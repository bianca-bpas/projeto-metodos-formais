
/* elevador
 * Author: win11
 * Creation date: 04/11/2026
 */

MACHINE elevador

SEES configuracao

INCLUDES
    painel_pedidos,
    cabine_movimento,
    controle_manutencao

PROMOTES atualizar_peso, ajustar_peso, consultar_peso, consultar_folga,
         consultar_estado, consultar_deslocamento, consultar_visitas,
         liberar_interno, liberar_subida, liberar_descida, consultar_estado_manutencao,
         consultar_botoes_pressionados, consultar_botoes_com_tempo,
         consultar_historico_paradas, consultar_extremos_historico,
         sugerir_pedido_qualquer

VARIABLES piscando_abrir, piscando_fechar

INVARIANT
    andar : 0..4 & direcao : DIRECOES & porta : PORTAS & peso : NATURAL &
    chave_manutencao : BOOL & manutencao : BOOL & manutencao_pendente : BOOL &
    pedidos_cabine <: 0..4 & pedidos_subida <: 0..3 & pedidos_descida <: 1..4 &
    leds_cabine = pedidos_cabine & leds_subida = pedidos_subida &
    leds_descida = pedidos_descida &
    piscando_cabine <: 0..4 & piscando_subida <: 0..3 & piscando_descida <: 1..4 &
    minutos_porta_aberta : NATURAL & aviso_porta_aberta : BOOL & deslocamento : NATURAL &
    (direcao /= parado => porta = fechada) &
    (manutencao = TRUE => direcao = parado & pedidos_cabine = {} &
                           pedidos_subida = {} & pedidos_descida = {}) &
    (porta = fechada => minutos_porta_aberta = 0) &
    (minutos_porta_aberta <= 2 => aviso_porta_aberta = FALSE)

INITIALISATION
    andar := 0 || direcao := parado || porta := fechada || peso := 0 ||
    chave_manutencao := FALSE || manutencao := FALSE || manutencao_pendente := FALSE ||
    pedidos_cabine := {} || pedidos_subida := {} || pedidos_descida := {} ||
    leds_cabine := {} || leds_subida := {} || leds_descida := {} ||
    piscando_cabine := {} || piscando_subida := {} || piscando_descida := {} ||
    minutos_porta_aberta := 0 || aviso_porta_aberta := FALSE || deslocamento := 0

OPERATIONS
    /* HLR-002..004: o pedido e o LED permanecem ativos ate atendimento/cancelamento. */
    chamar_cabine(pavimento) =
        PRE pavimento : 0..4 & manutencao = FALSE
        THEN pedidos_cabine := pedidos_cabine \/ {pavimento} || leds_cabine := leds_cabine \/ {pavimento} END;
    chamar_subida(pavimento) =
        PRE pavimento : 0..3 & manutencao = FALSE
        THEN pedidos_subida := pedidos_subida \/ {pavimento} || leds_subida := leds_subida \/ {pavimento} END;
    chamar_descida(pavimento) =
        PRE pavimento : 1..4 & manutencao = FALSE
        THEN pedidos_descida := pedidos_descida \/ {pavimento} || leds_descida := leds_descida \/ {pavimento} END;

    /* HLR-005: somente o ultimo pedido total nao pode ser cancelado. */
    cancelar_cabine(pavimento) =
        PRE pavimento : pedidos_cabine & manutencao = FALSE &
            card(pedidos_cabine \/ pedidos_subida \/ pedidos_descida) > 1
        THEN pedidos_cabine := pedidos_cabine - {pavimento} || leds_cabine := leds_cabine - {pavimento} END;
        
    recusar_cancelamento_cabine(pavimento) =
        PRE pavimento : pedidos_cabine & manutencao = FALSE &
            card(pedidos_cabine \/ pedidos_subida \/ pedidos_descida) = 1
        THEN piscando_cabine := piscando_cabine \/ {pavimento} END;
        
    cancelar_subida(pavimento) =
        PRE pavimento : pedidos_subida & manutencao = FALSE
        THEN pedidos_subida := pedidos_subida - {pavimento} || leds_subida := leds_subida - {pavimento} END;
        
    cancelar_descida(pavimento) =
        PRE pavimento : pedidos_descida & manutencao = FALSE
        THEN pedidos_descida := pedidos_descida - {pavimento} || leds_descida := leds_descida - {pavimento} END;
    fim_da_piscada =
        BEGIN piscando_cabine := {} || piscando_subida := {} || piscando_descida := {} END;

    /* --- CANCELAMENTOS COM TRATAMENTO HLR-006 ---
       alvo : dom((P <| tempo) |> {3})  equivale a  alvo : P & tempo(alvo) = 3 */

    elevador_cancelar_interno(alvo) =
        PRE
            alvo : dom((pedidos_internos <| tempo_interno) |> {3})
        THEN
            /* if card = 1, pisca e não remove */
            cancelamento_interno(alvo)
        END;

    elevador_cancelar_subida(alvo) =
        PRE
            alvo : dom((pedidos_subida <| tempo_subida) |> {3})
        THEN
            cancelamento_externo_subida(alvo) ||
            /* HLR-006: Ativa parada pendente APENAS se este era o UNICO pedido de todo o elevador */
            IF direcao /= parado &
               pedidos_subida = {alvo} &
               pedidos_internos = {} &
               pedidos_descida = {}
            THEN
                solicitar_parada_pendente
            END
        END;

    elevador_cancelar_descida(alvo) =
        PRE
            alvo : dom((pedidos_descida <| tempo_descida) |> {3})
        THEN
            cancelamento_externo_descida(alvo) ||
            /* HLR-006: Ativa parada pendente APENAS se este era o UNICO pedido de todo o elevador */
            IF direcao /= parado &
               pedidos_descida = {alvo} &
               pedidos_internos = {} &
               pedidos_subida = {}
            THEN
                solicitar_parada_pendente
            END
        END;

    /* --- CONTROLE DE MOVIMENTO (PREPROPRIADOS PARA AS POs) --- */

    elevador_iniciar_subida =
        PRE
            (sentido_atendimento /= parado or pedidos_subida /= {} or pedidos_descida /= {} or
             (pedidos_internos /\ (0..(andar - 1))) = {} or
             (pedidos_internos /\ ((andar + 1)..andar_maximo)) = {} or
             max(pedidos_internos \/ {andar}) - andar <= andar - min(pedidos_internos \/ {andar})) &
            manutencao = FALSE &
            direcao = parado &
            porta = fechada &
            limite_peso_atingido = FALSE &
            andar < andar_maximo &
            (sentido_atendimento = parado or sentido_atendimento = subindo) &
            andar /: (pedidos_internos \/ pedidos_subida) &
            ((pedidos_internos \/ pedidos_subida \/ pedidos_descida) /\ ((andar + 1)..andar_maximo)) /= {}
        THEN
            iniciar_subida(pedidos_internos \/ pedidos_subida \/ pedidos_descida, pedidos_internos \/ pedidos_subida)
        END;

    elevador_iniciar_descida =
        PRE
            (sentido_atendimento /= parado or pedidos_subida /= {} or pedidos_descida /= {} or
             (pedidos_internos /\ (0..(andar - 1))) = {} or
             (pedidos_internos /\ ((andar + 1)..andar_maximo)) = {} or
             andar - min(pedidos_internos \/ {andar}) <= max(pedidos_internos \/ {andar}) - andar) &
            manutencao = FALSE &
            direcao = parado &
            porta = fechada &
            limite_peso_atingido = FALSE &
            andar > 0 &
            (sentido_atendimento = parado or sentido_atendimento = descendo) &
            andar /: (pedidos_internos \/ pedidos_descida) &
            ((pedidos_internos \/ pedidos_subida \/ pedidos_descida) /\ (0..(andar - 1))) /= {}
        THEN
            iniciar_descida(pedidos_internos \/ pedidos_subida \/ pedidos_descida, pedidos_internos \/ pedidos_descida)
        END;

    elevador_subir =
        PRE
            direcao = subindo &
            porta = fechada &
            limite_peso_atingido = FALSE &
            andar < andar_maximo
        THEN
            subir(pedidos_internos, pedidos_subida, pedidos_descida) ||
            IF manutencao_pendente = TRUE THEN
                confirmar_parada_manutencao(TRUE) || cancelar_todos
            END
        END;

    elevador_descer =
        PRE
            direcao = descendo &
            porta = fechada &
            limite_peso_atingido = FALSE &
            andar > 0
        THEN
            descer(pedidos_internos, pedidos_subida, pedidos_descida) ||
            IF manutencao_pendente = TRUE THEN
                confirmar_parada_manutencao(TRUE) || cancelar_todos
            END
        END;

    elevador_inverter_sentido =
        PRE
            direcao = parado &
            porta = fechada &
            andar /: pedidos_internos &
            (
                (sentido_atendimento = subindo &
                 andar /: pedidos_subida &
                 ((pedidos_internos \/ pedidos_subida \/ pedidos_descida) /\ ((andar + 1)..andar_maximo)) = {} &
                 (andar : pedidos_descida or ((pedidos_internos \/ pedidos_subida \/ pedidos_descida) /\ (0..(andar - 1))) /= {}))
                or
                (sentido_atendimento = descendo &
                 andar /: pedidos_descida &
                 ((pedidos_internos \/ pedidos_subida \/ pedidos_descida) /\ (0..(andar - 1))) = {} &
                 (andar : pedidos_subida or ((pedidos_internos \/ pedidos_subida \/ pedidos_descida) /\ ((andar + 1)..andar_maximo)) /= {}))
            )
        THEN
            inverter_sentido(pedidos_internos, pedidos_subida, pedidos_descida)
        END;

    /* --- ATENDIMENTO E LIMPEZA DE PEDIDOS ---
       HLR-003: botoes de abrir/fechar porta sao operacoes totais: sem efeito
       quando a cabine esta em movimento (ELSE skip). */

    elevador_abrir_porta =
        SELECT manutencao = TRUE THEN
            piscando_abrir := 2
        WHEN manutencao = FALSE & direcao = parado & porta = fechada THEN
            abrir_porta(pedidos_internos, pedidos_subida, pedidos_descida) ||
            atender_pedidos_andar(andar, sentido_atendimento)
        ELSE
            skip
        END;

    elevador_fechar_porta =
        SELECT manutencao = TRUE THEN
            piscando_fechar := 2
        WHEN manutencao = FALSE & porta = aberta THEN
            fechar_porta
        ELSE
            skip
        END;

    avancar_piscadas_porta =
        PRE piscando_abrir > 0 or piscando_fechar > 0
        THEN
            IF piscando_abrir > 0 THEN piscando_abrir := piscando_abrir - 1 END ||
            IF piscando_fechar > 0 THEN piscando_fechar := piscando_fechar - 1 END
        END;

    elevador_entrar_em_reposo =
        PRE
            direcao = parado &
            porta = fechada &
            pedidos_internos = {} &
            pedidos_subida = {} &
            pedidos_descida = {}
        THEN
            entrar_em_reposo(pedidos_internos, pedidos_subida, pedidos_descida)
        END;

    elevador_parar_piscar =
        PRE
            piscando_interno1 /= {} or piscando_interno2 /= {} or
            piscando_subida1 /= {}  or piscando_subida2 /= {}  or
            piscando_descida1 /= {} or piscando_descida2 /= {}
        THEN
            parar_piscar
        END;

    /* --- CONSULTAS (sem alteracao de estado) --- */
    acima, abaixo, existe_acima <-- consultar_pedidos_ao_redor =
        LET todos BE todos = pedidos_internos \/ pedidos_subida \/ pedidos_descida IN
            acima := {pp | pp : todos & pp > andar} ||
            abaixo := {pp | pp : todos & pp < andar} ||
            existe_acima := bool(#pp.(pp : todos & pp > andar))
        END;

    /* HLR-010: escolhe (nao deterministicamente) um dos pedidos pendentes mais proximos da cabine */
    alvo <-- sugerir_pedido_mais_proximo =
        PRE (pedidos_internos \/ pedidos_subida \/ pedidos_descida) /= {}
        THEN
            ANY aa WHERE
                aa : (pedidos_internos \/ pedidos_subida \/ pedidos_descida) &
                !bb.(bb : (pedidos_internos \/ pedidos_subida \/ pedidos_descida) =>
                    (aa - andar) * (aa - andar) <= (bb - andar) * (bb - andar))
            THEN
                alvo := aa
            END
        END;

    trajeto <-- consultar_trajeto =
        BEGIN
            trajeto := andar -> rev(historico_paradas)
        END;

    /* HLR-002: botoes do painel externo de um pavimento */
    botoes <-- consultar_botoes_painel(pav) =
        PRE pav : 0..andar_maximo
        THEN
            botoes := painel_externo[{pav}]
        END;

    /* HLR-002: estrutura dos paineis externos */
    andares_com_subida, andares_com_descida, paineis_intermediarios, painel_do_ultimo, so_botoes_subida <-- consultar_mapa_paineis =
        BEGIN
            andares_com_subida := painel_externo~[{subindo}] ||
            andares_com_descida := dom(painel_externo |> {descendo}) ||
            paineis_intermediarios := {0, andar_maximo} <<| painel_externo ||
            painel_do_ultimo := {andar_maximo} <| painel_externo ||
            so_botoes_subida := painel_externo |>> {descendo}
        END
END
