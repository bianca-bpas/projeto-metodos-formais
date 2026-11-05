/* Escalonamento automatico: executar passo repetidamente enquanto habilitado.
   Interacoes manuais permanecem na maquina elevador. */
MACHINE controlador
SEES configuracao
INCLUDES elevador
PROMOTES pressionar_interno, pressionar_externo_subida, pressionar_externo_descida,
         liberar_interno, liberar_subida, liberar_descida, passar_segundo,
         atualizar_peso, consultar_peso, consultar_estado, consultar_deslocamento,
         consultar_avisos, consultar_estado_manutencao,
         elevador_cancelar_interno, elevador_cancelar_subida, elevador_cancelar_descida,
         elevador_parar_piscar, avancar_piscadas_porta,
         inserir_chave, remover_chave, elevador_abrir_porta,
         elevador_fechar_porta, elevador_iniciar_subida, elevador_subir,
         elevador_iniciar_descida, elevador_descer, elevador_entrar_em_reposo
OPERATIONS
    passo =
        PRE
            manutencao = FALSE & limite_peso_atingido = FALSE &
            (pedidos_internos \/ pedidos_subida \/ pedidos_descida /= {} or direcao /= parado or
             porta = aberta or sentido_atendimento /= parado)
        THEN
            IF direcao = subindo THEN elevador_subir
            ELSIF direcao = descendo THEN elevador_descer
            ELSIF porta = aberta THEN elevador_fechar_porta
            ELSIF pedidos_internos \/ pedidos_subida \/ pedidos_descida = {}
            THEN elevador_entrar_em_reposo
            ELSIF andar : pedidos_internos or
                  (andar : pedidos_subida & sentido_atendimento /= descendo) or
                  (andar : pedidos_descida & sentido_atendimento /= subindo)
            THEN elevador_abrir_porta
            ELSIF (sentido_atendimento = subindo &
                   ((pedidos_internos \/ pedidos_subida \/ pedidos_descida) /\ ((andar+1)..andar_maximo)) = {}) or
                  (sentido_atendimento = descendo &
                   ((pedidos_internos \/ pedidos_subida \/ pedidos_descida) /\ (0..(andar-1))) = {})
            THEN elevador_inverter_sentido
            ELSIF sentido_atendimento = subindo THEN elevador_iniciar_subida
            ELSIF sentido_atendimento = descendo THEN elevador_iniciar_descida
            ELSIF ((pedidos_internos \/ pedidos_subida \/ pedidos_descida) /\ (0..(andar-1))) = {}
            THEN elevador_iniciar_subida
            ELSIF ((pedidos_internos \/ pedidos_subida \/ pedidos_descida) /\ ((andar+1)..andar_maximo)) = {}
            THEN elevador_iniciar_descida
            ELSIF max(pedidos_internos \/ pedidos_subida \/ pedidos_descida) - andar <=
                  andar - min(pedidos_internos \/ pedidos_subida \/ pedidos_descida)
            THEN elevador_iniciar_subida
            ELSE elevador_iniciar_descida
            END
        END
END