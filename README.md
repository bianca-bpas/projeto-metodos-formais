# Projeto de Métodos Formais — Controle de Elevador

Especificação de um controlador de elevador em B.

Para entender o funcionamento e simular o sistema, comece pelo
[`docs/guia-do-modelo.md`](docs/guia-do-modelo.md). Ele documenta a arquitetura,
o estado, todas as operações públicas, pré-condições, consultas e exemplos de
uso.

- `elevador/`: máquinas `configuracao`, `painel_pedidos`, `cabine_movimento` e `elevador`.
- `Controle Elevador.md`: requisitos.
- `docs/validacao.md`: resultados, reprodução e limites.
- `docs/auditoria-requisitos.md`: cobertura dos requisitos e pendências.
- `docs/decisões.md`: hipóteses e decisões de modelagem.
- `docs/diagrama-entidades.md`: entidades e correspondência com B.
- `provas/`: logs, lote nativo e identificação das fontes verificadas.
- `verificacao/hlr005_008/`: 18 cenários de cancelamento, manutenção e LEDs.
- `verificacao/hlr010/`: 14 cenários da política de manter o sentido e inverter ao fim da rodada.

## Validação histórica (instância de cinco pavimentos) — 2026-11-10

Os resultados abaixo foram obtidos antes de `andar_maximo` ser generalizado.
Eles se referem à instância em que `andar_maximo = 4`; as obrigações da versão
paramétrica precisam ser regeneradas e provadas novamente no Atelier B.

**ProB: 18/18 cenários aprovados. Atelier B: 843/843 obrigações provadas
nativamente em força 3, sem Z3 e sem obrigações pendentes.** São 0 de
`configuracao`, 444 de `painel_pedidos`, 55 de `cabine_movimento` e 344 de
`elevador`. Logs em `provas/atelier-reconciliacao.log` e
`provas/prob-reconciliacao.log`.

O workspace foi reconstruído como `reconciliacao_elevador`, com base em
`native/bdp/`, linguagem em `native/lang/` e fontes em `elevador/`.
Abra esse projeto pela lista do Atelier B. A base gerada é local; os logs e
as evidências de prova ficam disponíveis em `provas/`.

```sh
python3 verificacao/hlr005_008/verificar.py /opt/ProB/probcli
```

O cache ProB é gerado localmente e ignorado pelo Git.
Os **14/14 cenários adicionais de HLR-010 passaram** no ProB:

```sh
python3 verificacao/hlr010/verificar.py /opt/ProB/probcli
```

**HLR-010 não está integralmente cumprido:** justiça temporal e minimização
global permanecem pendentes. Provas de invariantes e cenários não demonstram
essas propriedades.

## Testes adicionais de borda

```sh
python3 verificacao/hlr010/exaustivo.py
python3 verificacao/hlr010/bordas.py /opt/ProB/probcli
python3 verificacao/hlr010/interacoes.py /opt/ProB/probcli
```

Resultados: **13/13 casos de borda e 47/47 interações aprovados no ProB**.
A projeção Python verificou exaustivamente **311.296 estados iniciais** com
pedidos fixos, sem bloqueios ambientais; isso não é exaustividade do modelo B
completo. Escopo, logs e instruções em
[verificacao/hlr010/README.md](verificacao/hlr010/README.md).
