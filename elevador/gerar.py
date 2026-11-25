#!/usr/bin/env python3
"""Gera o SVG e o JSON do VisB para uma instancia com N andares.
Uso: python3 gerar.py [N]   (padrao N = 4)

Este gerador nao altera os arquivos .mch; configure andar_maximo = N no ProB."""
import json, sys
from pathlib import Path
N = int(sys.argv[1]) if len(sys.argv) > 1 else 4
if N < 1:
    sys.exit('N deve ser maior ou igual a 1')
HERE = Path(__file__).parent

# ---------- 2. geometria ----------
FH, TOP = 92, 70                      # altura do pavimento / topo do pavimento N
fy = lambda f: TOP + (N - f) * FH      # y do topo do pavimento f
W, H = 940, TOP + (N + 1) * FH + 150
SX, SW = 120, 130                      # poço: x e largura
svg, items, events = [], [], []
add = svg.append
def item(i, attr, val): items.append({'id': i, 'attr': attr, 'value': val})
def ev(i, op, preds=None):
    target = 'evento_' + i
    add(f'<g display="none"><g id="{target}"/></g>')
    value = preds[0].split('=')[1] if preds else '0'
    events.append({'id': target, 'event': 'entregar', 'predicates': [
        'evento=STRING_TO_INT(VISB_CLICK_META_INFOS\'jsVars("evento"))',
        f'comando={COMMANDS[op]}', f'alvo={value}']})
def txt(i, x, y, s, size=13, anchor='start', fill='#e8e8e8', weight='normal'):
    add(f'<text id="{i}" x="{x}" y="{y}" font-size="{size}" text-anchor="{anchor}" fill="{fill}" font-weight="{weight}" font-family="monospace">{s}</text>')
def circ(i, cx, cy, r=11):
    liberar = i.replace('ext_up_', 'lib_up_').replace('ext_dn_', 'lib_dn_').replace('int_', 'lib_int_')
    add(f'<g display="none"><g id="pressionar_{i}"/><g id="{liberar}"/></g>')
    add(f'<circle id="{i}" data-liberar="{liberar}" cx="{cx}" cy="{cy}" r="{r}" fill="#3a3a3a" stroke="#888" stroke-width="1.5" style="cursor:pointer;touch-action:none"/>')
def rect(i, x, y, w, h, fill, stroke='#888', rx=4, extra=''):
    add(f'<rect id="{i}" x="{x}" y="{y}" width="{w}" height="{h}" rx="{rx}" fill="{fill}" stroke="{stroke}" stroke-width="1.5" {extra}/>')

ON, OFF = '#ffd400', '#3a3a3a'
COMMANDS = {'passar_tempo':0,'passo':1,'pressionar_interno':2,'liberar_interno':3,
 'pressionar_externo_subida':4,'liberar_subida':5,'pressionar_externo_descida':6,
 'liberar_descida':7,'pressionar_abrir':8,'pressionar_fechar':9,
 'inserir_chave':10,'remover_chave_manutencao':11,'ajustar_peso':12,
 'segurar_porta':13,'liberar_porta':14}
def led(lst, f, p1, p3, ped):      # replica consultar_leds
    return (f'IF ({f} : {ped} & {f} /: ({p1[0]} \\/ {p1[1]} \\/ {p1[2]} \\/ {p1[3]})) or {f} : {p1[0]} or {f} : {p1[2]} '
            f'THEN "{ON}" ELSE "{OFF}" END')
pis = lambda n: [f'piscando_{n}{k}' for k in (1, 2, 3, 4)]
held = lambda f, s: f'IF {f} : {s} THEN "#ffffff" ELSE "#888888" END'

def estado_externo(i, f, grupo, valido):
    item(i, 'data-fase', f'IF not({valido}) THEN -1 ELSE IF manutencao = TRUE THEN IF {f} : piscando_{grupo}1 THEN 5 ELSE 4 END ELSE IF {f} : segurando_{grupo}_2 THEN 3 ELSE IF {f} : segurando_{grupo}_1 THEN 2 ELSE IF {f} : segurando_{grupo} THEN 1 ELSE 0 END END END END END')
    item(i, 'stroke-width', f'IF {f} : segurando_{grupo}_2 THEN 4.0 ELSE IF {f} : segurando_{grupo}_1 THEN 3.0 ELSE IF {f} : segurando_{grupo} THEN 2.5 ELSE 1.5 END END END')

def aviso(i,x,y,titulo,cond):
    if 'peso' in i:
        figura = ('<path d="M7 6V4a3 3 0 0 1 6 0v2M8.5 6V4a1.5 1.5 0 0 1 3 0v2" fill="none" stroke="#ff453a" stroke-width="1.5"/>'
                  '<path d="M5 6h10l2.5 11H2.5z" fill="#4a2020" stroke="#ff453a" stroke-width="1.5"/>'
                  '<path d="M10 9v4m0 2v.1" stroke="#fff" stroke-width="2" stroke-linecap="round"/>')
        fundo = '<circle cx="10" cy="10" r="9" fill="#321c28" stroke="#ff453a"/>'
    else:
        figura = '<path d="M14.8 3.5a4.5 4.5 0 0 0-5.2 5.2L4.2 14a1.5 1.5 0 0 0 2.1 2.1l5.3-5.4a4.5 4.5 0 0 0 5.2-5.2l-3 3-2.2-2.2z" fill="#ffae32"/>'
        fundo = '<circle cx="10" cy="10" r="9" fill="#3b2c14" stroke="#ffae32"/>'
    add(f'<svg id="{i}" x="{x}" y="{y}" width="20" height="20" viewBox="0 0 20 20" visibility="hidden" pointer-events="none"><title>{titulo}</title>{fundo}{figura}</svg>')
    item(i,'visibility',f'IF {cond} THEN "visible" ELSE "hidden" END')

add(f'<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 {W} {H}" width="{W}" height="{H}">')
add(f'<rect width="{W}" height="{H}" fill="#1b1e24"/>')
txt('t1', 20, 28, 'Controle de Elevador — Formal Model Visualisation (VisB / ProB)', 16, weight='bold')
txt('t2', 20, 48, 'Clique nos botões para executar operações do modelo B; LED = pedido ativo; borda branca = botão retido', 11, fill='#9aa')

# ---------- 3. poço, pavimentos, painéis externos ----------
rect('poco', SX, TOP, SW, (N + 1) * FH, '#101216', '#555', 2)
for f in range(N + 1):
    y = fy(f)
    add(f'<line x1="20" y1="{y+FH}" x2="{SX+SW+190}" y2="{y+FH}" stroke="#444"/>')
    txt(f'andar_{f}', 28, y + 52, f'P{f}', 20, weight='bold', fill='#8fb8ff')
    # visor externo (HLR-001/007/008)
    rect(f'visor_{f}', 62, y + 26, 52, 34, '#000', '#555', 3)
    txt(f'vnum_{f}', 76, y + 50, '0', 18, 'middle', '#7CFC00')
    txt(f'vdir_{f}', 100, y + 50, '■', 14, 'middle', '#7CFC00')
    item(f'vnum_{f}', 'text', 'andar')
    dirs = 'IF manutencao = TRUE THEN "M" ELSE IF segundos_porta_aberta > 120 THEN "X" ELSE IF direcao = subindo THEN "▲" ELSE IF direcao = descendo THEN "▼" ELSE "■" END END END END'
    item(f'vdir_{f}', 'text', dirs)
    aviso(f'aviso_manut_{f}',347,y+27,'Elevador em manutenção','manutencao = TRUE or manutencao_pendente = TRUE')
    aviso(f'aviso_peso_{f}',374,y+27,'Excesso de peso','limite_peso_atingido = TRUE')
    txt(f'aviso_porta_{f}',347,y+73,'',11,fill='#ff453a')
    item(f'aviso_porta_{f}','text','IF segundos_porta_aberta > 120 THEN "PORTA ABERTA > 120 s" ELSE "" END')
    # botões do painel externo (HLR-002/004/005)
    bx = SX + SW + 40
    if f < N:
        circ(f'ext_up_{f}', bx, y + 30); txt(f'ut_{f}', bx, y + 35, '▲', 11, 'middle', '#fff')
        item(f'ext_up_{f}', 'fill', led(0, f, pis('subida'), 0, 'pedidos_subida'))
        item(f'ext_up_{f}', 'stroke', held(f, 'segurando_subida'))
        estado_externo(f'ext_up_{f}',f,'subida',f'{f} < andar_maximo')
        ev(f'pressionar_ext_up_{f}', 'pressionar_externo_subida', [f'alvo={f}'])
        ev(f'lib_up_{f}', 'liberar_subida', [f'alvo={f}'])
    if f > 0:
        circ(f'ext_dn_{f}', bx + 40, y + 30); txt(f'dt_{f}', bx + 40, y + 35, '▼', 11, 'middle', '#fff')
        item(f'ext_dn_{f}', 'fill', led(0, f, pis('descida'), 0, 'pedidos_descida'))
        item(f'ext_dn_{f}', 'stroke', held(f, 'segurando_descida'))
        estado_externo(f'ext_dn_{f}',f,'descida',f'{f} <= andar_maximo')
        ev(f'pressionar_ext_dn_{f}', 'pressionar_externo_descida', [f'alvo={f}'])
        ev(f'lib_dn_{f}', 'liberar_descida', [f'alvo={f}'])

# ---------- 4. cabine (posição, porta) ----------
add('<g id="cabine_animada" data-delta="0">')
item('cabine_animada','data-delta',f'IF direcao = subindo THEN -{FH} ELSE IF direcao = descendo THEN {FH} ELSE 0 END END')
Y = f'{TOP + N*FH + 10} - andar * {FH}'
rect('cab', SX + 12, TOP + N * FH + 10, SW - 24, FH - 20, '#2d3a55', '#8fb8ff', 3)
item('cab', 'y', Y)
rect('porta_e', SX + 12, TOP + N * FH + 10, SW // 2 - 12, FH - 20, '#9aa7bd', '#9aa7bd', 0)
rect('porta_d', SX + SW // 2, TOP + N * FH + 10, SW // 2 - 12, FH - 20, '#9aa7bd', '#9aa7bd', 0)
item('porta_e', 'y', Y); item('porta_d', 'y', Y)
item('porta_e', 'width', f'IF porta = aberta THEN 6 ELSE {SW//2 - 12} END')
item('porta_d', 'width', f'IF porta = aberta THEN 6 ELSE {SW//2 - 12} END')
item('porta_d', 'x', f'IF porta = aberta THEN {SX + SW - 18} ELSE {SX + SW//2} END')
add(f'<circle id="peso_ico" cx="{SX+SW//2}" cy="{TOP+N*FH+22}" r="5" fill="#2d3a55"/>')
item('peso_ico', 'cy', f'{TOP + N*FH + 22} - andar * {FH}')
item('peso_ico', 'fill', 'IF limite_peso_atingido = TRUE THEN "#ff3b30" ELSE IF manutencao = TRUE THEN "#ff9500" ELSE "#2d3a55" END END')
add('</g>')

# ---------- 5. painel interno (HLR-003/004/005/008/009) ----------
PX = 560
rect('painel', PX - 20, TOP - 10, 360, (N + 1) * FH + 130, '#242831', '#555', 8)
txt('p_tit', PX, TOP + 14, 'PAINEL INTERNO / ESTADO', 13, weight='bold', fill='#8fb8ff')
rect('vi', PX, TOP + 26, 320, 44, '#000', '#555', 4)
txt('vi_num', PX + 14, TOP + 58, '0', 26, fill='#7CFC00'); item('vi_num', 'text', 'andar')
txt('vi_dir', PX + 60, TOP + 58, '■', 22, fill='#7CFC00')
item('vi_dir', 'text', 'IF direcao = subindo THEN "▲" ELSE IF direcao = descendo THEN "▼" ELSE "■" END END')
aviso('vi_manutencao',PX+108,TOP+39,'Elevador em manutenção','manutencao = TRUE or manutencao_pendente = TRUE')
aviso('vi_peso',PX+140,TOP+39,'Excesso de peso','limite_peso_atingido = TRUE')
txt('ib_t', PX, TOP + 92, 'Destinos', 11, fill='#9aa')
for f in range(N + 1):
    cx = PX + 18 + f * 40
    circ(f'int_{f}', cx, TOP + 114, 14); txt(f'it_{f}', cx, TOP + 119, str(f), 13, 'middle', '#fff')
    item(f'int_{f}', 'fill', f'IF {f} : interno_recusado THEN "{ON}" ELSE {led(0, f, pis("interno"), 0, "pedidos_internos")} END')
    item(f'int_{f}', 'stroke', held(f, 'segurando_interno \\/ interno_recusado'))
    item(f'int_{f}', 'stroke-width', f'IF {f} : segurando_interno_2 THEN 4.0 ELSE IF {f} : segurando_interno_1 THEN 3.0 ELSE IF {f} : segurando_interno THEN 2.5 ELSE 1.5 END END END')
    ev(f'pressionar_int_{f}', 'pressionar_interno', [f'alvo={f}']); ev(f'lib_int_{f}', 'liberar_interno', [f'alvo={f}'])
for i, (nome, lab, op, var) in enumerate([('abrir', '◀▶ abrir', 'pressionar_abrir', 'piscando_abrir'), ('fechar', '▶◀ fechar', 'pressionar_fechar', 'piscando_fechar')]):
    x = PX + i * 110
    rect(f'btn_{nome}', x, TOP + 156, 96, 28, '#3a3a3a', '#888', 6, 'style="cursor:pointer"')
    txt(f'bt_{nome}', x + 48, TOP + 175, lab, 12, 'middle', '#fff')
    item(f'btn_{nome}', 'fill', f'IF {var} = 4 or {var} = 2 THEN "{ON}" ELSE "{OFF}" END')
    ev(f'btn_{nome}', op)
# chave, peso, relógio
rect('btn_chave', PX, TOP + 200, 150, 28, '#3a3a3a', '#888', 6, 'style="cursor:pointer"')
txt('bt_chave', PX + 75, TOP + 219, 'inserir chave', 12, 'middle', '#fff')
item('btn_chave', 'fill', 'IF chave_manutencao = TRUE THEN "#ff9500" ELSE "#3a3a3a" END')
rect('btn_chave2', PX + 160, TOP + 200, 160, 28, '#3a3a3a', '#888', 6, 'style="cursor:pointer"')
txt('bt_chave2', PX + 240, TOP + 219, 'remover chave', 12, 'middle', '#fff')
ev('btn_chave', 'inserir_chave'); ev('btn_chave2', 'remover_chave_manutencao')
for i, (lab, d) in enumerate([('+75 kg', 75), ('−75 kg', -75)]):
    x = PX + i * 110
    rect(f'btn_peso{i}', x, TOP + 240, 96, 28, '#3a3a3a', '#888', 6, 'style="cursor:pointer"')
    txt(f'bt_peso{i}', x + 48, TOP + 259, lab, 12, 'middle', '#fff')
    ev(f'btn_peso{i}', 'ajustar_peso', [f'delta={d}'])
txt('peso_txt', PX + 225, TOP + 259, '', 12, fill='#e8e8e8')
item('peso_txt', 'text', 'peso')
txt('peso_kg', PX + 262, TOP + 259, '/ 450 kg', 12, fill='#9aa')
add('<g id="simulacao" display="none"><g id="btn_tick"/><g id="btn_passo"/></g>')
item('simulacao','data-confirmado','ultimo_evento')
item('simulacao','data-pronto','IF andar >= 0 THEN "sim" ELSE "nao" END')
item('simulacao','data-passo','IF manutencao = FALSE & (pedidos_internos /= {} or pedidos_subida /= {} or pedidos_descida /= {} or direcao /= parado or porta = aberta or sentido_atendimento /= parado) THEN "sim" ELSE "nao" END')
rect('alternar_tempo',PX,TOP+284,155,32,'#295842','#8ad6a3',6,'style="cursor:pointer"')
txt('tempo_retencao',PX+140,TOP+145,'—',14,fill='#ffd400',weight='bold')
txt('acao_tempo',PX+77,TOP+305,'▶ Passar tempo',13,'middle')
txt('estado_tempo',PX+169,TOP+305,'Pausado',12,fill='#b7c7da')
txt('tempos_simulados',PX,TOP+329,'Tempos de simulação • trecho: 6 s',11,fill='#9aa')
ev('btn_tick','passar_tempo'); ev('btn_passo','passo')
rect('segurar_porta',350,TOP+(N+1)*FH+28,170,30,'#3a3a3a','#888',6,'data-liberar="lib_porta" style="cursor:pointer;touch-action:none"')
txt('ambiente',350,TOP+(N+1)*FH+17,'AMBIENTE DE SIMULAÇÃO',11,fill='#9aa')
txt('segurar_rotulo',435,TOP+(N+1)*FH+48,'Segurar porta',13,'middle')
txt('retencao_ritmo',350,TOP+(N+1)*FH+74,'Pressionado: 10 s simulados / s',11,fill='#9aa')
item('segurar_porta','fill','IF porta_retida = TRUE THEN "#ffd400" ELSE "#3a3a3a" END')
item('segurar_porta','data-habilitado','IF manutencao = FALSE & direcao = parado & porta = aberta THEN "sim" ELSE "nao" END')
ev('pressionar_segurar_porta','segurar_porta'); ev('lib_porta','liberar_porta')
# painel de variáveis
yy = TOP + 342
rows = [('s_porta', 'porta', 'porta'), ('s_seg', 'porta aberta (s)', 'segundos_porta_aberta'),
        ('s_sent', 'sentido_atend.', 'sentido_atendimento'), ('s_desl', 'deslocamento', 'deslocamento'),
        ('s_parada', 'parada_pendente', 'parada_pendente'), ('s_ped', 'pedidos ativos', 'card(pedidos_internos \\/ pedidos_subida \\/ pedidos_descida)'),
        ('s_hist', 'histórico paradas', 'historico_paradas')]
for i, (i_id, lab, expr) in enumerate(rows):
    txt(f'{i_id}_l', PX, yy + i * 18, lab + ':', 11, fill='#9aa')
    txt(i_id, PX + 130, yy + i * 18, '', 11); item(i_id, 'text', expr)
add('<script><![CDATA[' + (HERE / 'gestos.js').read_text(encoding='utf-8') + ']]></script>')
add('</svg>')
(HERE / 'elevador.svg').write_text('\n'.join(svg), encoding='utf-8')
json.dump({'svg': 'elevador.svg', 'items': items, 'events': events},
          open(HERE / 'elevador_visb.json', 'w', encoding='utf-8'), ensure_ascii=False, indent=1)
print(f'N={N}: {len(items)} itens, {len(events)} eventos')
