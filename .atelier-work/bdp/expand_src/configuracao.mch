MACHINE configuracao

SETS
    DIRECOES = { subindo , descendo , parado } ;
    PORTAS = { aberta , fechada }

CONCRETE_CONSTANTS
    peso_maximo ,
    andar_maximo ,
    painel_externo

PROPERTIES
    peso_maximo = 450 &
    /* O numero de andares e um parametro da instancia do predio.
       Ao menos dois pavimentos sao necessarios para haver subida e descida. */
    andar_maximo : NATURAL &
    andar_maximo > 0 &
    painel_externo : ( 0 .. andar_maximo ) <-> DIRECOES &
    painel_externo = ( ( 0 .. ( andar_maximo - 1 ) ) * { subindo } ) \/
                     ( ( 1 .. andar_maximo ) * { descendo } )

END
