MACHINE elevador

SEES configuracao

INCLUDES
    painel_pedidos,
    cabine_movimento

PROMOTES
    liberar_interno, liberar_subida, liberar_descida,
    atualizar_peso, ajustar_peso, consultar_peso, consultar_folga,
    consultar_estado, consultar_deslocamento, consultar_visitas, consultar_porta,
    consultar_manutencao, consultar_parada_pendente, consultar_leds, consultar_piscadas,
    consultar_botoes_pressionados, consultar_botoes_com_tempo,
    consultar_historico_paradas, consultar_extremos_historico,
    sugerir_pedido_qualquer, remover_chave_manutencao

VARIABLES piscando_abrir, piscando_fechar

INVARIANT
    piscando_abrir : 0..4 &
    piscando_fechar : 0..4 &
    (manutencao = TRUE =>
        pedidos_internos = {} & pedidos_subida = {} & pedidos_descida = {})

INITIALISATION
    piscando_abrir := 0 ||
    piscando_fechar := 0

OPERATIONS

    /* AVANÇO GLOBAL DE TEMPO (HLR-005 / HLR-007) */
    passar_tempo =
        BEGIN
            /* Durante a manutencao, os pedidos estao vazios pelo
               invariante do controlador. Resta apenas a animacao. */
            IF manutencao = TRUE THEN
                avancar_piscadas_manutencao ||
                zerar_tempo_porta
            ELSE
                avancar_tempo_botoes ||
                IF direcao /= parado &
                   pedidos_internos = {} &
                   pedidos_subida = segurando_subida_2 &
                   pedidos_descida = segurando_descida_2 &
                   pedidos_subida \/ pedidos_descida /= {}
                THEN
                    avancar_tempo_porta(TRUE)
                ELSE
                    avancar_tempo_porta(FALSE)
                END
            END ||
            /* Maximo com zero equivale aos IFs anteriores, sem
               quatro casos redundantes para o provador. */
            piscando_abrir := max({0, piscando_abrir - 1}) ||
            piscando_fechar := max({0, piscando_fechar - 1})
        END;

    /* GERENCIAMENTO DE CHAVE DE MANUTENÇÃO (HLR-008) */
    inserir_chave =
        PRE chave_manutencao = FALSE THEN
            inserir_chave_manutencao ||
            IF direcao = parado THEN
                cancelar_todos
            END
        END;

    /* INTERACAO COM OS PAINEIS (HLR-003 / HLR-004 / HLR-008) */
    pressionar_interno(alvo) =
        PRE alvo : 0..andar_maximo THEN
            SELECT manutencao = TRUE THEN
                piscar_interno(alvo)
            WHEN manutencao = FALSE THEN
                registrar_interno(alvo)
            END
        END;

    pressionar_externo_subida(alvo) =
        PRE alvo : 0..(andar_maximo - 1) & alvo |-> subindo : painel_externo THEN
            SELECT manutencao = TRUE THEN
                piscar_subida(alvo)
            WHEN manutencao = FALSE THEN
                registrar_externo_subida(alvo)
            END
        END;

    pressionar_externo_descida(alvo) =
        PRE alvo : 1..andar_maximo & alvo |-> descendo : painel_externo THEN
            SELECT manutencao = TRUE THEN
                piscar_descida(alvo)
            WHEN manutencao = FALSE THEN
                registrar_externo_descida(alvo)
            END
        END;

    pressionar_abrir =
        SELECT manutencao = TRUE THEN
            piscando_abrir := 4
        WHEN manutencao = FALSE & direcao = parado & porta = fechada THEN
            abrir_porta(pedidos_internos, pedidos_subida, pedidos_descida) ||
            IF andar : pedidos_internos or
               (andar : pedidos_subida & sentido_atendimento /= descendo) or
               (andar : pedidos_descida & sentido_atendimento /= subindo)
            THEN
                atender_pedidos_andar(andar, sentido_atendimento)
            END
        ELSE
            skip
        END;

    pressionar_fechar =
        SELECT manutencao = TRUE THEN
            piscando_fechar := 4
        WHEN manutencao = FALSE & direcao = parado & porta = aberta THEN
            fechar_porta
        ELSE
            skip
        END;

    /* LOOP DE EXECUCAO EXISTENTE: politica HLR-010 preservada. */
    passo =
        PRE
            manutencao = FALSE &
            (#pp.(pp : pedidos_internos \/ pedidos_subida \/ pedidos_descida) or direcao /= parado or
             porta = aberta or sentido_atendimento /= parado)
        THEN
            IF direcao = subindo THEN
                subir(pedidos_internos, pedidos_subida, pedidos_descida) ||
                IF manutencao_pendente = TRUE THEN
                    cancelar_todos
                END
            ELSIF direcao = descendo THEN
                descer(pedidos_internos, pedidos_subida, pedidos_descida) ||
                IF manutencao_pendente = TRUE THEN
                    cancelar_todos
                END
            ELSIF porta = aberta &
                  (andar : pedidos_internos or
                   (andar : pedidos_subida & sentido_atendimento /= descendo) or
                   (andar : pedidos_descida & sentido_atendimento /= subindo)) THEN
                manter_porta(pedidos_internos, pedidos_subida, pedidos_descida) ||
                atender_pedidos_andar(andar, sentido_atendimento)
            ELSIF porta = aberta THEN
                fechar_porta
            ELSIF porta = aberta THEN
                fechar_porta
            ELSIF pedidos_internos \/ pedidos_subida \/ pedidos_descida = {} THEN
                entrar_em_reposo(pedidos_internos, pedidos_subida, pedidos_descida)
            ELSIF andar : pedidos_internos or
                  (andar : pedidos_subida & sentido_atendimento /= descendo) or
                  (andar : pedidos_descida & sentido_atendimento /= subindo) THEN
                abrir_porta(pedidos_internos, pedidos_subida, pedidos_descida) ||
                atender_pedidos_andar(andar, sentido_atendimento)
            ELSIF limite_peso_atingido = TRUE THEN
                /* Sobrecarga impede apenas movimento, nao abertura/fechamento. */
                skip
            ELSIF (sentido_atendimento = subindo &
                   ((pedidos_internos \/ pedidos_subida \/ pedidos_descida) /\ ((andar+1)..andar_maximo)) = {}) or
                  (sentido_atendimento = descendo &
                   ((pedidos_internos \/ pedidos_subida \/ pedidos_descida) /\ (0..(andar-1))) = {}) THEN
                inverter_sentido
            ELSIF sentido_atendimento = subindo THEN
                iniciar_subida
            ELSIF sentido_atendimento = descendo THEN
                iniciar_descida
            ELSIF andar = andar_maximo THEN
                iniciar_descida
            ELSIF andar = 0 THEN
                iniciar_subida
            ELSIF ((pedidos_internos \/ pedidos_subida \/ pedidos_descida) /\ (0..(andar-1))) = {} THEN
                iniciar_subida
            ELSIF ((pedidos_internos \/ pedidos_subida \/ pedidos_descida) /\ ((andar+1)..andar_maximo)) = {} THEN
                iniciar_descida
            ELSE
                IF min(((pedidos_internos \/ pedidos_subida \/ pedidos_descida) /\ ((andar+1)..andar_maximo)) \/ {andar_maximo}) - andar <=
                   andar - max(((pedidos_internos \/ pedidos_subida \/ pedidos_descida) /\ (0..(andar-1))) \/ {0}) THEN
                    iniciar_subida
                ELSE
                    iniciar_descida
                END
            END
        END;

    /* HLR-005/006: a contagem de 3 segundos e o cancelamento sao
       atomicos em passar_tempo. Quando o ultimo pedido externo expira,
       avancar_tempo_porta(TRUE) arma parada_pendente na cabine. */

    led_abrir, led_fechar <-- consultar_leds_porta =
        BEGIN
            led_abrir := bool(piscando_abrir = 4 or piscando_abrir = 2) ||
            led_fechar := bool(piscando_fechar = 4 or piscando_fechar = 2)
        END;

    /* ESTADO DOS VISORES E DOS BOTOES INSTANTANEOS */
    pavimento_exibido, direcao_exibida,
    aviso_manutencao_interno, aviso_manutencao_externo,
    aviso_sobrecarga_interno, aviso_porta_externo <-- consultar_visores =
        BEGIN
            pavimento_exibido := andar ||
            direcao_exibida := direcao ||
            aviso_manutencao_interno := manutencao ||
            aviso_manutencao_externo := manutencao ||
            aviso_sobrecarga_interno := limite_peso_atingido ||
            aviso_porta_externo := bool(segundos_porta_aberta > 120)
        END;

    pisca_abrir, pisca_fechar <-- consultar_piscadas_porta =
        BEGIN
            pisca_abrir := piscando_abrir ||
            pisca_fechar := piscando_fechar
        END
END