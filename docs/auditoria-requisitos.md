# Auditoria dos requisitos — controle de elevador

## Atualização da animação — 2026-11-25

A retenção ambiental, a continuidade do contador e a entrega confirmada dos eventos
foram implementadas. Evidências atuais, separadas do histórico abaixo, estão em
[verificação da animação](../verificacao/animacao/README.md). HLR-010 permanece fora
desta implementação; a interpretação atual de HLR-005 foi preservada.

## Estado histórico da auditoria — 2026-11-11

Em 2026-11-11, passaram **28/28 cenários HLR-005/008, 14/14 HLR-010,
13/13 de borda e 47/47 de interação no ProB**, todos com
`andar_maximo = 4`. Os runners fixam a constante em cópias temporárias do
modelo. As **843/843 obrigações nativas** pertencem à execução histórica de
2026-11-10, sem Z3:
`configuracao` 0/0, `painel_pedidos` 444/444, `cabine_movimento` 55/55 e
`elevador` 344/344. Nenhuma obrigação pendente por máquina/operação.
A enumeração de 311.296 estados é restrita à projeção Python de pedidos fixos;
não demonstra justiça do modelo completo.
Evidências históricas e reprodução em [validacao.md](validacao.md). Os hashes
das provas não correspondem às fontes atuais após as alterações recentes em
`cabine_movimento.mch`; a prova nativa atual está pendente de regeneração.

HLR-005/008 foram implementados na abstração atual. Os cenários atuais conferem o cancelamento automático e as quatro fases de LED.
**Não há cumprimento total de HLR-010:** justiça temporal e minimização global
permanecem pendentes. Invariantes provados não demonstram vivacidade nem ótimo
global.

## Rastreabilidade

| Requisito | Avaliação | Evidência e limite |
|---|---|---|
| HLR-001 — visor externo | Atendido na abstração | `consultar_visores` e `consultar_estado` expõem andar/direção. Uma única saída representa a informação comum a todos os visores; não há dispositivos separados. |
| HLR-002 — botões externos | Atendido | `configuracao.painel_externo` permite subir em `0..(andar_maximo - 1)` e descer em `1..andar_maximo`; operações externas exigem pavimento e associação válidos. |
| HLR-003 — painel interno e porta | Atendido na abstração | Botões internos em `0..andar_maximo`; abrir/fechar só atuam com cabine parada. Retenção ambiental impede fechamento manual/automático e não abre a porta. `direcao /= parado => porta = fechada` é invariante. |
| HLR-004 — LED do pedido | Atendido como estado lógico | `consultar_leds` incorpora as quatro fases ligado/desligado/ligado/desligado e o estado estável, conferidos pelos cenários. |
| HLR-005 — cancelamento após três segundos | Implementado na abstração | Cancelamento automático no terceiro tick, usando conjuntos `segurando_*`; recusa do último interno em `interno_recusado`. Chamadas externas que continuam ativas permitem cancelar o último interno. |
| HLR-006 — parar no próximo andar após último cancelamento | Atendido quando o cancelamento é executado | Cancelamentos externos marcam `parada_por_cancelamento` e `parada_pendente`; `subir`/`descer` avançam um andar e param. A remoção da chave preserva essa parada, mesmo com novo pedido. Se nenhum outro pedido sobreviver ao tick, um pedido interno é preservado. |
| HLR-007 — aviso após dois minutos | Atendido com relógio abstrato | Tempo contínuo durante retenção/manutenção, sem reinício por pedido no mesmo andar; satura em 121, aviso é `segundos_porta_aberta > 120` e fechamento zera o contador. Depende de cada `passar_tempo` corresponder a um segundo. |
| HLR-008 — manutenção | Implementado na abstração | Chave com cabine parada cancela imediatamente; em movimento, para no próximo andar e cancela. Remover a chave antes da parada cancela a manutenção pendente e somente seu motivo de parada. Durante a manutenção, novos pedidos são recusados, avisos são expostos e a remoção libera manutenção. As quatro fases e os LEDs de porta são conferidos pelos cenários ProB. |
| HLR-009 — limite de 450 kg | Atendido na abstração | Sobrecarga somente se peso > 450; iniciar movimento e avançar exigem ausência de sobrecarga. Alterações de peso só são aceitas com cabine parada. Não há contagem de pessoas; seis pessoas é tratado como justificativa dos 450 kg. |
| HLR-010 — justiça e minimização | Não demonstrado integralmente; ótimo global refutado | Há política de varredura e escolha inicial pelo pedido mais próximo. Não há prova de vivacidade. Existe percurso não mínimo mesmo sem novas chamadas. |

## Pendências de requisitos

### Interpretação do último pedido interno

Uma chamada externa de subida ou descida conta como outro botão selecionado, inclusive no mesmo pavimento. Se ela continuar ativa no terceiro tick, o último pedido interno pode ser cancelado.

### Não há garantia de percurso mínimo

Exemplo registrado no [cenário complementar](../verificacao/cenarios/README.md): cabine em repouso no andar 1; pedidos internos
nos andares 0, 2 e 4; nenhuma nova chamada. O empate entre 0 e 2 escolhe subida.

- Percurso escolhido: `1 → 2 → 4 → 0`, distância **7**.
- Percurso alternativo: `1 → 0 → 2 → 4`, distância **5**.

A preparação do cenário desloca a cabine de 0 a 1. Por isso o contador final
do trace é 8: um deslocamento de preparação e sete de atendimento. Todos os
pedidos foram atendidos. O documento de decisões chama a estratégia de
“minimização local”, mas essa decisão não demonstra a minimização exigida se
o HLR-010 for interpretado como ótimo para os pedidos já conhecidos.

### Justiça não é consequência das provas de invariante

Não foi demonstrado que todo pedido não cancelado será eventualmente atendido.
É necessário especificar hipóteses de execução: `passo` deve continuar sendo
executado, manutenção e sobrecarga devem terminar e intervenções na porta não
podem impedir indefinidamente o progresso. O documento de decisões também
assume quantidade finita de novas chamadas. Falta validar uma propriedade
temporal sob essas hipóteses, ou uma variante de progresso adequada.

## Cobertura dos elementos de B exigidos na avaliação

| Elemento | Estado atual |
|---|---|
| Relações/funções e operações | Presentes: relação dos painéis e operações de consulta; temporizadores agora usam conjuntos aninhados. |
| Sequências | Presentes na sequência de histórico de paradas, com inserção, concatenação, `tail`, `first`, `last` e `size`. |
| Naturais/inteiros infinitos | Presentes em peso, deslocamento e ajuste de peso. |
| Compreensão de conjuntos | Não há construção explícita `{x | P}` na versão atual. A representação atual por conjuntos também removeu a lambda. |
| Operações de conjuntos | Presentes: pertinência, inclusão, união, interseção, diferença, produto cartesiano, domínio e imagem. |
| Operadores lógicos | Existencial, conjunção, disjunção, implicação, equivalência e negação presentes. Quantificação universal explícita foi removida na refatoração. |
| Substituições B | `PRE`, `BEGIN`, `IF`, `SELECT`, `ANY`, atribuições e paralelismo presentes. `LET` foi removido. A lista de avaliação cita exemplos, não exige necessariamente cada substituição. |
| Operações com/sem retorno | Presentes. |

O repositório contém uma especificação abstrata B, não uma implementação de
hardware ou de relógio real. As provas não garantem completude dos requisitos.
