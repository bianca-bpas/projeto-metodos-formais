# Documentação das funções e operações

Este documento descreve as operações das máquinas B do projeto e as funções
auxiliares usadas nos testes. Em B, uma operação com parâmetros altera o estado
da máquina quando sua pré-condição é verdadeira. As operações de consulta apenas
retornam valores e não alteram o estado.

## Visão geral

| Máquina | Responsabilidade |
| --- | --- |
| `configuracao` | Define os conjuntos e os limites fixos do elevador. |
| `painel_pedidos` | Registra, cancela e sinaliza pedidos internos e externos. |
| `cabine_movimento` | Controla andar, direção, portas, peso e deslocamento. |
| `controle_manutencao` | Controla a chave e os estados de manutenção. |
| `elevador` | Integra as máquinas e oferece as operações usadas pelo sistema. |

## `configuracao.mch`

Esta máquina não possui operações. Ela fornece os conjuntos `DIRECOES` e
`PORTAS` e as constantes `peso_maximo = 450` e `andar_maximo = 4`, usados pelas
demais máquinas.

## `painel_pedidos.mch`

Mantém três conjuntos de pedidos: `pedidos_internos`, `pedidos_subida` e
`pedidos_descida`. Também mantém dois estágios de piscada para cada tipo de
botão (`*1` e `*2`). Um pedido é representado pelo número do andar.

### `cancelar_todos`

Remove todos os pedidos internos e externos e limpa todas as listas de piscada.
É usada, principalmente, quando o elevador entra em manutenção.

### `cancelamento_interno(alvo)`

Cancela um pedido feito dentro da cabine. Se `alvo` for o único pedido interno,
ele não é removido imediatamente: é colocado em `piscando_interno1`, permitindo
o tratamento da regra de cancelamento do último pedido. Com mais de um pedido,
remove `alvo` diretamente de `pedidos_internos`.

### `atender_pedidos_andar(alvo, sentido)`

Limpa os pedidos atendidos quando a porta abre no andar `alvo`. Remove sempre o
pedido interno do andar. Remove o pedido externo de subida quando o elevador
está subindo ou parado; remove o pedido externo de descida quando está descendo
ou quando está parado e não existe pedido de subida correspondente.

### `cancelamento_externo_subida(alvo)`

Remove `alvo` dos pedidos externos de subida.

### `cancelamento_externo_descida(alvo)`

Remove `alvo` dos pedidos externos de descida.

### `pedir_interno(alvo)`

Adiciona `alvo` ao conjunto de pedidos feitos pelos passageiros dentro da
cabine. Como o estado é um conjunto, repetir o mesmo pedido não o duplica.

### `pedir_externo_subida(alvo)`

Adiciona `alvo` ao conjunto de chamadas externas que solicitam subida. O andar
de destino deve estar entre o andar mínimo e o penúltimo andar.

### `pedir_externo_descida(alvo)`

Adiciona `alvo` ao conjunto de chamadas externas que solicitam descida. O andar
de origem deve estar entre o segundo andar e o andar máximo.

### `piscar_interno(alvo)`

Registra em `piscando_interno1` que o botão interno de `alvo` deve sinalizar uma
rejeição ou ação pendente.

### `piscar_subida(alvo)`

Registra em `piscando_subida1` a sinalização do botão externo de subida de
`alvo`.

### `piscar_descida(alvo)`

Registra em `piscando_descida1` a sinalização do botão externo de descida de
`alvo`.

### `parar_piscar`

Avança o ciclo de sinalização: limpa o primeiro estágio de cada tipo e copia o
conteúdo anterior para o segundo estágio. Assim, uma piscada pode ser observada
antes de ser completamente removida em uma chamada posterior.

## `cabine_movimento.mch`

Controla a posição da cabine, sua direção, o estado da porta, o sentido de
atendimento, o peso, a parada pendente e o total de deslocamento.

### `passar_segundo`

Avança em um segundo o contador `segundos_porta_aberta` enquanto a porta está
aberta. O contador fica limitado a 121 segundos. Ele é reiniciado por
`fechar_porta`.

### `solicitar_parada_pendente`

Marca `parada_pendente` quando a cabine está em movimento. A marca faz a cabine
parar no próximo avanço realizado por `subir` ou `descer`.

### `atualizar_peso(novo_peso)`

Atualiza o peso da cabine, mas somente quando ela está parada. Também atualiza
`limite_peso_atingido`: fica verdadeiro quando `novo_peso` é maior que 450 kg.

### `iniciar_subida(todos_pedidos, pedidos_compativeis)`

Inicia o movimento de subida quando a cabine está parada, com a porta fechada,
sem excesso de peso e com algum pedido acima do andar atual compatível com a
subida. Define `direcao` e `sentido_atendimento` como `subindo`.

### `iniciar_descida(todos_pedidos, pedidos_compativeis)`

Inicia o movimento de descida sob as condições equivalentes às da subida,
verificando a existência de pedido abaixo do andar atual. Define a direção e o
sentido de atendimento como `descendo`.

### `subir(p_int, p_sub, p_des)`

Move a cabine um andar para cima e incrementa `deslocamento`. Depois do avanço,
para se houver parada pendente, um pedido compatível no próximo andar ou nenhum
pedido restante à frente. Ao parar, limpa `parada_pendente`.

### `descer(p_int, p_sub, p_des)`

Move a cabine um andar para baixo e incrementa `deslocamento`. Aplica a lógica
equivalente à de `subir`, procurando pedidos no sentido da descida e parando
quando necessário.

### `inverter_sentido(p_int, p_sub, p_des)`

Troca o sentido de atendimento quando não há pedidos atendíveis à frente e
existem pedidos no sentido oposto. Só pode ser executada com a cabine parada,
com a porta fechada e sem pedido interno no andar atual.

### `abrir_porta(p_int, p_sub, p_des)`

Abre a porta quando a cabine está parada e fechada. Se o sentido ainda estiver
parado, escolhe subida ou descida com base no tipo de chamada externa existente
no andar atual.

### `fechar_porta`

Fecha a porta aberta e zera `segundos_porta_aberta`.

### `entrar_em_reposo(p_int, p_sub, p_des)`

Coloca `sentido_atendimento` em `parado` quando a cabine está parada, fechada e
não existem pedidos pendentes.

### `consultar_estado`

Retorna `andar` em `pavimento_exibido` e `direcao` em `direcao_exibida` para os
visores ou para o adaptador externo.

### `consultar_deslocamento`

Retorna o total acumulado de andares percorridos em `total_deslocamento`.

### `consultar_peso`

Retorna o peso atual em `peso_atual` e o estado do alerta de excesso em
`alerta_ativo`.

## `controle_manutencao.mch`

Gerencia a chave física e diferencia manutenção ativa de manutenção pendente.
Manutenção pendente ocorre quando a chave é inserida durante o movimento e só
fica ativa depois que a cabine para.

### `inserir_chave_manutencao(cabine_parada)`

Insere a chave quando ela ainda não está inserida. Se `cabine_parada` for
verdadeiro, ativa imediatamente a manutenção; caso contrário, registra
`manutencao_pendente`.

### `confirmar_parada_manutencao(cabine_parada)`

Converte uma manutenção pendente em manutenção ativa quando a cabine chegou a
um estado parado.

### `remover_chave_manutencao(cabine_parada)`

Retira a chave e encerra a manutenção ativa. A cabine precisa estar parada.

### `cancelar_manutencao_pendente`

Cancela uma solicitação de manutenção que ainda não foi ativada, retirando a
chave lógica e limpando o estado pendente.

### `consultar_estado_manutencao`

Retorna três estados: `chave_inserida`, `manutencao_ativa` e `estado_pendente`.

## `elevador.mch`

É a máquina de integração. Inclui as máquinas de pedidos, movimento e
manutenção, e expõe operações com nomes voltados à interface do elevador.

### `inserir_chave`

Insere a chave de manutenção. Se a cabine estiver parada, ativa a manutenção e
cancela os pedidos; se estiver em movimento, solicita uma parada pendente.

### `remover_chave`

Retira a chave. Quando a manutenção está ativa, encerra-a; quando ainda está
pendente, cancela a solicitação pendente.

### `consultar_avisos`

Retorna os avisos interno e externo de manutenção e informa se a porta está
aberta há mais de 120 segundos por meio de `porta_aberta_externo`.

### `pressionar_interno(alvo)`

Processa o pressionamento de um botão interno. Em operação normal cria um
pedido; durante a manutenção, registra uma piscada de rejeição.

### `pressionar_externo_subida(alvo)`

Processa uma chamada externa de subida. Cria o pedido normalmente ou registra a
rejeição com piscada durante a manutenção.

### `pressionar_externo_descida(alvo)`

Processa uma chamada externa de descida, com comportamento análogo ao da
operação de subida.

### `elevador_cancelar_interno(alvo)`

Solicita o cancelamento de um pedido interno, aplicando a regra especial para o
último pedido por meio de `cancelamento_interno`.

### `elevador_cancelar_subida(alvo)`

Cancela uma chamada externa de subida. Se ela era o único pedido do elevador
durante o movimento, também marca uma parada pendente.

### `elevador_cancelar_descida(alvo)`

Cancela uma chamada externa de descida e aplica a mesma regra de parada pendente
quando era o último pedido existente durante o movimento.

### `elevador_iniciar_subida`

Valida as condições de operação normal e delega a inicialização da subida para
`cabine_movimento.iniciar_subida` usando os conjuntos de pedidos atuais.

### `elevador_iniciar_descida`

Valida as condições de operação normal e delega a inicialização da descida para
`cabine_movimento.iniciar_descida`.

### `elevador_subir`

Executa um avanço de um andar para cima. Se houver manutenção pendente, confirma
a parada de manutenção ao chegar, ativa a manutenção e cancela os pedidos.

### `elevador_descer`

Executa um avanço de um andar para baixo e trata a manutenção pendente da mesma
forma que `elevador_subir`.

### `elevador_inverter_sentido`

Valida se é possível trocar o sentido de atendimento e delega a mudança para
`inverter_sentido`.

### `elevador_abrir_porta`

Abre a porta em operação normal e atende os pedidos do andar atual. Durante a
manutenção, não altera a porta: inicia duas unidades de sinalização em
`piscando_abrir`.

### `elevador_fechar_porta`

Fecha a porta em operação normal. Durante a manutenção, não altera a porta e
inicia a sinalização em `piscando_fechar`.

### `avancar_piscadas_porta`

Decrementa os contadores `piscando_abrir` e `piscando_fechar` até zero,
representando a passagem de uma etapa da sinalização dos botões de porta.

### `elevador_entrar_em_reposo`

Coloca o sentido de atendimento em repouso quando a cabine está parada, fechada
e todos os conjuntos de pedidos estão vazios.

### `elevador_parar_piscar`

Avança as listas de piscada dos painéis, delegando para `parar_piscar`. É usada
para apagar gradualmente as sinalizações internas e externas.

## Funções auxiliares dos testes Python

### `verificar(cenarios)` em `tests/verificar.py`

Executa cada cenário no `probcli`, inicializa uma cópia temporária das máquinas
B, envia as operações e as consultas de estado e verifica invariantes após cada
passo. Falha se houver resultado falso, erro de execução, operação não habilitada
ou quantidade incorreta de predicados verdadeiros.

### `ir_ao_primeiro` em `tests/bordas.py`

É uma sequência reutilizável de comandos que solicita o primeiro andar, inicia a
subida, chega ao andar, abre e fecha a porta e coloca o elevador em repouso.

### `pedidos_extremos` em `tests/bordas.py`

É uma sequência reutilizável que cria pedidos internos para os andares mínimo e
máximo, usada nos cenários de borda.

### `cenarios` em `tests/bordas.py`

Agrupa os cenários de auditoria de limites e lacunas conhecidas, incluindo
cancelamentos, piscadas, custo de deslocamento, manutenção, peso e temporização
da porta. O bloco principal passa esse conjunto para `verificar`.

### Bloco principal dos testes

Os blocos `if __name__ == "__main__"` permitem executar cada arquivo diretamente
com `python3`. O caminho do `probcli` pode ser informado como primeiro argumento.

