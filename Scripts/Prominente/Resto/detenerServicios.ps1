# Obtener todos los servicios que empiezan con "x"
$serviciosPectra = Get-Service -Name Pectra*

# Detener cada servicio encontrado
foreach ($servicio in $serviciosPectra) {
    Stop-Service -Name $servicio.Name -Force
}