-- =====================================================================
-- script-ddl.sql | ARMAZÉM LOGÍSTICO (armazembd) - Estrutura (DDL)
-- 1FN: atributos atômicos | 2FN: sem dependência parcial da PK
-- 3FN: sem dependência transitiva entre atributos não-chave
-- =====================================================================
DROP DATABASE IF EXISTS armazembd;
CREATE DATABASE armazembd;
USE armazembd;

-- CLIENTE (1FN): endereço desmembrado; e-mail multivalorado vai p/ tabela própria
CREATE TABLE IF NOT EXISTS cliente (
  idcliente INT UNSIGNED NOT NULL,
  nome      VARCHAR(145) NOT NULL,
  cep       CHAR(8)      NOT NULL, 
  numero    VARCHAR(15)  NOT NULL,
  bairro    VARCHAR(60)  NOT NULL,
  idade     INT          NOT NULL,
  PRIMARY KEY (idcliente),
  CONSTRAINT ck_cliente_idade CHECK (idade >= 18)
) ENGINE = InnoDB;

-- CLIENTE_EMAIL: PK composta evita e-mail repetido; CASCADE apaga junto com o cliente
CREATE TABLE IF NOT EXISTS Cliente_email (
  FK_idcliente INT UNSIGNED NOT NULL,
  email        VARCHAR(95)  NOT NULL,
  tipo         VARCHAR(20)  NOT NULL DEFAULT 'pessoal',
  ativo        BOOLEAN      NOT NULL DEFAULT TRUE,
  PRIMARY KEY (FK_idcliente, email),
  CONSTRAINT fk_cliente_email
    FOREIGN KEY (FK_idcliente) REFERENCES cliente (idcliente)
    ON DELETE CASCADE
) ENGINE = InnoDB;

-- TURNO: horários dependem do turno, não do funcionário (3FN)
CREATE TABLE IF NOT EXISTS Turno (
  idTurno          INT UNSIGNED NOT NULL,
  nome             VARCHAR(30)  NOT NULL UNIQUE,
  hora_inicio      TIME NOT NULL,
  hora_fim         TIME NOT NULL,
  qtd_funcionarios INT UNSIGNED NOT NULL DEFAULT 1,
  PRIMARY KEY (idTurno),
  CONSTRAINT ck_turno_qtd CHECK (qtd_funcionarios > 0)
) ENGINE = InnoDB;

-- FUNCIONARIO (N:1 com Turno): guarda só a FK
CREATE TABLE IF NOT EXISTS funcionario (
  idfuncionario INT UNSIGNED NOT NULL,
  nome          VARCHAR(100) NOT NULL,
  cargo         VARCHAR(45)  NOT NULL,
  CPF           VARCHAR(11)  NOT NULL UNIQUE,
  FK_idturno    INT UNSIGNED NOT NULL,
  PRIMARY KEY (idfuncionario),
  CONSTRAINT idturno
    FOREIGN KEY (FK_idturno) REFERENCES Turno (idTurno)
) ENGINE = InnoDB;

-- PEDIDO (3FN): só FKs; o nome do cliente vem via JOIN
CREATE TABLE IF NOT EXISTS pedido (
  idpedido         INT UNSIGNED NOT NULL,
  preço            DECIMAL(10,2) NOT NULL,
  FK_idcliente     INT UNSIGNED NOT NULL,
  FK_idfuncionario INT UNSIGNED NOT NULL,
  PRIMARY KEY (idpedido),
  CONSTRAINT ck_pedido_preco CHECK (preço >= 0),
  CONSTRAINT fk_idcliente
    FOREIGN KEY (FK_idcliente) REFERENCES cliente (idcliente),
  CONSTRAINT fk_idfuncionario
    FOREIGN KEY (FK_idfuncionario) REFERENCES funcionario (idfuncionario)
) ENGINE = InnoDB;

-- FORNECEDOR: CNPJ (14 dígitos, sem pontuação) como chave natural
CREATE TABLE IF NOT EXISTS fornecedor (
  CNPJ         VARCHAR(14)  NOT NULL,
  razao_social VARCHAR(100) NOT NULL,
  endereço     VARCHAR(145) NOT NULL,
  telefone     VARCHAR(15)  NOT NULL,
  PRIMARY KEY (CNPJ)
) ENGINE = InnoDB;

-- PRODUTO (N:1 com Fornecedor): categoria e estoque dependem só de idproduto
CREATE TABLE IF NOT EXISTS produto (
  idproduto      INT UNSIGNED  NOT NULL,
  nome           VARCHAR(100)  NOT NULL,
  categoria      VARCHAR(45)   NOT NULL,
  preco_unitario DECIMAL(10,2) NOT NULL,
  quantidade     INT UNSIGNED  NOT NULL DEFAULT 0,
  FK_CNPJ        VARCHAR(14)   NOT NULL,
  PRIMARY KEY (idproduto),
  CONSTRAINT ck_produto_preco CHECK (preco_unitario > 0),
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
