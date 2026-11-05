/* painel_pedidos
 * Author: win11
 * Creation date: 03/11/2026
 */
MACHINE
    painel_pedidos

SEES
    configuracao

CONSTANTS
    min_andar, max_andar

PROPERTIES
    min_andar = 0 &
    max_andar = 4

VARIABLES
    tempo_interno, tempo_subida, tempo_descida,
    pedidos_internos,
    pedidos_subida,
    pedidos_descida,

    piscando_interno1,
    piscando_subida1,
    piscando_descida1,
    piscando_interno2,
    piscando_subida2,
    piscando_descida2

INVARIANT
    tempo_interno : (min_andar..max_andar) --> (-1..3) &
    tempo_subida : (min_andar..(max_andar - 1)) --> (-1..3) &
    tempo_descida : ((min_andar + 1)..max_andar) --> (-1..3) &
    pedidos_internos <: min_andar..max_andar &
    pedidos_subida <: min_andar..(max_andar - 1) &
    pedidos_descida <: (min_andar + 1)..max_andar &

    piscando_interno1 <: min_andar..max_andar &
    piscando_subida1 <: min_andar..(max_andar - 1) &
    piscando_descida1 <: (min_andar + 1)..max_andar &
    piscando_interno2 <: min_andar..max_andar &
    piscando_subida2 <: min_andar..(max_andar - 1) &
    piscando_descida2 <: (min_andar + 1)..max_andar

INITIALISATION
    tempo_interno := (min_andar..max_andar) * {-1} ||
    tempo_subida := (min_andar..(max_andar - 1)) * {-1} ||
    tempo_descida := ((min_andar + 1)..max_andar) * {-1} ||
    pedidos_internos := {} ||
    pedidos_subida := {} ||
    pedidos_descida := {} ||
    piscando_interno1 := {} ||
    piscando_subida1 := {} ||
    piscando_descida1 := {} ||
    piscando_interno2 := {} ||
    piscando_subida2 := {} ||
    piscando_descida2 := {}

OPERATIONS
    liberar_interno(alvo) =
        PRE alvo : min_andar..max_andar
        THEN tempo_interno(alvo) := -1 END;

    liberar_subida(alvo) =
        PRE alvo : min_andar..(max_andar - 1)
        THEN tempo_subida(alvo) := -1 END;

    liberar_descida(alvo) =
        PRE alvo : (min_andar + 1)..max_andar
        THEN tempo_descida(alvo) := -1 END;

    /* -1: solto; 0..3: pressao continua. So os valores 0..2 avancam. */
    avancar_tempo_botoes =
        BEGIN
            tempo_interno := tempo_interno <+
                %pavimento.(pavimento : (min_andar..max_andar) & tempo_interno(pavimento) : 0..2 | tempo_interno(pavimento) + 1) ||
            tempo_subida := tempo_subida <+
                %pavimento.(pavimento : (min_andar..(max_andar - 1)) & tempo_subida(pavimento) : 0..2 | tempo_subida(pavimento) + 1) ||
            tempo_descida := tempo_descida <+
                %pavimento.(pavimento : ((min_andar + 1)..max_andar) & tempo_descida(pavimento) : 0..2 | tempo_descida(pavimento) + 1)
        END;

    cancelar_todos =
        BEGIN
            tempo_interno := (min_andar..max_andar) * {-1} ||
            tempo_subida := (min_andar..(max_andar - 1)) * {-1} ||
            tempo_descida := ((min_andar + 1)..max_andar) * {-1} ||
            pedidos_internos := {} || pedidos_subida := {} || pedidos_descida := {} ||
            piscando_interno1 := {} || piscando_interno2 := {} ||
            piscando_subida1 := {} || piscando_subida2 := {} ||
            piscando_descida1 := {} || piscando_descida2 := {}
        END;

    cancelamento_interno(alvo) =
        PRE
            alvo : pedidos_internos
        THEN
            IF card(pedidos_internos) = 1 THEN
                piscando_interno1 := piscando_interno1 \/ {alvo} ||
                piscando_interno2 := piscando_interno2 - {alvo} ||
                tempo_interno(alvo) := -1
            ELSE
                pedidos_internos := pedidos_internos - {alvo} ||
                piscando_interno1 := piscando_interno1 - {alvo} ||
                piscando_interno2 := piscando_interno2 - {alvo} ||
                tempo_interno(alvo) := -1
            END
        END;
/* Operação unificada para atender e limpar pedidos do andar ao abrir pavimento porta */
    atender_pedidos_andar(alvo, sentido) =
        PRE
            alvo : min_andar..max_andar &
            sentido : DIRECOES
        THEN
            IF alvo : pedidos_internos THEN
                pedidos_internos := pedidos_internos - {alvo} ||
                piscando_interno1 := piscando_interno1 - {alvo} ||
                piscando_interno2 := piscando_interno2 - {alvo} ||
                tempo_interno(alvo) := -1
            END ||
            IF (sentido = subindo or sentido = parado) & alvo : pedidos_subida THEN
                pedidos_subida := pedidos_subida - {alvo} ||
                piscando_subida1 := piscando_subida1 - {alvo} ||
                piscando_subida2 := piscando_subida2 - {alvo} ||
                tempo_subida(alvo) := -1
            END ||
            IF (sentido = descendo or (sentido = parado & alvo /: pedidos_subida)) & alvo : pedidos_descida THEN
                pedidos_descida := pedidos_descida - {alvo} ||
                piscando_descida1 := piscando_descida1 - {alvo} ||
                piscando_descida2 := piscando_descida2 - {alvo} ||
                tempo_descida(alvo) := -1
            END
        END;

    cancelamento_externo_subida(alvo) =
        PRE
            alvo : pedidos_subida
        THEN
            pedidos_subida := pedidos_subida - {alvo} ||
                piscando_subida1 := piscando_subida1 - {alvo} ||
                piscando_subida2 := piscando_subida2 - {alvo} ||
                tempo_subida(alvo) := -1
        END;

    cancelamento_externo_descida(alvo) =
        PRE
            alvo : pedidos_descida
        THEN
            pedidos_descida := pedidos_descida - {alvo} ||
                piscando_descida1 := piscando_descida1 - {alvo} ||
                piscando_descida2 := piscando_descida2 - {alvo} ||
                tempo_descida(alvo) := -1
        END;

    pedir_interno(alvo) =
        PRE
            alvo : min_andar..max_andar
        THEN
            pedidos_internos := pedidos_internos \/ {alvo} || tempo_interno(alvo) := 0
        END;

    pedir_externo_descida(alvo) =
        PRE
            alvo : (min_andar + 1)..max_andar
        THEN
            pedidos_descida := pedidos_descida \/ {alvo} || tempo_descida(alvo) := 0
        END;

    pedir_externo_subida(alvo) =
        PRE
            alvo : min_andar..(max_andar - 1)
        THEN
            pedidos_subida := pedidos_subida \/ {alvo} || tempo_subida(alvo) := 0
        END;

    piscar_interno(alvo) =
        PRE
            alvo : min_andar..max_andar
        THEN
            piscando_interno1 := piscando_interno1 \/ {alvo}
        END;

    piscar_descida(alvo) =
        PRE
            alvo : (min_andar + 1)..max_andar
        THEN
            piscando_descida1 := piscando_descida1 \/ {alvo}
        END;

    piscar_subida(alvo) =
        PRE
            alvo : min_andar..(max_andar - 1)
        THEN
            piscando_subida1 := piscando_subida1 \/ {alvo}
        END;

    parar_piscar =
        PRE
            piscando_interno1 /= {} or piscando_interno2 /= {} or
            piscando_subida1 /= {}  or piscando_subida2 /= {}  or
            piscando_descida1 /= {} or piscando_descida2 /= {}
        THEN
            piscando_interno1 := {} ||
            piscando_interno2 := piscando_interno1 ||

            piscando_subida1 := {} ||
            piscando_subida2 := piscando_subida1 ||

            piscando_descida1 := {} ||
            piscando_descida2 := piscando_descida1
        END
END