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

-- DML: SIMULAÇÃO DE DADOS

-- CIDADES
INSERT INTO Cidade (idCidade, nome, uf) VALUES (1, 'Belo Horizonte', 'MG');

-- LOJAS
INSERT INTO Loja (idLoja, nome, idCidade) VALUES (10, 'Aeroporto Confins', 1);
INSERT INTO Loja (idLoja, nome, idCidade) VALUES (11, 'Centro BH', 1);

-- CARROS
INSERT INTO Carro (placa, modelo, marca, valorDiaria, status, idLojaAtual) 
VALUES ('AAA1111', 'Gol', 'VW', 90.00, 'LIVRE', 10);
INSERT INTO Carro (placa, modelo, marca, valorDiaria, status, idLojaAtual) 
VALUES ('BBB2222', 'Polo', 'VW', 120.00, 'LIVRE', 11);

-- CLIENTE
INSERT INTO Cliente (idCliente, nome, cpf, cnh) VALUES (1000, 'Carlos Water Falls', '00011122233', '1234567890');

-- 1. RESERVA
INSERT INTO Reserva (idReserva, idCliente, dataRetiradaPrevista, idLojaRetirada, periodoDias, valorTotal)
VALUES (500, 1000, '2024-01-10 10:00:00', 11, 7, 630.00);

-- 2. ALOCAÇÃO INTELIGENTE (Busca o carro mais perto - Regra de Negócio)
SELECT 
    C.placa, L.nome as LojaLocalizacao
FROM Carro C
JOIN Loja L ON C.idLojaAtual = L.idLoja
WHERE C.status = 'LIVRE'
  AND L.idCidade = (SELECT idCidade FROM Loja WHERE idLoja = 11)
ORDER BY 
    CASE WHEN L.idLoja = 11 THEN 0 ELSE 1 END ASC
LIMIT 1;

-- 3. LOCAÇÃO (Execução)
INSERT INTO Locacao (idLocacao, idReserva, placaCarro, dataDevolucaoPrevista, idLojaDevolucao)
VALUES (1000, 500, 'BBB2222', '2024-01-17 10:00:00', 10);

-- 4. INCLUSÃO DE MOTORISTA
INSERT INTO Motorista (idMotorista, idLocacao, nome, cnh)
VALUES (200, 1000, 'Maria Auxiliar', '98765432100'); 

-- 5. ATUALIZAR STATUS
UPDATE Carro SET status = 'ALUGADO' WHERE placa = 'BBB2222';

-- 6. RELATÓRIO ESTATÍSTICO
SELECT R.periodoDias, COUNT(L.idLocacao) AS TotalLocacoes
FROM Locacao L
JOIN Reserva R ON L.idReserva = R.idReserva
GROUP BY R.periodoDias;
