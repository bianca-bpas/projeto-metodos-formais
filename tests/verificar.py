"""Regressões executadas no ProB: python3 tests/verificar.py [probcli]."""
from pathlib import Path
import re
import shutil
import subprocess
import sys
import tempfile

prob = sys.argv[1] if len(sys.argv) > 1 else '/opt/ProB/probcli'
root = Path(__file__).resolve().parents[1]
cases = {
    'pedido oposto não bloqueia subida': [
        'pressionar_interno(1)', 'pressionar_interno(3)', 'pressionar_externo_descida(1)',
        'elevador_iniciar_subida', 'elevador_subir', 'elevador_abrir_porta',
        'elevador_fechar_porta', 'elevador_iniciar_subida',
        '?andar = 1 & direcao = subindo & pedidos_descida = {1}'],
    'pedido oposto não bloqueia descida': [
        'pressionar_interno(3)', 'elevador_iniciar_subida', 'elevador_subir',
        'elevador_subir', 'elevador_subir', 'elevador_abrir_porta', 'elevador_fechar_porta',
        'pressionar_interno(2)', 'pressionar_interno(0)', 'pressionar_externo_subida(2)',
        'elevador_inverter_sentido', 'elevador_iniciar_descida', 'elevador_descer',
        'elevador_abrir_porta', 'elevador_fechar_porta', 'elevador_iniciar_descida',
        '?andar = 2 & direcao = descendo & pedidos_subida = {2}'],
    'limite de peso': ['atualizar_peso(451)', '?limite_peso_atingido = TRUE',
        'atualizar_peso(450)', 'pressionar_interno(1)', 'elevador_iniciar_subida',
        '?limite_peso_atingido = FALSE & direcao = subindo'],
    'porta e temporização': ['elevador_abrir_porta'] + ['passar_segundo'] * 120 + [
        '?porta = aberta & segundos_porta_aberta = 120', 'passar_segundo',
        '?segundos_porta_aberta > 120', 'elevador_fechar_porta',
        '?porta = fechada & segundos_porta_aberta = 0'],
    'manutenção parada e painéis': ['pressionar_interno(2)', 'inserir_chave',
        'pressionar_interno(1)', 'pressionar_externo_subida(0)', 'pressionar_externo_descida(4)',
        'elevador_abrir_porta', 'elevador_fechar_porta',
        '?manutencao = TRUE & pedidos_internos = {} & pedidos_subida = {} & pedidos_descida = {} & piscando_interno1 = {1} & piscando_abrir = 2 & piscando_fechar = 2 & porta = fechada',
        'remover_chave', 'elevador_abrir_porta', '?manutencao = FALSE & porta = aberta'],
    'manutenção em movimento': ['pressionar_interno(4)', 'elevador_iniciar_subida',
        'inserir_chave', '?manutencao_pendente = TRUE', 'elevador_subir',
        '?andar = 1 & direcao = parado & manutencao = TRUE & manutencao_pendente = FALSE & pedidos_internos = {}'],
    'retirada antes da parada': ['pressionar_interno(4)', 'elevador_iniciar_subida',
        'inserir_chave', 'remover_chave', 'elevador_subir',
        '?manutencao = FALSE & chave_manutencao = FALSE & pedidos_internos = {4}'],
    'último pedido interno não pode ser cancelado': ['pressionar_interno(4)',
        'elevador_cancelar_interno(4)',
        '?pedidos_internos = {4} & piscando_interno1 = {4}',
        'elevador_parar_piscar', '?piscando_interno1 = {} & piscando_interno2 = {4}',
        'elevador_parar_piscar', '?piscando_interno2 = {} & pedidos_internos = {4}'],
    'cancelamento do último pedido durante subida': ['pressionar_externo_descida(4)',
        'elevador_iniciar_subida', 'elevador_cancelar_descida(4)',
        '?parada_pendente = TRUE & pedidos_descida = {}', 'elevador_subir',
        '?andar = 1 & direcao = parado & parada_pendente = FALSE'],
    'manutenção durante descida': ['pressionar_interno(3)', 'elevador_iniciar_subida',
        'elevador_subir', 'elevador_subir', 'elevador_subir', 'elevador_abrir_porta',
        'elevador_fechar_porta', 'pressionar_interno(0)', 'elevador_inverter_sentido',
        'elevador_iniciar_descida', 'inserir_chave', 'elevador_descer',
        '?andar = 2 & direcao = parado & manutencao = TRUE & pedidos_internos = {}'],
    'manutenção com porta aberta e fim das piscadas': ['elevador_abrir_porta',
        'inserir_chave', 'elevador_fechar_porta', 'elevador_abrir_porta',
        '?manutencao = TRUE & porta = aberta & piscando_abrir = 2 & piscando_fechar = 2',
        'avancar_piscadas_porta', '?piscando_abrir = 1 & piscando_fechar = 1',
        'avancar_piscadas_porta', '?piscando_abrir = 0 & piscando_fechar = 0',
        'remover_chave', 'elevador_fechar_porta', '?porta = fechada'],
}
def verificar(cenarios):
    with tempfile.TemporaryDirectory() as tmp:
        for source in (root / 'elevador').glob('*.mch'):
            shutil.copy(source, tmp)
        for name, steps in cenarios.items():
            commands = []
            for step in steps:
                commands.append(step[1:] if step.startswith('?') else ':exec ' + step)
                commands.append('@INVARIANT')
            result = subprocess.run([prob, str(Path(tmp) / 'elevador.mch'), '-init', '-repl'],
                input='\n'.join(commands + [':q']) + '\n', text=True, capture_output=True, timeout=60)
            output = result.stdout + result.stderr
            expected = len(steps) + sum(step.startswith('?') for step in steps)
            if output.count('Predicate is TRUE') != expected or result.returncode or re.search(r'(?:Predicate is|Execution result:) FALSE|error|not enabled|no solution', output, re.I):
                print(output)
                raise SystemExit('FALHOU: ' + name)
            print('OK: ' + name, flush=True)


if __name__ == "__main__":
    verificar(cases)
