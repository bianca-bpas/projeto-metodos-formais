// Teste de integracao: abre o ProB2 UI real e usa seu VisB/ProB, sem mock.
import javafx.application.Platform
import de.prob2.ui.visb.VisBView
import de.prob2.ui.prob2fx.CurrentTrace
import de.prob.statespace.Transition
import com.sun.javafx.application.ParametersImpl
import java.util.concurrent.FutureTask

def fx = { Closure c ->
    def task = new FutureTask(c as java.util.concurrent.Callable)
    Platform.runLater(task); task.get()
}
Thread.start {
    try {
        sleep 7500
        def (ct, view) = fx {
            def app = ParametersImpl.@params.keySet().find { it.class.name == 'de.prob2.ui.ProB2' }
            def injector = app.@injector
            def current = injector.getInstance(CurrentTrace)
            def trace = current.get()
            if (trace.currentState.id == 'root') trace = trace.execute(Transition.SETUP_CONSTANTS_NAME, ['andar_maximo=4'])
            if (!trace.currentState.isInitialised()) trace = trace.execute(Transition.INITIALISE_MACHINE_NAME, [])
            current.set(trace)
            [current, injector.getInstance(VisBView)]
        }
        sleep 1500
        fx { view.loadFromDefinitions() }
        sleep 2000
        def js = { s -> fx { view.@webView.engine.executeScript(s) } }
        def until = { String expr ->
            for (int i=0; i<200; i++) { if (js(expr) == true) return; sleep 50 }
            throw new AssertionError('Timeout: ' + expr + '; erros: ' + js("document.getElementById('visb_error_messages').textContent"))
        }
        js('''window.click=id=>document.getElementById(id).dispatchEvent(new MouseEvent('click',{bubbles:true}));
window.down=(id,p=1)=>document.getElementById(id).dispatchEvent(new PointerEvent('pointerdown',{pointerId:p,button:0,bubbles:true}));
window.up=(p=1)=>window.dispatchEvent(new PointerEvent('pointerup',{pointerId:p,button:0,bubbles:true}));''')
        until("document.getElementById('simulacao').getAttribute('data-pronto')==='sim'")
        js("click('btn_abrir')")
        until("document.getElementById('s_porta').textContent==='aberta'")
        js("down('segurar_porta');click('btn_fechar');down('int_4',2);up(2)")
        until("document.getElementById('int_4').getAttribute('fill')==='#ffd400' && document.getElementById('simulacao').getAttribute('data-confirmado')==='5'")
        assert js("document.getElementById('s_porta').textContent") == 'aberta'
        js("click('alternar_tempo')")
        sleep 3400
        assert js("document.getElementById('s_porta').textContent") == 'aberta'
        assert js("document.getElementById('vi_num').textContent") == '0'
        js("click('alternar_tempo')")
        sleep 400
        def seconds = js("document.getElementById('s_seg').textContent")
        sleep 1400
        assert js("document.getElementById('s_seg').textContent") == seconds
        // Avanca os ticks pelo ProB real para verificar os limiares sem
        // esperar dois minutos de parede. A pausa da ponte ja foi testada.
        int numero = Integer.parseInt(js("document.getElementById('simulacao').getAttribute('data-confirmado')").toString())
        fx {
            def trace = ct.get()
            for (int i=Integer.parseInt(seconds); i<120; i++) {
                trace = trace.execute('entregar', ['evento=' + (++numero), 'comando=0', 'alvo=0'])
            }
            ct.set(trace)
        }
        until("document.getElementById('s_seg').textContent==='120'")
        assert js("document.getElementById('aviso_porta_0').textContent") == ''
        fx { ct.set(ct.get().execute('entregar', ['evento=' + (++numero), 'comando=0', 'alvo=0'])) }
        until("document.getElementById('aviso_porta_0').textContent==='PORTA ABERTA > 120 s'")
        js("click('btn_chave')")
        until("document.getElementById('aviso_manut_0').getAttribute('visibility')==='visible'")
        assert js("document.getElementById('aviso_porta_0').textContent") == 'PORTA ABERTA > 120 s'
        assert js("document.getElementById('vnum_0').textContent") == '0'
        assert js("document.getElementById('vdir_0').textContent") == '■'
        assert js("document.getElementById('segurar_porta').getAttribute('fill')") == '#3a3a3a'
        js("up();click('btn_chave2')")
        until("document.getElementById('segurar_porta').getAttribute('data-habilitado')==='sim'")
        js("down('segurar_porta');down('int_4',2);up(2)")
        until("document.getElementById('segurar_porta').getAttribute('fill')==='#ffd400' && document.getElementById('int_4').getAttribute('fill')==='#ffd400'")
        js("window.dispatchEvent(new Event('blur'))")
        until("document.getElementById('segurar_porta').getAttribute('fill')==='#3a3a3a'")
        js("click('alternar_tempo')")
        until("document.getElementById('s_porta').textContent==='fechada'")
        until("Number(document.getElementById('cabine_animada').getAttribute('data-delta'))!==0")
        sleep 3000
        assert js("document.getElementById('vi_num').textContent") == '0'
        until("document.getElementById('vi_num').textContent==='1'")
        println 'VisB real: retencao, concorrencia, pausa, alertas 120/121, manutencao, blur e trecho: OK'
        System.exit(0)
    } catch (Throwable e) { e.printStackTrace(); System.exit(1) }
}
de.prob2.ui.Main.main(['--no-save-config', '--machine-file', new File('elevador/animacao.mch').absolutePath] as String[])
