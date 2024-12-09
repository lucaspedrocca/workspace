# Instalar el módulo ThreadJob si no está disponible
if (-not (Get-Module -ListAvailable -Name ThreadJob)) {
    Install-Module -Name ThreadJob -Scope CurrentUser -Force
}

Import-Module ThreadJob

# Iniciar el temporizador
$stopwatch = [System.Diagnostics.Stopwatch]::StartNew()

# Pedir al usuario que introduzca el dominio
$dominio = Read-Host "Por favor, introduce el dominio"
Write-Host "El dominio que has introducido es: $dominio"

# Obtener todos los controladores de dominio del dominio especificado
$domainControllers = Get-ADDomainController -Filter * -Server $dominio

# Pedir las credenciales solo una vez
$credenciales = Get-Credential

# Comando remoto que se ejecutará en cada controlador de dominio
$remoteCommand = {
    wevtutil qe Security /rd:true /c:15000 /f:text /q:"*[System[(EventID=4740 or EventID=4625 or EventID=4771 or EventID=4776)]]"
}

# Crear una lista para almacenar trabajos
$jobs = @()

# Crear un trabajo para cada controlador de dominio
foreach ($dc in $domainControllers) {
    Write-Host "Creando trabajo para obtener eventos de $($dc.HostName)..."
    $jobs += Start-ThreadJob -ScriptBlock {
        param ($hostName, $scriptBlock, $cred)
        Invoke-Command -ComputerName $hostName -ScriptBlock $scriptBlock -Credential $cred
    } -ArgumentList $dc.HostName, $remoteCommand, $credenciales
}

# Esperar a que terminen todos los trabajos
Write-Host "Esperando a que los trabajos terminen..."
$jobs | Wait-Job

# Obtener los resultados de todos los trabajos
$allEvents = $jobs | Receive-Job

# Eliminar los trabajos
$jobs | Remove-Job

# Determinar la ruta del archivo basado en la ubicación del script
$currentDate = Get-Date
$formattedDate = $currentDate.ToString("yyyy-MM-dd_HH-mm")

# Obtiene la ruta de la carpeta de Documentos del usuario
$documentsPath = [environment]::GetFolderPath('MyDocuments')

# Crea la ruta para la carpeta "logs bloqueos"
$logsPath = Join-Path -Path $documentsPath -ChildPath "Logs bloqueos"

# Asegurarse de que la carpeta exista
if (-not (Test-Path $logsPath)) {
    New-Item -Path $logsPath -ItemType Directory | Out-Null
}

# Crea la ruta completa con el archivo
$filePath = Join-Path -Path $logsPath -ChildPath "$formattedDate-SecurityEventsPromi.txt"

# Guardar todos los eventos en el archivo
$allEvents | Out-File -FilePath $filePath

# Confirmar si se escribió el archivo correctamente
if (Test-Path $filePath) {
    Write-Host "Los eventos se escribieron en $filePath"
} else {
    Write-Host "Fallo al escribir los eventos"
}

# Finalizar el temporizador
$stopwatch.Stop()
Write-Host "Tiempo transcurrido: $($stopwatch.Elapsed.TotalSeconds) segundos"
