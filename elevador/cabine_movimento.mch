MACHINE cabine_movimento

SEES configuracao

VARIABLES
    andar,
    direcao,
    deslocamento,
    porta,
    sentido_atendimento,
    parada_pendente,
    peso,
    limite_peso_atingido,
    segundos_porta_aberta,
    ultima_visita,
    chave_manutencao,
    manutencao,
    manutencao_pendente

INVARIANT
    andar : 0..andar_maximo &
    direcao : DIRECOES &
    deslocamento : NATURAL &
    porta : PORTAS &
    sentido_atendimento : DIRECOES &
    (direcao = subindo => sentido_atendimento = subindo) &
    (direcao = descendo => sentido_atendimento = descendo) &
    parada_pendente : BOOL &
    peso : NATURAL &
    limite_peso_atingido : BOOL &
    (limite_peso_atingido = TRUE <=> peso > peso_maximo) &
    (direcao /= parado => porta = fechada) &
    (direcao /= parado => limite_peso_atingido = FALSE) &
    (direcao = subindo => andar < andar_maximo) &
    (direcao = descendo => andar > 0) &
    (parada_pendente = TRUE => direcao /= parado) &
    segundos_porta_aberta : 0..121 &
    (porta = fechada => segundos_porta_aberta = 0) &
    ultima_visita : (0..andar_maximo) +-> NATURAL &
    ran(ultima_visita) <: 0..deslocamento &
    chave_manutencao : BOOL &
    manutencao : BOOL &
    manutencao_pendente : BOOL &
    (manutencao = TRUE => chave_manutencao = TRUE) &
    (manutencao = TRUE => direcao = parado) &
    (manutencao_pendente = TRUE => chave_manutencao = TRUE) &
    not (manutencao = TRUE & manutencao_pendente = TRUE) &
    (manutencao_pendente = TRUE => direcao /= parado)

INITIALISATION
    andar := 0 ||
    direcao := parado ||
    deslocamento := 0 ||
    porta := fechada ||
    sentido_atendimento := parado ||
    parada_pendente := FALSE ||
    peso := 0 ||
    limite_peso_atingido := FALSE ||
    segundos_porta_aberta := 0 ||
    ultima_visita := {} ||
    chave_manutencao := FALSE ||
    manutencao := FALSE ||
    manutencao_pendente := FALSE

OPERATIONS

    /* MANUTENÇÃO (HLR-008) */
    inserir_chave_manutencao =
        PRE chave_manutencao = FALSE THEN
            chave_manutencao := TRUE ||
            IF direcao = parado THEN
                manutencao := TRUE || manutencao_pendente := FALSE || segundos_porta_aberta := 0
            ELSE
                manutencao_pendente := TRUE ||
                parada_pendente := TRUE
            END
        END;

    confirmar_parada_manutencao =
        PRE chave_manutencao = TRUE & manutencao_pendente = TRUE & direcao = parado THEN
            manutencao := TRUE || manutencao_pendente := FALSE
        END;

    remover_chave_manutencao =
        PRE chave_manutencao = TRUE & ((manutencao = TRUE & direcao = parado) or manutencao_pendente = TRUE) THEN
            chave_manutencao := FALSE || manutencao := FALSE || manutencao_pendente := FALSE
        END;

    /* CONTROLE DE PESO (HLR-009) */
    atualizar_peso(novo_peso) =
        PRE novo_peso : NATURAL & direcao = parado THEN
            peso := novo_peso ||
            limite_peso_atingido := bool(novo_peso > peso_maximo)
        END;

    ajustar_peso(delta) =
        PRE delta : INTEGER & direcao = parado & peso + delta : NATURAL THEN
            peso := peso + delta ||
            limite_peso_atingido := bool(peso + delta > peso_maximo)
        END;

    /* TEMPORIZADOR DE PORTA (HLR-007) */
    avancar_tempo_porta(parar) =
        PRE parar : BOOL & (parar = TRUE => direcao /= parado) THEN
            IF porta = aberta & segundos_porta_aberta < 121 THEN
                segundos_porta_aberta := segundos_porta_aberta + 1
            END ||
            IF parar = TRUE THEN parada_pendente := TRUE END
        END;

    zerar_tempo_porta =
        PRE manutencao = TRUE THEN
            segundos_porta_aberta := 0
        END;

    /* MOVIMENTAÇÃO E SEGURANÇA (HLR-006) */
    solicitar_parada_pendente =
        PRE direcao /= parado THEN
            parada_pendente := TRUE
        END;

    /* A politica de pedidos pertence ao controlador; aqui ficam as segurancas. */
    iniciar_subida =
        PRE
            direcao = parado & porta = fechada &
            limite_peso_atingido = FALSE & manutencao = FALSE &
            andar < andar_maximo &
            (sentido_atendimento = parado or sentido_atendimento = subindo)
        THEN
            direcao := subindo || sentido_atendimento := subindo
        END;

    /* A politica de pedidos pertence ao controlador; aqui ficam as segurancas. */
    iniciar_descida =
        PRE
            direcao = parado & porta = fechada &
            limite_peso_atingido = FALSE & manutencao = FALSE &
            andar > 0 &
            (sentido_atendimento = parado or sentido_atendimento = descendo)
        THEN
            direcao := descendo || sentido_atendimento := descendo
        END;

    subir(p_int, p_sub, p_des) =
        PRE
            p_int <: 0..andar_maximo & p_sub <: 0..(andar_maximo - 1) & p_des <: 1..andar_maximo &
            direcao = subindo & porta = fechada & limite_peso_atingido = FALSE &
            manutencao = FALSE & andar < andar_maximo
        THEN
            andar := andar + 1 || deslocamento := deslocamento + 1 ||
            IF andar + 1 = andar_maximo or parada_pendente = TRUE or (andar + 1) : (p_int \/ p_sub) or
               ((p_int \/ p_sub \/ p_des) /\ ((andar + 2)..andar_maximo)) = {}
            THEN
                direcao := parado ||
                IF manutencao_pendente = TRUE THEN
                    manutencao := TRUE ||
                    manutencao_pendente := FALSE
                END
            END ||
            parada_pendente := FALSE
        END;

    descer(p_int, p_sub, p_des) =
        PRE
            p_int <: 0..andar_maximo & p_sub <: 0..(andar_maximo - 1) & p_des <: 1..andar_maximo &
            direcao = descendo & porta = fechada & limite_peso_atingido = FALSE &
            manutencao = FALSE & andar > 0
        THEN
            andar := andar - 1 || deslocamento := deslocamento + 1 ||
            IF parada_pendente = TRUE or (andar - 1) : (p_int \/ p_des) or
               ((p_int \/ p_sub \/ p_des) /\ (0..(andar - 2))) = {}
            THEN
                direcao := parado ||
                IF manutencao_pendente = TRUE THEN
                    manutencao := TRUE ||
                    manutencao_pendente := FALSE
                END
            END ||
            parada_pendente := FALSE
        END;

    inverter_sentido =
        PRE
            direcao = parado & porta = fechada &
            sentido_atendimento : {subindo, descendo}
        THEN
            IF sentido_atendimento = subindo THEN sentido_atendimento := descendo ELSE sentido_atendimento := subindo END
        END;

    abrir_porta(p_int, p_sub, p_des) =
        PRE
            p_int <: 0..andar_maximo & p_sub <: 0..(andar_maximo - 1) & p_des <: 1..andar_maximo &
            direcao = parado & porta = fechada & manutencao = FALSE
        THEN
            porta := aberta ||
            IF sentido_atendimento = parado & andar : p_sub THEN sentido_atendimento := subindo
            ELSIF sentido_atendimento = parado & andar : p_des THEN sentido_atendimento := descendo END ||
            ultima_visita := ultima_visita <+ {andar |-> deslocamento}
        END;

    fechar_porta =
        PRE porta = aberta THEN
            porta := fechada || segundos_porta_aberta := 0
        END;

    /* caso onde o pedido é no andar atual e a porta está aberta*/
    manter_porta(p_int, p_sub, p_des) =
        PRE
            p_int <: 0..andar_maximo & p_sub <: 0..(andar_maximo - 1) & p_des <: 1..andar_maximo &
            direcao = parado & porta = aberta & manutencao = FALSE
        THEN
            segundos_porta_aberta := 0 ||
            IF sentido_atendimento = parado & andar : p_sub THEN sentido_atendimento := subindo
            ELSIF sentido_atendimento = parado & andar : p_des THEN sentido_atendimento := descendo END
        END;

    entrar_em_reposo(p_int, p_sub, p_des) =
        PRE
            p_int <: 0..andar_maximo & p_sub <: 0..(andar_maximo - 1) & p_des <: 1..andar_maximo &
            direcao = parado & porta = fechada & p_int = {} & p_sub = {} & p_des = {}
        THEN
            sentido_atendimento := parado
        END;

    /* Consulta para observar a parada solicitada pelo HLR-006. */
    pendente <-- consultar_parada_pendente =
        BEGIN pendente := parada_pendente END;

    /* CONSULTAS (HLR-001 / HLR-009) */
    pavimento_exibido, direcao_exibida <-- consultar_estado =
        BEGIN pavimento_exibido := andar || direcao_exibida := direcao END;

    total_deslocamento <-- consultar_deslocamento =
        BEGIN total_deslocamento := deslocamento END;

    peso_atual, alerta_ativo <-- consultar_peso =
        BEGIN peso_atual := peso || alerta_ativo := limite_peso_atingido END;

    folga <-- consultar_folga =
        BEGIN folga := peso_maximo - peso END;

    estado_porta, tempo_aberta <-- consultar_porta =
        BEGIN
            estado_porta := porta ||
            tempo_aberta := segundos_porta_aberta
        END;

    chave_inserida, manutencao_ativa, manutencao_aguardando <-- consultar_manutencao =
        BEGIN
            chave_inserida := chave_manutencao ||
            manutencao_ativa := manutencao ||
            manutencao_aguardando := manutencao_pendente
        END;

    visitados, nunca_visitados, marcas <-- consultar_visitas =
        BEGIN
            visitados := dom(ultima_visita) ||
            nunca_visitados := (0..andar_maximo) - dom(ultima_visita) ||
            marcas := ran(ultima_visita)
        END
END