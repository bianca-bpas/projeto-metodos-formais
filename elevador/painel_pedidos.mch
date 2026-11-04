/* painel_pedidos
 * Author: win11
 * Creation date: 03/11/2026
 */
MACHINE
    painel_pedidos
    
CONSTANTS
    min_andar, max_andar
PROPERTIES
    min_andar = 0 &
    max_andar = 4
    
VARIABLES
    pedidos_internos, /* a cada andar fazer uma subtração de conjuntos */
    pedidos_subida,
    pedidos_descida,

    piscando_interno,
    piscando_subida,
    piscando_descida
    
INVARIANT
    pedidos_internos <: min_andar..max_andar &
    pedidos_subida <: min_andar..max_andar-1 &
    pedidos_descida <: min_andar+1..max_andar &

    piscando_interno <: min_andar..max_andar &
    piscando_subida <: min_andar..(max_andar - 1) &
    piscando_descida <: (min_andar + 1)..max_andar
    
INITIALISATION
    pedidos_internos := {} ||
    pedidos_subida := {} ||
    pedidos_descida := {} ||
    piscando_interno := {} ||
    piscando_subida := {} ||
    piscando_descida := {}
OPERATIONS
    cancelamento_interno(alvo) =
        PRE
            alvo : pedidos_internos
        THEN
            IF card(pedidos_internos) = 1 THEN
                piscando_interno := piscando_interno \/ {alvo}
            ELSE
                pedidos_internos := pedidos_internos - {alvo}
            END
        END
            
END
