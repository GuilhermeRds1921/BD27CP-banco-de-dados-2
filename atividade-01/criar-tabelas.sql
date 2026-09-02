-- Guilherme Rodrigues dos Santos
-- Luiz Eduardo Caldas Kramer


CREATE TABLE Cliente (
    cpf CHAR(11) PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    telefone1 VARCHAR(15) NOT NULL,
    telefone2 VARCHAR(15),
    telefone3 VARCHAR(15),
    CONSTRAINT chk_telefone1_not_null CHECK (telefone1 IS NOT NULL)
);

CREATE TABLE Funcionario (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    tipo_atuacao VARCHAR(15) CHECK (tipo_atuacao IN ('venda', 'financiamento')) NOT NULL
);

CREATE TABLE TipoFinanciamento (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(50) NOT NULL
);

CREATE TABLE FuncionarioGerencia (
    id_funcionario INTEGER REFERENCES Funcionario(id),
    id_tipo INTEGER REFERENCES TipoFinanciamento(id),
    PRIMARY KEY (id_funcionario),
    UNIQUE (id_funcionario)
);

CREATE TABLE Financiamento (
    id SERIAL PRIMARY KEY,
    descricao VARCHAR(255),
    num_parcelas INTEGER NOT NULL CHECK (num_parcelas > 0),
    valor_parcela DECIMAL(10,2) NOT NULL,
    id_tipo INTEGER REFERENCES TipoFinanciamento(id),
    cpf_cliente CHAR(11) REFERENCES Cliente(cpf)
);

CREATE TABLE Carro (
    codigo SERIAL PRIMARY KEY,
    modelo VARCHAR(100) NOT NULL,
    cor VARCHAR(30),
    ano INTEGER,
    detalhes TEXT
);

CREATE TABLE Compra (
    id SERIAL PRIMARY KEY,
    data DATE NOT NULL,
    valor_total DECIMAL(12,2) NOT NULL,
    cpf_cliente CHAR(11) REFERENCES Cliente(cpf),
    id_funcionario INTEGER REFERENCES Funcionario(id)
);

CREATE TABLE PagamentoCompra (
    id_compra INTEGER PRIMARY KEY REFERENCES Compra(id) ON DELETE CASCADE,
    data_pag1 DATE NOT NULL,
    data_pag2 DATE,
    data_pag3 DATE
);

CREATE TABLE CompraCarro (
    id_compra INTEGER REFERENCES Compra(id) ON DELETE CASCADE,
    id_carro INTEGER REFERENCES Carro(codigo),
    PRIMARY KEY (id_compra, id_carro)
);