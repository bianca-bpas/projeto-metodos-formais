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
    andar_maximo

PROPERTIES
    peso_maximo = 450 &
    andar_maximo = 4

END