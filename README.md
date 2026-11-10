# Projeto de Métodos Formais — Controle de Elevador

Especificação formal de um controlador de elevador em B.

## Estrutura

- `elevador/elevador.mch`: máquina abstrata B.
- `elevador/configuracao.mch`: conjuntos, limites e relação dos painéis externos.
- `elevador/painel_pedidos.mch`: pedidos, LEDs, temporização e cancelamento.
- `elevador/cabine_movimento.mch`: movimento, porta, peso e manutenção.
- `Controle Elevador.md`: requisitos do sistema.
- `docs/diagrama-entidades.md`: diagrama das entidades e suas responsabilidades.
- `docs/decisões.md`: decisões de modelagem e hipóteses do HLR-010.
- `docs/validacao.md`: resultado das verificações automatizadas.

## Abrir no Atelier B

O workspace já está registrado no Atelier B com o nome
`projeto_metodos_formais`. Abra esse projeto pela lista de projetos do Atelier
B; as quatro máquinas usam como diretório-fonte `elevador/`.

Também há um workspace registrado como `projeto_metodos_formais_ng`, com base
em `ng/bdp/`. Ele usa o gerador NG e o Z3 local para tentar as obrigações que
restaram após a prova automática do Atelier B. O resultado e os limites de
confiança dessas provas estão em `docs/validacao.md`.

Os artefatos locais ficam em:

- `bdp/`: base do projeto, obrigações (`.po`/`.pog`), provas (`.pmi`) e
  `provas.log`;
- `lang/`: metadados de linguagem do workspace.

Esses diretórios e `ng/` são gerados localmente e ficam ignorados pelo Git. O
resumo versionado das provas está em `docs/validacao.md`.

## Interface principal

A máquina `elevador` expõe operações para pressionar e liberar botões,
abrir/fechar a porta, avançar o tempo, executar um passo do controlador,
cancelar pedidos e consultar LEDs, piscadas, visores, peso e manutenção.
