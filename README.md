Descripción
Este proyecto implementa un flujo de datos completo para un escenario de retail, utilizando servicios de Azure y herramientas de análisis. El objetivo es cargar datos en un almacenamiento en la nube, procesarlos mediante Azure Data Factory (ADF), almacenarlos en Azure SQL Database y visualizarlos en Power BI.

Arquitectura
Azure Blob Storage: Almacenamiento de archivos fuente (CSV).
Azure Data Factory: Orquestación de pipelines para ingesta y transformación.
Azure SQL Database: Base de datos relacional para datos procesados.
Log Analytics: Monitorización y trazabilidad.
Power BI: Visualización de datos.
Pasos Realizados
Creación de recursos en Azure:

Grupo de recursos.
Cuenta de almacenamiento (Blob).
Azure Data Factory.
Azure SQL Database.
Workspace de Log Analytics.
Carga de datos en Blob Storage:

Subida de archivos CSV al contenedor raw.
Configuración en Azure Data Factory:

Creación de linked services (Blob y SQL).
Creación de datasets para origen y destino.
Pipeline de copia (Blob → SQL).
Prueba y ejecución del pipeline.
Transformación en SQL:

Creación de tablas en Azure SQL Database.
Limpieza y normalización de datos.
Monitorización:

Configuración de integración con Log Analytics.
Validación de logs y métricas.
Visualización en Power BI:

Conexión a Azure SQL Database.
Creación de dashboard básico.
Tecnologías y Herramientas
Azure Portal
Visual Studio Code
GitHub (para control de versiones)
Power BI Desktop
