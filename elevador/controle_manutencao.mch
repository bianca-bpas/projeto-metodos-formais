MACHINE controle_manutencao

VARIABLES
    chave_manutencao,
    manutencao,
    manutencao_pendente

INVARIANT
    chave_manutencao : BOOL &
    manutencao : BOOL &
    manutencao_pendente : BOOL &

    (chave_manutencao = TRUE => manutencao = TRUE or manutencao_pendente = TRUE) &
    (manutencao = TRUE => chave_manutencao = TRUE) &
    (manutencao_pendente = TRUE => chave_manutencao = TRUE) &
    not (manutencao = TRUE & manutencao_pendente = TRUE)

INITIALISATION
    chave_manutencao := FALSE ||
    manutencao := FALSE ||
    manutencao_pendente := FALSE

OPERATIONS
    inserir_chave_manutencao(cabine_parada) =
        PRE
            chave_manutencao = FALSE &
            cabine_parada : BOOL
        THEN
            chave_manutencao := TRUE ||

            IF cabine_parada = TRUE THEN
                manutencao := TRUE ||
                manutencao_pendente := FALSE
            ELSE
                manutencao_pendente := TRUE
            END
        END;

    confirmar_parada_manutencao(cabine_parada) =
        PRE
            chave_manutencao = TRUE &
            manutencao_pendente = TRUE &
            cabine_parada = TRUE
        THEN
            manutencao := TRUE ||
            manutencao_pendente := FALSE
        END;

    remover_chave_manutencao(cabine_parada) =
        PRE
            chave_manutencao = TRUE &
            manutencao = TRUE &
            cabine_parada = TRUE
        THEN
            chave_manutencao := FALSE ||
            manutencao := FALSE ||
            manutencao_pendente := FALSE
        END;

    cancelar_manutencao_pendente =
        PRE
            chave_manutencao = TRUE &
            manutencao_pendente = TRUE &
            manutencao = FALSE
        THEN
            chave_manutencao := FALSE ||
            manutencao_pendente := FALSE
        END;

    chave_inserida, manutencao_ativa, estado_pendente <-- consultar_estado_manutencao =
        BEGIN
            chave_inserida := chave_manutencao ||
            manutencao_ativa := manutencao ||
            estado_pendente := manutencao_pendente
        END

END