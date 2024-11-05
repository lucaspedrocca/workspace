Por supuesto, aquí tienes el script con todas las modificaciones que hicimos:

```batch
@echo off
setlocal

echo ### Apaga System State en disco C:
cd\
del *.bkf

echo ### Limpia temporales en perfiles de usuario

for /d %%K in ("%HOMEDRIVE%\users\*") do (
    del /S /F /Q "%%~fK\AppData\Local\Temp\*.*"
    del /S /F /Q "%%~fK\AppData\Local\Microsoft\Windows\Temporary Internet Files\*.*"
    del /S /F /Q "%%~fK\AppData\Local\Microsoft\Windows\Explorer\thumbcache*.db"
    del /S /F /Q "%%~fK\AppData\Local\Microsoft\Terminal Server Client\Cache\*.*"
)

echo ### Limpia archivos de desinstalación de parches más de 30 días

forfiles /p %windir% /m $NtServicePackUninstall* /d -31 /c "cmd.exe /c rd /s /q @path"
forfiles /p %windir% /m $NtUninstall* /d -31 /c "cmd.exe /c rd /s /q @path"

echo ### Limpia temporales generales

del /S /F /Q %HOMEDRIVE%\temp\*.* 
del /S /F /Q %windir%\ccmcache\*.* 
del /S /F /Q %windir%\ccmsetup\*.* 
del /S /F /Q %windir%\temp\*.* 
del /S /F /Q %HOMEDRIVE%\PUBLIC\TEMP\*.* 

echo ### Limpia eventos de más de 30 días

forfiles /p %windir%\PCHealth\ERRORREP\UserDumps\ /s /m *.* /d -30 /c "cmd.exe /c del /F /Q @path"
forfiles /p %windir%\PCHealth\ERRORREP\QSIGNOFF\ /s /m *.* /d -30 /c "cmd.exe /c del /F /Q @path"
forfiles /p %HOMEDRIVE%\ProgramData\Microsoft\Windows\WER\ReportQueue\ /s /m *.* /d -30 /c "cmd.exe /c del /F /Q @path"
del %windir%\system32\drivers\fidbox.dat 
del %windir%\system32\drivers\fidbox.idx 
del %windir%\MEMORY.DMP

echo ### Recrea carpetas de Wu

net stop wuauserv 
rd /s /q %windir%\SoftwareDistribution
net start wuauserv

echo ### Remueve logs de 180 días e compacta más viejos de 30 días

forfiles /p %windir%\system32\LogFiles\ /s /m *.log /d -180 /c "cmd.exe /c del /F /Q @path"
forfiles /p %windir%\system32\LogFiles\ /s /m *.log /d -30 /c "cmd.exe /c compact /c  @path"

echo ### Compacta logs de IIS en %HOMEDRIVE%\inetpub\logs\LogFiles

forfiles /p %HOMEDRIVE%\inetpub\logs\LogFiles\ /s /m *.log /d -30 /c "cmd.exe /c compact /c  @path"

echo ### Compacta definiciones de virus de Symantec

forfiles /p "%HOMEDRIVE%\Program Files\Common Files\Symantec Shared\VirusDefs" /s /m *.* /d -1 /c "cmd.exe /c compact /c  @path"
forfiles /p "%HOMEDRIVE%\support" /s /m *.* /d -1 /c "cmd.exe /c compact /c  @path"
forfiles /p "%HOMEDRIVE%\install" /s /m *.* /d -1 /c "cmd.exe /c compact /c  @path"

echo ### Compacta fuentes de programas instalados

compact /c %windir%\installer\*.*

echo ### Muestra espacio libre en disco antes de la limpieza

for /f "usebackq delims== tokens=2" %%x in (`wmic logicaldisk where "DeviceID='C:'" get Size /format:value`) do set SizeBefore=%%x
set SizeBeforeGB=%SizeBefore:~0,-9%
echo Espacio en disco antes: %SizeBeforeGB% GB

echo ### Muestra espacio libre en disco después de la limpieza

for /f "usebackq delims== tokens=2" %%x in (`wmic logicaldisk where "DeviceID='C:'" get FreeSpace /format:value`) do set FreeSpace=%%x
for /f "usebackq delims== tokens=2" %%x in (`wmic logicaldisk where "DeviceID='C:'" get Size /format:value`) do set Size=%%x
set FreeMB=%FreeSpace:~0,-6%
set SizeMB=%Size:~0,-6%
set /a Percentage=100 * FreeMB / SizeMB
set FreeGB=%FreeSpace:~0,-9%
set SizeGB=%Size:~0,-9%
echo Espacio en disco después: %SizeGB% GB
echo Espacio liberado: %Percentage% ^%
echo Espacio libre ahora: %FreeGB% GB