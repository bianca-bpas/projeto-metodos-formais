# Validação do modelo

Validação executada com Atelier B Community 24.04.2 e ProB 1.16.1.

O projeto está registrado no Atelier B como `projeto_metodos_formais`, usando
`elevador/` como diretório-fonte, `bdp/` como base de provas e `lang/` como
diretório de linguagem. O log integral da última execução está em
`bdp/provas.log`.

## Atelier B

As quatro máquinas passam pela análise sintática e semântica.

| Máquina | Obrigações | Provadas automaticamente | Pendentes |
|---|---:|---:|---:|
| `configuracao` | 0 | 0 | 0 |
| `painel_pedidos` | 236 | 197 | 39 |
| `cabine_movimento` | 56 | 54 | 2 |
| `elevador` | 372 | 363 | 9 |
| **Total** | **664** | **614** | **50** |

A prova automática em força 3 concluiu aproximadamente 92% das obrigações.
Uma obrigação pendente não representa automaticamente um contraexemplo; as
pendências concentram-se nas funções de tempo, no atendimento composto e em
aritmética de movimento. Devem ser tratadas por prova interativa ou por lemas
auxiliares antes de se afirmar prova integral.

### Pendências iniciais do workspace original

- `painel_pedidos`: 24 obrigações em `atender_pedidos_andar`, 6 em
  `avancar_tempo_botoes` e 9 nas operações de registrar, liberar e cancelar.
  Todas envolvem a preservação da relação entre o tempo de pressão e o
  conjunto de pedidos ativos.
- `cabine_movimento`: uma obrigação em `iniciar_subida` e uma em `subir`.
- `elevador`: sete obrigações de preservação do invariante em `passo` e duas
  de boa definição da escolha da direção nesse mesmo passo.

O workspace original usa obrigações no formato legado (`.pos` convertido de
`.pmi`), incompatível com `extprove`. Ele foi preservado.

### Workspace NG e Z3

Criei o projeto `projeto_metodos_formais_ng` em `ng/bdp/` e `ng/lang/`, migrei-o
para o gerador NG do Atelier B e gerei novamente as 664 obrigações. O Z3
4.13.3 está instalado localmente em `ng/usr/bin/z3`. As máquinas-fonte em
`elevador/` são compartilhadas pelos dois projetos.

Após a prova automática nativa em força 3 e o mecanismo externo `z3_pp` com
limite de 10 segundos por obrigação, o resultado do workspace NG é:

| Máquina | Provadas pelo Atelier B | Resolvidas pelo Z3, não confiáveis | Pendentes |
|---|---:|---:|---:|
| `painel_pedidos` | 197 | 31 | 8 |
| `cabine_movimento` | 54 | 2 | 0 |
| `elevador` | 363 | 2 | 7 |
| **Total** | **614** | **35** | **15** |

O mecanismo distribuído pelo Atelier B tem `trust="never"`. Assim, as 35
obrigações resolvidas pelo Z3 aparecem como *Unreliably proved* no Atelier B;
não são contabilizadas como provas confiáveis. Nenhuma obrigação foi marcada
como refutada. O log da execução está em `ng/bdp/z3-10s.log`.

As 15 pendências restantes são oito no painel (uma em
`registrar_externo_descida`, seis em `avancar_tempo_botoes`, uma em
`cancelamento_externo_subida`) e sete em `elevador.passo` (cinco de preservação
do invariante e duas de boa definição). Elas ainda exigem lemas, ajustes na
especificação ou prova interativa.

## ProB

Uma exploração limitada de estados processou 1.349 estados e 1.249.004
transições sem encontrar violação de invariante ou pré-condição. A exploração
foi encerrada pelo limite de 15 segundos, portanto não constitui enumeração
exaustiva do espaço de estados.

As operações de peso usam `NATURAL` e `INTEGER`, de modo que o espaço completo
é infinito. Por isso, a verificação exaustiva exige limitar explicitamente o
domínio de teste sem alterar o domínio abstrato usado para avaliação.

### Cenários simbólicos confirmados

- Inserir a chave durante uma subida faz a cabine parar no pavimento seguinte,
  ficar com `direcao = parado`, ativar a manutenção e cancelar os pedidos.
- Pressionar um botão durante a manutenção não cria pedido; após dois avanços
  de tempo, as duas fases de piscada terminam e o LED permanece apagado.
- Um pedido externo mantido pressionado por três segundos pode ser cancelado;
  ao final, o pedido e sua marca de tempo são removidos.

## Cobertura sintática da avaliação

O modelo utiliza relações e funções, sobrescrita, restrição de imagem,
inversão, imagem relacional, sequências, naturais e inteiros, compreensão de
conjuntos, operações sobre conjuntos, quantificadores universal e existencial,
`IF`, `SELECT`, `ANY`, `LET` e operações com e sem retorno.
