-- Guilherme Rodrigues dos Santos
-- Luiz Eduardo Caldas Kramer


--  1. Buscar todos os clientes com seus financiamentos
SELECT
    c.nome AS cliente,
    f.descricao,
    f.num_parcelas,
    f.valor_parcela,
    tf.nome AS tipo
FROM
    Cliente c
JOIN
    Financiamento f ON f.cpf_cliente = c.cpf
JOIN
    TipoFinanciamento tf ON f.id_tipo = tf.id;

-- 2. Ver todos os carros comprados por um cliente

SELECT
    cl.nome AS cliente,
    car.modelo,
    car.ano,
    comp.data AS data_compra,
    comp.valor_total
FROM
    Cliente cl
JOIN
    Compra comp ON comp.cpf_cliente = cl.cpf
JOIN
    CompraCarro cc ON cc.id_compra = comp.id
JOIN
    Carro car ON car.codigo = cc.id_carro
WHERE
    cl.cpf = '12345678901'; -- CPF do cliente João Silva

-- 3. Ver o total gasto por cada cliente em compras

SELECT
    cl.nome,
    SUM(comp.valor_total) AS total_gasto
FROM
    Cliente cl
JOIN
    Compra comp ON comp.cpf_cliente = cl.cpf
GROUP BY
    cl.nome;

-- 4. Funcionários que gerenciam tipos de financiamento

SELECT
    f.nome AS funcionario,
    tf.nome AS tipo_gerenciado
FROM
    Funcionario f
JOIN
    FuncionarioGerencia fg ON fg.id_funcionario = f.id
JOIN
    TipoFinanciamento tf ON tf.id = fg.id_tipo;

-- 5. Ver quantos financiamentos cada cliente tem

SELECT
    c.nome,
    COUNT(f.id) AS qtde_financiamentos
FROM
    Cliente c
LEFT JOIN
    Financiamento f ON f.cpf_cliente = c.cpf
GROUP BY
    c.nome;
