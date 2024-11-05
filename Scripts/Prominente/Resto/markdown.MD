```mermaid
flowchart TD
    A[Detección del Incidente] --> B{Monitoreo y Alertas?}
    B --> C1[Servidores]
    B --> C2[Webs]
    B --> C3[Aplicaciones]
    B --> C4[Networking]
    A --> D[Reporte de usuarios y clientes]
    A --> E[Comunicación telefónica o por correo]

    F[Clasificación del Incidente] --> G{Identificación del tipo de incidente?}
    G --> H1[Alta]
    G --> H2[Media]
    F --> I[Breve detalle de lo identificado]
    F --> J[Identificación de componentes afectados]
    J --> J1[Enlace]
    J --> J2[Servidor]
    J --> J3[Servicio]
    J --> J4[Aplicación]
    J --> J5[Correo]
    J --> J6[Base de Datos]
    J --> J7[Telefonía]

 ```