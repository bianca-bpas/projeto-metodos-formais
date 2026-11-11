# Guia do modelo do elevador

Este projeto é uma **especificação formal em B**, e não um programa com
interface gráfica. Ele descreve estados possíveis do elevador, as operações
que mudam esses estados e as propriedades que nunca podem ser violadas. A
máquina a usar como interface é `elevador`.

## Visão geral

```
configuracao (limites e domínios)
       ↑                 ↑
painel_pedidos      cabine_movimento
       ↑                 ↑
       └──── elevador ───┘
             interface pública e controlador
```

- `configuracao.mch` parametriza o prédio por `andar_maximo : NATURAL`, com
  `andar_maximo > 0`: os andares são `0..andar_maximo`, com pelo menos dois
  pavimentos. O peso máximo
  é `450 kg`; as direções são `subindo`, `descendo`, `parado`; e as portas são
  `aberta` e `fechada`. As chamadas externas válidas são subir em
  `0..(andar_maximo - 1)` e descer em `1..andar_maximo`.
- `painel_pedidos.mch` guarda as chamadas internas, de subida e de descida,
  controla LEDs, retenção do botão por três segundos, cancelamento e histórico
  das últimas cinco paradas.
- `cabine_movimento.mch` representa posição, sentido, porta, peso, manutenção,
  temporizador da porta e marcas de visita.
- `elevador.mch` inclui as duas máquinas anteriores e define a interface do
  sistema: interação com usuário, passagem de tempo e a política de despacho.

Em B, `INVARIANT` lista as propriedades que devem ser verdadeiras em todo
estado alcançável; `PRE` é a pré-condição de uma operação; `:=` atualiza uma
variável; e `||` separa atualizações simultâneas. Assim, não chame uma
operação se sua `PRE` não for satisfeita.

## Mapa do estado interno

| Onde | Campos | Para que servem |
|---|---|---|
| Cabine | `andar`, `direcao`, `deslocamento` | Posição atual, movimento e quantidade acumulada de andares percorridos. |
| Cabine | `sentido_atendimento`, `parada_pendente` | Memória da varredura e pedido para cessar movimento no próximo andar. |
| Porta | `porta`, `segundos_porta_aberta` | Estado físico e contador usado no alerta após dois minutos. |
| Carga | `peso`, `limite_peso_atingido` | Peso lido e alerta derivado de `peso > 450`. |
| Manutenção | `chave_manutencao`, `manutencao`, `manutencao_pendente` | Chave inserida, modo ativo e solicitação aguardando a próxima parada. |
| Visitas | `ultima_visita` | Função parcial que associa cada andar visitado ao deslocamento acumulado na última visita. |
| Pedidos | `pedidos_internos`, `pedidos_subida`, `pedidos_descida` | Conjuntos dos destinos solicitados por cada origem. |
| Retenção | `segurando_*`, `segurando_*_1`, `segurando_*_2` | Botões pressionados há zero, um e dois ticks; no terceiro tick ocorre cancelamento. |
| Exceção interna | `interno_recusado` | Último pedido interno cuja tentativa de cancelamento foi recusada. |
| LEDs de andar | `piscando_*1` a `piscando_*4` | Quatro fases que determinam se o LED aparece aceso ou apagado durante uma piscada. |
| Histórico | `historico_paradas` | Sequência limitada às cinco últimas paradas atendidas. |
| LEDs de porta | `piscando_abrir`, `piscando_fechar` | Contadores de 4 a 0; os LEDs acendem nos valores 4 e 2. |

## Estado inicial e regras de segurança

Ao inicializar, a cabine está no andar `0`, parada, com porta fechada, sem
pedidos, peso zero e fora de manutenção. Entre as garantias mais importantes
dos invariantes estão:

- a cabine permanece entre os andares `0` e `andar_maximo`;
- ela só se move com a porta fechada, sem sobrecarga e fora de manutenção;
- uma cabine em subida não fica no último andar, e uma em descida não fica no
  térreo;
- porta fechada implica contador de porta igual a zero;
- manutenção ativa exige chave inserida, cabine parada e não pode coexistir
  com a manutenção pendente.

## Operações da interface `elevador`

### Pedidos e botões

| Operação | Uso | Efeito |
|---|---|---|
| `pressionar_interno(alvo)` | `alvo : 0..andar_maximo` | Registra pedido da cabine e acende seu LED. |
| `pressionar_externo_subida(alvo)` | `alvo : 0..(andar_maximo - 1)` | Registra chamada de subida. |
| `pressionar_externo_descida(alvo)` | `alvo : 1..andar_maximo` | Registra chamada de descida. |
| `liberar_interno(alvo)`, `liberar_subida(alvo)`, `liberar_descida(alvo)` | mesmo domínio do botão | Solta o botão e interrompe sua contagem de cancelamento, mantendo o pedido. |
| `pressionar_abrir` | sem parâmetro | Se a cabine estiver parada, com porta fechada e fora de manutenção, abre a porta. |
| `pressionar_fechar` | sem parâmetro | Se a cabine estiver parada, com porta aberta e fora de manutenção, fecha a porta. |

Em manutenção, pressionar um botão de andar **não cria pedido**: o LED entra
em uma animação de duas piscadas e termina apagado. Os botões abrir e fechar
também apenas piscam nesse estado. Fora de manutenção, pressionar novamente
um botão reinicia sua contagem de retenção.

### Tempo, cancelamento e porta

`passar_tempo` é um tick de um segundo. Ele deve ser chamado por quem simula o
relógio. Fora de manutenção, avança simultaneamente a contagem dos botões, as
fases de LED, o temporizador da porta e a animação dos botões abrir/fechar.

Para cancelar uma chamada, pressione e mantenha o botão pressionado durante
três chamadas a `passar_tempo`. Se ele for liberado antes, o pedido continua.
Chamadas externas expiradas são removidas. Pedidos internos também são
removidos, salvo quando eles constituem o último pedido interno: nesse caso o
menor andar selecionado permanece, é marcado como recusado e seu LED pisca
duas vezes antes de voltar a acender.

Se a cabine estiver em movimento e o último pedido expirar, a próxima chamada
a `passar_tempo` arma uma parada pendente. A cabine para no próximo andar no
sentido em que viaja. A porta que ficar aberta por mais de 120 ticks produz o
alerta externo de porta aberta em `consultar_visores`.

### Movimento e atendimento

`passo` executa uma transição do controlador. Sua pré-condição exige que não
haja manutenção e que exista atividade: pedido, movimento, porta aberta ou
sentido de atendimento armazenado. Normalmente, uma simulação chama `passo`
repetidamente até que não esteja mais habilitado.

A política é uma varredura: depois de escolher um sentido, o elevador atende
os pedidos compatíveis que estão adiante e preserva o sentido enquanto houver
pedidos à frente. Quando não há mais, inverte para atender os pedidos atrás.
Uma parada abre a porta e remove os pedidos atendidos; o passo seguinte fecha a
porta. Chamadas externas no sentido oposto podem aguardar o retorno. Quando
não existe pedido, o controlador volta a `parado`.

O modelo impede o início do movimento com peso acima de 450 kg. Atualize-o com
`atualizar_peso(novo_peso)` ou `ajustar_peso(delta)`; ambas exigem cabine
parada. `ajustar_peso` também exige que o resultado seja natural (não negativo).
Quando há sobrecarga, `passo` não movimenta a cabine, mas ainda permite abrir
e fechar a porta.

### Manutenção

| Operação | Quando usar | Resultado |
|---|---|---|
| `inserir_chave` | chave ainda ausente | Se parada, entra imediatamente em manutenção e cancela os pedidos; em movimento, marca manutenção pendente e solicita parada. |
| `remover_chave_manutencao` | manutenção ativa, cabine parada | Remove a chave e sai de manutenção. |

Se a chave for inserida em movimento, execute `passo` até a cabine parar. O
controlador cancela todos os pedidos quando a manutenção é efetivada. A chave
não pode ser removida enquanto a manutenção estiver pendente ou a cabine não
estiver parada.

## Consultas disponíveis

As consultas não mudam o modelo. Os retornos correspondem à ordem escrita na
assinatura B.

| Consulta | Retorno / finalidade |
|---|---|
| `consultar_estado` | andar e direção atuais. |
| `consultar_visores` | andar, direção e alertas de manutenção, sobrecarga e porta aberta. |
| `consultar_porta` | estado da porta e segundos aberta. |
| `consultar_peso`, `consultar_folga` | peso/alerta e capacidade restante. |
| `consultar_manutencao` | chave inserida, manutenção ativa e pendente. |
| `consultar_parada_pendente` | se a próxima parada foi solicitada. |
| `consultar_leds` | conjuntos de LEDs acesos: internos, subida e descida. |
| `consultar_piscadas` | fases de animação dos LEDs de andares. |
| `consultar_piscadas_porta`, `consultar_leds_porta` | contador de piscadas e saída dos LEDs abrir/fechar. |
| `consultar_botoes_pressionados` | botões atualmente retidos (inclui pedido interno recusado). |
| `consultar_botoes_com_tempo(tt)` | botões por idade: `0`, `1`, `2`; `3` é interno recusado; `-1` são não pressionados. |
| `consultar_historico_paradas`, `consultar_extremos_historico` | até cinco últimas paradas, ou primeira/última se houver histórico. |
| `consultar_deslocamento`, `consultar_visitas` | deslocamento total e informações das visitas. |
| `sugerir_pedido_qualquer` | um pedido ativo, escolhido não deterministicamente; exige pelo menos um. |

## Roteiro de simulação

Este é um trace conceitual, útil no animador do ProB. Os comandos com retorno
podem ser usados para observar o estado entre as transições.

```
INITIALISATION
pressionar_interno(3)
liberar_interno(3)       /* evita cancelamento por retenção */
passo                    /* escolhe/inicia a subida */
passo                    /* chega ao andar 1 */
passo                    /* chega ao andar 2 */
passo                    /* chega ao 3 e para */
passo                    /* abre a porta e atende o pedido */
consultar_estado         /* retorna 3, parado */
passo                    /* fecha a porta */
passo                    /* entra em repouso */
```

Para testar cancelamento, substitua a liberação por três ticks:

```
pressionar_externo_subida(2)
passar_tempo
passar_tempo
passar_tempo             /* remove a chamada externa */
consultar_leds
```

Os scripts em `verificacao/` fornecem traces executáveis no ProB. Para
reproduzir a verificação dos cenários, a partir da raiz e com Python 3 e ProB
instalados:

```sh
python3 verificacao/hlr005_008/verificar.py /opt/ProB/probcli
python3 verificacao/hlr010/verificar.py /opt/ProB/probcli
```

## Limites do que foi demonstrado

Na execução histórica da instância de cinco pavimentos (`andar_maximo = 4`),
as invariantes e 843 obrigações geradas foram provadas no Atelier B; os scripts ProB validam
cenários concretos nessa instância. A revisão paramétrica deve ter as provas
regeneradas. Isto não constitui prova de que todo pedido será atendido ao longo
de execuções infinitas, nem que o percurso é globalmente mínimo. Esses são os
limites conhecidos do HLR-010. As fontes atuais incluem alterações posteriores,
portanto as provas nativas precisam ser regeneradas. Consulte `docs/validacao.md` para resultados e
reprodução, e `docs/decisões.md` para as hipóteses de modelagem.
