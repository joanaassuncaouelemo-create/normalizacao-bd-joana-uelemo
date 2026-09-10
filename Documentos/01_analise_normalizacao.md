# Normalização de Base de Dados — Sistema de Gestão de Funcionários

Universidade Licungo — Faculdade de Ciências e Tecnologias
Curso de Licenciatura em Informática — Trabalho II

> **Nota sobre os dados:** os valores abaixo foram transcritos a partir da imagem da folha `Dados_Nao_Normalizados_Funcionarios.xlsx`. Nomes, cargos, funções, cidades e datas foram lidos com confiança. Os campos numéricos longos (NUIT, BI e números de celular) vinham com baixa resolução na imagem — foram transcritos com o melhor esforço, mas **recomenda-se conferir estes valores no ficheiro Excel original** antes da submissão final, já que a exatidão de um dígito não afeta a lógica de normalização, mas afeta a exatidão dos dados.

---

## 1. Identificação dos Problemas na Tabela Original (0FN)

A tabela original junta, numa única folha, dados de identificação, morada, dados profissionais, filhos e contactos telefónicos de cada funcionário. Isto gera os seguintes problemas clássicos de uma tabela em **Zero Forma Normal (0FN)**:

### 1.1 Dados não atómicos
- **Endereço**: o campo `Endereço` mistura três informações distintas num só valor de texto (ex.: *"Av. Júlio Nyerere, n.º 245, Sommerschield"* = via pública + número da porta + bairro). Não é possível pesquisar ou ordenar por bairro sem processar texto.
- **Nome**: em rigor, "Nome" também agrega nome próprio e apelido, mas para efeitos deste trabalho mantemos o nome completo como um único atributo atómico (decisão de âmbito, documentada aqui).

### 1.2 Grupos repetitivos (repeating groups)
- **Filhos**: as colunas `Filha 1`, `Filha 2`, `Filha 3` representam o mesmo tipo de informação (um dependente do funcionário) repetida em colunas — um funcionário com 4 filhos não teria onde os colocar, e um funcionário sem filhos deixa colunas vazias (desperdício de espaço).
- **Contactos telefónicos**: o mesmo problema ocorre com `Celular 1`, `Celular 2`, `Celular 3`.

Estes dois grupos repetitivos violam diretamente a definição de 1ª Forma Normal.

### 1.3 Dependências parciais
Não existe, na tabela original, uma chave composta "verdadeira" (a linha inteira descreve um único funcionário, identificado por NUIT ou BI), pelo que **não há dependências parciais na tabela-mãe em si**. As dependências parciais só passam a existir depois de introduzirmos chaves compostas nas tabelas de `Filho` e `Telefone` em 1FN — ver secção 3.

### 1.4 Dependências transitivas
Identificam-se três cadeias de dependência transitiva, todas do tipo *NUIT → X → Y*, em que Y não depende diretamente do funcionário, mas sim de X:

| Cadeia | Exemplo nos dados |
|---|---|
| `NUIT → Cidade → Província → País` | Todos os funcionários de "Beira" têm sempre província "Sofala" e país "Moçambique" — a província não é um facto sobre o funcionário, é um facto sobre a cidade. |
| `NUIT → Cód. Cargo → Cargo` | Todo o funcionário com `Cód. Cargo = C03` tem sempre o nome de cargo "Engenheiro Civil" — o nome do cargo depende do código, não da pessoa. |
| `NUIT → Cód. Função → Função` | Todo o funcionário com `Cód. Função = F07` tem sempre a função "Recursos Humanos". |
| `NUIT → Posto de Trabalho → Cidade (do posto)` | Todos os funcionários lotados em "Delegação Beira" trabalham sempre na cidade "Beira" — a cidade do posto de trabalho é um facto sobre o posto, não sobre o funcionário individualmente. |

### 1.5 Dependências multivaloradas (MVD)
O funcionário pode ter **vários filhos** e **vários números de celular**, e estes dois factos são **independentes um do outro** (o número de filhos não tem qualquer relação com o número de telefones que a pessoa tem). Isto é o exemplo clássico de dependência multivalorada:Se estes dois grupos fossem colocados **na mesma tabela** (por exemplo, uma tabela "Funcionario_Contactos" com colunas Filho e Celular lado a lado), seria necessário multiplicar todas as combinações de filho × celular para cada funcionário, criando redundância e anomalias de inserção/remoção. É este problema que a 4ª Forma Normal resolve.

---

## 2. Primeira Forma Normal (1FN)

**Regra:** eliminar grupos repetitivos e garantir que todos os atributos são atómicos.

**Ações tomadas:**
1. O campo `Endereço` foi decomposto em `Rua`, `Número` e `Bairro`.
2. As colunas `Filha 1/2/3` foram removidas da tabela de funcionário e viraram uma tabela nova: **FILHO**, com uma linha por filho.
3. As colunas `Celular 1/2/3` foram removidas e viraram uma tabela nova: **TELEFONE**, com uma linha por número.
4. Ficou uma tabela **FUNCIONARIO** única, com chave primária `NUIT` (mais estável do que o Nome, e mais curto que o BI para chave — decidimos usar o NUIT como identificador fiscal único).

### 2.1 FUNCIONARIO (1FN)

| NUIT | Nome | Data Nasc. | BI | Email | Rua | Número | Bairro | Cidade | Província | País | Cargo | Cód.Cargo | Função | Cód.Função | Posto de Trabalho | Data Admissão |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 100234567 | Amélia Fernanda Cossa | 12/03/1985 | 111012072345A | amelia.cossa@empresa.co.mz | Av. Júlio Nyerere | 245 | Sommerschield | Maputo | Maputo Cidade | Moçambique | Técnica de Informática | C01 | Tecnologias de Informação | F01 | Sede Maputo | 09/02/2019 |
| 100349678 | Bernardo Alfredo Machava | 22/07/1979 | 110102345678 | bernardo.machava@empresa.co.mz | Rua da Resistência | 8 | Polana Caniço | Maputo | Maputo Cidade | Moçambique | Contabilista | C02 | Finanças | F02 | Sede Maputo | 14/09/2010 |
| 100456789 | Celina Armanda Sitoe | 03/11/1990 | 112003456789C | celina.sitoe@empresa.co.mz | Av. Samora Machel | 12 | Fomento | Matola | Maputo Província | Moçambique | Assistente Administrativa | C08 | Administração | F08 | Delegação Matola | 01/06/2018 |
| 100567890 | Domingos Paulo Nhantumbo | 30/01/1982 | 113004567890D | domingos.nhantumbo@empresa.co.mz | Rua 3 | 56 | Chókwè-Sede | Chókwè | Gaza | Moçambique | Motorista | C06 | Logística | F06 | Delegação Gaza | 10/03/2012 |
| 100678901 | Eugénia Marta Muchanga | 18/09/1988 | 114005678901E | eugenia.muchanga@empresa.co.mz | Av. Eduardo Mondlane | 321 | Maxixe-Sede | Maxixe | Inhambane | Moçambique | Enfermeiro | C04 | Saúde | F04 | Delegação Inhambane | 20/08/2016 |
| 100789012 | Fernando José Macuácua | 25/09/1975 | 115006789012F | fernando.macuacua@empresa.co.mz | Av. Poder Popular | 77 | Macuti | Beira | Sofala | Moçambique | Engenheiro Civil | C03 | Engenharia | F03 | Delegação Beira | 15/01/2008 |
| 100890123 | Graça Isabel Zungue | 07/12/1992 | 116007890123G | graca.zungue@empresa.co.mz | Rua da Frescura | 19 | Ponta Gêa | Beira | Sofala | Moçambique | Professor | C05 | Educação | F05 | Delegação Beira | 02/02/2019 |
| 100901234 | Hélder António Cuamba | 14/04/1980 | 117008901234H | helder.cuamba@empresa.co.mz | Av. 25 de Setembro | 150 | Alto Maé | Maputo | Maputo Cidade | Moçambique | Gestor de Recursos Humanos | C07 | Recursos Humanos | F07 | Sede Maputo | 15/11/2011 |
| 101012345 | Ivete Sara Chirindza | 29/06/1995 | 118009012345I | ivete.chirindza@empresa.co.mz | Rua do Bagamoyo | 5 | Muhipiti | Nampula | Nampula | Moçambique | Técnico de Informática | C01 | Tecnologias de Informação | F01 | Delegação Nampula | 03/07/2020 |
| 101123456 | João Baptista Nhaca | 09/08/1978 | 119000123456J | joao.nhaca@empresa.co.mz | Av. Josina Machel | 200 | Nanhurwa | Nampula | Nampula | Moçambique | Contabilista | C02 | Finanças | F02 | Delegação Nampula | 25/09/2009 |
| 101234567 | Lúcia Ermelinda Bila | 16/02/1991 | 111000123456K | lucia.bila@empresa.co.mz | Rua da Base | 33 | Chamite | Beira | Sofala | Moçambique | Assistente Administrativa | C08 | Administração | F08 | Delegação Beira | 16/09/2017 |
| 101345678 | Marcelino Inácio Tembe | 27/10/1983 | 111102345678L | marcelino.tembe@empresa.co.mz | Av. Kwame Nkrumah | 413 | Coop | Maputo | Maputo Cidade | Moçambique | Engenheiro Civil | C03 | Engenharia | F03 | Sede Maputo | 08/04/2013 |
| 101456789 | Noémia Abíss Massingue | 06/03/1987 | 112003456789M | noemia.massingue@empresa.co.mz | Rua de Chimoio | 87 | Chinguassura | Chimoio | Manica | Moçambique | Enfermeiro | C04 | Saúde | F04 | Delegação Manica | 12/12/2014 |
| 101567890 | Osvaldo Simão Ubisse | 27/07/1976 | 113004567890N | osvaldo.ubisse@empresa.co.mz | Av. 7 de Setembro | 90 | Matundo | Tete | Tete | Moçambique | Motorista | C06 | Logística | F06 | Delegação Tete | 30/10/2006 |
| 101678901 | Paulina Fátima Uache | 15/01/1993 | 114005678900O | paulina.uache@empresa.co.mz | Rua da Missão | 24 | Chaluua | Quelimane | Zambézia | Moçambique | Professor | C05 | Educação | F05 | Delegação Zambézia | 09/09/2021 |
| 101789012 | Ricardo Manuel Come | 02/06/1981 | 115006789019P | ricardo.come@empresa.co.mz | Av. Franqueza | 18 | Chuvauia | Pemba | Cabo Delgado | Moçambique | Gestor de Recursos Humanos | C07 | Recursos Humanos | F07 | Delegação Cabo Delgado | 17/07/2010 |

### 2.2 FILHO (1FN)

| NUIT (funcionário) | Nome do Filho |
|---|---|
| 100234567 | Célia Cossa |
| 100349678 | Nelson Machava |
| 100349678 | Ivete Machava |
| 100349678 | Suzana Machava |
| 100567890 | Paulo Nhantumbo Jr. |
| 100567890 | Alzira Nhantumbo |
| 100678901 | Marta Muchanga |
| 100789012 | José Macuácua |
| 100789012 | Beatriz Macuácua |
| 100789012 | Adriano Macuácua |
| 100901234 | António Cuamba Jr. |
| 100901234 | Filomena Cuamba |
| 101123456 | Baptista Nhaca Jr. |
| 101234567 | Ermelinda Bila |
| 101345678 | Inácio Tembe Jr. |
| 101345678 | Rosa Tembe |
| 101567890 | Simão Ubisse Jr. |
| 101567890 | Alcinda Ubisse |
| 101567890 | Custódio Ubisse |
| 101789012 | Manuel Come Jr. |

*(Celina Sitoe, Graça Zungue, Ivete Chirindza, Noémia Massingue e Paulina Uache não têm filhos registados — simplesmente não geram linhas nesta tabela, o que já elimina o desperdício de colunas vazias da tabela original.)*

### 2.3 TELEFONE (1FN)

| NUIT (funcionário) | Número de Celular |
|---|---|
| 100234567 | 841234567 |
| 100234567 | 827234567 |
| 100349678 | 849678901 |
| 100456789 | 861122334 |
| 100567890 | 847890123 |
| 100567890 | 878901234 |
| 100678901 | 849012345 |
| 100789012 | 823456789 |
| 100789012 | 843456789 |
| 100789012 | 863456789 |
| 100890123 | 844567890 |
| 100890123 | 824567890 |
| 100901234 | 829678901 |
| 101012345 | 866789012 |
| 101123456 | 827890123 |
| 101123456 | 847890124 |
| 101234567 | 848907234 |
| 101345678 | 829012345 |
| 101345678 | 849072345 |
| 101345678 | 869012345 |
| 101456789 | 841122334 |
| 101567890 | 822233445 |
| 101567890 | 842233445 |
| 101678901 | 843346556 |
| 101789012 | 824455667 |
| 101789012 | 844455667 |

Com isto, todos os atributos passam a ser atómicos e não há mais colunas repetidas — **1FN cumprida**.

---

## 3. Segunda Forma Normal (2FN)

**Regra:** eliminar dependências parciais em relação à chave primária (só se aplica quando a chave é composta).

- **FUNCIONARIO** tem chave primária simples (`NUIT`), pelo que **não pode existir dependência parcial** — todos os atributos dependem por definição da chave inteira. 2FN já está garantida aqui.
- **FILHO** e **TELEFONE**, em 1FN, teriam chave composta `(NUIT, Nome_Filho)` e `(NUIT, Número_Celular)`. Como não há mais nenhum atributo além dos que compõem a própria chave, não há atributo "pendurado" a depender só de parte da chave — **não há dependência parcial real**.
- Ainda assim, por boas práticas (e para facilitar chaves estrangeiras noutras tabelas no futuro), introduzimos uma **chave substituta (surrogate key)** `id_filho` e `id_telefone`, transformando a chave composta em chave simples. Isto não é exigido pela 2FN em si, mas reforça a robustez do modelo.

**Conclusão: a estrutura já satisfaz 2FN após a 1FN**, não sendo necessária nenhuma decomposição adicional nesta fase — o que já é um indicador de que os verdadeiros problemas desta tabela são transitivos e multivalorados, não parciais.

---

## 4. Terceira Forma Normal (3FN)

**Regra:** eliminar dependências transitivas (atributos não-chave que dependem de outro atributo não-chave, e não diretamente da chave primária).

Com base nas dependências transitivas identificadas na secção 1.4, a tabela **FUNCIONARIO** é decomposta em:

### 4.1 CIDADE
Elimina a transitividade `NUIT → Cidade → Província/País`.

| id_cidade | Nome Cidade | Província | País |
|---|---|---|---|
| 1 | Maputo | Maputo Cidade | Moçambique |
| 2 | Matola | Maputo Província | Moçambique |
| 3 | Chókwè | Gaza | Moçambique |
| 4 | Maxixe | Inhambane | Moçambique |
| 5 | Beira | Sofala | Moçambique |
| 6 | Nampula | Nampula | Moçambique |
| 7 | Chimoio | Manica | Moçambique |
| 8 | Tete | Tete | Moçambique |
| 9 | Quelimane | Zambézia | Moçambique |
| 10 | Pemba | Cabo Delgado | Moçambique |

### 4.2 CARGO
Elimina a transitividade `NUIT → Cód.Cargo → Nome do Cargo`. Corresponde à "tabela de referência de cargos" mencionada no enunciado.

| cod_cargo | Nome do Cargo |
|---|---|
| C01 | Técnico(a) de Informática |
| C02 | Contabilista |
| C03 | Engenheiro(a) Civil |
| C04 | Enfermeiro(a) |
| C05 | Professor(a) |
| C06 | Motorista |
| C07 | Gestor(a) de Recursos Humanos |
| C08 | Assistente Administrativo(a) |

### 4.3 FUNÇÃO
Elimina a transitividade `NUIT → Cód.Função → Nome da Função`. Corresponde à "tabela de referência de funções" do enunciado.

| cod_funcao | Nome da Função |
|---|---|
| F01 | Tecnologias de Informação |
| F02 | Finanças |
| F03 | Engenharia |
| F04 | Saúde |
| F05 | Educação |
| F06 | Logística |
| F07 | Recursos Humanos |
| F08 | Administração |

### 4.4 POSTO_TRABALHO
Elimina a transitividade `NUIT → Posto de Trabalho → Cidade do posto` (repare que "Sede Maputo" está sempre na cidade "Maputo", "Delegação Beira" está sempre em "Beira", etc. — este facto pertence ao posto, não ao funcionário).

| id_posto | Nome do Posto | id_cidade |
|---|---|---|
| 1 | Sede Maputo | 1 (Maputo) |
| 2 | Delegação Matola | 2 (Matola) |
| 3 | Delegação Gaza | 3 (Chókwè) |
| 4 | Delegação Inhambane | 4 (Maxixe) |
| 5 | Delegação Beira | 5 (Beira) |
| 6 | Delegação Nampula | 6 (Nampula) |
| 7 | Delegação Manica | 7 (Chimoio) |
| 8 | Delegação Tete | 8 (Tete) |
| 9 | Delegação Zambézia | 9 (Quelimane) |
| 10 | Delegação Cabo Delgado | 10 (Pemba) |

### 4.5 FUNCIONARIO (3FN)

A tabela FUNCIONARIO fica apenas com atributos que dependem **diretamente e só** do NUIT, mais as chaves estrangeiras para as tabelas de referência:

`FUNCIONARIO (NUIT PK, Nome, Data_Nasc, BI, Email, Rua, Numero, Bairro, id_cidade_residencia FK→CIDADE, cod_cargo FK→CARGO, cod_funcao FK→FUNCAO, id_posto FK→POSTO_TRABALHO, Data_Admissao)`

As tabelas FILHO e TELEFONE mantêm-se como em 1FN/2FN, apenas com `NUIT` como chave estrangeira para FUNCIONARIO.

**Conclusão: sem dependências transitivas remanescentes — 3FN cumprida.**

---

## 5. Quarta Forma Normal (4FN)

**Regra:** eliminar dependências multivaloradas independentes — nenhuma tabela deve misturar dois grupos multivalorados que não têm relação lógica entre si.

Como identificado na secção 1.5, "filhos" e "números de telefone" são duas famílias de dados **multivaloradas e independentes** em relação ao funcionário (`NUIT →→ Filho` e `NUIT →→ Telefone`, sem qualquer relação entre o número de filhos e o número de telefones de uma pessoa).

A decisão tomada logo na 1FN — de criar **duas tabelas separadas** (FILHO e TELEFONE), em vez de uma única tabela "Funcionario_Contactos" com Filho e Celular lado a lado — já satisfaz a 4FN. Se estas duas informações tivessem sido combinadas numa só tabela, cada funcionário com, por exemplo, 3 filhos e 2 celulares geraria 6 linhas (3×2) só para representar informação que na realidade tem apenas 5 factos distintos (3 filhos + 2 celulares) — isto seria a anomalia clássica de uma tabela em 3FN mas fora de 4FN.

**Esquema final (4FN):**---

## 6. Cardinalidades dos Relacionamentos

| Relacionamento | Cardinalidade | Justificação |
|---|---|---|
| CIDADE — FUNCIONARIO (residência) | 1:N | Uma cidade tem muitos funcionários residentes; um funcionário reside numa só cidade. |
| CIDADE — POSTO_TRABALHO | 1:N | Uma cidade pode ter vários postos de trabalho; cada posto fica localizado numa só cidade. |
| POSTO_TRABALHO — FUNCIONARIO | 1:N | Um posto de trabalho tem vários funcionários lotados; cada funcionário está lotado num só posto (nos dados atuais). |
| CARGO — FUNCIONARIO | 1:N | Um cargo é ocupado por vários funcionários; cada funcionário tem um único cargo. |
| FUNCAO — FUNCIONARIO | 1:N | Uma função é desempenhada por vários funcionários; cada funcionário tem uma única função. |
| FUNCIONARIO — FILHO | 1:N | Um funcionário pode ter vários filhos registados; cada filho pertence a um único funcionário. |
| FUNCIONARIO — TELEFONE | 1:N | Um funcionário pode ter vários números de celular; cada número pertence a um único funcionário. |

Não existe, nos dados fornecidos, nenhum relacionamento N:M — todos os relacionamentos identificados são 1:N, o que é típico de um esquema de recursos humanos deste tipo (cada funcionário tem um único cargo/função/posto/cidade de residência ao mesmo tempo).

> **Observação adicional:** repare que, nos dados, `Cód.Cargo` e `Cód.Função` aparecem sempre emparelhados da mesma forma (C01↔F01, C02↔F02, etc.). Isto sugere uma forte correlação entre cargo e função nesta empresa, mas foram mantidos como duas entidades/tabelas de referência distintas — tal como o próprio enunciado pede ("tabela de referência de cargos **e** funções") — porque conceptualmente são classificações diferentes (cargo = título profissional; função = área/departamento), mesmo que na prática atual estejam sempre associados 1 para 1.
