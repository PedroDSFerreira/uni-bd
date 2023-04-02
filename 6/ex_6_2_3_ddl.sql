CREATE TABLE medico(
    [numSNS] [int],
    [nome] [varchar](64) NOT NULL,
    [especialidade] [varchar](64),
    PRIMARY KEY (numSNS)
);

CREATE TABLE paciente(
    [numUtente] [int],
    [nome] [varchar](64) NOT NULL,
    [dataNasc] [date] NOT NULL,
    [endereco] [varchar](128),
    PRIMARY KEY ([numUtente])
);

CREATE TABLE farmacia(
    [nome] [varchar](64),
    [telefone] [int] UNIQUE,
    [endereco] [varchar](128),
    PRIMARY KEY ([nome])                
);

CREATE TABLE farmaceutica(
    [numReg] [int],
    [nome] [varchar](64),
    [endereco] [varchar](128),
    PRIMARY KEY ([numReg])                    
);

CREATE TABLE farmaco(
    [numRegFarm] [int] ,
    [nome] [varchar](64),
    [formula] [varchar](128),                      
    PRIMARY KEY ([numRegFarm], [nome]),
	FOREIGN KEY ([numRegFarm]) REFERENCES farmaceutica([numReg]),
);

CREATE TABLE prescricao(
    [numPresc] [int],
    [numUtente] [int] NOT NULL REFERENCES paciente([numUtente]),
    [numMedico] [int] NOT NULL REFERENCES medico([numSNS]),
    [farmacia] [varchar](64) REFERENCES farmacia([nome]),
    [dataProc] [date],
    PRIMARY KEY ([numPresc])
);

CREATE TABLE presc_farmaco(
    [numPresc] [int] REFERENCES prescricao([numPresc]),
    [numRegFarm] [int],
    [nomeFarmaco] [varchar](64),
    FOREIGN KEY ([numRegFarm], [nomeFarmaco]) REFERENCES farmaco([numRegFarm], [nome]),
    PRIMARY KEY ([numPresc], [numRegFarm], [nomeFarmaco]),
);