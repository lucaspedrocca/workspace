Clear-Host

$dominio = Read-Host "Por favor, introduce un valor:"
Write-Host "El valor que has introducido es: $dominio"

$domainController = Get-ADDomainController -Filter * -Server $dominio

# Obtener la fecha y hora actual en el formato deseado
$currentDate = Get-Date
$formattedDate = $currentDate.ToString("yyyyMMddHHmm")

# Definir la ruta del archivo de salida con la fecha y hora en el nombre del archivo
$DefaultFolder = [Environment]::GetFolderPath("MyDocuments")
$Destination = "$formattedDate-4625-4771-4776.txt"
$filePath = $DefaultFolder + "\" + $Destination

Invoke-Command -ComputerName $domainController -ScriptBlock {
     wevtutil qe Security /rd:true /c:1000 /f:text /q:"*[System[(EventID=4625) or (EventID=4771) or (EventID=4776)]]"
 } -Credential (Get-Credential) | Out-File -FilePath  $filePath

 Invoke-Item -Path $filePath