# Validação do modelo

## Resultado histórico da instância de cinco pavimentos — 2026-11-10

Este resultado foi gerado quando `andar_maximo = 4`. Após a generalização para
`andar_maximo : NATURAL1`, as obrigações de prova devem ser regeneradas e
provadas novamente; portanto, os totais abaixo não certificam ainda a revisão
paramétrica.

Atelier B Community 24.04.2, geração completa (`po … 0`) e provador nativo
em força 3, sem Z3. Workspace reconstruído: `reconciliacao_elevador`, base
`native/bdp/`, linguagem `native/lang/`, fontes `elevador/`.

| Máquina | Obrigações | Provadas nativamente | Pendentes |
|---|---:|---:|---:|
| `configuracao` | 0 | 0 | 0 |
| `painel_pedidos` | 444 | 444 | 0 |
| `cabine_movimento` | 55 | 55 | 0 |
| `elevador` | 344 | 344 | 0 |
| **Total** | **843** | **843** | **0** |

### Inventário de obrigações pendentes por máquina/operação

Nenhuma: `configuracao`, `painel_pedidos`, `cabine_movimento` e `elevador`
têm zero obrigações pendentes em todas as operações. O log contém os totais
por operação e as consultas `us` com listas vazias. Não se aplicam ao modelo
atual as seis pendências da antiga representação por funções temporizadoras.

Evidências: [log nativo](../provas/atelier-reconciliacao.log),
[lote executável](../provas/reconciliar.batch), [fontes e hashes](../provas/fontes.sha256)
e cópias dos arquivos `.pmi`/`.pog` em `provas/nativas/`.
Em uma instalação nova, crie no Atelier B o projeto `reconciliacao_elevador`,
com diretórios de base `native/bdp/` e linguagem `native/lang/`, e adicione as
quatro máquinas de `elevador/`. Os diretórios antigos `bdp/` e `elevador/bdp/`
eram bases duplicadas e foram removidos. O workspace nativo atual foi mantido.

Para repetir no workspace registrado, a partir da raiz:

```sh
/opt/atelierb-free-24.04.2/bin/bbatch -r=/opt/atelierb-free-24.04.2/etc/AtelierB -i="$PWD/provas/reconciliar.batch" > provas/atelier-reconciliacao.log 2>&1
python3 verificacao/hlr005_008/verificar.py /opt/ProB/probcli
```

O ProB concluiu **18/18 cenários**, após regeneração do cache `elevador/elevador.prob`. O cache é descartável,
foi removido na limpeza e será recriado pelo ProB; não é uma evidência versionada.
O verificador usa `segurando_*` e `interno_recusado`, sem os campos removidos
`tempo_*`. Logs individuais em `verificacao/hlr005_008/` e
[resumo da execução](../provas/prob-reconciliacao.log).
Os cenários conferem cancelamento no terceiro tick, liberação, preservação do
último interno, manutenção e os retornos dos LEDs em todas as quatro fases e
no estado estável. Cada tick representa um segundo. A recusa permanece em
`interno_recusado` até a liberação, sem reiniciar automaticamente a piscada.

**Limites:** são cenários, não exploração exaustiva. As provas nativas atestam
as obrigações geradas do modelo, não a completude dos requisitos.
HLR-010 permanece pendente quanto à justiça temporal e minimização global;
não há prova de atendimento eventual e a política local não garante percurso
ótimo. A interpretação da exceção de cancelamento permanece restrita ao último
pedido interno.

## Cenários da política HLR-010 — 2026-11-10

**14/14 cenários adicionais aprovados** com o ProB, definidos em
[cenarios.py](../verificacao/hlr010/cenarios.py) e executados por
[verificar.py](../verificacao/hlr010/verificar.py). O
[resumo](../verificacao/hlr010/resultados.txt), traces e logs individuais
estão em `verificacao/hlr010/`.

A política solicitada mantém o sentido atual enquanto houver pedidos adiante,
invertendo ao fim da rodada. Os testes verificam subida e descida, pedidos
novos atrás da cabine, paradas intermediárias, retomada, atendimento no retorno,
chamada externa oposta e inversão antes dos limites do prédio. Eles conferem
estados intermediários e a ordem de atendimento, além dos pedidos restantes.

Esses 14 cenários são adicionais aos 18 de HLR-005/008. As fontes B não foram
alteradas; seus hashes continuam iguais aos registrados nas provas nativas.
Testar a política não prova justiça temporal nem minimização global.

## Fronteiras e interações — 2026-11-10

| Execução | Cobertura | Resultado |
|---|---|---|
| `hlr010/bordas.py` | Porta, repouso, chamadas locais opostas, empate, manutenção, sobrecarga e cancelamento em movimento | **13/13 aprovados no ProB** |
| `hlr010/interacoes.py` | Todos os 13 botões válidos de pavimento em manutenção, cancelamento e liberação; abrir/fechar e ciclos de recusa | **47/47 aprovados no ProB** |
| `hlr010/exaustivo.py` | Projeção finita da política com pedidos fixos | **311.296 estados iniciais, 7.591.528 transições, zero falhas** |

Esses 60 cenários ProB são adicionais aos 18 de HLR-005/008 e 14 de HLR-010
já registrados: 92 cenários aprovados no conjunto das execuções. Logs e traces
novos ficam em `verificacao/hlr010/bordas/` e `verificacao/hlr010/interacoes/`.
A enumeração Python registra os números em
[exaustivo.json](../verificacao/hlr010/exaustivo.json); o maior percurso exigiu
38 passos até repouso sem pedidos. A ordem de atendimento de chamadas opostas
no mesmo andar prioriza subida quando o sentido anterior é parado.

A exaustividade vale somente para a projeção Python documentada no
[guia dos testes](../verificacao/hlr010/README.md): todos os conjuntos válidos
de pedidos, andares, sentidos, portas e movimentos coerentes com os limites,
sem novas chamadas ou interferências durante cada percurso. A projeção é uma
tradução manual, não um refinamento formalmente provado do B. As matrizes ProB
são cenários finitos: não enumeram todas as sequências ou interações ambientais.
Peso, deslocamento e marcas de visita tornam o modelo completo infinito.
Não se afirma verificação exaustiva do modelo completo nem justiça temporal.
As fontes B permaneceram idênticas aos hashes das 843 provas nativas.
