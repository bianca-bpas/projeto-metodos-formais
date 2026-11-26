// Fila unica com confirmacao B. Reenvios conservam o numero: entregar e
// idempotente, inclusive se uma resposta chegar depois de outra tentativa.
(() => {
    const el = id => document.getElementById(id);
    const painel = el('simulacao');
    const cabine = el('cabine_animada');
    const fila = [];
    const gestos = new Map();
    let sequencia = 0;
    let executando = false;
    let agora = 0;
    let anterior = performance.now();
    let segundo = 1000;
    let passo = 1500;
    let trecho = null;

    function animar() {
        const delta = Number(cabine.getAttribute('data-delta'));
        const andar = el('vi_num').textContent;
        if (!delta) {
            if (trecho) passo = agora + 1500;
            trecho = null;
            cabine.removeAttribute('transform');
        } else {
            if (!trecho || trecho.andar !== andar || trecho.delta !== delta) {
                trecho = {andar, delta, inicio: agora};
                passo = agora + 6000;
            }
            cabine.setAttribute('transform', 'translate(0 ' +
                Math.min(1, (agora - trecho.inicio) / 6000) * delta + ')');
        }
    }

    function enviar(id, temporal = false, confirmar = null) {
        fila.push({id, temporal, confirmar, numero: null, tentativa: -Infinity});
        bombear();
    }

    function bombear() {
        if (painel.getAttribute('data-pronto') !== 'sim') return;
        const confirmado = Number(painel.getAttribute('data-confirmado'));
        sequencia = Math.max(sequencia, confirmado);
        const evento = fila[0];
        if (!evento) return;
        if (evento.numero !== null && confirmado >= evento.numero) {
            fila.shift();
            animar();
            if (evento.confirmar) evento.confirmar();
            // Outro ciclo permite que o VisB termine a atualizacao do DOM.
            return;
        }
        // Um tick ja enviado termina atomicamente, inclusive ao pausar.
        // Seu reenvio idempotente nao pode bloquear a soltura atras dele.
        if (evento.temporal && !executando && evento.numero === null) return;
        if (evento.numero === null) evento.numero = ++sequencia;
        if (performance.now() - evento.tentativa < 750) return;
        evento.tentativa = performance.now();
        window.visb_vars = window.visb_vars || {};
        window.visb_vars.evento = String(evento.numero);
        el('evento_' + evento.id).dispatchEvent(new MouseEvent('click', {bubbles: true}));
    }

    function atualizar() {
        const real = performance.now();
        // A simulacao espera a ponte: latencia nao cria rajadas de ticks nem
        // encurta trechos. Pausa congela todos os tempos simulados.
        if (executando && !fila.length && painel.getAttribute('data-pronto') === 'sim') {
            agora += real - anterior;
        }
        anterior = real;
        bombear();
        animar();
        if (!executando || fila.length || painel.getAttribute('data-pronto') !== 'sim') return;
        // Nao use a fracao de segundo anterior a uma pressao para cancelar.
        // O vencimento global e preservado: a fracao volta a contar na soltura.
        const limites = [...gestos.values()]
            .filter(g => g.inicio !== null && g.botao.id !== 'segurar_porta')
            .map(g => g.inicio + Math.floor((agora - g.inicio) / 1000) * 1000);
        const limite = Math.min(agora, ...limites);
        if (limite >= segundo) {
            segundo += 1000;
            enviar('btn_tick', true);
        } else if (agora >= passo) {
            passo = agora + 1500;
            if (painel.getAttribute('data-passo') === 'sim') enviar('btn_passo', true);
        }
        const inicios = [...gestos.values()].map(g => g.inicio).filter(t => t !== null);
        el('tempo_retencao').textContent = inicios.length ?
            Math.floor((agora - Math.min(...inicios)) / 1000) + ' s' : '—';
    }

    function soltar(pointerId) {
        const gesto = gestos.get(pointerId);
        if (!gesto) return;
        atualizar();
        gestos.delete(pointerId);
        enviar(gesto.botao.dataset.liberar);
        if (!gestos.size) el('tempo_retencao').textContent = '—';
    }
    function soltarTodos() {
        [...gestos.keys()].forEach(soltar);
    }

    document.addEventListener('pointerdown', evento => {
        const botao = evento.target.closest('[data-liberar]');
        if (evento.button !== 0 || !botao || gestos.has(evento.pointerId) ||
            [...gestos.values()].some(g => g.botao === botao)) return;
        if (botao.getAttribute('data-habilitado') === 'nao' ||
            Number(botao.getAttribute('data-fase') || 0) < 0) return;
        evento.preventDefault();
        atualizar();
        const gesto = {botao, inicio: null};
        gestos.set(evento.pointerId, gesto);
        if (botao.setPointerCapture && evento.isTrusted) botao.setPointerCapture(evento.pointerId);
        enviar('pressionar_' + botao.id, false, () => { gesto.inicio = agora; });
    });
    window.addEventListener('pointerup', e => soltar(e.pointerId), true);
    window.addEventListener('pointercancel', e => soltar(e.pointerId), true);
    document.addEventListener('lostpointercapture', e => soltar(e.pointerId), true);
    window.addEventListener('blur', soltarTodos);
    window.addEventListener('pagehide', soltarTodos);
    document.addEventListener('visibilitychange', () => {
        if (document.hidden) soltarTodos();
    });

    ['btn_abrir', 'btn_fechar', 'btn_chave', 'btn_chave2', 'btn_peso0', 'btn_peso1'].forEach(id => {
        el(id).addEventListener('click', () => { atualizar(); enviar(id); });
    });
    el('alternar_tempo').addEventListener('click', () => {
        atualizar();
        executando = !executando;
        // Eventos temporais ainda nao enviados nao podem bloquear uma soltura.
        if (!executando) {
            for (let i = fila.length - 1; i >= 0; i--) {
                if (fila[i].temporal && fila[i].numero === null) fila.splice(i, 1);
            }
        }
        anterior = performance.now();
        el('acao_tempo').textContent = executando ? 'Ⅱ Pausar tempo' : '▶ Passar tempo';
        el('estado_tempo').textContent = executando ? 'Em execução' : 'Pausado';
    });
    setInterval(atualizar, 16);
})();
