MACHINE configuracao

SETS
    DIRECOES = {subindo, descendo, parado};
    PORTAS = {aberta, fechada}

CONSTANTS
    peso_maximo,
    andar_maximo,
    painel_externo,
    proximo_tempo

PROPERTIES
    peso_maximo = 450 &
    andar_maximo = 4 &
    painel_externo : (0..andar_maximo) <-> DIRECOES &
    painel_externo = ((0..(andar_maximo - 1)) * {subindo}) \/
                     ((1..andar_maximo) * {descendo}) &
    proximo_tempo : (0..3) --> (0..3) &
    proximo_tempo = {(0|->1), (1|->2), (2|->3), (3|->3)}

END