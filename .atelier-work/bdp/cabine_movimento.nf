Normalised(
THEORY MagicNumberX IS
  MagicNumber(Machine(cabine_movimento))==(3.5)
END
&
THEORY UpperLevelX IS
  First_Level(Machine(cabine_movimento))==(Machine(cabine_movimento));
  Level(Machine(cabine_movimento))==(0)
END
&
THEORY LoadedStructureX IS
  Machine(cabine_movimento)
END
&
THEORY ListSeesX IS
  List_Sees(Machine(cabine_movimento))==(configuracao)
END
&
THEORY ListUsesX IS
  List_Uses(Machine(cabine_movimento))==(?)
END
&
THEORY ListIncludesX IS
  Inherited_List_Includes(Machine(cabine_movimento))==(?);
  List_Includes(Machine(cabine_movimento))==(?)
END
&
THEORY ListPromotesX IS
  List_Promotes(Machine(cabine_movimento))==(?)
END
&
THEORY ListExtendsX IS
  List_Extends(Machine(cabine_movimento))==(?)
END
&
THEORY ListVariablesX IS
  External_Context_List_Variables(Machine(cabine_movimento))==(?);
  Context_List_Variables(Machine(cabine_movimento))==(?);
  Abstract_List_Variables(Machine(cabine_movimento))==(?);
  Local_List_Variables(Machine(cabine_movimento))==(manutencao_pendente,manutencao,chave_manutencao,ultima_visita,segundos_porta_aberta,limite_peso_atingido,peso,parada_por_cancelamento,parada_pendente,sentido_atendimento,porta_retida,porta,deslocamento,direcao,andar);
  List_Variables(Machine(cabine_movimento))==(manutencao_pendente,manutencao,chave_manutencao,ultima_visita,segundos_porta_aberta,limite_peso_atingido,peso,parada_por_cancelamento,parada_pendente,sentido_atendimento,porta_retida,porta,deslocamento,direcao,andar);
  External_List_Variables(Machine(cabine_movimento))==(manutencao_pendente,manutencao,chave_manutencao,ultima_visita,segundos_porta_aberta,limite_peso_atingido,peso,parada_por_cancelamento,parada_pendente,sentido_atendimento,porta_retida,porta,deslocamento,direcao,andar)
END
&
THEORY ListVisibleVariablesX IS
  Inherited_List_VisibleVariables(Machine(cabine_movimento))==(?);
  Abstract_List_VisibleVariables(Machine(cabine_movimento))==(?);
  External_List_VisibleVariables(Machine(cabine_movimento))==(?);
  Expanded_List_VisibleVariables(Machine(cabine_movimento))==(?);
  List_VisibleVariables(Machine(cabine_movimento))==(?);
  Internal_List_VisibleVariables(Machine(cabine_movimento))==(?)
END
&
THEORY ListInvariantX IS
  Gluing_Seen_List_Invariant(Machine(cabine_movimento))==(btrue);
  Gluing_List_Invariant(Machine(cabine_movimento))==(btrue);
  Expanded_List_Invariant(Machine(cabine_movimento))==(btrue);
  Abstract_List_Invariant(Machine(cabine_movimento))==(btrue);
  Context_List_Invariant(Machine(cabine_movimento))==(btrue);
  List_Invariant(Machine(cabine_movimento))==(andar: 0..andar_maximo & direcao: DIRECOES & deslocamento: NATURAL & porta: PORTAS & porta_retida: BOOL & sentido_atendimento: DIRECOES & (direcao = subindo => sentido_atendimento = subindo) & (direcao = descendo => sentido_atendimento = descendo) & parada_pendente: BOOL & parada_por_cancelamento: BOOL & peso: NATURAL & limite_peso_atingido: BOOL & limite_peso_atingido = TRUE <=> peso>peso_maximo & (direcao/=parado => porta = fechada) & (direcao/=parado => limite_peso_atingido = FALSE) & (direcao = subindo => andar<andar_maximo) & (direcao = descendo => andar>0) & (parada_pendente = TRUE => direcao/=parado) & segundos_porta_aberta: 0..121 & (porta = fechada => segundos_porta_aberta = 0) & ultima_visita: 0..andar_maximo +-> NATURAL & ran(ultima_visita) <: 0..deslocamento & chave_manutencao: BOOL & manutencao: BOOL & (porta_retida = TRUE => porta = aberta) & (porta = fechada => porta_retida = FALSE) & (porta_retida = TRUE => direcao = parado) & (porta_retida = TRUE => manutencao = FALSE) & manutencao_pendente: BOOL & (manutencao = TRUE => chave_manutencao = TRUE) & (manutencao = TRUE => direcao = parado) & (manutencao_pendente = TRUE => chave_manutencao = TRUE) & not(manutencao = TRUE & manutencao_pendente = TRUE) & (manutencao_pendente = TRUE => direcao/=parado) & (parada_pendente = TRUE => parada_por_cancelamento = TRUE or manutencao_pendente = TRUE) & (parada_por_cancelamento = TRUE => parada_pendente = TRUE) & (manutencao_pendente = TRUE => parada_pendente = TRUE))
END
&
THEORY ListAssertionsX IS
  Expanded_List_Assertions(Machine(cabine_movimento))==(btrue);
  Abstract_List_Assertions(Machine(cabine_movimento))==(btrue);
  Context_List_Assertions(Machine(cabine_movimento))==(btrue);
  List_Assertions(Machine(cabine_movimento))==(btrue)
END
&
THEORY ListCoverageX IS
  List_Coverage(Machine(cabine_movimento))==(btrue)
END
&
THEORY ListExclusivityX IS
  List_Exclusivity(Machine(cabine_movimento))==(btrue)
END
&
THEORY ListInitialisationX IS
  Expanded_List_Initialisation(Machine(cabine_movimento))==(andar,direcao,deslocamento,porta,porta_retida,sentido_atendimento,parada_pendente,parada_por_cancelamento,peso,limite_peso_atingido,segundos_porta_aberta,ultima_visita,chave_manutencao,manutencao,manutencao_pendente:=0,parado,0,fechada,FALSE,parado,FALSE,FALSE,0,FALSE,0,{},FALSE,FALSE,FALSE);
  Context_List_Initialisation(Machine(cabine_movimento))==(skip);
  List_Initialisation(Machine(cabine_movimento))==(andar:=0 || direcao:=parado || deslocamento:=0 || porta:=fechada || porta_retida:=FALSE || sentido_atendimento:=parado || parada_pendente:=FALSE || parada_por_cancelamento:=FALSE || peso:=0 || limite_peso_atingido:=FALSE || segundos_porta_aberta:=0 || ultima_visita:={} || chave_manutencao:=FALSE || manutencao:=FALSE || manutencao_pendente:=FALSE)
END
&
THEORY ListParametersX IS
  List_Parameters(Machine(cabine_movimento))==(?)
END
&
THEORY ListInstanciatedParametersX IS
  List_Instanciated_Parameters(Machine(cabine_movimento),Machine(configuracao))==(?)
END
&
THEORY ListConstraintsX IS
  List_Context_Constraints(Machine(cabine_movimento))==(btrue);
  List_Constraints(Machine(cabine_movimento))==(btrue)
END
&
THEORY ListOperationsX IS
  Internal_List_Operations(Machine(cabine_movimento))==(inserir_chave_manutencao,remover_chave_manutencao,atualizar_peso,ajustar_peso,avancar_tempo_porta,segurar_porta,liberar_porta,iniciar_subida,iniciar_descida,subir,descer,inverter_sentido,abrir_porta,fechar_porta,manter_porta,entrar_em_reposo,consultar_parada_pendente,consultar_estado,consultar_deslocamento,consultar_peso,consultar_folga,consultar_porta,consultar_manutencao,consultar_visitas);
  List_Operations(Machine(cabine_movimento))==(inserir_chave_manutencao,remover_chave_manutencao,atualizar_peso,ajustar_peso,avancar_tempo_porta,segurar_porta,liberar_porta,iniciar_subida,iniciar_descida,subir,descer,inverter_sentido,abrir_porta,fechar_porta,manter_porta,entrar_em_reposo,consultar_parada_pendente,consultar_estado,consultar_deslocamento,consultar_peso,consultar_folga,consultar_porta,consultar_manutencao,consultar_visitas)
END
&
THEORY ListInputX IS
  List_Input(Machine(cabine_movimento),inserir_chave_manutencao)==(?);
  List_Input(Machine(cabine_movimento),remover_chave_manutencao)==(?);
  List_Input(Machine(cabine_movimento),atualizar_peso)==(novo_peso);
  List_Input(Machine(cabine_movimento),ajustar_peso)==(delta);
  List_Input(Machine(cabine_movimento),avancar_tempo_porta)==(parar);
  List_Input(Machine(cabine_movimento),segurar_porta)==(?);
  List_Input(Machine(cabine_movimento),liberar_porta)==(?);
  List_Input(Machine(cabine_movimento),iniciar_subida)==(?);
  List_Input(Machine(cabine_movimento),iniciar_descida)==(?);
  List_Input(Machine(cabine_movimento),subir)==(p_int,p_sub,p_des);
  List_Input(Machine(cabine_movimento),descer)==(p_int,p_sub,p_des);
  List_Input(Machine(cabine_movimento),inverter_sentido)==(?);
  List_Input(Machine(cabine_movimento),abrir_porta)==(p_int,p_sub,p_des);
  List_Input(Machine(cabine_movimento),fechar_porta)==(?);
  List_Input(Machine(cabine_movimento),manter_porta)==(p_int,p_sub,p_des);
  List_Input(Machine(cabine_movimento),entrar_em_reposo)==(p_int,p_sub,p_des);
  List_Input(Machine(cabine_movimento),consultar_parada_pendente)==(?);
  List_Input(Machine(cabine_movimento),consultar_estado)==(?);
  List_Input(Machine(cabine_movimento),consultar_deslocamento)==(?);
  List_Input(Machine(cabine_movimento),consultar_peso)==(?);
  List_Input(Machine(cabine_movimento),consultar_folga)==(?);
  List_Input(Machine(cabine_movimento),consultar_porta)==(?);
  List_Input(Machine(cabine_movimento),consultar_manutencao)==(?);
  List_Input(Machine(cabine_movimento),consultar_visitas)==(?)
END
&
THEORY ListOutputX IS
  List_Output(Machine(cabine_movimento),inserir_chave_manutencao)==(?);
  List_Output(Machine(cabine_movimento),remover_chave_manutencao)==(?);
  List_Output(Machine(cabine_movimento),atualizar_peso)==(?);
  List_Output(Machine(cabine_movimento),ajustar_peso)==(?);
  List_Output(Machine(cabine_movimento),avancar_tempo_porta)==(?);
  List_Output(Machine(cabine_movimento),segurar_porta)==(?);
  List_Output(Machine(cabine_movimento),liberar_porta)==(?);
  List_Output(Machine(cabine_movimento),iniciar_subida)==(?);
  List_Output(Machine(cabine_movimento),iniciar_descida)==(?);
  List_Output(Machine(cabine_movimento),subir)==(?);
  List_Output(Machine(cabine_movimento),descer)==(?);
  List_Output(Machine(cabine_movimento),inverter_sentido)==(?);
  List_Output(Machine(cabine_movimento),abrir_porta)==(?);
  List_Output(Machine(cabine_movimento),fechar_porta)==(?);
  List_Output(Machine(cabine_movimento),manter_porta)==(?);
  List_Output(Machine(cabine_movimento),entrar_em_reposo)==(?);
  List_Output(Machine(cabine_movimento),consultar_parada_pendente)==(pendente);
  List_Output(Machine(cabine_movimento),consultar_estado)==(pavimento_exibido,direcao_exibida);
  List_Output(Machine(cabine_movimento),consultar_deslocamento)==(total_deslocamento);
  List_Output(Machine(cabine_movimento),consultar_peso)==(peso_atual,alerta_ativo);
  List_Output(Machine(cabine_movimento),consultar_folga)==(folga);
  List_Output(Machine(cabine_movimento),consultar_porta)==(estado_porta,tempo_aberta);
  List_Output(Machine(cabine_movimento),consultar_manutencao)==(chave_inserida,manutencao_ativa,manutencao_aguardando);
  List_Output(Machine(cabine_movimento),consultar_visitas)==(visitados,nunca_visitados,marcas)
END
&
THEORY ListHeaderX IS
  List_Header(Machine(cabine_movimento),inserir_chave_manutencao)==(inserir_chave_manutencao);
  List_Header(Machine(cabine_movimento),remover_chave_manutencao)==(remover_chave_manutencao);
  List_Header(Machine(cabine_movimento),atualizar_peso)==(atualizar_peso(novo_peso));
  List_Header(Machine(cabine_movimento),ajustar_peso)==(ajustar_peso(delta));
  List_Header(Machine(cabine_movimento),avancar_tempo_porta)==(avancar_tempo_porta(parar));
  List_Header(Machine(cabine_movimento),segurar_porta)==(segurar_porta);
  List_Header(Machine(cabine_movimento),liberar_porta)==(liberar_porta);
  List_Header(Machine(cabine_movimento),iniciar_subida)==(iniciar_subida);
  List_Header(Machine(cabine_movimento),iniciar_descida)==(iniciar_descida);
  List_Header(Machine(cabine_movimento),subir)==(subir(p_int,p_sub,p_des));
  List_Header(Machine(cabine_movimento),descer)==(descer(p_int,p_sub,p_des));
  List_Header(Machine(cabine_movimento),inverter_sentido)==(inverter_sentido);
  List_Header(Machine(cabine_movimento),abrir_porta)==(abrir_porta(p_int,p_sub,p_des));
  List_Header(Machine(cabine_movimento),fechar_porta)==(fechar_porta);
  List_Header(Machine(cabine_movimento),manter_porta)==(manter_porta(p_int,p_sub,p_des));
  List_Header(Machine(cabine_movimento),entrar_em_reposo)==(entrar_em_reposo(p_int,p_sub,p_des));
  List_Header(Machine(cabine_movimento),consultar_parada_pendente)==(pendente <-- consultar_parada_pendente);
  List_Header(Machine(cabine_movimento),consultar_estado)==(pavimento_exibido,direcao_exibida <-- consultar_estado);
  List_Header(Machine(cabine_movimento),consultar_deslocamento)==(total_deslocamento <-- consultar_deslocamento);
  List_Header(Machine(cabine_movimento),consultar_peso)==(peso_atual,alerta_ativo <-- consultar_peso);
  List_Header(Machine(cabine_movimento),consultar_folga)==(folga <-- consultar_folga);
  List_Header(Machine(cabine_movimento),consultar_porta)==(estado_porta,tempo_aberta <-- consultar_porta);
  List_Header(Machine(cabine_movimento),consultar_manutencao)==(chave_inserida,manutencao_ativa,manutencao_aguardando <-- consultar_manutencao);
  List_Header(Machine(cabine_movimento),consultar_visitas)==(visitados,nunca_visitados,marcas <-- consultar_visitas)
END
&
THEORY ListOperationGuardX END
&
THEORY ListPreconditionX IS
  List_Precondition(Machine(cabine_movimento),inserir_chave_manutencao)==(chave_manutencao = FALSE);
  List_Precondition(Machine(cabine_movimento),remover_chave_manutencao)==(chave_manutencao = TRUE & (manutencao = TRUE & direcao = parado or manutencao_pendente = TRUE));
  List_Precondition(Machine(cabine_movimento),atualizar_peso)==(novo_peso: NATURAL & direcao = parado);
  List_Precondition(Machine(cabine_movimento),ajustar_peso)==(delta: INTEGER & direcao = parado & peso+delta: NATURAL);
  List_Precondition(Machine(cabine_movimento),avancar_tempo_porta)==(parar: BOOL & (parar = TRUE => direcao/=parado));
  List_Precondition(Machine(cabine_movimento),segurar_porta)==(btrue);
  List_Precondition(Machine(cabine_movimento),liberar_porta)==(btrue);
  List_Precondition(Machine(cabine_movimento),iniciar_subida)==(direcao = parado & porta = fechada & limite_peso_atingido = FALSE & manutencao = FALSE & andar<andar_maximo & (sentido_atendimento = parado or sentido_atendimento = subindo));
  List_Precondition(Machine(cabine_movimento),iniciar_descida)==(direcao = parado & porta = fechada & limite_peso_atingido = FALSE & manutencao = FALSE & andar>0 & (sentido_atendimento = parado or sentido_atendimento = descendo));
  List_Precondition(Machine(cabine_movimento),subir)==(p_int <: 0..andar_maximo & p_sub <: 0..andar_maximo-1 & p_des <: 1..andar_maximo & direcao = subindo & porta = fechada & limite_peso_atingido = FALSE & manutencao = FALSE & andar<andar_maximo);
  List_Precondition(Machine(cabine_movimento),descer)==(p_int <: 0..andar_maximo & p_sub <: 0..andar_maximo-1 & p_des <: 1..andar_maximo & direcao = descendo & porta = fechada & limite_peso_atingido = FALSE & manutencao = FALSE & andar>0);
  List_Precondition(Machine(cabine_movimento),inverter_sentido)==(direcao = parado & porta = fechada & sentido_atendimento: {subindo,descendo});
  List_Precondition(Machine(cabine_movimento),abrir_porta)==(p_int <: 0..andar_maximo & p_sub <: 0..andar_maximo-1 & p_des <: 1..andar_maximo & direcao = parado & porta = fechada & manutencao = FALSE);
  List_Precondition(Machine(cabine_movimento),fechar_porta)==(porta = aberta & porta_retida = FALSE);
  List_Precondition(Machine(cabine_movimento),manter_porta)==(p_int <: 0..andar_maximo & p_sub <: 0..andar_maximo-1 & p_des <: 1..andar_maximo & direcao = parado & porta = aberta & manutencao = FALSE);
  List_Precondition(Machine(cabine_movimento),entrar_em_reposo)==(p_int <: 0..andar_maximo & p_sub <: 0..andar_maximo-1 & p_des <: 1..andar_maximo & direcao = parado & porta = fechada & p_int = {} & p_sub = {} & p_des = {});
  List_Precondition(Machine(cabine_movimento),consultar_parada_pendente)==(btrue);
  List_Precondition(Machine(cabine_movimento),consultar_estado)==(btrue);
  List_Precondition(Machine(cabine_movimento),consultar_deslocamento)==(btrue);
  List_Precondition(Machine(cabine_movimento),consultar_peso)==(btrue);
  List_Precondition(Machine(cabine_movimento),consultar_folga)==(btrue);
  List_Precondition(Machine(cabine_movimento),consultar_porta)==(btrue);
  List_Precondition(Machine(cabine_movimento),consultar_manutencao)==(btrue);
  List_Precondition(Machine(cabine_movimento),consultar_visitas)==(btrue)
END
&
THEORY ListSubstitutionX IS
  Expanded_List_Substitution(Machine(cabine_movimento),consultar_visitas)==(btrue | visitados,nunca_visitados,marcas:=dom(ultima_visita),{aa | aa: 0..andar_maximo & aa/:dom(ultima_visita)},ran(ultima_visita));
  Expanded_List_Substitution(Machine(cabine_movimento),consultar_manutencao)==(btrue | chave_inserida,manutencao_ativa,manutencao_aguardando:=chave_manutencao,manutencao,manutencao_pendente);
  Expanded_List_Substitution(Machine(cabine_movimento),consultar_porta)==(btrue | estado_porta,tempo_aberta:=porta,segundos_porta_aberta);
  Expanded_List_Substitution(Machine(cabine_movimento),consultar_folga)==(btrue | folga:=peso_maximo-peso);
  Expanded_List_Substitution(Machine(cabine_movimento),consultar_peso)==(btrue | peso_atual,alerta_ativo:=peso,limite_peso_atingido);
  Expanded_List_Substitution(Machine(cabine_movimento),consultar_deslocamento)==(btrue | total_deslocamento:=deslocamento);
  Expanded_List_Substitution(Machine(cabine_movimento),consultar_estado)==(btrue | pavimento_exibido,direcao_exibida:=andar,direcao);
  Expanded_List_Substitution(Machine(cabine_movimento),consultar_parada_pendente)==(btrue | pendente:=parada_pendente);
  Expanded_List_Substitution(Machine(cabine_movimento),entrar_em_reposo)==(p_int <: 0..andar_maximo & p_sub <: 0..andar_maximo-1 & p_des <: 1..andar_maximo & direcao = parado & porta = fechada & p_int = {} & p_sub = {} & p_des = {} | sentido_atendimento:=parado);
  Expanded_List_Substitution(Machine(cabine_movimento),manter_porta)==(p_int <: 0..andar_maximo & p_sub <: 0..andar_maximo-1 & p_des <: 1..andar_maximo & direcao = parado & porta = aberta & manutencao = FALSE | sentido_atendimento = parado & andar: p_sub ==> sentido_atendimento:=subindo [] not(sentido_atendimento = parado & andar: p_sub) ==> (sentido_atendimento = parado & andar: p_des ==> sentido_atendimento:=descendo [] not(sentido_atendimento = parado & andar: p_des) ==> skip));
  Expanded_List_Substitution(Machine(cabine_movimento),fechar_porta)==(porta = aberta & porta_retida = FALSE | porta,segundos_porta_aberta:=fechada,0);
  Expanded_List_Substitution(Machine(cabine_movimento),abrir_porta)==(p_int <: 0..andar_maximo & p_sub <: 0..andar_maximo-1 & p_des <: 1..andar_maximo & direcao = parado & porta = fechada & manutencao = FALSE | porta:=aberta || (sentido_atendimento = parado & andar: p_sub ==> sentido_atendimento:=subindo [] not(sentido_atendimento = parado & andar: p_sub) ==> (sentido_atendimento = parado & andar: p_des ==> sentido_atendimento:=descendo [] not(sentido_atendimento = parado & andar: p_des) ==> skip)) || ultima_visita:=ultima_visita<+{andar|->deslocamento});
  Expanded_List_Substitution(Machine(cabine_movimento),inverter_sentido)==(direcao = parado & porta = fechada & sentido_atendimento: {subindo,descendo} | sentido_atendimento = subindo ==> sentido_atendimento:=descendo [] not(sentido_atendimento = subindo) ==> sentido_atendimento:=subindo);
  Expanded_List_Substitution(Machine(cabine_movimento),descer)==(p_int <: 0..andar_maximo & p_sub <: 0..andar_maximo-1 & p_des <: 1..andar_maximo & direcao = descendo & porta = fechada & limite_peso_atingido = FALSE & manutencao = FALSE & andar>0 | andar,deslocamento:=andar-1,deslocamento+1 || (parada_pendente = TRUE or andar-1: p_int\/p_des or p_int\/p_sub\/p_des/\0..andar-2 = {} ==> (direcao:=parado || (manutencao_pendente = TRUE ==> manutencao,manutencao_pendente:=TRUE,FALSE [] not(manutencao_pendente = TRUE) ==> skip)) [] not(parada_pendente = TRUE or andar-1: p_int\/p_des or p_int\/p_sub\/p_des/\0..andar-2 = {}) ==> skip) || parada_pendente:=FALSE || parada_por_cancelamento:=FALSE);
  Expanded_List_Substitution(Machine(cabine_movimento),subir)==(p_int <: 0..andar_maximo & p_sub <: 0..andar_maximo-1 & p_des <: 1..andar_maximo & direcao = subindo & porta = fechada & limite_peso_atingido = FALSE & manutencao = FALSE & andar<andar_maximo | andar,deslocamento:=andar+1,deslocamento+1 || (andar+1 = andar_maximo or parada_pendente = TRUE or andar+1: p_int\/p_sub or p_int\/p_sub\/p_des/\andar+2..andar_maximo = {} ==> (direcao:=parado || (manutencao_pendente = TRUE ==> manutencao,manutencao_pendente:=TRUE,FALSE [] not(manutencao_pendente = TRUE) ==> skip)) [] not(andar+1 = andar_maximo or parada_pendente = TRUE or andar+1: p_int\/p_sub or p_int\/p_sub\/p_des/\andar+2..andar_maximo = {}) ==> skip) || parada_pendente:=FALSE || parada_por_cancelamento:=FALSE);
  Expanded_List_Substitution(Machine(cabine_movimento),iniciar_descida)==(direcao = parado & porta = fechada & limite_peso_atingido = FALSE & manutencao = FALSE & andar>0 & (sentido_atendimento = parado or sentido_atendimento = descendo) | direcao,sentido_atendimento:=descendo,descendo);
  Expanded_List_Substitution(Machine(cabine_movimento),iniciar_subida)==(direcao = parado & porta = fechada & limite_peso_atingido = FALSE & manutencao = FALSE & andar<andar_maximo & (sentido_atendimento = parado or sentido_atendimento = subindo) | direcao,sentido_atendimento:=subindo,subindo);
  Expanded_List_Substitution(Machine(cabine_movimento),liberar_porta)==(btrue | porta_retida:=FALSE);
  Expanded_List_Substitution(Machine(cabine_movimento),segurar_porta)==(btrue | direcao = parado & porta = aberta & manutencao = FALSE ==> porta_retida:=TRUE [] not(direcao = parado & porta = aberta & manutencao = FALSE) ==> skip);
  Expanded_List_Substitution(Machine(cabine_movimento),avancar_tempo_porta)==(parar: BOOL & (parar = TRUE => direcao/=parado) | porta = aberta & segundos_porta_aberta<121 ==> segundos_porta_aberta:=segundos_porta_aberta+1 [] not(porta = aberta & segundos_porta_aberta<121) ==> skip || (parar = TRUE ==> parada_por_cancelamento,parada_pendente:=TRUE,TRUE [] not(parar = TRUE) ==> skip));
  Expanded_List_Substitution(Machine(cabine_movimento),ajustar_peso)==(delta: INTEGER & direcao = parado & peso+delta: NATURAL | peso,limite_peso_atingido:=peso+delta,bool(peso+delta>peso_maximo));
  Expanded_List_Substitution(Machine(cabine_movimento),atualizar_peso)==(novo_peso: NATURAL & direcao = parado | peso,limite_peso_atingido:=novo_peso,bool(novo_peso>peso_maximo));
  Expanded_List_Substitution(Machine(cabine_movimento),remover_chave_manutencao)==(chave_manutencao = TRUE & (manutencao = TRUE & direcao = parado or manutencao_pendente = TRUE) | chave_manutencao,manutencao,manutencao_pendente,parada_pendente:=FALSE,FALSE,FALSE,parada_por_cancelamento);
  Expanded_List_Substitution(Machine(cabine_movimento),inserir_chave_manutencao)==(chave_manutencao = FALSE | chave_manutencao:=TRUE || (direcao = parado ==> manutencao,manutencao_pendente,porta_retida:=TRUE,FALSE,FALSE [] not(direcao = parado) ==> manutencao_pendente,parada_pendente:=TRUE,TRUE));
  List_Substitution(Machine(cabine_movimento),inserir_chave_manutencao)==(chave_manutencao:=TRUE || IF direcao = parado THEN manutencao:=TRUE || manutencao_pendente:=FALSE || porta_retida:=FALSE ELSE manutencao_pendente:=TRUE || parada_pendente:=TRUE END);
  List_Substitution(Machine(cabine_movimento),remover_chave_manutencao)==(chave_manutencao:=FALSE || manutencao:=FALSE || manutencao_pendente:=FALSE || parada_pendente:=parada_por_cancelamento);
  List_Substitution(Machine(cabine_movimento),atualizar_peso)==(peso:=novo_peso || limite_peso_atingido:=bool(novo_peso>peso_maximo));
  List_Substitution(Machine(cabine_movimento),ajustar_peso)==(peso:=peso+delta || limite_peso_atingido:=bool(peso+delta>peso_maximo));
  List_Substitution(Machine(cabine_movimento),avancar_tempo_porta)==(IF porta = aberta & segundos_porta_aberta<121 THEN segundos_porta_aberta:=segundos_porta_aberta+1 END || IF parar = TRUE THEN parada_por_cancelamento:=TRUE || parada_pendente:=TRUE END);
  List_Substitution(Machine(cabine_movimento),segurar_porta)==(IF direcao = parado & porta = aberta & manutencao = FALSE THEN porta_retida:=TRUE END);
  List_Substitution(Machine(cabine_movimento),liberar_porta)==(porta_retida:=FALSE);
  List_Substitution(Machine(cabine_movimento),iniciar_subida)==(direcao:=subindo || sentido_atendimento:=subindo);
  List_Substitution(Machine(cabine_movimento),iniciar_descida)==(direcao:=descendo || sentido_atendimento:=descendo);
  List_Substitution(Machine(cabine_movimento),subir)==(andar:=andar+1 || deslocamento:=deslocamento+1 || IF andar+1 = andar_maximo or parada_pendente = TRUE or andar+1: p_int\/p_sub or p_int\/p_sub\/p_des/\andar+2..andar_maximo = {} THEN direcao:=parado || IF manutencao_pendente = TRUE THEN manutencao:=TRUE || manutencao_pendente:=FALSE END END || parada_pendente:=FALSE || parada_por_cancelamento:=FALSE);
  List_Substitution(Machine(cabine_movimento),descer)==(andar:=andar-1 || deslocamento:=deslocamento+1 || IF parada_pendente = TRUE or andar-1: p_int\/p_des or p_int\/p_sub\/p_des/\0..andar-2 = {} THEN direcao:=parado || IF manutencao_pendente = TRUE THEN manutencao:=TRUE || manutencao_pendente:=FALSE END END || parada_pendente:=FALSE || parada_por_cancelamento:=FALSE);
  List_Substitution(Machine(cabine_movimento),inverter_sentido)==(IF sentido_atendimento = subindo THEN sentido_atendimento:=descendo ELSE sentido_atendimento:=subindo END);
  List_Substitution(Machine(cabine_movimento),abrir_porta)==(porta:=aberta || IF sentido_atendimento = parado & andar: p_sub THEN sentido_atendimento:=subindo ELSIF sentido_atendimento = parado & andar: p_des THEN sentido_atendimento:=descendo END || ultima_visita:=ultima_visita<+{andar|->deslocamento});
  List_Substitution(Machine(cabine_movimento),fechar_porta)==(porta:=fechada || segundos_porta_aberta:=0);
  List_Substitution(Machine(cabine_movimento),manter_porta)==(IF sentido_atendimento = parado & andar: p_sub THEN sentido_atendimento:=subindo ELSIF sentido_atendimento = parado & andar: p_des THEN sentido_atendimento:=descendo END);
  List_Substitution(Machine(cabine_movimento),entrar_em_reposo)==(sentido_atendimento:=parado);
  List_Substitution(Machine(cabine_movimento),consultar_parada_pendente)==(pendente:=parada_pendente);
  List_Substitution(Machine(cabine_movimento),consultar_estado)==(pavimento_exibido:=andar || direcao_exibida:=direcao);
  List_Substitution(Machine(cabine_movimento),consultar_deslocamento)==(total_deslocamento:=deslocamento);
  List_Substitution(Machine(cabine_movimento),consultar_peso)==(peso_atual:=peso || alerta_ativo:=limite_peso_atingido);
  List_Substitution(Machine(cabine_movimento),consultar_folga)==(folga:=peso_maximo-peso);
  List_Substitution(Machine(cabine_movimento),consultar_porta)==(estado_porta:=porta || tempo_aberta:=segundos_porta_aberta);
  List_Substitution(Machine(cabine_movimento),consultar_manutencao)==(chave_inserida:=chave_manutencao || manutencao_ativa:=manutencao || manutencao_aguardando:=manutencao_pendente);
  List_Substitution(Machine(cabine_movimento),consultar_visitas)==(visitados:=dom(ultima_visita) || nunca_visitados:={aa | aa: 0..andar_maximo & aa/:dom(ultima_visita)} || marcas:=ran(ultima_visita))
END
&
THEORY ListConstantsX IS
  List_Valuable_Constants(Machine(cabine_movimento))==(?);
  Inherited_List_Constants(Machine(cabine_movimento))==(?);
  List_Constants(Machine(cabine_movimento))==(?)
END
&
THEORY ListSetsX IS
  Set_Definition(Machine(cabine_movimento),PORTAS)==({aberta,fechada});
  Context_List_Enumerated(Machine(cabine_movimento))==(DIRECOES,PORTAS);
  Context_List_Defered(Machine(cabine_movimento))==(?);
  Context_List_Sets(Machine(cabine_movimento))==(DIRECOES,PORTAS);
  List_Valuable_Sets(Machine(cabine_movimento))==(?);
  Inherited_List_Enumerated(Machine(cabine_movimento))==(?);
  Inherited_List_Defered(Machine(cabine_movimento))==(?);
  Inherited_List_Sets(Machine(cabine_movimento))==(?);
  List_Enumerated(Machine(cabine_movimento))==(?);
  List_Defered(Machine(cabine_movimento))==(?);
  List_Sets(Machine(cabine_movimento))==(?);
  Set_Definition(Machine(cabine_movimento),DIRECOES)==({subindo,descendo,parado})
END
&
THEORY ListHiddenConstantsX IS
  Abstract_List_HiddenConstants(Machine(cabine_movimento))==(?);
  Expanded_List_HiddenConstants(Machine(cabine_movimento))==(?);
  List_HiddenConstants(Machine(cabine_movimento))==(?);
  External_List_HiddenConstants(Machine(cabine_movimento))==(?)
END
&
THEORY ListPropertiesX IS
  Abstract_List_Properties(Machine(cabine_movimento))==(btrue);
  Context_List_Properties(Machine(cabine_movimento))==(peso_maximo = 450 & andar_maximo: NATURAL & andar_maximo>0 & painel_externo: 0..andar_maximo <-> DIRECOES & painel_externo = (0..andar_maximo-1)*{subindo}\/(1..andar_maximo)*{descendo} & DIRECOES: FIN(INTEGER) & not(DIRECOES = {}) & PORTAS: FIN(INTEGER) & not(PORTAS = {}));
  Inherited_List_Properties(Machine(cabine_movimento))==(btrue);
  List_Properties(Machine(cabine_movimento))==(btrue)
END
&
THEORY ListSeenInfoX IS
  Seen_Internal_List_Operations(Machine(cabine_movimento),Machine(configuracao))==(?);
  Seen_Context_List_Enumerated(Machine(cabine_movimento))==(?);
  Seen_Context_List_Invariant(Machine(cabine_movimento))==(btrue);
  Seen_Context_List_Assertions(Machine(cabine_movimento))==(btrue);
  Seen_Context_List_Properties(Machine(cabine_movimento))==(btrue);
  Seen_List_Constraints(Machine(cabine_movimento))==(btrue);
  Seen_List_Operations(Machine(cabine_movimento),Machine(configuracao))==(?);
  Seen_Expanded_List_Invariant(Machine(cabine_movimento),Machine(configuracao))==(btrue)
END
&
THEORY ListANYVarX IS
  List_ANY_Var(Machine(cabine_movimento),inserir_chave_manutencao)==(?);
  List_ANY_Var(Machine(cabine_movimento),remover_chave_manutencao)==(?);
  List_ANY_Var(Machine(cabine_movimento),atualizar_peso)==(?);
  List_ANY_Var(Machine(cabine_movimento),ajustar_peso)==(?);
  List_ANY_Var(Machine(cabine_movimento),avancar_tempo_porta)==(?);
  List_ANY_Var(Machine(cabine_movimento),segurar_porta)==(?);
  List_ANY_Var(Machine(cabine_movimento),liberar_porta)==(?);
  List_ANY_Var(Machine(cabine_movimento),iniciar_subida)==(?);
  List_ANY_Var(Machine(cabine_movimento),iniciar_descida)==(?);
  List_ANY_Var(Machine(cabine_movimento),subir)==(?);
  List_ANY_Var(Machine(cabine_movimento),descer)==(?);
  List_ANY_Var(Machine(cabine_movimento),inverter_sentido)==(?);
  List_ANY_Var(Machine(cabine_movimento),abrir_porta)==(?);
  List_ANY_Var(Machine(cabine_movimento),fechar_porta)==(?);
  List_ANY_Var(Machine(cabine_movimento),manter_porta)==(?);
  List_ANY_Var(Machine(cabine_movimento),entrar_em_reposo)==(?);
  List_ANY_Var(Machine(cabine_movimento),consultar_parada_pendente)==(?);
  List_ANY_Var(Machine(cabine_movimento),consultar_estado)==(?);
  List_ANY_Var(Machine(cabine_movimento),consultar_deslocamento)==(?);
  List_ANY_Var(Machine(cabine_movimento),consultar_peso)==(?);
  List_ANY_Var(Machine(cabine_movimento),consultar_folga)==(?);
  List_ANY_Var(Machine(cabine_movimento),consultar_porta)==(?);
  List_ANY_Var(Machine(cabine_movimento),consultar_manutencao)==(?);
  List_ANY_Var(Machine(cabine_movimento),consultar_visitas)==(?)
END
&
THEORY ListOfIdsX IS
  List_Of_Ids(Machine(cabine_movimento)) == (? | ? | manutencao_pendente,manutencao,chave_manutencao,ultima_visita,segundos_porta_aberta,limite_peso_atingido,peso,parada_por_cancelamento,parada_pendente,sentido_atendimento,porta_retida,porta,deslocamento,direcao,andar | ? | inserir_chave_manutencao,remover_chave_manutencao,atualizar_peso,ajustar_peso,avancar_tempo_porta,segurar_porta,liberar_porta,iniciar_subida,iniciar_descida,subir,descer,inverter_sentido,abrir_porta,fechar_porta,manter_porta,entrar_em_reposo,consultar_parada_pendente,consultar_estado,consultar_deslocamento,consultar_peso,consultar_folga,consultar_porta,consultar_manutencao,consultar_visitas | ? | seen(Machine(configuracao)) | ? | cabine_movimento);
  List_Of_HiddenCst_Ids(Machine(cabine_movimento)) == (? | ?);
  List_Of_VisibleCst_Ids(Machine(cabine_movimento)) == (?);
  List_Of_VisibleVar_Ids(Machine(cabine_movimento)) == (? | ?);
  List_Of_Ids_SeenBNU(Machine(cabine_movimento)) == (?: ?);
  List_Of_Ids(Machine(configuracao)) == (peso_maximo,andar_maximo,painel_externo,DIRECOES,PORTAS,subindo,descendo,parado,aberta,fechada | ? | ? | ? | ? | ? | ? | ? | configuracao);
  List_Of_HiddenCst_Ids(Machine(configuracao)) == (? | ?);
  List_Of_VisibleCst_Ids(Machine(configuracao)) == (peso_maximo,andar_maximo,painel_externo);
  List_Of_VisibleVar_Ids(Machine(configuracao)) == (? | ?);
  List_Of_Ids_SeenBNU(Machine(configuracao)) == (?: ?)
END
&
THEORY VariablesEnvX IS
  Variables(Machine(cabine_movimento)) == (Type(manutencao_pendente) == Mvl(btype(BOOL,?,?));Type(manutencao) == Mvl(btype(BOOL,?,?));Type(chave_manutencao) == Mvl(btype(BOOL,?,?));Type(ultima_visita) == Mvl(SetOf(btype(INTEGER,?,?)*btype(INTEGER,?,?)));Type(segundos_porta_aberta) == Mvl(btype(INTEGER,?,?));Type(limite_peso_atingido) == Mvl(btype(BOOL,?,?));Type(peso) == Mvl(btype(INTEGER,?,?));Type(parada_por_cancelamento) == Mvl(btype(BOOL,?,?));Type(parada_pendente) == Mvl(btype(BOOL,?,?));Type(sentido_atendimento) == Mvl(etype(DIRECOES,?,?));Type(porta_retida) == Mvl(btype(BOOL,?,?));Type(porta) == Mvl(etype(PORTAS,?,?));Type(deslocamento) == Mvl(btype(INTEGER,?,?));Type(direcao) == Mvl(etype(DIRECOES,?,?));Type(andar) == Mvl(btype(INTEGER,?,?)))
END
&
THEORY OperationsEnvX IS
  Operations(Machine(cabine_movimento)) == (Type(consultar_visitas) == Cst(SetOf(btype(INTEGER,?,?))*SetOf(btype(INTEGER,?,?))*SetOf(btype(INTEGER,?,?)),No_type);Type(consultar_manutencao) == Cst(btype(BOOL,?,?)*btype(BOOL,?,?)*btype(BOOL,?,?),No_type);Type(consultar_porta) == Cst(etype(PORTAS,?,?)*btype(INTEGER,?,?),No_type);Type(consultar_folga) == Cst(btype(INTEGER,?,?),No_type);Type(consultar_peso) == Cst(btype(INTEGER,?,?)*btype(BOOL,?,?),No_type);Type(consultar_deslocamento) == Cst(btype(INTEGER,?,?),No_type);Type(consultar_estado) == Cst(btype(INTEGER,?,?)*etype(DIRECOES,?,?),No_type);Type(consultar_parada_pendente) == Cst(btype(BOOL,?,?),No_type);Type(entrar_em_reposo) == Cst(No_type,SetOf(btype(INTEGER,?,?))*SetOf(btype(INTEGER,?,?))*SetOf(btype(INTEGER,?,?)));Type(manter_porta) == Cst(No_type,SetOf(btype(INTEGER,?,?))*SetOf(btype(INTEGER,?,?))*SetOf(btype(INTEGER,?,?)));Type(fechar_porta) == Cst(No_type,No_type);Type(abrir_porta) == Cst(No_type,SetOf(btype(INTEGER,?,?))*SetOf(btype(INTEGER,?,?))*SetOf(btype(INTEGER,?,?)));Type(inverter_sentido) == Cst(No_type,No_type);Type(descer) == Cst(No_type,SetOf(btype(INTEGER,?,?))*SetOf(btype(INTEGER,?,?))*SetOf(btype(INTEGER,?,?)));Type(subir) == Cst(No_type,SetOf(btype(INTEGER,?,?))*SetOf(btype(INTEGER,?,?))*SetOf(btype(INTEGER,?,?)));Type(iniciar_descida) == Cst(No_type,No_type);Type(iniciar_subida) == Cst(No_type,No_type);Type(liberar_porta) == Cst(No_type,No_type);Type(segurar_porta) == Cst(No_type,No_type);Type(avancar_tempo_porta) == Cst(No_type,btype(BOOL,?,?));Type(ajustar_peso) == Cst(No_type,btype(INTEGER,?,?));Type(atualizar_peso) == Cst(No_type,btype(INTEGER,?,?));Type(remover_chave_manutencao) == Cst(No_type,No_type);Type(inserir_chave_manutencao) == Cst(No_type,No_type));
  Observers(Machine(cabine_movimento)) == (Type(consultar_visitas) == Cst(SetOf(btype(INTEGER,?,?))*SetOf(btype(INTEGER,?,?))*SetOf(btype(INTEGER,?,?)),No_type);Type(consultar_manutencao) == Cst(btype(BOOL,?,?)*btype(BOOL,?,?)*btype(BOOL,?,?),No_type);Type(consultar_porta) == Cst(etype(PORTAS,?,?)*btype(INTEGER,?,?),No_type);Type(consultar_folga) == Cst(btype(INTEGER,?,?),No_type);Type(consultar_peso) == Cst(btype(INTEGER,?,?)*btype(BOOL,?,?),No_type);Type(consultar_deslocamento) == Cst(btype(INTEGER,?,?),No_type);Type(consultar_estado) == Cst(btype(INTEGER,?,?)*etype(DIRECOES,?,?),No_type);Type(consultar_parada_pendente) == Cst(btype(BOOL,?,?),No_type))
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
