
-- % de suscripciones finalizadas sobre el total, por plan. --
SELECT
    pl.nombre_plan,
    COUNT(*) AS total_suscripciones,
    SUM(CASE WHEN s.fecha_fin IS NOT NULL THEN 1 ELSE 0 END) AS bajas,
    ROUND(SUM(CASE WHEN s.fecha_fin IS NOT NULL THEN 1 ELSE 0 END) / COUNT(*) * 100, 2) AS tasa_churn
FROM suscripciones s
JOIN planes pl ON s.plan_id = pl.plan_id
GROUP BY pl.nombre_plan
ORDER BY tasa_churn DESC;

-- % de suscripciones finalizadas sobre el total, por país del usuario. --
SELECT
    u.pais,
    COUNT(*) AS total_suscripciones,
    SUM(CASE WHEN s.fecha_fin IS NOT NULL THEN 1 ELSE 0 END) AS bajas,
    ROUND(SUM(CASE WHEN s.fecha_fin IS NOT NULL THEN 1 ELSE 0 END) / COUNT(*) * 100, 2) AS tasa_churn
FROM suscripciones s
JOIN usuarios u ON s.user_id = u.user_id
GROUP BY u.pais
ORDER BY tasa_churn DESC;

-- cantidad de bajas por motivo, desglosado por plan --
SELECT
    pl.nombre_plan,
    s.motivo_baja,
    COUNT(*) AS cantidad
FROM suscripciones s
JOIN planes pl ON s.plan_id = pl.plan_id
WHERE s.motivo_baja IS NOT NULL
GROUP BY pl.nombre_plan, s.motivo_baja
ORDER BY pl.nombre_plan, cantidad DESC;


-- cantidad de bajas por motivo, desglosado por país. --
SELECT
    u.pais,
    s.motivo_baja,
    COUNT(*) AS cantidad
FROM suscripciones s
JOIN usuarios u ON s.user_id = u.user_id
WHERE s.motivo_baja IS NOT NULL
GROUP BY u.pais, s.motivo_baja
ORDER BY u.pais, cantidad DESC;

-- ingreso total generado por plan (suma de pagos exitosos). --
SELECT
    pl.nombre_plan,
    COUNT(pa.pago_id) AS cantidad_pagos,
    SUM(pa.monto) AS ingreso_total,
    ROUND(AVG(pa.monto), 2) AS ticket_promedio
FROM pagos pa
JOIN suscripciones s ON pa.suscripcion_id = s.suscripcion_id
JOIN planes pl ON s.plan_id = pl.plan_id
WHERE pa.estado = 'Exitoso'
GROUP BY pl.nombre_plan
ORDER BY ingreso_total DESC;

select pl.nombre_plan, sum(p.monto) as total_por_plan
from planes pl 
join suscripciones s on s.plan_id = pl.plan_id
join pagos p on p.suscripcion_id = s.suscripcion_id
group by pl.nombre_plan
order by total_por_plan desc;

-- total de usuarios por país, y evolución de altas nuevas por año (2023-2025, años completos). --
SELECT pais, COUNT(*) AS total_usuarios
FROM usuarios
GROUP BY pais
ORDER BY total_usuarios DESC;

-- Usuarios nuevos por país y año --
SELECT pais, YEAR(fecha_registro) AS anio, COUNT(*) AS usuarios_nuevos
FROM usuarios
GROUP BY pais, YEAR(fecha_registro)
ORDER BY pais, anio;

-- cantidad de visualizaciones por género de contenido, segmentado por rango de edad del usuario --
SELECT
    CASE
        WHEN u.edad < 18 THEN 'Menor de 18'
        WHEN u.edad BETWEEN 18 AND 25 THEN '18-25'
        WHEN u.edad BETWEEN 26 AND 35 THEN '26-35'
        WHEN u.edad BETWEEN 36 AND 50 THEN '36-50'
        ELSE 'Más de 50'
    END AS rango_edad,
    c.genero,
    COUNT(*) AS cantidad_visualizaciones
FROM visualizaciones v
JOIN usuarios u ON v.user_id = u.user_id
JOIN contenido c ON v.contenido_id = c.contenido_id
GROUP BY rango_edad, c.genero
ORDER BY rango_edad, cantidad_visualizaciones DESC;

-- : cantidad de suscripciones por plan, segmentado por rango de edad del usuario. --
SELECT
    CASE
        WHEN u.edad < 18 THEN 'Menor de 18'
        WHEN u.edad BETWEEN 18 AND 25 THEN '18-25'
        WHEN u.edad BETWEEN 26 AND 35 THEN '26-35'
        WHEN u.edad BETWEEN 36 AND 50 THEN '36-50'
        ELSE 'Más de 50'
    END AS rango_edad,
    pl.nombre_plan,
    COUNT(*) AS cantidad_suscripciones
FROM suscripciones s
JOIN usuarios u ON s.user_id = u.user_id
JOIN planes pl ON s.plan_id = pl.plan_id
GROUP BY rango_edad, pl.nombre_plan
ORDER BY rango_edad, cantidad_suscripciones DESC;

-- cantidad de visualizaciones por tipo de contenido, segmentado por rango de edad. --
SELECT
    CASE
        WHEN u.edad < 18 THEN 'Menor de 18'
        WHEN u.edad BETWEEN 18 AND 25 THEN '18-25'
        WHEN u.edad BETWEEN 26 AND 35 THEN '26-35'
        WHEN u.edad BETWEEN 36 AND 50 THEN '36-50'
        ELSE 'Más de 50'
    END AS rango_edad,
    c.tipo AS tipo_de_contenido,
    COUNT(*) AS cantidad_visualizaciones
FROM contenido c
JOIN visualizaciones v ON v.contenido_id = c.contenido_id
JOIN usuarios u ON u.user_id = v.user_id
GROUP BY rango_edad, tipo_de_contenido
ORDER BY rango_edad, cantidad_visualizaciones DESC;

-- ingreso total acumulado, y evolución mensual/anual por país. --
SELECT SUM(monto) AS ingreso_total
FROM pagos
WHERE estado = 'Exitoso';

-- Ingreso mensual por país --
SELECT
    u.pais,
    DATE_FORMAT(pa.fecha_pago, '%Y-%m') AS mes,
    SUM(pa.monto) AS ingreso_mensual
FROM pagos pa
JOIN suscripciones s ON pa.suscripcion_id = s.suscripcion_id
JOIN usuarios u ON s.user_id = u.user_id
WHERE pa.estado = 'Exitoso'
GROUP BY u.pais, mes
ORDER BY u.pais, mes;

-- distribución de usuarios por rango etario. --
SELECT
    CASE
        WHEN edad < 18 THEN 'Menor de 18'
        WHEN edad BETWEEN 18 AND 25 THEN '18-25'
        WHEN edad BETWEEN 26 AND 35 THEN '26-35'
        WHEN edad BETWEEN 36 AND 50 THEN '36-50'
        ELSE 'Más de 50'
    END AS rango_edad,
    COUNT(*) AS cantidad_usuarios
FROM usuarios
GROUP BY rango_edad
ORDER BY cantidad_usuarios DESC;

-- cantidad de días/meses promedio entre fecha_inicio y fecha_fin, solo para suscripciones ya finalizadas --
SELECT
    pl.nombre_plan,
    ROUND(AVG(DATEDIFF(s.fecha_fin, s.fecha_inicio)), 0) AS duracion_promedio_dias
FROM suscripciones s
JOIN planes pl ON s.plan_id = pl.plan_id
WHERE s.fecha_fin IS NOT NULL
GROUP BY pl.nombre_plan
ORDER BY duracion_promedio_dias DESC;

-- cantidad de visualizaciones por género de contenido --
SELECT
    c.tipo,
    c.genero,
    COUNT(*) AS cantidad_visualizaciones
FROM visualizaciones v
JOIN contenido c ON v.contenido_id = c.contenido_id
GROUP BY c.tipo, c.genero
ORDER BY c.tipo, cantidad_visualizaciones DESC;

-- : cantidad de visualizaciones por dispositivo, y cuántas se completan según el dispositivo. --
SELECT
    dispositivo,
    COUNT(*) AS cantidad_visualizaciones,
    SUM(CASE WHEN completado = 'Si' THEN 1 ELSE 0 END) AS completadas,
    ROUND(SUM(CASE WHEN completado = 'Si' THEN 1 ELSE 0 END) / COUNT(*) * 100, 2) AS pct_completado
FROM visualizaciones
GROUP BY dispositivo
ORDER BY cantidad_visualizaciones DESC;

-- % de visualizaciones con minutos_vistos bajo (ej. menor a 10 minutos) y completado = No. --
SELECT
    COUNT(*) AS total_visualizaciones,
    SUM(CASE WHEN minutos_vistos < 10 AND completado = 'No' THEN 1 ELSE 0 END) AS abandono_temprano,
    ROUND(SUM(CASE WHEN minutos_vistos < 10 AND completado = 'No' THEN 1 ELSE 0 END) / COUNT(*) * 100, 2) AS pct_abandono
FROM visualizaciones;

-- cantidad de suscripciones por método de pago, y su relación con el churn. --
SELECT
    metodo_pago,
    COUNT(*) AS total_suscripciones,
    SUM(CASE WHEN fecha_fin IS NOT NULL THEN 1 ELSE 0 END) AS bajas,
    ROUND(SUM(CASE WHEN fecha_fin IS NOT NULL THEN 1 ELSE 0 END) / COUNT(*) * 100, 2) AS tasa_churn
FROM suscripciones
GROUP BY metodo_pago
ORDER BY total_suscripciones DESC;

-- cruce entre volumen de visualizaciones y puntaje promedio de reseñas, por título. --
SELECT
    c.titulo,
    COUNT(DISTINCT v.visualizacion_id) AS visualizaciones,
    ROUND(AVG(r.puntaje), 2) AS puntaje_promedio
FROM contenido c
JOIN visualizaciones v ON v.contenido_id = c.contenido_id
LEFT JOIN resenas r ON r.contenido_id = c.contenido_id
GROUP BY c.titulo
ORDER BY visualizaciones DESC
LIMIT 10;

-- : % de visualizaciones completadas, por tipo de contenido. --
SELECT
    c.tipo,
    COUNT(*) AS total_visualizaciones,
    SUM(CASE WHEN v.completado = 'Si' THEN 1 ELSE 0 END) AS completadas,
    ROUND(SUM(CASE WHEN v.completado = 'Si' THEN 1 ELSE 0 END) / COUNT(*) * 100, 2) AS pct_completado
FROM visualizaciones v
JOIN contenido c ON v.contenido_id = c.contenido_id
GROUP BY c.tipo;

-- : puntaje promedio de reseñas, por género de contenido.-- 
SELECT
    c.genero,
    COUNT(*) AS cantidad_resenas,
    ROUND(AVG(r.puntaje), 2) AS puntaje_promedio
FROM resenas r
JOIN contenido c ON r.contenido_id = c.contenido_id
GROUP BY c.genero
ORDER BY puntaje_promedio DESC;

-- : género más visto, segmentado por clasificación de edad del contenido (ATP, +13, +16, +18).--
SELECT
    CASE
        WHEN DATEDIFF(IFNULL(s.fecha_fin, CURDATE()), s.fecha_inicio) < 90 THEN '0-3 meses'
        WHEN DATEDIFF(IFNULL(s.fecha_fin, CURDATE()), s.fecha_inicio) BETWEEN 90 AND 180 THEN '3-6 meses'
        WHEN DATEDIFF(IFNULL(s.fecha_fin, CURDATE()), s.fecha_inicio) BETWEEN 181 AND 365 THEN '6-12 meses'
        ELSE 'Más de 12 meses'
    END AS antiguedad,
    COUNT(DISTINCT s.user_id) AS cantidad_usuarios,
    ROUND(AVG(vistas.total_visualizaciones), 2) AS promedio_visualizaciones_por_usuario
FROM suscripciones s
LEFT JOIN (
    SELECT user_id, COUNT(*) AS total_visualizaciones
    FROM visualizaciones
    GROUP BY user_id
) AS vistas ON s.user_id = vistas.user_id
GROUP BY antiguedad
ORDER BY 
    CASE antiguedad
        WHEN '0-3 meses' THEN 1
        WHEN '3-6 meses' THEN 2
        WHEN '6-12 meses' THEN 3
        ELSE 4
    END;


