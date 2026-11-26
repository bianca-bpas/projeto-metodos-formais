MACHINE animacao
/* Adaptador de entrega do VisB. Todas as decisoes pertencem a elevador. */
DEFINITIONS
    VISB_JSON_FILE == "elevador_visb.json";
    MAX_OPERATIONS_entregar == 1;
    SET_PREF_MAX_INITIALISATIONS == 5
SEES configuracao
INCLUDES elevador
VARIABLES ultimo_evento
INVARIANT ultimo_evento : NATURAL
INITIALISATION ultimo_evento := 0
OPERATIONS
    entregar(evento, comando, alvo) =
        PRE evento : NATURAL & comando : 0..14 & alvo : INTEGER THEN
            IF evento > ultimo_evento THEN
                ultimo_evento := evento ||
                CASE comando OF
                    EITHER 0 THEN
                        IF porta_retida = TRUE THEN
                            passar_tempo; passar_tempo; passar_tempo; passar_tempo; passar_tempo;
                            passar_tempo; passar_tempo; passar_tempo; passar_tempo; passar_tempo
                        ELSE passar_tempo END
                    OR 1 THEN
                        IF manutencao = FALSE & ((# pp.(pp : pedidos_internos \/ pedidos_subida \/ pedidos_descida)) or
                           direcao /= parado or porta = aberta or sentido_atendimento /= parado)
                        THEN passo END
                    OR 2 THEN IF alvo : 0..andar_maximo THEN pressionar_interno(alvo) END
                    OR 3 THEN IF alvo : 0..andar_maximo THEN liberar_interno(alvo) END
                    OR 4 THEN IF alvo : 0..(andar_maximo-1) THEN pressionar_externo_subida(alvo) END
                    OR 5 THEN IF alvo : 0..(andar_maximo-1) THEN liberar_subida(alvo) END
                    OR 6 THEN IF alvo : 1..andar_maximo THEN pressionar_externo_descida(alvo) END
                    OR 7 THEN IF alvo : 1..andar_maximo THEN liberar_descida(alvo) END
                    OR 8 THEN pressionar_abrir
                    OR 9 THEN pressionar_fechar
                    OR 10 THEN IF chave_manutencao = FALSE THEN inserir_chave END
                    OR 11 THEN IF chave_manutencao = TRUE &
                        ((manutencao = TRUE & direcao = parado) or manutencao_pendente = TRUE)
                        THEN remover_chave_manutencao END
                    OR 12 THEN IF direcao = parado & peso + alvo : NATURAL THEN ajustar_peso(alvo) END
                    OR 13 THEN segurar_porta
                    OR 14 THEN liberar_porta
                END END
            END
        END
END
