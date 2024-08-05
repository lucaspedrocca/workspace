# Definir los servidores en los que se realizará el escaneo
$serversFile = "servers.txt"

$servers = Get-Content -Path $serversFile

$cred = Get-Credential

foreach ($server in $servers) {
    Invoke-Command -ComputerName $server -Credential $cred -ScriptBlock {
        Start-MpScan -ScanType FullScan
    }
}
