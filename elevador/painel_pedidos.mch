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
    cancelamento_interno(alvo) =
        PRE
            alvo : pedidos_internos
        THEN
            IF card(pedidos_internos) = 1 THEN
                piscando_interno1 := piscando_interno1 \/ {alvo}
            ELSE
                pedidos_internos := pedidos_internos - {alvo}
            END
        END;
/* Operação unificada para atender e limpar pedidos do andar ao abrir a porta */
    atender_pedidos_andar(alvo, sentido) =
        PRE
            alvo : min_andar..max_andar &
            sentido : DIRECOES
        THEN
            IF alvo : pedidos_internos THEN
                pedidos_internos := pedidos_internos - {alvo}
            END ||
            IF (sentido = subindo or sentido = parado) & alvo : pedidos_subida THEN
                pedidos_subida := pedidos_subida - {alvo}
            END ||
            IF (sentido = descendo or (sentido = parado & alvo /: pedidos_subida)) & alvo : pedidos_descida THEN
                pedidos_descida := pedidos_descida - {alvo}
            END
        END;

    cancelamento_externo_subida(alvo) =
        PRE
            alvo : pedidos_subida
        THEN
            pedidos_subida := pedidos_subida - {alvo}
        END;

    cancelamento_externo_descida(alvo) =
        PRE
            alvo : pedidos_descida
        THEN
            pedidos_descida := pedidos_descida - {alvo}
        END;

    pedir_interno(alvo) = 
        PRE
            alvo : min_andar..max_andar 
        THEN
            pedidos_internos := pedidos_internos \/ {alvo}
        END;

    pedir_externo_descida(alvo) = 
        PRE
            alvo : (min_andar + 1)..max_andar 
        THEN
            pedidos_descida := pedidos_descida \/ {alvo}
        END;

    pedir_externo_subida(alvo) = 
        PRE
            alvo : min_andar..(max_andar - 1)
        THEN
            pedidos_subida := pedidos_subida \/ {alvo}
        END;

    piscar_interno(alvo) = 
        PRE 
            alvo : pedidos_internos
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