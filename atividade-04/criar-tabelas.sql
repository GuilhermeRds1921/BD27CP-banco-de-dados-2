-- Guilherme Rodrigues dos Santos
-- Luiz Eduardo Caldas Kramer

DROP TABLE  IF EXISTS  alugueis_bicicletas CASCADE;
DROP TABLE  IF EXISTS  dim_data  CASCADE;
DROP TABLE  IF EXISTS  dim_hora CASCADE;
DROP TABLE  IF EXISTS  dim_estacao CASCADE;
DROP TABLE  IF EXISTS  dim_bicicleta_tipo CASCADE;
DROP TABLE  IF EXISTS  dim_usuario_tipo CASCADE;
DROP TABLE  IF EXISTS  fato_aluguel CASCADE;

-- Dados .csv
CREATE TABLE alugueis_bicicletas (
    ride_id TEXT PRIMARY KEY,
    rideable_type TEXT,
    started_at TIMESTAMP,
    ended_at TIMESTAMP,
    start_station_name TEXT,
    start_station_id TEXT,
    end_station_name TEXT,
    end_station_id TEXT,
    start_lat DECIMAL(10,6),
    start_lng DECIMAL(10,6),
    end_lat DECIMAL(10,6),
    end_lng DECIMAL(10,6),
    member_casual TEXT
);

-- Data
CREATE TABLE dim_data (
    id SERIAL PRIMARY KEY,
    data DATE,
    ano INT,
    mes INT,
    dia INT,
    dia_semana TEXT
);

-- Hora
CREATE TABLE dim_hora (
    id SERIAL PRIMARY KEY,
    hora INT,
    minuto INT,
    turno TEXT
);

-- Estação
CREATE TABLE dim_estacao (
    id SERIAL PRIMARY KEY,
    nome TEXT,
    latitude DECIMAL(10,6),
    longitude DECIMAL(10,6)
);

-- Tipo de bicicleta
CREATE TABLE dim_bicicleta_tipo (
    id SERIAL PRIMARY KEY,
    tipo TEXT
);

-- Tipo de usuário
CREATE TABLE dim_usuario_tipo (
    id SERIAL PRIMARY KEY,
    tipo TEXT
);

-- Tabela de associações
CREATE TABLE fato_aluguel (
    ride_id TEXT PRIMARY KEY,
    data_id INT REFERENCES dim_data(id),
    hora_id INT REFERENCES dim_hora(id),
    estacao_inicio_id INT REFERENCES dim_estacao(id),
    estacao_fim_id INT REFERENCES dim_estacao(id),
    tipo_bicicleta_id INT REFERENCES dim_bicicleta_tipo(id),
    tipo_usuario_id INT REFERENCES dim_usuario_tipo(id),
    duracao_minutos INT
);
