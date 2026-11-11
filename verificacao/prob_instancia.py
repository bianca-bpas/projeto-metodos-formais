"""Cria uma cópia temporária do modelo com andar_maximo fixado para ProB."""
from contextlib import contextmanager
from pathlib import Path
import shutil
import tempfile


ROOT = Path(__file__).resolve().parents[1]


@contextmanager
def instancia_prob(andar_maximo):
    """Força uma instância finita sem alterar as fontes versionadas."""
    if andar_maximo < 1:
        raise ValueError('andar_maximo deve ser maior ou igual a 1')

    with tempfile.TemporaryDirectory(prefix='elevador-prob-') as temp:
        temp_root = Path(temp)
        modelo = temp_root / 'elevador'
        shutil.copytree(ROOT / 'elevador', modelo,
                        ignore=shutil.ignore_patterns('*.prob', 'bdp'))

        configuracao = modelo / 'configuracao.mch'
        fonte = configuracao.read_text(encoding='utf-8')
        alvo = 'andar_maximo > 0 &'
        if fonte.count(alvo) != 1:
            raise RuntimeError('não foi possível localizar a propriedade de andar_maximo')
        configuracao.write_text(
            fonte.replace(alvo, f'andar_maximo > 0 &\n    andar_maximo = {andar_maximo} &'),
            encoding='utf-8')
        yield temp_root, modelo / 'elevador.mch'
