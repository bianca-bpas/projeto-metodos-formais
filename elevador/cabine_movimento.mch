/* cabine_movimento
 * Author: araujo
 * Creation date: 04/11/2026
 *
 * HLR-001: Exibir pavimento atual e direcao do movimento.
 * HLR-006: Apos cancelar o ultimo pedido durante o movimento,
 *          parar no proximo pavimento no mesmo sentido.
 * HLR-010: Atender pedidos por sentido, evitando deslocamentos
 *          desnecessarios. A justica e a otimalidade global
 *          ainda dependem da politica de escalonamento.
 *
 * Abstracao: cada operacao subir/descer representa o avanco
 * de um pavimento inteiro. Abrir a porta conclui o atendimento.
 * Peso >= peso_maximo ativa uma flag e impede movimentacao.
 */
MACHINE cabine_movimento

SEES configuracao

VARIABLES
    andar,
    direcao,
    deslocamento,
    porta,
    pedidos_cabine,
    pedidos_subida,
    pedidos_descida,
    sentido_atendimento,
    parada_pendente,
    peso,
    limite_peso_atingido

INVARIANT
    andar : 0..andar_maximo &
    direcao : DIRECOES &
    deslocamento : NATURAL &
    porta : PORTAS &
    pedidos_cabine <: 0..andar_maximo &
    pedidos_subida <: 0..(andar_maximo - 1) &
    pedidos_descida <: 1..andar_maximo &
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
    pedidos_cabine := {} ||
    pedidos_subida := {} ||
    pedidos_descida := {} ||
    sentido_atendimento := parado ||
    parada_pendente := FALSE ||
    peso := 0 ||
    limite_peso_atingido := FALSE

OPERATIONS

    /* REGISTRO DE PEDIDOS */

    solicitar_cabine(destino) =
        PRE destino : 0..andar_maximo
        THEN
            pedidos_cabine := pedidos_cabine \/ {destino}
        END;

    solicitar_subida(pavimento) =
        PRE pavimento : 0..(andar_maximo - 1)
        THEN
            pedidos_subida := pedidos_subida \/ {pavimento}
        END;

    solicitar_descida(pavimento) =
        PRE pavimento : 1..andar_maximo
        THEN
            pedidos_descida := pedidos_descida \/ {pavimento}
        END;

    /* CANCELAMENTO: A ULTIMA SOLICITACAO EM MOVIMENTO
       OBRIGA A PARADA NO PROXIMO PAVIMENTO. */

    cancelar_pedido_cabine(destino) =
        PRE
            destino : 0..andar_maximo &
            destino : pedidos_cabine
        THEN
            pedidos_cabine := pedidos_cabine - {destino} ||
            IF direcao /= parado &
               pedidos_cabine = {destino} &
               pedidos_subida = {} &
               pedidos_descida = {}
            THEN
                parada_pendente := TRUE
            END
        END;

    cancelar_pedido_subida(pavimento) =
        PRE
            pavimento : 0..(andar_maximo - 1) &
            pavimento : pedidos_subida
        THEN
            pedidos_subida := pedidos_subida - {pavimento} ||
            IF direcao /= parado &
               pedidos_subida = {pavimento} &
               pedidos_cabine = {} &
               pedidos_descida = {}
            THEN
                parada_pendente := TRUE
            END
        END;

    cancelar_pedido_descida(pavimento) =
        PRE
            pavimento : 1..andar_maximo &
            pavimento : pedidos_descida
        THEN
            pedidos_descida := pedidos_descida - {pavimento} ||
            IF direcao /= parado &
               pedidos_descida = {pavimento} &
               pedidos_cabine = {} &
               pedidos_subida = {}
            THEN
                parada_pendente := TRUE
            END
        END;

    /* CONTROLE DE CARGA: PESO E FLAG DE LIMITE ATINGIDO.
       A MEDICAO E ATUALIZADA APENAS QUANDO A CABINE ESTA PARADA;
       ISSO MODELA A ENTRADA E SAIDA DE PASSAGEIROS EM PAVIMENTOS. */

    atualizar_peso(novo_peso) =
        PRE
            novo_peso : NATURAL &
            direcao = parado
        THEN
            peso := novo_peso ||
            IF novo_peso >= peso_maximo
            THEN
                limite_peso_atingido := TRUE
            ELSE
                limite_peso_atingido := FALSE
            END
        END;

    /* INICIO DO MOVIMENTO: RESPEITA O SENTIDO EM CURSO.
       QUANDO O SENTIDO E PARADO, A ESCOLHA INICIAL E LIVRE. */

    iniciar_subida =
        PRE
            direcao = parado &
            porta = fechada &
            limite_peso_atingido = FALSE &
            andar < andar_maximo &
            (sentido_atendimento = parado or
             sentido_atendimento = subindo) &
            andar /: pedidos_cabine &
            andar /: pedidos_subida &
            (sentido_atendimento = parado =>
                andar /: pedidos_descida) &
            ((pedidos_cabine \/ pedidos_subida \/ pedidos_descida) /\
             ((andar + 1)..andar_maximo)) /= {}
        THEN
            direcao := subindo ||
            sentido_atendimento := subindo
        END;

    iniciar_descida =
        PRE
            direcao = parado &
            porta = fechada &
            limite_peso_atingido = FALSE &
            andar > 0 &
            (sentido_atendimento = parado or
             sentido_atendimento = descendo) &
            andar /: pedidos_cabine &
            andar /: pedidos_descida &
            (sentido_atendimento = parado =>
                andar /: pedidos_subida) &
            ((pedidos_cabine \/ pedidos_subida \/ pedidos_descida) /\
             (0..(andar - 1))) /= {}
        THEN
            direcao := descendo ||
            sentido_atendimento := descendo
        END;

    /* CADA MOVIMENTO CHEGA A UM NOVO PAVIMENTO.
       PARA SE HOUVER ATENDIMENTO COMPATIVEL, SE FOR O
       ULTIMO PAVIMENTO RELEVANTE OU SE HOUVER CANCELAMENTO. */

    subir =
        PRE
            direcao = subindo &
            porta = fechada &
            limite_peso_atingido = FALSE &
            andar < andar_maximo
        THEN
            andar := andar + 1 ||
            deslocamento := deslocamento + 1 ||
            IF
                parada_pendente = TRUE or
                (andar + 1) : (pedidos_cabine \/ pedidos_subida) or
                ((pedidos_cabine \/ pedidos_subida \/ pedidos_descida) /\
                 ((andar + 2)..andar_maximo)) = {}
            THEN
                direcao := parado
            END ||
            parada_pendente := FALSE
        END;

    descer =
        PRE
            direcao = descendo &
            porta = fechada &
            limite_peso_atingido = FALSE &
            andar > 0
        THEN
            andar := andar - 1 ||
            deslocamento := deslocamento + 1 ||
            IF
                parada_pendente = TRUE or
                (andar - 1) : (pedidos_cabine \/ pedidos_descida) or
                ((pedidos_cabine \/ pedidos_subida \/ pedidos_descida) /\
                 (0..(andar - 2))) = {}
            THEN
                direcao := parado
            END ||
            parada_pendente := FALSE
        END;

    /* INVERSAO SOMENTE QUANDO NAO RESTA PEDIDO ADIANTE
       NA DIRECAO ATUAL. PEDIDOS NO PAVIMENTO ATUAL DEVEM
       SER ATENDIDOS ANTES DE INVERTER. */

    inverter_sentido =
        PRE
            direcao = parado &
            porta = fechada &
            andar /: pedidos_cabine &
            (
                (sentido_atendimento = subindo &
                 andar /: pedidos_subida &
                 ((pedidos_cabine \/ pedidos_subida \/ pedidos_descida) /\
                  ((andar + 1)..andar_maximo)) = {} &
                 (andar : pedidos_descida or
                  ((pedidos_cabine \/ pedidos_subida \/ pedidos_descida) /\
                   (0..(andar - 1))) /= {}))
                or
                (sentido_atendimento = descendo &
                 andar /: pedidos_descida &
                 ((pedidos_cabine \/ pedidos_subida \/ pedidos_descida) /\
                  (0..(andar - 1))) = {} &
                 (andar : pedidos_subida or
                  ((pedidos_cabine \/ pedidos_subida \/ pedidos_descida) /\
                   ((andar + 1)..andar_maximo)) /= {}))
            )
        THEN
            IF sentido_atendimento = subindo
            THEN
                sentido_atendimento := descendo
            ELSE
                sentido_atendimento := subindo
            END
        END;

    /* ABRIR A PORTA E O EVENTO DE ATENDIMENTO.
       O ALERTA DE CARGA TAMBEM PERMITE ABRIR PARA DESEMBARQUE.
       PEDIDOS INTERNOS SAO ATENDIDOS EM AMBOS OS SENTIDOS.
       PEDIDOS EXTERNOS SAO ATENDIDOS NO SENTIDO CORRETO.
       SEM SENTIDO DEFINIDO, PRIORIZA-SE A CHAMADA DE SUBIDA. */

    abrir_porta =
        PRE
            direcao = parado &
            porta = fechada &
            (
                limite_peso_atingido = TRUE or
                andar : pedidos_cabine or
                (sentido_atendimento = subindo &
                 andar : pedidos_subida) or
                (sentido_atendimento = descendo &
                 andar : pedidos_descida) or
                (sentido_atendimento = parado &
                 (andar : pedidos_subida or
                  andar : pedidos_descida))
            )
        THEN
            porta := aberta ||
            pedidos_cabine := pedidos_cabine - {andar} ||
            IF
                sentido_atendimento = subindo or
                (sentido_atendimento = parado &
                 andar : pedidos_subida)
            THEN
                pedidos_subida := pedidos_subida - {andar}
            END ||
            IF
                sentido_atendimento = descendo or
                (sentido_atendimento = parado &
                 andar /: pedidos_subida &
                 andar : pedidos_descida)
            THEN
                pedidos_descida := pedidos_descida - {andar}
            END ||
            IF sentido_atendimento = parado &
               andar : pedidos_subida
            THEN
                sentido_atendimento := subindo
            ELSIF sentido_atendimento = parado &
                  andar : pedidos_descida
            THEN
                sentido_atendimento := descendo
            END
        END;

    fechar_porta =
        PRE porta = aberta
        THEN porta := fechada
        END;

    /* SEM PEDIDOS, O SENTIDO PLANEJADO TAMBEM FICA PARADO. */

    entrar_em_reposo =
        PRE
            direcao = parado &
            porta = fechada &
            pedidos_cabine = {} &
            pedidos_subida = {} &
            pedidos_descida = {}
        THEN
            sentido_atendimento := parado
        END;

    /* HLR-001: SAIDAS PARA O VISOR. */

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