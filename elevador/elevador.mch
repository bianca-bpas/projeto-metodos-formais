MACHINE elevador

SEES configuracao

INCLUDES
    painel_pedidos,
    cabine_movimento

PROMOTES
    liberar_interno, liberar_subida, liberar_descida,
    atualizar_peso, ajustar_peso, consultar_peso, consultar_folga,
    consultar_estado, consultar_deslocamento, consultar_visitas,
    consultar_alerta_porta, consultar_manutencao,
    consultar_botoes_pressionados, consultar_botoes_com_tempo,
    consultar_botoes_prontos_cancelamento, consultar_em_contagem,
    consultar_tempos_ate,
    consultar_historico_paradas, consultar_extremos_historico,
    consultar_rota, consultar_rota_ida_volta,
    sugerir_pedido_qualquer, remover_chave_manutencao

OPERATIONS

    /* AVANÇO GLOBAL DE TEMPO (HLR-005 / HLR-007) */
    passar_tempo =
        BEGIN
            avancar_tempo_botoes ||
            avancar_tempo_porta
        END;

    /* BOTÕES DOS PAINÉIS (HLR-002 / HLR-003 / HLR-004 / HLR-008)
       Durante a manutenção os painéis ficam inoperantes: o LED pisca e
       o pedido não é registrado. */
    apertar_interno(alvo) =
        PRE alvo : 0..andar_maximo THEN
            IF manutencao = TRUE THEN
                recusar_interno(alvo)
            ELSE
                pressionar_interno(alvo)
            END
        END;

    apertar_subida(alvo) =
        PRE alvo : 0..(andar_maximo - 1) THEN
            IF manutencao = TRUE THEN
                piscar_subida(alvo)
            ELSE
                pressionar_externo_subida(alvo)
            END
        END;

    apertar_descida(alvo) =
        PRE alvo : 1..andar_maximo THEN
            IF manutencao = TRUE THEN
                piscar_descida(alvo)
            ELSE
                pressionar_externo_descida(alvo)
            END
        END;

    /* Botões "abrir" e "fechar" imediatamente (HLR-003): só com a cabine parada */
    apertar_abrir_porta =
        PRE direcao = parado & porta = fechada & manutencao = FALSE THEN
            abrir_porta_imediato
        END;

    apertar_fechar_porta =
        PRE porta = aberta & manutencao = FALSE THEN
            fechar_porta
        END;

    /* GERENCIAMENTO DE CHAVE DE MANUTENÇÃO (HLR-008) */
    inserir_chave =
        PRE chave_manutencao = FALSE THEN
            inserir_chave_manutencao ||
            IF direcao = parado THEN
                cancelar_todos
            END
        END;

    /* Cabine parou com a chave pendente: entra em manutenção e cancela os pedidos */
    elevador_confirmar_manutencao =
        SELECT manutencao_pendente = TRUE & direcao = parado THEN
            confirmar_parada_manutencao ||
            cancelar_todos
        END;

    /* LOOP DE EXECUÇÃO PRINCIPAL (HLR-010: Atendimento e limpeza ao abrir porta) */
    passo =
        PRE
            manutencao = FALSE & limite_peso_atingido = FALSE &
            (manutencao_pendente = FALSE or direcao /= parado) &
            (pedidos_internos \/ pedidos_subida \/ pedidos_descida /= {} or direcao /= parado or
             porta = aberta or sentido_atendimento /= parado)
        THEN
            IF direcao = subindo THEN
                subir(pedidos_internos, pedidos_subida, pedidos_descida)
            ELSIF direcao = descendo THEN
                descer(pedidos_internos, pedidos_subida, pedidos_descida)
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
                iniciar_subida
            ELSIF sentido_atendimento = descendo THEN
                iniciar_descida
            ELSIF ((pedidos_internos \/ pedidos_subida \/ pedidos_descida) /\ (0..(andar-1))) = {} THEN
                iniciar_subida
            ELSIF ((pedidos_internos \/ pedidos_subida \/ pedidos_descida) /\ ((andar+1)..andar_maximo)) = {} THEN
                iniciar_descida
            ELSE
                CHOICE
                    iniciar_subida
                OR
                    iniciar_descida
                END
            END
        END;

    /* CANCELAMENTOS DE EMERGÊNCIA (HLR-005 / HLR-006) */
    elevador_cancelar_interno(alvo) =
        PRE alvo : dom(tempo_interno) & tempo_interno(alvo) = 3 THEN
            cancelamento_interno(alvo)
        END;

    elevador_cancelar_subida(alvo) =
        PRE alvo : dom(tempo_subida) & tempo_subida(alvo) = 3 THEN
            cancelamento_externo_subida(alvo) ||
            IF direcao /= parado & pedidos_subida = {alvo} & pedidos_internos = {} & pedidos_descida = {} THEN
                solicitar_parada_pendente
            END
        END;

    elevador_cancelar_descida(alvo) =
        PRE alvo : dom(tempo_descida) & tempo_descida(alvo) = 3 THEN
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
        END;

    /* CONSULTAS DO ELEVADOR */

    /* Botões existentes em cada painel de pavimento (HLR-002): primeiro andar
       só sobe, último só desce */
    direcoes_pavimento <-- consultar_painel_pavimento(pav) =
        PRE pav : 0..andar_maximo THEN
            direcoes_pavimento := painel_externo[{pav}]
        END;

    /* Compreensão de conjuntos + LET */
    acima <-- consultar_pedidos_acima =
        LET todos BE todos = pedidos_internos \/ pedidos_subida \/ pedidos_descida IN
            acima := {pp | pp : todos & pp > andar}
        END;

    abaixo <-- consultar_pedidos_abaixo =
        LET todos BE todos = pedidos_internos \/ pedidos_subida \/ pedidos_descida IN
            abaixo := {pp | pp : todos & pp < andar}
        END;

    /* Quantificadores existencial e universal */
    ha_acima, ha_abaixo, todos_validos <-- consultar_situacao_pedidos =
        BEGIN
            ha_acima := bool(#pp.(pp : (pedidos_internos \/ pedidos_subida \/ pedidos_descida) & pp > andar)) ||
            ha_abaixo := bool(#pp.(pp : (pedidos_internos \/ pedidos_subida \/ pedidos_descida) & pp < andar)) ||
            todos_validos := bool(!pp.(pp : (pedidos_internos \/ pedidos_subida \/ pedidos_descida) => pp : 0..andar_maximo))
        END
END