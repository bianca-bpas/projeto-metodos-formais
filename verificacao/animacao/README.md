# Validação da animação — 2026-11-25

Executado nesta revisão, com `andar_maximo = 4`:

- ProB: 17/17 cenários de porta, retenção, manutenção, sobrecarga e entrega idempotente; 30/30 cenários HLR-005/008 de regressão.
- Ponte JavaScript: 11/11 testes para atraso e descarte de eventos, concorrência, pausa, perda de foco e aceleração da retenção.
- VisB real: retenção, comandos concorrentes, pausa, aviso em 120/121 s, manutenção, perda de foco e chegada após trecho verificados em `visb.groovy` antes da troca dos avisos por ícones. Os novos ícones tiveram SVG e expressões JSON conferidos estaticamente; `visb_icones.groovy` permite a conferência visual no aplicativo.
- Atelier B: obrigações regeneradas e provadas na revisão do modelo B: 1096/1096 em cinco máquinas (incluindo o adaptador `animacao`). As bases locais são descartáveis; os arquivos em `provas/nativas/` são históricos.

Com **Segurar porta** confirmado, cada tick do relógio executa dez avanços B em uma transição; o contador visível salta de 10 em 10. A soltura restaura um avanço por tick. Cada transição aguarda confirmação do ProB, então a latência pode alongar o intervalo observado entre saltos. A pausa congela o tempo simulado.

Para repetir os testes locais, use `node verificacao/animacao/ponte.test.js` e `python3 verificacao/animacao/verificar.py CAMINHO_PROBCLI`. A instalação ProB2 UI deste ambiente fornece um core ELF sem `probcliparser.jar`; `probcli.py` adapta o parser Java do aplicativo para os cenários. A interface real exige acesso à janela gráfica e a um socket local. Nenhum desses testes demonstra justiça temporal do HLR-010.
