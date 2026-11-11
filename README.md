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
- `provas/`: lote nativo, arquivos de prova e hashes versionados.
- `verificacao/hlr005_008/`: 18 cenários de cancelamento, manutenção e LEDs.
- `verificacao/hlr010/`: 14 cenários da política de manter o sentido e inverter ao fim da rodada.

## Validação e estado das evidências — 2026-11-11

Os resultados de prova nativa abaixo são históricos: foram obtidos em
`2026-11-10`, antes das correções mais recentes em `cabine_movimento.mch`.
Eles se referem à instância em que `andar_maximo = 4` e não certificam o
estado atual das fontes. As obrigações precisam ser regeneradas e provadas
novamente no Atelier B.

**ProB: 18/18 cenários HLR-005/008 aprovados na execução atual com
`andar_maximo = 4`. Atelier B: 843/843 obrigações provadas nativamente
em força 3, sem Z3 e sem obrigações pendentes na execução histórica.** São 0 de
`configuracao`, 444 de `painel_pedidos`, 55 de `cabine_movimento` e 344 de
`elevador`. Os logs completos não são versionados. Os arquivos nativos, o
lote e os hashes em `provas/` são históricos; como os hashes não coincidem com
as fontes atuais, as obrigações do Atelier B precisam ser regeneradas.

O workspace histórico foi reconstruído localmente no Atelier B, usando as
fontes em `elevador/`. As bases geradas e os logs não fazem parte deste
repositório.

Para regenerar e provar as obrigações no projeto local `elevador_atual`, rode
na raiz do repositório:

```sh
printf 'open_project elevador_atual\ncd elevador\npo configuracao 0\npr configuracao 3\npo painel_pedidos 0\npr painel_pedidos 3\npo cabine_movimento 0\npr cabine_movimento 3\npo elevador 0\npr elevador 3\nsg\nq\n' \
  | /opt/atelierb-free-24.04.2/bin/bbatch \
      -r=/opt/atelierb-free-24.04.2/etc/AtelierB
```

O comando gera (`po`) e prova (`pr`) as obrigações de cada máquina; `sg`
salva o projeto antes de sair. Os números de obrigações e resultados atuais
devem ser conferidos na saída do Atelier B.

```sh
python3 verificacao/hlr005_008/verificar.py /opt/ProB/probcli --andar-maximo 4
```

O cache ProB é gerado localmente e ignorado pelo Git.
Os **14/14 cenários adicionais de HLR-010 passaram** no ProB com andar
máximo 4:

```sh
python3 verificacao/hlr010/verificar.py /opt/ProB/probcli --andar-maximo 4
```

**HLR-010 não está integralmente cumprido:** justiça temporal e minimização
global permanecem pendentes. Provas de invariantes e cenários não demonstram
essas propriedades.

## Testes adicionais de borda

```sh
python3 verificacao/hlr010/exaustivo.py
python3 verificacao/hlr010/bordas.py /opt/ProB/probcli --andar-maximo 4
python3 verificacao/hlr010/interacoes.py /opt/ProB/probcli --andar-maximo 4
```

Na execução atual, com andar máximo 4, passaram **13/13 casos de borda e
47/47 interações no ProB**.
A projeção Python verificou exaustivamente **311.296 estados iniciais** com
pedidos fixos, sem bloqueios ambientais; isso não é exaustividade do modelo B
completo. Escopo, logs e instruções em
[verificacao/hlr010/README.md](verificacao/hlr010/README.md).
