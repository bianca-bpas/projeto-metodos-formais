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
    e = {'id': i, 'event': op, 'hovers': [{'attr': 'stroke-width', 'enter': '3.5', 'leave': '1.5'}]}
    if preds: e['predicates'] = preds
    events.append(e)
def txt(i, x, y, s, size=13, anchor='start', fill='#e8e8e8', weight='normal'):
    add(f'<text id="{i}" x="{x}" y="{y}" font-size="{size}" text-anchor="{anchor}" fill="{fill}" font-weight="{weight}" font-family="monospace">{s}</text>')
def circ(i, cx, cy, r=11):
    add(f'<circle id="{i}" cx="{cx}" cy="{cy}" r="{r}" fill="#3a3a3a" stroke="#888" stroke-width="1.5" style="cursor:pointer"/>')
def rect(i, x, y, w, h, fill, stroke='#888', rx=4, extra=''):
    add(f'<rect id="{i}" x="{x}" y="{y}" width="{w}" height="{h}" rx="{rx}" fill="{fill}" stroke="{stroke}" stroke-width="1.5" {extra}/>')

ON, OFF = '#ffd400', '#3a3a3a'
def led(lst, f, p1, p3, ped):      # replica consultar_leds
    return (f'IF ({f} : {ped} & {f} /: ({p1[0]} \\/ {p1[1]} \\/ {p1[2]} \\/ {p1[3]})) or {f} : {p1[0]} or {f} : {p1[2]} '
            f'THEN "{ON}" ELSE "{OFF}" END')
pis = lambda n: [f'piscando_{n}{k}' for k in (1, 2, 3, 4)]
held = lambda f, s: f'IF {f} : {s} THEN "#ffffff" ELSE "#888888" END'

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
    # botões do painel externo (HLR-002/004/005)
    bx = SX + SW + 40
    if f < N:
        circ(f'ext_up_{f}', bx, y + 30); txt(f'ut_{f}', bx, y + 35, '▲', 11, 'middle', '#fff')
        circ(f'lib_up_{f}', bx, y + 62, 5)
        item(f'ext_up_{f}', 'fill', led(0, f, pis('subida'), 0, 'pedidos_subida'))
        item(f'ext_up_{f}', 'stroke', held(f, 'segurando_subida'))
        ev(f'ext_up_{f}', 'pressionar_externo_subida', [f'alvo={f}'])
        ev(f'lib_up_{f}', 'liberar_subida', [f'alvo={f}'])
    if f > 0:
        circ(f'ext_dn_{f}', bx + 40, y + 30); txt(f'dt_{f}', bx + 40, y + 35, '▼', 11, 'middle', '#fff')
        circ(f'lib_dn_{f}', bx + 40, y + 62, 5)
        item(f'ext_dn_{f}', 'fill', led(0, f, pis('descida'), 0, 'pedidos_descida'))
        item(f'ext_dn_{f}', 'stroke', held(f, 'segurando_descida'))
        ev(f'ext_dn_{f}', 'pressionar_externo_descida', [f'alvo={f}'])
        ev(f'lib_dn_{f}', 'liberar_descida', [f'alvo={f}'])
txt('legenda_lib', SX + SW + 110, TOP + 20, '○ pequeno = soltar botão', 10, fill='#9aa')

# ---------- 4. cabine (posição, porta) ----------
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

# ---------- 5. painel interno (HLR-003/004/005/008/009) ----------
PX = 560
rect('painel', PX - 20, TOP - 10, 360, (N + 1) * FH + 130, '#242831', '#555', 8)
txt('p_tit', PX, TOP + 14, 'PAINEL INTERNO / ESTADO', 13, weight='bold', fill='#8fb8ff')
rect('vi', PX, TOP + 26, 320, 44, '#000', '#555', 4)
txt('vi_num', PX + 14, TOP + 58, '0', 26, fill='#7CFC00'); item('vi_num', 'text', 'andar')
txt('vi_dir', PX + 60, TOP + 58, '■', 22, fill='#7CFC00')
item('vi_dir', 'text', 'IF direcao = subindo THEN "▲" ELSE IF direcao = descendo THEN "▼" ELSE "■" END END')
txt('vi_alerta', PX + 100, TOP + 56, '', 15, fill='#ff453a', weight='bold')
item('vi_alerta', 'text', 'IF manutencao = TRUE THEN "MANUTENÇÃO" ELSE IF limite_peso_atingido = TRUE THEN "EXCESSO DE PESO" ELSE IF manutencao_pendente = TRUE THEN "MANUT. PENDENTE" ELSE "" END END END')
txt('ib_t', PX, TOP + 92, 'Destinos', 11, fill='#9aa')
for f in range(N + 1):
    cx = PX + 18 + f * 40
    circ(f'int_{f}', cx, TOP + 114, 14); txt(f'it_{f}', cx, TOP + 119, str(f), 13, 'middle', '#fff')
    circ(f'lib_int_{f}', cx, TOP + 138, 5)
    item(f'int_{f}', 'fill', led(0, f, pis('interno'), 0, 'pedidos_internos'))
    item(f'int_{f}', 'stroke', held(f, 'segurando_interno \\/ interno_recusado'))
    ev(f'int_{f}', 'pressionar_interno', [f'alvo={f}']); ev(f'lib_int_{f}', 'liberar_interno', [f'alvo={f}'])
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
rect('btn_tick', PX, TOP + 284, 150, 32, '#2d5a3a', '#7CFC00', 6, 'style="cursor:pointer"')
txt('bt_tick', PX + 75, TOP + 305, 'passar_tempo (+1 s)', 12, 'middle', '#fff')
rect('btn_passo', PX + 170, TOP + 284, 150, 32, '#2d3a5a', '#8fb8ff', 6, 'style="cursor:pointer"')
txt('bt_passo', PX + 245, TOP + 305, 'passo (controlador)', 12, 'middle', '#fff')
ev('btn_tick', 'passar_tempo'); ev('btn_passo', 'passo')
# painel de variáveis
yy = TOP + 342
rows = [('s_porta', 'porta', 'porta'), ('s_seg', 'porta aberta (s)', 'segundos_porta_aberta'),
        ('s_sent', 'sentido_atend.', 'sentido_atendimento'), ('s_desl', 'deslocamento', 'deslocamento'),
        ('s_parada', 'parada_pendente', 'parada_pendente'), ('s_ped', 'pedidos ativos', 'card(pedidos_internos \\/ pedidos_subida \\/ pedidos_descida)'),
        ('s_hist', 'histórico paradas', 'historico_paradas')]
for i, (i_id, lab, expr) in enumerate(rows):
    txt(f'{i_id}_l', PX, yy + i * 18, lab + ':', 11, fill='#9aa')
    txt(i_id, PX + 130, yy + i * 18, '', 11); item(i_id, 'text', expr)
add('</svg>')
(HERE / 'elevador.svg').write_text('\n'.join(svg), encoding='utf-8')
json.dump({'svg': 'elevador.svg', 'items': items, 'events': events},
          open(HERE / 'elevador_visb.json', 'w', encoding='utf-8'), ensure_ascii=False, indent=1)
print(f'N={N}: {len(items)} itens, {len(events)} eventos')
