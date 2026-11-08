"""Auditoria: inclui reproduções de lacunas, não apenas comportamentos desejados.

Execute: python3 tests/bordas.py [probcli]. Ver docs/revisao-requisitos.md.
"""
from verificar import verificar

ir_ao_primeiro = [
    'pressionar_interno(1)', 'elevador_iniciar_subida', 'elevador_subir',
    'elevador_abrir_porta', 'elevador_fechar_porta', 'elevador_entrar_em_reposo',
]
pedidos_extremos = ['pressionar_interno(0)', 'pressionar_interno(4)']

cenarios = {
    'LACUNA: cancelamento sem passagem de tempo': [
        'pressionar_externo_subida(2)', 'elevador_cancelar_subida(2)',
        '?pedidos_subida = {}'],
    'LACUNA: piscada permanece após cancelamento aceito': [
        'pressionar_interno(1)', 'elevador_cancelar_interno(1)',
        'pressionar_interno(2)', 'elevador_cancelar_interno(1)',
        '?pedidos_internos = {2} & piscando_interno1 = {1}'],
    'LACUNA: piscada permanece após atendimento': [
        'pressionar_interno(0)', 'elevador_cancelar_interno(0)', 'elevador_abrir_porta',
        '?pedidos_internos = {} & piscando_interno1 = {0}'],
    'LACUNA: ciclo repetível sem atender pedido': [
        'pressionar_interno(4)',
        'elevador_abrir_porta', 'elevador_fechar_porta',
        'elevador_abrir_porta', 'elevador_fechar_porta',
        '?andar = 0 & direcao = parado & sentido_atendimento = parado & porta = fechada & pedidos_internos = {4} & deslocamento = 0 & segundos_porta_aberta = 0'],
    'LACUNA: trajeto permitido com custo 7 a partir do andar 1':
        ir_ao_primeiro + pedidos_extremos + [
            'elevador_iniciar_subida', 'elevador_subir', 'elevador_subir', 'elevador_subir',
            'elevador_abrir_porta', 'elevador_fechar_porta', 'elevador_inverter_sentido',
            'elevador_iniciar_descida'] + ['elevador_descer'] * 4 + [
            'elevador_abrir_porta', '?pedidos_internos = {} & deslocamento = 8'],
    'comparação: mesmos pedidos com custo 5 a partir do andar 1':
        ir_ao_primeiro + pedidos_extremos + [
            'elevador_iniciar_descida', 'elevador_descer', 'elevador_abrir_porta',
            'elevador_fechar_porta', 'elevador_inverter_sentido',
            'elevador_iniciar_subida'] + ['elevador_subir'] * 4 + [
            'elevador_abrir_porta', '?pedidos_internos = {} & deslocamento = 6'],
    'pedido repetido não duplica e cancelamento parcial preserva o outro': [
        'pressionar_interno(1)', 'pressionar_interno(1)', 'pressionar_interno(2)',
        'elevador_cancelar_interno(1)', '?pedidos_internos = {2}'],
    'duas direções no mesmo andar são atendidas separadamente': ir_ao_primeiro + [
        'pressionar_externo_subida(1)', 'pressionar_externo_descida(1)',
        'elevador_abrir_porta', '?pedidos_subida = {} & pedidos_descida = {1}',
        'elevador_fechar_porta', 'elevador_inverter_sentido', 'elevador_abrir_porta',
        '?pedidos_descida = {} & andar = 1 & deslocamento = 1'],
    'cancelamento na descida e novo pedido não eliminam parada obrigatória':
        ir_ao_primeiro + ['pressionar_externo_subida(0)', 'elevador_iniciar_descida',
            'elevador_cancelar_subida(0)', 'pressionar_interno(4)', 'elevador_descer',
            '?andar = 0 & direcao = parado & parada_pendente = FALSE & pedidos_internos = {4}'],
    'manutenção pendente aceita pedidos mas cancela todos ao parar': [
        'pressionar_interno(4)', 'elevador_iniciar_subida', 'inserir_chave',
        'pressionar_externo_subida(2)', 'pressionar_externo_descida(3)',
        'elevador_subir', '?andar = 1 & manutencao = TRUE & pedidos_internos = {} & pedidos_subida = {} & pedidos_descida = {}'],
    'peso 0, 449, 450 e 451': [
        'atualizar_peso(0)', '?limite_peso_atingido = FALSE',
        'atualizar_peso(449)', '?limite_peso_atingido = FALSE',
        'atualizar_peso(450)', '?limite_peso_atingido = FALSE',
        'atualizar_peso(451)', '?limite_peso_atingido = TRUE & direcao = parado'],
    'porta reaberta reinicia contagem': ['elevador_abrir_porta'] + ['passar_segundo'] * 121 + [
        '?segundos_porta_aberta = 121', 'elevador_fechar_porta', 'elevador_abrir_porta',
        '?segundos_porta_aberta = 0'],
}

if __name__ == '__main__':
    verificar(cenarios)
