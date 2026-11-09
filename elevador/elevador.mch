MACHINE elevador

SEES configuracao

INCLUDES
    painel_pedidos,
    cabine_movimento

PROMOTES
    pressionar_interno, pressionar_externo_subida, pressionar_externo_descida,
    liberar_interno, liberar_subida, liberar_descida,
    atualizar_peso, ajustar_peso, consultar_peso, consultar_folga,
    consultar_estado, consultar_deslocamento, consultar_visitas,
    consultar_botoes_pressionados, consultar_botoes_com_tempo,
    consultar_historico_paradas, consultar_extremos_historico,
    sugerir_pedido_qualquer, remover_chave_manutencao

VARIABLES piscando_abrir, piscando_fechar

INVARIANT
    piscando_abrir : NATURAL &
    piscando_fechar : NATURAL

INITIALISATION
    piscando_abrir := 0 ||
    piscando_fechar := 0

OPERATIONS

    /* AVANÇO GLOBAL DE TEMPO (HLR-005 / HLR-007) */
    passar_tempo =
        BEGIN
            avancar_tempo_botoes ||
            avancar_tempo_porta
        END;

    /* GERENCIAMENTO DE CHAVE DE MANUTENÇÃO (HLR-008) */
    inserir_chave =
        BEGIN
            inserir_chave_manutencao ||
            IF direcao = parado THEN
                cancelar_todos
            END
        END;

    /* LOOP DE EXECUÇÃO PRINCIPAL (HLR-010: Atendimento e limpeza ao abrir porta) */
    passo =
        PRE
            manutencao = FALSE & limite_peso_atingido = FALSE &
            (pedidos_internos \/ pedidos_subida \/ pedidos_descida /= {} or direcao /= parado or
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
            ELSIF porta = aberta THEN
                fechar_porta
            ELSIF pedidos_internos \/ pedidos_subida \/ pedidos_descida = {} THEN
                entrar_em_reposo(pedidos_internos, pedidos_subida, pedidos_descida)
            ELSIF andar : pedidos_internos or
                  (andar : pedidos_subida & sentido_atendimento /= descendo) or
                  (andar : pedidos_descida & sentido_atendimento /= subindo) THEN
                abrir_porta(pedidos_internos, pedidos_subida, pedidos_descida) ||
                atender_pedidos_andar(andar, sentido_atendimento)
            ELSIF (sentido_atendimento = subindo &
                   ((pedidos_internos \/ pedidos_subida \/ pedidos_descida) /\ ((andar+1)..andar_maximo)) = {}) or
                  (sentido_atendimento = descendo &
                   ((pedidos_internos \/ pedidos_subida \/ pedidos_descida) /\ (0..(andar-1))) = {}) THEN
                inverter_sentido(pedidos_internos, pedidos_subida, pedidos_descida)
            ELSIF sentido_atendimento = subindo THEN
                iniciar_subida(pedidos_internos \/ pedidos_subida \/ pedidos_descida, pedidos_internos \/ pedidos_subida)
            ELSIF sentido_atendimento = descendo THEN
                iniciar_descida(pedidos_internos \/ pedidos_subida \/ pedidos_descida, pedidos_internos \/ pedidos_descida)
            ELSIF ((pedidos_internos \/ pedidos_subida \/ pedidos_descida) /\ (0..(andar-1))) = {} THEN
                iniciar_subida(pedidos_internos \/ pedidos_subida \/ pedidos_descida, pedidos_internos \/ pedidos_subida)
            ELSIF ((pedidos_internos \/ pedidos_subida \/ pedidos_descida) /\ ((andar+1)..andar_maximo)) = {} THEN
                iniciar_descida(pedidos_internos \/ pedidos_subida \/ pedidos_descida, pedidos_internos \/ pedidos_descida)
            ELSE
                CHOICE
                    iniciar_subida(pedidos_internos \/ pedidos_subida \/ pedidos_descida, pedidos_internos \/ pedidos_subida)
                OR
                    iniciar_descida(pedidos_internos \/ pedidos_subida \/ pedidos_descida, pedidos_internos \/ pedidos_subida)
                END
            END
        END;

    /* CANCELAMENTOS DE EMERGÊNCIA (HLR-005 / HLR-006) */
    elevador_cancelar_interno(alvo) =
        PRE alvo : dom((tempo_interno) |> {3}) THEN
            cancelamento_interno(alvo)
        END;

    elevador_cancelar_subida(alvo) =
        PRE alvo : dom((tempo_subida) |> {3}) THEN
            cancelamento_externo_subida(alvo) ||
            IF direcao /= parado & pedidos_subida = {alvo} & pedidos_internos = {} & pedidos_descida = {} THEN
                solicitar_parada_pendente
            END
        END;

    elevador_cancelar_descida(alvo) =
        PRE alvo : dom((tempo_descida) |> {3}) THEN
            cancelamento_externo_descida(alvo) ||
            IF direcao /= parado & pedidos_descida = {alvo} & pedidos_internos = {} & pedidos_subida = {} THEN
                solicitar_parada_pendente
            END
        END;

    elevador_parar_piscar =
        PRE piscando_interno1 /= {} or piscando_interno2 /= {} or
            piscando_subida1 /= {}  or piscando_subida2 /= {}  or
            piscando_descida1 /= {} or piscando_descida2 /= {}
        THEN
            parar_piscar
        END
END