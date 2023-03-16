CREATE TABLE tipo_fornecedor (
	[codigo] [int] NOT NULL PRIMARY KEY,
	[designacao] [varchar](256) NOT NULL,
);

CREATE TABLE cond_pagamento (
	[codigo] [int] NOT NULL PRIMARY KEY,
	[prazo] [int] NOT NULL,
	[designacao] [varchar](256) NOT NULL,
);

CREATE TABLE fornecedor (
	[nif] [int] NOT NULL PRIMARY KEY,
	[nome] [varchar](256) NOT NULL,
	[endereço] [varchar](256) NOT NULL,
	[f_codigo] [int] NOT NULL FOREIGN KEY REFERENCES cond_pagamento([codigo]),
	[pag_codigo] [int] NOT NULL FOREIGN KEY REFERENCES tipo_fornecedor([codigo]),
);

CREATE TABLE armazem (
	[codigo] [int] NOT NULL PRIMARY KEY,
	[morada] [varchar](256) NOT NULL,
);

CREATE TABLE produto (
	[codigo] [int] NOT NULL PRIMARY KEY,
	[nome] [varchar](256) NOT NULL,
	[preco] [int] NOT NULL,
	[iva] [int] NOT NULL,
	[a_codigo] [int] NOT NULL FOREIGN KEY REFERENCES armazem([codigo]),
);

CREATE TABLE encomenda (
	[numero] [int] NOT NULL PRIMARY KEY,
	[data] [date] NOT NULL,
	[f_nif] [int] NOT NULL FOREIGN KEY REFERENCES fornecedor([nif]),
);

CREATE TABLE enc_prod (
	[p_codigo] [int] NOT NULL FOREIGN KEY REFERENCES produto([codigo]),
	[e_numero] [int] NOT NULL FOREIGN KEY REFERENCES encomenda([numero]),
);