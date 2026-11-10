"""Traces e expectativas independentes para a politica de varredura HLR-010."""


def passos(n):
    return ['passo.'] * n


def pedido(andar, tipo='interno'):
    liberar = {'interno': 'interno', 'externo_subida': 'subida',
               'externo_descida': 'descida'}[tipo]
    return [f'pressionar_{tipo}(int({andar})).', f'liberar_{liberar}(int({andar})).']


def cenarios():
    vazio = 'pedidos_internos = {} & pedidos_subida = {} & pedidos_descida = {}'
    # Inicia subida ate 4, com parada em 2; um pedido atras chega durante movimento.
    subida = pedido(2) + pedido(4) + passos(2) + pedido(0)
    # Prepara repouso no topo: iniciar, quatro movimentos, abrir, fechar, repousar.
    topo = pedido(4) + passos(8)
    descida = topo + pedido(2) + pedido(0) + passos(2) + pedido(4)
    oposto = pedido(4) + pedido(2, 'externo_descida')
    return [
        ('subida_nao_inverte_por_pedido_atras', subida,
         'andar = 1 & direcao = subindo & sentido_atendimento = subindo & pedidos_internos = {0,2,4}'),
        ('subida_atende_intermediario', subida + passos(2),
         'andar = 2 & porta = aberta & sentido_atendimento = subindo & pedidos_internos = {0,4} & historico_paradas = [2]'),
        ('subida_continua_apos_parada', subida + passos(4),
         'andar = 2 & direcao = subindo & sentido_atendimento = subindo & pedidos_internos = {0,4}'),
        ('subida_inverte_no_ultimo_pedido', subida + passos(9),
         'andar = 4 & sentido_atendimento = descendo & porta = fechada & pedidos_internos = {0} & historico_paradas = [2,4]'),
        ('subida_atende_retorno', subida + passos(17),
         vazio + ' & andar = 0 & sentido_atendimento = parado & historico_paradas = [2,4,0]'),
        ('descida_nao_inverte_por_pedido_atras', descida,
         'andar = 3 & direcao = descendo & sentido_atendimento = descendo & pedidos_internos = {0,2,4}'),
        ('descida_atende_intermediario', descida + passos(2),
         'andar = 2 & porta = aberta & sentido_atendimento = descendo & pedidos_internos = {0,4} & historico_paradas = [4,2]'),
        ('descida_continua_apos_parada', descida + passos(4),
         'andar = 2 & direcao = descendo & sentido_atendimento = descendo & pedidos_internos = {0,4}'),
        ('descida_inverte_no_ultimo_pedido', descida + passos(9),
         'andar = 0 & sentido_atendimento = subindo & porta = fechada & pedidos_internos = {4} & historico_paradas = [4,2,0]'),
        ('descida_atende_retorno', descida + passos(17),
         vazio + ' & andar = 4 & sentido_atendimento = parado & historico_paradas = [4,2,0,4]'),
        ('chamada_oposta_aguarda_retorno', oposto + passos(3),
         'andar = 2 & direcao = subindo & pedidos_descida = {2} & historico_paradas = []'),
        ('chamada_oposta_atendida_no_retorno', oposto + passos(12),
         vazio + ' & andar = 2 & porta = aberta & historico_paradas = [4,2]'),
        ('inversao_antes_do_topo', pedido(3, 'externo_descida') + passos(5),
         'andar = 3 & sentido_atendimento = descendo & deslocamento = 3 & pedidos_descida = {3}'),
        ('inversao_antes_do_terreo', topo + pedido(1, 'externo_subida') + passos(5),
         'andar = 1 & sentido_atendimento = subindo & deslocamento = 7 & pedidos_subida = {1}'),
    ]
