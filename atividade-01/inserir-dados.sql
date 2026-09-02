-- Guilherme Rodrigues dos Santos
-- Luiz Eduardo Caldas Kramer


-- Clientes
INSERT INTO Cliente (cpf, nome, telefone1, telefone2, telefone3) VALUES
('12345678901', 'João Silva', '11999998888', NULL, NULL),
('23456789012', 'Maria Oliveira', '21988887777', '21988886666', NULL),
('34567890123', 'Carlos Souza', '31977776666', '31977775555', '31977774444');

-- Funcionários
INSERT INTO Funcionario (nome, tipo_atuacao) VALUES
('Fernanda Costa', 'venda'),
('Rafael Lima', 'financiamento'),
('Ana Paula', 'financiamento');

-- Tipos de Financiamento
INSERT INTO TipoFinanciamento (nome) VALUES
('Consórcio'),
('CDC'),
('Leasing');

-- Funcionários que gerenciam tipos de financiamento
INSERT INTO FuncionarioGerencia (id_funcionario, id_tipo) VALUES
(2, 1), -- Rafael gerencia Consórcio
(3, 2); -- Ana Paula gerencia CDC

-- Financiamentos
INSERT INTO Financiamento (descricao, num_parcelas, valor_parcela, id_tipo, cpf_cliente) VALUES
('Financiamento Consórcio - Cliente João', 24, 500.00, 1, '12345678901'),
('Financiamento CDC - Cliente Maria', 36, 450.00, 2, '23456789012'),
('Financiamento CDC - Cliente Maria - Extra', 12, 800.00, 2, '23456789012');

-- Carros
INSERT INTO Carro (modelo, cor, ano, detalhes) VALUES
('Honda Civic', 'Preto', 2022, 'Completo, automático'),
('Toyota Corolla', 'Branco', 2023, 'Híbrido, banco de couro'),
('Ford Ka', 'Prata', 2020, 'Econômico');

-- Compras
INSERT INTO Compra (data, valor_total, cpf_cliente, id_funcionario) VALUES
('2025-04-01', 95000.00, '12345678901', 1),
('2025-04-10', 120000.00, '23456789012', 1);

-- Pagamentos das Compras
INSERT INTO PagamentoCompra (id_compra, data_pag1, data_pag2, data_pag3) VALUES
(1, '2025-04-01', NULL, NULL),
(2, '2025-04-10', '2025-04-20', '2025-04-30');

-- Associação entre Compra e Carro
INSERT INTO CompraCarro (id_compra, id_carro) VALUES
(1, 1),
(2, 2),
(2, 3); -- Compra com mais de um carro
