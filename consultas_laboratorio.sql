USE football002;
-- CONSULTA BÁSICA 1: Filtrado WHERE con dos condiciones
-- ¿En qué partidos un equipo anotó 4 o más goles teniendo menos del 40% de la posesión?

SELECT match_id AS partido, team_id AS equipo, goals AS goles, possession AS posesion, shots_on_target 
AS tiros_al_arco FROM team_match_stats
WHERE goals >= 4
AND possession < 40
ORDER BY goals DESC, possession ASC;

-- CONSULTA BÁSICA 2: JOIN entre dos entidades (team y team_match_stats)
-- ¿Qué equipos han anotado 6 o más goles en un mismo partido, y con cuántos tiros al arco lo lograron?

SELECT team.name AS equipo, team_match_stats.goals AS goles, team_match_stats.shots_on_target AS tiros_al_arco,
team_match_stats.possession AS posesion
FROM team_match_stats
INNER JOIN team ON team.id = team_match_stats.team_id
WHERE team_match_stats.goals >= 6
ORDER BY team_match_stats.goals DESC, team.name ASC;


-- CONSULTA BÁSICA 3: JOIN entre tres entidades (team, team_match_stats y match)
-- ¿Qué equipos terminaron un partido con 2 tarjetas rojas, en qué temporada ocurrió y cuántos goles lograron anotar aun así?

SELECT `match`.season AS temporada, team.name AS equipo, team_match_stats.red_cards AS tarjetas_rojas,
team_match_stats.goals AS goles, team_match_stats.possession AS posesion
FROM team_match_stats
INNER JOIN team ON team.id = team_match_stats.team_id
INNER JOIN `match` ON `match`.id = team_match_stats.match_id
WHERE team_match_stats.red_cards >= 2
ORDER BY `match`.season ASC, team.name ASC;


-- CONSULTA BÁSICA 4: Función de agregación con GROUP BY
-- ¿Cuál es el promedio de goles por partido de cada equipo, considerando solo equipos con al menos 100 partidos disputados?

SELECT team.name AS equipo, COUNT(*) AS partidos_jugados, SUM(team_match_stats.goals) AS goles_totales,
AVG(team_match_stats.goals) AS promedio_goles
FROM team_match_stats
INNER JOIN team ON team.id = team_match_stats.team_id
GROUP BY team.name
HAVING COUNT(*) >= 100
ORDER BY promedio_goles DESC;


-- CONSULTA DE ANÁLISIS 1: Tabla general de puntos
-- Acumulando 3 puntos por victoria y 1 por empate en todas las temporadas, ¿qué equipo tiene más 
-- puntos? ¿Es el mismo que más partidos ha disputado, o hay una eficiencia distinta? 

SELECT team.name AS equipo, COUNT(*) AS partidos_jugados, SUM(propio.goals > rival.goals) AS victorias,
SUM(propio.goals = rival.goals) AS empates, SUM(propio.goals < rival.goals) AS derrotas,
SUM(propio.goals > rival.goals) * 3 + SUM(propio.goals = rival.goals) AS puntos,
(SUM(propio.goals > rival.goals) * 3 + SUM(propio.goals = rival.goals)) / COUNT(*) AS puntos_por_partido
FROM team_match_stats AS propio
INNER JOIN team_match_stats AS rival
ON rival.match_id = propio.match_id
AND rival.team_id <> propio.team_id
INNER JOIN team ON team.id = propio.team_id
GROUP BY team.name
ORDER BY puntos DESC;


-- CONSULTA DE ANÁLISIS 2 (parte A): Posesión promedio en victorias
-- Entre los partidos ganados por cada equipo, ¿cuál tiene  el mejor promedio de posesión? 
-- (solo equipos con 30 o más victorias)

SELECT team.name AS equipo, COUNT(*) AS victorias, AVG(propio.possession) 
AS posesion_promedio_en_victorias
FROM team_match_stats AS propio
INNER JOIN team_match_stats AS rival
ON rival.match_id = propio.match_id
AND rival.team_id <> propio.team_id
INNER JOIN team ON team.id = propio.team_id
WHERE propio.goals > rival.goals
GROUP BY team.name
HAVING COUNT(*) >= 30
ORDER BY posesion_promedio_en_victorias DESC;

-- CONSULTA DE ANÁLISIS 2 (parte B): Frecuencia de victorias con poca posesión
-- ¿Ganar con poca posesión es un patrón raro o común?

SELECT COUNT(*) AS total_victorias,
SUM(propio.possession < 50) AS victorias_con_menos_del_50,
SUM(propio.possession < 50) * 100 / COUNT(*) AS porcentaje_menos_del_50,
SUM(propio.possession < 40) AS victorias_con_menos_del_40,
SUM(propio.possession < 40) * 100 / COUNT(*) AS porcentaje_menos_del_40,
AVG(propio.possession) AS posesion_promedio_del_ganador
FROM team_match_stats AS propio
INNER JOIN team_match_stats AS rival
ON rival.match_id = propio.match_id
AND rival.team_id <> propio.team_id
WHERE propio.goals > rival.goals;


-- CONSULTA DE ANÁLISIS 3 (parte A): Tiros al arco vs goles por temporada
-- ¿Qué equipo tiene la mayor diferencia entre tiros al arco y goles anotados en una misma temporada?

SELECT `match`.season AS temporada, team.name AS equipo,
COUNT(*) AS partidos,
SUM(team_match_stats.shots_on_target) AS tiros_al_arco,
SUM(team_match_stats.goals) AS goles,
SUM(team_match_stats.shots_on_target) - SUM(team_match_stats.goals) AS diferencia,
SUM(team_match_stats.goals) * 100 / SUM(team_match_stats.shots_on_target) AS porcentaje_conversion
FROM team_match_stats
INNER JOIN team ON team.id = team_match_stats.team_id
INNER JOIN `match` ON `match`.id = team_match_stats.match_id
GROUP BY `match`.season, team.name
ORDER BY diferencia DESC
LIMIT 10;


-- CONSULTA DE ANÁLISIS 3 (parte B): Conversión promedio de la liga
-- Referencia para interpretar la eficiencia ofensiva de la parte A

SELECT SUM(shots_on_target) AS tiros_al_arco_totales,
SUM(goals) AS goles_totales,
SUM(goals) * 100 / SUM(shots_on_target) AS porcentaje_conversion_liga
FROM team_match_stats;


-- CONSULTA DE ANÁLISIS 4: Tarjetas rojas y goles por temporada
-- ¿En qué temporada se registró el mayor número total de tarjetas rojas (sumando ambos equipos)? 
-- ¿Coincide con la temporada de mayor número de goles, o son fenómenos independientes?

SELECT `match`.season AS temporada,
COUNT(DISTINCT team_match_stats.match_id) AS partidos,
SUM(team_match_stats.red_cards) AS tarjetas_rojas,
SUM(team_match_stats.goals) AS goles,
SUM(team_match_stats.red_cards) / COUNT(DISTINCT team_match_stats.match_id) AS rojas_por_partido,
SUM(team_match_stats.goals) / COUNT(DISTINCT team_match_stats.match_id) AS goles_por_partido
FROM team_match_stats
INNER JOIN `match` ON `match`.id = team_match_stats.match_id
GROUP BY `match`.season
ORDER BY tarjetas_rojas DESC;