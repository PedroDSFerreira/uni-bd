CREATE TABLE cliente(
	[nif] [int] NOT NULL PRIMARY KEY,
	[nome] [varchar](256) NOT NULL,
	[endereco] [varchar](256) NOT NULL,
	[num_carta] [int] NOT NULL,

);

CREATE TABLE balcao(
	[numero] [int] NOT NULL PRIMARY KEY,
	[nome] [varchar](256) NOT NULL,
	[endereco] [varchar](256) NOT NULL,
);

CREATE TABLE tipo_veiculo(
	[codigo] [int] NOT NULL PRIMARY KEY,
	[designacao] [varchar](128) NOT NULL,
	[arcondicionado] [bit] NOT NULL,
);

CREATE TABLE veiculo(
	[matricula] [varchar](16) NOT NULL PRIMARY KEY,
	[ano] [int] NOT NULL,
	[marca] [varchar](256) NOT NULL,
	[codigo_tipo_veiculo] [int] NOT NULL REFERENCES tipo_veiculo([codigo]),
);

CREATE TABLE aluguer(
	[numero] [int] NOT NULL PRIMARY KEY,
	[duracao] [time] NOT NULL,
	[data] [date] NOT NULL,
	[numero_balcao] [int] NOT NULL,
	[nif_cliente] [int] NOT NULL REFERENCES cliente([nif]),
	[matricula_veiculo] [varchar](16) NOT NULL,
);



CREATE TABLE similaridade(
	[codigo_tipo_veiculo_1] [int] NOT NULL FOREIGN KEY REFERENCES tipo_veiculo([codigo]),
	[codigo_tipo_veiculo_2] [int] NOT NULL FOREIGN KEY REFERENCES tipo_veiculo([codigo]),
);

CREATE TABLE ligeiro(
	[codigo_tipo_veiculo] [int] NOT NULL FOREIGN KEY REFERENCES tipo_veiculo([codigo]),
	[num_lugares] [int] NOT NULL,
	[portas] [int] NOT NULL,
	[combustivel] [varchar](16) NOT NULL,
);

CREATE TABLE pesado(
	[codigo_tipo_veiculo] [int] NOT NULL FOREIGN KEY REFERENCES tipo_veiculo([codigo]),
	[peso] [int] NOT NULL,
	[passageiros] [int] NOT NULL,
);
