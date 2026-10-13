# Inventário de Armazém

Estudo sobre a modelagem de um banco de dados para o controle de inventário e o fluxo de pedidos de um armazém logístico. O trabalho apresenta a cadeia lógica de funcionamento da operação, detalhando os horários de cada turno e o número de funcionários presentes em cada período.

# 1. Contexto do Minimundo

Este projeto tem como objetivo aprimorar a gestão de armazéns logísticos por meio de um banco de dados que centraliza o controle de estoque e de pedidos. O sistema deverá permitir:

* Registrar e acompanhar o inventário, informando a quantidade disponível de cada produto;
* Gerenciar os pedidos recebidos, definindo quais produtos serão separados e despachados;
* Identificar produtos com estoque baixo, para que seja feito o pedido de reposição aos fornecedores no momento adequado;
* Organizar a equipe de trabalho, relacionando horários de funcionamento e quantidade de funcionários por período às etapas da operação.

# as entidades relacionamentos e atributos são os seguintes:

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
