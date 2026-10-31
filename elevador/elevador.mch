/* Maquina abstrata B -- requisitos de Controle Elevador.txt (HLR-001..010). */
MACHINE elevador

SETS
    DIRECOES = {subindo, descendo, parado};
    PORTAS = {aberta, fechada}

CONSTANTS peso_maximo

PROPERTIES peso_maximo = 450

VARIABLES
    andar, direcao, porta, peso,
    chave_manutencao, manutencao, manutencao_pendente,
    pedidos_cabine, pedidos_subida, pedidos_descida,
    leds_cabine, leds_subida, leds_descida,
    piscando_cabine, piscando_subida, piscando_descida,
    minutos_porta_aberta, aviso_porta_aberta, deslocamento

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

    /* HLR-003 e HLR-007. */
    abrir_porta =
        PRE direcao = parado & porta = fechada & manutencao = FALSE
        THEN porta := aberta || minutos_porta_aberta := 0 || aviso_porta_aberta := FALSE END;
    fechar_porta =
        PRE direcao = parado & porta = aberta & manutencao = FALSE
        THEN porta := fechada || minutos_porta_aberta := 0 || aviso_porta_aberta := FALSE END;
    passar_um_minuto =
        PRE porta = aberta
        THEN minutos_porta_aberta := minutos_porta_aberta + 1 ||
             aviso_porta_aberta := bool(minutos_porta_aberta + 1 > 2) END;

    /* HLR-009: o peso e livremente medido, mas sobrecarga bloqueia movimento. */
    atualizar_peso(novo_peso) =
        PRE novo_peso : NATURAL THEN peso := novo_peso END;

    /* HLR-010: partir apenas na direcao de algum pedido reduz deslocamento inutil. */
    iniciar_subida =
        PRE direcao = parado & porta = fechada & manutencao = FALSE &
            manutencao_pendente = FALSE & peso <= peso_maximo & andar < 4 &
            (pedidos_cabine \/ pedidos_subida \/ pedidos_descida) /\ (andar+1..4) /= {}
        THEN direcao := subindo END;
        
    iniciar_descida =
        PRE direcao = parado & porta = fechada & manutencao = FALSE &
            manutencao_pendente = FALSE & peso <= peso_maximo & andar > 0 &
            (pedidos_cabine \/ pedidos_subida \/ pedidos_descida) /\ (0..andar-1) /= {}
        THEN direcao := descendo END;

    /* Ao chegar a um pedido, ele e atendido, os LEDs apagam e a porta abre. */
    subir =
        PRE direcao = subindo & porta = fechada & manutencao = FALSE &
            manutencao_pendente = FALSE & peso <= peso_maximo & andar < 4
        THEN
            IF andar + 1 : (pedidos_cabine \/ pedidos_subida \/ pedidos_descida) THEN
                andar := andar + 1 || direcao := parado || porta := aberta ||
                pedidos_cabine := pedidos_cabine - {andar + 1} ||
                pedidos_subida := pedidos_subida - {andar + 1} ||
                pedidos_descida := pedidos_descida - {andar + 1} ||
                leds_cabine := leds_cabine - {andar + 1} ||
                leds_subida := leds_subida - {andar + 1} ||
                leds_descida := leds_descida - {andar + 1} ||
                minutos_porta_aberta := 0 || aviso_porta_aberta := FALSE ||
                deslocamento := deslocamento + 1
            ELSE andar := andar + 1 || deslocamento := deslocamento + 1 END
        END;
    descer =
        PRE direcao = descendo & porta = fechada & manutencao = FALSE &
            manutencao_pendente = FALSE & peso <= peso_maximo & andar > 0
        THEN
            IF andar - 1 : (pedidos_cabine \/ pedidos_subida \/ pedidos_descida) THEN
                andar := andar - 1 || direcao := parado || porta := aberta ||
                pedidos_cabine := pedidos_cabine - {andar - 1} ||
                pedidos_subida := pedidos_subida - {andar - 1} ||
                pedidos_descida := pedidos_descida - {andar - 1} ||
                leds_cabine := leds_cabine - {andar - 1} ||
                leds_subida := leds_subida - {andar - 1} ||
                leds_descida := leds_descida - {andar - 1} ||
                minutos_porta_aberta := 0 || aviso_porta_aberta := FALSE ||
                deslocamento := deslocamento + 1
            ELSE andar := andar - 1 || deslocamento := deslocamento + 1 END
        END;

    /* HLR-006: depois do ultimo cancelamento, completa somente o proximo trecho. */
    parar_no_proximo_subindo =
        PRE direcao = subindo & pedidos_cabine = {} & pedidos_subida = {} &
            pedidos_descida = {} & andar < 4
        THEN andar := andar + 1 || direcao := parado || deslocamento := deslocamento + 1 END;
    parar_no_proximo_descendo =
        PRE direcao = descendo & pedidos_cabine = {} & pedidos_subida = {} &
            pedidos_descida = {} & andar > 0
        THEN andar := andar - 1 || direcao := parado || deslocamento := deslocamento + 1 END;

    /* HLR-008: chave cancela tudo ao parar e torna os paineis inoperantes. */
    inserir_chave_manutencao =
        PRE chave_manutencao = FALSE
        THEN IF direcao = parado THEN
                chave_manutencao := TRUE || manutencao := TRUE || manutencao_pendente := FALSE ||
                pedidos_cabine := {} || pedidos_subida := {} || pedidos_descida := {} ||
                leds_cabine := {} || leds_subida := {} || leds_descida := {}
             ELSE chave_manutencao := TRUE || manutencao_pendente := TRUE END END;
    parar_para_manutencao_subindo =
        PRE manutencao_pendente = TRUE & direcao = subindo & andar < 4
        THEN andar := andar + 1 || direcao := parado || manutencao := TRUE ||
             manutencao_pendente := FALSE || pedidos_cabine := {} ||
             pedidos_subida := {} || pedidos_descida := {} || leds_cabine := {} ||
             leds_subida := {} || leds_descida := {} || deslocamento := deslocamento + 1 END;
    parar_para_manutencao_descendo =
        PRE manutencao_pendente = TRUE & direcao = descendo & andar > 0
        THEN andar := andar - 1 || direcao := parado || manutencao := TRUE ||
             manutencao_pendente := FALSE || pedidos_cabine := {} ||
             pedidos_subida := {} || pedidos_descida := {} || leds_cabine := {} ||
             leds_subida := {} || leds_descida := {} || deslocamento := deslocamento + 1 END;
    iniciar_manutencao_ao_parar =
        PRE manutencao_pendente = TRUE & direcao = parado
        THEN manutencao := TRUE || manutencao_pendente := FALSE ||
             pedidos_cabine := {} || pedidos_subida := {} || pedidos_descida := {} ||
             leds_cabine := {} || leds_subida := {} || leds_descida := {} END;
    remover_chave_manutencao =
        PRE chave_manutencao = TRUE & direcao = parado
        THEN chave_manutencao := FALSE || manutencao := FALSE || manutencao_pendente := FALSE END;
    pressionar_cabine_em_manutencao(pavimento) =
        PRE manutencao = TRUE & pavimento : 0..4 THEN piscando_cabine := piscando_cabine \/ {pavimento} END;
    pressionar_subida_em_manutencao(pavimento) =
        PRE manutencao = TRUE & pavimento : 0..3 THEN piscando_subida := piscando_subida \/ {pavimento} END;
    pressionar_descida_em_manutencao(pavimento) =
        PRE manutencao = TRUE & pavimento : 1..4 THEN piscando_descida := piscando_descida \/ {pavimento} END

END
