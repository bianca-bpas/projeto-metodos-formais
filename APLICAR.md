# Aplicar ao projeto original

As correções foram preparadas nesta cópia porque a sessão não tem permissão de
escrita no projeto original. O patch foi conferido com `git apply --check` no
original e aplicado numa cópia temporária, com comparação byte a byte dos 12
arquivos alterados/adicionados.

No seu terminal:

```sh
cd /home/araujo/Projetos/elevador/projeto-metodos-formais
git apply --check '/home/araujo/Graduação/7º período/Medotos Formais/elevador_correcoes.patch'
git apply '/home/araujo/Graduação/7º período/Medotos Formais/elevador_correcoes.patch'
```

O patch parte do estado local atual, incluindo as alterações não commitadas da
sessão anterior. Não é um patch relativo apenas ao último commit.

Validação: 32 cenários e 620 lotes finitos passaram no ProB. Custo mínimo
verificado para os 160 lotes internos. Otimização geral com chamadas externas
continua pendente; ver `docs/revisao-requisitos.md`.
