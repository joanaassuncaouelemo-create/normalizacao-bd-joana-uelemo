# Trabalho II — Normalização de Base de Dados (Sistema de Gestão de Funcionários)

**Universidade Licungo · Faculdade de Ciências e Tecnologias · Licenciatura em Informática**

## Objetivo

Partindo de uma tabela única e não normalizada (0FN) com dados de funcionários, este trabalho aplica o processo de normalização passo a passo (1FN → 2FN → 3FN → 4FN), identifica cardinalidades e culmina num Modelo Entidade-Relacionamento (MER) e num script SQL executável.

## Estrutura do repositório

```
/documentos
    01_analise_normalizacao.md   → identificação dos problemas e justificação de cada forma normal (1FN a 4FN), com as tabelas resultantes de cada fase
/diagramas
    02_diagrama_ER.md            → diagrama MER em Mermaid (renderiza no GitHub) + resumo de entidades/chaves
/sql
    03_esquema.sql                → DDL (CREATE TABLE) do esquema final em 4FN, dados de exemplo (INSERT) e 4 queries com JOIN que reconstituem a informação original
README.md                         → este ficheiro
```

> Sugestão: ao criar o repositório GitHub, move estes três ficheiros para as pastas indicadas acima (`/documentos`, `/diagramas`, `/sql`) conforme pedido no enunciado.

## Como consultar

1. **Análise da normalização** — abrir `01_analise_normalizacao.md`. Contém, por ordem: problemas do 0FN (dados não atómicos, grupos repetitivos, dependências parciais/transitivas/multivaloradas), depois as tabelas resultantes de 1FN, justificação de 2FN, decomposição em 3FN e a resolução final em 4FN, terminando com a tabela de cardinalidades.
2. **Diagrama ER** — abrir `02_diagrama_ER.md`. O bloco de código Mermaid é renderizado automaticamente pelo GitHub. Para exportar como imagem (`.png`/`.svg`) para o vídeo, colar o código em https://mermaid.live e usar "Export".
3. **Script SQL** — abrir `03_esquema.sql`. Pode ser executado diretamente em MySQL/MariaDB/PostgreSQL (ajustar `AUTO_INCREMENT` para `SERIAL`/`GENERATED ALWAYS AS IDENTITY` se usares PostgreSQL). Contém 7 tabelas, dados de exemplo dos 16 funcionários e 4 queries com `JOIN` que demonstram a reconstituição da tabela original a partir do esquema normalizado.

## Esquema final (resumo)

7 tabelas: `cidade`, `cargo`, `funcao`, `posto_trabalho`, `funcionario`, `filho`, `telefone` — todos os relacionamentos são **1:N** (ver secção 6 de `01_analise_normalizacao.md`).

## Nota sobre a fidelidade dos dados

Os dados de partida foram transcritos a partir de uma **imagem** (fotografia de ecrã) da folha `Dados_Nao_Normalizados_Funcionarios.xlsx`, e não do ficheiro Excel em si. Nomes, cargos, funções, cidades, datas e endereços foram lidos com confiança. Os campos numéricos mais longos — NUIT, número de BI e números de celular — vinham com resolução baixa na imagem, pelo que foram transcritos com o melhor esforço possível mas **podem conter pequenos desvios de dígitos**. Antes de submeter, recomenda-se abrir o ficheiro `.xlsx` original e confirmar rapidamente esses valores (a lógica de normalização e o esquema relacional não são afetados por isto).

## Vídeo explicativo (a preparar pelo estudante)

Conforme pedido no enunciado, gravar um vídeo de 5–10 min cobrindo:
- Como decorreu cada fase da normalização (1FN → 4FN) e as decisões tomadas (ver `01_analise_normalizacao.md` como guião).
- Qual a ferramenta usada para o Modelo ER (aqui: Mermaid, exportado via mermaid.live — ou outra ferramenta à escolha, como draw.io/dbdiagram.io).
- Breve demonstração do esquema final e das queries SQL a funcionar (usar `03_esquema.sql`).

Publicar no YouTube (pode ser "não listado") e colocar o link no Google Classroom, junto com o link do repositório GitHub.
