Normalised(
THEORY MagicNumberX IS
  MagicNumber(Machine(painel_pedidos))==(3.5)
END
&
THEORY UpperLevelX IS
  First_Level(Machine(painel_pedidos))==(Machine(painel_pedidos));
  Level(Machine(painel_pedidos))==(0)
END
&
THEORY LoadedStructureX IS
  Machine(painel_pedidos)
END
&
THEORY ListSeesX IS
  List_Sees(Machine(painel_pedidos))==(configuracao)
END
&
THEORY ListUsesX IS
  List_Uses(Machine(painel_pedidos))==(?)
END
&
THEORY ListIncludesX IS
  Inherited_List_Includes(Machine(painel_pedidos))==(?);
  List_Includes(Machine(painel_pedidos))==(?)
END
&
THEORY ListPromotesX IS
  List_Promotes(Machine(painel_pedidos))==(?)
END
&
THEORY ListExtendsX IS
  List_Extends(Machine(painel_pedidos))==(?)
END
&
THEORY ListVariablesX IS
  External_Context_List_Variables(Machine(painel_pedidos))==(?);
  Context_List_Variables(Machine(painel_pedidos))==(?);
  Abstract_List_Variables(Machine(painel_pedidos))==(?);
  Local_List_Variables(Machine(painel_pedidos))==(historico_paradas,segurando_descida_2,segurando_descida_1,segurando_descida,segurando_subida_2,segurando_subida_1,segurando_subida,interno_recusado,segurando_interno_2,segurando_interno_1,segurando_interno,piscando_descida4,piscando_descida3,piscando_descida2,piscando_subida4,piscando_subida3,piscando_subida2,piscando_interno4,piscando_interno3,piscando_interno2,piscando_descida1,piscando_subida1,piscando_interno1,pedidos_descida,pedidos_subida,pedidos_internos);
  List_Variables(Machine(painel_pedidos))==(historico_paradas,segurando_descida_2,segurando_descida_1,segurando_descida,segurando_subida_2,segurando_subida_1,segurando_subida,interno_recusado,segurando_interno_2,segurando_interno_1,segurando_interno,piscando_descida4,piscando_descida3,piscando_descida2,piscando_subida4,piscando_subida3,piscando_subida2,piscando_interno4,piscando_interno3,piscando_interno2,piscando_descida1,piscando_subida1,piscando_interno1,pedidos_descida,pedidos_subida,pedidos_internos);
  External_List_Variables(Machine(painel_pedidos))==(historico_paradas,segurando_descida_2,segurando_descida_1,segurando_descida,segurando_subida_2,segurando_subida_1,segurando_subida,interno_recusado,segurando_interno_2,segurando_interno_1,segurando_interno,piscando_descida4,piscando_descida3,piscando_descida2,piscando_subida4,piscando_subida3,piscando_subida2,piscando_interno4,piscando_interno3,piscando_interno2,piscando_descida1,piscando_subida1,piscando_interno1,pedidos_descida,pedidos_subida,pedidos_internos)
END
&
THEORY ListVisibleVariablesX IS
  Inherited_List_VisibleVariables(Machine(painel_pedidos))==(?);
  Abstract_List_VisibleVariables(Machine(painel_pedidos))==(?);
  External_List_VisibleVariables(Machine(painel_pedidos))==(?);
  Expanded_List_VisibleVariables(Machine(painel_pedidos))==(?);
  List_VisibleVariables(Machine(painel_pedidos))==(?);
  Internal_List_VisibleVariables(Machine(painel_pedidos))==(?)
END
&
THEORY ListInvariantX IS
  Gluing_Seen_List_Invariant(Machine(painel_pedidos))==(btrue);
  Gluing_List_Invariant(Machine(painel_pedidos))==(btrue);
  Expanded_List_Invariant(Machine(painel_pedidos))==(btrue);
  Abstract_List_Invariant(Machine(painel_pedidos))==(btrue);
  Context_List_Invariant(Machine(painel_pedidos))==(btrue);
  List_Invariant(Machine(painel_pedidos))==(pedidos_internos <: 0..andar_maximo & pedidos_subida <: 0..andar_maximo-1 & pedidos_descida <: 1..andar_maximo & piscando_interno1 <: 0..andar_maximo & piscando_subida1 <: 0..andar_maximo-1 & piscando_descida1 <: 1..andar_maximo & piscando_interno2 <: 0..andar_maximo & piscando_interno3 <: 0..andar_maximo & piscando_interno4 <: 0..andar_maximo & piscando_subida2 <: 0..andar_maximo-1 & piscando_subida3 <: 0..andar_maximo-1 & piscando_subida4 <: 0..andar_maximo-1 & piscando_descida2 <: 1..andar_maximo & piscando_descida3 <: 1..andar_maximo & piscando_descida4 <: 1..andar_maximo & historico_paradas: seq(0..andar_maximo) & size(historico_paradas)<=5 & segurando_interno: POW(0..andar_maximo) & segurando_interno_1: POW(0..andar_maximo) & segurando_interno_2: POW(0..andar_maximo) & interno_recusado: POW(0..andar_maximo) & segurando_subida: POW(0..andar_maximo-1) & segurando_subida_1: POW(0..andar_maximo-1) & segurando_subida_2: POW(0..andar_maximo-1) & segurando_descida: POW(1..andar_maximo) & segurando_descida_1: POW(1..andar_maximo) & segurando_descida_2: POW(1..andar_maximo) & segurando_interno_2 <: segurando_interno_1 & segurando_interno_1 <: segurando_interno & segurando_interno <: pedidos_internos & interno_recusado <: pedidos_internos & segurando_interno/\interno_recusado = {} & segurando_subida_2 <: segurando_subida_1 & segurando_subida_1 <: segurando_subida & segurando_subida <: pedidos_subida & segurando_descida_2 <: segurando_descida_1 & segurando_descida_1 <: segurando_descida & segurando_descida <: pedidos_descida & !aa.(aa: pedidos_subida => aa|->subindo: painel_externo) & !aa.(aa: pedidos_descida => aa|->descendo: painel_externo))
END
&
THEORY ListAssertionsX IS
  Expanded_List_Assertions(Machine(painel_pedidos))==(btrue);
  Abstract_List_Assertions(Machine(painel_pedidos))==(btrue);
  Context_List_Assertions(Machine(painel_pedidos))==(btrue);
  List_Assertions(Machine(painel_pedidos))==(btrue)
END
&
THEORY ListCoverageX IS
  List_Coverage(Machine(painel_pedidos))==(btrue)
END
&
THEORY ListExclusivityX IS
  List_Exclusivity(Machine(painel_pedidos))==(btrue)
END
&
THEORY ListInitialisationX IS
  Expanded_List_Initialisation(Machine(painel_pedidos))==(pedidos_internos,pedidos_subida,pedidos_descida,piscando_interno1,piscando_subida1,piscando_descida1,piscando_interno2,piscando_interno3,piscando_interno4,piscando_subida2,piscando_subida3,piscando_subida4,piscando_descida2,piscando_descida3,piscando_descida4,segurando_interno,segurando_interno_1,segurando_interno_2,interno_recusado,segurando_subida,segurando_subida_1,segurando_subida_2,segurando_descida,segurando_descida_1,segurando_descida_2,historico_paradas:={},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},<>);
  Context_List_Initialisation(Machine(painel_pedidos))==(skip);
  List_Initialisation(Machine(painel_pedidos))==(pedidos_internos:={} || pedidos_subida:={} || pedidos_descida:={} || piscando_interno1:={} || piscando_subida1:={} || piscando_descida1:={} || piscando_interno2:={} || piscando_interno3:={} || piscando_interno4:={} || piscando_subida2:={} || piscando_subida3:={} || piscando_subida4:={} || piscando_descida2:={} || piscando_descida3:={} || piscando_descida4:={} || segurando_interno:={} || segurando_interno_1:={} || segurando_interno_2:={} || interno_recusado:={} || segurando_subida:={} || segurando_subida_1:={} || segurando_subida_2:={} || segurando_descida:={} || segurando_descida_1:={} || segurando_descida_2:={} || historico_paradas:=<>)
END
&
THEORY ListParametersX IS
  List_Parameters(Machine(painel_pedidos))==(?)
END
&
THEORY ListInstanciatedParametersX IS
  List_Instanciated_Parameters(Machine(painel_pedidos),Machine(configuracao))==(?)
END
&
THEORY ListConstraintsX IS
  List_Context_Constraints(Machine(painel_pedidos))==(btrue);
  List_Constraints(Machine(painel_pedidos))==(btrue)
END
&
THEORY ListOperationsX IS
  Internal_List_Operations(Machine(painel_pedidos))==(registrar_interno,registrar_externo_subida,registrar_externo_descida,liberar_interno,liberar_subida,liberar_descida,avancar_tempo_botoes,avancar_piscadas_manutencao,cancelar_todos,atender_pedidos_andar,piscar_interno,piscar_subida,piscar_descida,consultar_leds,consultar_piscadas,consultar_botoes_pressionados,consultar_botoes_com_tempo,consultar_historico_paradas,consultar_extremos_historico,sugerir_pedido_qualquer);
  List_Operations(Machine(painel_pedidos))==(registrar_interno,registrar_externo_subida,registrar_externo_descida,liberar_interno,liberar_subida,liberar_descida,avancar_tempo_botoes,avancar_piscadas_manutencao,cancelar_todos,atender_pedidos_andar,piscar_interno,piscar_subida,piscar_descida,consultar_leds,consultar_piscadas,consultar_botoes_pressionados,consultar_botoes_com_tempo,consultar_historico_paradas,consultar_extremos_historico,sugerir_pedido_qualquer)
END
&
THEORY ListInputX IS
  List_Input(Machine(painel_pedidos),registrar_interno)==(alvo);
  List_Input(Machine(painel_pedidos),registrar_externo_subida)==(alvo);
  List_Input(Machine(painel_pedidos),registrar_externo_descida)==(alvo);
  List_Input(Machine(painel_pedidos),liberar_interno)==(alvo);
  List_Input(Machine(painel_pedidos),liberar_subida)==(alvo);
  List_Input(Machine(painel_pedidos),liberar_descida)==(alvo);
  List_Input(Machine(painel_pedidos),avancar_tempo_botoes)==(?);
  List_Input(Machine(painel_pedidos),avancar_piscadas_manutencao)==(?);
  List_Input(Machine(painel_pedidos),cancelar_todos)==(?);
  List_Input(Machine(painel_pedidos),atender_pedidos_andar)==(alvo,sentido);
  List_Input(Machine(painel_pedidos),piscar_interno)==(alvo);
  List_Input(Machine(painel_pedidos),piscar_subida)==(alvo);
  List_Input(Machine(painel_pedidos),piscar_descida)==(alvo);
  List_Input(Machine(painel_pedidos),consultar_leds)==(?);
  List_Input(Machine(painel_pedidos),consultar_piscadas)==(?);
  List_Input(Machine(painel_pedidos),consultar_botoes_pressionados)==(?);
  List_Input(Machine(painel_pedidos),consultar_botoes_com_tempo)==(tt);
  List_Input(Machine(painel_pedidos),consultar_historico_paradas)==(?);
  List_Input(Machine(painel_pedidos),consultar_extremos_historico)==(?);
  List_Input(Machine(painel_pedidos),sugerir_pedido_qualquer)==(?)
END
&
THEORY ListOutputX IS
  List_Output(Machine(painel_pedidos),registrar_interno)==(?);
  List_Output(Machine(painel_pedidos),registrar_externo_subida)==(?);
  List_Output(Machine(painel_pedidos),registrar_externo_descida)==(?);
  List_Output(Machine(painel_pedidos),liberar_interno)==(?);
  List_Output(Machine(painel_pedidos),liberar_subida)==(?);
  List_Output(Machine(painel_pedidos),liberar_descida)==(?);
  List_Output(Machine(painel_pedidos),avancar_tempo_botoes)==(?);
  List_Output(Machine(painel_pedidos),avancar_piscadas_manutencao)==(?);
  List_Output(Machine(painel_pedidos),cancelar_todos)==(?);
  List_Output(Machine(painel_pedidos),atender_pedidos_andar)==(?);
  List_Output(Machine(painel_pedidos),piscar_interno)==(?);
  List_Output(Machine(painel_pedidos),piscar_subida)==(?);
  List_Output(Machine(painel_pedidos),piscar_descida)==(?);
  List_Output(Machine(painel_pedidos),consultar_leds)==(leds_internos,leds_subida,leds_descida);
  List_Output(Machine(painel_pedidos),consultar_piscadas)==(internos_fase1,internos_fase2,subida_fase1,subida_fase2,descida_fase1,descida_fase2);
  List_Output(Machine(painel_pedidos),consultar_botoes_pressionados)==(botoes_internos,botoes_subida,botoes_descida);
  List_Output(Machine(painel_pedidos),consultar_botoes_com_tempo)==(internos_com_tempo,subida_com_tempo,descida_com_tempo);
  List_Output(Machine(painel_pedidos),consultar_historico_paradas)==(historico,quantidade);
  List_Output(Machine(painel_pedidos),consultar_extremos_historico)==(primeira,ultima);
  List_Output(Machine(painel_pedidos),sugerir_pedido_qualquer)==(alvo)
END
&
THEORY ListHeaderX IS
  List_Header(Machine(painel_pedidos),registrar_interno)==(registrar_interno(alvo));
  List_Header(Machine(painel_pedidos),registrar_externo_subida)==(registrar_externo_subida(alvo));
  List_Header(Machine(painel_pedidos),registrar_externo_descida)==(registrar_externo_descida(alvo));
  List_Header(Machine(painel_pedidos),liberar_interno)==(liberar_interno(alvo));
  List_Header(Machine(painel_pedidos),liberar_subida)==(liberar_subida(alvo));
  List_Header(Machine(painel_pedidos),liberar_descida)==(liberar_descida(alvo));
  List_Header(Machine(painel_pedidos),avancar_tempo_botoes)==(avancar_tempo_botoes);
  List_Header(Machine(painel_pedidos),avancar_piscadas_manutencao)==(avancar_piscadas_manutencao);
  List_Header(Machine(painel_pedidos),cancelar_todos)==(cancelar_todos);
  List_Header(Machine(painel_pedidos),atender_pedidos_andar)==(atender_pedidos_andar(alvo,sentido));
  List_Header(Machine(painel_pedidos),piscar_interno)==(piscar_interno(alvo));
  List_Header(Machine(painel_pedidos),piscar_subida)==(piscar_subida(alvo));
  List_Header(Machine(painel_pedidos),piscar_descida)==(piscar_descida(alvo));
  List_Header(Machine(painel_pedidos),consultar_leds)==(leds_internos,leds_subida,leds_descida <-- consultar_leds);
  List_Header(Machine(painel_pedidos),consultar_piscadas)==(internos_fase1,internos_fase2,subida_fase1,subida_fase2,descida_fase1,descida_fase2 <-- consultar_piscadas);
  List_Header(Machine(painel_pedidos),consultar_botoes_pressionados)==(botoes_internos,botoes_subida,botoes_descida <-- consultar_botoes_pressionados);
  List_Header(Machine(painel_pedidos),consultar_botoes_com_tempo)==(internos_com_tempo,subida_com_tempo,descida_com_tempo <-- consultar_botoes_com_tempo(tt));
  List_Header(Machine(painel_pedidos),consultar_historico_paradas)==(historico,quantidade <-- consultar_historico_paradas);
  List_Header(Machine(painel_pedidos),consultar_extremos_historico)==(primeira,ultima <-- consultar_extremos_historico);
  List_Header(Machine(painel_pedidos),sugerir_pedido_qualquer)==(alvo <-- sugerir_pedido_qualquer)
END
&
THEORY ListOperationGuardX END
&
THEORY ListPreconditionX IS
  List_Precondition(Machine(painel_pedidos),registrar_interno)==(alvo: 0..andar_maximo);
  List_Precondition(Machine(painel_pedidos),registrar_externo_subida)==(alvo: 0..andar_maximo-1 & alvo|->subindo: painel_externo);
  List_Precondition(Machine(painel_pedidos),registrar_externo_descida)==(alvo: 1..andar_maximo & alvo|->descendo: painel_externo);
  List_Precondition(Machine(painel_pedidos),liberar_interno)==(alvo: 0..andar_maximo);
  List_Precondition(Machine(painel_pedidos),liberar_subida)==(alvo: 0..andar_maximo-1);
  List_Precondition(Machine(painel_pedidos),liberar_descida)==(alvo: 1..andar_maximo);
  List_Precondition(Machine(painel_pedidos),avancar_tempo_botoes)==(btrue);
  List_Precondition(Machine(painel_pedidos),avancar_piscadas_manutencao)==(btrue);
  List_Precondition(Machine(painel_pedidos),cancelar_todos)==(btrue);
  List_Precondition(Machine(painel_pedidos),atender_pedidos_andar)==(alvo: 0..andar_maximo & sentido: DIRECOES);
  List_Precondition(Machine(painel_pedidos),piscar_interno)==(alvo: 0..andar_maximo);
  List_Precondition(Machine(painel_pedidos),piscar_subida)==(alvo: 0..andar_maximo-1 & alvo|->subindo: painel_externo);
  List_Precondition(Machine(painel_pedidos),piscar_descida)==(alvo: 1..andar_maximo & alvo|->descendo: painel_externo);
  List_Precondition(Machine(painel_pedidos),consultar_leds)==(btrue);
  List_Precondition(Machine(painel_pedidos),consultar_piscadas)==(btrue);
  List_Precondition(Machine(painel_pedidos),consultar_botoes_pressionados)==(btrue);
  List_Precondition(Machine(painel_pedidos),consultar_botoes_com_tempo)==(tt: -1..3);
  List_Precondition(Machine(painel_pedidos),consultar_historico_paradas)==(btrue);
  List_Precondition(Machine(painel_pedidos),consultar_extremos_historico)==(historico_paradas/=<>);
  List_Precondition(Machine(painel_pedidos),sugerir_pedido_qualquer)==(pedidos_internos\/pedidos_subida\/pedidos_descida/={})
END
&
THEORY ListSubstitutionX IS
  Expanded_List_Substitution(Machine(painel_pedidos),sugerir_pedido_qualquer)==(pedidos_internos\/pedidos_subida\/pedidos_descida/={} | @aa.(aa: pedidos_internos\/pedidos_subida\/pedidos_descida ==> alvo:=aa));
  Expanded_List_Substitution(Machine(painel_pedidos),consultar_extremos_historico)==(historico_paradas/=<> | primeira,ultima:=first(historico_paradas),last(historico_paradas));
  Expanded_List_Substitution(Machine(painel_pedidos),consultar_historico_paradas)==(btrue | historico,quantidade:=historico_paradas,size(historico_paradas));
  Expanded_List_Substitution(Machine(painel_pedidos),consultar_botoes_com_tempo)==(tt: -1..3 | tt = -1 ==> internos_com_tempo,subida_com_tempo,descida_com_tempo:=(0..andar_maximo)-(segurando_interno\/interno_recusado),(0..andar_maximo-1)-segurando_subida,(1..andar_maximo)-segurando_descida [] not(tt = -1) ==> (tt = 0 ==> internos_com_tempo,subida_com_tempo,descida_com_tempo:=segurando_interno-segurando_interno_1,segurando_subida-segurando_subida_1,segurando_descida-segurando_descida_1 [] not(tt = 0) ==> (tt = 1 ==> internos_com_tempo,subida_com_tempo,descida_com_tempo:=segurando_interno_1-segurando_interno_2,segurando_subida_1-segurando_subida_2,segurando_descida_1-segurando_descida_2 [] not(tt = 1) ==> (tt = 2 ==> internos_com_tempo,subida_com_tempo,descida_com_tempo:=segurando_interno_2,segurando_subida_2,segurando_descida_2 [] not(tt = 2) ==> internos_com_tempo,subida_com_tempo,descida_com_tempo:=interno_recusado,{},{}))));
  Expanded_List_Substitution(Machine(painel_pedidos),consultar_botoes_pressionados)==(btrue | botoes_internos,botoes_subida,botoes_descida:=segurando_interno\/interno_recusado,segurando_subida,segurando_descida);
  Expanded_List_Substitution(Machine(painel_pedidos),consultar_piscadas)==(btrue | internos_fase1,internos_fase2,subida_fase1,subida_fase2,descida_fase1,descida_fase2:=piscando_interno1,piscando_interno2,piscando_subida1,piscando_subida2,piscando_descida1,piscando_descida2);
  Expanded_List_Substitution(Machine(painel_pedidos),consultar_leds)==(btrue | leds_internos,leds_subida,leds_descida:=pedidos_internos-(piscando_interno1\/piscando_interno2\/piscando_interno3\/piscando_interno4)\/piscando_interno1\/piscando_interno3,pedidos_subida-(piscando_subida1\/piscando_subida2\/piscando_subida3\/piscando_subida4)\/piscando_subida1\/piscando_subida3,pedidos_descida-(piscando_descida1\/piscando_descida2\/piscando_descida3\/piscando_descida4)\/piscando_descida1\/piscando_descida3);
  Expanded_List_Substitution(Machine(painel_pedidos),piscar_descida)==(alvo: 1..andar_maximo & alvo|->descendo: painel_externo | piscando_descida1,piscando_descida2,piscando_descida3,piscando_descida4:=piscando_descida1\/{alvo},piscando_descida2-{alvo},piscando_descida3-{alvo},piscando_descida4-{alvo});
  Expanded_List_Substitution(Machine(painel_pedidos),piscar_subida)==(alvo: 0..andar_maximo-1 & alvo|->subindo: painel_externo | piscando_subida1,piscando_subida2,piscando_subida3,piscando_subida4:=piscando_subida1\/{alvo},piscando_subida2-{alvo},piscando_subida3-{alvo},piscando_subida4-{alvo});
  Expanded_List_Substitution(Machine(painel_pedidos),piscar_interno)==(alvo: 0..andar_maximo | piscando_interno1,piscando_interno2,piscando_interno3,piscando_interno4:=piscando_interno1\/{alvo},piscando_interno2-{alvo},piscando_interno3-{alvo},piscando_interno4-{alvo});
  Expanded_List_Substitution(Machine(painel_pedidos),atender_pedidos_andar)==(alvo: 0..andar_maximo & sentido: DIRECOES | alvo: pedidos_internos ==> pedidos_internos,piscando_interno1,piscando_interno2,piscando_interno3,piscando_interno4,segurando_interno,segurando_interno_1,segurando_interno_2,interno_recusado:=pedidos_internos-{alvo},piscando_interno1-{alvo},piscando_interno2-{alvo},piscando_interno3-{alvo},piscando_interno4-{alvo},segurando_interno-{alvo},segurando_interno_1-{alvo},segurando_interno_2-{alvo},interno_recusado-{alvo} [] not(alvo: pedidos_internos) ==> skip || (sentido = subindo or sentido = parado & alvo: pedidos_subida ==> pedidos_subida,piscando_subida1,piscando_subida2,piscando_subida3,piscando_subida4,segurando_subida,segurando_subida_1,segurando_subida_2:=pedidos_subida-{alvo},piscando_subida1-{alvo},piscando_subida2-{alvo},piscando_subida3-{alvo},piscando_subida4-{alvo},segurando_subida-{alvo},segurando_subida_1-{alvo},segurando_subida_2-{alvo} [] not(sentido = subindo or sentido = parado & alvo: pedidos_subida) ==> skip) || (sentido = descendo or (sentido = parado & alvo/:pedidos_subida) & alvo: pedidos_descida ==> pedidos_descida,piscando_descida1,piscando_descida2,piscando_descida3,piscando_descida4,segurando_descida,segurando_descida_1,segurando_descida_2:=pedidos_descida-{alvo},piscando_descida1-{alvo},piscando_descida2-{alvo},piscando_descida3-{alvo},piscando_descida4-{alvo},segurando_descida-{alvo},segurando_descida_1-{alvo},segurando_descida_2-{alvo} [] not(sentido = descendo or (sentido = parado & alvo/:pedidos_subida) & alvo: pedidos_descida) ==> skip) || (size(historico_paradas)<5 ==> historico_paradas:=historico_paradas<-alvo [] not(size(historico_paradas)<5) ==> historico_paradas:=tail(historico_paradas)^[alvo]));
  Expanded_List_Substitution(Machine(painel_pedidos),cancelar_todos)==(btrue | segurando_interno,segurando_interno_1,segurando_interno_2,interno_recusado,segurando_subida,segurando_subida_1,segurando_subida_2,segurando_descida,segurando_descida_1,segurando_descida_2,pedidos_internos,pedidos_subida,pedidos_descida,piscando_interno1,piscando_interno2,piscando_interno3,piscando_interno4,piscando_subida1,piscando_subida2,piscando_subida3,piscando_subida4,piscando_descida1,piscando_descida2,piscando_descida3,piscando_descida4:={},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{});
  Expanded_List_Substitution(Machine(painel_pedidos),avancar_piscadas_manutencao)==(btrue | piscando_interno1,piscando_interno2,piscando_interno3,piscando_interno4,piscando_subida1,piscando_subida2,piscando_subida3,piscando_subida4,piscando_descida1,piscando_descida2,piscando_descida3,piscando_descida4:={},piscando_interno1,piscando_interno2,piscando_interno3,{},piscando_subida1,piscando_subida2,piscando_subida3,{},piscando_descida1,piscando_descida2,piscando_descida3);
  Expanded_List_Substitution(Machine(painel_pedidos),avancar_tempo_botoes)==(btrue | pedidos_internos/={} & pedidos_internos = segurando_interno_2 & pedidos_subida-segurando_subida_2 = {} & pedidos_descida-segurando_descida_2 = {} ==> pedidos_internos,segurando_interno,segurando_interno_1,segurando_interno_2,interno_recusado,piscando_interno1,piscando_interno2,piscando_interno3,piscando_interno4:={min(pedidos_internos)},{},{},{},{min(pedidos_internos)},{min(pedidos_internos)},piscando_interno1-{min(pedidos_internos)},piscando_interno2-{min(pedidos_internos)},piscando_interno3-{min(pedidos_internos)} [] not(pedidos_internos/={} & pedidos_internos = segurando_interno_2 & pedidos_subida-segurando_subida_2 = {} & pedidos_descida-segurando_descida_2 = {}) ==> pedidos_internos,segurando_interno,segurando_interno_1,segurando_interno_2,interno_recusado,piscando_interno1,piscando_interno2,piscando_interno3,piscando_interno4:=pedidos_internos-segurando_interno_2,segurando_interno-segurando_interno_2,segurando_interno-segurando_interno_2,segurando_interno_1-segurando_interno_2,interno_recusado-segurando_interno_2,{},piscando_interno1,piscando_interno2,piscando_interno3 || pedidos_subida:=pedidos_subida-segurando_subida_2 || segurando_subida:=segurando_subida-segurando_subida_2 || segurando_subida_1:=segurando_subida-segurando_subida_2 || segurando_subida_2:=segurando_subida_1-segurando_subida_2 || piscando_subida1:={} || piscando_subida2:=piscando_subida1 || piscando_subida3:=piscando_subida2 || piscando_subida4:=piscando_subida3 || pedidos_descida:=pedidos_descida-segurando_descida_2 || segurando_descida:=segurando_descida-segurando_descida_2 || segurando_descida_1:=segurando_descida-segurando_descida_2 || segurando_descida_2:=segurando_descida_1-segurando_descida_2 || piscando_descida1:={} || piscando_descida2:=piscando_descida1 || piscando_descida3:=piscando_descida2 || piscando_descida4:=piscando_descida3);
  Expanded_List_Substitution(Machine(painel_pedidos),liberar_descida)==(alvo: 1..andar_maximo | segurando_descida,segurando_descida_1,segurando_descida_2:=segurando_descida-{alvo},segurando_descida_1-{alvo},segurando_descida_2-{alvo});
  Expanded_List_Substitution(Machine(painel_pedidos),liberar_subida)==(alvo: 0..andar_maximo-1 | segurando_subida,segurando_subida_1,segurando_subida_2:=segurando_subida-{alvo},segurando_subida_1-{alvo},segurando_subida_2-{alvo});
  Expanded_List_Substitution(Machine(painel_pedidos),liberar_interno)==(alvo: 0..andar_maximo | segurando_interno,segurando_interno_1,segurando_interno_2,interno_recusado:=segurando_interno-{alvo},segurando_interno_1-{alvo},segurando_interno_2-{alvo},interno_recusado-{alvo});
  Expanded_List_Substitution(Machine(painel_pedidos),registrar_externo_descida)==(alvo: 1..andar_maximo & alvo|->descendo: painel_externo | pedidos_descida,segurando_descida,segurando_descida_1,segurando_descida_2,piscando_descida1,piscando_descida2,piscando_descida3,piscando_descida4:=pedidos_descida\/{alvo},segurando_descida\/{alvo},segurando_descida_1-{alvo},segurando_descida_2-{alvo},piscando_descida1-{alvo},piscando_descida2-{alvo},piscando_descida3-{alvo},piscando_descida4-{alvo});
  Expanded_List_Substitution(Machine(painel_pedidos),registrar_externo_subida)==(alvo: 0..andar_maximo-1 & alvo|->subindo: painel_externo | pedidos_subida,segurando_subida,segurando_subida_1,segurando_subida_2,piscando_subida1,piscando_subida2,piscando_subida3,piscando_subida4:=pedidos_subida\/{alvo},segurando_subida\/{alvo},segurando_subida_1-{alvo},segurando_subida_2-{alvo},piscando_subida1-{alvo},piscando_subida2-{alvo},piscando_subida3-{alvo},piscando_subida4-{alvo});
  Expanded_List_Substitution(Machine(painel_pedidos),registrar_interno)==(alvo: 0..andar_maximo | pedidos_internos,segurando_interno,segurando_interno_1,segurando_interno_2,interno_recusado,piscando_interno1,piscando_interno2,piscando_interno3,piscando_interno4:=pedidos_internos\/{alvo},segurando_interno\/{alvo},segurando_interno_1-{alvo},segurando_interno_2-{alvo},interno_recusado-{alvo},piscando_interno1-{alvo},piscando_interno2-{alvo},piscando_interno3-{alvo},piscando_interno4-{alvo});
  List_Substitution(Machine(painel_pedidos),registrar_interno)==(pedidos_internos:=pedidos_internos\/{alvo} || segurando_interno:=segurando_interno\/{alvo} || segurando_interno_1:=segurando_interno_1-{alvo} || segurando_interno_2:=segurando_interno_2-{alvo} || interno_recusado:=interno_recusado-{alvo} || piscando_interno1:=piscando_interno1-{alvo} || piscando_interno2:=piscando_interno2-{alvo} || piscando_interno3:=piscando_interno3-{alvo} || piscando_interno4:=piscando_interno4-{alvo});
  List_Substitution(Machine(painel_pedidos),registrar_externo_subida)==(pedidos_subida:=pedidos_subida\/{alvo} || segurando_subida:=segurando_subida\/{alvo} || segurando_subida_1:=segurando_subida_1-{alvo} || segurando_subida_2:=segurando_subida_2-{alvo} || piscando_subida1:=piscando_subida1-{alvo} || piscando_subida2:=piscando_subida2-{alvo} || piscando_subida3:=piscando_subida3-{alvo} || piscando_subida4:=piscando_subida4-{alvo});
  List_Substitution(Machine(painel_pedidos),registrar_externo_descida)==(pedidos_descida:=pedidos_descida\/{alvo} || segurando_descida:=segurando_descida\/{alvo} || segurando_descida_1:=segurando_descida_1-{alvo} || segurando_descida_2:=segurando_descida_2-{alvo} || piscando_descida1:=piscando_descida1-{alvo} || piscando_descida2:=piscando_descida2-{alvo} || piscando_descida3:=piscando_descida3-{alvo} || piscando_descida4:=piscando_descida4-{alvo});
  List_Substitution(Machine(painel_pedidos),liberar_interno)==(segurando_interno:=segurando_interno-{alvo} || segurando_interno_1:=segurando_interno_1-{alvo} || segurando_interno_2:=segurando_interno_2-{alvo} || interno_recusado:=interno_recusado-{alvo});
  List_Substitution(Machine(painel_pedidos),liberar_subida)==(segurando_subida:=segurando_subida-{alvo} || segurando_subida_1:=segurando_subida_1-{alvo} || segurando_subida_2:=segurando_subida_2-{alvo});
  List_Substitution(Machine(painel_pedidos),liberar_descida)==(segurando_descida:=segurando_descida-{alvo} || segurando_descida_1:=segurando_descida_1-{alvo} || segurando_descida_2:=segurando_descida_2-{alvo});
  List_Substitution(Machine(painel_pedidos),avancar_tempo_botoes)==(IF pedidos_internos/={} & pedidos_internos = segurando_interno_2 & pedidos_subida-segurando_subida_2 = {} & pedidos_descida-segurando_descida_2 = {} THEN pedidos_internos:={min(pedidos_internos)} || segurando_interno:={} || segurando_interno_1:={} || segurando_interno_2:={} || interno_recusado:={min(pedidos_internos)} || piscando_interno1:={min(pedidos_internos)} || piscando_interno2:=piscando_interno1-{min(pedidos_internos)} || piscando_interno3:=piscando_interno2-{min(pedidos_internos)} || piscando_interno4:=piscando_interno3-{min(pedidos_internos)} ELSE pedidos_internos:=pedidos_internos-segurando_interno_2 || segurando_interno:=segurando_interno-segurando_interno_2 || segurando_interno_1:=segurando_interno-segurando_interno_2 || segurando_interno_2:=segurando_interno_1-segurando_interno_2 || interno_recusado:=interno_recusado-segurando_interno_2 || piscando_interno1:={} || piscando_interno2:=piscando_interno1 || piscando_interno3:=piscando_interno2 || piscando_interno4:=piscando_interno3 END || pedidos_subida:=pedidos_subida-segurando_subida_2 || segurando_subida:=segurando_subida-segurando_subida_2 || segurando_subida_1:=segurando_subida-segurando_subida_2 || segurando_subida_2:=segurando_subida_1-segurando_subida_2 || piscando_subida1:={} || piscando_subida2:=piscando_subida1 || piscando_subida3:=piscando_subida2 || piscando_subida4:=piscando_subida3 || pedidos_descida:=pedidos_descida-segurando_descida_2 || segurando_descida:=segurando_descida-segurando_descida_2 || segurando_descida_1:=segurando_descida-segurando_descida_2 || segurando_descida_2:=segurando_descida_1-segurando_descida_2 || piscando_descida1:={} || piscando_descida2:=piscando_descida1 || piscando_descida3:=piscando_descida2 || piscando_descida4:=piscando_descida3);
  List_Substitution(Machine(painel_pedidos),avancar_piscadas_manutencao)==(piscando_interno1:={} || piscando_interno2:=piscando_interno1 || piscando_interno3:=piscando_interno2 || piscando_interno4:=piscando_interno3 || piscando_subida1:={} || piscando_subida2:=piscando_subida1 || piscando_subida3:=piscando_subida2 || piscando_subida4:=piscando_subida3 || piscando_descida1:={} || piscando_descida2:=piscando_descida1 || piscando_descida3:=piscando_descida2 || piscando_descida4:=piscando_descida3);
  List_Substitution(Machine(painel_pedidos),cancelar_todos)==(segurando_interno:={} || segurando_interno_1:={} || segurando_interno_2:={} || interno_recusado:={} || segurando_subida:={} || segurando_subida_1:={} || segurando_subida_2:={} || segurando_descida:={} || segurando_descida_1:={} || segurando_descida_2:={} || pedidos_internos:={} || pedidos_subida:={} || pedidos_descida:={} || piscando_interno1:={} || piscando_interno2:={} || piscando_interno3:={} || piscando_interno4:={} || piscando_subida1:={} || piscando_subida2:={} || piscando_subida3:={} || piscando_subida4:={} || piscando_descida1:={} || piscando_descida2:={} || piscando_descida3:={} || piscando_descida4:={});
  List_Substitution(Machine(painel_pedidos),atender_pedidos_andar)==(IF alvo: pedidos_internos THEN pedidos_internos:=pedidos_internos-{alvo} || piscando_interno1:=piscando_interno1-{alvo} || piscando_interno2:=piscando_interno2-{alvo} || piscando_interno3:=piscando_interno3-{alvo} || piscando_interno4:=piscando_interno4-{alvo} || segurando_interno:=segurando_interno-{alvo} || segurando_interno_1:=segurando_interno_1-{alvo} || segurando_interno_2:=segurando_interno_2-{alvo} || interno_recusado:=interno_recusado-{alvo} END || IF sentido = subindo or sentido = parado & alvo: pedidos_subida THEN pedidos_subida:=pedidos_subida-{alvo} || piscando_subida1:=piscando_subida1-{alvo} || piscando_subida2:=piscando_subida2-{alvo} || piscando_subida3:=piscando_subida3-{alvo} || piscando_subida4:=piscando_subida4-{alvo} || segurando_subida:=segurando_subida-{alvo} || segurando_subida_1:=segurando_subida_1-{alvo} || segurando_subida_2:=segurando_subida_2-{alvo} END || IF sentido = descendo or (sentido = parado & alvo/:pedidos_subida) & alvo: pedidos_descida THEN pedidos_descida:=pedidos_descida-{alvo} || piscando_descida1:=piscando_descida1-{alvo} || piscando_descida2:=piscando_descida2-{alvo} || piscando_descida3:=piscando_descida3-{alvo} || piscando_descida4:=piscando_descida4-{alvo} || segurando_descida:=segurando_descida-{alvo} || segurando_descida_1:=segurando_descida_1-{alvo} || segurando_descida_2:=segurando_descida_2-{alvo} END || IF size(historico_paradas)<5 THEN historico_paradas:=historico_paradas<-alvo ELSE historico_paradas:=tail(historico_paradas)^[alvo] END);
  List_Substitution(Machine(painel_pedidos),piscar_interno)==(piscando_interno1:=piscando_interno1\/{alvo} || piscando_interno2:=piscando_interno2-{alvo} || piscando_interno3:=piscando_interno3-{alvo} || piscando_interno4:=piscando_interno4-{alvo});
  List_Substitution(Machine(painel_pedidos),piscar_subida)==(piscando_subida1:=piscando_subida1\/{alvo} || piscando_subida2:=piscando_subida2-{alvo} || piscando_subida3:=piscando_subida3-{alvo} || piscando_subida4:=piscando_subida4-{alvo});
  List_Substitution(Machine(painel_pedidos),piscar_descida)==(piscando_descida1:=piscando_descida1\/{alvo} || piscando_descida2:=piscando_descida2-{alvo} || piscando_descida3:=piscando_descida3-{alvo} || piscando_descida4:=piscando_descida4-{alvo});
  List_Substitution(Machine(painel_pedidos),consultar_leds)==(leds_internos:=pedidos_internos-(piscando_interno1\/piscando_interno2\/piscando_interno3\/piscando_interno4)\/piscando_interno1\/piscando_interno3 || leds_subida:=pedidos_subida-(piscando_subida1\/piscando_subida2\/piscando_subida3\/piscando_subida4)\/piscando_subida1\/piscando_subida3 || leds_descida:=pedidos_descida-(piscando_descida1\/piscando_descida2\/piscando_descida3\/piscando_descida4)\/piscando_descida1\/piscando_descida3);
  List_Substitution(Machine(painel_pedidos),consultar_piscadas)==(internos_fase1:=piscando_interno1 || internos_fase2:=piscando_interno2 || subida_fase1:=piscando_subida1 || subida_fase2:=piscando_subida2 || descida_fase1:=piscando_descida1 || descida_fase2:=piscando_descida2);
  List_Substitution(Machine(painel_pedidos),consultar_botoes_pressionados)==(botoes_internos:=segurando_interno\/interno_recusado || botoes_subida:=segurando_subida || botoes_descida:=segurando_descida);
  List_Substitution(Machine(painel_pedidos),consultar_botoes_com_tempo)==(IF tt = -1 THEN internos_com_tempo:=(0..andar_maximo)-(segurando_interno\/interno_recusado) || subida_com_tempo:=(0..andar_maximo-1)-segurando_subida || descida_com_tempo:=(1..andar_maximo)-segurando_descida ELSIF tt = 0 THEN internos_com_tempo:=segurando_interno-segurando_interno_1 || subida_com_tempo:=segurando_subida-segurando_subida_1 || descida_com_tempo:=segurando_descida-segurando_descida_1 ELSIF tt = 1 THEN internos_com_tempo:=segurando_interno_1-segurando_interno_2 || subida_com_tempo:=segurando_subida_1-segurando_subida_2 || descida_com_tempo:=segurando_descida_1-segurando_descida_2 ELSIF tt = 2 THEN internos_com_tempo:=segurando_interno_2 || subida_com_tempo:=segurando_subida_2 || descida_com_tempo:=segurando_descida_2 ELSE internos_com_tempo:=interno_recusado || subida_com_tempo:={} || descida_com_tempo:={} END);
  List_Substitution(Machine(painel_pedidos),consultar_historico_paradas)==(historico:=historico_paradas || quantidade:=size(historico_paradas));
  List_Substitution(Machine(painel_pedidos),consultar_extremos_historico)==(primeira:=first(historico_paradas) || ultima:=last(historico_paradas));
  List_Substitution(Machine(painel_pedidos),sugerir_pedido_qualquer)==(ANY aa WHERE aa: pedidos_internos\/pedidos_subida\/pedidos_descida THEN alvo:=aa END)
END
&
THEORY ListConstantsX IS
  List_Valuable_Constants(Machine(painel_pedidos))==(?);
  Inherited_List_Constants(Machine(painel_pedidos))==(?);
  List_Constants(Machine(painel_pedidos))==(?)
END
&
THEORY ListSetsX IS
  Set_Definition(Machine(painel_pedidos),PORTAS)==({aberta,fechada});
  Context_List_Enumerated(Machine(painel_pedidos))==(DIRECOES,PORTAS);
  Context_List_Defered(Machine(painel_pedidos))==(?);
  Context_List_Sets(Machine(painel_pedidos))==(DIRECOES,PORTAS);
  List_Valuable_Sets(Machine(painel_pedidos))==(?);
  Inherited_List_Enumerated(Machine(painel_pedidos))==(?);
  Inherited_List_Defered(Machine(painel_pedidos))==(?);
  Inherited_List_Sets(Machine(painel_pedidos))==(?);
  List_Enumerated(Machine(painel_pedidos))==(?);
  List_Defered(Machine(painel_pedidos))==(?);
  List_Sets(Machine(painel_pedidos))==(?);
  Set_Definition(Machine(painel_pedidos),DIRECOES)==({subindo,descendo,parado})
END
&
THEORY ListHiddenConstantsX IS
  Abstract_List_HiddenConstants(Machine(painel_pedidos))==(?);
  Expanded_List_HiddenConstants(Machine(painel_pedidos))==(?);
  List_HiddenConstants(Machine(painel_pedidos))==(?);
  External_List_HiddenConstants(Machine(painel_pedidos))==(?)
END
&
THEORY ListPropertiesX IS
  Abstract_List_Properties(Machine(painel_pedidos))==(btrue);
  Context_List_Properties(Machine(painel_pedidos))==(peso_maximo = 450 & andar_maximo: NATURAL & andar_maximo>0 & painel_externo: 0..andar_maximo <-> DIRECOES & painel_externo = (0..andar_maximo-1)*{subindo}\/(1..andar_maximo)*{descendo} & DIRECOES: FIN(INTEGER) & not(DIRECOES = {}) & PORTAS: FIN(INTEGER) & not(PORTAS = {}));
  Inherited_List_Properties(Machine(painel_pedidos))==(btrue);
  List_Properties(Machine(painel_pedidos))==(btrue)
END
&
THEORY ListSeenInfoX IS
  Seen_Internal_List_Operations(Machine(painel_pedidos),Machine(configuracao))==(?);
  Seen_Context_List_Enumerated(Machine(painel_pedidos))==(?);
  Seen_Context_List_Invariant(Machine(painel_pedidos))==(btrue);
  Seen_Context_List_Assertions(Machine(painel_pedidos))==(btrue);
  Seen_Context_List_Properties(Machine(painel_pedidos))==(btrue);
  Seen_List_Constraints(Machine(painel_pedidos))==(btrue);
  Seen_List_Operations(Machine(painel_pedidos),Machine(configuracao))==(?);
  Seen_Expanded_List_Invariant(Machine(painel_pedidos),Machine(configuracao))==(btrue)
END
&
THEORY ListANYVarX IS
  List_ANY_Var(Machine(painel_pedidos),registrar_interno)==(?);
  List_ANY_Var(Machine(painel_pedidos),registrar_externo_subida)==(?);
  List_ANY_Var(Machine(painel_pedidos),registrar_externo_descida)==(?);
  List_ANY_Var(Machine(painel_pedidos),liberar_interno)==(?);
  List_ANY_Var(Machine(painel_pedidos),liberar_subida)==(?);
  List_ANY_Var(Machine(painel_pedidos),liberar_descida)==(?);
  List_ANY_Var(Machine(painel_pedidos),avancar_tempo_botoes)==(?);
  List_ANY_Var(Machine(painel_pedidos),avancar_piscadas_manutencao)==(?);
  List_ANY_Var(Machine(painel_pedidos),cancelar_todos)==(?);
  List_ANY_Var(Machine(painel_pedidos),atender_pedidos_andar)==(?);
  List_ANY_Var(Machine(painel_pedidos),piscar_interno)==(?);
  List_ANY_Var(Machine(painel_pedidos),piscar_subida)==(?);
  List_ANY_Var(Machine(painel_pedidos),piscar_descida)==(?);
  List_ANY_Var(Machine(painel_pedidos),consultar_leds)==(?);
  List_ANY_Var(Machine(painel_pedidos),consultar_piscadas)==(?);
  List_ANY_Var(Machine(painel_pedidos),consultar_botoes_pressionados)==(?);
  List_ANY_Var(Machine(painel_pedidos),consultar_botoes_com_tempo)==(?);
  List_ANY_Var(Machine(painel_pedidos),consultar_historico_paradas)==(?);
  List_ANY_Var(Machine(painel_pedidos),consultar_extremos_historico)==(?);
  List_ANY_Var(Machine(painel_pedidos),sugerir_pedido_qualquer)==(Var(aa) == btype(INTEGER,?,?))
END
&
THEORY ListOfIdsX IS
  List_Of_Ids(Machine(painel_pedidos)) == (? | ? | historico_paradas,segurando_descida_2,segurando_descida_1,segurando_descida,segurando_subida_2,segurando_subida_1,segurando_subida,interno_recusado,segurando_interno_2,segurando_interno_1,segurando_interno,piscando_descida4,piscando_descida3,piscando_descida2,piscando_subida4,piscando_subida3,piscando_subida2,piscando_interno4,piscando_interno3,piscando_interno2,piscando_descida1,piscando_subida1,piscando_interno1,pedidos_descida,pedidos_subida,pedidos_internos | ? | registrar_interno,registrar_externo_subida,registrar_externo_descida,liberar_interno,liberar_subida,liberar_descida,avancar_tempo_botoes,avancar_piscadas_manutencao,cancelar_todos,atender_pedidos_andar,piscar_interno,piscar_subida,piscar_descida,consultar_leds,consultar_piscadas,consultar_botoes_pressionados,consultar_botoes_com_tempo,consultar_historico_paradas,consultar_extremos_historico,sugerir_pedido_qualquer | ? | seen(Machine(configuracao)) | ? | painel_pedidos);
  List_Of_HiddenCst_Ids(Machine(painel_pedidos)) == (? | ?);
  List_Of_VisibleCst_Ids(Machine(painel_pedidos)) == (?);
  List_Of_VisibleVar_Ids(Machine(painel_pedidos)) == (? | ?);
  List_Of_Ids_SeenBNU(Machine(painel_pedidos)) == (?: ?);
  List_Of_Ids(Machine(configuracao)) == (peso_maximo,andar_maximo,painel_externo,DIRECOES,PORTAS,subindo,descendo,parado,aberta,fechada | ? | ? | ? | ? | ? | ? | ? | configuracao);
  List_Of_HiddenCst_Ids(Machine(configuracao)) == (? | ?);
  List_Of_VisibleCst_Ids(Machine(configuracao)) == (peso_maximo,andar_maximo,painel_externo);
  List_Of_VisibleVar_Ids(Machine(configuracao)) == (? | ?);
  List_Of_Ids_SeenBNU(Machine(configuracao)) == (?: ?)
END
&
THEORY VariablesEnvX IS
  Variables(Machine(painel_pedidos)) == (Type(historico_paradas) == Mvl(SetOf(btype(INTEGER,?,?)*btype(INTEGER,?,?)));Type(segurando_descida_2) == Mvl(SetOf(btype(INTEGER,?,?)));Type(segurando_descida_1) == Mvl(SetOf(btype(INTEGER,?,?)));Type(segurando_descida) == Mvl(SetOf(btype(INTEGER,?,?)));Type(segurando_subida_2) == Mvl(SetOf(btype(INTEGER,?,?)));Type(segurando_subida_1) == Mvl(SetOf(btype(INTEGER,?,?)));Type(segurando_subida) == Mvl(SetOf(btype(INTEGER,?,?)));Type(interno_recusado) == Mvl(SetOf(btype(INTEGER,?,?)));Type(segurando_interno_2) == Mvl(SetOf(btype(INTEGER,?,?)));Type(segurando_interno_1) == Mvl(SetOf(btype(INTEGER,?,?)));Type(segurando_interno) == Mvl(SetOf(btype(INTEGER,?,?)));Type(piscando_descida4) == Mvl(SetOf(btype(INTEGER,?,?)));Type(piscando_descida3) == Mvl(SetOf(btype(INTEGER,?,?)));Type(piscando_descida2) == Mvl(SetOf(btype(INTEGER,?,?)));Type(piscando_subida4) == Mvl(SetOf(btype(INTEGER,?,?)));Type(piscando_subida3) == Mvl(SetOf(btype(INTEGER,?,?)));Type(piscando_subida2) == Mvl(SetOf(btype(INTEGER,?,?)));Type(piscando_interno4) == Mvl(SetOf(btype(INTEGER,?,?)));Type(piscando_interno3) == Mvl(SetOf(btype(INTEGER,?,?)));Type(piscando_interno2) == Mvl(SetOf(btype(INTEGER,?,?)));Type(piscando_descida1) == Mvl(SetOf(btype(INTEGER,?,?)));Type(piscando_subida1) == Mvl(SetOf(btype(INTEGER,?,?)));Type(piscando_interno1) == Mvl(SetOf(btype(INTEGER,?,?)));Type(pedidos_descida) == Mvl(SetOf(btype(INTEGER,?,?)));Type(pedidos_subida) == Mvl(SetOf(btype(INTEGER,?,?)));Type(pedidos_internos) == Mvl(SetOf(btype(INTEGER,?,?))))
END
&
THEORY OperationsEnvX IS
  Operations(Machine(painel_pedidos)) == (Type(sugerir_pedido_qualquer) == Cst(btype(INTEGER,?,?),No_type);Type(consultar_extremos_historico) == Cst(btype(INTEGER,?,?)*btype(INTEGER,?,?),No_type);Type(consultar_historico_paradas) == Cst(SetOf(btype(INTEGER,?,?)*btype(INTEGER,?,?))*btype(INTEGER,?,?),No_type);Type(consultar_botoes_com_tempo) == Cst(SetOf(btype(INTEGER,?,?))*SetOf(btype(INTEGER,?,?))*SetOf(btype(INTEGER,?,?)),btype(INTEGER,?,?));Type(consultar_botoes_pressionados) == Cst(SetOf(btype(INTEGER,?,?))*SetOf(btype(INTEGER,?,?))*SetOf(btype(INTEGER,?,?)),No_type);Type(consultar_piscadas) == Cst(SetOf(btype(INTEGER,?,?))*SetOf(btype(INTEGER,?,?))*SetOf(btype(INTEGER,?,?))*SetOf(btype(INTEGER,?,?))*SetOf(btype(INTEGER,?,?))*SetOf(btype(INTEGER,?,?)),No_type);Type(consultar_leds) == Cst(SetOf(btype(INTEGER,?,?))*SetOf(btype(INTEGER,?,?))*SetOf(btype(INTEGER,?,?)),No_type);Type(piscar_descida) == Cst(No_type,btype(INTEGER,?,?));Type(piscar_subida) == Cst(No_type,btype(INTEGER,?,?));Type(piscar_interno) == Cst(No_type,btype(INTEGER,?,?));Type(atender_pedidos_andar) == Cst(No_type,btype(INTEGER,?,?)*etype(DIRECOES,?,?));Type(cancelar_todos) == Cst(No_type,No_type);Type(avancar_piscadas_manutencao) == Cst(No_type,No_type);Type(avancar_tempo_botoes) == Cst(No_type,No_type);Type(liberar_descida) == Cst(No_type,btype(INTEGER,?,?));Type(liberar_subida) == Cst(No_type,btype(INTEGER,?,?));Type(liberar_interno) == Cst(No_type,btype(INTEGER,?,?));Type(registrar_externo_descida) == Cst(No_type,btype(INTEGER,?,?));Type(registrar_externo_subida) == Cst(No_type,btype(INTEGER,?,?));Type(registrar_interno) == Cst(No_type,btype(INTEGER,?,?)));
  Observers(Machine(painel_pedidos)) == (Type(sugerir_pedido_qualquer) == Cst(btype(INTEGER,?,?),No_type);Type(consultar_extremos_historico) == Cst(btype(INTEGER,?,?)*btype(INTEGER,?,?),No_type);Type(consultar_historico_paradas) == Cst(SetOf(btype(INTEGER,?,?)*btype(INTEGER,?,?))*btype(INTEGER,?,?),No_type);Type(consultar_botoes_com_tempo) == Cst(SetOf(btype(INTEGER,?,?))*SetOf(btype(INTEGER,?,?))*SetOf(btype(INTEGER,?,?)),btype(INTEGER,?,?));Type(consultar_botoes_pressionados) == Cst(SetOf(btype(INTEGER,?,?))*SetOf(btype(INTEGER,?,?))*SetOf(btype(INTEGER,?,?)),No_type);Type(consultar_piscadas) == Cst(SetOf(btype(INTEGER,?,?))*SetOf(btype(INTEGER,?,?))*SetOf(btype(INTEGER,?,?))*SetOf(btype(INTEGER,?,?))*SetOf(btype(INTEGER,?,?))*SetOf(btype(INTEGER,?,?)),No_type);Type(consultar_leds) == Cst(SetOf(btype(INTEGER,?,?))*SetOf(btype(INTEGER,?,?))*SetOf(btype(INTEGER,?,?)),No_type))
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
