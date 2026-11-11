# Cenários HLR-010 — política de varredura

A política testada mantém o sentido de atendimento enquanto existem pedidos
adiante e inverte quando eles acabam. A cabine pode parar para atendimento
sem abandonar esse sentido. Não é necessário chegar ao limite do prédio.

Na raiz do projeto (Python 3 e ProB instalados):

```sh
python3 verificacao/hlr010/verificar.py /opt/ProB/probcli --andar-maximo 4
```

Para executar somente um cenário:

```sh
python3 verificacao/hlr010/verificar.py /opt/ProB/probcli --cenario inversao_antes_do_topo --andar-maximo 4
```

`--andar-maximo` fixa a instância usada pelos traces (padrão: `4`). O script
cria uma cópia temporária das máquinas com essa propriedade adicional; as
fontes do projeto não são modificadas. Use um valor compatível com os
pavimentos usados nos cenários executados.

`cenarios.py` define 14 traces e seus predicados esperados. `verificar.py`
reproduz cada trace no modelo B, verifica sucesso do replay e verdade do
predicado, salva `.trace`/`.log` e retorna código diferente de zero se houver
falha. O resumo completo fica em `resultados.txt`; execuções isoladas geram
`resultado-<cenario>.txt`. O script também funciona fora da raiz do projeto.

Cobertura:

- Continuidade de subida e descida quando chega um pedido atrás da cabine.
- Atendimento intermediário e retomada do mesmo sentido.
- Inversão após o último pedido adiante e atendimento dos pedidos no retorno.
- Chamada externa de descida aguardando a volta durante uma subida.
- Inversão antes do topo ou térreo quando não há pedidos mais adiante.

Os pedidos são liberados imediatamente após pressionar os botões para separar
a política de atendimento da política de cancelamento. Os cenários verificam
posição, movimento, sentido de atendimento, pedidos restantes e histórico de
paradas. Cada execução começa em uma nova inicialização do modelo.

São testes finitos da política solicitada, não prova temporal de justiça nem
garantia de percurso globalmente mínimo. As provas nativas permanecem separadas.

## Fronteiras e interações

```sh
python3 verificacao/hlr010/exaustivo.py
python3 verificacao/hlr010/bordas.py /opt/ProB/probcli --andar-maximo 4
python3 verificacao/hlr010/interacoes.py /opt/ProB/probcli --andar-maximo 4
```

`exaustivo.py` enumera a projeção Python da política: todos os 32 conjuntos de
pedidos internos, 16 de subida e 16 de descida; todos os cinco andares;
cabine parada com cada sentido e porta aberta/fechada; cabine em movimento
nos sentidos compatíveis com os limites. Confere limites, porta, monotonicidade
dos pedidos, atendimento compatível, inversão apenas sem pedidos adiante e
conclusão em repouso sem ciclos. Não usa um corte arbitrário de passos: detecta
repetição de estado. Resultado em `exaustivo.json`.

Essa enumeração é exaustiva **apenas nessa projeção finita**, traduzida manualmente
do B. Durante cada percurso não chegam pedidos novos, não há cancelamentos,
manutenção, sobrecarga ou intervenções na porta. Não constitui equivalência
formal entre Python e B nem prova de justiça do sistema completo.

`bordas.py` executa 13 cenários reais no ProB: repouso, atendimento local,
prioridade entre chamadas opostas no mesmo andar, empate, porta, manutenção,
retomada após sobrecarga, cancelamento durante descida e pesos 0/449/450/451.
Logs, traces e resumo ficam em `bordas/`.

`interacoes.py` executa 47 cenários reais no ProB. Para cada um dos 13 botões
válidos de pavimento verifica recusa em manutenção após parada em movimento,
cancelamento no terceiro tick e liberação no segundo tick. Também testa abrir
e fechar em manutenção/movimento, saída de manutenção, repetição de botão,
recusa sem reinício de piscada e novo ciclo após liberação. Logs em `interacoes/`.
Essas matrizes não enumeram todas as sequências possíveis de intervenções.

A configuração completa possui domínios infinitos (peso, deslocamento e marcas
de visita) e sequências de chamadas sem limite. Portanto, não se alega teste
exaustivo do modelo completo, nem cobertura de toda combinação entre subsistemas.
