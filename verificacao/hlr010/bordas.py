"""Cenarios de fronteira executados no modelo B pelo ProB."""
from pathlib import Path
from cenarios import pedido, passos
import verificar


def cenarios_borda():
    vazio = 'pedidos_internos = {} & pedidos_subida = {} & pedidos_descida = {}'
    meio = pedido(2) + passos(6)
    cases = [
        ('repouso_inicial', [], vazio + ' & andar = 0 & sentido_atendimento = parado & direcao = parado'),
        ('pedido_no_andar_atual', pedido(0) + passos(2), vazio + ' & deslocamento = 0 & sentido_atendimento = parado'),
        ('chamadas_opostas_no_andar_atual', meio + pedido(2, 'externo_subida') + pedido(2, 'externo_descida') + passos(4),
         vazio + ' & andar = 2 & porta = aberta'),
        ('prioridade_subida_com_chamadas_opostas', meio + pedido(2, 'externo_subida') + pedido(2, 'externo_descida') + passos(1),
         'pedidos_subida = {} & pedidos_descida = {2} & sentido_atendimento = subindo & porta = aberta'),
        ('empate_inicial_escolhe_subida', meio + pedido(1) + pedido(3) + passos(1),
         'andar = 2 & direcao = subindo & pedidos_internos = {1,3}'),
        ('porta_aberta_fecha_antes_de_mover', pedido(0) + passos(1) + pedido(4) + passos(1),
         'andar = 0 & porta = fechada & direcao = parado & pedidos_internos = {4}'),
        ('manutencao_cancela_pedidos', pedido(4) + ['inserir_chave.'],
         vazio + ' & manutencao = TRUE & direcao = parado'),
        ('retoma_apos_sobrecarga', pedido(4) + ['atualizar_peso(int(451)).'] + passos(1) + ['atualizar_peso(int(450)).'] + passos(1),
         'andar = 0 & direcao = subindo & pedidos_internos = {4}'),
        ('todos_externos_cancelados_em_movimento', pedido(4) + passos(8) + ['pressionar_externo_subida(int(0)).'] + passos(1) + ['passar_tempo.']*3 + passos(1),
         vazio + ' & andar = 3 & direcao = parado'),
    ]
    for peso in (0, 449, 450, 451):
        cases.append((f'peso_{peso}', pedido(4) + [f'atualizar_peso(int({peso})).'] + passos(1),
                      'andar = 0 & pedidos_internos = {4} & direcao = ' + ('parado' if peso > 450 else 'subindo')))
    return cases


if __name__ == '__main__':
    verificar.cenarios = cenarios_borda
    verificar.OUTPUT = Path(__file__).resolve().parent / 'bordas'
    verificar.OUTPUT.mkdir(exist_ok=True)
    raise SystemExit(verificar.main())
