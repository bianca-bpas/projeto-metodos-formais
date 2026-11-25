# Visualização — Controle de Elevador (VisB / ProB)

Protótipo funcional animado das máquinas B desta pasta, construído com o **VisB**, o módulo de
visualização do ProB: um SVG cujos atributos são calculados por expressões B sobre o estado atual
e cujos elementos disparam operações B. O script de interação encaminha pressão, soltura e
tempo ao animador e interpola a posição da cabine durante o trajeto. Pedidos, LEDs, portas
e decisões de parada são calculados pelas máquinas B.

## Como abrir
1. Instale o **ProB 2 UI** (https://prob.hhu.de/w/index.php/Download).
2. `Arquivo → Abrir` → `elevador/animacao.mch`. A definição `VISB_JSON_FILE` carrega o
   `elevador_visb.json` automaticamente; abra a aba **VisB** (ou *View → VisB*).
3. Execute `SETUP_CONSTANTS` com `andar_maximo = 4` e depois `INITIALISATION` (ou "Setup/Initialise").
4. Clique em **Passar tempo** e escolha o destino. **Pausar tempo** congela o relógio e o controlador. Ao retomar, o pedido continua de onde parou. Durante a execução, o relógio avança automaticamente a cada segundo; a cabine leva 6 s entre dois pavimentos. As etapas com a cabine parada avançam a cada 1,5 s. O visor muda de andar na chegada.

As máquinas desta pasta permanecem paramétricas e não recebem uma restrição fixa no código B.
Para outro tamanho, execute `python3 elevador/gerar.py N` a partir da raiz do projeto e configure
`andar_maximo = N` no ProB. O gerador atualiza somente o SVG e o JSON da visualização.

## Mapa visualização → modelo B → requisito
| Elemento do SVG | Expressão B / operação | HLR |
|---|---|---|
| Cabine (`cab`, `porta_e/d`) sobe/desce, porta abre/fecha | `andar`, `porta` | 001, 003 |
| Visor de cada pavimento (`vnum_*`, `vdir_*`) | `andar` e seta de `direcao` sempre visíveis; avisos separados de manutenção e porta aberta | 001, 007, 008 |
| Botões ▲/▼ externos (`ext_up_*`, `ext_dn_*`); só existe ▲ no P0 e ▼ no último | `pressionar_externo_subida/descida`; LED = réplica de `consultar_leds` | 002, 004 |
| Botões de destino (`int_*`) | `pressionar_interno`; LED aceso/piscando conforme `pedidos_internos` e `piscando_interno1..4` | 003, 004, 005 |
| Soltura do mouse sobre um destino ou seta | `liberar_*` (soltar antes de 3 s mantém o pedido; segurar por 3 segundos de simulação tenta cancelar) | 005 |
| Borda branca de um botão | pertence a `segurando_*` ou `interno_recusado` | 005 |
| Botões abrir/fechar | `pressionar_abrir/fechar`; acendem em `piscando_* ∈ {4,2}` | 003, 008 |
| Chave de manutenção | `inserir_chave`, `remover_chave_manutencao`; ícone de manutenção (também enquanto pendente) | 008 |
| `+75 kg` / `−75 kg` | `ajustar_peso(delta)`; ponto da cabine fica vermelho e painéis mostram o ícone de excesso de peso se `peso > 450` | 009 |
| `passar_tempo` / `passo` | relógio de 1 s e um passo do controlador (varredura) | 005–007, 010 |
| Painel de estado | `porta`, `segundos_porta_aberta`, `sentido_atendimento`, `deslocamento`, `parada_pendente`, `card(pedidos)`, `historico_paradas` | 006, 010 |

Os botões respeitam as guardas do modelo: operações cuja pré-condição/guarda não vale (por exemplo,
`passo` em manutenção, `ajustar_peso` com cabine em movimento) aparecem como não habilitadas no
ProB e o clique não tem efeito.

## Roteiros para demonstrar (do `docs/guia-do-modelo.md`)
- **Atendimento:** clique e solte o botão 3, aguarde o controlador automático — cabine vai ao P3, abre e fecha a porta.
- **Parada por cancelamento (HLR-006):** a partir do P0, clique e solte a seta de descida do P4 como única chamada. Assim que a cabine começar a subir, segure a mesma seta por 3 s. Confira a parada pendente e a chegada ao P1.
- **Manutenção em movimento (HLR-008):** a partir do P0, peça o P4. Durante o primeiro trecho, clique em inserir chave. A cabine termina o trecho e entra em manutenção no P1.
- **Cancelamento (HLR-005):** clique e solte a seta de subida do P2. Com a chamada pendente e o relógio em execução, pressione novamente a mesma seta. Soltar antes de 3 s mantém o LED aceso; completar 3 s cancela a chamada e apaga o LED.
- **Último pedido interno:** com apenas o destino 2 ativo, segure o botão 2 por 3 segundos e solte. O painel mostra “Último pedido mantido”; o LED termina as duas piscadas e volta a ficar aceso.
- **Manutenção (HLR-008):** `inserir_chave` — pedidos zerados e botões só piscam; `remover chave` sai do modo.
- **Sobrecarga (HLR-009):** `+75 kg` ×7 — ícone de excesso de peso; `passo` não move a cabine.
- **Porta aberta > 2 min (HLR-007):** com o tempo pausado, clique em abrir e mantenha **Segurar porta** pressionado; inicie o relógio com outro ponteiro ou antes da pressão. Aos 120 s não há aviso; no segundo 121 aparece `PORTA ABERTA > 120 s` em cada pavimento. Soltar permite o fechamento no próximo passo. Para uma demonstração com mouse, inicie o relógio, abra e pressione Segurar porta antes do próximo passo.
- **Retenção e manutenção:** durante a retenção, Fechar não fecha e novos pedidos podem ser registrados. Inserir a chave limpa a retenção e os pedidos, mas preserva o contador da porta; os dois avisos externos podem coexistir.

## Entrega e tempo de simulação

`animacao.mch` inclui o controlador `elevador.mch` e acrescenta somente a operação
`entregar(evento, comando, alvo)` e o número `ultimo_evento`. O SVG envia números
crescentes pelos metadados de clique do VisB. Eventos repetidos ou antigos não
executam novamente a ação. Pressões, solturas, comandos, ticks e passos compartilham
uma fila; o envio de um clique sintético não equivale a confirmação. As decisões
sobre pedidos, porta e movimento continuam nas máquinas originais. Para animação
manual sem a ponte, abra `elevador.mch`.

O relógio começa pausado. A pausa congela movimento interpolado, ticks, cancelamentos,
piscadas e contador; uma transição já enviada termina atomicamente antes da pausa
estabilizar. Enquanto Segurar porta está pressionado, o contador salta 10 s simulados por tick de relógio confirmado pelo ProB. A ponte espera a confirmação do ProB, portanto 6 s de simulação podem
levar mais de 6 s de parede. A fração anterior à pressão não antecipa o cancelamento;
volta a contar após a soltura. Não há animação gradual das portas.

**Segurar porta** é um controle ambiental, fora do painel interno regulamentar.
Só atua com porta aberta, cabine parada e sem manutenção; não abre a porta. Soltura,
cancelamento do ponteiro, perda de captura/foco e ocultação da página liberam a
retenção. O estado B limita o fechamento manual e automático enquanto ela durar.

Testes e evidências atuais: [verificação da animação](../verificacao/animacao/README.md).
