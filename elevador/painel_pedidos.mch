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
    piscando_interno3,
    piscando_interno4,
    piscando_subida2,
    piscando_subida3,
    piscando_subida4,
    piscando_descida2,
    piscando_descida3,
    piscando_descida4,

    segurando_interno,
    segurando_interno_1,
    segurando_interno_2,
    interno_recusado,
    segurando_subida,
    segurando_subida_1,
    segurando_subida_2,
    segurando_descida,
    segurando_descida_1,
    segurando_descida_2,

    historico_paradas

INVARIANT
    pedidos_internos <: 0..andar_maximo &
    pedidos_subida <: 0..(andar_maximo - 1) &
    pedidos_descida <: 1..andar_maximo &

    piscando_interno1 <: 0..andar_maximo &
    piscando_subida1 <: 0..(andar_maximo - 1) &
    piscando_descida1 <: 1..andar_maximo &
    piscando_interno2 <: 0..andar_maximo &
    piscando_interno3 <: 0..andar_maximo &
    piscando_interno4 <: 0..andar_maximo &
    piscando_subida2 <: 0..(andar_maximo - 1) &
    piscando_subida3 <: 0..(andar_maximo - 1) &
    piscando_subida4 <: 0..(andar_maximo - 1) &
    piscando_descida2 <: 1..andar_maximo &
    piscando_descida3 <: 1..andar_maximo &
    piscando_descida4 <: 1..andar_maximo &

    historico_paradas : seq(0..andar_maximo) &
    size(historico_paradas) <= 5 &

    /* Tipagem explicita: em B, inclusoes entre variaveis nao bastam
       para inferir o tipo de todos os conjuntos aninhados. */
    segurando_interno : POW(0..andar_maximo) &
    segurando_interno_1 : POW(0..andar_maximo) &
    segurando_interno_2 : POW(0..andar_maximo) &
    interno_recusado : POW(0..andar_maximo) &
    segurando_subida : POW(0..(andar_maximo - 1)) &
    segurando_subida_1 : POW(0..(andar_maximo - 1)) &
    segurando_subida_2 : POW(0..(andar_maximo - 1)) &
    segurando_descida : POW(1..andar_maximo) &
    segurando_descida_1 : POW(1..andar_maximo) &
    segurando_descida_2 : POW(1..andar_maximo) &

    /* Contagem por conjuntos aninhados: segurando_2 <: segurando_1
       <: segurando <: pedidos. A terceira passagem do tempo cancela.
       Botao interno recusado permanece como pedido, mas sem contagem. */
    segurando_interno_2 <: segurando_interno_1 &
    segurando_interno_1 <: segurando_interno &
    segurando_interno <: pedidos_internos &
    interno_recusado <: pedidos_internos &
    segurando_interno /\ interno_recusado = {} &

    segurando_subida_2 <: segurando_subida_1 &
    segurando_subida_1 <: segurando_subida &
    segurando_subida <: pedidos_subida &

    segurando_descida_2 <: segurando_descida_1 &
    segurando_descida_1 <: segurando_descida &
    segurando_descida <: pedidos_descida

INITIALISATION
    pedidos_internos := {} ||
    pedidos_subida := {} ||
    pedidos_descida := {} ||
    piscando_interno1 := {} ||
    piscando_subida1 := {} ||
    piscando_descida1 := {} ||
    piscando_interno2 := {} || piscando_interno3 := {} || piscando_interno4 := {} ||
    piscando_subida2 := {} || piscando_subida3 := {} || piscando_subida4 := {} ||
    piscando_descida2 := {} || piscando_descida3 := {} || piscando_descida4 := {} ||
    segurando_interno := {} ||
    segurando_interno_1 := {} ||
    segurando_interno_2 := {} ||
    interno_recusado := {} ||
    segurando_subida := {} ||
    segurando_subida_1 := {} ||
    segurando_subida_2 := {} ||
    segurando_descida := {} ||
    segurando_descida_1 := {} ||
    segurando_descida_2 := {} ||
    historico_paradas := []

OPERATIONS

    /* REGISTRO E REINICIO DE CONTAGEM AO PRESSIONAR (HLR-004 / HLR-005).
       Cada nova pressao inicia uma nova tentativa de segurar por 3 s.
       Uma pressao valida encerra qualquer piscada anterior desse LED. */
    registrar_interno(alvo) =
        PRE alvo : 0..andar_maximo THEN
            pedidos_internos := pedidos_internos \/ {alvo} ||
            segurando_interno := segurando_interno \/ {alvo} ||
            segurando_interno_1 := segurando_interno_1 - {alvo} ||
            segurando_interno_2 := segurando_interno_2 - {alvo} ||
            interno_recusado := interno_recusado - {alvo} ||
            piscando_interno1 := piscando_interno1 - {alvo} ||
            piscando_interno2 := piscando_interno2 - {alvo} ||
            piscando_interno3 := piscando_interno3 - {alvo} ||
            piscando_interno4 := piscando_interno4 - {alvo}
        END;

    registrar_externo_subida(alvo) =
        PRE alvo : 0..(andar_maximo - 1) & alvo |-> subindo : painel_externo THEN
            pedidos_subida := pedidos_subida \/ {alvo} ||
            segurando_subida := segurando_subida \/ {alvo} ||
            segurando_subida_1 := segurando_subida_1 - {alvo} ||
            segurando_subida_2 := segurando_subida_2 - {alvo} ||
            piscando_subida1 := piscando_subida1 - {alvo} ||
            piscando_subida2 := piscando_subida2 - {alvo} ||
            piscando_subida3 := piscando_subida3 - {alvo} ||
            piscando_subida4 := piscando_subida4 - {alvo}
        END;

    registrar_externo_descida(alvo) =
        PRE alvo : 1..andar_maximo & alvo |-> descendo : painel_externo THEN
            pedidos_descida := pedidos_descida \/ {alvo} ||
            segurando_descida := segurando_descida \/ {alvo} ||
            segurando_descida_1 := segurando_descida_1 - {alvo} ||
            segurando_descida_2 := segurando_descida_2 - {alvo} ||
            piscando_descida1 := piscando_descida1 - {alvo} ||
            piscando_descida2 := piscando_descida2 - {alvo} ||
            piscando_descida3 := piscando_descida3 - {alvo} ||
            piscando_descida4 := piscando_descida4 - {alvo}
        END;

    /* O botao pode ser solto antes dos tres segundos.
       O pedido continua ativo, mas sua contagem de retencao termina. */
    liberar_interno(alvo) =
        PRE alvo : 0..andar_maximo THEN
            segurando_interno := segurando_interno - {alvo} ||
            segurando_interno_1 := segurando_interno_1 - {alvo} ||
            segurando_interno_2 := segurando_interno_2 - {alvo} ||
            interno_recusado := interno_recusado - {alvo}
        END;

    liberar_subida(alvo) =
        PRE alvo : 0..(andar_maximo - 1) THEN
            segurando_subida := segurando_subida - {alvo} ||
            segurando_subida_1 := segurando_subida_1 - {alvo} ||
            segurando_subida_2 := segurando_subida_2 - {alvo}
        END;

    liberar_descida(alvo) =
        PRE alvo : 1..andar_maximo THEN
            segurando_descida := segurando_descida - {alvo} ||
            segurando_descida_1 := segurando_descida_1 - {alvo} ||
            segurando_descida_2 := segurando_descida_2 - {alvo}
        END;

    /* Um tick equivale a um segundo.
       segurando_2: pressionado ha dois ticks, vence agora.
       A atualizacao simultanea usa valores do estado ANTERIOR.
       Sem lambda, composicao relacional ou funcao parcial. */
    avancar_tempo_botoes =
        BEGIN
            IF pedidos_internos /= {} & pedidos_internos = segurando_interno_2 &
               pedidos_subida - segurando_subida_2 = {} &
               pedidos_descida - segurando_descida_2 = {} THEN
                /* Todos os internos vencem juntos: so o menor permanece. */
                pedidos_internos := {min(pedidos_internos)} ||
                segurando_interno := {} ||
                segurando_interno_1 := {} ||
                segurando_interno_2 := {} ||
                interno_recusado := {min(pedidos_internos)} ||
                piscando_interno1 := {min(pedidos_internos)} ||
                piscando_interno2 := piscando_interno1 - {min(pedidos_internos)} ||
                piscando_interno3 := piscando_interno2 - {min(pedidos_internos)} ||
                piscando_interno4 := piscando_interno3 - {min(pedidos_internos)}
            ELSE
                pedidos_internos := pedidos_internos - segurando_interno_2 ||
                segurando_interno := segurando_interno - segurando_interno_2 ||
                segurando_interno_1 := segurando_interno - segurando_interno_2 ||
                segurando_interno_2 := segurando_interno_1 - segurando_interno_2 ||
                interno_recusado := interno_recusado - segurando_interno_2 ||
                piscando_interno1 := {} ||
                piscando_interno2 := piscando_interno1 ||
                piscando_interno3 := piscando_interno2 ||
                piscando_interno4 := piscando_interno3
            END ||
            pedidos_subida := pedidos_subida - segurando_subida_2 ||
            segurando_subida := segurando_subida - segurando_subida_2 ||
            segurando_subida_1 := segurando_subida - segurando_subida_2 ||
            segurando_subida_2 := segurando_subida_1 - segurando_subida_2 ||
            piscando_subida1 := {} ||
            piscando_subida2 := piscando_subida1 ||
            piscando_subida3 := piscando_subida2 ||
            piscando_subida4 := piscando_subida3 ||
            pedidos_descida := pedidos_descida - segurando_descida_2 ||
            segurando_descida := segurando_descida - segurando_descida_2 ||
            segurando_descida_1 := segurando_descida - segurando_descida_2 ||
            segurando_descida_2 := segurando_descida_1 - segurando_descida_2 ||
            piscando_descida1 := {} ||
            piscando_descida2 := piscando_descida1 ||
            piscando_descida3 := piscando_descida2 ||
            piscando_descida4 := piscando_descida3
        END;

    /* Durante a manutencao todos os pedidos estao vazios.
       Avanca apenas as quatro fases dos LEDs, sem expandir a
       logica de cancelamento da operacao avancar_tempo_botoes. */
    avancar_piscadas_manutencao =
        BEGIN
            piscando_interno1 := {} ||
            piscando_interno2 := piscando_interno1 ||
            piscando_interno3 := piscando_interno2 ||
            piscando_interno4 := piscando_interno3 ||
            piscando_subida1 := {} ||
            piscando_subida2 := piscando_subida1 ||
            piscando_subida3 := piscando_subida2 ||
            piscando_subida4 := piscando_subida3 ||
            piscando_descida1 := {} ||
            piscando_descida2 := piscando_descida1 ||
            piscando_descida3 := piscando_descida2 ||
            piscando_descida4 := piscando_descida3
        END;

    cancelar_todos =
        BEGIN
            segurando_interno := {} ||
            segurando_interno_1 := {} ||
            segurando_interno_2 := {} ||
            interno_recusado := {} ||
            segurando_subida := {} ||
            segurando_subida_1 := {} ||
            segurando_subida_2 := {} ||
            segurando_descida := {} ||
            segurando_descida_1 := {} ||
            segurando_descida_2 := {} ||
            pedidos_internos := {} || pedidos_subida := {} || pedidos_descida := {} ||
            piscando_interno1 := {} || piscando_interno2 := {} || piscando_interno3 := {} || piscando_interno4 := {} ||
            piscando_subida1 := {} || piscando_subida2 := {} || piscando_subida3 := {} || piscando_subida4 := {} ||
            piscando_descida1 := {} || piscando_descida2 := {} || piscando_descida3 := {} || piscando_descida4 := {}
        END;

    /* Cancelamentos por retencao nao sao operacoes diretas.
       O terceiro tick de avancar_tempo_botoes cancela atomicamente
       pedidos externos e internos elegiveis, evitando cancelar antes de 3s. */

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
                piscando_interno3 := piscando_interno3 - {alvo} || piscando_interno4 := piscando_interno4 - {alvo} ||
                segurando_interno := segurando_interno - {alvo} ||
                segurando_interno_1 := segurando_interno_1 - {alvo} ||
                segurando_interno_2 := segurando_interno_2 - {alvo} ||
                interno_recusado := interno_recusado - {alvo}
            END ||
            IF (sentido = subindo or sentido = parado) & alvo : pedidos_subida THEN
                pedidos_subida := pedidos_subida - {alvo} ||
                piscando_subida1 := piscando_subida1 - {alvo} ||
                piscando_subida2 := piscando_subida2 - {alvo} ||
                piscando_subida3 := piscando_subida3 - {alvo} || piscando_subida4 := piscando_subida4 - {alvo} ||
                segurando_subida := segurando_subida - {alvo} ||
                segurando_subida_1 := segurando_subida_1 - {alvo} ||
                segurando_subida_2 := segurando_subida_2 - {alvo}
            END ||
            IF (sentido = descendo or (sentido = parado & alvo /: pedidos_subida)) & alvo : pedidos_descida THEN
                pedidos_descida := pedidos_descida - {alvo} ||
                piscando_descida1 := piscando_descida1 - {alvo} ||
                piscando_descida2 := piscando_descida2 - {alvo} ||
                piscando_descida3 := piscando_descida3 - {alvo} || piscando_descida4 := piscando_descida4 - {alvo} ||
                segurando_descida := segurando_descida - {alvo} ||
                segurando_descida_1 := segurando_descida_1 - {alvo} ||
                segurando_descida_2 := segurando_descida_2 - {alvo}
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
            piscando_interno1 := piscando_interno1 \/ {alvo} ||
                piscando_interno2 := piscando_interno2 - {alvo} ||
                piscando_interno3 := piscando_interno3 - {alvo} || piscando_interno4 := piscando_interno4 - {alvo}
        END;

    piscar_subida(alvo) =
        PRE alvo : 0..(andar_maximo - 1) & alvo |-> subindo : painel_externo THEN
            piscando_subida1 := piscando_subida1 \/ {alvo} ||
                piscando_subida2 := piscando_subida2 - {alvo} ||
                piscando_subida3 := piscando_subida3 - {alvo} || piscando_subida4 := piscando_subida4 - {alvo}
        END;

    piscar_descida(alvo) =
        PRE alvo : 1..andar_maximo & alvo |-> descendo : painel_externo THEN
            piscando_descida1 := piscando_descida1 \/ {alvo} ||
                piscando_descida2 := piscando_descida2 - {alvo} ||
                piscando_descida3 := piscando_descida3 - {alvo} || piscando_descida4 := piscando_descida4 - {alvo}
        END;

    /* CONSULTAS */
    leds_internos, leds_subida, leds_descida <-- consultar_leds =
        BEGIN
            leds_internos := (pedidos_internos - (piscando_interno1 \/ piscando_interno2 \/ piscando_interno3 \/ piscando_interno4)) \/ piscando_interno1 \/ piscando_interno3 ||
            leds_subida := (pedidos_subida - (piscando_subida1 \/ piscando_subida2 \/ piscando_subida3 \/ piscando_subida4)) \/ piscando_subida1 \/ piscando_subida3 ||
            leds_descida := (pedidos_descida - (piscando_descida1 \/ piscando_descida2 \/ piscando_descida3 \/ piscando_descida4)) \/ piscando_descida1 \/ piscando_descida3
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
            botoes_internos := segurando_interno \/ interno_recusado ||
            botoes_subida := segurando_subida ||
            botoes_descida := segurando_descida
        END;

    internos_com_tempo, subida_com_tempo, descida_com_tempo <-- consultar_botoes_com_tempo(tt) =
        PRE tt : (-1..3)
        THEN
            IF tt = -1 THEN
                internos_com_tempo := (0..andar_maximo) - (segurando_interno \/ interno_recusado) ||
                subida_com_tempo := (0..(andar_maximo - 1)) - segurando_subida ||
                descida_com_tempo := (1..andar_maximo) - segurando_descida
            ELSIF tt = 0 THEN
                internos_com_tempo := segurando_interno - segurando_interno_1 ||
                subida_com_tempo := segurando_subida - segurando_subida_1 ||
                descida_com_tempo := segurando_descida - segurando_descida_1
            ELSIF tt = 1 THEN
                internos_com_tempo := segurando_interno_1 - segurando_interno_2 ||
                subida_com_tempo := segurando_subida_1 - segurando_subida_2 ||
                descida_com_tempo := segurando_descida_1 - segurando_descida_2
            ELSIF tt = 2 THEN
                internos_com_tempo := segurando_interno_2 ||
                subida_com_tempo := segurando_subida_2 ||
                descida_com_tempo := segurando_descida_2
            ELSE
                internos_com_tempo := interno_recusado ||
                subida_com_tempo := {} ||
                descida_com_tempo := {}
            END
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