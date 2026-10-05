# ⚽ European Football Performance Dashboard — Power BI & SQL Analysis

Este proyecto presenta un análisis integral del rendimiento de futbolistas en las principales ligas europeas. El objetivo es transformar datos estadísticos crudos en un panel interactivo y ejecutivo que permita comparar la eficiencia ofensiva, la aportación por 90 minutos y la distribución de goles por equipo y posición.

---

## 📌 Tabla de Contenidos
- [Tecnologías Utilizadas](#-tecnologías-utilizadas)
- [Estructura del Proyecto](#-estructura-del-proyecto)
- [Limpieza y Reglas de Negocio](#-limpieza-y-reglas-de-negocio)
- [Validación SQL](#-validación-sql)
- [Medidas DAX Destacadas](#-medidas-dax-destacadas)

---

## 🛠️ Tecnologías Utilizadas

* **Power BI Desktop:** Modelado de datos, maquetación UI/UX y creación de paneles interactivos.
* **DAX (Data Analysis Expressions):** Creación de medidas dinámicas estandarizadas por 90 minutos jugados.
* **SQL (MySQL Workbench):** Consultas de agregación, exploración de datos (EDA) y validación de consistencia.

---

## 🧹 Limpieza y Reglas de Negocio

1. **Tratamiento de Nulos:**
   - Métricas absolutas (ej. `goles`, `asistencias`) transformadas a `0`.
   - Métricas relativas/porcentajes conservadas como nulas para evitar distorsiones estadísticas.
2. **Estandarización de Edades:**
   - Corrección de escala de valores numéricos concatenados (e.g., `250` corregido a `25.0`).
3. **Métricas Estándar:**
   - Ajuste de métricas absolutas en función de bloques de 90 minutos (`90s`) para permitir comparaciones equitativas entre titulares y suplentes.

---

## 🔍 Validación SQL

Ejemplo de consulta utilizada para validar la consistencia de datos entre el motor SQL y el informe de Power BI:

```sql
-- Top 10 goleadores y su rendimiento por 90 minutos
SELECT 
    player,
    squad,
    comp,
    SUM(gls) AS total_goles,
    SUM(ast) AS total_asistencias,
    ROUND(SUM(gls) / NULLIF(SUM(90s), 0), 2) AS goles_por_90
FROM players_data
GROUP BY player, squad, comp
ORDER BY total_goles DESC
LIMIT 10;

```
```dax
Medidas DAX Destacadas
Total Goles:
Total Goles = SUM('players_data_light_cleaned'[gls])
Goles por 90 Minutos:
Goles90 = DIVIDE([Total Goles], SUM('players_data_light_cleaned'[90s]), 0)
Efectividad de Disparo a Puerta:
EfectDispApuerta = DIVIDE(SUM('players_data_light_cleaned'[sot]), SUM('players_dat
