# Apaga System State en disco C:
Remove-Item -Path "C:\*.bkf" -Force -ErrorAction SilentlyContinue

# Limpia temporales en perfiles de usuario
Get-ChildItem -Path "$env:SystemDrive\Users" -Directory | ForEach-Object {
    Remove-Item -Path "$($_.FullName)\AppData\Local\Temp\*" -Force -Recurse -ErrorAction SilentlyContinue
    Remove-Item -Path "$($_.FullName)\AppData\Local\Microsoft\Windows\Temporary Internet Files\*" -Force -Recurse -ErrorAction SilentlyContinue
    Remove-Item -Path "$($_.FullName)\AppData\Local\Microsoft\Windows\Explorer\thumbcache*.db" -Force -Recurse -ErrorAction SilentlyContinue
    Remove-Item -Path "$($_.FullName)\AppData\Local\Microsoft\Terminal Server Client\Cache\*" -Force -Recurse -ErrorAction SilentlyContinue
}

# Limpia archivos de desinstalación de parches más de 30 días
Get-ChildItem -Path "$env:windir" -Filter '$NtServicePackUninstall*' | Where-Object { $_.LastWriteTime -lt (Get-Date).AddDays(-31) } | Remove-Item -Recurse -Force
Get-ChildItem -Path "$env:windir" -Filter '$NtUninstall*' | Where-Object { $_.LastWriteTime -lt (Get-Date).AddDays(-31) } | Remove-Item -Recurse -Force

# Limpia temporales generales
Remove-Item -Path "$env:SystemDrive\temp\*" -Force -Recurse -ErrorAction SilentlyContinue
Remove-Item -Path "$env:windir\ccmcache\*" -Force -Recurse -ErrorAction SilentlyContinue
Remove-Item -Path "$env:windir\ccmsetup\*" -Force -Recurse -ErrorAction SilentlyContinue
Remove-Item -Path "$env:windir\temp\*" -Force -Recurse -ErrorAction SilentlyContinue
Remove-Item -Path "$env:SystemDrive\PUBLIC\TEMP\*" -Force -Recurse -ErrorAction SilentlyContinue

# Limpia eventos de más de 30 días
Get-ChildItem -Path "$env:windir\PCHealth\ERRORREP\UserDumps" -Recurse | Where-Object { $_.LastWriteTime -lt (Get-Date).AddDays(-30) } | Remove-Item -Force
Get-ChildItem -Path "$env:windir\PCHealth\ERRORREP\QSIGNOFF" -Recurse | Where-Object { $_.LastWriteTime -lt (Get-Date).AddDays(-30) } | Remove-Item -Force
Get-ChildItem -Path "$env:ProgramData\Microsoft\Windows\WER\ReportQueue" -Recurse | Where-Object { $_.LastWriteTime -lt (Get-Date).AddDays(-30) } | Remove-Item -Force
Remove-Item -Path "$env:windir\system32\drivers\fidbox.dat" -Force -ErrorAction SilentlyContinue
Remove-Item -Path "$env:windir\system32\drivers\fidbox.idx" -Force -ErrorAction SilentlyContinue
Remove-Item -Path "$env:windir\MEMORY.DMP" -Force -ErrorAction SilentlyContinue

# Recrea carpetas de Windows Update
Stop-Service -Name wuauserv
Remove-Item -Path "$env:windir\SoftwareDistribution" -Recurse -Force
Start-Service -Name wuauserv

# Remueve logs de 180 días y compacta más viejos de 30 días
Get-ChildItem -Path "$env:windir\system32\LogFiles" -Recurse -Filter *.log | Where-Object { $_.LastWriteTime -lt (Get-Date).AddDays(-180) } | Remove-Item -Force
Get-ChildItem -Path "$env:windir\system32\LogFiles" -Recurse -Filter *.log | Where-Object { $_.LastWriteTime -lt (Get-Date).AddDays(-30) } | ForEach-Object { Compact-Archive -Path $_.FullName -CompressionLevel Optimal }

# Compacta logs de IIS en inetpub\logs\LogFiles
Get-ChildItem -Path "$env:SystemDrive\inetpub\logs\LogFiles" -Recurse -Filter *.log | Where-Object { $_.LastWriteTime -lt (Get-Date).AddDays(-30) } | ForEach-Object { Compact-Archive -Path $_.FullName -CompressionLevel Optimal }

# Compacta definiciones de virus de Symantec
Get-ChildItem -Path "$env:ProgramFiles\Common Files\Symantec Shared\VirusDefs" -Recurse | Where-Object { $_.LastWriteTime -lt (Get-Date).AddDays(-1) } | ForEach-Object { Compact-Archive -Path $_.FullName -CompressionLevel Optimal }
Get-ChildItem -Path "$env:SystemDrive\support" -Recurse | Where-Object { $_.LastWriteTime -lt (Get-Date).AddDays(-1) } | ForEach-Object { Compact-Archive -Path $_.FullName -CompressionLevel Optimal }
Get-ChildItem -Path "$env:SystemDrive\install" -Recurse | Where-Object { $_.LastWriteTime -lt (Get-Date).AddDays(-1) } | ForEach-Object { Compact-Archive -Path $_.FullName -CompressionLevel Optimal }

# Compacta fuentes de programas instalados
Compact-Archive -Path "$env:windir\installer\*.*" -CompressionLevel Optimal

# Muestra espacio libre en disco antes de la limpieza
$disk = Get-PSDrive -Name C
$SizeBeforeGB = [math]::Round($disk.Used/1GB, 2)
Write-Output "Espacio en disco antes: $($disk.Used/1GB) GB"

# Muestra espacio libre en disco después de la limpieza
$disk.Refresh()
$FreeSpaceGB = [math]::Round($disk.Free/1GB, 2)
$SizeGB = [math]::Round($disk.Used/1GB, 2)
$Percentage = [math]::Round((100 * $FreeSpaceGB / $SizeGB), 2)
Write-Output "Espacio en disco después: $SizeGB GB"
Write-Output "Espacio liberado: $Percentage %"
Write-Output "Espacio libre ahora: $FreeSpaceGB GB"
# Solicita el nombre del servidor
$server = Read-Host "Ingresa el nombre del servidor en el que deseas ejecutar el script"

# Define el bloque de script a ejecutar remotamente
$scriptBlock = {
    # Función para manejar errores de acceso denegado
    function Remove-ItemSafely {
        param (
            [string]$Path
        )
        try {
            Remove-Item -Path $Path -Force -Recurse -ErrorAction Stop
        } catch {
            Write-Output "No se pudo eliminar $Path : Acceso denegado"
        }
    }

    # Apaga System State en disco C:
    Remove-ItemSafely -Path "C:\*.bkf"

    # Limpia temporales en perfiles de usuario
    Get-ChildItem -Path "$env:SystemDrive\Users" -Directory | ForEach-Object {
        Remove-ItemSafely -Path "$($_.FullName)\AppData\Local\Temp\*"
        Remove-ItemSafely -Path "$($_.FullName)\AppData\Local\Microsoft\Windows\Temporary Internet Files\*"
        Remove-ItemSafely -Path "$($_.FullName)\AppData\Local\Microsoft\Windows\Explorer\thumbcache*.db"
        Remove-ItemSafely -Path "$($_.FullName)\AppData\Local\Microsoft\Terminal Server Client\Cache\*"
    }

    # Limpia archivos de desinstalación de parches más de 30 días
    Get-ChildItem -Path "$env:windir" -Filter '$NtServicePackUninstall*' | Where-Object { $_.LastWriteTime -lt (Get-Date).AddDays(-31) } | ForEach-Object {
        Remove-ItemSafely -Path $_.FullName
    }
    Get-ChildItem -Path "$env:windir" -Filter '$NtUninstall*' | Where-Object { $_.LastWriteTime -lt (Get-Date).AddDays(-31) } | ForEach-Object {
        Remove-ItemSafely -Path $_.FullName
    }

    # Limpia temporales generales
    Remove-ItemSafely -Path "$env:SystemDrive\temp\*"
    Remove-ItemSafely -Path "$env:windir\ccmcache\*"
    Remove-ItemSafely -Path "$env:windir\ccmsetup\*"
    Remove-ItemSafely -Path "$env:windir\temp\*"
    Remove-ItemSafely -Path "$env:SystemDrive\PUBLIC\TEMP\*"

    # Limpia eventos de más de 30 días
    Remove-ItemSafely -Path "$env:windir\PCHealth\ERRORREP\UserDumps\*"
    Remove-ItemSafely -Path "$env:windir\PCHealth\ERRORREP\QSIGNOFF\*"
    Remove-ItemSafely -Path "$env:ProgramData\Microsoft\Windows\WER\ReportQueue\*"
    Remove-ItemSafely -Path "$env:windir\system32\drivers\fidbox.dat"
    Remove-ItemSafely -Path "$env:windir\system32\drivers\fidbox.idx"
    Remove-ItemSafely -Path "$env:windir\MEMORY.DMP"

    # Recrea carpetas de Windows Update
    Stop-Service -Name wuauserv
    Remove-ItemSafely -Path "$env:windir\SoftwareDistribution"
    Start-Service -Name wuauserv

    # Remueve logs de 180 días y compacta más viejos de 30 días
    Get-ChildItem -Path "$env:windir\system32\LogFiles" -Recurse -Filter *.log | Where-Object { $_.LastWriteTime -lt (Get-Date).AddDays(-180) } | ForEach-Object {
        Remove-ItemSafely -Path $_.FullName
    }
    Get-ChildItem -Path "$env:windir\system32\LogFiles" -Recurse -Filter *.log | Where-Object { $_.LastWriteTime -lt (Get-Date).AddDays(-30) } | ForEach-Object {
        compact.exe /c $_.FullName
    }

    # Compacta logs de IIS en inetpub\logs\LogFiles
    Get-ChildItem -Path "$env:SystemDrive\inetpub\logs\LogFiles" -Recurse -Filter *.log | Where-Object { $_.LastWriteTime -lt (Get-Date).AddDays(-30) } | ForEach-Object {
        compact.exe /c $_.FullName
    }

    # Compacta definiciones de virus de Symantec
    Get-ChildItem -Path "$env:ProgramFiles\Common Files\Symantec Shared\VirusDefs" -Recurse | Where-Object { $_.LastWriteTime -lt (Get-Date).AddDays(-1) } | ForEach-Object {
        compact.exe /c $_.FullName
    }
    Get-ChildItem -Path "$env:SystemDrive\support" -Recurse | Where-Object { $_.LastWriteTime -lt (Get-Date).AddDays(-1) } | ForEach-Object {
        compact.exe /c $_.FullName
    }
    Get-ChildItem -Path "$env:SystemDrive\install" -Recurse | Where-Object { $_.LastWriteTime -lt (Get-Date).AddDays(-1) } | ForEach-Object {
        compact.exe /c $_.FullName
    }

    # Compacta fuentes de programas instalados
    compact.exe /c "$env:windir\installer\*.*"

    # Muestra espacio libre en disco antes de la limpieza
    $disk = Get-PSDrive -Name C
    $SizeBeforeGB = [math]::Round($disk.Used/1GB, 2)
    Write-Output "Espacio en disco antes: $SizeBeforeGB GB"

    # Muestra espacio libre en disco después de la limpieza
    $disk.Refresh()
    $FreeSpaceGB = [math]::Round($disk.Free/1GB, 2)
    $SizeGB = [math]::Round($disk.Used/1GB, 2)
    $Percentage = [math]::Round((100 * $FreeSpaceGB / $SizeGB), 2)
    Write-Output "Espacio en disco después: $SizeGB GB"
    Write-Output "Espacio liberado: $Percentage %"
    Write-Output "Espacio libre ahora: $FreeSpaceGB GB"
}

# Ejecuta el script en el servidor especificado
Invoke-Command -ComputerName $server -ScriptBlock $scriptBlock -Credential (Get-Credential)
