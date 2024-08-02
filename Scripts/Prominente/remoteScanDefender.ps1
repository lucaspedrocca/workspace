# Definir los servidores en los que se realizará el escaneo
$servers = @(
    "BRHPECTRA03.USUARIOS.LOCAL",
    "MTVBL102.metrovias.com.ar",
    "MTVPROCSUBE.METROVIAS.COM.AR",
    "MTVRPT02.metrovias.com.ar",
    "MTVTSW100.metrovias.com.ar",
    "MTVRDP02.metrovias.com.ar",
    "mtvgt04.metrovias.com.ar",
    "MTVPECTRA01.metrovias.com.ar",
    "MTVTS102.metrovias.com.ar",
    "MTVTS101.metrovias.com.ar",
    "MTVRDP01.metrovias.com.ar",
    "MTVAPP05.metrovias.com.ar"
)

# Función para realizar el escaneo en un servidor remoto
function Start-WindowsDefenderScan {
    param (
        [string]$server
    )

    Invoke-Command -ComputerName $server -ScriptBlock {
        try {
            # Iniciar un escaneo rápido de Windows Defender
            Start-MpScan -ScanType QuickScan
            Write-Output "Scan started successfully on $env:COMPUTERNAME."
        } catch {
            Write-Output "Failed to start scan on $env:COMPUTERNAME. Error: $_"
        }
    }
}

# Ejecutar el escaneo en cada servidor
foreach ($server in $servers) {
    Start-WindowsDefenderScan -server $server
}
