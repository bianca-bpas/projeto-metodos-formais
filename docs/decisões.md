# Decisões do projeto

## Limites do prédio

- O número de pavimentos é parametrizado por `andar_maximo : NATURAL`, com
  `andar_maximo > 0`; os pavimentos são numerados de `0` a `andar_maximo`.
- O pavimento `0` representa o térreo.
- Há botão externo de subida nos pavimentos `0..(andar_maximo - 1)` e de
  descida nos pavimentos `1..andar_maximo`.

## Peso e sobrecarga

- A capacidade máxima é 450 kg.
- Acima desse limite, a cabine permanece parada até o peso ser reduzido.
- `atualizar_peso` e `ajustar_peso` exigem somente que a cabine esteja parada;
  a porta pode estar aberta ou fechada.
- O aviso de sobrecarga aparece somente no visor interno.
- A alternativa de descer ao térreo com sobrecarga foi descartada porque
  contradiz o HLR-009.

## Pedidos, LEDs e cancelamento

- Os pedidos são mantidos em três conjuntos: cabine, subida e descida.
- No estado estável, um pedido ativo mantém seu LED aceso. Durante a
  piscada, `consultar_leds` combina pedidos e fases para calcular a saída.
- Pressionar novamente um pedido ativo não cria uma cópia; conjuntos tornam a
  operação idempotente.
- Os conjuntos aninhados `segurando_*`, `segurando_*_1` e `segurando_*_2`
  representam a pressão e os dois primeiros ticks. O terceiro cancela
  automaticamente; `interno_recusado` registra a recusa até a liberação.
- Pedidos externos podem ser cancelados mesmo quando forem o único pedido.
- O último pedido interno não pode ser cancelado: ele permanece ativo e passa
  por quatro fases (ligado, desligado, ligado, desligado), retornando aceso.
- Se todos os internos completarem três segundos juntos, o menor pavimento
  permanece ativo; os demais são cancelados.
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
  chamadas durante o atendimento. Essas hipóteses ainda precisam sustentar uma prova temporal de atendimento
  eventual; as provas de invariantes não demonstram justiça.
- A minimização é uma política local: menor deslocamento para iniciar um novo
  ciclo e continuidade na direção atual. Não há garantia de ótimo global nem para um conjunto fixo de pedidos
  conhecidos. Justiça e minimização global de HLR-010 permanecem pendentes.

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
- Se a chave for removida enquanto a manutenção está pendente, a manutenção é
  cancelada, mas `parada_pendente` permanece ativa: a cabine ainda para no
  próximo pavimento.
- Durante a manutenção, os painéis não registram pedidos. Pressionar qualquer
  botão inicia quatro fases de piscada (ligado, desligado, ligado, desligado) e o LED
  volta a permanecer apagado.
- Inserir novamente uma chave já inserida não é uma operação válida.
