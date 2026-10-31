# Diagrama de entidades — Controle de Elevador

Este diagrama organiza os elementos que o projeto deve representar. Ele é um
modelo de análise: na especificação B, parte dessas entidades aparece como
variáveis e conjuntos, e não necessariamente como classes implementadas.

```mermaid
classDiagram
    class ControladorElevador {
        +andarAtual: 0..4
        +direcao: subindo|descendo|parado
        +deslocamentoAcumulado: NATURAL
        +atenderPedidos()
        +iniciarSubida()
        +iniciarDescida()
    }

    class Cabine {
        +pesoAtual: NATURAL
        +capacidadeMaxima: 450 kg
        +emMovimento: BOOL
    }

    class Porta {
        +estado: aberta|fechada
        +minutosAberta: NATURAL
        +avisoPortaAberta: BOOL
        +abrir()
        +fechar()
    }

    class PainelInterno {
        +botoesDeAndar: 0..4
        +botaoAbrir
        +botaoFechar
        +chaveManutencao
    }

    class PainelExterno {
        +pavimento: 0..4
        +botaoSubir: opcional
        +botaoDescer: opcional
    }

    class Pedido {
        +pavimento: 0..4
        +origem: cabine|subida|descida
        +ativo: BOOL
        +ledAceso: BOOL
        +cancelar()
    }

    class Visor {
        +andarExibido: 0..4
        +direcaoExibida
        +avisoManutencao: BOOL
        +avisoSobrecarga: BOOL
        +avisoPortaAberta: BOOL
    }

    class Manutencao {
        +chaveInserida: BOOL
        +ativa: BOOL
        +pendente: BOOL
        +ativar()
        +desativar()
    }

    ControladorElevador "1" *-- "1" Cabine
    Cabine "1" *-- "1" Porta
    Cabine "1" *-- "1" PainelInterno
    Cabine "1" *-- "1" Visor : visor interno
    ControladorElevador "1" o-- "0..*" PainelExterno
    PainelExterno "1" *-- "1" Visor : visor do pavimento
    PainelInterno "1" --> "0..*" Pedido : cria
    PainelExterno "1" --> "0..*" Pedido : cria
    ControladorElevador "1" --> "0..*" Pedido : gerencia
    PainelInterno "1" *-- "1" Manutencao
```

## O que cada entidade deve possuir

| Entidade | Deve possuir | Cobertura no modelo B |
|---|---|---|
| Controlador do elevador | Andar atual, direção, regra de deslocamento e atendimento dos pedidos. | `andar`, `direcao`, `deslocamento` e operações de movimento. |
| Cabine | Posição, peso atual e limite de 450 kg; não pode mover-se em sobrecarga. | `andar`, `peso`, `peso_maximo`. |
| Porta | Estado aberta/fechada, contador de minutos aberta e alerta após dois minutos. | `porta`, `minutos_porta_aberta`, `aviso_porta_aberta`. |
| Painel interno | Botões dos andares, abrir, fechar e chave de manutenção. | Operações `chamar_cabine`, `abrir_porta`, `fechar_porta` e manutenção. |
| Painel externo | Botão de subida nos andares 0 a 3 e de descida nos andares 1 a 4. | `chamar_subida` e `chamar_descida`. |
| Pedido | Pavimento, origem, estado ativo, LED e possibilidade de cancelamento. | `pedidos_cabine`, `pedidos_subida`, `pedidos_descida` e conjuntos `leds_*`. |
| Visor | Andar e direção; alertas de porta aberta, manutenção e sobrecarga conforme sua localização. | Andar/direção vêm de `andar`/`direcao`; `aviso_porta_aberta` já está modelado. |
| Manutenção | Chave inserida, estado ativo ou pendente, cancelamento dos pedidos e bloqueio dos painéis. | `chave_manutencao`, `manutencao`, `manutencao_pendente`. |

## Regras essenciais

- A cabine só se move com a porta fechada, fora de manutenção e sem sobrecarga.
- Todo pedido deve manter seu LED aceso até ser atendido ou cancelado.
- O pedido interno final não pode ser cancelado: seu LED deve piscar e continuar aceso.
- Em manutenção, pedidos ativos são cancelados e os novos pedidos não são aceitos.
- Cada visor deve refletir o andar e a direção atuais da cabine.
