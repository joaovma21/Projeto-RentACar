-- DDL: CRIAÇÃO DA ESTRUTURA

CREATE TABLE Cidade (
    idCidade INT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    uf CHAR(2) NOT NULL
);

CREATE TABLE Loja (
    idLoja INT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    endereco VARCHAR(255),
    idCidade INT NOT NULL,
    FOREIGN KEY (idCidade) REFERENCES Cidade(idCidade)
);

CREATE TABLE Cliente (
    idCliente INT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    cpf VARCHAR(14) UNIQUE NOT NULL,
    cnh VARCHAR(20) UNIQUE NOT NULL,
    email VARCHAR(100)
);

CREATE TABLE Carro (
    placa VARCHAR(7) PRIMARY KEY,
    modelo VARCHAR(50) NOT NULL,
    marca VARCHAR(50) NOT NULL,
    valorDiaria DECIMAL(10, 2) NOT NULL,
    status VARCHAR(20) NOT NULL CHECK (status IN ('LIVRE', 'ALUGADO', 'RESERVADO', 'MANUTENCAO')),
    idLojaAtual INT NOT NULL,
    FOREIGN KEY (idLojaAtual) REFERENCES Loja(idLoja)
);

CREATE TABLE Reserva (
    idReserva INT PRIMARY KEY,
    idCliente INT NOT NULL,
    dataRetiradaPrevista DATETIME NOT NULL,
    idLojaRetirada INT NOT NULL,
    periodoDias INT NOT NULL CHECK (periodoDias IN (7, 15, 30)),
    valorTotal DECIMAL(10, 2) NOT NULL,
    pagamentoConfirmado BOOLEAN NOT NULL DEFAULT TRUE,
    FOREIGN KEY (idCliente) REFERENCES Cliente(idCliente),
    FOREIGN KEY (idLojaRetirada) REFERENCES Loja(idLoja)
);

CREATE TABLE Locacao (
    idLocacao INT PRIMARY KEY,
    idReserva INT UNIQUE NOT NULL, 
    placaCarro VARCHAR(7) NOT NULL, 
    dataRealRetirada DATETIME DEFAULT CURRENT_TIMESTAMP,
    dataDevolucaoPrevista DATETIME NOT NULL,
    idLojaDevolucao INT NOT NULL,
    FOREIGN KEY (idReserva) REFERENCES Reserva(idReserva),
    FOREIGN KEY (placaCarro) REFERENCES Carro(placa),
    FOREIGN KEY (idLojaDevolucao) REFERENCES Loja(idLoja)
);

CREATE TABLE Motorista (
    idMotorista INT PRIMARY KEY,
    idLocacao INT NOT NULL UNIQUE,
    nome VARCHAR(100) NOT NULL,
    cnh VARCHAR(20) UNIQUE NOT NULL,
    FOREIGN KEY (idLocacao) REFERENCES Locacao(idLocacao) ON DELETE CASCADE
);

