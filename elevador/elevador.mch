MACHINE elevador

SEES configuracao

INCLUDES
    painel_pedidos,
    cabine_movimento

PROMOTES
    liberar_interno, liberar_subida, liberar_descida,
    atualizar_peso, ajustar_peso, consultar_peso, consultar_folga,
    consultar_estado, consultar_deslocamento, consultar_visitas, consultar_porta,
    consultar_manutencao, consultar_leds, consultar_piscadas,
    consultar_botoes_pressionados, consultar_botoes_com_tempo,
    consultar_historico_paradas, consultar_extremos_historico,
    sugerir_pedido_qualquer, remover_chave_manutencao

VARIABLES piscando_abrir, piscando_fechar

INVARIANT
    piscando_abrir : 0..2 &
    piscando_fechar : 0..2 &
    (manutencao = TRUE =>
        pedidos_internos = {} & pedidos_subida = {} & pedidos_descida = {})

INITIALISATION
    piscando_abrir := 0 ||
    piscando_fechar := 0

OPERATIONS

    /* AVANÇO GLOBAL DE TEMPO (HLR-005 / HLR-007) */
    passar_tempo =
        BEGIN
            avancar_tempo_botoes ||
            avancar_tempo_porta ||
            IF piscando_abrir > 0 THEN piscando_abrir := piscando_abrir - 1 END ||
            IF piscando_fechar > 0 THEN piscando_fechar := piscando_fechar - 1 END
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
            piscando_abrir := 2
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
            piscando_fechar := 2
        WHEN manutencao = FALSE & direcao = parado & porta = aberta THEN
            fechar_porta
        ELSE
            skip
        END;

    /* LOOP DE EXECUÇÃO PRINCIPAL (HLR-010: Atendimento e limpeza ao abrir porta) */
    passo =
        PRE
            manutencao = FALSE & limite_peso_atingido = FALSE &
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
                LET todos, acima, abaixo BE
                    todos = pedidos_internos \/ pedidos_subida \/ pedidos_descida &
                    acima = {pp | pp : pedidos_internos \/ pedidos_subida \/ pedidos_descida & pp > andar} &
                    abaixo = {pp | pp : pedidos_internos \/ pedidos_subida \/ pedidos_descida & pp < andar}
                IN
                    IF min(acima \/ {andar_maximo}) - andar <= andar - max(abaixo \/ {0}) THEN
                        iniciar_subida(todos, pedidos_internos \/ pedidos_subida)
                    ELSE
                        iniciar_descida(todos, pedidos_internos \/ pedidos_descida)
                    END
                END
            END
        END;

    /* CANCELAMENTOS DE EMERGÊNCIA (HLR-005 / HLR-006) */
    elevador_cancelar_interno(alvo) =
        PRE alvo : pedidos_internos & tempo_interno(alvo) = 3 THEN
            cancelamento_interno(alvo)
        END;

    elevador_cancelar_subida(alvo) =
        PRE alvo : pedidos_subida & tempo_subida(alvo) = 3 THEN
            cancelamento_externo_subida(alvo) ||
            IF direcao /= parado & pedidos_subida = {alvo} & pedidos_internos = {} & pedidos_descida = {} THEN
                solicitar_parada_pendente
            END
        END;

    elevador_cancelar_descida(alvo) =
        PRE alvo : pedidos_descida & tempo_descida(alvo) = 3 THEN
            cancelamento_externo_descida(alvo) ||
            IF direcao /= parado & pedidos_descida = {alvo} & pedidos_internos = {} & pedidos_subida = {} THEN
                solicitar_parada_pendente
            END
        END;

    elevador_parar_piscar =
        PRE piscando_interno1 /= {} or piscando_interno2 /= {} or
            piscando_subida1 /= {}  or piscando_subida2 /= {}  or
            piscando_descida1 /= {} or piscando_descida2 /= {} or
            piscando_abrir > 0 or piscando_fechar > 0
        THEN
            IF piscando_interno1 /= {} or piscando_interno2 /= {} or
               piscando_subida1 /= {} or piscando_subida2 /= {} or
               piscando_descida1 /= {} or piscando_descida2 /= {}
            THEN
                parar_piscar
            END ||
            IF piscando_abrir > 0 THEN piscando_abrir := piscando_abrir - 1 END ||
            IF piscando_fechar > 0 THEN piscando_fechar := piscando_fechar - 1 END
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
