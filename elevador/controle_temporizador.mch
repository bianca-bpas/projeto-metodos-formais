MACHINE controle_temporizador

VARIABLES
    minutos_porta_aberta,
    aviso_porta_aberta

INVARIANT
    minutos_porta_aberta : NATURAL &
    aviso_porta_aberta : BOOL &
    (minutos_porta_aberta <= 2 => aviso_porta_aberta = FALSE) &
    (minutos_porta_aberta > 2 => aviso_porta_aberta = TRUE)

INITIALISATION
    minutos_porta_aberta := 0 ||
    aviso_porta_aberta := FALSE

OPERATIONS
    iniciar_contagem =
        BEGIN
            minutos_porta_aberta := 0 ||
            aviso_porta_aberta := FALSE
        END;

    passar_um_minuto(porta_aberta) =
        PRE
            porta_aberta = TRUE
        THEN
            minutos_porta_aberta := minutos_porta_aberta + 1 ||
            aviso_porta_aberta := bool(minutos_porta_aberta + 1 > 2)
        END;

    zerar_contagem =
        BEGIN
            minutos_porta_aberta := 0 ||
            aviso_porta_aberta := FALSE
        END;

    aviso_ativo <-- consultar_aviso =
        BEGIN
            aviso_ativo := aviso_porta_aberta
        END

END