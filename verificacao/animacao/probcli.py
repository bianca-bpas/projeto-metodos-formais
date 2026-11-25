#!/usr/bin/env python3
"""Adaptador para o core ProB distribuido com ProB2 UI (sem probcliparser.jar).
Compila as fontes recebidas com o parser Java do ProB2, reproduz o trace no
core ELF real e verifica o predicado final como guarda de uma operacao extra.
PROB_CORE e PROB_UI_JAR permitem selecionar a instalacao local.
"""
import os
from pathlib import Path
import shutil
import subprocess
import sys
import tempfile

args = sys.argv[1:]
machine = Path(args[0]).resolve()
trace = Path(args[args.index('-trace_replay') + 2]).resolve()
predicate = args[args.index('-eval') + 1]
core = Path(os.environ['PROB_CORE']).resolve()
jar = os.environ.get('PROB_UI_JAR', '/opt/prob2-ui/lib/app/prob2-ui-1.4.0-linux.jar')
with tempfile.TemporaryDirectory(prefix='animacao-prob-') as temp:
    root = Path(temp)
    for source in machine.parent.glob('*.mch'):
        shutil.copy(source, root / source.name)
    target = root / machine.name
    source = target.read_text()
    end = source.rfind('END')
    target.write_text(source[:end] + ';\n verificar_predicado = PRE ' + predicate +
                      ' THEN skip END\n' + source[end:])
    parser = root / 'parse.groovy'
    parser.write_text('''import de.be4.classicalb.core.parser.analysis.prolog.RecursiveMachineLoader
 def machine = RecursiveMachineLoader.loadFile(new File(args[0]))
 new File(args[1]).withPrintWriter('UTF-8') { machine.printAsProlog(it) }
''')
    compiled = root / (machine.stem + '.prob')
    subprocess.run(['java', '-cp', jar, 'groovy.ui.GroovyMain', str(parser),
                    str(target), str(compiled)], check=True)
    replay = root / 'cenario.trace'
    replay.write_text(trace.read_text() + '\nverificar_predicado.\n')
    result = subprocess.run([str(core), str(compiled), '-no_color',
                             '-trace_replay', 'prolog', str(replay)],
                            cwd=core.parent, capture_output=True, text=True)
    print(result.stdout + result.stderr)
    if result.returncode == 0 and 'Trace checking successful !' in result.stdout:
        print('Predicate is TRUE (guarda verificar_predicado executada no ProB)')
    sys.exit(result.returncode)
