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
    parada_pendente : BOOL &
    peso : NATURAL &
    limite_peso_atingido : BOOL &
    (limite_peso_atingido = TRUE <=> peso > peso_maximo) &
    (porta = aberta => direcao = parado) &
    (andar = andar_maximo => direcao /= subindo) &
    (andar = 0 => direcao /= descendo) &
    (parada_pendente = TRUE => direcao /= parado) &
    segundos_porta_aberta : 0..121 &
    (porta = fechada => segundos_porta_aberta = 0) &
    ultima_visita : (0..andar_maximo) +-> NATURAL &
    chave_manutencao : BOOL &
    manutencao : BOOL &
    manutencao_pendente : BOOL &
    (manutencao = TRUE => chave_manutencao = TRUE) &
    (manutencao_pendente = TRUE => chave_manutencao = TRUE) &
    not (manutencao = TRUE & manutencao_pendente = TRUE)

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
                manutencao := TRUE || manutencao_pendente := FALSE
            ELSE
                manutencao_pendente := TRUE
            END
        END;

    confirmar_parada_manutencao =
        PRE chave_manutencao = TRUE & manutencao_pendente = TRUE & direcao = parado THEN
            manutencao := TRUE || manutencao_pendente := FALSE
        END;

    remover_chave_manutencao =
        PRE chave_manutencao = TRUE & manutencao = TRUE & direcao = parado THEN
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
    avancar_tempo_porta =
        BEGIN
            IF porta = aberta & segundos_porta_aberta < 121 THEN
                segundos_porta_aberta := segundos_porta_aberta + 1
            END
        END;

    /* MOVIMENTAÇÃO E SEGURANÇA (HLR-006) */
    solicitar_parada_pendente =
        PRE direcao /= parado THEN
            parada_pendente := TRUE
        END;

    iniciar_subida(todos_pedidos, pedidos_compativeis) =
        PRE
            todos_pedidos <: 0..andar_maximo &
            pedidos_compativeis <: todos_pedidos &
            direcao = parado & porta = fechada &
            limite_peso_atingido = FALSE & manutencao = FALSE &
            andar < andar_maximo &
            (sentido_atendimento = parado or sentido_atendimento = subindo) &
            andar /: pedidos_compativeis &
            (todos_pedidos /\ ((andar + 1)..andar_maximo)) /= {}
        THEN
            direcao := subindo || sentido_atendimento := subindo
        END;

    iniciar_descida(todos_pedidos, pedidos_compativeis) =
        PRE
            todos_pedidos <: 0..andar_maximo &
            pedidos_compativeis <: todos_pedidos &
            direcao = parado & porta = fechada &
            limite_peso_atingido = FALSE & manutencao = FALSE &
            andar > 0 &
            (sentido_atendimento = parado or sentido_atendimento = descendo) &
            andar /: pedidos_compativeis &
            (todos_pedidos /\ (0..(andar - 1))) /= {}
        THEN
            direcao := descendo || sentido_atendimento := descendo
        END;

    subir(p_int, p_sub, p_des) =
        PRE
            p_int <: 0..andar_maximo & p_sub <: 0..(andar_maximo - 1) & p_des <: 1..andar_maximo &
            direcao = subindo & porta = fechada & limite_peso_atingido = FALSE & andar < andar_maximo
        THEN
            andar := andar + 1 || deslocamento := deslocamento + 1 ||
            IF parada_pendente = TRUE or (andar + 1) : (p_int \/ p_sub) or
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
            direcao = descendo & porta = fechada & limite_peso_atingido = FALSE & andar > 0
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

    inverter_sentido(p_int, p_sub, p_des) =
        PRE
            p_int <: 0..andar_maximo & p_sub <: 0..(andar_maximo - 1) & p_des <: 1..andar_maximo &
            direcao = parado & porta = fechada & andar /: p_int &
            (
                (sentido_atendimento = subindo & andar /: p_sub & ((p_int \/ p_sub \/ p_des) /\ ((andar + 1)..andar_maximo)) = {} & (andar : p_des or ((p_int \/ p_sub \/ p_des) /\ (0..(andar - 1))) /= {})) or
                (sentido_atendimento = descendo & andar /: p_des & ((p_int \/ p_sub \/ p_des) /\ (0..(andar - 1))) = {} & (andar : p_sub or ((p_int \/ p_sub \/ p_des) /\ ((andar + 1)..andar_maximo)) /= {}))
            )
        THEN
            IF sentido_atendimento = subindo THEN sentido_atendimento := descendo ELSE sentido_atendimento := subindo END
        END;

    abrir_porta(p_int, p_sub, p_des) =
        PRE
            p_int <: 0..andar_maximo & p_sub <: 0..(andar_maximo - 1) & p_des <: 1..andar_maximo &
            direcao = parado & porta = fechada
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

    entrar_em_reposo(p_int, p_sub, p_des) =
        PRE
            p_int <: 0..andar_maximo & p_sub <: 0..(andar_maximo - 1) & p_des <: 1..andar_maximo &
            direcao = parado & porta = fechada & p_int = {} & p_sub = {} & p_des = {}
        THEN
            sentido_atendimento := parado
        END;

    /* CONSULTAS (HLR-001 / HLR-009) */
    pavimento_exibido, direcao_exibida <-- consultar_estado =
        BEGIN pavimento_exibido := andar || direcao_exibida := direcao END;

    total_deslocamento <-- consultar_deslocamento =
        BEGIN total_deslocamento := deslocamento END;

    peso_atual, alerta_ativo <-- consultar_peso =
        BEGIN peso_atual := peso || alerta_ativo := limite_peso_atingido END;

    folga <-- consultar_folga =
        BEGIN folga := peso_maximo - peso END;

    visitados, nunca_visitados, marcas <-- consultar_visitas =
        BEGIN
            visitados := dom(ultima_visita) ||
            nunca_visitados := (0..andar_maximo) - dom(ultima_visita) ||
            marcas := ran(ultima_visita)
        END
END