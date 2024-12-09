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

# Crear una lista para almacenar los resultados de cada controlador de dominio
$allEvents = @()

# Iterar sobre cada controlador de dominio y ejecutar el comando remoto
foreach ($dc in $domainControllers) {
    Write-Host "Obteniendo eventos de $($dc.HostName)..."
    $events = Invoke-Command -ComputerName $dc.HostName -ScriptBlock $remoteCommand -Credential $credenciales
    $allEvents += $events
}

# Determinar la ruta del archivo basado en la ubicación del script
$currentDate = Get-Date
$formattedDate = $currentDate.ToString("yyyy-MM-dd_HH-mm")


# Obtiene la ruta de la carpeta de Documentos del usuario
$documentsPath = [environment]::GetFolderPath('MyDocuments')

# Crea la ruta para la carpeta "logs bloqueos"
$logsPath = Join-Path -Path $documentsPath -ChildPath "Logs bloqueos"

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

# Mostrar el tiempo transcurrido
Write-Host "Tiempo transcurrido: $($stopwatch.Elapsed.TotalSeconds) segundos"
