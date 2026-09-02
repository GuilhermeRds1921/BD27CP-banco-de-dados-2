-- Guilherme Rodrigues dos Santos
-- Luiz Eduardo Caldas Kramer

--  Qual o total de minutos de aluguel por estação em cada mês?

SELECT
    e.nome AS estacao,
    d.ano,
    d.mes,
    SUM(f.duracao_minutos) AS total_minutos
FROM fato_aluguel f
JOIN dim_estacao e ON f.estacao_inicio_id = e.id
JOIN dim_data d ON f.data_id = d.id
GROUP BY e.nome, d.ano, d.mes
ORDER BY d.ano, d.mes, total_minutos DESC;

-- Quantos aluguéis foram realizados por tipo de usuário (membro vs. casual) em 2021?

SELECT
    u.tipo AS tipo_usuario,
    COUNT(*) AS total_alugueis
FROM fato_aluguel f
JOIN dim_usuario_tipo u ON f.tipo_usuario_id = u.id
JOIN dim_data d ON f.data_id = d.id
WHERE d.ano = 2021
GROUP BY u.tipo
ORDER BY total_alugueis DESC;

-- Quais são as 5 estações com maior número de aluguéis por dia?

SELECT
    d.data,
    e.nome AS estacao,
    COUNT(*) AS total_alugueis
FROM fato_aluguel f
JOIN dim_data d ON f.data_id = d.id
JOIN dim_estacao e ON f.estacao_inicio_id = e.id
GROUP BY d.data, e.nome
ORDER BY d.data, total_alugueis DESC
LIMIT 5;

-- Qual a duração média de aluguel por tipo de usuário em cada mês?

SELECT
    u.tipo AS tipo_usuario,
    d.ano,
    d.mes,
    ROUND(AVG(f.duracao_minutos), 2) AS duracao_media_minutos
FROM fato_aluguel f
JOIN dim_usuario_tipo u ON f.tipo_usuario_id = u.id
JOIN dim_data d ON f.data_id = d.id
GROUP BY u.tipo, d.ano, d.mes
ORDER BY d.ano, d.mes, u.tipo;
