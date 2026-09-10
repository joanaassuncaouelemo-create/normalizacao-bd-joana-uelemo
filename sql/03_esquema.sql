1. CRIAÇÃO DAS TABELAS (DDL)
-- ---------------------------------------------------------------------

DROP TABLE IF EXISTS telefone;
DROP TABLE IF EXISTS filho;
DROP TABLE IF EXISTS funcionario;
DROP TABLE IF EXISTS posto_trabalho;
DROP TABLE IF EXISTS funcao;
DROP TABLE IF EXISTS cargo;
DROP TABLE IF EXISTS cidade;

CREATE TABLE cidade (
    id_cidade     INT PRIMARY KEY AUTO_INCREMENT,
    nome_cidade   VARCHAR(100) NOT NULL,
    provincia     VARCHAR(100) NOT NULL,
    pais          VARCHAR(100) NOT NULL DEFAULT 'Moçambique'
);

CREATE TABLE cargo (
    cod_cargo     CHAR(3) PRIMARY KEY,
    nome_cargo    VARCHAR(100) NOT NULL
);

CREATE TABLE funcao (
    cod_funcao    CHAR(3) PRIMARY KEY,
    nome_funcao   VARCHAR(100) NOT NULL
);

CREATE TABLE posto_trabalho (
    id_posto      INT PRIMARY KEY AUTO_INCREMENT,
    nome_posto    VARCHAR(100) NOT NULL,
    id_cidade     INT NOT NULL,
    CONSTRAINT fk_posto_cidade
        FOREIGN KEY (id_cidade) REFERENCES cidade(id_cidade)
);

CREATE TABLE funcionario (
    nuit                    CHAR(9)      PRIMARY KEY,
    nome                    VARCHAR(150) NOT NULL,
    data_nasc               DATE         NOT NULL,
    bi                      VARCHAR(20)  NOT NULL UNIQUE,
    email                   VARCHAR(150) NOT NULL UNIQUE,
    rua                     VARCHAR(150),
    numero                  VARCHAR(10),
    bairro                  VARCHAR(100),
    id_cidade_residencia    INT NOT NULL,
    cod_cargo               CHAR(3) NOT NULL,
    cod_funcao              CHAR(3) NOT NULL,
    id_posto                INT NOT NULL,
    data_admissao           DATE NOT NULL,
    CONSTRAINT fk_func_cidade
        FOREIGN KEY (id_cidade_residencia) REFERENCES cidade(id_cidade),
    CONSTRAINT fk_func_cargo
        FOREIGN KEY (cod_cargo) REFERENCES cargo(cod_cargo),
    CONSTRAINT fk_func_funcao
        FOREIGN KEY (cod_funcao) REFERENCES funcao(cod_funcao),
    CONSTRAINT fk_func_posto
        FOREIGN KEY (id_posto) REFERENCES posto_trabalho(id_posto)
);

CREATE TABLE filho (
    id_filho          INT PRIMARY KEY AUTO_INCREMENT,
    nuit_funcionario  CHAR(9) NOT NULL,
    nome_filho        VARCHAR(150) NOT NULL,
    CONSTRAINT fk_filho_funcionario
        FOREIGN KEY (nuit_funcionario) REFERENCES funcionario(nuit)
        ON DELETE CASCADE
);

CREATE TABLE telefone (
    id_telefone       INT PRIMARY KEY AUTO_INCREMENT,
    nuit_funcionario  CHAR(9) NOT NULL,
    numero_celular    VARCHAR(20) NOT NULL,
    CONSTRAINT fk_telefone_funcionario
        FOREIGN KEY (nuit_funcionario) REFERENCES funcionario(nuit)
        ON DELETE CASCADE
);

-- ---------------------------------------------------------------------
-- 2. DADOS DE EXEMPLO (subconjunto ilustrativo)
--    Nota: transcritos a partir da imagem fornecida; confirmar valores
--    exatos de NUIT/BI/celulares contra o ficheiro Excel original.
-- ---------------------------------------------------------------------

INSERT INTO cidade (nome_cidade, provincia, pais) VALUES
 ('Maputo', 'Maputo Cidade', 'Moçambique'),
 ('Matola', 'Maputo Província', 'Moçambique'),
 ('Chókwè', 'Gaza', 'Moçambique'),
 ('Maxixe', 'Inhambane', 'Moçambique'),
 ('Beira', 'Sofala', 'Moçambique'),
 ('Nampula', 'Nampula', 'Moçambique'),
 ('Chimoio', 'Manica', 'Moçambique'),
 ('Tete', 'Tete', 'Moçambique'),
 ('Quelimane', 'Zambézia', 'Moçambique'),
 ('Pemba', 'Cabo Delgado', 'Moçambique');

INSERT INTO cargo (cod_cargo, nome_cargo) VALUES
 ('C01', 'Técnico(a) de Informática'),
 ('C02', 'Contabilista'),
 ('C03', 'Engenheiro(a) Civil'),
 ('C04', 'Enfermeiro(a)'),
 ('C05', 'Professor(a)'),
 ('C06', 'Motorista'),
 ('C07', 'Gestor(a) de Recursos Humanos'),
 ('C08', 'Assistente Administrativo(a)');

INSERT INTO funcao (cod_funcao, nome_funcao) VALUES
 ('F01', 'Tecnologias de Informação'),
 ('F02', 'Finanças'),
 ('F03', 'Engenharia'),
 ('F04', 'Saúde'),
 ('F05', 'Educação'),
 ('F06', 'Logística'),
 ('F07', 'Recursos Humanos'),
 ('F08', 'Administração');

INSERT INTO posto_trabalho (nome_posto, id_cidade) VALUES
 ('Sede Maputo', 1),
 ('Delegação Matola', 2),
 ('Delegação Gaza', 3),
 ('Delegação Inhambane', 4),
 ('Delegação Beira', 5),
 ('Delegação Nampula', 6),
 ('Delegação Manica', 7),
 ('Delegação Tete', 8),
 ('Delegação Zambézia', 9),
 ('Delegação Cabo Delgado', 10);

INSERT INTO funcionario
 (nuit, nome, data_nasc, bi, email, rua, numero, bairro,
  id_cidade_residencia, cod_cargo, cod_funcao, id_posto, data_admissao)
VALUES
 ('100234567', 'Amélia Fernanda Cossa', '1985-03-12', '111012072345A', 'amelia.cossa@empresa.co.mz', 'Av. Júlio Nyerere', '245', 'Sommerschield', 1, 'C01', 'F01', 1, '2019-02-09'),
 ('100349678', 'Bernardo Alfredo Machava', '1979-07-22', '110102345678', 'bernardo.machava@empresa.co.mz', 'Rua da Resistência', '8', 'Polana Caniço', 1, 'C02', 'F02', 1, '2010-09-14'),
 ('100456789', 'Celina Armanda Sitoe', '1990-11-03', '112003456789C', 'celina.sitoe@empresa.co.mz', 'Av. Samora Machel', '12', 'Fomento', 2, 'C08', 'F08', 2, '2018-06-01'),
 ('100567890', 'Domingos Paulo Nhantumbo', '1982-01-30', '113004567890D', 'domingos.nhantumbo@empresa.co.mz', 'Rua 3', '56', 'Chókwè-Sede', 3, 'C06', 'F06', 3, '2012-03-10'),
 ('100678901', 'Eugénia Marta Muchanga', '1988-09-18', '114005678901E', 'eugenia.muchanga@empresa.co.mz', 'Av. Eduardo Mondlane', '321', 'Maxixe-Sede', 4, 'C04', 'F04', 4, '2016-08-20'),
 ('100789012', 'Fernando José Macuácua', '1975-09-25', '115006789012F', 'fernando.macuacua@empresa.co.mz', 'Av. Poder Popular', '77', 'Macuti', 5, 'C03', 'F03', 5, '2008-01-15'),
 ('100890123', 'Graça Isabel Zungue', '1992-12-07', '116007890123G', 'graca.zungue@empresa.co.mz', 'Rua da Frescura', '19', 'Ponta Gêa', 5, 'C05', 'F05', 5, '2019-02-02'),
 ('100901234', 'Hélder António Cuamba', '1980-04-14', '117008901234H', 'helder.cuamba@empresa.co.mz', 'Av. 25 de Setembro', '150', 'Alto Maé', 1, 'C07', 'F07', 1, '2011-11-15'),
 ('101012345', 'Ivete Sara Chirindza', '1995-06-29', '118009012345I', 'ivete.chirindza@empresa.co.mz', 'Rua do Bagamoyo', '5', 'Muhipiti', 6, 'C01', 'F01', 6, '2020-07-03'),
 ('101123456', 'João Baptista Nhaca', '1978-08-09', '119000123456J', 'joao.nhaca@empresa.co.mz', 'Av. Josina Machel', '200', 'Nanhurwa', 6, 'C02', 'F02', 6, '2009-09-25'),
 ('101234567', 'Lúcia Ermelinda Bila', '1991-02-16', '111000123456K', 'lucia.bila@empresa.co.mz', 'Rua da Base', '33', 'Chamite', 5, 'C08', 'F08', 5, '2017-09-16'),
 ('101345678', 'Marcelino Inácio Tembe', '1983-10-27', '111102345678L', 'marcelino.tembe@empresa.co.mz', 'Av. Kwame Nkrumah', '413', 'Coop', 1, 'C03', 'F03', 1, '2013-04-08'),
 ('101456789', 'Noémia Abíss Massingue', '1987-03-06', '112003456789M', 'noemia.massingue@empresa.co.mz', 'Rua de Chimoio', '87', 'Chinguassura', 7, 'C04', 'F04', 7, '2014-12-12'),
 ('101567890', 'Osvaldo Simão Ubisse', '1976-07-27', '113004567890N', 'osvaldo.ubisse@empresa.co.mz', 'Av. 7 de Setembro', '90', 'Matundo', 8, 'C06', 'F06', 8, '2006-10-30'),
 ('101678901', 'Paulina Fátima Uache', '1993-01-15', '114005678900O', 'paulina.uache@empresa.co.mz', 'Rua da Missão', '24', 'Chaluua', 9, 'C05', 'F05', 9, '2021-09-09'),
 ('101789012', 'Ricardo Manuel Come', '1981-06-02', '115006789019P', 'ricardo.come@empresa.co.mz', 'Av. Franqueza', '18', 'Chuvauia', 10, 'C07', 'F07', 10, '2010-07-17');

INSERT INTO filho (nuit_funcionario, nome_filho) VALUES
 ('100234567', 'Célia Cossa'),
 ('100349678', 'Nelson Machava'),
 ('100349678', 'Ivete Machava'),
 ('100349678', 'Suzana Machava'),
 ('100567890', 'Paulo Nhantumbo Jr.'),
 ('100567890', 'Alzira Nhantumbo'),
 ('100678901', 'Marta Muchanga'),
 ('100789012', 'José Macuácua'),
 ('100789012', 'Beatriz Macuácua'),
 ('100789012', 'Adriano Macuácua'),
 ('100901234', 'António Cuamba Jr.'),
 ('100901234', 'Filomena Cuamba'),
 ('101123456', 'Baptista Nhaca Jr.'),
 ('101234567', 'Ermelinda Bila'),
 ('101345678', 'Inácio Tembe Jr.'),
 ('101345678', 'Rosa Tembe'),
 ('101567890', 'Simão Ubisse Jr.'),
 ('101567890', 'Alcinda Ubisse'),
 ('101567890', 'Custódio Ubisse'),
 ('101789012', 'Manuel Come Jr.');

INSERT INTO telefone (nuit_funcionario, numero_celular) VALUES
 ('100234567', '841234567'), ('100234567', '827234567'),
 ('100349678', '849678901'),
 ('100456789', '861122334'),
 ('100567890', '847890123'), ('100567890', '878901234'),
 ('100678901', '849012345'),
 ('100789012', '823456789'), ('100789012', '843456789'), ('100789012', '863456789'),
 ('100890123', '844567890'), ('100890123', '824567890'),
 ('100901234', '829678901'),
 ('101012345', '866789012'),
 ('101123456', '827890123'), ('101123456', '847890124'),
 ('101234567', '848907234'),
 ('101345678', '829012345'), ('101345678', '849072345'), ('101345678', '869012345'),
 ('101456789', '841122334'),
 ('101567890', '822233445'), ('101567890', '842233445'),
 ('101678901', '843346556'),
 ('101789012', '824455667'), ('101789012', '844455667');

-- ---------------------------------------------------------------------
-- 3. QUERIES DE EXEMPLO (com JOIN) — reconstituem a informação original
-- ---------------------------------------------------------------------

-- 3.1 Reconstituir a "ficha completa" do funcionário: dados pessoais,
--     cargo, função, posto de trabalho e cidade de residência
--     (equivalente às primeiras colunas da tabela 0FN original).
SELECT
    f.nuit,
    f.nome,
    f.data_nasc,
    f.bi,
    f.email,
    CONCAT(f.rua, ', n.º ', f.numero, ', ', f.bairro) AS endereco_completo,
    c_res.nome_cidade   AS cidade_residencia,
    c_res.provincia     AS provincia_residencia,
    ca.nome_cargo,
    fu.nome_funcao,
    pt.nome_posto,
    c_posto.nome_cidade AS cidade_do_posto,
    f.data_admissao
FROM funcionario f
JOIN cidade         c_res   ON f.id_cidade_residencia = c_res.id_cidade
JOIN cargo           ca     ON f.cod_cargo  = ca.cod_cargo
JOIN funcao           fu    ON f.cod_funcao = fu.cod_funcao
JOIN posto_trabalho   pt    ON f.id_posto   = pt.id_posto
JOIN cidade          c_posto ON pt.id_cidade = c_posto.id_cidade
ORDER BY f.nome;

-- 3.2 Listar cada funcionário com todos os seus filhos
--     (reconstitui as colunas Filha 1/2/3 da tabela original, mas sem
--      limite de 3 e sem colunas vazias).
SELECT
    f.nuit,
    f.nome AS nome_funcionario,
    fi.nome_filho
FROM funcionario f
JOIN filho fi ON f.nuit = fi.nuit_funcionario
ORDER BY f.nome, fi.id_filho;

-- 3.3 Listar cada funcionário com todos os seus números de telefone
--     (reconstitui as colunas Celular 1/2/3 da tabela original).
SELECT
    f.nuit,
    f.nome AS nome_funcionario,
    t.numero_celular
FROM funcionario f
JOIN telefone t ON f.nuit = t.nuit_funcionario
ORDER BY f.nome, t.id_telefone;

-- 3.4 Quantos funcionários existem por cargo e por cidade de trabalho
--     (exemplo de consulta analítica só possível de forma limpa depois
--      da normalização — junta 3 tabelas de referência).
SELECT
    ca.nome_cargo,
    c_posto.nome_cidade AS cidade_do_posto,
    COUNT(*) AS total_funcionarios
FROM funcionario f
JOIN cargo         ca      ON f.cod_cargo = ca.cod_cargo
JOIN posto_trabalho pt     ON f.id_posto  = pt.id_posto
JOIN cidade        c_posto ON pt.id_cidade = c_posto.id_cidade
GROUP BY ca.nome_cargo, c_posto.nome_cidade
ORDER BY total_funcionarios DESC;
