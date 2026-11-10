"""Enumera botoes validos em manutencao e fronteiras de cancelamento no ProB."""
from pathlib import Path
from cenarios import pedido, passos
import verificar

BOTOES = [('interno', p) for p in range(5)] + [('externo_subida', p) for p in range(4)] + [('externo_descida', p) for p in range(1, 5)]
VAZIO = 'pedidos_internos = {} & pedidos_subida = {} & pedidos_descida = {}'


def cenarios_interacao():
    cases = []
    for tipo, p in BOTOES:
        grupo = {'interno': 'interno', 'externo_subida': 'subida', 'externo_descida': 'descida'}[tipo]
        conjunto = {'interno': 'pedidos_internos', 'subida': 'pedidos_subida', 'descida': 'pedidos_descida'}[grupo]
        press = f'pressionar_{tipo}(int({p})).'
        release = f'liberar_{grupo}(int({p})).'
        # Chave inserida em movimento; proximo andar ativa manutencao.
        prefix = pedido(4) + passos(1) + ['inserir_chave.'] + passos(1)
        cases.append((f'manutencao_recusa_{tipo}_{p}', prefix + [press],
                      VAZIO + f' & andar = 1 & manutencao = TRUE & piscando_{grupo}1 = {{{p}}}'))
        # Um segundo pedido interno liberado permite cancelar qualquer alvo interno.
        outros = pedido((p+1)%5) if tipo == 'interno' else []
        cases.append((f'cancelamento_{tipo}_{p}', outros + [press] + ['passar_tempo.']*3,
                      f'{p} /: {conjunto} & segurando_{grupo} = {{}} & segurando_{grupo}_1 = {{}} & segurando_{grupo}_2 = {{}}'))
        cases.append((f'liberacao_no_limite_{tipo}_{p}', [press] + ['passar_tempo.']*2 + [release] + ['passar_tempo.']*2,
                      f'{conjunto} = {{{p}}} & segurando_{grupo} = {{}}'))
    for botao in ('abrir', 'fechar'):
        cases.append((f'porta_{botao}_em_manutencao', ['inserir_chave.', f'pressionar_{botao}.'],
                      VAZIO + f' & porta = fechada & piscando_{botao} = 4 & manutencao = TRUE'))
        cases.append((f'porta_{botao}_em_movimento', pedido(4) + passos(1) + [f'pressionar_{botao}.'],
                      'andar = 0 & porta = fechada & direcao = subindo & pedidos_internos = {4}'))
    cases += [
        ('saida_manutencao_reaceita_todos_botoes', ['inserir_chave.', 'remover_chave_manutencao.'] + [op for tipo,p in BOTOES for op in pedido(p,tipo)],
         'manutencao = FALSE & pedidos_internos = 0..4 & pedidos_subida = 0..3 & pedidos_descida = 1..4'),
        ('repeticao_botao_nao_duplica_pedido', ['pressionar_interno(int(2)).']*3,
         'pedidos_internos = {2} & card(pedidos_internos) = 1'),
        ('recusa_nao_reinicia_piscada', ['pressionar_interno(int(2)).'] + ['passar_tempo.']*10,
         'pedidos_internos = {2} & interno_recusado = {2} & piscando_interno1 = {} & piscando_interno2 = {} & piscando_interno3 = {} & piscando_interno4 = {}'),
        ('liberar_recusa_permite_novo_ciclo', ['pressionar_interno(int(2)).'] + ['passar_tempo.']*7 + ['liberar_interno(int(2)).', 'pressionar_interno(int(2)).'] + ['passar_tempo.']*3,
         'pedidos_internos = {2} & interno_recusado = {2} & piscando_interno1 = {2}'),
    ]
    return cases


if __name__ == '__main__':
    verificar.cenarios = cenarios_interacao
    verificar.OUTPUT = Path(__file__).resolve().parent / 'interacoes'
    verificar.OUTPUT.mkdir(exist_ok=True)
    raise SystemExit(verificar.main())
