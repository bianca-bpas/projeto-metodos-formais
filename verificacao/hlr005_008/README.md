# HLR-005 e HLR-008

Na raiz do projeto:

```sh
python3 verificacao/hlr005_008/verificar.py /opt/ProB/probcli --andar-maximo 4
```

`--andar-maximo` fixa a instância usada pelos traces (padrão: `4`). O script
cria uma cópia temporária das máquinas com essa propriedade adicional; as
fontes do projeto não são modificadas. Para a suíte completa, use um valor
compatível com os pavimentos dos cenários.

O script gera e reproduz 28 traces no ProB. Cada cenário verifica um predicado
final; os cenários de piscada também verificam os valores de retorno de
`consultar_leds` e, na manutenção, de `consultar_leds_porta`.

Cobertura: limite de dois/três segundos, liberação antecipada, cancelamento
automático com parada em movimento, cancelamentos internos simultâneos,
preservação do último interno, entrada/saída de manutenção e quatro fases
de LED com retorno ao estado estável. Uma fase avança por segundo, salvo
uso explícito da operação de avanço da animação.

Os dez cenários de remoção da chave cobrem subida e descida: cancelamento da
parada exclusiva de manutenção, reinserção da chave, dois ciclos de
inserção/remoção e cancelamento do último pedido antes/depois da inserção.
As consultas verificam `parada_pendente` antes e depois de remover a chave.
Nos casos do HLR-006, um novo pedido distante chega antes do próximo passo:
a cabine deve parar mesmo com esse pedido, preservá-lo e consumir a flag.

Os logs e traces são gerados localmente e ignorados pelo Git. A execução de 2026-11-11 com
`andar_maximo = 4` concluiu 28/28 cenários. São testes de cenários, não prova
exaustiva. Consulte
`docs/validacao.md` para as 843/843 obrigações nativas provadas e os limites
quanto a HLR-010.
