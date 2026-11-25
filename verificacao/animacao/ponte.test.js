// Testa o protocolo sob latencia/perda. Nao substitui visb.groovy.
const {test} = require('node:test');
const assert = require('node:assert/strict');
const vm = require('node:vm');
const fs = require('node:fs');
const source = fs.readFileSync('elevador/gestos.js', 'utf8');
function ambiente({delay=0, drop=0}={}) {
    let now=0, last=0, callback;
    const pending=[], attempts=[], applied=[], elements=new Map();
    class Element {
        constructor(id) { this.id=id; this.attrs={}; this.dataset={}; this.textContent='0'; this.handlers={}; }
        addEventListener(type, fn) { (this.handlers[type] ??= []).push(fn); }
        dispatchEvent(e) {
            e.target ??= this; e.preventDefault=()=>{};
            for(const fn of this.handlers[e.type] ?? []) fn(e);
            if(this.id.startsWith('evento_')) {
                const num=Number(window.visb_vars.evento), id=this.id.slice(7);
                attempts.push([num,id]);
                if(drop-- > 0) return;
                pending.push({at:now+delay, num, id});
            }
        }
        getAttribute(k) { return this.attrs[k] ?? null; }
        setAttribute(k,v) { this.attrs[k]=String(v); }
        removeAttribute(k) { delete this.attrs[k]; }
        closest() { return this.dataset.liberar ? this : null; }
    }
    const el=id=>{if(!elements.has(id)) elements.set(id,new Element(id)); return elements.get(id);};
    const document=new Element('document'), window=new Element('window');
    document.getElementById=el;
    el('simulacao').attrs={'data-pronto':'sim','data-confirmado':'0','data-passo':'nao'};
    el('cabine_animada').attrs={'data-delta':'0'};
    for(const [id,release] of [['int_2','lib_int_2'],['ext_up_1','lib_up_1'],['segurar_porta','lib_porta']]) el(id).dataset.liberar=release;
    vm.runInNewContext(source,{document,window,performance:{now:()=>now},setInterval:fn=>{callback=fn;},MouseEvent:class {constructor(type,opts){this.type=type;Object.assign(this,opts);}}});
    function advance(ms) {
        for(let n=0;n<ms;n+=20) {
            now+=20;
            for(let i=0;i<pending.length;) {
                if(pending[i].at>now){i++;continue;}
                const event=pending.splice(i,1)[0];
                if(event.num>last) { last=event.num; applied.push(event.id); }
                el('simulacao').setAttribute('data-confirmado',last);
            }
            callback();
        }
    }
    const down=(id,pointerId=1)=>document.dispatchEvent({type:'pointerdown',target:el(id),button:0,pointerId});
    const up=(pointerId=1)=>window.dispatchEvent({type:'pointerup',pointerId});
    const click=id=>el(id).dispatchEvent({type:'click'});
    return {advance,down,up,click,document,window,applied,attempts,el};
}
test('pressao e soltura confirmadas em ambos os paineis, com descarte e atraso',()=>{
    const a=ambiente({delay:650,drop:1});
    a.down('int_2');a.up();a.down('ext_up_1',2);a.up(2);a.advance(5000);
    assert.deepEqual(a.applied,['pressionar_int_2','lib_int_2','pressionar_ext_up_1','lib_up_1']);
    assert.ok(a.attempts.length>4);
});
test('retencao aceita comandos concorrentes sem perder a soltura',()=>{
    const a=ambiente({delay:400});
    a.down('segurar_porta');a.click('btn_fechar');a.down('int_2',2);a.up(2);a.up();a.advance(4000);
    assert.deepEqual(a.applied,['pressionar_segurar_porta','btn_fechar','pressionar_int_2','lib_int_2','lib_porta']);
});
for(const type of ['pointercancel','blur','pagehide','visibilitychange','lostpointercapture']) {
    test('libera retencao em '+type,()=>{
        const a=ambiente({delay:450});a.down('segurar_porta');
        if(type==='visibilitychange') a.document.hidden=true;
        const target=['visibilitychange','lostpointercapture'].includes(type)?a.document:a.window;
        target.dispatchEvent({type,pointerId:1});a.advance(2000);
        assert.deepEqual(a.applied,['pressionar_segurar_porta','lib_porta']);
    });
}
test('pausa estabiliza ticks; soltura prossegue apos tick em voo descartado',()=>{
    const a=ambiente({delay:500});a.down('segurar_porta');a.advance(1000);a.click('alternar_tempo');
    a.advance(1100);a.click('alternar_tempo');a.up();a.advance(2000);
    const ticks=a.applied.filter(x=>x==='btn_tick').length;
    a.advance(5000);
    assert.equal(a.applied.filter(x=>x==='btn_tick').length,ticks);
    assert.ok(ticks>=1);assert.equal(a.applied.at(-1),'lib_porta');
    a.click('alternar_tempo');a.advance(1800);
    assert.ok(a.applied.filter(x=>x==='btn_tick').length>ticks);
});
test('pressionar proximo ao tick nao antecipa os tres segundos de cancelamento',()=>{
    const a=ambiente();a.click('alternar_tempo');a.advance(900);a.down('int_2');a.advance(2900);a.up();a.advance(100);
    const release=a.applied.indexOf('lib_int_2');
    assert.equal(a.applied.slice(0,release).filter(x=>x==='btn_tick').length,2);
});
test('gesto em controle desabilitado nao entra na fila',()=>{
    const a=ambiente();a.el('segurar_porta').setAttribute('data-habilitado','nao');
    a.down('segurar_porta');a.up();a.advance(1000);assert.deepEqual(a.applied,[]);
});

test('retencao envia um tick por segundo; o modelo aplica dez segundos por tick',()=>{
    const a=ambiente();a.down('segurar_porta');a.advance(100);
    a.click('alternar_tempo');a.advance(2400);
    assert.equal(a.applied.filter(x=>x==='btn_tick').length,2);
    a.up();a.advance(1000);
    assert.ok(a.applied.includes('lib_porta'));
});
