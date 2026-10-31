# Decisões do projeto

## Peso e sobrecarga

### Questão

Devemos conferir o peso das pessoas ao entrar no elevador?

### Decisões registradas

- Não deixar o elevador sair.
- Descer até o último andar.

## Cancelamento de pedido

### Questão em aberto

O cancelamento de pedido só funciona quando existe um pedido ativo?

## Representação dos pedidos

### Questão em aberto

Podemos representar os pedidos do elevador como um conjunto (*set*)?

### Direção sugerida

Sim. Devem ser mantidos conjuntos separados para pedidos da cabine, de subida
e de descida, pois a origem e a direção do pedido precisam ser preservadas.

## Decisões pendentes

### Sobrecarga

- A decisão de descer até o último andar entra em conflito com o HLR-009, que
  proíbe qualquer movimento acima de 450 kg.
- Devemos decidir se a cabine fica parada, exibindo o aviso de sobrecarga, até
  que o peso seja reduzido. Esta é a opção mais alinhada ao requisito.

### Atendimento e prioridade dos pedidos

- Qual será a prioridade entre pedidos internos, de subida e de descida?
- A cabine deve continuar atendendo pedidos na direção atual antes de inverter
  sua direção?
- Como garantiremos que um pedido não fique esperando indefinidamente quando
  novos pedidos continuam chegando?

### Pedidos e cancelamento

- O que acontece quando um botão correspondente a um pedido já ativo é
  pressionado novamente?
- Pedidos externos podem ser cancelados quando são o único pedido ativo?
- Quando todos os pedidos são cancelados durante o movimento, a cabine deve
  parar obrigatoriamente no próximo andar?
- Ao chegar a um andar, devemos atender pedidos de cabine, subida e descida ao
  mesmo tempo ou apenas os compatíveis com a direção da cabine?

### Porta e avisos

- Após ficar aberta por mais de dois minutos, a porta fecha automaticamente ou
  apenas é exibido um aviso nos visores externos?
- Em quais visores cada alerta deve aparecer: sobrecarga, porta aberta e
  manutenção?

### Manutenção

- Se a chave de manutenção for inserida com a porta aberta e a cabine parada,
  a manutenção começa imediatamente ou somente depois que a porta for fechada?

### Limites do prédio

- Confirmar que o prédio possui cinco pavimentos, numerados de `0` a `4`, e
  que o pavimento `0` representa o térreo.
