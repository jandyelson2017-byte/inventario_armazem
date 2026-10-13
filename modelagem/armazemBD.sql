create database if not exists armazembd;
use armazembd;

CREATE TABLE IF NOT EXISTS cliente  (
   idcliente  INT UNSIGNED NOT NULL,
   nome  VARCHAR(145) NOT NULL,
   endereço  VARCHAR(145) NOT NULL,
   idade  INT NOT NULL,
  PRIMARY KEY ( idcliente ),
  UNIQUE INDEX  idcliente_UNIQUE  ( idcliente  ASC) VISIBLE)
ENGINE = InnoDB;


CREATE TABLE IF NOT EXISTS Turno  (
   idTurno  INT UNSIGNED NOT NULL,
   hora_inicio  TIME NULL,
   hora_fim  TIME NULL,
  PRIMARY KEY ( idTurno ),
  UNIQUE INDEX  idTurno_UNIQUE  ( idTurno  ASC) VISIBLE)
ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS funcionario  (
   idfuncionario  INT UNSIGNED NOT NULL,
   cargo  VARCHAR(45) NOT NULL,
   CPF  VARCHAR(11) NULL,
   FK_idturno  INT UNSIGNED NOT NULL,
  PRIMARY KEY ( idfuncionario ),
  UNIQUE INDEX  idturno_UNIQUE  ( FK_idturno  ASC) VISIBLE,
  CONSTRAINT  idturno 
    FOREIGN KEY ( FK_idturno )
    REFERENCES Turno  ( idTurno )
)
ENGINE = InnoDB;


CREATE TABLE IF NOT EXISTS pedido  (
   idpedido  INT UNSIGNED NOT NULL,
   preço  INT UNSIGNED NOT NULL,
   FK_idcliente  INT UNSIGNED NOT NULL,
   FK_idfuncionario  INT UNSIGNED NOT NULL,
  PRIMARY KEY ( idpedido ),
  UNIQUE INDEX  idpedido_UNIQUE  ( idpedido  ASC) VISIBLE,
  UNIQUE INDEX  preço_UNIQUE  ( preço  ASC) VISIBLE,
  CONSTRAINT  idcliente 
    FOREIGN KEY ( FK_idcliente )
    REFERENCES cliente  ( idcliente )
     
     ,
  CONSTRAINT  fk_idfuncionario 
    FOREIGN KEY ( FK_idfuncionario )
    REFERENCES funcionario  ( idfuncionario )
)
ENGINE = InnoDB;



CREATE TABLE IF NOT EXISTS fornecedor  (
   CNPJ  VARCHAR(14) NOT NULL,
   endereço  VARCHAR(145) NOT NULL,
   telefone  VARCHAR(15) NOT NULL,
  PRIMARY KEY ( CNPJ )
)
ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS produto  (
   idproduto  INT UNSIGNED NOT NULL,
   categoria  VARCHAR(45) NOT NULL,
   quantidade  INT UNSIGNED NOT NULL,
   FK_CNPJ  VARCHAR(14) NOT NULL,
  PRIMARY KEY ( idproduto ),
  UNIQUE INDEX  idproduto_UNIQUE  ( idproduto  ASC) VISIBLE,
  CONSTRAINT  CNPJ 
    FOREIGN KEY ( FK_CNPJ )
    REFERENCES fornecedor  ( CNPJ )
)
ENGINE = InnoDB;


CREATE TABLE IF NOT EXISTS armazem  (
   idarmazem  INT UNSIGNED NOT NULL,
   local  VARCHAR(145) NOT NULL,
   telefone  VARCHAR(15) NOT NULL,
   qtd_produtos  INT UNSIGNED NOT NULL,
   FK_idfuncionario  INT UNSIGNED NOT NULL,
  PRIMARY KEY ( idarmazem ),
  UNIQUE INDEX  idarmazem_UNIQUE  ( idarmazem  ASC) VISIBLE,
  CONSTRAINT  idfuncionario 
    FOREIGN KEY ( FK_idfuncionario )
    REFERENCES funcionario  ( idfuncionario )
)
ENGINE = InnoDB;


CREATE TABLE IF NOT EXISTS recebe  (
   FK_idarmazen  INT UNSIGNED NOT NULL,
   qtd_recebida  INT UNSIGNED NOT NULL,
  CONSTRAINT  idarmazem 
    FOREIGN KEY ( FK_idarmazen )
    REFERENCES armazem  ( idarmazem )
)
ENGINE = InnoDB;


CREATE TABLE IF NOT EXISTS contem  (
   idpedido  INT UNSIGNED NOT NULL,
   idproduto  INT UNSIGNED NOT NULL,
   qtd_itens  INT UNSIGNED NOT NULL,
  UNIQUE INDEX  idpedido_UNIQUE  ( idpedido  ASC) VISIBLE,
  PRIMARY KEY ( idpedido ,  idproduto ),
  UNIQUE INDEX  idproduto_UNIQUE  ( idproduto  ASC) VISIBLE,
  CONSTRAINT  idpedido 
    FOREIGN KEY ( idpedido )
    REFERENCES pedido  ( idpedido )
     
     ,
  CONSTRAINT  idproduto 
    FOREIGN KEY ( idproduto )
    REFERENCES produto  ( idproduto )
     
     )
ENGINE = InnoDB;

