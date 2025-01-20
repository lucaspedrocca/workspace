# README: LogOFF

## Índice

- Introducción
- Uso
- Estructura del Programa
- Funcionalidades

## Introducción

`logOFF` es una aplicación diseñada para facilitar la gestión y consulta de sesiones de usuario en servidores a través de una interfaz de línea de comandos. El programa permite consultar sesiones activas en servidores listados en un archivo JSON y realizar operaciones como cerrar sesiones de usuario.

## Uso

1. Coloque `logOFF.exe` y `hostnames.json` en el mismo directorio.
2. Ejecute `logOFF.exe` para iniciar la aplicación.
3. Seleccione una opción del menú y siga las instrucciones en pantalla para realizar consultas y gestionar servidores.

## Estructura del programa

El programa esta constituido principalmente de dos archivos:

1. **`logOFF.exe`**: El ejecutable principal del programa.
2. **`hostnames.json`**: Archivo de datos que contiene la lista de servidores agrupados por empresa. Este archivo debe estar en el mismo directorio que `logOFF.exe` para que el programa funcione correctamente.

Este archivo consta de una estructura especifica, en caso de ser reemplazado por favor respetar nombre completo y la siguiente estructura:

```json
{
    "EMPRESA1": [
        "servidor1.dominio.com",
        "servidor2.dominio.com"
    ],
    "EMPRESA2": [
        "servidor3.dominio.com",
        "servidor4.dominio.com"
    ]
}
```

### Actualización de Datos

Para actualizar la base de datos de servidores:

1. Modifique el archivo `hostnames.json` .
2. No es necesario recompilar el ejecutable. Los cambios en `hostnames.json` serán reflejados en la próxima ejecución del programa.

### Operaciones en Servidores

El programa utiliza comandos de PowerShell para consultar y gestionar sesiones en los servidores, incluyendo:

- **Consultar Sesiones**: `query session /server:{servidor} | findstr /i "{usuario}"`
  *Ejemplo: `query session /server:servidor3.dominio.com | findstr /i "usuario"`*
- **Cerrar Sesiones**: `reset session {id_sesion_encontrada} /server:{servidor}`
  *Ejemplo: `reset session 2 /server:servidor3.dominio.com`*

## Funcionalidades

El programa ofrece un menú de opciones para el usuario, incluyendo:

- **Consultar Servidores de una Empresa**: Permite consultar sesiones de usuario en servidores de una empresa seleccionada.(Actualmente desde el 1 hasta el 6)
- **Consulta Amplia**: Activa o desactiva la opción de consulta detallada en ser necesario.
- **Editar Servidores**:
- **Añadir Servidor**: Permite añadir un nuevo servidor a una empresa.
- **Eliminar Servidor**: Permite eliminar un servidor existente de una empresa.
- **Consultar `hostnames.json`**: Muestra el contenido del archivo `hostnames.json`.
