"""Executa os cenarios HLR-010 no modelo B real por meio do ProB."""
import argparse
from pathlib import Path
import shutil
import subprocess
import sys

sys.path.insert(0, str(Path(__file__).resolve().parents[1]))
from prob_instancia import instancia_prob
from cenarios import cenarios

ROOT = Path(__file__).resolve().parents[2]
OUTPUT = Path(__file__).resolve().parent
BASE = "machine('elevador').\n'$setup_constants'.\n'$initialise_machine'.\n"


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('probcli', nargs='?', default='/opt/ProB/probcli')
    parser.add_argument('--cenario', help='Executar somente o cenario indicado')
    parser.add_argument('--andar-maximo', type=int, default=4,
                        help='fixar a constante andar_maximo na instância ProB (padrão: 4)')
    args = parser.parse_args()
    cases = cenarios()
    if args.cenario:
        cases = [case for case in cases if case[0] == args.cenario]
        if not cases:
            parser.error('cenario desconhecido')
    results = []
    probcli = shutil.which(args.probcli) or args.probcli
    with instancia_prob(args.andar_maximo) as (instance_root, machine):
        for name, ops, predicate in cases:
            trace = OUTPUT / (name + '.trace')
            trace.write_text(BASE + '\n'.join(ops) + '\n')
            command = [probcli, str(machine), '-trace_replay',
                       'prolog', str(trace.resolve()), '-eval', predicate]
            try:
                run = subprocess.run(command, cwd=instance_root, capture_output=True,
                                     text=True, timeout=90)
                log = run.stdout + run.stderr
                ok = (run.returncode == 0 and 'Trace checking successful !' in run.stdout
                      and 'Predicate is TRUE' in run.stdout)
            except (OSError, subprocess.TimeoutExpired) as exc:
                log, ok = str(exc), False
            (OUTPUT / (name + '.log')).write_text(f'Predicado esperado: {predicate}\n' + log)
            results.append((name, ok))
            print(f'{name}: {"OK" if ok else "FALHOU"}', flush=True)
    approved = sum(ok for _, ok in results)
    summary = '\n'.join(f'{name}: {"OK" if ok else "FALHOU"}' for name, ok in results)
    summary += f'\n{approved}/{len(results)} cenarios aprovados.\n'
    (OUTPUT / ('resultado-' + args.cenario + '.txt' if args.cenario else 'resultados.txt')).write_text(summary)
    print(f'{approved}/{len(results)} cenarios aprovados.')
    return 0 if approved == len(results) else 1


if __name__ == '__main__':
    sys.exit(main())
