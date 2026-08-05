# 🧹 Documentación de Limpieza de Datos (ETL)

Este repositorio contiene el proceso de **Exploración, Limpieza y Transformación (ETL)** realizado sobre los conjuntos de datos en formato CSV de la plataforma, utilizando **Python** y la librería **Pandas**.

---

## 📋 Resumen de Transformaciones

A continuación se detallan los tratamientos de datos, imputaciones y correcciones aplicados en cada uno de los archivos:

### 📺 `visualizaciones.csv` ➔ `visualizaciones_limpio.csv`
* **Formato de Fechas:** Normalización de la columna `fecha` al tipo `datetime64` (`format='mixed'`).
* **Estandarización de Texto:**
  * `dispositivo`: Unificación de variantes de texto (ej. `'pc'` y `'smart tv'`) a sus formatos capitalizados (`'PC'`, `'Smart TV'`).
  * `completado`: Eliminación de espacios (`str.strip()`) y capitalización (`str.title()`) para solucionar discrepancias entre mayúsculas y minúsculas (`'si'`, `'no'`).
* **Tratamiento de Nulos:** Imputación de valores faltantes en `completado` con el valor `'No especificado'`.
* **Outliers y Errores:** Aplicación de `clip(lower=0, upper=300)` sobre `minutos_vistos` para corregir números negativos y acotar valores atípicos superiores a 300 minutos.

---

### 💳 `suscripciones.csv` ➔ `suscripciones_limpio.csv`
* **Formato de Fechas:** Conversión de `fecha_inicio` y `fecha_fin` al tipo de dato `datetime64`.
* **Estandarización de Texto:** Limpieza de espacios y normalización de minúsculas en `metodo_pago` con `str.strip().str.title()`.
* **Tratamiento de Nulos:** Imputación de registros faltantes en `motivo_baja` completando con `'Motivo no informado'` exclusivamente en filas que poseían una `fecha_fin` válida.

---

### ⭐ `resenas.csv` ➔ `resenas_limpio.csv`
* **Formato de Fechas:** Conversión de la columna `fecha` a `datetime64`.
* **Corrección de Rangos:** Ajuste de puntajes fuera de la escala permitida (valores como `-1` o `6`) mediante `clip(lower=1, upper=5)` para encuadrar las valoraciones del 1 al 5.

---

### 💵 `pagos.csv` ➔ `pagos_limpio.csv`
* **Limpieza y Conversión de Tipos:**
  * Remoción de símbolos monetarios y comas (`$`, `,`) en la columna `monto` mediante expresiones regulares y posterior conversión a tipo flotante (`float`).
  * Parsing de la columna `fecha_pago` a tipo `datetime64`.
* **Tratamiento de Nulos:**
  * Imputación de montos nulos utilizando la mediana agrupada por `suscripcion_id`.
  * Eliminación de las filas remanentes con valores nulos que no pudieron ser imputadas a través de la mediana del grupo.

---

### 🎬 `planes.csv` y `contenido.csv`
* **Validación de Integridad:** Confirmación de ausencia de filas duplicadas y revisión de coherencia en variables categóricas (`tipo`, `genero`, `rating_edad`) y rangos numéricos (`anio_lanzamiento`). Generación de sus correspondientes versiones limpias (`planes_limpio.csv` y `contenido_limpio.csv`).

---

## 🛠️ Tecnologías y Librerías

* **Lenguaje:** Python 3.x
* **Librerías:**
  * `pandas`: Manipulación y transformación de DataFrames.
  * `numpy`: Operaciones numéricas y manejo de estructuras vectorizadas.

---

## 📂 Archivos Generados

Los archivos exportados resultantes del proceso (guardados sin el índice por defecto de Pandas) son:

* `visualizaciones_limpio.csv`
* `suscripciones_limpio.csv`
* `resenas_limpio.csv`
* `pagos_limpio.csv`
* `planes_limpio.csv`
* `contenido_limpio.csv`
