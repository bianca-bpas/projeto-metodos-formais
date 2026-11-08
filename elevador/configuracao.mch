/* configuracao
 * Author: araujo
 * Creation date: 03/11/2026
 */
MACHINE configuracao

SETS
    DIRECOES = {subindo, descendo, parado};
    PORTAS = {aberta, fechada}

CONSTANTS
    peso_maximo,
    andar_maximo,
    painel_externo

PROPERTIES
    peso_maximo = 450 &
    andar_maximo = 4 &
    /* subindo = botao de seta para cima; descendo = botao de seta para baixo */
    painel_externo : (0..andar_maximo) <-> DIRECOES &
    painel_externo = ((0..(andar_maximo - 1)) * {subindo}) \/
                     ((1..andar_maximo) * {descendo})

END
