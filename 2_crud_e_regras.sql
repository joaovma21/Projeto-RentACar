-- POPULAÇÃO INICIAL
INSERT INTO Cidade (idCidade, nome, uf) VALUES (1, 'Belo Horizonte', 'MG');
INSERT INTO Loja (idLoja, nome, idCidade) VALUES (10, 'Aeroporto Confins', 1);
INSERT INTO Loja (idLoja, nome, idCidade) VALUES (11, 'Centro BH', 1);

INSERT INTO Carro (placa, modelo, marca, valorDiaria, status, idLojaAtual) 
VALUES ('AAA1111', 'Gol', 'VW', 90.00, 'LIVRE', 10);
INSERT INTO Carro (placa, modelo, marca, valorDiaria, status, idLojaAtual) 
VALUES ('BBB2222', 'Polo', 'VW', 120.00, 'LIVRE', 11);

INSERT INTO Cliente (idCliente, nome, cpf, cnh) VALUES (1000, 'Carlos Water Falls', '00011122233', '1234567890');
INSERT INTO Cliente (idCliente, nome, cpf, cnh) VALUES (1001, 'Cliente Teste Delete', '99988877766', '111111111');

-- CRUD: SELECT (Read)
SELECT * FROM Carro WHERE status = 'LIVRE';

-- CRUD: UPDATE
UPDATE Carro 
SET valorDiaria = 130.00 
WHERE placa = 'BBB2222';

-- CRUD: DELETE
DELETE FROM Cliente 
WHERE idCliente = 1001;

-- FLUXO DE NEGÓCIO: DO PEDIDO À ALOCAÇÃO

-- 1. Cliente faz o pedido (Reserva)
INSERT INTO Reserva (idReserva, idCliente, dataRetiradaPrevista, idLojaRetirada, periodoDias, valorTotal)
VALUES (500, 1000, '2024-01-10 10:00:00', 11, 7, 630.00);

-- 2. Sistema busca o carro livre mais próximo
SELECT C.placa, C.modelo, L.nome
FROM Carro C
JOIN Loja L ON C.idLojaAtual = L.idLoja
WHERE C.status = 'LIVRE'
  AND L.idCidade = (SELECT idCidade FROM Loja WHERE idLoja = 11)
ORDER BY CASE WHEN L.idLoja = 11 THEN 0 ELSE 1 END ASC
LIMIT 1;

-- 3. Sistema cria a alocação (Locação)
INSERT INTO Locacao (idLocacao, idReserva, placaCarro, dataDevolucaoPrevista, idLojaDevolucao)
VALUES (1000, 500, 'BBB2222', '2024-01-17 10:00:00', 10);

-- 4. Atualiza status do carro para ALUGADO
UPDATE Carro 
SET status = 'ALUGADO' 
WHERE placa = 'BBB2222';

-- 5. Relatório final de conferência
SELECT L.idLocacao, C.nome as Cliente, Car.modelo as CarroAlocado, Car.status
FROM Locacao L
JOIN Reserva R ON L.idReserva = R.idReserva
JOIN Cliente C ON R.idCliente = C.idCliente
JOIN Carro Car ON L.placaCarro = Car.placa;
