CREATE TABLE players_data (
    rk INT PRIMARY KEY,
    player VARCHAR(255),
    nation VARCHAR(10),
    pos VARCHAR(20),
    squad VARCHAR(255),
    comp VARCHAR(255),
    age NUMERIC,
    born INT,
    mp INT,
    starts INT,
    min NUMERIC,
    "90s" NUMERIC,
    gls INT,
    ast INT,
    g_plus_a INT,
    g_minus_pk INT,
    pk INT,
    pkatt INT,
    crdy INT,
    crdr INT,
    g_plus_a_minus_pk NUMERIC,
    sh INT,
    sot INT,
    sot_pct NUMERIC,
    sh_per_90 NUMERIC,
    sot_per_90 NUMERIC,
    g_per_sh NUMERIC,
    g_per_sot NUMERIC,
    crs INT,
    tklw INT,
    "int" INT,
    fld INT,
    "2crdy" INT,
    fls INT,
    og INT,
    ga NUMERIC,
    ga90 NUMERIC,
    sota NUMERIC,
    saves NUMERIC,
    save_pct NUMERIC,
    w NUMERIC,
    d NUMERIC,
    l NUMERIC,
    cs NUMERIC,
    cs_pct NUMERIC,
    pkatt_stats_keeper NUMERIC,
    pka NUMERIC,
    pksv NUMERIC,
    pkm NUMERIC
);

SELECT * from players_data;

-- 1. Máximos goleadores del torneo
SELECT player, squad, comp, gls 
FROM players_data 
ORDER BY gls DESC 
LIMIT 5;

-- 2. Promedio de edad por liga

SELECT comp, ROUND(AVG(age), 2) as avg_age
FROM players_data
GROUP BY comp
ORDER BY avg_age ASC;

-- 3. Disciplina por equipo
SELECT squad, SUM(crdy) as total_amarillas, SUM(crdr) as total_rojas
from players_data
GROUP BY squad
ORDER BY total_amarillas DESC;

-- 4. Filtrado de promesas jóvenes (Sub-21 con goles)

SELECT player,squad, gls,comp
from players_data
WHERE born >= 2005 AND gls > 1
ORDER BY gls DESC;

--5. Rendimiento ofensivo completo (Goles y Asistencias)

SELECT player, squad, gls, ast
from players_data
WHERE gls > 3 AND ast >= 2
ORDER BY gls DESC, ast DESC;

-- 6. Efectividad de cara a puerta (Goles por disparo)

SELECT player, squad, gls, sh, 
       ROUND(CAST(gls AS NUMERIC) / sh, 2) AS efectividad 
FROM players_data 
WHERE sh >= 10 
ORDER BY efectividad DESC 
LIMIT 5;

-- 7. Contribución de gol por cada 90 minutos (Sin penaltis)
SELECT player, squad, g_plus_a_minus_pk, "90s" 
FROM players_data 
WHERE "90s" >= 3.0 
ORDER BY g_plus_a_minus_pk DESC 
LIMIT 5;

-- 8. Rendimiento de Porteros (Porcentaje de atajadas)

SELECT player, squad, saves, sota, save_pct 
FROM players_data 
WHERE sota > 10 
ORDER BY save_pct DESC 
LIMIT 5;

-- 9. Recuperadores de balón (Entradas + Intercepciones)

SELECT player, pos, squad, tklw, "int", 
       (tklw + "int") AS total_recuperaciones 
FROM players_data 
ORDER BY total_recuperaciones DESC 
LIMIT 5;

--10. Agrupación avanzada: Comparativa entre Ligas

SELECT comp, 
       SUM(gls) AS total_goles, 
       SUM(sh) AS total_tiros, 
       ROUND(AVG(sot_pct), 2) AS avg_sot_pct 
FROM players_data 
GROUP BY comp 
ORDER BY total_goles DESC;