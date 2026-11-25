Normalised(
THEORY MagicNumberX IS
  MagicNumber(Machine(configuracao))==(3.5)
END
&
THEORY UpperLevelX IS
  First_Level(Machine(configuracao))==(Machine(configuracao));
  Level(Machine(configuracao))==(0)
END
&
THEORY LoadedStructureX IS
  Machine(configuracao)
END
&
THEORY ListSeesX IS
  List_Sees(Machine(configuracao))==(?)
END
&
THEORY ListUsesX IS
  List_Uses(Machine(configuracao))==(?)
END
&
THEORY ListIncludesX IS
  Inherited_List_Includes(Machine(configuracao))==(?);
  List_Includes(Machine(configuracao))==(?)
END
&
THEORY ListPromotesX IS
  List_Promotes(Machine(configuracao))==(?)
END
&
THEORY ListExtendsX IS
  List_Extends(Machine(configuracao))==(?)
END
&
THEORY ListVariablesX IS
  External_Context_List_Variables(Machine(configuracao))==(?);
  Context_List_Variables(Machine(configuracao))==(?);
  Abstract_List_Variables(Machine(configuracao))==(?);
  Local_List_Variables(Machine(configuracao))==(?);
  List_Variables(Machine(configuracao))==(?);
  External_List_Variables(Machine(configuracao))==(?)
END
&
THEORY ListVisibleVariablesX IS
  Inherited_List_VisibleVariables(Machine(configuracao))==(?);
  Abstract_List_VisibleVariables(Machine(configuracao))==(?);
  External_List_VisibleVariables(Machine(configuracao))==(?);
  Expanded_List_VisibleVariables(Machine(configuracao))==(?);
  List_VisibleVariables(Machine(configuracao))==(?);
  Internal_List_VisibleVariables(Machine(configuracao))==(?)
END
&
THEORY ListInvariantX IS
  Gluing_Seen_List_Invariant(Machine(configuracao))==(btrue);
  Gluing_List_Invariant(Machine(configuracao))==(btrue);
  Expanded_List_Invariant(Machine(configuracao))==(btrue);
  Abstract_List_Invariant(Machine(configuracao))==(btrue);
  Context_List_Invariant(Machine(configuracao))==(btrue);
  List_Invariant(Machine(configuracao))==(btrue)
END
&
THEORY ListAssertionsX IS
  Expanded_List_Assertions(Machine(configuracao))==(btrue);
  Abstract_List_Assertions(Machine(configuracao))==(btrue);
  Context_List_Assertions(Machine(configuracao))==(btrue);
  List_Assertions(Machine(configuracao))==(btrue)
END
&
THEORY ListCoverageX IS
  List_Coverage(Machine(configuracao))==(btrue)
END
&
THEORY ListExclusivityX IS
  List_Exclusivity(Machine(configuracao))==(btrue)
END
&
THEORY ListInitialisationX IS
  Expanded_List_Initialisation(Machine(configuracao))==(skip);
  Context_List_Initialisation(Machine(configuracao))==(skip);
  List_Initialisation(Machine(configuracao))==(skip)
END
&
THEORY ListParametersX IS
  List_Parameters(Machine(configuracao))==(?)
END
&
THEORY ListInstanciatedParametersX END
&
THEORY ListConstraintsX IS
  List_Context_Constraints(Machine(configuracao))==(btrue);
  List_Constraints(Machine(configuracao))==(btrue)
END
&
THEORY ListOperationsX IS
  Internal_List_Operations(Machine(configuracao))==(?);
  List_Operations(Machine(configuracao))==(?)
END
&
THEORY ListInputX END
&
THEORY ListOutputX END
&
THEORY ListHeaderX END
&
THEORY ListOperationGuardX END
&
THEORY ListPreconditionX END
&
THEORY ListSubstitutionX END
&
THEORY ListConstantsX IS
  List_Valuable_Constants(Machine(configuracao))==(peso_maximo,andar_maximo,painel_externo);
  Inherited_List_Constants(Machine(configuracao))==(?);
  List_Constants(Machine(configuracao))==(peso_maximo,andar_maximo,painel_externo)
END
&
THEORY ListSetsX IS
  Set_Definition(Machine(configuracao),DIRECOES)==({subindo,descendo,parado});
  Context_List_Enumerated(Machine(configuracao))==(?);
  Context_List_Defered(Machine(configuracao))==(?);
  Context_List_Sets(Machine(configuracao))==(?);
  List_Valuable_Sets(Machine(configuracao))==(?);
  Inherited_List_Enumerated(Machine(configuracao))==(?);
  Inherited_List_Defered(Machine(configuracao))==(?);
  Inherited_List_Sets(Machine(configuracao))==(?);
  List_Enumerated(Machine(configuracao))==(DIRECOES,PORTAS);
  List_Defered(Machine(configuracao))==(?);
  List_Sets(Machine(configuracao))==(DIRECOES,PORTAS);
  Set_Definition(Machine(configuracao),PORTAS)==({aberta,fechada})
END
&
THEORY ListHiddenConstantsX IS
  Abstract_List_HiddenConstants(Machine(configuracao))==(?);
  Expanded_List_HiddenConstants(Machine(configuracao))==(?);
  List_HiddenConstants(Machine(configuracao))==(?);
  External_List_HiddenConstants(Machine(configuracao))==(?)
END
&
THEORY ListPropertiesX IS
  Abstract_List_Properties(Machine(configuracao))==(btrue);
  Context_List_Properties(Machine(configuracao))==(btrue);
  Inherited_List_Properties(Machine(configuracao))==(btrue);
  List_Properties(Machine(configuracao))==(peso_maximo = 450 & andar_maximo: NATURAL & andar_maximo>0 & painel_externo: 0..andar_maximo <-> DIRECOES & painel_externo = (0..andar_maximo-1)*{subindo}\/(1..andar_maximo)*{descendo} & DIRECOES: FIN(INTEGER) & not(DIRECOES = {}) & PORTAS: FIN(INTEGER) & not(PORTAS = {}))
END
&
THEORY ListSeenInfoX END
&
THEORY ListANYVarX END
&
THEORY ListOfIdsX IS
  List_Of_Ids(Machine(configuracao)) == (peso_maximo,andar_maximo,painel_externo,DIRECOES,PORTAS,subindo,descendo,parado,aberta,fechada | ? | ? | ? | ? | ? | ? | ? | configuracao);
  List_Of_HiddenCst_Ids(Machine(configuracao)) == (? | ?);
  List_Of_VisibleCst_Ids(Machine(configuracao)) == (peso_maximo,andar_maximo,painel_externo);
  List_Of_VisibleVar_Ids(Machine(configuracao)) == (? | ?);
  List_Of_Ids_SeenBNU(Machine(configuracao)) == (?: ?)
END
&
THEORY SetsEnvX IS
  Sets(Machine(configuracao)) == (Type(DIRECOES) == Cst(SetOf(etype(DIRECOES,0,2)));Type(PORTAS) == Cst(SetOf(etype(PORTAS,0,1))))
END
&
THEORY ConstantsEnvX IS
  Constants(Machine(configuracao)) == (Type(subindo) == Cst(etype(DIRECOES,0,2));Type(descendo) == Cst(etype(DIRECOES,0,2));Type(parado) == Cst(etype(DIRECOES,0,2));Type(aberta) == Cst(etype(PORTAS,0,1));Type(fechada) == Cst(etype(PORTAS,0,1));Type(peso_maximo) == Cst(btype(INTEGER,?,?));Type(andar_maximo) == Cst(btype(INTEGER,?,?));Type(painel_externo) == Cst(SetOf(btype(INTEGER,?,?)*etype(DIRECOES,?,?))))
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
