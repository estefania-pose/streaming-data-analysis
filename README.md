# 🎬 Proyecto End-to-End: Análisis de Datos de Plataforma de Streaming

Este repositorio contiene un proyecto completo de **Análisis de Datos** (ETL, Modelado, Consultas y Visualización) sobre el ecosistema de una plataforma de streaming. El objetivo principal es transformar datos crudos sobre usuarios, contenido, suscripciones, pagos y visualizaciones para extraer insights clave sobre el negocio.

---

## 🛠️ Tecnologías Utilizadas

* **Python (Pandas & NumPy):** Exploración, limpieza y transformación de datos (ETL).
* **SQL:** Consultas analíticas, agregaciones y estructuración de bases de datos relacionales.
* **Power BI:** Diseños de tableros interactivos, métricas clave (DAX) y visualización de datos.
* **Git & GitHub:** Control de versiones y documentación.

---

## 🔄 Flujo del Proyecto y Estructura

┌─────────────────┐       ┌─────────────────┐       ┌─────────────────┐       ┌─────────────────┐
│  Datos Crudos   │ ────> │  ETL en Python  │ ────> │ Consultas SQL   │ ────> │ Reporte PowerBI │
│   (Archivos CSV)│       │  (Pandas)       │       │ (Base de Datos) │       │   (Dashboard)   │
└─────────────────┘       └─────────────────┘       └─────────────────┘       └─────────────────┘

---

## 📊 1. Proceso de Limpieza y Transformación (Python / Pandas)

Se procesaron y limpiaron los conjuntos de datos originales para resolver nulos, inconsistencias de formato y valores atípicos:

* **`visualizaciones.csv` ➔ `visualizaciones_limpio.csv`:**
  * Normalización de la columna `fecha` al tipo `datetime`.
  * Estandarización de campos de texto (`dispositivo` a `'PC'`, `'Smart TV'`; `completado` a `'Sí'`, `'No'`).
  * Tratamiento de valores faltantes y acotamiento de outliers en `minutos_vistos` (`clip` entre 0 y 300 min).
* **`suscripciones.csv` ➔ `suscripciones_limpio.csv`:**
  * Conversión de fechas de inicio y fin de membresía.
  * Imputación de motivos de baja faltantes (`'Motivo no informado'`).
* **`resenas.csv` ➔ `resenas_limpio.csv`:**
  * Ajuste y validación de puntuaciones de 1 a 5 estrellas.
* **`pagos.csv` ➔ `pagos_limpio.csv`:**
  * Limpieza de caracteres monetarios (`$`, `,`) y conversión de montos a valores numéricos (`float`).
  * Imputación de pagos nulos mediante la mediana por tipo de suscripción.
* **`planes.csv` y `contenido.csv`:**
  * Validaciones de integridad, géneros y rangos de lanzamiento.

---

## 🗄️ 2. Análisis y Consultas (SQL)

Con los datos procesados, se ejecutaron scripts en **SQL** (`.sql`) para modelar la información y responder preguntas de negocio clave, tales como:
* Cálculo de ingresos totales por tipo de plan de suscripción.
* Tasa de retención y análisis de cancelaciones (*Churn Rate*).
* Títulos y géneros más populares según horas reproducidas y valoraciones.
* Comportamiento del usuario por dispositivo utilizado.

---

## 📈 3. Dashboard Interactivo (Power BI)

El entregable final consta de un reporte visual desarrollado en **Power BI** (`.pbix`) que permite interactuar con los datos clave:

* **Métricas Principales (KPIs):** Total de ingresos, usuarios activos, total de horas vistas y calificación promedio.
* **Análisis de Suscripciones:** Distribución de planes activos vs. cancelados.
* **Consumo de Contenido:** Top de series/películas más vistas y desglose por categoría.
* **Filtros Interactivos:** Por rango de fechas, dispositivo, país o tipo de plan.

> 💡 *Nota: Para visualizar el reporte podés abrir el archivo `.pbix` en Power BI Desktop o consultar las capturas/PDF adjuntos en el repositorio.*

---

## 📂 Archivos del Repositorio

* `*.ipynb` / `*.py`: Notebooks/scripts de Python con el proceso de limpieza ETL.
* `*_limpio.csv`: Datasets transformados listos para análisis.
* `*.sql`: Consultas SQL de estructuración y análisis de datos.
* `*.pbix`: Archivo de Power BI con el Dashboard interactivo.

  ## Power BI Dashboard
 <img width="709" height="301" alt="powerbi" src="https://github.com/user-attachments/assets/201f425f-7d7e-4a58-bc24-04a03bf93bbc" />

