-- Guilherme Rodrigues dos Santos
-- Luiz Eduardo Caldas Kramer


-- Exercício 1: Criar as constraints após as tabelas.

-- Chave primária da tabela Aluno
ALTER TABLE Aluno ADD PRIMARY KEY (RA);
ALTER TABLE Discip ADD PRIMARY KEY (Sigla);
ALTER TABLE Matricula ADD PRIMARY KEY (RA, Sigla, Ano, Semestre);

-- Restrições de integridade referencial (FK)
ALTER TABLE Discip ADD FOREIGN KEY (Monitor) REFERENCES Aluno(RA);
ALTER TABLE Matricula ADD FOREIGN KEY (RA) REFERENCES Aluno(RA);
ALTER TABLE Matricula ADD FOREIGN KEY (Sigla) REFERENCES Discip(Sigla);
ALTER TABLE Discip ADD FOREIGN KEY (SiglaPreReq) REFERENCES Discip(Sigla);



-- Exercício 2) Suponha que o seguinte índice foi criado para a relação Aluno.
CREATE UNIQUE INDEX IdxAlunoNNI ON Aluno (Nome, NomeMae, Idade);

-- 1. Escreva uma consulta que utilize esse índice.
EXPLAIN ANALYZE
SELECT * FROM Aluno
WHERE Nome = 'João'
  AND NomeMae = 'Helena'
  AND Idade = 23;

-- 2. Mostre um exemplo onde o índice não é usado mesmo utilizando algum campo indexado na cláusula where, e explique por quê.
EXPLAIN ANALYZE
SELECT * FROM Aluno
WHERE Idade = 23;
-- Porque o índice criado é composto (Nome, NomeMae, Idade). O otimizador só consegue usar eficientemente se as colunas mais à esquerda forem especificadas. Aqui, só foi usada "Idade".



-- Exercício 3) Crie Índices e mostre exemplos de consultas (resultados e explain) que usam os seguintes tipos de acessos:

-- a) Sequential Scan
EXPLAIN ANALYZE
SELECT * FROM Aluno WHERE Curso  LIKE '%Engenharia%';

-- b) Bitmap Index Scan
CREATE INDEX idx_aluno_periodo ON Aluno(periodo);
ANALYZE Aluno;

EXPLAIN ANALYZE
SELECT * FROM Aluno WHERE periodo IN (3, 5, 7);

-- c) Index Scan
CREATE INDEX idx_aluno_ra ON Aluno(RA);
ANALYZE Aluno;

EXPLAIN ANALYZE
SELECT * FROM aluno WHERE ra = 12345678;

-- d) Index-Only Scan
CREATE INDEX idx_discip_nome_depto ON Discip(Nome, Depto);
ANALYZE Discip;

EXPLAIN ANALYZE
SELECT Nome, Depto FROM Discip WHERE Nome = 'MAT';

-- e) Multi-Index Scan
CREATE INDEX idx_aluno_estado ON Aluno(Estado);
CREATE INDEX idx_aluno_curso ON Aluno(Curso);
CREATE INDEX idx_aluno_nomemae ON Aluno(NomeMae);
ANALYZE Aluno;

EXPLAIN ANALYZE
SELECT * FROM Aluno
WHERE Estado = 'PR' AND Curso = 'Arquitetura' AND NomeMae = 'Helena Eduardo';



-- Exercício 4 - Criar índices para chaves estrangeiras:
CREATE INDEX idx_matricula_ra ON Matricula(RA);
CREATE INDEX idx_matricula_sigla ON Matricula(Sigla);
CREATE INDEX idx_discip_depto ON Discip(Depto);

ANALYZE Matricula;
ANALYZE Discip;
ANALYZE Aluno;

EXPLAIN ANALYZE
SELECT A.Nome, D.Nome AS Disciplina, M.Ano, M.Semestre
FROM Matricula M
JOIN Aluno A ON M.RA = A.RA
JOIN Discip D ON M.Sigla = D.Sigla
WHERE D.Depto = 'INF';

-- Exercício 5 - Utilizar índice bitmap para periodo:
EXPLAIN ANALYZE
SELECT * FROM Aluno WHERE periodo BETWEEN 3 AND 5;



-- Exercício 6 - Criar índice clusterizado:
CREATE INDEX idx_aluno_ra_cluster ON Aluno(RA);
ANALYZE Aluno;

EXPLAIN ANALYZE
SELECT * FROM Aluno WHERE RA BETWEEN 10000000 AND 10001234;

-- Clusterizando a tabela
CLUSTER Aluno USING idx_aluno_ra_cluster;
ANALYZE Aluno;

EXPLAIN ANALYZE
SELECT * FROM Aluno WHERE RA BETWEEN 10000000 AND 10001234;



-- Exercício 7 - Fazer busca por JSONB
ALTER TABLE Aluno ADD COLUMN IF NOT EXISTS informacoesExtras JSONB;

UPDATE Aluno
SET informacoesExtras = jsonb_build_object(
  'telefone', '4199' || to_char(numero(6), 'FM000000'),
  'time', (ARRAY['Santos', 'Corinthians', 'Flamengo', 'Grêmio', 'Athletico'])[1 + trunc(random() * 5)]
)
WHERE informacoesExtras IS NULL;


CREATE INDEX idx_informacoesExtras_time
ON Aluno
USING GIN (informacoesExtras jsonb_path_ops);


EXPLAIN ANALYZE
SELECT * FROM Aluno
WHERE informacoesExtras @> '{"time": "Santos"}';