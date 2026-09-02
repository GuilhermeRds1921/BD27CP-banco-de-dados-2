-- Guilherme Rodrigues dos Santos
-- Luiz Eduardo Caldas Kramer

-- Tabelas
DROP TABLE usuarios CASCADE
DROP TABLE log_operacoes CASCADE
DROP TABLE transacoes CASCADE
DROP TABLE contas CASCADE

CREATE TABLE usuarios (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(100),
    email VARCHAR(100),
    ultima_atualizacao TIMESTAMP
);

CREATE TABLE log_operacoes (
    id SERIAL PRIMARY KEY,
    usuario_id INT,
    operacao VARCHAR(10),
    usuario_banco TEXT,
    data_operacao TIMESTAMP
);

CREATE TABLE contas (
    id SERIAL PRIMARY KEY,
    titular VARCHAR(100),
    saldo_total NUMERIC DEFAULT 0
);

CREATE TABLE transacoes (
    id SERIAL PRIMARY KEY,
    conta_id INT REFERENCES contas(id),
    valor NUMERIC
);




