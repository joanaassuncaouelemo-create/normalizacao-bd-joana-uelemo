# Modelo Entidade-Relacionamento (MER) — Esquema Normalizado (4FN)

```mermaid
erDiagram
    CIDADE ||--o{ FUNCIONARIO : "reside em"
    CIDADE ||--o{ POSTO_TRABALHO : "localiza-se em"
    POSTO_TRABALHO ||--o{ FUNCIONARIO : "lota"
    CARGO ||--o{ FUNCIONARIO : "ocupa"
    FUNCAO ||--o{ FUNCIONARIO : "desempenha"
    FUNCIONARIO ||--o{ FILHO : "tem"
    FUNCIONARIO ||--o{ TELEFONE : "possui"

    CIDADE {
        int id_cidade PK
        string nome_cidade
        string provincia
        string pais
    }

    CARGO {
        string cod_cargo PK
        string nome_cargo
    }

    FUNCAO {
        string cod_funcao PK
        string nome_funcao
    }

    POSTO_TRABALHO {
        int id_posto PK
        string nome_posto
        int id_cidade FK
    }

    FUNCIONARIO {
        string nuit PK
        string nome
        date data_nasc
        string bi
        string email
        string rua
        string numero
        string bairro
        int id_cidade_residencia FK
        string cod_cargo FK
        string cod_funcao FK
        int id_posto FK
        date data_admissao
    }

    FILHO {
        int id_filho PK
        string nuit_funcionario FK
        string nome_filho
    }

    TELEFONE {
        int id_telefone PK
        string nuit_funcionario FK
        string numero_celular
    }
