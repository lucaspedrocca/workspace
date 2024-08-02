# 100 Casos, eventos 4740 (Bloqueos), 4625, 4771, 4776 (intentos fallidos) 

$remoteCommand = { 

    wevtutil qe Security /rd:true /c:1000 /f:text /q:"*[System[(EventID=4740 or EventID=4625 or EventID=4771 or EventID=4776)]]" 

} 

$events = Invoke-Command -ComputerName "clibaad03.cliba.com.ar" -ScriptBlock $remoteCommand -Credential (Get-Credential) 

$filePath = "C:\temp\SecurityEventsPromi.txt" 

$events | Out-File -FilePath $filePath 

# Confirmar 

if (Test-Path $filePath) { 

    "Los eventos se escribieron en $filePath" 

} else { 

    "Fallo al escribir los eventos" 

} 