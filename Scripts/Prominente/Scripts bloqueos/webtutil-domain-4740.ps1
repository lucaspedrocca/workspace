Clear-Host

$dominio = Read-Host "Por favor, introduce el dominio"
Write-Host "El dominio que has introducido es: $dominio"

$domainController = Get-ADDomainController -DomainName $dominio -Discover

# Obtener la fecha y hora actual en el formato deseado
$currentDate = Get-Date
$formattedDate = $currentDate.ToString("yyyyMMddHHmm")

# Definir la ruta del archivo de salida con la fecha y hora en el nombre del archivo
$DefaultFolder = [Environment]::GetFolderPath("MyDocuments")
$Destination = "$formattedDate-4740.txt"
$filePath = $DefaultFolder + "\" + $Destination

Invoke-Command -ComputerName $domainController -ScriptBlock {
     wevtutil qe Security /rd:true /c:100 /f:text /q:"*[System[(EventID=4740)]]"
 } -Credential (Get-Credential) | Out-File -FilePath  $filePath

 Invoke-Item -Path $filePath