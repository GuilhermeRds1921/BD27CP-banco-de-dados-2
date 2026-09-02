-- Guilherme Rodrigues dos Santos
-- Luiz Eduardo Caldas Kramer

-- Popula a dimensão de datas com valores únicos de data, ano, mês, dia e dia da semana
INSERT INTO dim_data (data, ano, mes, dia, dia_semana)
SELECT DISTINCT
    DATE(started_at) AS data,
    EXTRACT(YEAR FROM started_at)::INT AS ano,
    EXTRACT(MONTH FROM started_at)::INT AS mes,
    EXTRACT(DAY FROM started_at)::INT AS dia,
    TO_CHAR(started_at, 'Day') AS dia_semana
FROM alugueis_bicicletas;

-- Popula a dimensão de hora com hora, minuto e classificação por turno (manhã, tarde etc.)
INSERT INTO dim_hora (hora, minuto, turno)
SELECT DISTINCT
    EXTRACT(HOUR FROM started_at)::INT AS hora,
    EXTRACT(MINUTE FROM started_at)::INT AS minuto,
    CASE
        WHEN EXTRACT(HOUR FROM started_at) BETWEEN 5 AND 11 THEN 'Manhã'
        WHEN EXTRACT(HOUR FROM started_at) BETWEEN 12 AND 17 THEN 'Tarde'
        WHEN EXTRACT(HOUR FROM started_at) BETWEEN 18 AND 22 THEN 'Noite'
        ELSE 'Madrugada'
    END AS turno
FROM alugueis_bicicletas;

-- Popula a dimensão de estação com os nomes e coordenadas das estações (início e fim)
INSERT INTO dim_estacao (nome, latitude, longitude)
SELECT DISTINCT
    start_station_name,
    start_lat,
    start_lng
FROM alugueis_bicicletas
WHERE start_station_name IS NOT NULL

UNION

SELECT DISTINCT
    end_station_name,
    end_lat,
    end_lng
FROM alugueis_bicicletas
WHERE end_station_name IS NOT NULL;

-- Popula a dimensão de tipos de bicicleta com os diferentes tipos disponíveis
INSERT INTO dim_bicicleta_tipo (tipo)
SELECT DISTINCT rideable_type
FROM alugueis_bicicletas;

-- Popula a dimensão de tipos de usuário (membro ou casual)
INSERT INTO dim_usuario_tipo (tipo)
SELECT DISTINCT member_casual
FROM alugueis_bicicletas;

-- Popula a tabela fato com os dados dos aluguéis, relacionando as dimensões e junta elas
INSERT INTO fato_aluguel (
    ride_id,
    data_id,
    hora_id,
    estacao_inicio_id,
    estacao_fim_id,
    tipo_bicicleta_id,
    tipo_usuario_id,
    duracao_minutos
)
SELECT
    ab.ride_id,

    d.id AS data_id,
    h.id AS hora_id,

    ei.id AS estacao_inicio_id,
    ef.id AS estacao_fim_id,

    bt.id AS tipo_bicicleta_id,
    ut.id AS tipo_usuario_id,

    EXTRACT(EPOCH FROM (ab.ended_at - ab.started_at)) / 60 AS duracao_minutos

FROM alugueis_bicicletas ab

JOIN dim_data d
    ON DATE(ab.started_at) = d.data

JOIN dim_hora h
    ON EXTRACT(HOUR FROM ab.started_at)::INT = h.hora
   AND EXTRACT(MINUTE FROM ab.started_at)::INT = h.minuto

LEFT JOIN dim_estacao ei
    ON ab.start_station_name = ei.nome
   AND ab.start_lat = ei.latitude
   AND ab.start_lng = ei.longitude

LEFT JOIN dim_estacao ef
    ON ab.end_station_name = ef.nome
   AND ab.end_lat = ef.latitude
   AND ab.end_lng = ef.longitude

JOIN dim_bicicleta_tipo bt
    ON ab.rideable_type = bt.tipo

JOIN dim_usuario_tipo ut
    ON ab.member_casual = ut.tipo;
