-- =====================================================================
-- ARMAZÉM LOGÍSTICO (armazembd) - DER -> SQL, normalização e DML
-- 1FN: atributos atômicos | 2FN: sem dependência parcial da PK
-- 3FN: sem dependência transitiva entre atributos não-chave
-- =====================================================================
CREATE DATABASE IF NOT EXISTS armazembd;
USE armazembd;

-- CLIENTE (1FN): endereço desmembrado; e-mail multivalorado vai p/ tabela própria
CREATE TABLE IF NOT EXISTS cliente (
  idcliente INT UNSIGNED NOT NULL,
  nome      VARCHAR(145) NOT NULL,
  cep       CHAR(8)      NOT NULL,   -- sem hífen
  numero    VARCHAR(10)  NOT NULL,
  bairro    VARCHAR(60)  NOT NULL,
  idade     INT          NOT NULL,
  PRIMARY KEY (idcliente)
) ENGINE = InnoDB;

-- CLIENTE_EMAIL: PK composta evita e-mail repetido; CASCADE apaga junto com o cliente
CREATE TABLE IF NOT EXISTS Cliente_email (
  FK_idcliente INT UNSIGNED NOT NULL,
  email        VARCHAR(95)  NOT NULL,
  PRIMARY KEY (FK_idcliente, email),
  CONSTRAINT fk_cliente_email
    FOREIGN KEY (FK_idcliente) REFERENCES cliente (idcliente)
    ON DELETE CASCADE
) ENGINE = InnoDB;

-- TURNO: horários dependem do turno, não do funcionário (3FN)
CREATE TABLE IF NOT EXISTS Turno (
  idTurno     INT UNSIGNED NOT NULL,
  hora_inicio TIME NULL,
  hora_fim    TIME NULL,
  PRIMARY KEY (idTurno)
) ENGINE = InnoDB;

-- FUNCIONARIO (N:1 com Turno): guarda só a FK
CREATE TABLE IF NOT EXISTS funcionario (
  idfuncionario INT UNSIGNED NOT NULL,
  cargo         VARCHAR(45)  NOT NULL,
  CPF           VARCHAR(11)  NULL,
  FK_idturno    INT UNSIGNED NOT NULL,
  PRIMARY KEY (idfuncionario),
  CONSTRAINT idturno
    FOREIGN KEY (FK_idturno) REFERENCES Turno (idTurno)
) ENGINE = InnoDB;

-- PEDIDO (3FN): só FKs; o nome do cliente vem via JOIN
-- (preço é derivável dos itens)
CREATE TABLE IF NOT EXISTS pedido (
  idpedido         INT UNSIGNED NOT NULL,
  preço            INT UNSIGNED NOT NULL,
  FK_idcliente     INT UNSIGNED NOT NULL,
  FK_idfuncionario INT UNSIGNED NOT NULL,
  PRIMARY KEY (idpedido),
  CONSTRAINT fk_idcliente
    FOREIGN KEY (FK_idcliente) REFERENCES cliente (idcliente),
  CONSTRAINT fk_idfuncionario
    FOREIGN KEY (FK_idfuncionario) REFERENCES funcionario (idfuncionario)
) ENGINE = InnoDB;

-- FORNECEDOR: CNPJ (14 dígitos, sem pontuação) como chave natural
CREATE TABLE IF NOT EXISTS fornecedor (
  CNPJ     VARCHAR(14)  NOT NULL,
  endereço VARCHAR(145) NOT NULL,
  telefone VARCHAR(15)  NOT NULL,
  PRIMARY KEY (CNPJ)
) ENGINE = InnoDB;

-- PRODUTO (N:1 com Fornecedor): categoria e estoque dependem só de idproduto
CREATE TABLE IF NOT EXISTS produto (
  idproduto  INT UNSIGNED NOT NULL,
  categoria  VARCHAR(45)  NOT NULL,
  quantidade INT UNSIGNED NOT NULL,
  FK_CNPJ    VARCHAR(14)  NOT NULL,
  PRIMARY KEY (idproduto),
  CONSTRAINT CNPJ
    FOREIGN KEY (FK_CNPJ) REFERENCES fornecedor (CNPJ)
) ENGINE = InnoDB;

-- ARMAZEM: um funcionário responsável (N:1); qtd_produtos é derivável
CREATE TABLE IF NOT EXISTS armazem (
  idarmazem        INT UNSIGNED NOT NULL,
  local            VARCHAR(145) NOT NULL,
  telefone         VARCHAR(15)  NOT NULL,
  qtd_produtos     INT UNSIGNED NOT NULL,
  FK_idfuncionario INT UNSIGNED NOT NULL,
  PRIMARY KEY (idarmazem),
  CONSTRAINT idfuncionario
    FOREIGN KEY (FK_idfuncionario) REFERENCES funcionario (idfuncionario)
) ENGINE = InnoDB;

-- RECEBE: quantidades recebidas por armazém (sem PK; melhoria: id próprio e FK de produto)
CREATE TABLE IF NOT EXISTS recebe (
  FK_idarmazen INT UNSIGNED NOT NULL,
  qtd_recebida INT UNSIGNED NOT NULL,
  CONSTRAINT idarmazem
    FOREIGN KEY (FK_idarmazen) REFERENCES armazem (idarmazem)
) ENGINE = InnoDB;

-- CONTEM (2FN, N:M Pedido x Produto): qtd_itens depende do par inteiro;
-- categoria fica em PRODUTO
CREATE TABLE IF NOT EXISTS contem (
  idpedido  INT UNSIGNED NOT NULL,
  idproduto INT UNSIGNED NOT NULL,
  qtd_itens INT UNSIGNED NOT NULL,
  PRIMARY KEY (idpedido, idproduto),
  CONSTRAINT idpedido
    FOREIGN KEY (idpedido) REFERENCES pedido (idpedido),
  CONSTRAINT idproduto
    FOREIGN KEY (idproduto) REFERENCES produto (idproduto)
) ENGINE = InnoDB;

-- =====================================================================
-- INSERTS: um exemplo por tabela (tabelas "pai" antes das "filhas")
-- =====================================================================
INSERT INTO cliente (idcliente, nome, cep, numero, bairro, idade)
VALUES (1, 'Ana Souza', '59000000', '120', 'Centro', 28);

INSERT INTO Cliente_email (FK_idcliente, email)
VALUES (1, 'ana.souza@email.com');

INSERT INTO Turno (idTurno, hora_inicio, hora_fim)
VALUES (1, '06:00:00', '14:00:00');

INSERT INTO funcionario (idfuncionario, cargo, CPF, FK_idturno)
VALUES (1, 'Gerente', '11111111111', 1);

INSERT INTO pedido (idpedido, preço, FK_idcliente, FK_idfuncionario)
VALUES (101, 250, 1, 1);

INSERT INTO fornecedor (CNPJ, endereço, telefone)
VALUES ('12345678000190', 'Av. Industrial, 1000 - Natal/RN', '84999990001');

INSERT INTO produto (idproduto, categoria, quantidade, FK_CNPJ)
VALUES (1, 'Eletrônicos', 50, '12345678000190');

INSERT INTO armazem (idarmazem, local, telefone, qtd_produtos, FK_idfuncionario)
VALUES (1, 'Galpão Central - Natal/RN', '8433330001', 405, 1);

INSERT INTO recebe (FK_idarmazen, qtd_recebida) VALUES (1, 100);

INSERT INTO contem (idpedido, idproduto, qtd_itens) VALUES (101, 1, 1);

-- =====================================================================
-- CONSULTAS
-- =====================================================================

-- INNER JOIN: pedido com cliente e atendente (ON liga FK à PK)
SELECT p.idpedido AS 'Pedido', c.nome AS 'Cliente',
       f.cargo AS 'Atendente', p.preço AS 'Valor'
FROM pedido p
INNER JOIN cliente c     ON p.FK_idcliente     = c.idcliente
INNER JOIN funcionario f ON p.FK_idfuncionario = f.idfuncionario
ORDER BY p.idpedido;

-- GROUP BY: pedidos e itens por cliente
SELECT c.nome AS 'Cliente',
       COUNT(DISTINCT p.idpedido) AS 'Pedidos',
       SUM(ct.qtd_itens)          AS 'Itens'
FROM cliente c
INNER JOIN pedido p  ON c.idcliente = p.FK_idcliente
INNER JOIN contem ct ON p.idpedido  = ct.idpedido
GROUP BY c.idcliente, c.nome
ORDER BY `Itens` DESC;

-- =====================================================================
-- UPDATE E DELETE (sempre com WHERE)
-- =====================================================================
-- Reposição de estoque: +30 unidades no produto 1
UPDATE produto SET quantidade = quantidade + 30 WHERE idproduto = 1;

-- Remove um e-mail específico
DELETE FROM Cliente_email
WHERE FK_idcliente = 1 AND email = 'ana.souza@email.com';
