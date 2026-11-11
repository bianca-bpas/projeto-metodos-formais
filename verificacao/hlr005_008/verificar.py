"""Cenarios ProB para HLR-005/008. Executar na raiz do repositorio."""
import argparse
from pathlib import Path
import shutil
import subprocess
import sys
sys.path.insert(0, str(Path(__file__).resolve().parents[1]))
from prob_instancia import instancia_prob

ROOT = Path(__file__).resolve().parents[2]
OUTPUT = Path(__file__).resolve().parent
parser = argparse.ArgumentParser(description=__doc__)
parser.add_argument('probcli', nargs='?', default='/opt/ProB/probcli')
parser.add_argument('--andar-maximo', type=int, default=4,
                    help='fixar a constante andar_maximo na instância ProB (padrão: 4)')
args = parser.parse_args()
prob = shutil.which(args.probcli) or args.probcli
base = "machine('elevador').\n'$setup_constants'.\n'$initialise_machine'.\n"
tick = ['passar_tempo.']
cases = [
 ('antes_tres', ['pressionar_externo_subida(int(2)).']+tick*2, '2 : pedidos_subida & 2 : segurando_subida_2'),
 ('cancelamento', ['pressionar_externo_subida(int(2)).']+tick*3, 'pedidos_subida = {} & segurando_subida = {} & segurando_subida_1 = {} & segurando_subida_2 = {}'),
 ('liberacao', ['pressionar_externo_subida(int(2)).']+tick*2+['liberar_subida(int(2)).']+tick*3, '2 : pedidos_subida & segurando_subida = {} & segurando_subida_1 = {} & segurando_subida_2 = {}'),
 ('parada', ['pressionar_externo_subida(int(3)).','passo.']+tick*3+['passo.'], 'andar = 1 & direcao = parado & pedidos_subida = {}'),
 ('simultaneos', ['pressionar_interno(int(1)).','pressionar_interno(int(3)).']+tick*3, 'pedidos_internos = {1} & 1 : piscando_interno1 & interno_recusado = {1}'),
 ('outro_interno', ['pressionar_interno(int(1)).','liberar_interno(int(1)).','pressionar_interno(int(3)).']+tick*3, 'pedidos_internos = {1}'),
 ('manutencao_movimento', ['pressionar_interno(int(4)).','passo.','inserir_chave.','passo.'], 'manutencao = TRUE & andar = 1 & pedidos_internos = {}'),
 ('saida_manutencao', ['inserir_chave.','remover_chave_manutencao.','pressionar_interno(int(2)).'], 'manutencao = FALSE & pedidos_internos = {2}'),
]
for maintenance in [False, True]:
 prefix = ['inserir_chave.','pressionar_interno(int(2)).','pressionar_externo_subida(int(1)).','pressionar_externo_descida(int(3)).','pressionar_abrir.','pressionar_fechar.'] if maintenance else ['pressionar_interno(int(2)).']+tick*3
 for phase in range(5):
  pred = 'pedidos_internos = {} & pedidos_subida = {} & pedidos_descida = {}' if maintenance else 'pedidos_internos = {2} & interno_recusado = {2} & segurando_interno = {}'
  for n,v in [('interno',2)]+([('subida',1),('descida',3)] if maintenance else []):
   for k in range(1,5): pred += f' & piscando_{n}{k} = '+ ('{'+str(v)+'}' if phase==k-1 else '{}')
  if maintenance: pred += f' & piscando_abrir = {4-phase} & piscando_fechar = {4-phase} & porta = fechada'
  def conjunto(v, ligado):
   return f'avl_set(node(int({v}),true,0,empty,empty))' if ligado else '[]'
  ligado = phase in (0,2) or (not maintenance and phase == 4)
  saidas = [conjunto(2,ligado), conjunto(1,maintenance and ligado), conjunto(3,maintenance and ligado)]
  consulta = 'consultar_leds --> ['+', '.join(saidas)+'].'
  ops = prefix+tick*phase+[consulta]
  if maintenance:
   booleano = 'bool_true' if ligado else 'bool_false'
   ops += [f'consultar_leds_porta --> [{booleano}, {booleano}].']
  cases.append((f'pisca_{maintenance}_{phase}',ops,pred))
with instancia_prob(args.andar_maximo) as (instance_root, machine):
 for name, ops, pred in cases:
  trace=OUTPUT/(name+'.trace');trace.write_text(base+'\n'.join(ops)+'\n')
  r=subprocess.run([prob,str(machine),'-trace_replay','prolog',str(trace.resolve()),'-eval',pred],cwd=instance_root,capture_output=True,text=True,timeout=60)
  (OUTPUT/(name+'.log')).write_text(r.stdout+r.stderr)
  if r.returncode or 'Trace checking successful !' not in r.stdout or 'Predicate is TRUE' not in r.stdout: raise RuntimeError(name)
  print(name+': OK',flush=True)
print(f'{len(cases)} cenarios aprovados para andar_maximo={args.andar_maximo}.')
