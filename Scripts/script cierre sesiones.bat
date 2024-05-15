@echo off
setlocal enabledelayedexpansion

REM Verificar derechos de administrador
>nul 2>&1 net session || (
    echo Este script requiere derechos de administrador. Ejecutalo como administrador.
    pause
    goto :eof
)

REM Solicitar el dominio al usuario
set /p "dominio=Introduce el dominio en el que deseas cerrar sesion (brh, cliba, metrovias, emv, haug): "

REM Validar el dominio ingresado
set "dominios=brh cliba metrovias emv haug"
echo %dominios% | find /i "%dominio%" >nul
if errorlevel 1 (
    echo Dominio no valido. Elige entre brh, cliba, metrovias, emv, haug.
    pause
    goto :eof
)

REM Lista de servidores remotos (nombres de servidores)
set "servidores="
if "%dominio%"=="brh" set "servidores=brhts100.usuarios.local brhts101.usuarios.local brhts05.usuarios.local brhts06.usuarios.local"
if "%dominio%"=="cliba" set "servidores=clibats100.cliba.com.ar clibats101.cliba.com.ar clibats102.cliba.com.ar"
if "%dominio%"=="emv" set "servidores=emvts01.emv.com.ar emvts02.emv.com.ar emvts03.emv.com.ar emvtserp01 emvtserp02"
if "%dominio%"=="haug" set "servidores=haugts100.haug.local haugts101.haug.local haugts102.haug.local"
if "%dominio%"=="metrovias" set "servidores=mtvts01.metrovias.com.ar mtvts02.metrovias.com.ar mtvts03.metrovias.com.ar mtvts100.metrovias.com.ar mtvts101.metrovias.com.ar mtvts102.metrovias.com.ar mtvts103.metrovias.com.ar"
REM Solicitar el nombre de usuario al usuario
set /p "nombreUsuario=Introduce el nombre de usuario que deseas cerrar sesion en el dominio %dominio%: "

REM Loop a traves de los servidores remotos
for %%i in (%servidores%) do (
    REM Obtener informacion de sesion para el usuario
    for /f "tokens=2" %%j in ('quser /server:%%i ^| findstr /C:"%nombreUsuario%"') do (
        REM Cerrar cada sesion encontrada para el usuario
        set "idSesion=%%j"
        logoff !idSesion! /server:%%i >nul 2>&1
        if !errorlevel! equ 0 (
            echo Sesion !idSesion! de %nombreUsuario% cerrada en %%i
        ) else (
            echo No se pudo cerrar la sesion !idSesion! de %nombreUsuario% en %%i
        )
    )

    if not defined idSesion (
        echo No se encontraron sesiones para %nombreUsuario% en %%i
    )
)

echo.
echo El proceso ha terminado. Presiona cualquier tecla para cerrar esta ventana.
pause >nul
endlocal
