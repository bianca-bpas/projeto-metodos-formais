/* cabine_movimento
 * Author: araujo
 * Creation date: 04/11/2026
 */
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
    limite_peso_atingido

INVARIANT
    andar : 0..andar_maximo &
    direcao : DIRECOES &
    deslocamento : NATURAL &
    porta : PORTAS &
    sentido_atendimento : DIRECOES &
    parada_pendente : BOOL &
    peso : NATURAL &
    limite_peso_atingido : BOOL &
    (limite_peso_atingido = TRUE <=> peso >= peso_maximo) &
    (porta = aberta => direcao = parado) &
    (andar = andar_maximo => direcao /= subindo) &
    (andar = 0 => direcao /= descendo) &
    (parada_pendente = TRUE => direcao /= parado)

INITIALISATION
    andar := 0 ||
    direcao := parado ||
    deslocamento := 0 ||
    porta := fechada ||
    sentido_atendimento := parado ||
    parada_pendente := FALSE ||
    peso := 0 ||
    limite_peso_atingido := FALSE

OPERATIONS

    /* HLR-006: Chamado pela Mestre quando o ultimo pedido em movimento for cancelado */
    solicitar_parada_pendente =
        PRE
            direcao /= parado
        THEN
            parada_pendente := TRUE
        END;

    atualizar_peso(novo_peso) =
        PRE
            novo_peso : NATURAL &
            direcao = parado
        THEN
            peso := novo_peso ||
            IF novo_peso >= peso_maximo THEN
                limite_peso_atingido := TRUE
            ELSE
                limite_peso_atingido := FALSE
            END
        END;

    iniciar_subida(todos_pedidos) =
        PRE
            todos_pedidos <: 0..andar_maximo &
            direcao = parado &
            porta = fechada &
            limite_peso_atingido = FALSE &
            andar < andar_maximo &
            (sentido_atendimento = parado or sentido_atendimento = subindo) &
            andar /: todos_pedidos &
            (todos_pedidos /\ ((andar + 1)..andar_maximo)) /= {}
        THEN
            direcao := subindo ||
            sentido_atendimento := subindo
        END;

    iniciar_descida(todos_pedidos) =
        PRE
            todos_pedidos <: 0..andar_maximo &
            direcao = parado &
            porta = fechada &
            limite_peso_atingido = FALSE &
            andar > 0 &
            (sentido_atendimento = parado or sentido_atendimento = descendo) &
            andar /: todos_pedidos &
            (todos_pedidos /\ (0..(andar - 1))) /= {}
        THEN
            direcao := descendo ||
            sentido_atendimento := descendo
        END;

    subir(p_int, p_sub, p_des) =
        PRE
            p_int <: 0..andar_maximo &
            p_sub <: 0..(andar_maximo - 1) &
            p_des <: 1..andar_maximo &
            direcao = subindo &
            porta = fechada &
            limite_peso_atingido = FALSE &
            andar < andar_maximo
        THEN
            andar := andar + 1 ||
            deslocamento := deslocamento + 1 ||
            IF parada_pendente = TRUE or
               (andar + 1) : (p_int \/ p_sub) or
               ((p_int \/ p_sub \/ p_des) /\ ((andar + 2)..andar_maximo)) = {}
            THEN
                direcao := parado
            END ||
            parada_pendente := FALSE
        END;

    descer(p_int, p_sub, p_des) =
        PRE
            p_int <: 0..andar_maximo &
            p_sub <: 0..(andar_maximo - 1) &
            p_des <: 1..andar_maximo &
            direcao = descendo &
            porta = fechada &
            limite_peso_atingido = FALSE &
            andar > 0
        THEN
            andar := andar - 1 ||
            deslocamento := deslocamento + 1 ||
            IF parada_pendente = TRUE or
               (andar - 1) : (p_int \/ p_des) or
               ((p_int \/ p_sub \/ p_des) /\ (0..(andar - 2))) = {}
            THEN
                direcao := parado
            END ||
            parada_pendente := FALSE
        END;

    inverter_sentido(p_int, p_sub, p_des) =
        PRE
            p_int <: 0..andar_maximo &
            p_sub <: 0..(andar_maximo - 1) &
            p_des <: 1..andar_maximo &
            direcao = parado &
            porta = fechada &
            andar /: p_int &
            (
                (sentido_atendimento = subindo &
                 andar /: p_sub &
                 ((p_int \/ p_sub \/ p_des) /\ ((andar + 1)..andar_maximo)) = {} &
                 (andar : p_des or ((p_int \/ p_sub \/ p_des) /\ (0..(andar - 1))) /= {}))
                or
                (sentido_atendimento = descendo &
                 andar /: p_des &
                 ((p_int \/ p_sub \/ p_des) /\ (0..(andar - 1))) = {} &
                 (andar : p_sub or ((p_int \/ p_sub \/ p_des) /\ ((andar + 1)..andar_maximo)) /= {}))
            )
        THEN
            IF sentido_atendimento = subindo THEN
                sentido_atendimento := descendo
            ELSE
                sentido_atendimento := subindo
            END
        END;

    abrir_porta(p_int, p_sub, p_des) =
        PRE
            p_int <: 0..andar_maximo &
            p_sub <: 0..(andar_maximo - 1) &
            p_des <: 1..andar_maximo &
            direcao = parado &
            porta = fechada &
            (
                limite_peso_atingido = TRUE or
                andar : p_int or
                (sentido_atendimento = subindo & andar : p_sub) or
                (sentido_atendimento = descendo & andar : p_des) or
                (sentido_atendimento = parado & (andar : p_sub or andar : p_des))
            )
        THEN
            porta := aberta ||
            IF sentido_atendimento = parado & andar : p_sub THEN
                sentido_atendimento := subindo
            ELSIF sentido_atendimento = parado & andar : p_des THEN
                sentido_atendimento := descendo
            END
        END;

    fechar_porta =
        PRE porta = aberta
        THEN porta := fechada
        END;

    entrar_em_reposo(p_int, p_sub, p_des) =
        PRE
            p_int <: 0..andar_maximo &
            p_sub <: 0..(andar_maximo - 1) &
            p_des <: 1..andar_maximo &
            direcao = parado &
            porta = fechada &
            p_int = {} & p_sub = {} & p_des = {}
        THEN
            sentido_atendimento := parado
        END;

    pavimento_exibido, direcao_exibida <-- consultar_estado =
        BEGIN
            pavimento_exibido := andar ||
            direcao_exibida := direcao
        END;

    total_deslocamento <-- consultar_deslocamento =
        BEGIN
            total_deslocamento := deslocamento
        END;

    peso_atual, alerta_ativo <-- consultar_peso =
        BEGIN
            peso_atual := peso ||
            alerta_ativo := limite_peso_atingido
        END
END