# Projeto de Métodos Formais — Controle de Elevador

Especificação formal de um controlador de elevador em B.

## Estrutura

- `elevador/controlador.mch`: controlador automático com operação `passo`.
- `elevador/elevador.mch`: integração dos componentes e interface manual.
- `Controle Elevador.md`: requisitos do sistema.
- `docs/diagrama-entidades.md`: diagrama das entidades e suas responsabilidades.
- `docs/decisões.md`

## Abrir no Atelier B

Importe ou abra a máquina `elevador/controlador.mch` no Atelier B para verificar a
sintaxe, os invariantes e as obrigações de prova.

## Integração e regressões

O controle automático está em `elevador/controlador.mch`, que inclui `elevador.mch`. A máquina `controle_manutencao` foi recuperada sem alterações do
commit `9cbd2bc`, de Bianca, e incluída pela máquina principal.

- A inserção da chave com a cabine parada ativa imediatamente a manutenção.
  Em movimento, solicita parada no próximo pavimento; nessa chegada, ativa
  a manutenção e cancela os pedidos. Retirar a chave antes da chegada cancela
  a manutenção pendente, mas preserva a parada já solicitada.
- Em manutenção, os botões não alteram porta ou pedidos; os estados de piscada
  registram a rejeição. `consultar_estado_manutencao` e `consultar_avisos`
  expõem os estados e avisos para os visores.
- `passar_segundo` representa o relógio externo dos botões e da porta.
  O contador satura em 121 segundos: o aviso externo acende após 120 segundos
  e é removido ao fechar a porta. Não há fechamento automático.
- O peso é atualizado enquanto a cabine está parada. Exatamente 450 kg são
  permitidos; acima disso o movimento é bloqueado. `atualizar_peso`,
  `consultar_peso`, `consultar_estado` e `consultar_deslocamento` são expostos
  pela máquina principal.

Execute `python3 tests/verificar.py /caminho/para/probcli` para testar os
cenários de regressão e seus invariantes intermediários. Os testes não
substituem uma prova exaustiva de invariantes ou de justiça do atendimento.

## Pressão contínua e atendimento automático

`pressionar_*` inicia a contagem; `liberar_*` a interrompe. O adaptador deve chamar
`elevador_cancelar_*` depois de três segundos contínuos. Atendimento e cancelamento
limpam as duas etapas de piscada. Os contadores são saturados e ficam em -1 quando soltos.

Execute `controlador.passo` repetidamente para atendimento automático. Sua garantia
depende de escalonamento justo e de condições que permitam o movimento. O custo
mínimo foi verificado para todos os lotes internos a partir dos cinco andares em
repouso; a otimização geral com chamadas externas permanece pendente.

Ver [revisão dos requisitos](docs/revisao-requisitos.md) para contratos, hipóteses,
limitações e os comandos das quatro suítes de testes.
