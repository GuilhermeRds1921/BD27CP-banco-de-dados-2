-- Guilherme Rodrigues dos Santos
-- Luiz Eduardo Caldas Kramer


drop table Aluno cascade;
drop table Discip cascade;
drop table Matricula cascade;

CREATE TABLE Aluno(
	Nome VARCHAR(50) NOT NULL,
	RA DECIMAL(8) NOT NULL,
	DataNasc DATE NOT NULL,
	Idade DECIMAL(3),
	NomeMae VARCHAR(50) NOT NULL,
	Cidade VARCHAR(30),
	Estado CHAR(2),
	Curso VARCHAR(50),
	periodo integer
);

CREATE TABLE Discip(
	Sigla CHAR(7) NOT NULL,
	Nome VARCHAR(25) NOT NULL,
	SiglaPreReq CHAR(7),
	NNCred DECIMAL(2) NOT NULL,
	Monitor DECIMAL(8),
	Depto CHAR(8)
);

CREATE TABLE Matricula(
	RA DECIMAL(8) NOT NULL,
	Sigla CHAR(7) NOT NULL,
	Ano CHAR(4) NOT NULL,
	Semestre CHAR(1) NOT NULL,
	CodTurma DECIMAL(4) NOT NULL,
	NotaP1 NUMERIC(3,1),
	NotaP2 NUMERIC(3,1),
	NotaTrab NUMERIC(3,1),
	NotaFIM NUMERIC(3,1),
	Frequencia DECIMAL(3)
);