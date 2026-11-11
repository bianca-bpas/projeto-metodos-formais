# Validação do modelo

## Estado das evidências — 2026-11-11

As fontes foram atualizadas desde a execução nativa registrada abaixo. Os
arquivos `.pmi`/`.pog` e os hashes versionados em `provas/` são evidências
históricas e não certificam a revisão atual. Nesta revisão também foram
removidas as operações não alcançáveis/não chamadas de manutenção e parada
pendente, e eliminado um ramo repetido em `passo`. As provas nativas precisam
ser regeneradas antes de serem usadas como evidência da revisão atual. Os logs
completos são gerados localmente e não fazem parte do repositório.

As suítes ProB foram executadas novamente em 2026-11-11 na instância
`andar_maximo = 4`: 18/18 cenários HLR-005/008, 14/14 HLR-010, 13/13 bordas e
47/47 interações passaram. Cada runner cria uma cópia temporária do modelo
com a constante fixada; as fontes B versionadas permanecem genéricas.

## Resultado histórico da instância de cinco pavimentos — 2026-11-10

Este resultado foi gerado quando `andar_maximo = 4`. A configuração atual usa
`andar_maximo : NATURAL` com `andar_maximo > 0`; as obrigações de prova devem
ser regeneradas após as alterações recentes e os totais abaixo não certificam
as fontes atuais.

Atelier B Community 24.04.2, geração completa (`po … 0`) e provador nativo
em força 3, sem Z3, usando as fontes de `elevador/`.

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

Evidências históricas: [lote executável](../provas/reconciliar.batch),
[fontes e hashes](../provas/fontes.sha256)
e cópias dos arquivos `.pmi`/`.pog` em `provas/nativas/`.
Em uma instalação nova, crie um projeto no Atelier B e adicione as quatro
máquinas de `elevador/`. As bases geradas pelo Atelier B são locais e não são
versionadas.

Para repetir no workspace registrado, a partir da raiz:

```sh
/opt/atelierb-free-24.04.2/bin/bbatch -r=/opt/atelierb-free-24.04.2/etc/AtelierB -i="$PWD/provas/reconciliar.batch" > provas/atelier-reconciliacao.log 2>&1
python3 verificacao/hlr005_008/verificar.py /opt/ProB/probcli --andar-maximo 4
```

Na execução atual com `andar_maximo = 4`, o ProB concluiu **18/18 cenários**.
O cache é descartável e não é uma evidência versionada.
O verificador usa `segurando_*` e `interno_recusado`, sem os campos removidos
`tempo_*`. Logs individuais são gerados localmente em
`verificacao/hlr005_008/`. O resumo da execução histórica não é versionado;
uma nova execução deve preservar seus logs localmente para auditoria.
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

## Cenários da política HLR-010 — 2026-11-11

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

Esses 14 cenários são adicionais aos 18 de HLR-005/008. Testar a política não
prova justiça temporal nem minimização global.

## Fronteiras e interações — 2026-11-11

| Execução | Cobertura | Resultado |
|---|---|---|
| `hlr010/bordas.py` | Porta, repouso, chamadas locais opostas, empate, manutenção, sobrecarga e cancelamento em movimento | **13/13 aprovados no ProB**, andar máximo 4 |
| `hlr010/interacoes.py` | Todos os 13 botões válidos de pavimento em manutenção, cancelamento e liberação; abrir/fechar e ciclos de recusa | **47/47 aprovados no ProB**, andar máximo 4 |
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
As fontes B não permanecem idênticas aos hashes das 843 provas nativas; a
reconciliação está pendente após as alterações recentes.
