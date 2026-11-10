MACHINE
    painel_pedidos

SEES
    configuracao

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
    tempo_interno : (0..andar_maximo) --> (-1..3) &
    tempo_subida : (0..(andar_maximo - 1)) --> (-1..3) &
    tempo_descida : (1..andar_maximo) --> (-1..3) &
    pedidos_internos <: 0..andar_maximo &
    pedidos_subida <: 0..(andar_maximo - 1) &
    pedidos_descida <: 1..andar_maximo &

    piscando_interno1 <: 0..andar_maximo &
    piscando_subida1 <: 0..(andar_maximo - 1) &
    piscando_descida1 <: 1..andar_maximo &
    piscando_interno2 <: 0..andar_maximo &
    piscando_subida2 <: 0..(andar_maximo - 1) &
    piscando_descida2 <: 1..andar_maximo &

    historico_paradas : seq(0..andar_maximo) &
    size(historico_paradas) <= 5 &

    !aa.(aa : 0..andar_maximo & tempo_interno(aa) >= 0 => aa : pedidos_internos) &
    !aa.(aa : 0..(andar_maximo - 1) & tempo_subida(aa) >= 0 => aa : pedidos_subida) &
    !aa.(aa : 1..andar_maximo & tempo_descida(aa) >= 0 => aa : pedidos_descida)

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
    tempo_interno := (0..andar_maximo) * {-1} ||
    tempo_subida := (0..(andar_maximo - 1)) * {-1} ||
    tempo_descida := (1..andar_maximo) * {-1} ||
    historico_paradas := []

OPERATIONS

    /* REGISTRO DE PEDIDOS COM INICIALIZAÇÃO DE TEMPO (HLR-004 / HLR-005) */
    registrar_interno(alvo) =
        PRE alvo : 0..andar_maximo THEN
            pedidos_internos := pedidos_internos \/ {alvo} ||
            IF tempo_interno(alvo) = -1 THEN
                tempo_interno(alvo) := 0
            END
        END;

    registrar_externo_subida(alvo) =
        PRE alvo : 0..(andar_maximo - 1) & alvo |-> subindo : painel_externo THEN
            pedidos_subida := pedidos_subida \/ {alvo} ||
            IF tempo_subida(alvo) = -1 THEN
                tempo_subida(alvo) := 0
            END
        END;

    registrar_externo_descida(alvo) =
        PRE alvo : 1..andar_maximo & alvo |-> descendo : painel_externo THEN
            pedidos_descida := pedidos_descida \/ {alvo} ||
            IF tempo_descida(alvo) = -1 THEN
                tempo_descida(alvo) := 0
            END
        END;

    /* GESTÃO DE TEMPO DOS BOTÕES (HLR-005) */
    liberar_interno(alvo) =
        PRE alvo : 0..andar_maximo
        THEN tempo_interno(alvo) := -1 END;

    liberar_subida(alvo) =
        PRE alvo : 0..(andar_maximo - 1)
        THEN tempo_subida(alvo) := -1 END;

    liberar_descida(alvo) =
        PRE alvo : 1..andar_maximo
        THEN tempo_descida(alvo) := -1 END;

    avancar_tempo_botoes =
        BEGIN
            tempo_interno := tempo_interno <+
                %pavimento.(pavimento : dom(tempo_interno |> (0..2)) | tempo_interno(pavimento) + 1) ||
            tempo_subida := tempo_subida <+
                %pavimento.(pavimento : dom(tempo_subida |> (0..2)) | tempo_subida(pavimento) + 1) ||
            tempo_descida := tempo_descida <+
                %pavimento.(pavimento : dom(tempo_descida |> (0..2)) | tempo_descida(pavimento) + 1) ||
            piscando_interno1 := {} ||
            piscando_interno2 := piscando_interno1 ||
            piscando_subida1 := {} ||
            piscando_subida2 := piscando_subida1 ||
            piscando_descida1 := {} ||
            piscando_descida2 := piscando_descida1
        END;

    cancelar_todos =
        BEGIN
            tempo_interno := (0..andar_maximo) * {-1} ||
            tempo_subida := (0..(andar_maximo - 1)) * {-1} ||
            tempo_descida := (1..andar_maximo) * {-1} ||
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
            alvo : 0..andar_maximo &
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
        PRE alvo : 0..andar_maximo THEN
            piscando_interno1 := piscando_interno1 \/ {alvo}
        END;

    piscar_subida(alvo) =
        PRE alvo : 0..(andar_maximo - 1) & alvo |-> subindo : painel_externo THEN
            piscando_subida1 := piscando_subida1 \/ {alvo}
        END;

    piscar_descida(alvo) =
        PRE alvo : 1..andar_maximo & alvo |-> descendo : painel_externo THEN
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
    leds_internos, leds_subida, leds_descida <-- consultar_leds =
        BEGIN
            leds_internos := pedidos_internos ||
            leds_subida := pedidos_subida ||
            leds_descida := pedidos_descida
        END;

    internos_fase1, internos_fase2,
    subida_fase1, subida_fase2,
    descida_fase1, descida_fase2 <-- consultar_piscadas =
        BEGIN
            internos_fase1 := piscando_interno1 ||
            internos_fase2 := piscando_interno2 ||
            subida_fase1 := piscando_subida1 ||
            subida_fase2 := piscando_subida2 ||
            descida_fase1 := piscando_descida1 ||
            descida_fase2 := piscando_descida2
        END;

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
