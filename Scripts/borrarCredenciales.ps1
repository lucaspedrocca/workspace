# Eliminar todas las credenciales de Windows
$credentials = cmdkey /list
$credentials | ForEach-Object {
    if ($_ -match 'Target: (.*)') {
        $target = $matches[1]
        cmdkey /delete:$target
    }
}

# Confirmación de eliminación
Write-Output "Todas las credenciales de Windows han sido eliminadas."
