CREATE TABLE turma (
	[id] [int] NOT NULL PRIMARY KEY,
	[designacao] [varchar](128) NOT NULL,
	[max_alunos] [int] NOT NULL,
	[ano_letivo] [int] NOT NULL,
);

CREATE TABLE atividade (
	[id] [int] NOT NULL PRIMARY KEY,
	[designacao] [varchar](128) NOT NULL,
	[custo] [int] NOT NULL,
);

CREATE TABLE turma_atividade (
	[t_id] [int] NOT NULL FOREIGN KEY REFERENCES turma([id]),
	[a_id] [int] NOT NULL FOREIGN KEY REFERENCES atividade([id]),
);

CREATE TABLE pessoa (
	[cc] [int] NOT NULL PRIMARY KEY,
	[nome] [varchar](256) NOT NULL,
	[morada] [varchar](256) NOT NULL,
	[data_nasc] [date] NOT NULL,
);

CREATE TABLE adulto (
	[email] [varchar](256) NOT NULL PRIMARY KEY,
	[telefone] [int] NOT NULL,
	[p_cc] [int] NOT NULL UNIQUE FOREIGN KEY REFERENCES pessoa([cc]),
);

CREATE TABLE professor (
	[n_funcionario] [int] NOT NULL PRIMARY KEY,
	[a_cc] [int] NOT NULL FOREIGN KEY REFERENCES adulto([p_cc]),
	[a_email] [varchar](256) NOT NULL FOREIGN KEY REFERENCES adulto([email]),
	[t_id] [int] NOT NULL FOREIGN KEY REFERENCES turma([id]),
);

CREATE TABLE enc_educacao (
	[relacao] [varchar](16) NOT NULL,
	[a_cc] [int] NOT NULL UNIQUE FOREIGN KEY REFERENCES adulto([p_cc]),
	[a_email] [varchar](256) NOT NULL UNIQUE FOREIGN KEY REFERENCES adulto([email]),
);

CREATE TABLE aluno (
	[p_cc] [int] NOT NULL UNIQUE FOREIGN KEY REFERENCES pessoa([cc]),
	[t_id] [int] NOT NULL UNIQUE FOREIGN KEY REFERENCES turma([id]),
	[enc_cc] [int] NOT NULL FOREIGN KEY REFERENCES enc_educacao([a_cc]),
	[enc_email] [varchar](256) NOT NULL FOREIGN KEY REFERENCES enc_educacao([a_email]),
);