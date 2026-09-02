# Banco de Dados 2

Repositório de atividades práticas e trabalhos da disciplina de Banco de Dados 2.

## Conteúdo

- **APS**: projeto de banco de dados para um sistema comercial, com clientes, fornecedores, produtos, estoque, promoções e transações.
- **Atividade 01**: consultas SQL sobre clientes, compras, carros e financiamentos.
- **Atividade 02**: criação, população e consultas com índices.
- **Atividade 03**: triggers, inserção de dados e testes.
- **Atividade 04**: projeto e consultas de um modelo estrela para análise de aluguel de bicicletas.
- **Relatórios**: documentos em PDF relacionados às atividades e à APS.

## Estrutura

```text
.
├── aps/
│   ├── APS.pdf
│   ├── README.md
│   └── popular.py
├── atividade-01/
│   ├── CreateTable.sql
│   ├── InsertTable.sql
│   └── Querys.sql
├── atividade-02/
│   ├── create.sql
│   ├── insert.sql
│   └── exercicios.sql
├── atividade-03/
│   ├── create.sql
│   ├── insert e testes.sql
│   └── triggers.sql
├── atividade-04/
│   ├── create.sql
│   ├── estrela.sql
│   ├── search.sql
│   └── README.txt
└── Relatório_Banco_de_Dados2.pdf
```

## Tecnologias

- PostgreSQL
- SQL
- Python 3
- Faker, usado pelo gerador de dados da APS

## Como usar

1. Instale o PostgreSQL e crie um banco de dados para os exercícios.
2. Abra a atividade desejada e execute primeiro o script de criação das tabelas.
3. Execute o script de inserção de dados.
4. Execute as consultas, exercícios ou testes correspondentes.

A ordem exata pode variar entre as atividades. Consulte os comentários de cada script e o README específico da APS antes da execução.

## APS

A APS contém um gerador de dados em [`aps/popular.py`](aps/popular.py) e o relatório técnico em [`aps/APS.pdf`](aps/APS.pdf).

Para gerar dados da APS:

```bash
cd aps
python3 popular.py
```

O script gera um arquivo SQL de população conforme as tabelas definidas no projeto. Execute-o somente após criar o esquema correspondente no PostgreSQL.

## Observações

- Os scripts devem ser executados em um ambiente de testes, pois alguns comandos criam, alteram ou removem tabelas.
- Os arquivos PDF e as imagens documentam entregas e resultados das atividades.
- Nomes de arquivos existentes foram preservados para manter a compatibilidade com o material original.
