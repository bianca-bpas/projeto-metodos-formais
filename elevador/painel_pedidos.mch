MACHINE
    painel_pedidos

SEES
    configuracao

CONSTANTS
    min_andar, max_andar

PROPERTIES
    min_andar = 0 &
    max_andar = andar_maximo

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
    tempo_interno : (min_andar..max_andar) +-> (0..3) &
    tempo_subida : (min_andar..(max_andar - 1)) +-> (0..3) &
    tempo_descida : ((min_andar + 1)..max_andar) +-> (0..3) &
    pedidos_internos : POW(min_andar..max_andar) &
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

    dom(tempo_interno) <: pedidos_internos &
    dom(tempo_subida) <: pedidos_subida &
    dom(tempo_descida) <: pedidos_descida

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
    tempo_interno := {} ||
    tempo_subida := {} ||
    tempo_descida := {} ||
    historico_paradas := []

OPERATIONS

    /* REGISTRO DE PEDIDOS COM INICIALIZAÇÃO DE TEMPO (HLR-004 / HLR-005) */
    pressionar_interno(alvo) =
        PRE alvo : min_andar..max_andar THEN
            pedidos_internos := pedidos_internos \/ {alvo} ||
            IF alvo /: dom(tempo_interno) THEN
                tempo_interno := tempo_interno <+ {alvo |-> 0}
            END
        END;

    pressionar_externo_subida(alvo) =
        PRE alvo : min_andar..(max_andar - 1) THEN
            pedidos_subida := pedidos_subida \/ {alvo} ||
            IF alvo /: dom(tempo_subida) THEN
                tempo_subida := tempo_subida <+ {alvo |-> 0}
            END
        END;

    pressionar_externo_descida(alvo) =
        PRE alvo : (min_andar + 1)..max_andar THEN
            pedidos_descida := pedidos_descida \/ {alvo} ||
            IF alvo /: dom(tempo_descida) THEN
                tempo_descida := tempo_descida <+ {alvo |-> 0}
            END
        END;

    /* BOTÃO INTERNO RECUSADO (HLR-008): o LED pisca e o pedido NÃO é registrado */
    recusar_interno(alvo) =
        PRE alvo : min_andar..max_andar THEN
            piscando_interno1 := piscando_interno1 \/ {alvo}
        END;

    /* GESTÃO DE TEMPO DOS BOTÕES (HLR-005) */
    liberar_interno(alvo) =
        PRE alvo : min_andar..max_andar
        THEN tempo_interno := {alvo} <<| tempo_interno END;

    liberar_subida(alvo) =
        PRE alvo : min_andar..(max_andar - 1)
        THEN tempo_subida := {alvo} <<| tempo_subida END;

    liberar_descida(alvo) =
        PRE alvo : (min_andar + 1)..max_andar
        THEN tempo_descida := {alvo} <<| tempo_descida END;

    avancar_tempo_botoes =
        BEGIN
            tempo_interno := %aa.(aa : dom(tempo_interno) | proximo_tempo(tempo_interno(aa))) ||
            tempo_subida := %aa.(aa : dom(tempo_subida) | proximo_tempo(tempo_subida(aa))) ||
            tempo_descida := %aa.(aa : dom(tempo_descida) | proximo_tempo(tempo_descida(aa)))
        END;

    cancelar_todos =
        BEGIN
            tempo_interno := {} ||
            tempo_subida := {} ||
            tempo_descida := {} ||
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
                tempo_interno := {alvo} <<| tempo_interno
            END
        END;

    cancelamento_externo_subida(alvo) =
        PRE
            alvo : pedidos_subida
        THEN
            pedidos_subida := pedidos_subida - {alvo} ||
            tempo_subida := {alvo} <<| tempo_subida
        END;

    cancelamento_externo_descida(alvo) =
        PRE
            alvo : pedidos_descida
        THEN
            pedidos_descida := pedidos_descida - {alvo} ||
            tempo_descida := {alvo} <<| tempo_descida
        END;

    /* ATENDIMENTO EM PARADA DE PORTA (HLR-010)
       Remoções incondicionais: retirar um elemento ausente é um no-op,
       o que simplifica as obrigações de prova. */
    atender_pedidos_andar(alvo, sentido) =
        PRE
            alvo : min_andar..max_andar &
            sentido : DIRECOES
        THEN
            pedidos_internos := pedidos_internos - {alvo} ||
            piscando_interno1 := piscando_interno1 - {alvo} ||
            piscando_interno2 := piscando_interno2 - {alvo} ||
            tempo_interno := {alvo} <<| tempo_interno ||

            IF sentido = subindo or sentido = parado THEN
                pedidos_subida := pedidos_subida - {alvo} ||
                piscando_subida1 := piscando_subida1 - {alvo} ||
                piscando_subida2 := piscando_subida2 - {alvo} ||
                tempo_subida := {alvo} <<| tempo_subida
            END ||

            IF sentido = descendo or (sentido = parado & alvo /: pedidos_subida) THEN
                pedidos_descida := pedidos_descida - {alvo} ||
                piscando_descida1 := piscando_descida1 - {alvo} ||
                piscando_descida2 := piscando_descida2 - {alvo} ||
                tempo_descida := {alvo} <<| tempo_descida
            END ||

            IF size(historico_paradas) = 5 THEN
                historico_paradas := tail(historico_paradas) <- alvo
            ELSE
                historico_paradas := historico_paradas <- alvo
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
            botoes_internos := dom(tempo_interno) ||
            botoes_subida := dom(tempo_subida) ||
            botoes_descida := dom(tempo_descida)
        END;

    internos_com_tempo, subida_com_tempo, descida_com_tempo <-- consultar_botoes_com_tempo(tt) =
        PRE tt : (0..3)
        THEN
            internos_com_tempo := tempo_interno~[{tt}] ||
            subida_com_tempo := tempo_subida~[{tt}] ||
            descida_com_tempo := tempo_descida~[{tt}]
        END;

    /* Botões segurados por 3 s (prontos para cancelar): restrição de imagem |> */
    prontos_internos, prontos_subida, prontos_descida <-- consultar_botoes_prontos_cancelamento =
        BEGIN
            prontos_internos := dom(tempo_interno |> {3}) ||
            prontos_subida := dom(tempo_subida |> {3}) ||
            prontos_descida := dom(tempo_descida |> {3})
        END;

    /* Botões ainda em contagem (tempo < 3): subtração de imagem |>> */
    contagem_internos, contagem_subida, contagem_descida <-- consultar_em_contagem =
        BEGIN
            contagem_internos := dom(tempo_interno |>> {3}) ||
            contagem_subida := dom(tempo_subida |>> {3}) ||
            contagem_descida := dom(tempo_descida |>> {3})
        END;

    /* Tempos dos botões até um andar limite: restrição de domínio <| */
    internos_ate, subida_ate, descida_ate <-- consultar_tempos_ate(lim) =
        PRE lim : min_andar..max_andar
        THEN
            internos_ate := (min_andar..lim) <| tempo_interno ||
            subida_ate := (min_andar..lim) <| tempo_subida ||
            descida_ate := (min_andar..lim) <| tempo_descida
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

    /* Rota percorrida incluindo o andar atual na cabeça: inserção na cabeça -> */
    rota <-- consultar_rota(atual) =
        PRE atual : min_andar..max_andar
        THEN
            rota := atual -> historico_paradas
        END;

    /* Rota de ida e volta: concatenação ^ e inversão rev */
    ida_volta <-- consultar_rota_ida_volta =
        BEGIN
            ida_volta := historico_paradas ^ rev(historico_paradas)
        END;

    alvo <-- sugerir_pedido_qualquer =
        PRE (pedidos_internos \/ pedidos_subida \/ pedidos_descida) : POW1(min_andar..max_andar)
        THEN
            ANY aa WHERE
                aa : (pedidos_internos \/ pedidos_subida \/ pedidos_descida)
            THEN
                alvo := aa
            END
        END
END