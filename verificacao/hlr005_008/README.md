# HLR-005 e HLR-008

Na raiz do projeto:

```sh
python3 verificacao/hlr005_008/verificar.py /opt/ProB/probcli
```

O script gera e reproduz 18 traces no ProB. Cada cenário verifica um predicado
final; os cenários de piscada também verificam os valores de retorno de
`consultar_leds` e, na manutenção, de `consultar_leds_porta`.

Cobertura: limite de dois/três segundos, liberação antecipada, cancelamento
automático com parada em movimento, cancelamentos internos simultâneos,
preservação do último interno, entrada/saída de manutenção e quatro fases
de LED com retorno ao estado estável. Uma fase avança por segundo, salvo
uso explícito da operação de avanço da animação.

Os logs acompanham os traces no repositório. A execução de 2026-11-10 concluiu
18/18 cenários. São testes de cenários, não prova exaustiva. Consulte
`docs/validacao.md` para as 843/843 obrigações nativas provadas e os limites
quanto a HLR-010.
