-- Guilherme Rodrigues dos Santos
-- Luiz Eduardo Caldas Kramer

-- Insert e Testes
-- 1. Crie um trigger que converta automaticamente o campo nome para letras maiúsculas antes de cada INSERT ou UPDATE.
INSERT INTO usuarios (nome, email) VALUES ('ana banana', 'ana@gmail.com');
UPDATE usuarios SET nome = 'ana banana maça' WHERE email = 'ana@gmail.com';

SELECT nome FROM usuarios WHERE email = 'ana@gmail.com';



-- 2. Crie um trigger que registre em uma tabela de log o usuário que realizou a operação (usando current_user).
INSERT INTO usuarios (nome, email) VALUES ('Log', 'log@gmail.com');
DELETE FROM usuarios WHERE email = 'log@gmail.com';

SELECT operacao, usuario_banco FROM log_operacoes;



-- 3. Crie um trigger que impeça a atualização de emails para valores nulos.
UPDATE usuarios SET email = 'atualizado@gmail.com' WHERE nome = 'ANA BANANA MAÇA'; 	-- Valido
UPDATE usuarios SET email = NULL WHERE nome = 'ANA BANANA MAÇA';  						-- Erro esperado



-- 4. Crie um trigger que atualize uma coluna saldo_total em uma tabela de contas sempre que uma transação for inserida ou deletada
INSERT INTO contas (titular) VALUES ('Pedro');

-- a) Aumentar o saldo
INSERT INTO transacoes (conta_id, valor)
VALUES ((SELECT id FROM contas WHERE titular = 'Pedro'), 150.00);

-- b) Diminuir o saldo
DELETE FROM transacoes
WHERE conta_id = (SELECT id FROM contas WHERE titular = 'Pedro')
AND valor = 150.00;

SELECT saldo_total FROM contas WHERE titular = 'Pedro';



-- 5. Crie um trigger que envie uma notificação (usando NOTIFY) quando o email de um usuário for atualizado.
INSERT INTO usuarios (nome, email) VALUES ('Joao', 'jao@gmail.com');

UPDATE usuarios SET email = 'notifica@gmail.com'
WHERE nome = 'Joao';




-- 6. Crie um trigger que valide se o campo email contém um formato válido (ex.: contém @ e .) antes de INSERT ou UPDATE.
INSERT INTO usuarios (nome, email) VALUES ('Email OK', 'email@gmail.com');			-- Valido
INSERT INTO usuarios (nome, email) VALUES ('Email Err', 'gmail');					-- Erro esperado

UPDATE usuarios SET email = 'valido@gmail.com' WHERE nome = 'EMAIL OK';			-- Valido
UPDATE usuarios SET email = 'invalido' WHERE nome = 'EMAIL OK';  					-- Erro esperado

SELECT nome, email FROM usuarios WHERE nome = 'EMAIL OK';
