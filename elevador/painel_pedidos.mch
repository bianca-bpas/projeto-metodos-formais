MACHINE
    painel_pedidos

SEES
    configuracao

CONSTANTS
    min_andar, max_andar

PROPERTIES
    min_andar = 0 &
    max_andar = 4

VARIABLES
    pedidos_internos,
    pedidos_subida,
    pedidos_descida,

    piscando_interno1,
    piscando_subida1,
    piscando_descida1,
    piscando_interno2,
    piscando_subida2,
    piscando_descida2,

    tempo_interno,
    tempo_subida,
    tempo_descida,

    historico_paradas

INVARIANT
    tempo_interno : (min_andar..max_andar) --> (-1..3) &
    tempo_subida : (min_andar..(max_andar - 1)) --> (-1..3) &
    tempo_descida : ((min_andar + 1)..max_andar) --> (-1..3) &
    pedidos_internos <: min_andar..max_andar &
    pedidos_subida <: min_andar..(max_andar - 1) &
    pedidos_descida <: (min_andar + 1)..max_andar &

    piscando_interno1 <: min_andar..max_andar &
    piscando_subida1 <: min_andar..(max_andar - 1) &
    piscando_descida1 <: (min_andar + 1)..max_andar &
    piscando_interno2 <: min_andar..max_andar &
    piscando_subida2 <: min_andar..(max_andar - 1) &
    piscando_descida2 <: (min_andar + 1)..max_andar &

    historico_paradas : seq(min_andar..max_andar) &
    size(historico_paradas) <= 5 &

    !aa.(aa : min_andar..max_andar & tempo_interno(aa) >= 0 => aa : pedidos_internos) &
    !aa.(aa : min_andar..(max_andar - 1) & tempo_subida(aa) >= 0 => aa : pedidos_subida) &
    !aa.(aa : (min_andar + 1)..max_andar & tempo_descida(aa) >= 0 => aa : pedidos_descida)

INITIALISATION
    pedidos_internos := {} ||
    pedidos_subida := {} ||
    pedidos_descida := {} ||
    piscando_interno1 := {} ||
    piscando_subida1 := {} ||
    piscando_descida1 := {} ||
    piscando_interno2 := {} ||
    piscando_subida2 := {} ||
    piscando_descida2 := {} ||
    tempo_interno := (min_andar..max_andar) * {-1} ||
    tempo_subida := (min_andar..(max_andar - 1)) * {-1} ||
    tempo_descida := ((min_andar + 1)..max_andar) * {-1} ||
    historico_paradas := []

OPERATIONS

    /* REGISTRO DE PEDIDOS COM INICIALIZAÇÃO DE TEMPO (HLR-004 / HLR-005) */
    pressionar_interno(alvo) =
        PRE alvo : min_andar..max_andar THEN
            pedidos_internos := pedidos_internos \/ {alvo} ||
            IF tempo_interno(alvo) = -1 THEN
                tempo_interno(alvo) := 0
            END
        END;

    pressionar_externo_subida(alvo) =
        PRE alvo : min_andar..(max_andar - 1) THEN
            pedidos_subida := pedidos_subida \/ {alvo} ||
            IF tempo_subida(alvo) = -1 THEN
                tempo_subida(alvo) := 0
            END
        END;

    pressionar_externo_descida(alvo) =
        PRE alvo : (min_andar + 1)..max_andar THEN
            pedidos_descida := pedidos_descida \/ {alvo} ||
            IF tempo_descida(alvo) = -1 THEN
                tempo_descida(alvo) := 0
            END
        END;

    /* GESTÃO DE TEMPO DOS BOTÕES (HLR-005) */
    liberar_interno(alvo) =
        PRE alvo : min_andar..max_andar
        THEN tempo_interno(alvo) := -1 END;

    liberar_subida(alvo) =
        PRE alvo : min_andar..(max_andar - 1)
        THEN tempo_subida(alvo) := -1 END;

    liberar_descida(alvo) =
        PRE alvo : (min_andar + 1)..max_andar
        THEN tempo_descida(alvo) := -1 END;

    avancar_tempo_botoes =
        BEGIN
            tempo_interno := tempo_interno <+
                %pavimento.(pavimento : dom(tempo_interno |> (0..2)) | tempo_interno(pavimento) + 1) ||
            tempo_subida := tempo_subida <+
                %pavimento.(pavimento : dom(tempo_subida |> (0..2)) | tempo_subida(pavimento) + 1) ||
            tempo_descida := tempo_descida <+
                %pavimento.(pavimento : dom(tempo_descida |> (0..2)) | tempo_descida(pavimento) + 1)
        END;

    cancelar_todos =
        BEGIN
            tempo_interno := (min_andar..max_andar) * {-1} ||
            tempo_subida := (min_andar..(max_andar - 1)) * {-1} ||
            tempo_descida := ((min_andar + 1)..max_andar) * {-1} ||
            pedidos_internos := {} || pedidos_subida := {} || pedidos_descida := {} ||
            piscando_interno1 := {} || piscando_interno2 := {} ||
            piscando_subida1 := {} || piscando_subida2 := {} ||
            piscando_descida1 := {} || piscando_descida2 := {}
        END;

    /* CANCELAMENTO INTERNO COM REGRA DE RECUSA DE ÚNICO PEDIDO (HLR-005) */
    cancelamento_interno(alvo) =
        PRE
            alvo : pedidos_internos
        THEN
            IF card(pedidos_internos) = 1 THEN
                piscando_interno1 := piscando_interno1 \/ {alvo}
            ELSE
                pedidos_internos := pedidos_internos - {alvo} ||
                piscando_interno1 := piscando_interno1 - {alvo} ||
                piscando_interno2 := piscando_interno2 - {alvo} ||
                tempo_interno(alvo) := -1
            END
        END;

    cancelamento_externo_subida(alvo) =
        PRE
            alvo : pedidos_subida
        THEN
            pedidos_subida := pedidos_subida - {alvo} ||
            tempo_subida(alvo) := -1
        END;

    cancelamento_externo_descida(alvo) =
        PRE
            alvo : pedidos_descida
        THEN
            pedidos_descida := pedidos_descida - {alvo} ||
            tempo_descida(alvo) := -1
        END;

    /* ATENDIMENTO EM PARADA DE PORTA (HLR-010) */
    atender_pedidos_andar(alvo, sentido) =
        PRE
            alvo : min_andar..max_andar &
            sentido : DIRECOES
        THEN
            IF alvo : pedidos_internos THEN
                pedidos_internos := pedidos_internos - {alvo} ||
                piscando_interno1 := piscando_interno1 - {alvo} ||
                piscando_interno2 := piscando_interno2 - {alvo} ||
                tempo_interno(alvo) := -1
            END ||
            IF (sentido = subindo or sentido = parado) & alvo : pedidos_subida THEN
                pedidos_subida := pedidos_subida - {alvo} ||
                piscando_subida1 := piscando_subida1 - {alvo} ||
                piscando_subida2 := piscando_subida2 - {alvo} ||
                tempo_subida(alvo) := -1
            END ||
            IF (sentido = descendo or (sentido = parado & alvo /: pedidos_subida)) & alvo : pedidos_descida THEN
                pedidos_descida := pedidos_descida - {alvo} ||
                piscando_descida1 := piscando_descida1 - {alvo} ||
                piscando_descida2 := piscando_descida2 - {alvo} ||
                tempo_descida(alvo) := -1
            END ||
            IF size(historico_paradas) < 5 THEN
                historico_paradas := historico_paradas <- alvo
            ELSE
                historico_paradas := tail(historico_paradas) ^ [alvo]
            END
        END;

    /* ANIMACAO DE PISCA */
    piscar_interno(alvo) =
        PRE alvo : pedidos_internos THEN
            piscando_interno1 := piscando_interno1 \/ {alvo}
        END;

    piscar_subida(alvo) =
        PRE alvo : min_andar..(max_andar - 1) THEN
            piscando_subida1 := piscando_subida1 \/ {alvo}
        END;

    piscar_descida(alvo) =
        PRE alvo : (min_andar + 1)..max_andar THEN
            piscando_descida1 := piscando_descida1 \/ {alvo}
        END;

    parar_piscar =
        PRE
            piscando_interno1 /= {} or piscando_interno2 /= {} or
            piscando_subida1 /= {}  or piscando_subida2 /= {}  or
            piscando_descida1 /= {} or piscando_descida2 /= {}
        THEN
            piscando_interno1 := {} ||
            piscando_interno2 := piscando_interno1 ||

            piscando_subida1 := {} ||
            piscando_subida2 := piscando_subida1 ||

            piscando_descida1 := {} ||
            piscando_descida2 := piscando_descida1
        END;

    /* CONSULTAS */
    botoes_internos, botoes_subida, botoes_descida <-- consultar_botoes_pressionados =
        BEGIN
            botoes_internos := dom(tempo_interno |>> {-1}) ||
            botoes_subida := dom(tempo_subida |>> {-1}) ||
            botoes_descida := dom(tempo_descida |>> {-1})
        END;

    internos_com_tempo, subida_com_tempo, descida_com_tempo <-- consultar_botoes_com_tempo(tt) =
        PRE tt : (-1..3)
        THEN
            internos_com_tempo := tempo_interno~[{tt}] ||
            subida_com_tempo := tempo_subida~[{tt}] ||
            descida_com_tempo := tempo_descida~[{tt}]
        END;

    historico, quantidade <-- consultar_historico_paradas =
        BEGIN
            historico := historico_paradas ||
            quantidade := size(historico_paradas)
        END;

    primeira, ultima <-- consultar_extremos_historico =
        PRE historico_paradas /= []
        THEN
            primeira := first(historico_paradas) ||
            ultima := last(historico_paradas)
        END;

    alvo <-- sugerir_pedido_qualquer =
        PRE (pedidos_internos \/ pedidos_subida \/ pedidos_descida) /= {}
        THEN
            ANY aa WHERE
                aa : (pedidos_internos \/ pedidos_subida \/ pedidos_descida)
            THEN
                alvo := aa
            END
        END
END