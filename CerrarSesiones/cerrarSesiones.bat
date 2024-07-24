@echo off
REM Mapea la ubicación de red a una unidad (En este caso Z)
net use Z: "\\PCA1195.prominente.com.ar\cerrarSesiones"

REM Cambia a la unidad mapeada
cd /d Z:

REM Ejecuta el script de Python
"\python\python.exe" "app.py"

REM Desconecta la unidad mapeada
net use Z: /delete

pause
