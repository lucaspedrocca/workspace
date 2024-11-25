# Ejecuta el comando cscript con slmgr.vbs y captura su salida
$output = & cscript //Nologo "C:\Windows\System32\slmgr.vbs" /dlv

# Imprime el resultado en la consola
$output
