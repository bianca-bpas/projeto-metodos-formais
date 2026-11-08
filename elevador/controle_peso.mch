MACHINE controle_peso

CONSTANTS
    peso_maximo

PROPERTIES
    peso_maximo = 450

VARIABLES
    peso,
    aviso_excesso_peso

INVARIANT
    peso : NATURAL &
    aviso_excesso_peso : BOOL &
    (peso > peso_maximo => aviso_excesso_peso = TRUE) &
    (peso <= peso_maximo => aviso_excesso_peso = FALSE)

INITIALISATION
    peso := 0 || 
    aviso_excesso_peso := FALSE

OPERATIONS
    atualizar_peso(novo_peso) =
        PRE
            novo_peso : NATURAL
        THEN
            peso := novo_peso ||
            aviso_excesso_peso := bool(novo_peso > peso_maximo)
        END;

    peso_atual, aviso_ativo, movimento_permitido <-- consultar_peso =
        BEGIN
            peso_atual := peso ||
            aviso_ativo := aviso_excesso_peso ||
            movimento_permitido := bool(peso <= peso_maximo)
        END

END
