Normalised(
THEORY MagicNumberX IS
  MagicNumber(Machine(elevador))==(3.5)
END
&
THEORY UpperLevelX IS
  First_Level(Machine(elevador))==(Machine(elevador));
  Level(Machine(elevador))==(0)
END
&
THEORY LoadedStructureX IS
  Machine(elevador)
END
&
THEORY ListSeesX IS
  List_Sees(Machine(elevador))==(configuracao)
END
&
THEORY ListUsesX IS
  List_Uses(Machine(elevador))==(?)
END
&
THEORY ListIncludesX IS
  Inherited_List_Includes(Machine(elevador))==(cabine_movimento,painel_pedidos);
  List_Includes(Machine(elevador))==(painel_pedidos,cabine_movimento)
END
&
THEORY ListPromotesX IS
  List_Promotes(Machine(elevador))==(segurar_porta,liberar_porta,liberar_interno,liberar_subida,liberar_descida,atualizar_peso,ajustar_peso,consultar_peso,consultar_folga,consultar_estado,consultar_deslocamento,consultar_visitas,consultar_porta,consultar_manutencao,consultar_parada_pendente,consultar_leds,consultar_piscadas,consultar_botoes_pressionados,consultar_botoes_com_tempo,consultar_historico_paradas,consultar_extremos_historico,sugerir_pedido_qualquer,remover_chave_manutencao)
END
&
THEORY ListExtendsX IS
  List_Extends(Machine(elevador))==(?)
END
&
THEORY ListVariablesX IS
  External_Context_List_Variables(Machine(elevador))==(?);
  Context_List_Variables(Machine(elevador))==(?);
  Abstract_List_Variables(Machine(elevador))==(?);
  Local_List_Variables(Machine(elevador))==(piscando_fechar,piscando_abrir);
  List_Variables(Machine(elevador))==(piscando_fechar,piscando_abrir,historico_paradas,segurando_descida_2,segurando_descida_1,segurando_descida,segurando_subida_2,segurando_subida_1,segurando_subida,interno_recusado,segurando_interno_2,segurando_interno_1,segurando_interno,piscando_descida4,piscando_descida3,piscando_descida2,piscando_subida4,piscando_subida3,piscando_subida2,piscando_interno4,piscando_interno3,piscando_interno2,piscando_descida1,piscando_subida1,piscando_interno1,pedidos_descida,pedidos_subida,pedidos_internos,manutencao_pendente,manutencao,chave_manutencao,ultima_visita,segundos_porta_aberta,limite_peso_atingido,peso,parada_por_cancelamento,parada_pendente,sentido_atendimento,porta_retida,porta,deslocamento,direcao,andar);
  External_List_Variables(Machine(elevador))==(piscando_fechar,piscando_abrir,historico_paradas,segurando_descida_2,segurando_descida_1,segurando_descida,segurando_subida_2,segurando_subida_1,segurando_subida,interno_recusado,segurando_interno_2,segurando_interno_1,segurando_interno,piscando_descida4,piscando_descida3,piscando_descida2,piscando_subida4,piscando_subida3,piscando_subida2,piscando_interno4,piscando_interno3,piscando_interno2,piscando_descida1,piscando_subida1,piscando_interno1,pedidos_descida,pedidos_subida,pedidos_internos,manutencao_pendente,manutencao,chave_manutencao,ultima_visita,segundos_porta_aberta,limite_peso_atingido,peso,parada_por_cancelamento,parada_pendente,sentido_atendimento,porta_retida,porta,deslocamento,direcao,andar)
END
&
THEORY ListVisibleVariablesX IS
  Inherited_List_VisibleVariables(Machine(elevador))==(?);
  Abstract_List_VisibleVariables(Machine(elevador))==(?);
  External_List_VisibleVariables(Machine(elevador))==(?);
  Expanded_List_VisibleVariables(Machine(elevador))==(?);
  List_VisibleVariables(Machine(elevador))==(?);
  Internal_List_VisibleVariables(Machine(elevador))==(?)
END
&
THEORY ListInvariantX IS
  Gluing_Seen_List_Invariant(Machine(elevador))==(btrue);
  Gluing_List_Invariant(Machine(elevador))==(btrue);
  Abstract_List_Invariant(Machine(elevador))==(btrue);
  Expanded_List_Invariant(Machine(elevador))==(pedidos_internos <: 0..andar_maximo & pedidos_subida <: 0..andar_maximo-1 & pedidos_descida <: 1..andar_maximo & piscando_interno1 <: 0..andar_maximo & piscando_subida1 <: 0..andar_maximo-1 & piscando_descida1 <: 1..andar_maximo & piscando_interno2 <: 0..andar_maximo & piscando_interno3 <: 0..andar_maximo & piscando_interno4 <: 0..andar_maximo & piscando_subida2 <: 0..andar_maximo-1 & piscando_subida3 <: 0..andar_maximo-1 & piscando_subida4 <: 0..andar_maximo-1 & piscando_descida2 <: 1..andar_maximo & piscando_descida3 <: 1..andar_maximo & piscando_descida4 <: 1..andar_maximo & historico_paradas: seq(0..andar_maximo) & size(historico_paradas)<=5 & segurando_interno: POW(0..andar_maximo) & segurando_interno_1: POW(0..andar_maximo) & segurando_interno_2: POW(0..andar_maximo) & interno_recusado: POW(0..andar_maximo) & segurando_subida: POW(0..andar_maximo-1) & segurando_subida_1: POW(0..andar_maximo-1) & segurando_subida_2: POW(0..andar_maximo-1) & segurando_descida: POW(1..andar_maximo) & segurando_descida_1: POW(1..andar_maximo) & segurando_descida_2: POW(1..andar_maximo) & segurando_interno_2 <: segurando_interno_1 & segurando_interno_1 <: segurando_interno & segurando_interno <: pedidos_internos & interno_recusado <: pedidos_internos & segurando_interno/\interno_recusado = {} & segurando_subida_2 <: segurando_subida_1 & segurando_subida_1 <: segurando_subida & segurando_subida <: pedidos_subida & segurando_descida_2 <: segurando_descida_1 & segurando_descida_1 <: segurando_descida & segurando_descida <: pedidos_descida & !aa.(aa: pedidos_subida => aa|->subindo: painel_externo) & !aa.(aa: pedidos_descida => aa|->descendo: painel_externo) & andar: 0..andar_maximo & direcao: DIRECOES & deslocamento: NATURAL & porta: PORTAS & porta_retida: BOOL & sentido_atendimento: DIRECOES & (direcao = subindo => sentido_atendimento = subindo) & (direcao = descendo => sentido_atendimento = descendo) & parada_pendente: BOOL & parada_por_cancelamento: BOOL & peso: NATURAL & limite_peso_atingido: BOOL & limite_peso_atingido = TRUE <=> peso>peso_maximo & (direcao/=parado => porta = fechada) & (direcao/=parado => limite_peso_atingido = FALSE) & (direcao = subindo => andar<andar_maximo) & (direcao = descendo => andar>0) & (parada_pendente = TRUE => direcao/=parado) & segundos_porta_aberta: 0..121 & (porta = fechada => segundos_porta_aberta = 0) & ultima_visita: 0..andar_maximo +-> NATURAL & ran(ultima_visita) <: 0..deslocamento & chave_manutencao: BOOL & manutencao: BOOL & (porta_retida = TRUE => porta = aberta) & (porta = fechada => porta_retida = FALSE) & (porta_retida = TRUE => direcao = parado) & (porta_retida = TRUE => manutencao = FALSE) & manutencao_pendente: BOOL & (manutencao = TRUE => chave_manutencao = TRUE) & (manutencao = TRUE => direcao = parado) & (manutencao_pendente = TRUE => chave_manutencao = TRUE) & not(manutencao = TRUE & manutencao_pendente = TRUE) & (manutencao_pendente = TRUE => direcao/=parado) & (parada_pendente = TRUE => parada_por_cancelamento = TRUE or manutencao_pendente = TRUE) & (parada_por_cancelamento = TRUE => parada_pendente = TRUE) & (manutencao_pendente = TRUE => parada_pendente = TRUE));
  Context_List_Invariant(Machine(elevador))==(btrue);
  List_Invariant(Machine(elevador))==(piscando_abrir: 0..4 & piscando_fechar: 0..4 & (manutencao = TRUE => pedidos_internos = {} & pedidos_subida = {} & pedidos_descida = {}))
END
&
THEORY ListAssertionsX IS
  Abstract_List_Assertions(Machine(elevador))==(btrue);
  Expanded_List_Assertions(Machine(elevador))==(btrue);
  Context_List_Assertions(Machine(elevador))==(btrue);
  List_Assertions(Machine(elevador))==(btrue)
END
&
THEORY ListCoverageX IS
  List_Coverage(Machine(elevador))==(btrue)
END
&
THEORY ListExclusivityX IS
  List_Exclusivity(Machine(elevador))==(btrue)
END
&
THEORY ListInitialisationX IS
  Expanded_List_Initialisation(Machine(elevador))==(pedidos_internos,pedidos_subida,pedidos_descida,piscando_interno1,piscando_subida1,piscando_descida1,piscando_interno2,piscando_interno3,piscando_interno4,piscando_subida2,piscando_subida3,piscando_subida4,piscando_descida2,piscando_descida3,piscando_descida4,segurando_interno,segurando_interno_1,segurando_interno_2,interno_recusado,segurando_subida,segurando_subida_1,segurando_subida_2,segurando_descida,segurando_descida_1,segurando_descida_2,historico_paradas:={},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},<>;andar,direcao,deslocamento,porta,porta_retida,sentido_atendimento,parada_pendente,parada_por_cancelamento,peso,limite_peso_atingido,segundos_porta_aberta,ultima_visita,chave_manutencao,manutencao,manutencao_pendente:=0,parado,0,fechada,FALSE,parado,FALSE,FALSE,0,FALSE,0,{},FALSE,FALSE,FALSE;piscando_abrir,piscando_fechar:=0,0);
  Context_List_Initialisation(Machine(elevador))==(skip);
  List_Initialisation(Machine(elevador))==(piscando_abrir:=0 || piscando_fechar:=0)
END
&
THEORY ListParametersX IS
  List_Parameters(Machine(elevador))==(?)
END
&
THEORY ListInstanciatedParametersX IS
  List_Instanciated_Parameters(Machine(elevador),Machine(painel_pedidos))==(?);
  List_Instanciated_Parameters(Machine(elevador),Machine(cabine_movimento))==(?);
  List_Instanciated_Parameters(Machine(elevador),Machine(configuracao))==(?)
END
&
THEORY ListConstraintsX IS
  List_Constraints(Machine(elevador),Machine(cabine_movimento))==(btrue);
  List_Context_Constraints(Machine(elevador))==(btrue);
  List_Constraints(Machine(elevador))==(btrue);
  List_Constraints(Machine(elevador),Machine(painel_pedidos))==(btrue)
END
&
THEORY ListOperationsX IS
  Internal_List_Operations(Machine(elevador))==(passar_tempo,inserir_chave,pressionar_interno,pressionar_externo_subida,pressionar_externo_descida,pressionar_abrir,pressionar_fechar,passo,consultar_leds_porta,consultar_visores,consultar_piscadas_porta,liberar_interno,liberar_subida,liberar_descida,consultar_leds,consultar_piscadas,consultar_botoes_pressionados,consultar_botoes_com_tempo,consultar_historico_paradas,consultar_extremos_historico,sugerir_pedido_qualquer,remover_chave_manutencao,atualizar_peso,ajustar_peso,segurar_porta,liberar_porta,consultar_parada_pendente,consultar_estado,consultar_deslocamento,consultar_peso,consultar_folga,consultar_porta,consultar_manutencao,consultar_visitas);
  List_Operations(Machine(elevador))==(passar_tempo,inserir_chave,pressionar_interno,pressionar_externo_subida,pressionar_externo_descida,pressionar_abrir,pressionar_fechar,passo,consultar_leds_porta,consultar_visores,consultar_piscadas_porta,liberar_interno,liberar_subida,liberar_descida,consultar_leds,consultar_piscadas,consultar_botoes_pressionados,consultar_botoes_com_tempo,consultar_historico_paradas,consultar_extremos_historico,sugerir_pedido_qualquer,remover_chave_manutencao,atualizar_peso,ajustar_peso,segurar_porta,liberar_porta,consultar_parada_pendente,consultar_estado,consultar_deslocamento,consultar_peso,consultar_folga,consultar_porta,consultar_manutencao,consultar_visitas)
END
&
THEORY ListInputX IS
  List_Input(Machine(elevador),consultar_visitas)==(?);
  List_Input(Machine(elevador),consultar_manutencao)==(?);
  List_Input(Machine(elevador),consultar_porta)==(?);
  List_Input(Machine(elevador),consultar_folga)==(?);
  List_Input(Machine(elevador),consultar_peso)==(?);
  List_Input(Machine(elevador),consultar_deslocamento)==(?);
  List_Input(Machine(elevador),consultar_estado)==(?);
  List_Input(Machine(elevador),consultar_parada_pendente)==(?);
  List_Input(Machine(elevador),liberar_porta)==(?);
  List_Input(Machine(elevador),segurar_porta)==(?);
  List_Input(Machine(elevador),ajustar_peso)==(delta);
  List_Input(Machine(elevador),atualizar_peso)==(novo_peso);
  List_Input(Machine(elevador),remover_chave_manutencao)==(?);
  List_Input(Machine(elevador),sugerir_pedido_qualquer)==(?);
  List_Input(Machine(elevador),consultar_extremos_historico)==(?);
  List_Input(Machine(elevador),consultar_historico_paradas)==(?);
  List_Input(Machine(elevador),consultar_botoes_com_tempo)==(tt);
  List_Input(Machine(elevador),consultar_botoes_pressionados)==(?);
  List_Input(Machine(elevador),consultar_piscadas)==(?);
  List_Input(Machine(elevador),consultar_leds)==(?);
  List_Input(Machine(elevador),liberar_descida)==(alvo);
  List_Input(Machine(elevador),liberar_subida)==(alvo);
  List_Input(Machine(elevador),liberar_interno)==(alvo);
  List_Input(Machine(elevador),passar_tempo)==(?);
  List_Input(Machine(elevador),inserir_chave)==(?);
  List_Input(Machine(elevador),pressionar_interno)==(alvo);
  List_Input(Machine(elevador),pressionar_externo_subida)==(alvo);
  List_Input(Machine(elevador),pressionar_externo_descida)==(alvo);
  List_Input(Machine(elevador),pressionar_abrir)==(?);
  List_Input(Machine(elevador),pressionar_fechar)==(?);
  List_Input(Machine(elevador),passo)==(?);
  List_Input(Machine(elevador),consultar_leds_porta)==(?);
  List_Input(Machine(elevador),consultar_visores)==(?);
  List_Input(Machine(elevador),consultar_piscadas_porta)==(?)
END
&
THEORY ListOutputX IS
  List_Output(Machine(elevador),consultar_visitas)==(visitados,nunca_visitados,marcas);
  List_Output(Machine(elevador),consultar_manutencao)==(chave_inserida,manutencao_ativa,manutencao_aguardando);
  List_Output(Machine(elevador),consultar_porta)==(estado_porta,tempo_aberta);
  List_Output(Machine(elevador),consultar_folga)==(folga);
  List_Output(Machine(elevador),consultar_peso)==(peso_atual,alerta_ativo);
  List_Output(Machine(elevador),consultar_deslocamento)==(total_deslocamento);
  List_Output(Machine(elevador),consultar_estado)==(pavimento_exibido,direcao_exibida);
  List_Output(Machine(elevador),consultar_parada_pendente)==(pendente);
  List_Output(Machine(elevador),liberar_porta)==(?);
  List_Output(Machine(elevador),segurar_porta)==(?);
  List_Output(Machine(elevador),ajustar_peso)==(?);
  List_Output(Machine(elevador),atualizar_peso)==(?);
  List_Output(Machine(elevador),remover_chave_manutencao)==(?);
  List_Output(Machine(elevador),sugerir_pedido_qualquer)==(alvo);
  List_Output(Machine(elevador),consultar_extremos_historico)==(primeira,ultima);
  List_Output(Machine(elevador),consultar_historico_paradas)==(historico,quantidade);
  List_Output(Machine(elevador),consultar_botoes_com_tempo)==(internos_com_tempo,subida_com_tempo,descida_com_tempo);
  List_Output(Machine(elevador),consultar_botoes_pressionados)==(botoes_internos,botoes_subida,botoes_descida);
  List_Output(Machine(elevador),consultar_piscadas)==(internos_fase1,internos_fase2,subida_fase1,subida_fase2,descida_fase1,descida_fase2);
  List_Output(Machine(elevador),consultar_leds)==(leds_internos,leds_subida,leds_descida);
  List_Output(Machine(elevador),liberar_descida)==(?);
  List_Output(Machine(elevador),liberar_subida)==(?);
  List_Output(Machine(elevador),liberar_interno)==(?);
  List_Output(Machine(elevador),passar_tempo)==(?);
  List_Output(Machine(elevador),inserir_chave)==(?);
  List_Output(Machine(elevador),pressionar_interno)==(?);
  List_Output(Machine(elevador),pressionar_externo_subida)==(?);
  List_Output(Machine(elevador),pressionar_externo_descida)==(?);
  List_Output(Machine(elevador),pressionar_abrir)==(?);
  List_Output(Machine(elevador),pressionar_fechar)==(?);
  List_Output(Machine(elevador),passo)==(?);
  List_Output(Machine(elevador),consultar_leds_porta)==(led_abrir,led_fechar);
  List_Output(Machine(elevador),consultar_visores)==(pavimento_exibido,direcao_exibida,aviso_manutencao_interno,aviso_manutencao_externo,aviso_sobrecarga_interno,aviso_porta_externo);
  List_Output(Machine(elevador),consultar_piscadas_porta)==(pisca_abrir,pisca_fechar)
END
&
THEORY ListHeaderX IS
  List_Header(Machine(elevador),consultar_visitas)==(visitados,nunca_visitados,marcas <-- consultar_visitas);
  List_Header(Machine(elevador),consultar_manutencao)==(chave_inserida,manutencao_ativa,manutencao_aguardando <-- consultar_manutencao);
  List_Header(Machine(elevador),consultar_porta)==(estado_porta,tempo_aberta <-- consultar_porta);
  List_Header(Machine(elevador),consultar_folga)==(folga <-- consultar_folga);
  List_Header(Machine(elevador),consultar_peso)==(peso_atual,alerta_ativo <-- consultar_peso);
  List_Header(Machine(elevador),consultar_deslocamento)==(total_deslocamento <-- consultar_deslocamento);
  List_Header(Machine(elevador),consultar_estado)==(pavimento_exibido,direcao_exibida <-- consultar_estado);
  List_Header(Machine(elevador),consultar_parada_pendente)==(pendente <-- consultar_parada_pendente);
  List_Header(Machine(elevador),liberar_porta)==(liberar_porta);
  List_Header(Machine(elevador),segurar_porta)==(segurar_porta);
  List_Header(Machine(elevador),ajustar_peso)==(ajustar_peso(delta));
  List_Header(Machine(elevador),atualizar_peso)==(atualizar_peso(novo_peso));
  List_Header(Machine(elevador),remover_chave_manutencao)==(remover_chave_manutencao);
  List_Header(Machine(elevador),sugerir_pedido_qualquer)==(alvo <-- sugerir_pedido_qualquer);
  List_Header(Machine(elevador),consultar_extremos_historico)==(primeira,ultima <-- consultar_extremos_historico);
  List_Header(Machine(elevador),consultar_historico_paradas)==(historico,quantidade <-- consultar_historico_paradas);
  List_Header(Machine(elevador),consultar_botoes_com_tempo)==(internos_com_tempo,subida_com_tempo,descida_com_tempo <-- consultar_botoes_com_tempo(tt));
  List_Header(Machine(elevador),consultar_botoes_pressionados)==(botoes_internos,botoes_subida,botoes_descida <-- consultar_botoes_pressionados);
  List_Header(Machine(elevador),consultar_piscadas)==(internos_fase1,internos_fase2,subida_fase1,subida_fase2,descida_fase1,descida_fase2 <-- consultar_piscadas);
  List_Header(Machine(elevador),consultar_leds)==(leds_internos,leds_subida,leds_descida <-- consultar_leds);
  List_Header(Machine(elevador),liberar_descida)==(liberar_descida(alvo));
  List_Header(Machine(elevador),liberar_subida)==(liberar_subida(alvo));
  List_Header(Machine(elevador),liberar_interno)==(liberar_interno(alvo));
  List_Header(Machine(elevador),passar_tempo)==(passar_tempo);
  List_Header(Machine(elevador),inserir_chave)==(inserir_chave);
  List_Header(Machine(elevador),pressionar_interno)==(pressionar_interno(alvo));
  List_Header(Machine(elevador),pressionar_externo_subida)==(pressionar_externo_subida(alvo));
  List_Header(Machine(elevador),pressionar_externo_descida)==(pressionar_externo_descida(alvo));
  List_Header(Machine(elevador),pressionar_abrir)==(pressionar_abrir);
  List_Header(Machine(elevador),pressionar_fechar)==(pressionar_fechar);
  List_Header(Machine(elevador),passo)==(passo);
  List_Header(Machine(elevador),consultar_leds_porta)==(led_abrir,led_fechar <-- consultar_leds_porta);
  List_Header(Machine(elevador),consultar_visores)==(pavimento_exibido,direcao_exibida,aviso_manutencao_interno,aviso_manutencao_externo,aviso_sobrecarga_interno,aviso_porta_externo <-- consultar_visores);
  List_Header(Machine(elevador),consultar_piscadas_porta)==(pisca_abrir,pisca_fechar <-- consultar_piscadas_porta)
END
&
THEORY ListOperationGuardX END
&
THEORY ListPreconditionX IS
  Own_Precondition(Machine(elevador),consultar_visitas)==(btrue);
  List_Precondition(Machine(elevador),consultar_visitas)==(btrue);
  Own_Precondition(Machine(elevador),consultar_manutencao)==(btrue);
  List_Precondition(Machine(elevador),consultar_manutencao)==(btrue);
  Own_Precondition(Machine(elevador),consultar_porta)==(btrue);
  List_Precondition(Machine(elevador),consultar_porta)==(btrue);
  Own_Precondition(Machine(elevador),consultar_folga)==(btrue);
  List_Precondition(Machine(elevador),consultar_folga)==(btrue);
  Own_Precondition(Machine(elevador),consultar_peso)==(btrue);
  List_Precondition(Machine(elevador),consultar_peso)==(btrue);
  Own_Precondition(Machine(elevador),consultar_deslocamento)==(btrue);
  List_Precondition(Machine(elevador),consultar_deslocamento)==(btrue);
  Own_Precondition(Machine(elevador),consultar_estado)==(btrue);
  List_Precondition(Machine(elevador),consultar_estado)==(btrue);
  Own_Precondition(Machine(elevador),consultar_parada_pendente)==(btrue);
  List_Precondition(Machine(elevador),consultar_parada_pendente)==(btrue);
  Own_Precondition(Machine(elevador),liberar_porta)==(btrue);
  List_Precondition(Machine(elevador),liberar_porta)==(btrue);
  Own_Precondition(Machine(elevador),segurar_porta)==(btrue);
  List_Precondition(Machine(elevador),segurar_porta)==(btrue);
  Own_Precondition(Machine(elevador),ajustar_peso)==(delta: INTEGER & direcao = parado & peso+delta: NATURAL);
  List_Precondition(Machine(elevador),ajustar_peso)==(delta: INTEGER & direcao = parado & peso+delta: NATURAL);
  Own_Precondition(Machine(elevador),atualizar_peso)==(novo_peso: NATURAL & direcao = parado);
  List_Precondition(Machine(elevador),atualizar_peso)==(novo_peso: NATURAL & direcao = parado);
  Own_Precondition(Machine(elevador),remover_chave_manutencao)==(chave_manutencao = TRUE & (manutencao = TRUE & direcao = parado or manutencao_pendente = TRUE));
  List_Precondition(Machine(elevador),remover_chave_manutencao)==(chave_manutencao = TRUE & (manutencao = TRUE & direcao = parado or manutencao_pendente = TRUE));
  Own_Precondition(Machine(elevador),sugerir_pedido_qualquer)==(pedidos_internos\/pedidos_subida\/pedidos_descida/={});
  List_Precondition(Machine(elevador),sugerir_pedido_qualquer)==(pedidos_internos\/pedidos_subida\/pedidos_descida/={});
  Own_Precondition(Machine(elevador),consultar_extremos_historico)==(historico_paradas/=<>);
  List_Precondition(Machine(elevador),consultar_extremos_historico)==(historico_paradas/=<>);
  Own_Precondition(Machine(elevador),consultar_historico_paradas)==(btrue);
  List_Precondition(Machine(elevador),consultar_historico_paradas)==(btrue);
  Own_Precondition(Machine(elevador),consultar_botoes_com_tempo)==(tt: -1..3);
  List_Precondition(Machine(elevador),consultar_botoes_com_tempo)==(tt: -1..3);
  Own_Precondition(Machine(elevador),consultar_botoes_pressionados)==(btrue);
  List_Precondition(Machine(elevador),consultar_botoes_pressionados)==(btrue);
  Own_Precondition(Machine(elevador),consultar_piscadas)==(btrue);
  List_Precondition(Machine(elevador),consultar_piscadas)==(btrue);
  Own_Precondition(Machine(elevador),consultar_leds)==(btrue);
  List_Precondition(Machine(elevador),consultar_leds)==(btrue);
  Own_Precondition(Machine(elevador),liberar_descida)==(alvo: 1..andar_maximo);
  List_Precondition(Machine(elevador),liberar_descida)==(alvo: 1..andar_maximo);
  Own_Precondition(Machine(elevador),liberar_subida)==(alvo: 0..andar_maximo-1);
  List_Precondition(Machine(elevador),liberar_subida)==(alvo: 0..andar_maximo-1);
  Own_Precondition(Machine(elevador),liberar_interno)==(alvo: 0..andar_maximo);
  List_Precondition(Machine(elevador),liberar_interno)==(alvo: 0..andar_maximo);
  List_Precondition(Machine(elevador),passar_tempo)==(btrue);
  List_Precondition(Machine(elevador),inserir_chave)==(chave_manutencao = FALSE);
  List_Precondition(Machine(elevador),pressionar_interno)==(alvo: 0..andar_maximo);
  List_Precondition(Machine(elevador),pressionar_externo_subida)==(alvo: 0..andar_maximo-1 & alvo|->subindo: painel_externo);
  List_Precondition(Machine(elevador),pressionar_externo_descida)==(alvo: 1..andar_maximo & alvo|->descendo: painel_externo);
  List_Precondition(Machine(elevador),pressionar_abrir)==(btrue);
  List_Precondition(Machine(elevador),pressionar_fechar)==(btrue);
  List_Precondition(Machine(elevador),passo)==(manutencao = FALSE & (#pp.(pp: pedidos_internos\/pedidos_subida\/pedidos_descida) or direcao/=parado or porta = aberta or sentido_atendimento/=parado));
  List_Precondition(Machine(elevador),consultar_leds_porta)==(btrue);
  List_Precondition(Machine(elevador),consultar_visores)==(btrue);
  List_Precondition(Machine(elevador),consultar_piscadas_porta)==(btrue)
END
&
THEORY ListSubstitutionX IS
  Expanded_List_Substitution(Machine(elevador),consultar_piscadas_porta)==(btrue | pisca_abrir,pisca_fechar:=piscando_abrir,piscando_fechar);
  Expanded_List_Substitution(Machine(elevador),consultar_visores)==(btrue | pavimento_exibido,direcao_exibida,aviso_manutencao_interno,aviso_manutencao_externo,aviso_sobrecarga_interno,aviso_porta_externo:=andar,direcao,manutencao,manutencao,limite_peso_atingido,bool(segundos_porta_aberta>120));
  Expanded_List_Substitution(Machine(elevador),consultar_leds_porta)==(btrue | led_abrir,led_fechar:=bool(piscando_abrir = 4 or piscando_abrir = 2),bool(piscando_fechar = 4 or piscando_fechar = 2));
  Expanded_List_Substitution(Machine(elevador),passo)==(manutencao = FALSE & (#pp.(pp: pedidos_internos\/pedidos_subida\/pedidos_descida) or direcao/=parado or porta = aberta or sentido_atendimento/=parado) | direcao = subindo ==> (pedidos_internos <: 0..andar_maximo & pedidos_subida <: 0..andar_maximo-1 & pedidos_descida <: 1..andar_maximo & direcao = subindo & porta = fechada & limite_peso_atingido = FALSE & manutencao = FALSE & andar<andar_maximo | andar,deslocamento:=andar+1,deslocamento+1 || (andar+1 = andar_maximo or parada_pendente = TRUE or andar+1: pedidos_internos\/pedidos_subida or pedidos_internos\/pedidos_subida\/pedidos_descida/\andar+2..andar_maximo = {} ==> (direcao:=parado || (manutencao_pendente = TRUE ==> manutencao,manutencao_pendente:=TRUE,FALSE [] not(manutencao_pendente = TRUE) ==> skip)) [] not(andar+1 = andar_maximo or parada_pendente = TRUE or andar+1: pedidos_internos\/pedidos_subida or pedidos_internos\/pedidos_subida\/pedidos_descida/\andar+2..andar_maximo = {}) ==> skip) || parada_pendente:=FALSE || parada_por_cancelamento:=FALSE || (manutencao_pendente = TRUE ==> (btrue | segurando_interno,segurando_interno_1,segurando_interno_2,interno_recusado,segurando_subida,segurando_subida_1,segurando_subida_2,segurando_descida,segurando_descida_1,segurando_descida_2,pedidos_internos,pedidos_subida,pedidos_descida,piscando_interno1,piscando_interno2,piscando_interno3,piscando_interno4,piscando_subida1,piscando_subida2,piscando_subida3,piscando_subida4,piscando_descida1,piscando_descida2,piscando_descida3,piscando_descida4:={},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{}) [] not(manutencao_pendente = TRUE) ==> skip)) [] not(direcao = subindo) ==> (direcao = descendo ==> (pedidos_internos <: 0..andar_maximo & pedidos_subida <: 0..andar_maximo-1 & pedidos_descida <: 1..andar_maximo & direcao = descendo & porta = fechada & limite_peso_atingido = FALSE & manutencao = FALSE & andar>0 | andar,deslocamento:=andar-1,deslocamento+1 || (parada_pendente = TRUE or andar-1: pedidos_internos\/pedidos_descida or pedidos_internos\/pedidos_subida\/pedidos_descida/\0..andar-2 = {} ==> (direcao:=parado || (manutencao_pendente = TRUE ==> manutencao,manutencao_pendente:=TRUE,FALSE [] not(manutencao_pendente = TRUE) ==> skip)) [] not(parada_pendente = TRUE or andar-1: pedidos_internos\/pedidos_descida or pedidos_internos\/pedidos_subida\/pedidos_descida/\0..andar-2 = {}) ==> skip) || parada_pendente:=FALSE || parada_por_cancelamento:=FALSE || (manutencao_pendente = TRUE ==> (btrue | segurando_interno,segurando_interno_1,segurando_interno_2,interno_recusado,segurando_subida,segurando_subida_1,segurando_subida_2,segurando_descida,segurando_descida_1,segurando_descida_2,pedidos_internos,pedidos_subida,pedidos_descida,piscando_interno1,piscando_interno2,piscando_interno3,piscando_interno4,piscando_subida1,piscando_subida2,piscando_subida3,piscando_subida4,piscando_descida1,piscando_descida2,piscando_descida3,piscando_descida4:={},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{}) [] not(manutencao_pendente = TRUE) ==> skip)) [] not(direcao = descendo) ==> (porta = aberta & (andar: pedidos_internos or (andar: pedidos_subida & sentido_atendimento/=descendo) or (andar: pedidos_descida & sentido_atendimento/=subindo)) ==> (pedidos_internos <: 0..andar_maximo & pedidos_subida <: 0..andar_maximo-1 & pedidos_descida <: 1..andar_maximo & direcao = parado & porta = aberta & manutencao = FALSE & andar: 0..andar_maximo & sentido_atendimento: DIRECOES | sentido_atendimento = parado & andar: pedidos_subida ==> sentido_atendimento:=subindo [] not(sentido_atendimento = parado & andar: pedidos_subida) ==> (sentido_atendimento = parado & andar: pedidos_descida ==> sentido_atendimento:=descendo [] not(sentido_atendimento = parado & andar: pedidos_descida) ==> skip) || (andar: pedidos_internos ==> pedidos_internos,piscando_interno1,piscando_interno2,piscando_interno3,piscando_interno4,segurando_interno,segurando_interno_1,segurando_interno_2,interno_recusado:=pedidos_internos-{andar},piscando_interno1-{andar},piscando_interno2-{andar},piscando_interno3-{andar},piscando_interno4-{andar},segurando_interno-{andar},segurando_interno_1-{andar},segurando_interno_2-{andar},interno_recusado-{andar} [] not(andar: pedidos_internos) ==> skip || (sentido_atendimento = subindo or sentido_atendimento = parado & andar: pedidos_subida ==> pedidos_subida,piscando_subida1,piscando_subida2,piscando_subida3,piscando_subida4,segurando_subida,segurando_subida_1,segurando_subida_2:=pedidos_subida-{andar},piscando_subida1-{andar},piscando_subida2-{andar},piscando_subida3-{andar},piscando_subida4-{andar},segurando_subida-{andar},segurando_subida_1-{andar},segurando_subida_2-{andar} [] not(sentido_atendimento = subindo or sentido_atendimento = parado & andar: pedidos_subida) ==> skip) || (sentido_atendimento = descendo or (sentido_atendimento = parado & andar/:pedidos_subida) & andar: pedidos_descida ==> pedidos_descida,piscando_descida1,piscando_descida2,piscando_descida3,piscando_descida4,segurando_descida,segurando_descida_1,segurando_descida_2:=pedidos_descida-{andar},piscando_descida1-{andar},piscando_descida2-{andar},piscando_descida3-{andar},piscando_descida4-{andar},segurando_descida-{andar},segurando_descida_1-{andar},segurando_descida_2-{andar} [] not(sentido_atendimento = descendo or (sentido_atendimento = parado & andar/:pedidos_subida) & andar: pedidos_descida) ==> skip) || (size(historico_paradas)<5 ==> historico_paradas:=historico_paradas<-andar [] not(size(historico_paradas)<5) ==> historico_paradas:=tail(historico_paradas)^[andar]))) [] not(porta = aberta & (andar: pedidos_internos or (andar: pedidos_subida & sentido_atendimento/=descendo) or (andar: pedidos_descida & sentido_atendimento/=subindo))) ==> (porta = aberta ==> (porta_retida = FALSE ==> (porta = aberta & porta_retida = FALSE | porta,segundos_porta_aberta:=fechada,0) [] not(porta_retida = FALSE) ==> skip) [] not(porta = aberta) ==> (pedidos_internos\/pedidos_subida\/pedidos_descida = {} ==> (pedidos_internos <: 0..andar_maximo & pedidos_subida <: 0..andar_maximo-1 & pedidos_descida <: 1..andar_maximo & direcao = parado & porta = fechada & pedidos_internos = {} & pedidos_subida = {} & pedidos_descida = {} | sentido_atendimento:=parado) [] not(pedidos_internos\/pedidos_subida\/pedidos_descida = {}) ==> (andar: pedidos_internos or (andar: pedidos_subida & sentido_atendimento/=descendo) or (andar: pedidos_descida & sentido_atendimento/=subindo) ==> (pedidos_internos <: 0..andar_maximo & pedidos_subida <: 0..andar_maximo-1 & pedidos_descida <: 1..andar_maximo & direcao = parado & porta = fechada & manutencao = FALSE & andar: 0..andar_maximo & sentido_atendimento: DIRECOES | porta:=aberta || (sentido_atendimento = parado & andar: pedidos_subida ==> sentido_atendimento:=subindo [] not(sentido_atendimento = parado & andar: pedidos_subida) ==> (sentido_atendimento = parado & andar: pedidos_descida ==> sentido_atendimento:=descendo [] not(sentido_atendimento = parado & andar: pedidos_descida) ==> skip)) || ultima_visita:=ultima_visita<+{andar|->deslocamento} || (andar: pedidos_internos ==> pedidos_internos,piscando_interno1,piscando_interno2,piscando_interno3,piscando_interno4,segurando_interno,segurando_interno_1,segurando_interno_2,interno_recusado:=pedidos_internos-{andar},piscando_interno1-{andar},piscando_interno2-{andar},piscando_interno3-{andar},piscando_interno4-{andar},segurando_interno-{andar},segurando_interno_1-{andar},segurando_interno_2-{andar},interno_recusado-{andar} [] not(andar: pedidos_internos) ==> skip || (sentido_atendimento = subindo or sentido_atendimento = parado & andar: pedidos_subida ==> pedidos_subida,piscando_subida1,piscando_subida2,piscando_subida3,piscando_subida4,segurando_subida,segurando_subida_1,segurando_subida_2:=pedidos_subida-{andar},piscando_subida1-{andar},piscando_subida2-{andar},piscando_subida3-{andar},piscando_subida4-{andar},segurando_subida-{andar},segurando_subida_1-{andar},segurando_subida_2-{andar} [] not(sentido_atendimento = subindo or sentido_atendimento = parado & andar: pedidos_subida) ==> skip) || (sentido_atendimento = descendo or (sentido_atendimento = parado & andar/:pedidos_subida) & andar: pedidos_descida ==> pedidos_descida,piscando_descida1,piscando_descida2,piscando_descida3,piscando_descida4,segurando_descida,segurando_descida_1,segurando_descida_2:=pedidos_descida-{andar},piscando_descida1-{andar},piscando_descida2-{andar},piscando_descida3-{andar},piscando_descida4-{andar},segurando_descida-{andar},segurando_descida_1-{andar},segurando_descida_2-{andar} [] not(sentido_atendimento = descendo or (sentido_atendimento = parado & andar/:pedidos_subida) & andar: pedidos_descida) ==> skip) || (size(historico_paradas)<5 ==> historico_paradas:=historico_paradas<-andar [] not(size(historico_paradas)<5) ==> historico_paradas:=tail(historico_paradas)^[andar]))) [] not(andar: pedidos_internos or (andar: pedidos_subida & sentido_atendimento/=descendo) or (andar: pedidos_descida & sentido_atendimento/=subindo)) ==> (limite_peso_atingido = TRUE ==> skip [] not(limite_peso_atingido = TRUE) ==> (sentido_atendimento = subindo & pedidos_internos\/pedidos_subida\/pedidos_descida/\andar+1..andar_maximo = {} or (sentido_atendimento = descendo & pedidos_internos\/pedidos_subida\/pedidos_descida/\0..andar-1 = {}) ==> (direcao = parado & porta = fechada & sentido_atendimento: {subindo,descendo} | sentido_atendimento = subindo ==> sentido_atendimento:=descendo [] not(sentido_atendimento = subindo) ==> sentido_atendimento:=subindo) [] not(sentido_atendimento = subindo & pedidos_internos\/pedidos_subida\/pedidos_descida/\andar+1..andar_maximo = {} or (sentido_atendimento = descendo & pedidos_internos\/pedidos_subida\/pedidos_descida/\0..andar-1 = {})) ==> (sentido_atendimento = subindo ==> (direcao = parado & porta = fechada & limite_peso_atingido = FALSE & manutencao = FALSE & andar<andar_maximo & (sentido_atendimento = parado or sentido_atendimento = subindo) | direcao,sentido_atendimento:=subindo,subindo) [] not(sentido_atendimento = subindo) ==> (sentido_atendimento = descendo ==> (direcao = parado & porta = fechada & limite_peso_atingido = FALSE & manutencao = FALSE & andar>0 & (sentido_atendimento = parado or sentido_atendimento = descendo) | direcao,sentido_atendimento:=descendo,descendo) [] not(sentido_atendimento = descendo) ==> (andar = andar_maximo ==> (direcao = parado & porta = fechada & limite_peso_atingido = FALSE & manutencao = FALSE & andar>0 & (sentido_atendimento = parado or sentido_atendimento = descendo) | direcao,sentido_atendimento:=descendo,descendo) [] not(andar = andar_maximo) ==> (andar = 0 ==> (direcao = parado & porta = fechada & limite_peso_atingido = FALSE & manutencao = FALSE & andar<andar_maximo & (sentido_atendimento = parado or sentido_atendimento = subindo) | direcao,sentido_atendimento:=subindo,subindo) [] not(andar = 0) ==> (pedidos_internos\/pedidos_subida\/pedidos_descida/\0..andar-1 = {} ==> (direcao = parado & porta = fechada & limite_peso_atingido = FALSE & manutencao = FALSE & andar<andar_maximo & (sentido_atendimento = parado or sentido_atendimento = subindo) | direcao,sentido_atendimento:=subindo,subindo) [] not(pedidos_internos\/pedidos_subida\/pedidos_descida/\0..andar-1 = {}) ==> (pedidos_internos\/pedidos_subida\/pedidos_descida/\andar+1..andar_maximo = {} ==> (direcao = parado & porta = fechada & limite_peso_atingido = FALSE & manutencao = FALSE & andar>0 & (sentido_atendimento = parado or sentido_atendimento = descendo) | direcao,sentido_atendimento:=descendo,descendo) [] not(pedidos_internos\/pedidos_subida\/pedidos_descida/\andar+1..andar_maximo = {}) ==> (min(pedidos_internos\/pedidos_subida\/pedidos_descida/\andar+1..andar_maximo\/{andar_maximo})-andar<=andar-max(pedidos_internos\/pedidos_subida\/pedidos_descida/\0..andar-1\/{0}) ==> (direcao = parado & porta = fechada & limite_peso_atingido = FALSE & manutencao = FALSE & andar<andar_maximo & (sentido_atendimento = parado or sentido_atendimento = subindo) | direcao,sentido_atendimento:=subindo,subindo) [] not(min(pedidos_internos\/pedidos_subida\/pedidos_descida/\andar+1..andar_maximo\/{andar_maximo})-andar<=andar-max(pedidos_internos\/pedidos_subida\/pedidos_descida/\0..andar-1\/{0})) ==> (direcao = parado & porta = fechada & limite_peso_atingido = FALSE & manutencao = FALSE & andar>0 & (sentido_atendimento = parado or sentido_atendimento = descendo) | direcao,sentido_atendimento:=descendo,descendo))))))))))))))));
  Expanded_List_Substitution(Machine(elevador),pressionar_fechar)==(btrue | manutencao = TRUE ==> piscando_fechar:=4 [] manutencao = FALSE & direcao = parado & porta = aberta & porta_retida = FALSE ==> (porta = aberta & porta_retida = FALSE | porta,segundos_porta_aberta:=fechada,0) [] not(manutencao = TRUE) & not(manutencao = FALSE & direcao = parado & porta = aberta & porta_retida = FALSE) ==> skip);
  Expanded_List_Substitution(Machine(elevador),pressionar_abrir)==(btrue | manutencao = TRUE ==> piscando_abrir:=4 [] manutencao = FALSE & direcao = parado & porta = fechada ==> (pedidos_internos <: 0..andar_maximo & pedidos_subida <: 0..andar_maximo-1 & pedidos_descida <: 1..andar_maximo & direcao = parado & porta = fechada & manutencao = FALSE | porta:=aberta || (sentido_atendimento = parado & andar: pedidos_subida ==> sentido_atendimento:=subindo [] not(sentido_atendimento = parado & andar: pedidos_subida) ==> (sentido_atendimento = parado & andar: pedidos_descida ==> sentido_atendimento:=descendo [] not(sentido_atendimento = parado & andar: pedidos_descida) ==> skip)) || ultima_visita:=ultima_visita<+{andar|->deslocamento} || (andar: pedidos_internos or (andar: pedidos_subida & sentido_atendimento/=descendo) or (andar: pedidos_descida & sentido_atendimento/=subindo) ==> (andar: 0..andar_maximo & sentido_atendimento: DIRECOES | andar: pedidos_internos ==> pedidos_internos,piscando_interno1,piscando_interno2,piscando_interno3,piscando_interno4,segurando_interno,segurando_interno_1,segurando_interno_2,interno_recusado:=pedidos_internos-{andar},piscando_interno1-{andar},piscando_interno2-{andar},piscando_interno3-{andar},piscando_interno4-{andar},segurando_interno-{andar},segurando_interno_1-{andar},segurando_interno_2-{andar},interno_recusado-{andar} [] not(andar: pedidos_internos) ==> skip || (sentido_atendimento = subindo or sentido_atendimento = parado & andar: pedidos_subida ==> pedidos_subida,piscando_subida1,piscando_subida2,piscando_subida3,piscando_subida4,segurando_subida,segurando_subida_1,segurando_subida_2:=pedidos_subida-{andar},piscando_subida1-{andar},piscando_subida2-{andar},piscando_subida3-{andar},piscando_subida4-{andar},segurando_subida-{andar},segurando_subida_1-{andar},segurando_subida_2-{andar} [] not(sentido_atendimento = subindo or sentido_atendimento = parado & andar: pedidos_subida) ==> skip) || (sentido_atendimento = descendo or (sentido_atendimento = parado & andar/:pedidos_subida) & andar: pedidos_descida ==> pedidos_descida,piscando_descida1,piscando_descida2,piscando_descida3,piscando_descida4,segurando_descida,segurando_descida_1,segurando_descida_2:=pedidos_descida-{andar},piscando_descida1-{andar},piscando_descida2-{andar},piscando_descida3-{andar},piscando_descida4-{andar},segurando_descida-{andar},segurando_descida_1-{andar},segurando_descida_2-{andar} [] not(sentido_atendimento = descendo or (sentido_atendimento = parado & andar/:pedidos_subida) & andar: pedidos_descida) ==> skip) || (size(historico_paradas)<5 ==> historico_paradas:=historico_paradas<-andar [] not(size(historico_paradas)<5) ==> historico_paradas:=tail(historico_paradas)^[andar])) [] not(andar: pedidos_internos or (andar: pedidos_subida & sentido_atendimento/=descendo) or (andar: pedidos_descida & sentido_atendimento/=subindo)) ==> skip)) [] not(manutencao = TRUE) & not(manutencao = FALSE & direcao = parado & porta = fechada) ==> skip);
  Expanded_List_Substitution(Machine(elevador),pressionar_externo_descida)==(alvo: 1..andar_maximo & alvo|->descendo: painel_externo | manutencao = TRUE ==> (alvo: 1..andar_maximo & alvo|->descendo: painel_externo | piscando_descida1,piscando_descida2,piscando_descida3,piscando_descida4:=piscando_descida1\/{alvo},piscando_descida2-{alvo},piscando_descida3-{alvo},piscando_descida4-{alvo}) [] manutencao = FALSE ==> (alvo: 1..andar_maximo & alvo|->descendo: painel_externo | pedidos_descida,segurando_descida,segurando_descida_1,segurando_descida_2,piscando_descida1,piscando_descida2,piscando_descida3,piscando_descida4:=pedidos_descida\/{alvo},segurando_descida\/{alvo},segurando_descida_1-{alvo},segurando_descida_2-{alvo},piscando_descida1-{alvo},piscando_descida2-{alvo},piscando_descida3-{alvo},piscando_descida4-{alvo}));
  Expanded_List_Substitution(Machine(elevador),pressionar_externo_subida)==(alvo: 0..andar_maximo-1 & alvo|->subindo: painel_externo | manutencao = TRUE ==> (alvo: 0..andar_maximo-1 & alvo|->subindo: painel_externo | piscando_subida1,piscando_subida2,piscando_subida3,piscando_subida4:=piscando_subida1\/{alvo},piscando_subida2-{alvo},piscando_subida3-{alvo},piscando_subida4-{alvo}) [] manutencao = FALSE ==> (alvo: 0..andar_maximo-1 & alvo|->subindo: painel_externo | pedidos_subida,segurando_subida,segurando_subida_1,segurando_subida_2,piscando_subida1,piscando_subida2,piscando_subida3,piscando_subida4:=pedidos_subida\/{alvo},segurando_subida\/{alvo},segurando_subida_1-{alvo},segurando_subida_2-{alvo},piscando_subida1-{alvo},piscando_subida2-{alvo},piscando_subida3-{alvo},piscando_subida4-{alvo}));
  Expanded_List_Substitution(Machine(elevador),pressionar_interno)==(alvo: 0..andar_maximo | manutencao = TRUE ==> (alvo: 0..andar_maximo | piscando_interno1,piscando_interno2,piscando_interno3,piscando_interno4:=piscando_interno1\/{alvo},piscando_interno2-{alvo},piscando_interno3-{alvo},piscando_interno4-{alvo}) [] manutencao = FALSE ==> (alvo: 0..andar_maximo | pedidos_internos,segurando_interno,segurando_interno_1,segurando_interno_2,interno_recusado,piscando_interno1,piscando_interno2,piscando_interno3,piscando_interno4:=pedidos_internos\/{alvo},segurando_interno\/{alvo},segurando_interno_1-{alvo},segurando_interno_2-{alvo},interno_recusado-{alvo},piscando_interno1-{alvo},piscando_interno2-{alvo},piscando_interno3-{alvo},piscando_interno4-{alvo}));
  Expanded_List_Substitution(Machine(elevador),inserir_chave)==(chave_manutencao = FALSE | chave_manutencao:=TRUE || (direcao = parado ==> manutencao,manutencao_pendente,porta_retida:=TRUE,FALSE,FALSE [] not(direcao = parado) ==> manutencao_pendente,parada_pendente:=TRUE,TRUE) || (direcao = parado ==> (btrue | segurando_interno,segurando_interno_1,segurando_interno_2,interno_recusado,segurando_subida,segurando_subida_1,segurando_subida_2,segurando_descida,segurando_descida_1,segurando_descida_2,pedidos_internos,pedidos_subida,pedidos_descida,piscando_interno1,piscando_interno2,piscando_interno3,piscando_interno4,piscando_subida1,piscando_subida2,piscando_subida3,piscando_subida4,piscando_descida1,piscando_descida2,piscando_descida3,piscando_descida4:={},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{}) [] not(direcao = parado) ==> skip));
  Expanded_List_Substitution(Machine(elevador),passar_tempo)==(btrue | manutencao = TRUE ==> (btrue & FALSE: BOOL & (FALSE = TRUE => direcao/=parado) | piscando_interno1,piscando_interno2,piscando_interno3,piscando_interno4,piscando_subida1,piscando_subida2,piscando_subida3,piscando_subida4,piscando_descida1,piscando_descida2,piscando_descida3,piscando_descida4:={},piscando_interno1,piscando_interno2,piscando_interno3,{},piscando_subida1,piscando_subida2,piscando_subida3,{},piscando_descida1,piscando_descida2,piscando_descida3 || (porta = aberta & segundos_porta_aberta<121 ==> segundos_porta_aberta:=segundos_porta_aberta+1 [] not(porta = aberta & segundos_porta_aberta<121) ==> skip || (FALSE = TRUE ==> parada_por_cancelamento,parada_pendente:=TRUE,TRUE [] not(FALSE = TRUE) ==> skip))) [] not(manutencao = TRUE) ==> (btrue | pedidos_internos/={} & pedidos_internos = segurando_interno_2 & pedidos_subida-segurando_subida_2 = {} & pedidos_descida-segurando_descida_2 = {} ==> pedidos_internos,segurando_interno,segurando_interno_1,segurando_interno_2,interno_recusado,piscando_interno1,piscando_interno2,piscando_interno3,piscando_interno4:={min(pedidos_internos)},{},{},{},{min(pedidos_internos)},{min(pedidos_internos)},piscando_interno1-{min(pedidos_internos)},piscando_interno2-{min(pedidos_internos)},piscando_interno3-{min(pedidos_internos)} [] not(pedidos_internos/={} & pedidos_internos = segurando_interno_2 & pedidos_subida-segurando_subida_2 = {} & pedidos_descida-segurando_descida_2 = {}) ==> pedidos_internos,segurando_interno,segurando_interno_1,segurando_interno_2,interno_recusado,piscando_interno1,piscando_interno2,piscando_interno3,piscando_interno4:=pedidos_internos-segurando_interno_2,segurando_interno-segurando_interno_2,segurando_interno-segurando_interno_2,segurando_interno_1-segurando_interno_2,interno_recusado-segurando_interno_2,{},piscando_interno1,piscando_interno2,piscando_interno3 || pedidos_subida:=pedidos_subida-segurando_subida_2 || segurando_subida:=segurando_subida-segurando_subida_2 || segurando_subida_1:=segurando_subida-segurando_subida_2 || segurando_subida_2:=segurando_subida_1-segurando_subida_2 || piscando_subida1:={} || piscando_subida2:=piscando_subida1 || piscando_subida3:=piscando_subida2 || piscando_subida4:=piscando_subida3 || pedidos_descida:=pedidos_descida-segurando_descida_2 || segurando_descida:=segurando_descida-segurando_descida_2 || segurando_descida_1:=segurando_descida-segurando_descida_2 || segurando_descida_2:=segurando_descida_1-segurando_descida_2 || piscando_descida1:={} || piscando_descida2:=piscando_descida1 || piscando_descida3:=piscando_descida2 || piscando_descida4:=piscando_descida3 || (direcao/=parado & pedidos_internos = {} & pedidos_subida = segurando_subida_2 & pedidos_descida = segurando_descida_2 & pedidos_subida\/pedidos_descida/={} ==> (TRUE: BOOL & (TRUE = TRUE => direcao/=parado) | porta = aberta & segundos_porta_aberta<121 ==> segundos_porta_aberta:=segundos_porta_aberta+1 [] not(porta = aberta & segundos_porta_aberta<121) ==> skip || (TRUE = TRUE ==> parada_por_cancelamento,parada_pendente:=TRUE,TRUE [] not(TRUE = TRUE) ==> skip)) [] not(direcao/=parado & pedidos_internos = {} & pedidos_subida = segurando_subida_2 & pedidos_descida = segurando_descida_2 & pedidos_subida\/pedidos_descida/={}) ==> (FALSE: BOOL & (FALSE = TRUE => direcao/=parado) | porta = aberta & segundos_porta_aberta<121 ==> segundos_porta_aberta:=segundos_porta_aberta+1 [] not(porta = aberta & segundos_porta_aberta<121) ==> skip || (FALSE = TRUE ==> parada_por_cancelamento,parada_pendente:=TRUE,TRUE [] not(FALSE = TRUE) ==> skip)))) || piscando_abrir:=max({0,piscando_abrir-1}) || piscando_fechar:=max({0,piscando_fechar-1}));
  List_Substitution(Machine(elevador),consultar_visitas)==(visitados:=dom(ultima_visita) || nunca_visitados:={aa | aa: 0..andar_maximo & aa/:dom(ultima_visita)} || marcas:=ran(ultima_visita));
  Expanded_List_Substitution(Machine(elevador),consultar_visitas)==(btrue | visitados,nunca_visitados,marcas:=dom(ultima_visita),{aa | aa: 0..andar_maximo & aa/:dom(ultima_visita)},ran(ultima_visita));
  List_Substitution(Machine(elevador),consultar_manutencao)==(chave_inserida:=chave_manutencao || manutencao_ativa:=manutencao || manutencao_aguardando:=manutencao_pendente);
  Expanded_List_Substitution(Machine(elevador),consultar_manutencao)==(btrue | chave_inserida,manutencao_ativa,manutencao_aguardando:=chave_manutencao,manutencao,manutencao_pendente);
  List_Substitution(Machine(elevador),consultar_porta)==(estado_porta:=porta || tempo_aberta:=segundos_porta_aberta);
  Expanded_List_Substitution(Machine(elevador),consultar_porta)==(btrue | estado_porta,tempo_aberta:=porta,segundos_porta_aberta);
  List_Substitution(Machine(elevador),consultar_folga)==(folga:=peso_maximo-peso);
  Expanded_List_Substitution(Machine(elevador),consultar_folga)==(btrue | folga:=peso_maximo-peso);
  List_Substitution(Machine(elevador),consultar_peso)==(peso_atual:=peso || alerta_ativo:=limite_peso_atingido);
  Expanded_List_Substitution(Machine(elevador),consultar_peso)==(btrue | peso_atual,alerta_ativo:=peso,limite_peso_atingido);
  List_Substitution(Machine(elevador),consultar_deslocamento)==(total_deslocamento:=deslocamento);
  Expanded_List_Substitution(Machine(elevador),consultar_deslocamento)==(btrue | total_deslocamento:=deslocamento);
  List_Substitution(Machine(elevador),consultar_estado)==(pavimento_exibido:=andar || direcao_exibida:=direcao);
  Expanded_List_Substitution(Machine(elevador),consultar_estado)==(btrue | pavimento_exibido,direcao_exibida:=andar,direcao);
  List_Substitution(Machine(elevador),consultar_parada_pendente)==(pendente:=parada_pendente);
  Expanded_List_Substitution(Machine(elevador),consultar_parada_pendente)==(btrue | pendente:=parada_pendente);
  List_Substitution(Machine(elevador),liberar_porta)==(porta_retida:=FALSE);
  Expanded_List_Substitution(Machine(elevador),liberar_porta)==(btrue | porta_retida:=FALSE);
  List_Substitution(Machine(elevador),segurar_porta)==(IF direcao = parado & porta = aberta & manutencao = FALSE THEN porta_retida:=TRUE END);
  Expanded_List_Substitution(Machine(elevador),segurar_porta)==(btrue | direcao = parado & porta = aberta & manutencao = FALSE ==> porta_retida:=TRUE [] not(direcao = parado & porta = aberta & manutencao = FALSE) ==> skip);
  List_Substitution(Machine(elevador),ajustar_peso)==(peso:=peso+delta || limite_peso_atingido:=bool(peso+delta>peso_maximo));
  Expanded_List_Substitution(Machine(elevador),ajustar_peso)==(delta: INTEGER & direcao = parado & peso+delta: NATURAL | peso,limite_peso_atingido:=peso+delta,bool(peso+delta>peso_maximo));
  List_Substitution(Machine(elevador),atualizar_peso)==(peso:=novo_peso || limite_peso_atingido:=bool(novo_peso>peso_maximo));
  Expanded_List_Substitution(Machine(elevador),atualizar_peso)==(novo_peso: NATURAL & direcao = parado | peso,limite_peso_atingido:=novo_peso,bool(novo_peso>peso_maximo));
  List_Substitution(Machine(elevador),remover_chave_manutencao)==(chave_manutencao:=FALSE || manutencao:=FALSE || manutencao_pendente:=FALSE || parada_pendente:=parada_por_cancelamento);
  Expanded_List_Substitution(Machine(elevador),remover_chave_manutencao)==(chave_manutencao = TRUE & (manutencao = TRUE & direcao = parado or manutencao_pendente = TRUE) | chave_manutencao,manutencao,manutencao_pendente,parada_pendente:=FALSE,FALSE,FALSE,parada_por_cancelamento);
  List_Substitution(Machine(elevador),sugerir_pedido_qualquer)==(ANY aa WHERE aa: pedidos_internos\/pedidos_subida\/pedidos_descida THEN alvo:=aa END);
  Expanded_List_Substitution(Machine(elevador),sugerir_pedido_qualquer)==(pedidos_internos\/pedidos_subida\/pedidos_descida/={} | @aa.(aa: pedidos_internos\/pedidos_subida\/pedidos_descida ==> alvo:=aa));
  List_Substitution(Machine(elevador),consultar_extremos_historico)==(primeira:=first(historico_paradas) || ultima:=last(historico_paradas));
  Expanded_List_Substitution(Machine(elevador),consultar_extremos_historico)==(historico_paradas/=<> | primeira,ultima:=first(historico_paradas),last(historico_paradas));
  List_Substitution(Machine(elevador),consultar_historico_paradas)==(historico:=historico_paradas || quantidade:=size(historico_paradas));
  Expanded_List_Substitution(Machine(elevador),consultar_historico_paradas)==(btrue | historico,quantidade:=historico_paradas,size(historico_paradas));
  List_Substitution(Machine(elevador),consultar_botoes_com_tempo)==(IF tt = -1 THEN internos_com_tempo:=(0..andar_maximo)-(segurando_interno\/interno_recusado) || subida_com_tempo:=(0..andar_maximo-1)-segurando_subida || descida_com_tempo:=(1..andar_maximo)-segurando_descida ELSIF tt = 0 THEN internos_com_tempo:=segurando_interno-segurando_interno_1 || subida_com_tempo:=segurando_subida-segurando_subida_1 || descida_com_tempo:=segurando_descida-segurando_descida_1 ELSIF tt = 1 THEN internos_com_tempo:=segurando_interno_1-segurando_interno_2 || subida_com_tempo:=segurando_subida_1-segurando_subida_2 || descida_com_tempo:=segurando_descida_1-segurando_descida_2 ELSIF tt = 2 THEN internos_com_tempo:=segurando_interno_2 || subida_com_tempo:=segurando_subida_2 || descida_com_tempo:=segurando_descida_2 ELSE internos_com_tempo:=interno_recusado || subida_com_tempo:={} || descida_com_tempo:={} END);
  Expanded_List_Substitution(Machine(elevador),consultar_botoes_com_tempo)==(tt: -1..3 | tt = -1 ==> internos_com_tempo,subida_com_tempo,descida_com_tempo:=(0..andar_maximo)-(segurando_interno\/interno_recusado),(0..andar_maximo-1)-segurando_subida,(1..andar_maximo)-segurando_descida [] not(tt = -1) ==> (tt = 0 ==> internos_com_tempo,subida_com_tempo,descida_com_tempo:=segurando_interno-segurando_interno_1,segurando_subida-segurando_subida_1,segurando_descida-segurando_descida_1 [] not(tt = 0) ==> (tt = 1 ==> internos_com_tempo,subida_com_tempo,descida_com_tempo:=segurando_interno_1-segurando_interno_2,segurando_subida_1-segurando_subida_2,segurando_descida_1-segurando_descida_2 [] not(tt = 1) ==> (tt = 2 ==> internos_com_tempo,subida_com_tempo,descida_com_tempo:=segurando_interno_2,segurando_subida_2,segurando_descida_2 [] not(tt = 2) ==> internos_com_tempo,subida_com_tempo,descida_com_tempo:=interno_recusado,{},{}))));
  List_Substitution(Machine(elevador),consultar_botoes_pressionados)==(botoes_internos:=segurando_interno\/interno_recusado || botoes_subida:=segurando_subida || botoes_descida:=segurando_descida);
  Expanded_List_Substitution(Machine(elevador),consultar_botoes_pressionados)==(btrue | botoes_internos,botoes_subida,botoes_descida:=segurando_interno\/interno_recusado,segurando_subida,segurando_descida);
  List_Substitution(Machine(elevador),consultar_piscadas)==(internos_fase1:=piscando_interno1 || internos_fase2:=piscando_interno2 || subida_fase1:=piscando_subida1 || subida_fase2:=piscando_subida2 || descida_fase1:=piscando_descida1 || descida_fase2:=piscando_descida2);
  Expanded_List_Substitution(Machine(elevador),consultar_piscadas)==(btrue | internos_fase1,internos_fase2,subida_fase1,subida_fase2,descida_fase1,descida_fase2:=piscando_interno1,piscando_interno2,piscando_subida1,piscando_subida2,piscando_descida1,piscando_descida2);
  List_Substitution(Machine(elevador),consultar_leds)==(leds_internos:=pedidos_internos-(piscando_interno1\/piscando_interno2\/piscando_interno3\/piscando_interno4)\/piscando_interno1\/piscando_interno3 || leds_subida:=pedidos_subida-(piscando_subida1\/piscando_subida2\/piscando_subida3\/piscando_subida4)\/piscando_subida1\/piscando_subida3 || leds_descida:=pedidos_descida-(piscando_descida1\/piscando_descida2\/piscando_descida3\/piscando_descida4)\/piscando_descida1\/piscando_descida3);
  Expanded_List_Substitution(Machine(elevador),consultar_leds)==(btrue | leds_internos,leds_subida,leds_descida:=pedidos_internos-(piscando_interno1\/piscando_interno2\/piscando_interno3\/piscando_interno4)\/piscando_interno1\/piscando_interno3,pedidos_subida-(piscando_subida1\/piscando_subida2\/piscando_subida3\/piscando_subida4)\/piscando_subida1\/piscando_subida3,pedidos_descida-(piscando_descida1\/piscando_descida2\/piscando_descida3\/piscando_descida4)\/piscando_descida1\/piscando_descida3);
  List_Substitution(Machine(elevador),liberar_descida)==(segurando_descida:=segurando_descida-{alvo} || segurando_descida_1:=segurando_descida_1-{alvo} || segurando_descida_2:=segurando_descida_2-{alvo});
  Expanded_List_Substitution(Machine(elevador),liberar_descida)==(alvo: 1..andar_maximo | segurando_descida,segurando_descida_1,segurando_descida_2:=segurando_descida-{alvo},segurando_descida_1-{alvo},segurando_descida_2-{alvo});
  List_Substitution(Machine(elevador),liberar_subida)==(segurando_subida:=segurando_subida-{alvo} || segurando_subida_1:=segurando_subida_1-{alvo} || segurando_subida_2:=segurando_subida_2-{alvo});
  Expanded_List_Substitution(Machine(elevador),liberar_subida)==(alvo: 0..andar_maximo-1 | segurando_subida,segurando_subida_1,segurando_subida_2:=segurando_subida-{alvo},segurando_subida_1-{alvo},segurando_subida_2-{alvo});
  List_Substitution(Machine(elevador),liberar_interno)==(segurando_interno:=segurando_interno-{alvo} || segurando_interno_1:=segurando_interno_1-{alvo} || segurando_interno_2:=segurando_interno_2-{alvo} || interno_recusado:=interno_recusado-{alvo});
  Expanded_List_Substitution(Machine(elevador),liberar_interno)==(alvo: 0..andar_maximo | segurando_interno,segurando_interno_1,segurando_interno_2,interno_recusado:=segurando_interno-{alvo},segurando_interno_1-{alvo},segurando_interno_2-{alvo},interno_recusado-{alvo});
  List_Substitution(Machine(elevador),passar_tempo)==(IF manutencao = TRUE THEN avancar_piscadas_manutencao || avancar_tempo_porta(FALSE) ELSE avancar_tempo_botoes || IF direcao/=parado & pedidos_internos = {} & pedidos_subida = segurando_subida_2 & pedidos_descida = segurando_descida_2 & pedidos_subida\/pedidos_descida/={} THEN avancar_tempo_porta(TRUE) ELSE avancar_tempo_porta(FALSE) END END || piscando_abrir:=max({0,piscando_abrir-1}) || piscando_fechar:=max({0,piscando_fechar-1}));
  List_Substitution(Machine(elevador),inserir_chave)==(inserir_chave_manutencao || IF direcao = parado THEN cancelar_todos END);
  List_Substitution(Machine(elevador),pressionar_interno)==(SELECT manutencao = TRUE THEN piscar_interno(alvo) WHEN manutencao = FALSE THEN registrar_interno(alvo) END);
  List_Substitution(Machine(elevador),pressionar_externo_subida)==(SELECT manutencao = TRUE THEN piscar_subida(alvo) WHEN manutencao = FALSE THEN registrar_externo_subida(alvo) END);
  List_Substitution(Machine(elevador),pressionar_externo_descida)==(SELECT manutencao = TRUE THEN piscar_descida(alvo) WHEN manutencao = FALSE THEN registrar_externo_descida(alvo) END);
  List_Substitution(Machine(elevador),pressionar_abrir)==(SELECT manutencao = TRUE THEN piscando_abrir:=4 WHEN manutencao = FALSE & direcao = parado & porta = fechada THEN abrir_porta(pedidos_internos,pedidos_subida,pedidos_descida) || IF andar: pedidos_internos or (andar: pedidos_subida & sentido_atendimento/=descendo) or (andar: pedidos_descida & sentido_atendimento/=subindo) THEN atender_pedidos_andar(andar,sentido_atendimento) END ELSE skip END);
  List_Substitution(Machine(elevador),pressionar_fechar)==(SELECT manutencao = TRUE THEN piscando_fechar:=4 WHEN manutencao = FALSE & direcao = parado & porta = aberta & porta_retida = FALSE THEN fechar_porta ELSE skip END);
  List_Substitution(Machine(elevador),passo)==(IF direcao = subindo THEN subir(pedidos_internos,pedidos_subida,pedidos_descida) || IF manutencao_pendente = TRUE THEN cancelar_todos END ELSIF direcao = descendo THEN descer(pedidos_internos,pedidos_subida,pedidos_descida) || IF manutencao_pendente = TRUE THEN cancelar_todos END ELSIF porta = aberta & (andar: pedidos_internos or (andar: pedidos_subida & sentido_atendimento/=descendo) or (andar: pedidos_descida & sentido_atendimento/=subindo)) THEN manter_porta(pedidos_internos,pedidos_subida,pedidos_descida) || atender_pedidos_andar(andar,sentido_atendimento) ELSIF porta = aberta THEN IF porta_retida = FALSE THEN fechar_porta END ELSIF pedidos_internos\/pedidos_subida\/pedidos_descida = {} THEN entrar_em_reposo(pedidos_internos,pedidos_subida,pedidos_descida) ELSIF andar: pedidos_internos or (andar: pedidos_subida & sentido_atendimento/=descendo) or (andar: pedidos_descida & sentido_atendimento/=subindo) THEN abrir_porta(pedidos_internos,pedidos_subida,pedidos_descida) || atender_pedidos_andar(andar,sentido_atendimento) ELSIF limite_peso_atingido = TRUE THEN skip ELSIF sentido_atendimento = subindo & pedidos_internos\/pedidos_subida\/pedidos_descida/\andar+1..andar_maximo = {} or (sentido_atendimento = descendo & pedidos_internos\/pedidos_subida\/pedidos_descida/\0..andar-1 = {}) THEN inverter_sentido ELSIF sentido_atendimento = subindo THEN iniciar_subida ELSIF sentido_atendimento = descendo THEN iniciar_descida ELSIF andar = andar_maximo THEN iniciar_descida ELSIF andar = 0 THEN iniciar_subida ELSIF pedidos_internos\/pedidos_subida\/pedidos_descida/\0..andar-1 = {} THEN iniciar_subida ELSIF pedidos_internos\/pedidos_subida\/pedidos_descida/\andar+1..andar_maximo = {} THEN iniciar_descida ELSE IF min(pedidos_internos\/pedidos_subida\/pedidos_descida/\andar+1..andar_maximo\/{andar_maximo})-andar<=andar-max(pedidos_internos\/pedidos_subida\/pedidos_descida/\0..andar-1\/{0}) THEN iniciar_subida ELSE iniciar_descida END END);
  List_Substitution(Machine(elevador),consultar_leds_porta)==(led_abrir:=bool(piscando_abrir = 4 or piscando_abrir = 2) || led_fechar:=bool(piscando_fechar = 4 or piscando_fechar = 2));
  List_Substitution(Machine(elevador),consultar_visores)==(pavimento_exibido:=andar || direcao_exibida:=direcao || aviso_manutencao_interno:=manutencao || aviso_manutencao_externo:=manutencao || aviso_sobrecarga_interno:=limite_peso_atingido || aviso_porta_externo:=bool(segundos_porta_aberta>120));
  List_Substitution(Machine(elevador),consultar_piscadas_porta)==(pisca_abrir:=piscando_abrir || pisca_fechar:=piscando_fechar)
END
&
THEORY ListConstantsX IS
  List_Valuable_Constants(Machine(elevador))==(?);
  Inherited_List_Constants(Machine(elevador))==(?);
  List_Constants(Machine(elevador))==(?)
END
&
THEORY ListSetsX IS
  Set_Definition(Machine(elevador),PORTAS)==({aberta,fechada});
  Context_List_Enumerated(Machine(elevador))==(DIRECOES,PORTAS);
  Context_List_Defered(Machine(elevador))==(?);
  Context_List_Sets(Machine(elevador))==(DIRECOES,PORTAS);
  List_Valuable_Sets(Machine(elevador))==(?);
  Inherited_List_Enumerated(Machine(elevador))==(?);
  Inherited_List_Defered(Machine(elevador))==(?);
  Inherited_List_Sets(Machine(elevador))==(?);
  List_Enumerated(Machine(elevador))==(?);
  List_Defered(Machine(elevador))==(?);
  List_Sets(Machine(elevador))==(?);
  Set_Definition(Machine(elevador),DIRECOES)==({subindo,descendo,parado})
END
&
THEORY ListHiddenConstantsX IS
  Abstract_List_HiddenConstants(Machine(elevador))==(?);
  Expanded_List_HiddenConstants(Machine(elevador))==(?);
  List_HiddenConstants(Machine(elevador))==(?);
  External_List_HiddenConstants(Machine(elevador))==(?)
END
&
THEORY ListPropertiesX IS
  Abstract_List_Properties(Machine(elevador))==(btrue);
  Context_List_Properties(Machine(elevador))==(peso_maximo = 450 & andar_maximo: NATURAL & andar_maximo>0 & painel_externo: 0..andar_maximo <-> DIRECOES & painel_externo = (0..andar_maximo-1)*{subindo}\/(1..andar_maximo)*{descendo} & DIRECOES: FIN(INTEGER) & not(DIRECOES = {}) & PORTAS: FIN(INTEGER) & not(PORTAS = {}));
  Inherited_List_Properties(Machine(elevador))==(btrue);
  List_Properties(Machine(elevador))==(btrue)
END
&
THEORY ListSeenInfoX IS
  Seen_Internal_List_Operations(Machine(elevador),Machine(configuracao))==(?);
  Seen_Context_List_Enumerated(Machine(elevador))==(?);
  Seen_Context_List_Invariant(Machine(elevador))==(btrue);
  Seen_Context_List_Assertions(Machine(elevador))==(btrue);
  Seen_Context_List_Properties(Machine(elevador))==(btrue);
  Seen_List_Constraints(Machine(elevador))==(btrue);
  Seen_List_Operations(Machine(elevador),Machine(configuracao))==(?);
  Seen_Expanded_List_Invariant(Machine(elevador),Machine(configuracao))==(btrue)
END
&
THEORY ListANYVarX IS
  List_ANY_Var(Machine(elevador),consultar_visitas)==(?);
  List_ANY_Var(Machine(elevador),consultar_manutencao)==(?);
  List_ANY_Var(Machine(elevador),consultar_porta)==(?);
  List_ANY_Var(Machine(elevador),consultar_folga)==(?);
  List_ANY_Var(Machine(elevador),consultar_peso)==(?);
  List_ANY_Var(Machine(elevador),consultar_deslocamento)==(?);
  List_ANY_Var(Machine(elevador),consultar_estado)==(?);
  List_ANY_Var(Machine(elevador),consultar_parada_pendente)==(?);
  List_ANY_Var(Machine(elevador),liberar_porta)==(?);
  List_ANY_Var(Machine(elevador),segurar_porta)==(?);
  List_ANY_Var(Machine(elevador),ajustar_peso)==(?);
  List_ANY_Var(Machine(elevador),atualizar_peso)==(?);
  List_ANY_Var(Machine(elevador),remover_chave_manutencao)==(?);
  List_ANY_Var(Machine(elevador),sugerir_pedido_qualquer)==(Var(aa) == btype(INTEGER,?,?));
  List_ANY_Var(Machine(elevador),consultar_extremos_historico)==(?);
  List_ANY_Var(Machine(elevador),consultar_historico_paradas)==(?);
  List_ANY_Var(Machine(elevador),consultar_botoes_com_tempo)==(?);
  List_ANY_Var(Machine(elevador),consultar_botoes_pressionados)==(?);
  List_ANY_Var(Machine(elevador),consultar_piscadas)==(?);
  List_ANY_Var(Machine(elevador),consultar_leds)==(?);
  List_ANY_Var(Machine(elevador),liberar_descida)==(?);
  List_ANY_Var(Machine(elevador),liberar_subida)==(?);
  List_ANY_Var(Machine(elevador),liberar_interno)==(?);
  List_ANY_Var(Machine(elevador),passar_tempo)==(?);
  List_ANY_Var(Machine(elevador),inserir_chave)==(?);
  List_ANY_Var(Machine(elevador),pressionar_interno)==(?);
  List_ANY_Var(Machine(elevador),pressionar_externo_subida)==(?);
  List_ANY_Var(Machine(elevador),pressionar_externo_descida)==(?);
  List_ANY_Var(Machine(elevador),pressionar_abrir)==(?);
  List_ANY_Var(Machine(elevador),pressionar_fechar)==(?);
  List_ANY_Var(Machine(elevador),passo)==(?);
  List_ANY_Var(Machine(elevador),consultar_leds_porta)==(?);
  List_ANY_Var(Machine(elevador),consultar_visores)==(?);
  List_ANY_Var(Machine(elevador),consultar_piscadas_porta)==(?)
END
&
THEORY ListOfIdsX IS
  List_Of_Ids(Machine(elevador)) == (? | ? | piscando_fechar,piscando_abrir | V,manutencao_pendente,manutencao,chave_manutencao,ultima_visita,segundos_porta_aberta,limite_peso_atingido,peso,parada_por_cancelamento,parada_pendente,sentido_atendimento,porta_retida,porta,deslocamento,direcao,andar,historico_paradas,segurando_descida_2,segurando_descida_1,segurando_descida,segurando_subida_2,segurando_subida_1,segurando_subida,interno_recusado,segurando_interno_2,segurando_interno_1,segurando_interno,piscando_descida4,piscando_descida3,piscando_descida2,piscando_subida4,piscando_subida3,piscando_subida2,piscando_interno4,piscando_interno3,piscando_interno2,piscando_descida1,piscando_subida1,piscando_interno1,pedidos_descida,pedidos_subida,pedidos_internos | passar_tempo,inserir_chave,pressionar_interno,pressionar_externo_subida,pressionar_externo_descida,pressionar_abrir,pressionar_fechar,passo,consultar_leds_porta,consultar_visores,consultar_piscadas_porta | segurar_porta,liberar_porta,liberar_interno,liberar_subida,liberar_descida,atualizar_peso,ajustar_peso,consultar_peso,consultar_folga,consultar_estado,consultar_deslocamento,consultar_visitas,consultar_porta,consultar_manutencao,consultar_parada_pendente,consultar_leds,consultar_piscadas,consultar_botoes_pressionados,consultar_botoes_com_tempo,consultar_historico_paradas,consultar_extremos_historico,sugerir_pedido_qualquer,remover_chave_manutencao | seen(Machine(configuracao)),included(Machine(painel_pedidos)),included(Machine(cabine_movimento)) | ? | elevador);
  List_Of_HiddenCst_Ids(Machine(elevador)) == (? | ?);
  List_Of_VisibleCst_Ids(Machine(elevador)) == (?);
  List_Of_VisibleVar_Ids(Machine(elevador)) == (? | ?);
  List_Of_Ids_SeenBNU(Machine(elevador)) == (seen(Machine(configuracao)): (peso_maximo,andar_maximo,painel_externo,DIRECOES,PORTAS,subindo,descendo,parado,aberta,fechada | ? | ? | ? | ? | ? | ? | ? | ?));
  List_Of_Ids(Machine(cabine_movimento)) == (? | ? | manutencao_pendente,manutencao,chave_manutencao,ultima_visita,segundos_porta_aberta,limite_peso_atingido,peso,parada_por_cancelamento,parada_pendente,sentido_atendimento,porta_retida,porta,deslocamento,direcao,andar | ? | inserir_chave_manutencao,remover_chave_manutencao,atualizar_peso,ajustar_peso,avancar_tempo_porta,segurar_porta,liberar_porta,iniciar_subida,iniciar_descida,subir,descer,inverter_sentido,abrir_porta,fechar_porta,manter_porta,entrar_em_reposo,consultar_parada_pendente,consultar_estado,consultar_deslocamento,consultar_peso,consultar_folga,consultar_porta,consultar_manutencao,consultar_visitas | ? | seen(Machine(configuracao)) | ? | cabine_movimento);
  List_Of_HiddenCst_Ids(Machine(cabine_movimento)) == (? | ?);
  List_Of_VisibleCst_Ids(Machine(cabine_movimento)) == (?);
  List_Of_VisibleVar_Ids(Machine(cabine_movimento)) == (? | ?);
  List_Of_Ids_SeenBNU(Machine(cabine_movimento)) == (?: ?);
  List_Of_Ids(Machine(configuracao)) == (peso_maximo,andar_maximo,painel_externo,DIRECOES,PORTAS,subindo,descendo,parado,aberta,fechada | ? | ? | ? | ? | ? | ? | ? | configuracao);
  List_Of_HiddenCst_Ids(Machine(configuracao)) == (? | ?);
  List_Of_VisibleCst_Ids(Machine(configuracao)) == (peso_maximo,andar_maximo,painel_externo);
  List_Of_VisibleVar_Ids(Machine(configuracao)) == (? | ?);
  List_Of_Ids_SeenBNU(Machine(configuracao)) == (?: ?);
  List_Of_Ids(Machine(painel_pedidos)) == (? | ? | historico_paradas,segurando_descida_2,segurando_descida_1,segurando_descida,segurando_subida_2,segurando_subida_1,segurando_subida,interno_recusado,segurando_interno_2,segurando_interno_1,segurando_interno,piscando_descida4,piscando_descida3,piscando_descida2,piscando_subida4,piscando_subida3,piscando_subida2,piscando_interno4,piscando_interno3,piscando_interno2,piscando_descida1,piscando_subida1,piscando_interno1,pedidos_descida,pedidos_subida,pedidos_internos | ? | registrar_interno,registrar_externo_subida,registrar_externo_descida,liberar_interno,liberar_subida,liberar_descida,avancar_tempo_botoes,avancar_piscadas_manutencao,cancelar_todos,atender_pedidos_andar,piscar_interno,piscar_subida,piscar_descida,consultar_leds,consultar_piscadas,consultar_botoes_pressionados,consultar_botoes_com_tempo,consultar_historico_paradas,consultar_extremos_historico,sugerir_pedido_qualquer | ? | seen(Machine(configuracao)) | ? | painel_pedidos);
  List_Of_HiddenCst_Ids(Machine(painel_pedidos)) == (? | ?);
  List_Of_VisibleCst_Ids(Machine(painel_pedidos)) == (?);
  List_Of_VisibleVar_Ids(Machine(painel_pedidos)) == (? | ?);
  List_Of_Ids_SeenBNU(Machine(painel_pedidos)) == (?: ?)
END
&
THEORY VariablesEnvX IS
  Variables(Machine(elevador)) == (Type(pedidos_internos) == Mvl(SetOf(btype(INTEGER,?,?)));Type(pedidos_subida) == Mvl(SetOf(btype(INTEGER,?,?)));Type(pedidos_descida) == Mvl(SetOf(btype(INTEGER,?,?)));Type(piscando_interno1) == Mvl(SetOf(btype(INTEGER,?,?)));Type(piscando_subida1) == Mvl(SetOf(btype(INTEGER,?,?)));Type(piscando_descida1) == Mvl(SetOf(btype(INTEGER,?,?)));Type(piscando_interno2) == Mvl(SetOf(btype(INTEGER,?,?)));Type(piscando_interno3) == Mvl(SetOf(btype(INTEGER,?,?)));Type(piscando_interno4) == Mvl(SetOf(btype(INTEGER,?,?)));Type(piscando_subida2) == Mvl(SetOf(btype(INTEGER,?,?)));Type(piscando_subida3) == Mvl(SetOf(btype(INTEGER,?,?)));Type(piscando_subida4) == Mvl(SetOf(btype(INTEGER,?,?)));Type(piscando_descida2) == Mvl(SetOf(btype(INTEGER,?,?)));Type(piscando_descida3) == Mvl(SetOf(btype(INTEGER,?,?)));Type(piscando_descida4) == Mvl(SetOf(btype(INTEGER,?,?)));Type(segurando_interno) == Mvl(SetOf(btype(INTEGER,?,?)));Type(segurando_interno_1) == Mvl(SetOf(btype(INTEGER,?,?)));Type(segurando_interno_2) == Mvl(SetOf(btype(INTEGER,?,?)));Type(interno_recusado) == Mvl(SetOf(btype(INTEGER,?,?)));Type(segurando_subida) == Mvl(SetOf(btype(INTEGER,?,?)));Type(segurando_subida_1) == Mvl(SetOf(btype(INTEGER,?,?)));Type(segurando_subida_2) == Mvl(SetOf(btype(INTEGER,?,?)));Type(segurando_descida) == Mvl(SetOf(btype(INTEGER,?,?)));Type(segurando_descida_1) == Mvl(SetOf(btype(INTEGER,?,?)));Type(segurando_descida_2) == Mvl(SetOf(btype(INTEGER,?,?)));Type(historico_paradas) == Mvl(SetOf(btype(INTEGER,?,?)*btype(INTEGER,?,?)));Type(andar) == Mvl(btype(INTEGER,?,?));Type(direcao) == Mvl(etype(DIRECOES,?,?));Type(deslocamento) == Mvl(btype(INTEGER,?,?));Type(porta) == Mvl(etype(PORTAS,?,?));Type(porta_retida) == Mvl(btype(BOOL,?,?));Type(sentido_atendimento) == Mvl(etype(DIRECOES,?,?));Type(parada_pendente) == Mvl(btype(BOOL,?,?));Type(parada_por_cancelamento) == Mvl(btype(BOOL,?,?));Type(peso) == Mvl(btype(INTEGER,?,?));Type(limite_peso_atingido) == Mvl(btype(BOOL,?,?));Type(segundos_porta_aberta) == Mvl(btype(INTEGER,?,?));Type(ultima_visita) == Mvl(SetOf(btype(INTEGER,?,?)*btype(INTEGER,?,?)));Type(chave_manutencao) == Mvl(btype(BOOL,?,?));Type(manutencao) == Mvl(btype(BOOL,?,?));Type(manutencao_pendente) == Mvl(btype(BOOL,?,?));Type(piscando_fechar) == Mvl(btype(INTEGER,?,?));Type(piscando_abrir) == Mvl(btype(INTEGER,?,?)))
END
&
THEORY OperationsEnvX IS
  Operations(Machine(elevador)) == (Type(segurar_porta) == Cst(No_type,No_type);Type(liberar_porta) == Cst(No_type,No_type);Type(liberar_interno) == Cst(No_type,btype(INTEGER,?,?));Type(liberar_subida) == Cst(No_type,btype(INTEGER,?,?));Type(liberar_descida) == Cst(No_type,btype(INTEGER,?,?));Type(atualizar_peso) == Cst(No_type,btype(INTEGER,?,?));Type(ajustar_peso) == Cst(No_type,btype(INTEGER,?,?));Type(consultar_peso) == Cst(btype(INTEGER,?,?)*btype(BOOL,?,?),No_type);Type(consultar_folga) == Cst(btype(INTEGER,?,?),No_type);Type(consultar_estado) == Cst(btype(INTEGER,?,?)*etype(DIRECOES,?,?),No_type);Type(consultar_deslocamento) == Cst(btype(INTEGER,?,?),No_type);Type(consultar_visitas) == Cst(SetOf(btype(INTEGER,?,?))*SetOf(btype(INTEGER,?,?))*SetOf(btype(INTEGER,?,?)),No_type);Type(consultar_porta) == Cst(etype(PORTAS,?,?)*btype(INTEGER,?,?),No_type);Type(consultar_manutencao) == Cst(btype(BOOL,?,?)*btype(BOOL,?,?)*btype(BOOL,?,?),No_type);Type(consultar_parada_pendente) == Cst(btype(BOOL,?,?),No_type);Type(consultar_leds) == Cst(SetOf(btype(INTEGER,?,?))*SetOf(btype(INTEGER,?,?))*SetOf(btype(INTEGER,?,?)),No_type);Type(consultar_piscadas) == Cst(SetOf(btype(INTEGER,?,?))*SetOf(btype(INTEGER,?,?))*SetOf(btype(INTEGER,?,?))*SetOf(btype(INTEGER,?,?))*SetOf(btype(INTEGER,?,?))*SetOf(btype(INTEGER,?,?)),No_type);Type(consultar_botoes_pressionados) == Cst(SetOf(btype(INTEGER,?,?))*SetOf(btype(INTEGER,?,?))*SetOf(btype(INTEGER,?,?)),No_type);Type(consultar_botoes_com_tempo) == Cst(SetOf(btype(INTEGER,?,?))*SetOf(btype(INTEGER,?,?))*SetOf(btype(INTEGER,?,?)),btype(INTEGER,?,?));Type(consultar_historico_paradas) == Cst(SetOf(btype(INTEGER,?,?)*btype(INTEGER,?,?))*btype(INTEGER,?,?),No_type);Type(consultar_extremos_historico) == Cst(btype(INTEGER,?,?)*btype(INTEGER,?,?),No_type);Type(sugerir_pedido_qualquer) == Cst(btype(INTEGER,?,?),No_type);Type(remover_chave_manutencao) == Cst(No_type,No_type);Type(consultar_piscadas_porta) == Cst(btype(INTEGER,?,?)*btype(INTEGER,?,?),No_type);Type(consultar_visores) == Cst(btype(INTEGER,?,?)*etype(DIRECOES,?,?)*btype(BOOL,?,?)*btype(BOOL,?,?)*btype(BOOL,?,?)*btype(BOOL,?,?),No_type);Type(consultar_leds_porta) == Cst(btype(BOOL,?,?)*btype(BOOL,?,?),No_type);Type(passo) == Cst(No_type,No_type);Type(pressionar_fechar) == Cst(No_type,No_type);Type(pressionar_abrir) == Cst(No_type,No_type);Type(pressionar_externo_descida) == Cst(No_type,btype(INTEGER,?,?));Type(pressionar_externo_subida) == Cst(No_type,btype(INTEGER,?,?));Type(pressionar_interno) == Cst(No_type,btype(INTEGER,?,?));Type(inserir_chave) == Cst(No_type,No_type);Type(passar_tempo) == Cst(No_type,No_type));
  Observers(Machine(elevador)) == (Type(consultar_peso) == Cst(btype(INTEGER,?,?)*btype(BOOL,?,?),No_type);Type(consultar_folga) == Cst(btype(INTEGER,?,?),No_type);Type(consultar_estado) == Cst(btype(INTEGER,?,?)*etype(DIRECOES,?,?),No_type);Type(consultar_deslocamento) == Cst(btype(INTEGER,?,?),No_type);Type(consultar_visitas) == Cst(SetOf(btype(INTEGER,?,?))*SetOf(btype(INTEGER,?,?))*SetOf(btype(INTEGER,?,?)),No_type);Type(consultar_porta) == Cst(etype(PORTAS,?,?)*btype(INTEGER,?,?),No_type);Type(consultar_manutencao) == Cst(btype(BOOL,?,?)*btype(BOOL,?,?)*btype(BOOL,?,?),No_type);Type(consultar_parada_pendente) == Cst(btype(BOOL,?,?),No_type);Type(consultar_leds) == Cst(SetOf(btype(INTEGER,?,?))*SetOf(btype(INTEGER,?,?))*SetOf(btype(INTEGER,?,?)),No_type);Type(consultar_piscadas) == Cst(SetOf(btype(INTEGER,?,?))*SetOf(btype(INTEGER,?,?))*SetOf(btype(INTEGER,?,?))*SetOf(btype(INTEGER,?,?))*SetOf(btype(INTEGER,?,?))*SetOf(btype(INTEGER,?,?)),No_type);Type(consultar_botoes_pressionados) == Cst(SetOf(btype(INTEGER,?,?))*SetOf(btype(INTEGER,?,?))*SetOf(btype(INTEGER,?,?)),No_type);Type(consultar_botoes_com_tempo) == Cst(SetOf(btype(INTEGER,?,?))*SetOf(btype(INTEGER,?,?))*SetOf(btype(INTEGER,?,?)),btype(INTEGER,?,?));Type(consultar_historico_paradas) == Cst(SetOf(btype(INTEGER,?,?)*btype(INTEGER,?,?))*btype(INTEGER,?,?),No_type);Type(consultar_extremos_historico) == Cst(btype(INTEGER,?,?)*btype(INTEGER,?,?),No_type);Type(sugerir_pedido_qualquer) == Cst(btype(INTEGER,?,?),No_type);Type(consultar_piscadas_porta) == Cst(btype(INTEGER,?,?)*btype(INTEGER,?,?),No_type);Type(consultar_visores) == Cst(btype(INTEGER,?,?)*etype(DIRECOES,?,?)*btype(BOOL,?,?)*btype(BOOL,?,?)*btype(BOOL,?,?)*btype(BOOL,?,?),No_type);Type(consultar_leds_porta) == Cst(btype(BOOL,?,?)*btype(BOOL,?,?),No_type))
END
&
THEORY TCIntRdX IS
  predB0 == OK;
  extended_sees == KO;
  B0check_tab == KO;
  local_op == OK;
  abstract_constants_visible_in_values == KO;
  project_type == SOFTWARE_TYPE;
  event_b_deadlockfreeness == KO;
  variant_clause_mandatory == KO;
  event_b_coverage == KO;
  event_b_exclusivity == KO;
  genFeasibilityPO == KO
END
)
