"""Cenarios HLR-001..009 e protocolo de entrega; nenhuma afirmacao sobre HLR-010."""
import argparse
from pathlib import Path
import subprocess
import sys
sys.path.insert(0, str(Path(__file__).resolve().parents[1]))
from prob_instancia import instancia_prob

parser = argparse.ArgumentParser(description=__doc__)
parser.add_argument('probcli')
args = parser.parse_args()
out = Path(__file__).parent
cases = []
tick = ['passar_tempo.']
opened = ['pressionar_abrir.']
held = opened + ['segurar_porta.']
for n in [120, 121, 130]:
    cases.append((f'porta_{n}', held + tick*n,
                  f'porta = aberta & porta_retida = TRUE & segundos_porta_aberta = {min(n,121)}', 'elevador'))
cases += [
 ('novo_pedido_nao_zera', held + tick*20 + ['pressionar_interno(int(0)).', 'liberar_interno(int(0)).', 'passo.'],
  'segundos_porta_aberta = 20 & porta_retida = TRUE & pedidos_internos = {}', 'elevador'),
 ('bloqueio_fechamento', held + ['pressionar_fechar.', 'pressionar_interno(int(4)).', 'liberar_interno(int(4)).'] + ['passo.']*4,
  'andar = 0 & direcao = parado & porta = aberta & porta_retida = TRUE & pedidos_internos = {4}', 'elevador'),
 ('liberar_fecha_reabre', held + tick*121 + ['liberar_porta.', 'passo.', 'pressionar_abrir.'],
  'porta = aberta & porta_retida = FALSE & segundos_porta_aberta = 0', 'elevador'),
 ('manutencao_conta', held + tick*120 + ['inserir_chave.', 'segurar_porta.', 'pressionar_interno(int(2)).'] + tick,
  'manutencao = TRUE & porta_retida = FALSE & segundos_porta_aberta = 121 & pedidos_internos = {}', 'elevador'),
 ('retencao_movimento', ['pressionar_interno(int(4)).', 'liberar_interno(int(4)).', 'passo.', 'segurar_porta.'],
  'direcao = subindo & porta = fechada & porta_retida = FALSE & andar = 0', 'elevador'),
 ('retencao_nao_abre', ['segurar_porta.'], 'porta = fechada & porta_retida = FALSE', 'elevador'),
 ('peso_450', ['atualizar_peso(int(450)).', 'pressionar_interno(int(4)).', 'liberar_interno(int(4)).', 'passo.'],
  'direcao = subindo & limite_peso_atingido = FALSE', 'elevador'),
 ('peso_525', ['atualizar_peso(int(525)).', 'pressionar_interno(int(4)).', 'liberar_interno(int(4)).', 'passo.'],
  'direcao = parado & andar = 0 & limite_peso_atingido = TRUE', 'elevador'),
 ('peso_retomada', ['atualizar_peso(int(525)).', 'pressionar_interno(int(4)).', 'liberar_interno(int(4)).', 'passo.', 'ajustar_peso(int(-75)).', 'passo.'],
  'direcao = subindo & peso = 450', 'elevador'),
 ('retencao_salto_dez', ['entregar(int(1),int(8),int(0)).', 'entregar(int(2),int(13),int(0)).', 'entregar(int(3),int(0),int(0)).'],
  'segundos_porta_aberta = 10 & porta_retida = TRUE & ultimo_evento = 3', 'animacao'),
 ('retencao_120_121', ['entregar(int(1),int(8),int(0)).', 'entregar(int(2),int(13),int(0)).'] +
  [f'entregar(int({i}),int(0),int(0)).' for i in range(3,15)],
  'segundos_porta_aberta = 120 & porta_retida = TRUE', 'animacao'),
 ('retencao_volta_ao_normal', ['entregar(int(1),int(8),int(0)).', 'entregar(int(2),int(13),int(0)).',
                              'entregar(int(3),int(0),int(0)).', 'entregar(int(4),int(14),int(0)).',
                              'entregar(int(5),int(0),int(0)).'],
  'segundos_porta_aberta = 11 & porta_retida = FALSE', 'animacao'),
 ('entrega_repetida', ['entregar(int(1),int(8),int(0)).', 'entregar(int(2),int(0),int(0)).',
                       'entregar(int(2),int(0),int(0)).', 'entregar(int(1),int(9),int(0)).'],
  'ultimo_evento = 2 & segundos_porta_aberta = 1 & porta = aberta', 'animacao'),
 ('comando_invalido_confirmado', ['entregar(int(1),int(12),int(-75)).'],
  'ultimo_evento = 1 & peso = 0', 'animacao'),
]
with instancia_prob(4) as (root, machine):
    for name, ops, predicate, model in cases:
        trace = out / (name + '.trace')
        trace.write_text(f"machine('{model}').\n'$setup_constants'.\n'$initialise_machine'.\n" + '\n'.join(ops) + '\n')
        result = subprocess.run([args.probcli, str(machine.with_name(model + '.mch')), '-no_color',
                                 '-trace_replay', 'prolog', str(trace.resolve()), '-eval', predicate],
                                cwd=root, capture_output=True, text=True, timeout=60)
        (out / (name + '.log')).write_text(result.stdout + result.stderr)
        assert result.returncode == 0 and 'Trace checking successful !' in result.stdout and 'Predicate is TRUE' in result.stdout, name
        print(name + ': OK', flush=True)
print(f'{len(cases)} cenarios aprovados.')
