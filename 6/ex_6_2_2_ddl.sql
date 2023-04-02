CREATE TABLE tipo_fornecedor(
	[codigo] [int] NOT NULL UNIQUE CHECK([codigo]> 0),
	[designacao] [varchar](64),
	PRIMARY KEY([codigo])
);

CREATE TABLE fornecedor(
	[nif] [int] NOT NULL UNIQUE CHECK([nif]> 0),	
	[nome] [varchar](64),
	[fax] [int],	
	[endereco] [varchar](128),
	[condpag] [varchar](128),
	[tipo] [int],
	PRIMARY KEY([nif]),
	FOREIGN KEY([tipo]) REFERENCES tipo_fornecedor([codigo])
);

CREATE TABLE produto(
	[codigo] [int] NOT NULL UNIQUE CHECK([codigo]> 0),	
	[nome] [varchar](64) NOT NULL,
	[preco] [float] NOT NULL CHECK([preco]> 0),	
	[iva] [int] DEFAULT 23,
	[unidades] [int] CHECK([unidades]> 0),
	PRIMARY KEY([codigo])
);

CREATE TABLE encomenda(
	[numero] [int] NOT NULL UNIQUE CHECK([numero]> 0),	
	[data] [date],
	[fornecedor] [int],
	PRIMARY KEY([numero]),
	FOREIGN KEY([fornecedor]) REFERENCES fornecedor([nif])
);

CREATE TABLE item(
	[numEnc] [int],	
	[codProd] [int],
	[unidades] [int],
	FOREIGN KEY([numEnc]) REFERENCES encomenda([numero]),
	FOREIGN KEY([codProd]) REFERENCES produto([codigo])
);