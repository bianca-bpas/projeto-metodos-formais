# Cenários complementares

Traces preservados para percurso, aviso de porta aberta e sobrecarga.
`resultados.txt` registra resultados históricos; estes cenários não integram
os 18 testes da reconciliação atual.

Na raiz do projeto, para repetir o exemplo de percurso não mínimo:

```sh
/opt/ProB/probcli elevador/elevador.mch -trace_replay prolog verificacao/cenarios/deslocamento.trace -eval 'deslocamento = 8 & andar = 0 & pedidos_internos = {}'
```

Para `porta_121.trace`, use o predicado `segundos_porta_aberta = 121 & porta = aberta`;
para `sobrecarga.trace`, use `limite_peso_atingido = TRUE & direcao = parado`.
O percurso inclui um andar de preparação e sete de atendimento. Uma alternativa
atende os mesmos pedidos em cinco andares. Isso ilustra o limite da política
local, sem demonstrar justiça temporal.
