# inventario armazem
estudo sobre a criação de um banco de dados esse estudo em especifico e sobre o funcionamento e inventario de um armazem e funcionamento de pedidos feitos para o armazem mostrando a cadeia logica de funcionamento contendo horario e numero de funcionarios presente entre cada periodo

as entidades relacionamentos e atributos são os seguintes:

### Entidade: Cliente

**Relação:** realiza
**Atributos:** CPF (PK), endereço, idade

### Entidade: Pedido

**Relações:** registra, contém
**Atributos:** ID_Pedido (PK), valor

### Entidade: Funcionário

**Relações:** registra, administra, trabalha
**Atributos:** ID_Funcionário (PK), CPF, cargo

### Entidade: Turno

**Relação:** trabalha
**Atributos:** ID_Turno (PK), hora de início, hora de término, dia da semana

### Entidade: Armazém

**Relações:** administra, recebe
**Atributos:** local, telefone, quantidade de produtos, responsável

### Entidade: Produto

**Relações:** contém, fornece
**Atributos:** ID_Produto (PK), nome, categoria

### Entidade: Fornecedor

**Relações:** fornece, recebe
**Atributos:** CNPJ (PK), local, telefone

### Relações e cardinalidades

* **Cliente — realiza — Pedido:** 1:N
* **Funcionário — registra — Pedido:** 1:N
* **Pedido — contém — Produto:** N:N
* **Funcionário — administra — Armazém:** 1:1
* **Funcionário — trabalha — Turno:** N:1
* **Armazém — recebe — Fornecedor:** N:N
* **Produto — fornece — Fornecedor:** N:1
