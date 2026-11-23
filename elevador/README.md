# Visualização — Controle de Elevador (VisB / ProB)

Protótipo funcional animado das máquinas B desta pasta, construído com o **VisB**, o módulo de
visualização do ProB: um SVG cujos atributos são calculados por expressões B sobre o estado atual
e cujos elementos disparam operações B ao serem clicados. Não há lógica fora do modelo — o que se
vê é sempre o estado real do animador.

## Como abrir
1. Instale o **ProB 2 UI** (https://prob.hhu.de/w/index.php/Download).
2. `Arquivo → Abrir` → `elevador/elevador.mch`. A definição `VISB_JSON_FILE` carrega o
   `elevador_visb.json` automaticamente; abra a aba **VisB** (ou *View → VisB*).
3. Execute `SETUP_CONSTANTS` com `andar_maximo = 4` e depois `INITIALISATION` (ou "Setup/Initialise").
4. Clique nos botões do SVG.

As máquinas desta pasta permanecem paramétricas e não recebem uma restrição fixa no código B.
Para outro tamanho, execute `python3 elevador/gerar.py N` a partir da raiz do projeto e configure
`andar_maximo = N` no ProB. O gerador atualiza somente o SVG e o JSON da visualização.

## Mapa visualização → modelo B → requisito
| Elemento do SVG | Expressão B / operação | HLR |
|---|---|---|
| Cabine (`cab`, `porta_e/d`) sobe/desce, porta abre/fecha | `andar`, `porta` | 001, 003 |
| Visor de cada pavimento (`vnum_*`, `vdir_*`) | `andar`; seta de `direcao`; `M` se `manutencao`; `X` se `segundos_porta_aberta > 120` | 001, 007, 008 |
| Botões ▲/▼ externos (`ext_up_*`, `ext_dn_*`); só existe ▲ no P0 e ▼ no último | `pressionar_externo_subida/descida`; LED = réplica de `consultar_leds` | 002, 004 |
| Botões de destino (`int_*`) | `pressionar_interno`; LED aceso/piscando conforme `pedidos_internos` e `piscando_interno1..4` | 003, 004, 005 |
| Círculos pequenos (`lib_*`) | `liberar_*` (soltar antes de 3 s mantém o pedido; segurar por 3 `passar_tempo` cancela) | 005 |
| Borda branca de um botão | pertence a `segurando_*` ou `interno_recusado` | 005 |
| Botões abrir/fechar | `pressionar_abrir/fechar`; acendem em `piscando_* ∈ {4,2}` | 003, 008 |
| Chave de manutenção | `inserir_chave`, `remover_chave_manutencao`; aviso `MANUTENÇÃO` / `MANUT. PENDENTE` | 008 |
| `+75 kg` / `−75 kg` | `ajustar_peso(delta)`; ponto da cabine fica vermelho e visor mostra `EXCESSO DE PESO` se `peso > 450` | 009 |
| `passar_tempo` / `passo` | relógio de 1 s e um passo do controlador (varredura) | 005–007, 010 |
| Painel de estado | `porta`, `segundos_porta_aberta`, `sentido_atendimento`, `deslocamento`, `parada_pendente`, `card(pedidos)`, `historico_paradas` | 006, 010 |

Os botões respeitam as guardas do modelo: operações cuja pré-condição/guarda não vale (por exemplo,
`passo` em manutenção, `ajustar_peso` com cabine em movimento) aparecem como não habilitadas no
ProB e o clique não tem efeito.

## Roteiros para demonstrar (do `docs/guia-do-modelo.md`)
- **Atendimento:** clique `int_3`, solte em `lib_int_3`, depois `passo` ×5 — cabine vai ao P3, abre e fecha a porta.
- **Cancelamento (HLR-005):** clique `ext_up_2` e `passar_tempo` ×3 sem soltar — LED apaga.
- **Último pedido interno:** `int_2` e `passar_tempo` ×3 — o LED pisca duas vezes e volta a acender.
- **Manutenção (HLR-008):** `inserir_chave` — pedidos zerados e botões só piscam; `remover chave` sai do modo.
- **Sobrecarga (HLR-009):** `+75 kg` ×7 — `EXCESSO DE PESO`; `passo` não move a cabine.
- **Porta aberta > 2 min (HLR-007):** abra a porta e execute `passar_tempo` ×121 — `X` nos visores.
