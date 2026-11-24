-- =====================================================================
-- script-dml.sql | Povoamento orientado a cenários (armazembd)
-- Executar depois do script-ddl.sql
-- =====================================================================
USE armazembd;

-- =====================================================================
-- Cenário 1 — Configuração Inicial (Dados Base):
-- Antes de iniciar a operação, a diretoria definiu os cinco turnos,
-- contratou a equipe (um gerente para cada armazém e atendentes),
-- cadastrou os fornecedores e montou o catálogo inicial de produtos
-- (Eletrônicos, Ferramentas, Embalagens, Higiene e Limpeza e
-- Alimentos) com preços e fornecedores.
-- =====================================================================

INSERT INTO Turno (idTurno, nome, hora_inicio, hora_fim, qtd_funcionarios) VALUES
(1, 'Manhã',          '06:00:00', '14:00:00', 6),
(2, 'Tarde',          '14:00:00', '22:00:00', 5),
(3, 'Noite',          '22:00:00', '06:00:00', 3),
(4, 'Administrativo', '08:00:00', '17:00:00', 4),
(5, 'Fim de semana',  '07:00:00', '15:00:00', 4);

-- ids 1 a 5: gerentes dos armazéns | 6 a 8: operação
INSERT INTO funcionario (idfuncionario, nome, cargo, CPF, FK_idturno) VALUES
(1, 'Carlos Mendes',   'Gerente de Armazém',       '11122233301', 4),
(2, 'Patrícia Gomes',  'Gerente de Armazém',       '11122233302', 4),
(3, 'Ricardo Barros',  'Gerente de Armazém',       '11122233303', 4),
(4, 'Sandra Nogueira', 'Gerente de Armazém',       '11122233304', 4),
(5, 'Helena Duarte',   'Gerente de Armazém',       '11122233305', 4),
(6, 'Ana Paula Souza', 'Atendente de Pedidos',     '11122233306', 1),
(7, 'Fernanda Costa',  'Atendente de Pedidos',     '11122233307', 2),
(8, 'Roberto Lima',    'Operador de Empilhadeira', '11122233308', 2);

INSERT INTO fornecedor (CNPJ, razao_social, endereço, telefone) VALUES
('11222333000181', 'TecnoImport Distribuidora Ltda',    'Av. Industrial, 1000 - Recife/PE',     '8132011000'),
('22333444000172', 'FerraMax Ferramentas S.A.',         'Rua das Oficinas, 250 - Fortaleza/CE', '8532022000'),
('33444555000163', 'EmbalaPlus Embalagens Ltda',        'Av. Hermes da Fonseca, 800 - Natal/RN','8433033000'),
('44555666000154', 'LimpaBem Produtos de Limpeza Ltda', 'Rua do Comércio, 45 - Mossoró/RN',     '8433044000'),
('55666777000145', 'Grãos do Sertão Alimentos Ltda',    'BR-226, km 12 - Caicó/RN',             '8434055000');

INSERT INTO produto (idproduto, nome, categoria, preco_unitario, quantidade, FK_CNPJ) VALUES
(1, 'Fone de Ouvido Bluetooth',           'Eletrônicos',       129.90, 200, '11222333000181'),
(2, 'Carregador USB-C 20W',               'Eletrônicos',        59.90, 350, '11222333000181'),
(3, 'Furadeira de Impacto 650W',          'Ferramentas',       289.00,  80, '22333444000172'),
(4, 'Jogo de Chaves de Fenda 12 peças',   'Ferramentas',        45.50, 150, '22333444000172'),
(5, 'Caixa de Papelão 40x30x30 (pct 25)', 'Embalagens',         98.00, 120, '33444555000163'),
(6, 'Fita Adesiva 48mm (caixa 36 un)',    'Embalagens',        112.00,  90, '33444555000163'),
(7, 'Detergente Neutro 500ml (cx 12)',    'Higiene e Limpeza',  38.40, 400, '44555666000154'),
(8, 'Arroz Tipo 1 5kg (fardo 6)',         'Alimentos',         189.00,  60, '55666777000145');

-- =====================================================================
-- Cenário 2 — Inauguração dos Armazéns e Recebimento de Mercadoria:
-- Cada armazém foi entregue a um gerente. Na última semana de
-- setembro, os fornecedores entregaram o estoque inicial, e cada
-- recebimento foi registrado com produto, quantidade e data.
-- (qtd_produtos de cada armazém: soma das 1.450 unidades em estoque)
-- =====================================================================

INSERT INTO armazem (idarmazem, local, telefone, qtd_produtos, FK_idfuncionario) VALUES
(1, 'Galpão Central - Natal/RN',          '8433330001', 490, 1),
(2, 'Galpão Norte - Mossoró/RN',          '8433330002', 250, 2),
(3, 'Galpão Litoral - Parnamirim/RN',     '8433330003', 500, 3),
(4, 'Galpão Seridó - Caicó/RN',           '8433330004',  60, 4),
(5, 'Galpão Agreste - Currais Novos/RN',  '8433330005', 150, 5);

INSERT INTO recebe (idrecebimento, FK_idarmazen, FK_idproduto, qtd_recebida, data_recebimento) VALUES
(1, 1, 1, 200, '2026-09-28'),
(2, 1, 3,  80, '2026-09-28'),
(3, 1, 5, 120, '2026-09-29'),
(4, 1, 6,  90, '2026-09-29'),
(5, 2, 7, 250, '2026-09-29'),
(6, 3, 2, 350, '2026-09-30'),
(7, 3, 4, 150, '2026-09-30'),
(8, 4, 8,  60, '2026-10-01'),
(9, 5, 7, 150, '2026-10-01');
-- =====================================================================
-- Cenário 3 — Chegada dos Primeiros Clientes e Cadastros:
-- Na primeira semana de outubro, cinco clientes se cadastraram:
-- José Silva (15/04/1990), Maria Oliveira (22/08/1985), Pedro Santos
-- (03/11/1978), Ana Beatriz Lima (30/01/1995) e Lucas Ferreira
-- (09/07/2000). A idade abaixo é a de outubro de 2026. Alguns
-- informaram mais de um e-mail de contato.
-- =====================================================================

INSERT INTO cliente (idcliente, nome, cep, numero, bairro, idade) VALUES
(1, 'José Silva',       '59010000', '120', 'Centro',       36),
(2, 'Maria Oliveira',   '59020000', '45',  'Tirol',        41),
(3, 'Pedro Santos',     '59012000', '310', 'Petrópolis',   47),
(4, 'Ana Beatriz Lima', '59078000', '88',  'Capim Macio',  31),
(5, 'Lucas Ferreira',   '59054000', '2050','Lagoa Nova',   26);

INSERT INTO Cliente_email (FK_idcliente, email, tipo, ativo) VALUES
(1, 'jose.silva@email.com',       'pessoal',  TRUE),
(1, 'jose.silva@empresa.com.br',  'trabalho', TRUE),
(2, 'maria.oliveira@email.com',   'pessoal',  TRUE),
(3, 'pedro.santos@email.com',     'pessoal',  TRUE),
(4, 'anabeatriz.lima@email.com',  'pessoal',  TRUE),
(4, 'ab.lima@loja.com.br',        'trabalho', FALSE),
(5, 'lucas.ferreira@email.com',   'pessoal',  TRUE);

-- =====================================================================
-- Cenário 4 — Primeiros Pedidos da Semana:
-- Os atendentes registraram os seis primeiros pedidos entre os dias
-- 05 e 10 de outubro (ids em ordem cronológica). O valor de cada
-- pedido é a soma dos seus itens (ver Cenário 5).
-- =====================================================================

INSERT INTO pedido (idpedido, preço, FK_idcliente, FK_idfuncionario) VALUES
(101, 439.50, 1, 6),   -- 05/10 manhã
(102, 380.00, 2, 7),   -- 05/10 tarde
(103, 616.00, 3, 6),   -- 06/10
(104, 570.00, 4, 7),   -- 07/10
(105, 614.90, 5, 7),   -- 08/10
(106, 643.80, 1, 6);   -- 10/10 (segundo pedido do José Silva)

-- =====================================================================
-- Cenário 5 — Itens dos Pedidos:
-- Cada pedido foi detalhado com produtos e quantidades, guardando
-- o preço praticado no dia da compra.
-- =====================================================================

INSERT INTO contem (idpedido, idproduto, qtd_itens, preco_unitario) VALUES
(101, 1, 2, 129.90),
(101, 2, 3,  59.90),
(102, 3, 1, 289.00),
(102, 4, 2,  45.50),
(103, 5, 4,  98.00),
(103, 6, 2, 112.00),
(104, 7, 5,  38.40),
(104, 8, 2, 189.00),
(105, 1, 1, 129.90),
(105, 3, 1, 289.00),
(105, 5, 2,  98.00),
(106, 8, 3, 189.00),
(106, 7, 2,  38.40);

-- =====================================================================
-- (Seus SELECT / UPDATE / DELETE de exemplo continuam valendo aqui.)
-- Ex.: reposição de 30 unidades do produto 1 após as vendas:
-- UPDATE produto SET quantidade = quantidade + 30 WHERE idproduto = 1;
-- =====================================================================
