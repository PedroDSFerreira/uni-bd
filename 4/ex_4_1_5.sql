CREATE TABLE pessoa (
	[email] [varchar](256) NOT NULL PRIMARY KEY,
	[nome] [varchar](256) NOT NULL,
);

CREATE TABLE participante (
	[morada] [varchar](256) NOT NULL PRIMARY KEY,
	[data_inscricao] [date] NOT NULL,
	[email] [varchar](256) NOT NULL UNIQUE FOREIGN KEY REFERENCES pessoa([email]),
);

CREATE TABLE estudante (
	[loc_comprovativo] [varchar](256) NOT NULL,
	[email] [varchar](256) NOT NULL FOREIGN KEY REFERENCES participante([email]),
	[morada] [varchar](256) NOT NULL FOREIGN KEY REFERENCES participante([morada]),
);

CREATE TABLE nao_estudante (
	[ref_transacao] [int] NOT NULL,
	[email] [varchar](256) NOT NULL FOREIGN KEY REFERENCES participante([email]),
	[morada] [varchar](256) NOT NULL FOREIGN KEY REFERENCES participante([morada]),
);

CREATE TABLE instituicao (
	[endereco] [varchar](256) NOT NULL PRIMARY KEY,
	[nome] [varchar](256) NOT NULL,
	[p_email] [varchar](256) NOT NULL REFERENCES pessoa([email]),
);

CREATE TABLE artigo_cientifico (
	[n_registo] [int] NOT NULL PRIMARY KEY,
	[titulo] [varchar](256) NOT NULL,
);

CREATE TABLE autor_de (
	[p_email] [varchar](256) NOT NULL FOREIGN KEY REFERENCES pessoa([email]),
	[art_n_registo] [int] NOT NULL FOREIGN KEY REFERENCES artigo_cientifico([n_registo]),
);