# Pedir al usuario que introduzca una lista de servidores, separados por comas
$servidores = Read-Host "Por favor, introduce los nombres de los servidores, separados por comas"
$servidoresArray = $servidores -split ',' | ForEach-Object { $_.Trim() }

Write-Host "Los servidores que has introducido son: $($servidoresArray -join ', ')"

# Pedir las credenciales solo una vez
$credenciales = Get-Credential

# Comando remoto que se ejecutará en cada servidor
$remoteCommand = {
    wevtutil qe Security /rd:true /c:10000 /f:text /q:"*[System[(EventID=4740 or EventID=4625 or EventID=4771 or EventID=4776)]]"
}

# Crear una lista para almacenar los resultados de cada servidor
$allEvents = @()

# Iterar sobre cada servidor y ejecutar el comando remoto
foreach ($servidor in $servidoresArray) {
    Write-Host "Obteniendo eventos de $servidor..."
    try {
        $events = Invoke-Command -ComputerName $servidor -ScriptBlock $remoteCommand -Credential $credenciales
        $allEvents += $events
    } catch {
        Write-Host "No se pudo conectar con $servidor. Error: $_"
    }
}

# Determinar la ruta del archivo basado en la ubicación del script
$currentDate = Get-Date
$formattedDate = $currentDate.ToString("HH_mm-dd-MM-yyyy")

$filePath = Join-Path -Path $PSScriptRoot -ChildPath "$formattedDate-SecurityEventsPromi.txt"

# Guardar todos los eventos en el archivo
$allEvents | Out-File -FilePath $filePath

# Confirmar si se escribió el archivo correctamente
if (Test-Path $filePath) {
    Write-Host "Los eventos se escribieron en $filePath"
} else {
    Write-Host "Fallo al escribir los eventos"
}
