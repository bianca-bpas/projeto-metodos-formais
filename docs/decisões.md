# Decisões do projeto

## Limites do prédio

- O prédio possui cinco pavimentos, numerados de `0` a `4`.
- O pavimento `0` representa o térreo.
- Há botão externo de subida nos pavimentos `0..3` e de descida nos
  pavimentos `1..4`.

## Peso e sobrecarga

- A capacidade máxima é 450 kg.
- Acima desse limite, a cabine permanece parada até o peso ser reduzido.
- O aviso de sobrecarga aparece somente no visor interno.
- A alternativa de descer ao térreo com sobrecarga foi descartada porque
  contradiz o HLR-009.

## Pedidos, LEDs e cancelamento

- Os pedidos são mantidos em três conjuntos: cabine, subida e descida.
- Um pedido ativo representa também o LED correspondente aceso. Assim, não é
  necessário duplicar o estado em outro conjunto de LEDs.
- Pressionar novamente um pedido ativo não cria uma cópia; conjuntos tornam a
  operação idempotente.
- O contador de pressão vai de zero a três segundos. Ao atingir três, a
  operação de cancelamento fica habilitada.
- Pedidos externos podem ser cancelados mesmo quando forem o único pedido.
- O último pedido interno não pode ser cancelado: ele permanece ativo e passa
  por duas fases de piscada.
- Se o último pedido em curso for cancelado durante o movimento, a cabine para
  no próximo pavimento.

## Atendimento e prioridade

- Enquanto existe uma direção de atendimento, a cabine atende primeiro os
  pedidos compatíveis nessa direção e inverte quando não há pedidos adiante.
- Quando está sem direção e existem pedidos dos dois lados, escolhe o lado cujo
  pedido mais próximo exige o menor deslocamento. Em caso de empate, sobe.
- A justiça é considerada sob as hipóteses de que o controlador continua
  executando `passo`, a manutenção não permanece ativa para sempre, a
  sobrecarga é eventualmente removida e há uma quantidade finita de novas
  chamadas durante o atendimento. Sob essas hipóteses, o algoritmo LOOK
  percorre o conjunto finito de pavimentos sem abandonar pedidos pendentes.
- A minimização é uma política local: menor deslocamento para iniciar um novo
  ciclo e continuidade na direção atual. Não se afirma ótimo global diante de
  chamadas futuras desconhecidas.

## Porta e visores

- Os botões `pressionar_abrir` e `pressionar_fechar` só alteram a porta quando
  a cabine está parada.
- O próximo `passo` do controlador fecha uma porta aberta; o botão de fechar
  permite antecipar essa ação.
- Se o ambiente avançar o tempo por mais de 120 segundos antes do fechamento,
  o aviso de porta aberta aparece somente nos visores externos.
- Andar e direção aparecem nos visores internos e externos; manutenção aparece
  em ambos.

## Manutenção

- Se a chave for inserida com a cabine parada, inclusive com a porta aberta, a
  manutenção começa imediatamente e todos os pedidos são cancelados.
- Se a cabine estiver em movimento, ela para no próximo pavimento e só então
  ativa a manutenção.
- Durante a manutenção, os painéis não registram pedidos. Pressionar qualquer
  botão inicia duas fases de piscada e o LED volta a permanecer apagado.
- Inserir novamente uma chave já inserida não é uma operação válida.
