# ⚽ Análisis SQL: Rendimiento Multidimensional de Jugadores en Top Ligas de Fútbol

## 📌 Resumen Ejecutivo

Este proyecto aplica analítica de datos relacionales sobre un conjunto de estadísticas de fútbol profesional (`players_data`). El objetivo principal es evaluar el desempeño individual y colectivo de jugadores en aspectos clave como **capacidad goleadora**, **efectividad de cara al arco**, **disciplina**, **talento joven (promesas)**, **rendimiento defensivo** y **métricas avanzadas de guardametas**.

El proyecto incluye la definición del esquema DDL en **PostgreSQL** y **10 consultas analíticas** diseñadas para extraer insights accionables útiles para la toma de decisiones en *scouting*, análisis táctico y dirección deportiva.

---

## 🔍 Hallazgos Principales del Análisis

1. **Eficiencia Ofensiva**:
   * Filtrar a los goleadores por efectividad de disparo (`gls / sh`) permite identificar atacantes con alta tasa de conversión, diferenciando entre volumen de tiros y contundencia real.

2. **Detección de Talento Joven**:
   * A través del análisis del año de nacimiento (`born >= 2005`), el script aísla jóvenes promesas sub-21 que ya registran impacto directo en el marcador en ligas competitivas.

3. **Métricas Avanzadas de Porteros y Defensa**:
   * La combinación de entradas ganadas (`tklw`) e intercepciones (`int`) consolida el perfil de los principales recuperadores de balón.
   * El porcentaje de atajadas (`save_pct`) evaluado únicamente sobre porteros con más de 10 tiros a puerta recibidos (`sota > 10`) filtra anomalías por muestras pequeñas.

---

## 🛠️ Estructura de la Base de Datos (PostgreSQL)

La tabla `players_data` almacena las métricas individuales por jugador, cubriendo variables demográficas, de ataque, defensa, disciplina y portería.

```sql
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
```

---

## 💡 Consultas SQL Analíticas

### 1. Máximos Goleadores del Torneo
Identifica a los 5 principales anotadores de la competición.

```sql
SELECT player, squad, comp, gls 
FROM players_data 
ORDER BY gls DESC 
LIMIT 5;
```

---

### 2. Promedio de Edad por Liga
Calcula la edad media de las plantillas por competición para evaluar la madurez o juventud promedio de cada liga.

```sql
SELECT comp, ROUND(AVG(age), 2) AS avg_age
FROM players_data
GROUP BY comp
ORDER BY avg_age ASC;
```

---

### 3. Disciplina por Equipo
Acumula las tarjetas amarillas y rojas recibidas por cada club para identificar a los equipos con mayor registro disciplinario.

```sql
SELECT squad, SUM(crdy) AS total_amarillas, SUM(crdr) AS total_rojas
FROM players_data
GROUP BY squad
ORDER BY total_amarillas DESC;
```

---

### 4. Filtrado de Promesas Jóvenes (Sub-21 con Goles)
Filtra a los futbolistas nacidos a partir de 2005 que ya han registrado más de 1 gol en el torneo.

```sql
SELECT player, squad, gls, comp
FROM players_data
WHERE born >= 2005 AND gls > 1
ORDER BY gls DESC;
```

---

### 5. Rendimiento Ofensivo Completo (Goles y Asistencias)
Evalúa la contribución directa de gol identificando a los atacantes con regularidad en anotación y generación de pases de gol.

```sql
SELECT player, squad, gls, ast
FROM players_data
WHERE gls > 3 AND ast >= 2
ORDER BY gls DESC, ast DESC;
```

---

### 6. Efectividad de Cara a Puerta (Goles por Disparo)
Mide la tasa de conversión en jugadores con al menos 10 remates intentados.

```sql
SELECT player, squad, gls, sh, 
       ROUND(CAST(gls AS NUMERIC) / sh, 2) AS efectividad 
FROM players_data 
WHERE sh >= 10 
ORDER BY efectividad DESC 
LIMIT 5;
```

---

### 7. Contribución de Gol sin Penaltis por 90 Minutos
Mide la aportación ofensiva nula de penales ajustada por el tiempo de juego efectivo (mínimo 3 partidos jugados / 270 minutos).

```sql
SELECT player, squad, g_plus_a_minus_pk, "90s" 
FROM players_data 
WHERE "90s" >= 3.0 
ORDER BY g_plus_a_minus_pk DESC 
LIMIT 5;
```

---

### 8. Rendimiento de Porteros (Porcentaje de Atajadas)
Evalúa a los 5 arqueros con mayor efectividad bajo palos entre quienes han enfrentado más de 10 tiros a puerta.

```sql
SELECT player, squad, saves, sota, save_pct 
FROM players_data 
WHERE sota > 10 
ORDER BY save_pct DESC 
LIMIT 5;
```

---

### 9. Recuperadores de Balón (Entradas + Intercepciones)
Suma las entradas ganadas y las intercepciones para destacar a los futbolistas con mayor impacto en la destrucción de juego rival.

```sql
SELECT player, pos, squad, tklw, "int", 
       (tklw + "int") AS total_recuperaciones 
FROM players_data 
ORDER BY total_recuperaciones DESC 
LIMIT 5;
```

---

### 10. Agrupación Avanzada: Comparativa entre Ligas
Compara el volumen ofensivo total (goles y disparos) e imprecisión/precisión acumulada entre competiciones.

```sql
SELECT comp, 
       SUM(gls) AS total_goles, 
       SUM(sh) AS total_tiros, 
       ROUND(AVG(sot_pct), 2) AS avg_sot_pct 
FROM players_data 
GROUP BY comp 
ORDER BY total_goles DESC;
```

---

## 📈 Conclusiones y Aplicaciones Prácticas

1. **Scouting y Fichajes**: Las consultas 4, 6 y 7 ofrecen filtros directos para identificar jugadores subvalorados con alta eficiencia sin depender de goles de penal.
2. **Análisis de Perfil Defensivo**: La métrica combinada de recuperaciones (Consulta 9) facilita la búsqueda de pivotes defensivos y laterales de alto desgaste.
3. **Benchmarking entre Ligas**: La agrupación por competición (Consulta 10) permite comparar el estilo de juego (ofensivo vs. defensivo) entre diferentes ligas.

---
*Proyecto de análisis de datos de fútbol desarrollado en PostgreSQL.*
