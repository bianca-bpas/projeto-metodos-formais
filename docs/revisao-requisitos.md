# Revisão dos requisitos e casos de borda

Revisão de 05/11/2026 sobre as máquinas locais. Não foram alteradas as máquinas
B nesta revisão. A evidência combina inspeção das precondições e transições
com execução de cenários no ProB; não é prova exaustiva nem prova de vivacidade.

## Resultado por requisito

| Requisito | Avaliação | Evidência e limites |
| --- | --- | --- |
| HLR-001 | Representado na abstração | `consultar_estado` retorna andar e direção. Pressupõe que todos os visores consumam essa mesma saída; não modela visores físicos individualmente. |
| HLR-002 | Representado | Subida só aceita 0..3 e descida só 1..4. Os limites são precondições, não uma resposta de erro a entradas inválidas. |
| HLR-003 | Representado na abstração | Pedidos internos 0..4; abertura exige cabine parada fora da manutenção; fechamento exige porta aberta, que implica cabine parada pelo invariante. Visor usa `consultar_estado`. |
| HLR-004 | Parcial | Conjuntos representam LEDs de pedidos ativos e são limpos ao atender/cancelar. Entretanto, estados de piscada podem sobreviver à remoção do pedido; falta definir a prioridade entre LED apagado e piscando. |
| HLR-005 | Parcial | Cancelamento e rejeição do último pedido interno estão presentes. Não existe estado de botão pressionado nem contagem dos 3 segundos. As duas piscadas são duas etapas abstratas, sem sinal luminoso ou duração explícitos. |
| HLR-006 | Representado nos cenários | Cancelamento do último pedido externo em movimento solicita parada no próximo andar. Um novo pedido antes da chegada não elimina essa parada. O último interno não é cancelável. |
| HLR-007 | Representado com hipótese de relógio | Em 120 segundos não há aviso; em 121 há aviso externo. Fechar zera o contador. Depende de o ambiente chamar `passar_segundo`; após 121 o evento fica desabilitado, abstraindo o tempo posterior. |
| HLR-008 | Representado no nível de estados | Cancela todos os pedidos ao ativar manutenção, rejeita botões e informa avisos. Em movimento, para no próximo andar. As piscadas dependem de eventos externos para avançar. |
| HLR-009 | Representado com hipótese sobre a balança | 450 kg permitidos, 451 kg bloqueiam movimento nas precondições. `consultar_peso` fornece alerta. O peso só pode ser atualizado com a cabine parada; mudanças de leitura durante movimento estão fora do modelo. |
| HLR-010 | Não garantido | Há ciclos sem atendimento e escolha de direção sem comparação de custo. O contador mede deslocamento, mas não impõe minimização. |

## Achados reproduzidos

### 1. Atendimento eventual não é garantido — HLR-010

No estado inicial, executar `pressionar_interno(4)`. O par
`elevador_abrir_porta; elevador_fechar_porta` retorna ao mesmo estado completo,
com o pedido 4 ainda ativo e deslocamento zero. Pode ser repetido indefinidamente.
Nenhuma precondição, prioridade ou regra de progresso obriga a partida.

Isso demonstra ausência de garantia incondicional, não impossibilidade de
atender o pedido. É necessário especificar o controlador/escalonamento e as
hipóteses de justiça. Também é preciso excluir ou tratar explicitamente pedidos
cancelados, manutenção permanente, sobrecarga permanente e interferência
permanente nos botões de porta antes de formular atendimento eventual.

Local: `elevador.mch`, operações de movimento e de abertura/fechamento.

### 2. Escolha inicial não minimiza o deslocamento — HLR-010

Levar a cabine ao andar 1, atender o pedido e entrar em repouso. Adicionar
pedidos internos 0 e 4, sem novos pedidos ou cancelamentos depois disso.

- Escolher subida: 1 → 4 → 0, custo 7.
- Escolher descida: 1 → 0 → 4, custo 5.

Ambas as sequências são permitidas. Os testes verificam totais 8 e 6 porque
incluem o deslocamento inicial 0 → 1. O conjunto de pedidos e o estado inicial
da comparação são idênticos. Não há exigência de posição final nesse requisito.

Local: `elevador.mch`, `elevador_iniciar_subida` e `elevador_iniciar_descida`.
Definir o objetivo de otimização e uma política para decidir a direção em repouso.
Para pedidos futuros desconhecidos, a garantia pretendida precisa ser delimitada.

### 3. Cancelamento não exige os três segundos — HLR-005

`pressionar_externo_subida(2); elevador_cancelar_subida(2)` remove o pedido
sem qualquer evento temporal entre as operações. Se o cancelamento abstrato
representa um evento já reconhecido por hardware após três segundos, essa
hipótese precisa constar da especificação/refinamento. Caso contrário, falta
modelar pressão, liberação e duração.

Local: `elevador.mch`, operações `elevador_cancelar_*`.

### 4. Piscadas sobrevivem à remoção do pedido — HLR-004/005

Sequência: pedir interno 1; tentar cancelar (rejeitado); pedir interno 2;
cancelar interno 1 (aceito). Resultado: `pedidos_internos = {2}`, mas
`piscando_interno1 = {1}`. Também ocorre ao atender: pedir interno 0;
tentar cancelar; abrir porta. O pedido desaparece e a piscada permanece.

O modelo não fornece uma função que resolva a saída física do LED nesse
conflito. Se a marcação de piscada controla o LED, ele continua piscando após
a remoção, contrariando o apagamento ao atender/cancelar. Limpar as marcações
correspondentes ou definir explicitamente a prioridade da saída.

Local: `painel_pedidos.mch`, `cancelamento_interno` e `atender_pedidos_andar`.

## Casos de borda exercitados

As 11 regressões existentes cobrem pedidos opostos durante subida/descida,
peso limite, 120/121 segundos, manutenção parada/em movimento, retirada da chave
antes da parada, cancelamento interno rejeitado, parada por cancelamento externo,
manutenção na descida e manutenção com porta aberta/fim das piscadas.

Os 12 cenários adicionais cobrem os achados acima e:

- Pedido repetido sem duplicação e cancelamento com outro pedido interno ativo.
- Chamadas externas nas duas direções no mesmo andar, atendidas separadamente
  sem deslocar a cabine.
- Cancelamento durante descida até o térreo, com novo pedido antes da chegada.
- Pedidos adicionados durante manutenção pendente, todos cancelados ao parar.
- Pesos 0, 449, 450 e 451 kg.
- Reinício da contagem ao fechar e reabrir a porta após o aviso.

As proibições de entradas fora dos andares, abrir em movimento e partir com
sobrecarga foram inspecionadas nas precondições; estes cenários não tentam
executar operações fora de suas precondições.

## Reprodução

```sh
python3 tests/verificar.py /opt/ProB/probcli
python3 -B tests/bordas.py /opt/ProB/probcli
```

`bordas.py` contém testes marcados `LACUNA`: passar significa que o comportamento
problemático foi reproduzido, não que o requisito foi satisfeito. Cada passo
também avalia `@INVARIANT`. Preservar invariantes de segurança não demonstra
atendimento eventual ou custo mínimo. Ao corrigir o modelo, atualizar esses
testes para exigir o comportamento desejado.
