-- Guilherme Rodrigues dos Santos
-- Luiz Eduardo Caldas Kramer

-- Funções para gerar dados "aleatórios"
CREATE OR REPLACE FUNCTION nome_aleatorio() RETURNS TEXT AS $$
DECLARE
  nomes TEXT[] := ARRAY[
    'Ana', 'Bruno', 'Carlos', 'Daniela', 'Eduardo', 'Fernanda', 'Gabriel', 'Helena',
    'Isabela', 'João', 'Katia', 'Lucas', 'Mariana', 'Nathan', 'Otávio', 'Patrícia',
    'Quésia', 'Rafael', 'Simone', 'Tiago', 'Ursula', 'Victor', 'Wesley', 'Ximena',
    'Yasmin', 'Zeca'
  ];
BEGIN
  RETURN nomes[1 + trunc(random() * array_length(nomes, 1))];
END;
$$ LANGUAGE plpgsql;




CREATE OR REPLACE FUNCTION cidade_aleatoria() RETURNS TEXT AS $$
DECLARE
  cidades TEXT[] := ARRAY['Curitiba', 'Londrina', 'Maringá', 'Cascavel', 'Toledo', 'Ponta Grossa'];
BEGIN
  RETURN cidades[1 + trunc(random() * array_length(cidades, 1))];
END;
$$ LANGUAGE plpgsql;




CREATE OR REPLACE FUNCTION curso_aleatorio() RETURNS TEXT AS $$
DECLARE
  cursos TEXT[] := ARRAY[
    'Engenharia de Software', 'Sistemas de Informação', 'Engenharia Elétrica',
    'Engenharia Civil', 'Ciência da Computação', 'Arquitetura', 'Design', 'Química Industrial'
  ];
BEGIN
  RETURN cursos[1 + trunc(random() * array_length(cursos, 1))];
END;
$$ LANGUAGE plpgsql;




CREATE OR REPLACE FUNCTION estado_aleatorio() RETURNS CHAR(2) AS $$
DECLARE
  estados TEXT[] := ARRAY['PR', 'SC', 'RS', 'SP', 'MG', 'RJ'];
BEGIN
  RETURN estados[1 + trunc(random() * array_length(estados, 1))];
END;
$$ LANGUAGE plpgsql;




CREATE OR REPLACE FUNCTION data_nascimento() RETURNS DATE AS $$
BEGIN
  RETURN date '1980-01-01' + trunc(random() * 8000)::int;
END;
$$ LANGUAGE plpgsql;




CREATE OR REPLACE FUNCTION depto_aleatorio() RETURNS CHAR(8) AS $$
DECLARE
  deptos TEXT[] := ARRAY['INF', 'MAT', 'ELE', 'CIVIL', 'QUIMICA', 'ENGENH', 'GESTAO'];
BEGIN
  RETURN deptos[1 + trunc(random() * array_length(deptos, 1))];
END;
$$ LANGUAGE plpgsql;


-- Popula a tabela Aluno
DO $$
DECLARE
  i INTEGER;
  nome_completo TEXT;
  nome_mae TEXT;
  nascimento DATE;
  idade INTEGER;
BEGIN
  FOR i IN 1..3000 LOOP
    nome_completo := nome_aleatorio() || ' ' || nome_aleatorio();
    nome_mae := nome_aleatorio() || ' ' || nome_aleatorio();
    nascimento := data_nascimento();
    idade := date_part('year', age(current_date, nascimento));

    INSERT INTO Aluno (Nome, RA, DataNasc, Idade, NomeMae, Cidade, Estado, Curso, periodo)
    VALUES (
      nome_completo,
      numero(8),
      nascimento,
      idade,
      nome_mae,
      cidade_aleatoria(),
      estado_aleatorio(),
      curso_aleatorio(),
      trunc(random() * 10)::int + 1
    );
  END LOOP;
END;
$$;


-- Popula a tabela Discp
DO $$
DECLARE
  i INTEGER;
  sigla_base CHAR(7);
BEGIN
  FOR i IN 1..300 LOOP
    sigla_base := 'DISC' || lpad(i::text, 3, '0');

    INSERT INTO Discip (Sigla, Nome, SiglaPreReq, NNCred, Monitor, Depto)
    VALUES (
      sigla_base,
      'Disciplina ' || i,
      NULL,  -- preenchido depois
      trunc(random() * 4 + 1),
      NULL,  -- preenchido depois com RA válido
      depto_aleatorio()
    );
  END LOOP;
END;
$$;



-- Atualiza algumas disciplinas com pré-requisitos aleatórios (sigla anterior)
UPDATE Discip d
SET SiglaPreReq = (
  SELECT Sigla FROM Discip
  WHERE Sigla < d.Sigla
  ORDER BY random()
  LIMIT 1
)
WHERE random() < 0.5;  -- 50% terão pré-requisitos



-- Atualiza alguns monitores com RA válidos
UPDATE Discip
SET Monitor = (
  SELECT RA FROM Aluno ORDER BY random() LIMIT 1
)
WHERE random() < 0.3;  -- 30% terão monitor



-- Popula a tabela Matricula
DO $$
DECLARE
  i INTEGER;
  var_ra DECIMAL(8);
  var_sigla CHAR(7);
  ano CHAR(4);
  semestre CHAR(1);
BEGIN
  FOR i IN 1..3000 LOOP
    -- Seleciona RA e Sigla válidos
    SELECT RA INTO var_ra FROM Aluno ORDER BY random() LIMIT 1;
    SELECT Sigla INTO var_sigla FROM Discip ORDER BY random() LIMIT 1;

    ano := (2000 + trunc(random() * 25))::char(4);
    semestre := (1 + trunc(random() * 2))::char(1);

    INSERT INTO Matricula (
      RA, Sigla, Ano, Semestre, CodTurma,
      NotaP1, NotaP2, NotaTrab, NotaFIM, Frequencia
    )
    VALUES (
      var_ra,
      var_sigla,
      ano,
      semestre,
      numero(4),
      trunc((random() * 10)::numeric, 1),
      trunc((random() * 10)::numeric, 1),
      trunc((random() * 10)::numeric, 1),
      trunc((random() * 10)::numeric, 1),
      trunc(random() * 100)
    );
  END LOOP;
END;
$$;

ANALYZE Aluno;
ANALYZE Discip;
ANALYZE Matricula;