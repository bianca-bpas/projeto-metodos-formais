
/* painel_pedidos
 * Author: win11
 * Creation date: 04/11/2026
 */

MACHINE elevador

SEES configuracao

INCLUDES
    painel_pedidos,
    cabine_movimento

OPERATIONS

    /* --- INTERAÇÃO DE PAINEL --- */

    pressionar_interno(alvo) =
        PRE alvo : min_andar..max_andar THEN
            pedir_interno(alvo)
        END;

    pressionar_externo_subida(alvo) =
        PRE alvo : min_andar..(max_andar - 1) THEN
            pedir_externo_subida(alvo)
        END;

    pressionar_externo_descida(alvo) =
        PRE alvo : (min_andar + 1)..max_andar THEN
            pedir_externo_descida(alvo)
        END;

    /* --- CANCELAMENTOS COM TRATAMENTO HLR-006 --- */

    elevador_cancelar_interno(alvo) =
        PRE
            alvo : pedidos_internos
        THEN
            /* if card = 1, pisca e não remove */
            cancelamento_interno(alvo)
        END;

    elevador_cancelar_subida(alvo) =
        PRE
            alvo : pedidos_subida
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
            alvo : pedidos_descida
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
            direcao = parado &
            porta = fechada &
            limite_peso_atingido = FALSE &
            andar < andar_maximo &
            (sentido_atendimento = parado or sentido_atendimento = subindo) &
            andar /: (pedidos_internos \/ pedidos_subida \/ pedidos_descida) &
            ((pedidos_internos \/ pedidos_subida \/ pedidos_descida) /\ ((andar + 1)..andar_maximo)) /= {}
        THEN
            iniciar_subida(pedidos_internos \/ pedidos_subida \/ pedidos_descida)
        END;

    elevador_iniciar_descida =
        PRE
            direcao = parado &
            porta = fechada &
            limite_peso_atingido = FALSE &
            andar > 0 &
            (sentido_atendimento = parado or sentido_atendimento = descendo) &
            andar /: (pedidos_internos \/ pedidos_subida \/ pedidos_descida) &
            ((pedidos_internos \/ pedidos_subida \/ pedidos_descida) /\ (0..(andar - 1))) /= {}
        THEN
            iniciar_descida(pedidos_internos \/ pedidos_subida \/ pedidos_descida)
        END;

    elevador_subir =
        PRE
            direcao = subindo &
            porta = fechada &
            limite_peso_atingido = FALSE &
            andar < andar_maximo
        THEN
            subir(pedidos_internos, pedidos_subida, pedidos_descida)
        END;

    elevador_descer =
        PRE
            direcao = descendo &
            porta = fechada &
            limite_peso_atingido = FALSE &
            andar > 0
        THEN
            descer(pedidos_internos, pedidos_subida, pedidos_descida)
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

    /* --- ATENDIMENTO E LIMPEZA DE PEDIDOS --- */

    elevador_abrir_porta =
        PRE
            direcao = parado &
            porta = fechada &
            (
                limite_peso_atingido = TRUE or
                andar : pedidos_internos or
                (sentido_atendimento = subindo & andar : pedidos_subida) or
                (sentido_atendimento = descendo & andar : pedidos_descida) or
                (sentido_atendimento = parado & (andar : pedidos_subida or andar : pedidos_descida))
            )
        THEN
            abrir_porta(pedidos_internos, pedidos_subida, pedidos_descida) ||
            atender_pedidos_andar(andar, sentido_atendimento)
        END;

    elevador_fechar_porta =
        PRE
            porta = aberta
        THEN
            fechar_porta
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
        END
END