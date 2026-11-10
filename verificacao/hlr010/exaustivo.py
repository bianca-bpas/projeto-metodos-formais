"""Enumeracao exaustiva da projecao finita da politica HLR-010.

Nao executa B: traduz passo/subir/descer/atendimento para Python. Os traces
ProB conferem separadamente o modelo real. Sem novas chamadas, cancelamentos,
manutencao, sobrecarga ou intervencao na porta durante cada percurso.
"""
from itertools import product
from pathlib import Path
import json


def transicao(s):
    andar, movimento, sentido, porta, interno, subida, descida = s
    pedidos = interno | subida | descida
    local = 1 << andar
    if movimento:
        andar += movimento
        adiante = pedidos & (31 ^ ((1 << (andar + 1)) - 1)) if movimento == 1 else pedidos & ((1 << andar) - 1)
        compativeis = interno | (subida if movimento == 1 else descida)
        if compativeis & (1 << andar) or not adiante or andar == 4:
            movimento = 0
    elif porta:
        porta = False
    elif not pedidos:
        sentido = 0
    elif (interno | (subida if sentido != -1 else 0) | (descida if sentido != 1 else 0)) & local:
        porta = True
        if sentido == 0:
            if subida & local:
                sentido = 1
            elif descida & local:
                sentido = -1
        # B usa o sentido anterior no atendimento paralelo a abrir_porta.
        anterior = s[2]
        interno &= ~local
        if anterior != -1:
            subida &= ~local
        if anterior == -1 or (anterior == 0 and not (s[5] & local)):
            descida &= ~local
    else:
        acima = pedidos & (31 ^ ((1 << (andar + 1)) - 1))
        abaixo = pedidos & ((1 << andar) - 1)
        if (sentido == 1 and not acima) or (sentido == -1 and not abaixo):
            sentido = -sentido
        elif sentido:
            movimento = sentido
        elif not abaixo:
            movimento = sentido = 1
        elif not acima:
            movimento = sentido = -1
        else:
            dist_cima = min(i - andar for i in range(andar + 1, 5) if pedidos & (1 << i))
            dist_baixo = min(andar - i for i in range(andar) if pedidos & (1 << i))
            movimento = sentido = 1 if dist_cima <= dist_baixo else -1
    return andar, movimento, sentido, porta, interno, subida, descida


def conferir(antes, depois):
    a, m, sentido, porta, i, u, d = antes
    b, n, novo, aberta, j, v, e = depois
    assert 0 <= b <= 4, ('limite', antes, depois)
    assert not n or not aberta, ('porta em movimento', antes, depois)
    assert abs(b-a) <= 1
    assert not (j & ~i or v & ~u or e & ~d), ('pedido inventado', antes, depois)
    removidos = (i ^ j) | (u ^ v) | (d ^ e)
    if removidos:
        assert not m and not porta and aberta and a == b
        assert removidos == 1 << a
        assert sentido != -1 or u == v
        assert sentido != 1 or d == e
    if sentido and novo == -sentido:
        pedidos = i | u | d
        assert not m and not porta
        assert not any(pedidos & (1 << x) for x in range(5) if (x-a)*sentido > 0)
    if m:
        assert b == a+m and novo == sentido


def main():
    Path(__file__).with_name('exaustivo.json').unlink(missing_ok=True)
    total = transicoes = max_passos = 0
    pior = None
    # Todas as combinacoes de pedidos: 32 internos x 16 subida x 16 descida.
    for i, u, d0 in product(range(32), range(16), range(16)):
        d = d0 << 1
        for a in range(5):
            estados = [(a, 0, s, p, i, u, d) for s in (-1, 0, 1) for p in (False, True)]
            estados += [(a, m, m, False, i, u, d) for m in (-1, 1) if 0 <= a+m <= 4]
            for inicial in estados:
                s, vistos, passos = inicial, set(), 0
                while s[1] or s[2] or s[3] or s[4] or s[5] or s[6]:
                    assert s not in vistos, ('ciclo sem atendimento completo', inicial, s)
                    vistos.add(s)
                    t = transicao(s)
                    conferir(s, t)
                    s = t
                    passos += 1
                total += 1
                transicoes += passos
                if passos > max_passos:
                    max_passos, pior = passos, inicial
    result = dict(estados_iniciais=total, transicoes_verificadas=transicoes,
                  maximo_passos_ate_reposo=max_passos, caso_mais_longo=pior,
                  falhas=0, escopo='projecao Python finita, pedidos fixos, sem bloqueios ambientais')
    output = Path(__file__).with_name('exaustivo.json')
    output.write_text(json.dumps(result, indent=2, ensure_ascii=False)+'\n')
    print(output.read_text())


if __name__ == '__main__':
    main()
