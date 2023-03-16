CREATE TABLE paciente (
	[n_utente] [int] NOT NULL PRIMARY KEY,
	[nome] [varchar](256) NOT NULL,
	[endereco] [varchar](256) NOT NULL,
	[data_nasc] [date] NOT NULL,
);

CREATE TABLE medico (
	[sns] [int] NOT NULL PRIMARY KEY,
	[nome] [varchar](256) NOT NULL,
	[especialidade] [varchar](128) NOT NULL,
);

CREATE TABLE farmacia (
	[nif] [int] NOT NULL PRIMARY KEY,
	[nome] [varchar](256) NOT NULL,
	[endereco] [varchar](256) NOT NULL,
	[telefone] [int] NOT NULL,
);

CREATE TABLE prescricao (
	[numero] [int] NOT NULL PRIMARY KEY,
	[data] [date] NOT NULL,
	[med_sns] [int] NOT NULL FOREIGN KEY REFERENCES medico([sns]),
	[p_n_utente] [int] NOT NULL FOREIGN KEY REFERENCES paciente([n_utente]),
	[f_nif] [int] NOT NULL FOREIGN KEY REFERENCES farmacia([nif]),
);

CREATE TABLE comp_farmaceutica (
	[num_reg] [int] NOT NULL PRIMARY KEY,
	[nome] [varchar](256) NOT NULL,
	[endereco] [varchar](256) NOT NULL,
	[telefone] [int] NOT NULL,
);

CREATE TABLE farmaco (
	[nome] [varchar](128) NOT NULL PRIMARY KEY,
	[formula] [varchar](256) NOT NULL,
	[c_f_n_reg] [int] NOT NULL UNIQUE FOREIGN KEY REFERENCES comp_farmaceutica([num_reg]),
);

CREATE TABLE  farmaco_farmacia (
	[n_farmaco] [varchar](128) NOT NULL FOREIGN KEY REFERENCES farmaco([nome]),
	[c_f_n_reg] [int] NOT NULL FOREIGN KEY REFERENCES farmaco([c_f_n_reg]),
	[nif_farmacia] [int] NOT NULL FOREIGN KEY REFERENCES farmacia([nif]),
);

CREATE TABLE farmaco_prescricao (
	[n_farmaco] [varchar](128) NOT NULL FOREIGN KEY REFERENCES farmaco([nome]),
	[c_f_n_reg] [int] NOT NULL FOREIGN KEY REFERENCES farmaco([c_f_n_reg]),
	[n_prescricao] [int] NOT NULL FOREIGN KEY REFERENCES prescricao([numero]),
);