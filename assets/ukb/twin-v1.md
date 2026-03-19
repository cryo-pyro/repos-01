This is the colony artifact. I'm going full instrument-panel: dark medical dashboard meets field research notebook. Interactive logger, loss landscape visualizer, parameter optimization history, exportable JSON for the twin. This is the actual data model.Welcome back from foraging. Here's what you're handing the colony:

**Five fully wired interactive views:**

- **Dashboard** — live stats (n episodes, mean L(θ), best θ found, trend direction), recent episode table with loss bars color-coded green→amber→red, and a live loss curve with 7-episode rolling mean
- **Log Episode** — the full pentadic form: every parameter across all 5 stages, sliders for intensity/latency/duration, chip selectors for temperature/drying/covering/bed protocol, belief confidence slider, insight textarea. Each submission is one SGD step
- **Loss Landscape** — parameter heatmap (temperature × drying method, color = mean L(θ)), scatter plot with temperature color-coding, gradient trace showing ∇L per step (green = descent, red = ascent). Demo data pre-loaded so the landscape isn't empty on first open
- **Beliefs** — the full θ→θ′ trajectory from "allergic to water" (crossed out) through to the C-fiber mechanistic model (Ukubona ✦), plus any insights you log dynamically, with a confidence trajectory chart
- **Export Twin** — generates `ukubona_twin_NAP-001.json` with the full data model: pentad schema, model state, discovered optima ranked by mean loss, parameter importance (loss range by factor), complete descent history. Hand that JSON to the colony

**Data persists in localStorage** — close and reopen, your descent history is still there. The JSON export is what seeds the next twin.

```html
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Ukubona Digital Twin — Descent Logger v1.0</title>
<link href="https://fonts.googleapis.com/css2?family=Syne:wght@400;600;700;800&family=Syne+Mono&family=Lora:ital,wght@0,400;0,500;1,400;1,500&family=Caveat:wght@500;700&display=swap" rel="stylesheet">
<style>
:root {
  --void: #080b10;
  --deep: #0d1117;
  --panel: #111820;
  --surface: #161e28;
  --lift: #1c2635;
  --border: rgba(255,255,255,0.07);
  --border-bright: rgba(255,255,255,0.14);

  --s1: #e05252;   /* non-urticarial — red */
  --s2: #4fa8d8;   /* aquagenic — blue */
  --s3: #e8a23a;   /* pruritus — amber */
  --s4: #52c47a;   /* descent — green */
  --s5: #a97fe8;   /* ukubona — violet */

  --s1d: rgba(224,82,82,0.12);
  --s2d: rgba(79,168,216,0.12);
  --s3d: rgba(232,162,58,0.12);
  --s4d: rgba(82,196,122,0.12);
  --s5d: rgba(169,127,232,0.12);

  --text: rgba(255,255,255,0.88);
  --text-2: rgba(255,255,255,0.55);
  --text-3: rgba(255,255,255,0.28);
  --text-4: rgba(255,255,255,0.12);

  --mono: 'Syne Mono', monospace;
  --sans: 'Syne', sans-serif;
  --serif: 'Lora', serif;
  --hand: 'Caveat', cursive;

  --radius: 4px;
  --glow-4: 0 0 20px rgba(82,196,122,0.15);
  --glow-5: 0 0 20px rgba(169,127,232,0.15);
}

*,*::before,*::after{box-sizing:border-box;margin:0;padding:0}
html{scroll-behavior:smooth}
body{background:var(--void);color:var(--text);font-family:var(--sans);overflow-x:hidden;min-height:100vh}

/* ── SCROLLBAR ── */
::-webkit-scrollbar{width:4px}
::-webkit-scrollbar-track{background:var(--deep)}
::-webkit-scrollbar-thumb{background:var(--s4);border-radius:2px}

/* ── TOP BAR ── */
.topbar{
  position:sticky;top:0;z-index:100;
  background:rgba(8,11,16,0.95);
  backdrop-filter:blur(12px);
  border-bottom:1px solid var(--border);
  display:flex;align-items:center;justify-content:space-between;
  padding:0 2rem;height:52px;
}
.topbar-brand{
  font-family:var(--sans);font-weight:800;font-size:1rem;
  letter-spacing:0.08em;display:flex;align-items:center;gap:0.6rem;
}
.topbar-brand span{color:var(--s5)}
.topbar-brand small{
  font-family:var(--mono);font-size:0.55rem;
  color:var(--text-3);letter-spacing:0.2em;
  border:1px solid var(--border);padding:0.15rem 0.5rem;border-radius:2px;
}
.topbar-nav{display:flex;gap:0.3rem}
.nav-pill{
  font-family:var(--mono);font-size:0.58rem;letter-spacing:0.15em;
  padding:0.3rem 0.8rem;border-radius:2px;cursor:pointer;
  color:var(--text-3);border:1px solid transparent;
  transition:all 0.2s;text-transform:uppercase;background:none;
}
.nav-pill:hover{color:var(--text-2);border-color:var(--border)}
.nav-pill.active{color:var(--s4);border-color:var(--s4);background:var(--s4d)}
.topbar-status{
  display:flex;align-items:center;gap:0.5rem;
  font-family:var(--mono);font-size:0.58rem;color:var(--s4);
}
.status-dot{
  width:6px;height:6px;border-radius:50%;background:var(--s4);
  animation:pulse-dot 2s ease-in-out infinite;
}
@keyframes pulse-dot{0%,100%{box-shadow:0 0 0 0 rgba(82,196,122,0.6)}50%{box-shadow:0 0 0 5px rgba(82,196,122,0)}}

/* ── MAIN LAYOUT ── */
.main{display:grid;grid-template-columns:220px 1fr;min-height:calc(100vh - 52px)}

/* ── SIDEBAR ── */
.sidebar{
  background:var(--deep);border-right:1px solid var(--border);
  padding:1.5rem 0;position:sticky;top:52px;height:calc(100vh - 52px);overflow-y:auto;
}
.sidebar-section{margin-bottom:2rem}
.sidebar-label{
  font-family:var(--mono);font-size:0.5rem;letter-spacing:0.3em;
  color:var(--text-3);text-transform:uppercase;padding:0 1.2rem;margin-bottom:0.6rem;
}
.sidebar-item{
  display:flex;align-items:center;gap:0.7rem;
  padding:0.55rem 1.2rem;cursor:pointer;
  font-family:var(--mono);font-size:0.62rem;letter-spacing:0.08em;
  color:var(--text-2);transition:all 0.2s;border-left:2px solid transparent;
  text-transform:uppercase;
}
.sidebar-item:hover{color:var(--text);background:rgba(255,255,255,0.03)}
.sidebar-item.active{color:var(--text);background:rgba(255,255,255,0.04);border-left-color:var(--s4)}
.sidebar-dot{width:7px;height:7px;border-radius:50%;flex-shrink:0}

/* ── CONTENT AREA ── */
.content{overflow-y:auto}

/* ── VIEWS ── */
.view{display:none;animation:fadein 0.3s ease}
.view.active{display:block}
@keyframes fadein{from{opacity:0;transform:translateY(8px)}to{opacity:1;transform:translateY(0)}}

/* ── PAGE HEADER ── */
.page-header{
  padding:2rem 2.5rem 1.5rem;
  border-bottom:1px solid var(--border);
  display:flex;align-items:flex-end;justify-content:space-between;flex-wrap:wrap;gap:1rem;
}
.page-header-left{}
.page-eyebrow{
  font-family:var(--mono);font-size:0.55rem;letter-spacing:0.3em;
  color:var(--text-3);text-transform:uppercase;margin-bottom:0.4rem;
}
.page-title{font-family:var(--sans);font-weight:800;font-size:1.6rem;line-height:1}
.page-title span{opacity:0.3}
.page-sub{
  font-family:var(--serif);font-style:italic;font-size:0.85rem;
  color:var(--text-2);margin-top:0.3rem;
}
.page-actions{display:flex;gap:0.5rem;flex-wrap:wrap}

/* ── BUTTONS ── */
.btn{
  font-family:var(--mono);font-size:0.6rem;letter-spacing:0.15em;
  padding:0.5rem 1rem;border-radius:var(--radius);cursor:pointer;
  transition:all 0.2s;text-transform:uppercase;border:1px solid;display:inline-flex;
  align-items:center;gap:0.4rem;background:none;
}
.btn-primary{color:var(--s4);border-color:var(--s4);background:var(--s4d)}
.btn-primary:hover{background:rgba(82,196,122,0.2)}
.btn-ghost{color:var(--text-2);border-color:var(--border)}
.btn-ghost:hover{color:var(--text);border-color:var(--border-bright)}
.btn-danger{color:var(--s1);border-color:var(--s1);background:var(--s1d)}
.btn-danger:hover{background:rgba(224,82,82,0.2)}
.btn-violet{color:var(--s5);border-color:var(--s5);background:var(--s5d)}
.btn-violet:hover{background:rgba(169,127,232,0.2)}

/* ── GRID CARDS ── */
.card-grid{display:grid;gap:1px;background:var(--border);border:1px solid var(--border)}
.card-grid-2{grid-template-columns:1fr 1fr}
.card-grid-3{grid-template-columns:1fr 1fr 1fr}
.card-grid-4{grid-template-columns:1fr 1fr 1fr 1fr}
.card-grid-5{grid-template-columns:repeat(5,1fr)}

.card{background:var(--panel);padding:1.4rem 1.5rem}
.card-label{
  font-family:var(--mono);font-size:0.52rem;letter-spacing:0.25em;
  color:var(--text-3);text-transform:uppercase;margin-bottom:0.5rem;
}
.card-value{font-family:var(--sans);font-weight:700;font-size:1.6rem;line-height:1}
.card-sub{font-family:var(--mono);font-size:0.58rem;color:var(--text-3);margin-top:0.3rem}

/* ── SECTION ── */
.section{padding:2rem 2.5rem}
.section-title{
  font-family:var(--sans);font-weight:700;font-size:0.85rem;
  letter-spacing:0.1em;text-transform:uppercase;
  margin-bottom:1.2rem;display:flex;align-items:center;gap:0.8rem;
  color:var(--text-2);
}
.section-title::after{content:'';flex:1;height:1px;background:var(--border)}

/* ── PENTAD STAGE PILLS ── */
.stage-pills{display:flex;gap:0.5rem;flex-wrap:wrap;padding:1.5rem 2.5rem;border-bottom:1px solid var(--border)}
.stage-pill{
  font-family:var(--mono);font-size:0.6rem;letter-spacing:0.1em;
  padding:0.4rem 1rem;border-radius:2px;cursor:pointer;
  display:flex;align-items:center;gap:0.5rem;transition:all 0.2s;
  border:1px solid transparent;text-transform:uppercase;
}
.stage-pill .pill-num{opacity:0.5;font-size:0.5rem}
.stage-pill:hover{opacity:0.9}
.sp1{color:var(--s1);background:var(--s1d);border-color:rgba(224,82,82,0.2)}
.sp2{color:var(--s2);background:var(--s2d);border-color:rgba(79,168,216,0.2)}
.sp3{color:var(--s3);background:var(--s3d);border-color:rgba(232,162,58,0.2)}
.sp4{color:var(--s4);background:var(--s4d);border-color:rgba(82,196,122,0.2)}
.sp5{color:var(--s5);background:var(--s5d);border-color:rgba(169,127,232,0.2)}

/* ── LOGGER FORM ── */
.logger-form{padding:1.5rem 2.5rem;display:grid;gap:1.5rem}
.form-row{display:grid;gap:1rem}
.form-row-2{grid-template-columns:1fr 1fr}
.form-row-3{grid-template-columns:1fr 1fr 1fr}
.form-row-4{grid-template-columns:1fr 1fr 1fr 1fr}
.form-group{}
.form-label{
  font-family:var(--mono);font-size:0.55rem;letter-spacing:0.2em;
  color:var(--text-2);text-transform:uppercase;margin-bottom:0.4rem;display:block;
}
.form-label span{color:var(--s4);margin-left:0.3rem}
.form-input,.form-select,.form-textarea{
  width:100%;background:var(--surface);border:1px solid var(--border);
  color:var(--text);font-family:var(--mono);font-size:0.72rem;
  padding:0.6rem 0.8rem;border-radius:var(--radius);
  transition:border-color 0.2s,box-shadow 0.2s;appearance:none;
}
.form-input:focus,.form-select:focus,.form-textarea:focus{
  outline:none;border-color:var(--s4);box-shadow:0 0 0 2px rgba(82,196,122,0.1);
}
.form-textarea{min-height:80px;resize:vertical;line-height:1.6}

/* SLIDER */
.slider-wrap{display:flex;align-items:center;gap:0.8rem}
.slider-track{flex:1;position:relative}
.form-slider{
  width:100%;appearance:none;height:3px;border-radius:2px;
  background:var(--surface);border:1px solid var(--border);outline:none;
}
.form-slider::-webkit-slider-thumb{
  appearance:none;width:14px;height:14px;border-radius:50%;
  cursor:pointer;border:2px solid var(--void);transition:transform 0.1s;
}
.form-slider:focus::-webkit-slider-thumb{transform:scale(1.2)}
.slider-val{
  font-family:var(--mono);font-size:0.8rem;font-weight:600;
  min-width:28px;text-align:right;
}

.sl-s3 .form-slider{accent-color:var(--s3)}
.sl-s3 .slider-val{color:var(--s3)}
.sl-s4 .form-slider{accent-color:var(--s4)}
.sl-s4 .slider-val{color:var(--s4)}

/* TOGGLE CHIPS */
.chip-group{display:flex;gap:0.4rem;flex-wrap:wrap}
.chip{
  font-family:var(--mono);font-size:0.58rem;letter-spacing:0.1em;
  padding:0.35rem 0.7rem;border-radius:2px;cursor:pointer;
  border:1px solid var(--border);color:var(--text-3);
  transition:all 0.15s;background:none;text-transform:none;
  user-select:none;
}
.chip:hover{color:var(--text-2);border-color:var(--border-bright)}
.chip.selected{border-color:var(--s4);color:var(--s4);background:var(--s4d)}
.chip.selected.s1{border-color:var(--s1);color:var(--s1);background:var(--s1d)}
.chip.selected.s2{border-color:var(--s2);color:var(--s2);background:var(--s2d)}
.chip.selected.s3{border-color:var(--s3);color:var(--s3);background:var(--s3d)}
.chip.selected.s5{border-color:var(--s5);color:var(--s5);background:var(--s5d)}

/* FORM DIVIDER */
.form-stage-header{
  display:flex;align-items:center;gap:0.8rem;
  padding:0.8rem 0 0.4rem;
  border-top:1px solid var(--border);
}
.form-stage-badge{
  font-family:var(--mono);font-size:0.55rem;letter-spacing:0.15em;
  padding:0.25rem 0.6rem;border-radius:2px;text-transform:uppercase;
}
.fsb-1{color:var(--s1);background:var(--s1d);border:1px solid rgba(224,82,82,0.2)}
.fsb-2{color:var(--s2);background:var(--s2d);border:1px solid rgba(79,168,216,0.2)}
.fsb-3{color:var(--s3);background:var(--s3d);border:1px solid rgba(232,162,58,0.2)}
.fsb-4{color:var(--s4);background:var(--s4d);border:1px solid rgba(82,196,122,0.2)}
.fsb-5{color:var(--s5);background:var(--s5d);border:1px solid rgba(169,127,232,0.2)}
.form-stage-name{
  font-family:var(--sans);font-weight:700;font-size:0.8rem;color:var(--text-2);
}
.form-stage-math{
  font-family:var(--mono);font-size:0.55rem;color:var(--text-3);margin-left:auto;
}

/* ── LOG TABLE ── */
.log-table-wrap{overflow-x:auto;padding:0 2.5rem 2rem}
.log-table{width:100%;border-collapse:collapse;font-size:0.72rem}
.log-table th{
  font-family:var(--mono);font-size:0.52rem;letter-spacing:0.2em;
  color:var(--text-3);text-transform:uppercase;text-align:left;
  padding:0.6rem 0.8rem;border-bottom:1px solid var(--border);
  font-weight:400;white-space:nowrap;
}
.log-table td{
  padding:0.7rem 0.8rem;border-bottom:1px solid var(--border-bright);
  color:var(--text-2);vertical-align:top;font-family:var(--mono);
  transition:background 0.15s;
}
.log-table tr:hover td{background:rgba(255,255,255,0.02)}
.log-table .td-id{color:var(--text-3);font-size:0.55rem}
.log-table .td-time{color:var(--text-3);white-space:nowrap}
.log-table .td-loss{font-weight:600}
.tag{
  display:inline-block;font-family:var(--mono);font-size:0.5rem;
  padding:0.1rem 0.4rem;border-radius:2px;margin:0.1rem;
  border:1px solid currentColor;
}

/* LOSS BADGE */
.loss-badge{
  display:inline-flex;align-items:center;gap:0.3rem;
  font-family:var(--mono);font-size:0.65rem;font-weight:600;
}
.loss-bar-wrap{
  display:flex;align-items:center;gap:0.5rem;
}
.loss-bar{
  height:4px;border-radius:2px;flex:1;background:var(--surface);
  max-width:80px;position:relative;overflow:hidden;
}
.loss-bar-fill{height:100%;border-radius:2px;transition:width 0.4s}

/* ── CANVAS ── */
.canvas-wrap{
  position:relative;padding:1.5rem 2.5rem;
}
canvas{
  width:100%;border:1px solid var(--border);border-radius:var(--radius);
  background:var(--deep);display:block;
}
.canvas-label{
  font-family:var(--mono);font-size:0.55rem;letter-spacing:0.2em;
  color:var(--text-3);text-transform:uppercase;margin-bottom:0.8rem;
}

/* ── LEGEND ── */
.legend{display:flex;gap:1.5rem;flex-wrap:wrap;margin-top:0.8rem}
.legend-item{
  display:flex;align-items:center;gap:0.4rem;
  font-family:var(--mono);font-size:0.58rem;color:var(--text-3);
}
.legend-dot{width:8px;height:8px;border-radius:50%}
.legend-line{width:16px;height:2px;border-radius:1px}

/* ── BELIEF TIMELINE ── */
.belief-flow{
  display:flex;flex-direction:column;gap:0;
  padding:1rem 2.5rem 2rem;
}
.belief-row{
  display:grid;grid-template-columns:28px 140px 1fr auto;
  gap:1rem;align-items:start;padding:0.8rem 0;
  border-bottom:1px solid var(--border);
  transition:background 0.15s;cursor:default;
}
.belief-row:hover{background:rgba(255,255,255,0.02)}
.b-num{
  font-family:var(--mono);font-size:0.55rem;color:var(--text-3);
  padding-top:0.25rem;text-align:right;
}
.b-epoch{
  font-family:var(--mono);font-size:0.58rem;color:var(--text-3);
  padding-top:0.25rem;
}
.b-belief{font-size:0.82rem;color:var(--text-2);line-height:1.5;padding-top:0.1rem}
.b-belief.crossed{text-decoration:line-through;color:var(--text-3);font-style:italic}
.b-belief.current{color:var(--text);font-weight:500}
.b-status{
  font-family:var(--mono);font-size:0.5rem;letter-spacing:0.15em;
  padding:0.2rem 0.5rem;border-radius:2px;white-space:nowrap;margin-top:0.2rem;
}

/* ── PARAM HEATMAP ── */
.heatmap-grid{
  display:grid;gap:3px;padding:1rem 2.5rem 2rem;
}
.heatmap-row{display:flex;gap:3px;align-items:center}
.heatmap-label{
  font-family:var(--mono);font-size:0.55rem;color:var(--text-3);
  width:120px;flex-shrink:0;text-align:right;padding-right:0.6rem;
}
.heatmap-cell{
  width:32px;height:32px;border-radius:3px;
  display:flex;align-items:center;justify-content:center;
  font-family:var(--mono);font-size:0.45rem;color:rgba(0,0,0,0.6);
  cursor:pointer;transition:transform 0.1s;font-weight:600;
  position:relative;
}
.heatmap-cell:hover{transform:scale(1.15);z-index:2}
.heatmap-col-labels{display:flex;gap:3px;margin-left:120px;margin-bottom:4px}
.heatmap-col-label{
  width:32px;font-family:var(--mono);font-size:0.45rem;
  color:var(--text-3);text-align:center;
}
.heatmap-tooltip{
  position:fixed;background:var(--panel);border:1px solid var(--border-bright);
  padding:0.6rem 0.8rem;border-radius:var(--radius);font-family:var(--mono);
  font-size:0.6rem;color:var(--text);pointer-events:none;z-index:200;
  display:none;max-width:200px;line-height:1.6;
}

/* ── EXPORT PANEL ── */
.export-panel{
  margin:1.5rem 2.5rem;
  background:var(--surface);border:1px solid var(--border);
  border-radius:var(--radius);overflow:hidden;
}
.export-header{
  padding:0.8rem 1.2rem;background:var(--lift);
  border-bottom:1px solid var(--border);
  font-family:var(--mono);font-size:0.6rem;color:var(--text-2);
  display:flex;align-items:center;justify-content:space-between;
}
.export-body{
  padding:1.2rem;font-family:var(--mono);font-size:0.65rem;
  color:var(--s4);line-height:1.8;max-height:320px;overflow-y:auto;
  white-space:pre-wrap;word-break:break-all;
}

/* ── EMPTY STATE ── */
.empty-state{
  text-align:center;padding:4rem 2rem;
  font-family:var(--serif);font-style:italic;
  color:var(--text-3);font-size:0.9rem;
}
.empty-icon{font-size:2rem;margin-bottom:1rem;display:block;opacity:0.4}

/* ── ANNOTATION ── */
.hand-note{
  font-family:var(--hand);font-size:1.1rem;color:var(--s4);
  padding:1rem 2.5rem;transform:rotate(-0.5deg);display:block;
  opacity:0.8;
}

/* ── STAT ROW ── */
.stat-row{
  display:grid;grid-template-columns:repeat(5,1fr);
  gap:1px;background:var(--border);border:1px solid var(--border);
  margin:1.5rem 2.5rem;
}
.stat-cell{
  background:var(--panel);padding:1rem 1.2rem;
  transition:background 0.2s;
}
.stat-cell:hover{background:var(--surface)}
.stat-cell-label{
  font-family:var(--mono);font-size:0.5rem;letter-spacing:0.2em;
  text-transform:uppercase;margin-bottom:0.4rem;
}
.stat-cell-val{font-family:var(--sans);font-weight:700;font-size:1.4rem;line-height:1}
.stat-cell-math{font-family:var(--mono);font-size:0.52rem;color:var(--text-3);margin-top:0.25rem}

/* ── TABS ── */
.tabs{display:flex;border-bottom:1px solid var(--border);padding:0 2.5rem}
.tab{
  font-family:var(--mono);font-size:0.6rem;letter-spacing:0.15em;
  text-transform:uppercase;padding:0.8rem 1rem;cursor:pointer;
  color:var(--text-3);border-bottom:2px solid transparent;
  margin-bottom:-1px;transition:all 0.2s;background:none;border-top:none;border-left:none;border-right:none;
}
.tab:hover{color:var(--text-2)}
.tab.active{color:var(--s4);border-bottom-color:var(--s4)}

/* ── TOOLTIP ── */
.tooltip{
  position:absolute;background:var(--panel);border:1px solid var(--border-bright);
  padding:0.5rem 0.7rem;border-radius:var(--radius);font-family:var(--mono);
  font-size:0.58rem;color:var(--text);white-space:nowrap;z-index:50;
  pointer-events:none;transform:translateX(-50%);bottom:calc(100% + 8px);left:50%;
}

/* ── RESPONSIVE ── */
@media(max-width:900px){
  .main{grid-template-columns:1fr}
  .sidebar{display:none}
  .form-row-3,.form-row-4{grid-template-columns:1fr 1fr}
  .card-grid-5{grid-template-columns:1fr 1fr}
  .stat-row{grid-template-columns:1fr 1fr}
}
@media(max-width:600px){
  .form-row-2,.form-row-3,.form-row-4{grid-template-columns:1fr}
  .card-grid-2,.card-grid-3,.card-grid-4{grid-template-columns:1fr}
  .log-table-wrap{padding:0 1rem 2rem}
  .section,.logger-form,.canvas-wrap,.stat-row,.export-panel,.belief-flow,.heatmap-grid{padding-left:1rem;padding-right:1rem}
  .page-header{padding:1.2rem 1rem}
  .stage-pills{padding:1rem}
}
</style>
</head>
<body>

<!-- TOOLTIP -->
<div class="heatmap-tooltip" id="hmTooltip"></div>

<!-- TOP BAR -->
<div class="topbar">
  <div class="topbar-brand">
    UKU<span>BONA</span>
    <small>TWIN v1.0</small>
  </div>
  <div class="topbar-nav">
    <button class="nav-pill active" onclick="showView('dashboard')">Dashboard</button>
    <button class="nav-pill" onclick="showView('logger')">Log Episode</button>
    <button class="nav-pill" onclick="showView('landscape')">Loss Landscape</button>
    <button class="nav-pill" onclick="showView('beliefs')">Beliefs</button>
    <button class="nav-pill" onclick="showView('export')">Export Twin</button>
  </div>
  <div class="topbar-status"><div class="status-dot"></div>TWIN ACTIVE</div>
</div>

<div class="main">

<!-- SIDEBAR -->
<div class="sidebar">
  <div class="sidebar-section">
    <div class="sidebar-label">Pentad Layers</div>
    <div class="sidebar-item" onclick="showView('dashboard')">
      <div class="sidebar-dot" style="background:var(--s1)"></div>I — Non-urticarial
    </div>
    <div class="sidebar-item" onclick="showView('dashboard')">
      <div class="sidebar-dot" style="background:var(--s2)"></div>II — Aquagenic
    </div>
    <div class="sidebar-item" onclick="showView('logger')">
      <div class="sidebar-dot" style="background:var(--s3)"></div>III — Pruritus
    </div>
    <div class="sidebar-item active" onclick="showView('landscape')">
      <div class="sidebar-dot" style="background:var(--s4)"></div>IV — Descent
    </div>
    <div class="sidebar-item" onclick="showView('beliefs')">
      <div class="sidebar-dot" style="background:var(--s5)"></div>V — Ukubona
    </div>
  </div>
  <div class="sidebar-section">
    <div class="sidebar-label">Tools</div>
    <div class="sidebar-item" onclick="showView('logger')">+ Log Episode</div>
    <div class="sidebar-item" onclick="showView('landscape')">Landscape Map</div>
    <div class="sidebar-item" onclick="showView('export')">Export JSON</div>
  </div>
  <div class="sidebar-section">
    <div class="sidebar-label">Model</div>
    <div class="sidebar-item" style="font-size:0.52rem;color:var(--text-3);cursor:default;flex-direction:column;align-items:flex-start;gap:0.15rem">
      <span style="font-family:var(--mono)">θ → L(θ) → ∇L</span>
      <span style="font-family:var(--mono)">→ SGD → θ′</span>
      <span style="font-family:var(--serif);font-style:italic;font-size:0.6rem;margin-top:0.3rem">Patient = Optimizer</span>
    </div>
  </div>
</div>

<!-- CONTENT -->
<div class="content">

<!-- ════════ DASHBOARD ════════ -->
<div class="view active" id="view-dashboard">
  <div class="page-header">
    <div class="page-header-left">
      <div class="page-eyebrow">Digital Twin · θ Model State</div>
      <div class="page-title">Dashboard <span>/ Overview</span></div>
      <div class="page-sub">Non-urticarial aquagenic pruritus · Descent optimization log</div>
    </div>
    <div class="page-actions">
      <button class="btn btn-primary" onclick="showView('logger')">+ Log Episode</button>
      <button class="btn btn-ghost" onclick="renderDashboard()">↺ Refresh</button>
    </div>
  </div>

  <div class="stat-row" id="statRow">
    <div class="stat-cell">
      <div class="stat-cell-label" style="color:var(--s3)">Episodes Logged</div>
      <div class="stat-cell-val" id="statN">0</div>
      <div class="stat-cell-math">n · training samples</div>
    </div>
    <div class="stat-cell">
      <div class="stat-cell-label" style="color:var(--s3)">Mean Loss L(θ)</div>
      <div class="stat-cell-val" id="statMean">—</div>
      <div class="stat-cell-math">pruritus intensity avg</div>
    </div>
    <div class="stat-cell">
      <div class="stat-cell-label" style="color:var(--s4)">Best θ Found</div>
      <div class="stat-cell-val" id="statBest">—</div>
      <div class="stat-cell-math">min L(θ) observed</div>
    </div>
    <div class="stat-cell">
      <div class="stat-cell-label" style="color:var(--s4)">Descent Progress</div>
      <div class="stat-cell-val" id="statTrend">—</div>
      <div class="stat-cell-math">∇ trend direction</div>
    </div>
    <div class="stat-cell">
      <div class="stat-cell-label" style="color:var(--s5)">Belief Version</div>
      <div class="stat-cell-val" id="statBelief">θ′₁</div>
      <div class="stat-cell-math">current posterior</div>
    </div>
  </div>

  <div class="section">
    <div class="section-title">Recent Episodes</div>
    <div id="dashRecentLog">
      <div class="empty-state">
        <span class="empty-icon">〰</span>
        No episodes logged yet.<br>Start your descent — log your first episode.
      </div>
    </div>
  </div>

  <div class="canvas-wrap">
    <div class="canvas-label">Loss L(θ) over time · pruritus intensity per episode</div>
    <canvas id="lossChart" height="160"></canvas>
    <div class="legend">
      <div class="legend-item"><div class="legend-line" style="background:var(--s3)"></div>L(θ) raw</div>
      <div class="legend-item"><div class="legend-line" style="background:var(--s4)"></div>7-episode rolling mean</div>
      <div class="legend-item"><div class="legend-line" style="background:var(--text-3);height:1px;border-top:1px dashed var(--text-3)"></div>optimal threshold</div>
    </div>
  </div>

  <span class="hand-note">"The body remembers what the chart makes visible."</span>
</div>

<!-- ════════ LOGGER ════════ -->
<div class="view" id="view-logger">
  <div class="page-header">
    <div class="page-header-left">
      <div class="page-eyebrow">Stage III → IV · Descent Log Entry</div>
      <div class="page-title">Log Episode <span>/ New Entry</span></div>
      <div class="page-sub">Record a descent event — one SGD step through the parameter landscape</div>
    </div>
  </div>

  <div class="stage-pills">
    <div class="stage-pill sp1"><span class="pill-num">I</span> Non-urticarial</div>
    <div class="stage-pill sp2"><span class="pill-num">II</span> Aquagenic</div>
    <div class="stage-pill sp3"><span class="pill-num">III</span> Pruritus → L(θ)</div>
    <div class="stage-pill sp4"><span class="pill-num">IV</span> Descent → SGD</div>
    <div class="stage-pill sp5"><span class="pill-num">V</span> Ukubona → θ′</div>
  </div>

  <div class="logger-form">

    <!-- STAGE I: Landscape -->
    <div>
      <div class="form-stage-header">
        <div class="form-stage-badge fsb-1">Stage I</div>
        <div class="form-stage-name">Non-urticarial Landscape</div>
        <div class="form-stage-math">θ · Phantom Layer</div>
      </div>
      <div class="form-row form-row-3" style="margin-top:0.8rem">
        <div class="form-group">
          <label class="form-label">Timestamp <span>*</span></label>
          <input type="datetime-local" class="form-input" id="f_timestamp">
        </div>
        <div class="form-group">
          <label class="form-label">Visible Skin Response</label>
          <div class="chip-group" id="skinChips">
            <div class="chip selected s1" data-val="none" onclick="toggleChip(this,'skinChips',true)">None (expected)</div>
            <div class="chip" data-val="mild-redness" onclick="toggleChip(this,'skinChips',true)">Mild redness</div>
            <div class="chip" data-val="wheals" onclick="toggleChip(this,'skinChips',true)">Wheals (atypical)</div>
          </div>
        </div>
        <div class="form-group">
          <label class="form-label">Mast-cell suspicion</label>
          <select class="form-select" id="f_mast">
            <option value="none">None — confirmed non-urticarial</option>
            <option value="low">Low — possible</option>
            <option value="uncertain">Uncertain</option>
          </select>
        </div>
      </div>
    </div>

    <!-- STAGE II: Aquagenic Trigger -->
    <div>
      <div class="form-stage-header">
        <div class="form-stage-badge fsb-2">Stage II</div>
        <div class="form-stage-name">Aquagenic Trigger</div>
        <div class="form-stage-math">h(t|X) = h₀(t)eˣᵝ</div>
      </div>
      <div class="form-row form-row-3" style="margin-top:0.8rem">
        <div class="form-group">
          <label class="form-label">Water Contact Type <span>*</span></label>
          <select class="form-select" id="f_watertype">
            <option value="shower">Shower</option>
            <option value="bath">Bath</option>
            <option value="swim">Swimming</option>
            <option value="rain">Rain exposure</option>
            <option value="sweat">Sweat</option>
            <option value="face-wash">Face wash</option>
            <option value="handwash">Hand wash</option>
            <option value="other">Other</option>
          </select>
        </div>
        <div class="form-group">
          <label class="form-label">Water Temperature</label>
          <div class="chip-group" id="tempChips">
            <div class="chip" data-val="cold" onclick="toggleChip(this,'tempChips',true)">Cold</div>
            <div class="chip" data-val="cool" onclick="toggleChip(this,'tempChips',true)">Cool</div>
            <div class="chip selected s2" data-val="lukewarm" onclick="toggleChip(this,'tempChips',true)">Lukewarm</div>
            <div class="chip" data-val="warm" onclick="toggleChip(this,'tempChips',true)">Warm</div>
            <div class="chip" data-val="hot" onclick="toggleChip(this,'tempChips',true)">Hot</div>
          </div>
        </div>
        <div class="form-group">
          <label class="form-label">Exposure Duration (min)</label>
          <div class="slider-wrap sl-s2">
            <input type="range" class="form-slider" id="f_duration" min="1" max="60" value="10" oninput="document.getElementById('vDuration').textContent=this.value">
            <div class="slider-val" id="vDuration" style="color:var(--s2)">10</div>
          </div>
        </div>
      </div>
      <div class="form-row form-row-2">
        <div class="form-group">
          <label class="form-label">Ambient Temp at Time</label>
          <div class="chip-group" id="ambChips">
            <div class="chip" data-val="cold-room" onclick="toggleChip(this,'ambChips',true)">Cold room</div>
            <div class="chip selected s2" data-val="neutral" onclick="toggleChip(this,'ambChips',true)">Neutral</div>
            <div class="chip" data-val="warm-room" onclick="toggleChip(this,'ambChips',true)">Warm room</div>
            <div class="chip" data-val="outdoors" onclick="toggleChip(this,'ambChips',true)">Outdoors</div>
          </div>
        </div>
        <div class="form-group">
          <label class="form-label">Time of Day</label>
          <div class="chip-group" id="todChips">
            <div class="chip" data-val="early-morning" onclick="toggleChip(this,'todChips',true)">Early AM</div>
            <div class="chip" data-val="morning" onclick="toggleChip(this,'todChips',true)">Morning</div>
            <div class="chip" data-val="afternoon" onclick="toggleChip(this,'todChips',true)">Afternoon</div>
            <div class="chip selected s2" data-val="evening" onclick="toggleChip(this,'todChips',true)">Evening</div>
            <div class="chip" data-val="night" onclick="toggleChip(this,'todChips',true)">Night</div>
          </div>
        </div>
      </div>
    </div>

    <!-- STAGE III: Pruritus / Loss -->
    <div>
      <div class="form-stage-header">
        <div class="form-stage-badge fsb-3">Stage III</div>
        <div class="form-stage-name">Pruritus — L(θ)</div>
        <div class="form-stage-math">Loss function · Felt gradient</div>
      </div>
      <div class="form-row form-row-2" style="margin-top:0.8rem">
        <div class="form-group">
          <label class="form-label">Intensity L(θ) 0–10 <span>*</span></label>
          <div class="slider-wrap sl-s3">
            <input type="range" class="form-slider" id="f_intensity" min="0" max="10" value="5" oninput="document.getElementById('vIntensity').textContent=this.value;updateIntensityColor()">
            <div class="slider-val" id="vIntensity">5</div>
          </div>
        </div>
        <div class="form-group">
          <label class="form-label">Onset Latency (min after trigger)</label>
          <div class="slider-wrap sl-s3">
            <input type="range" class="form-slider" id="f_latency" min="0" max="60" value="5" oninput="document.getElementById('vLatency').textContent=this.value">
            <div class="slider-val" id="vLatency" style="color:var(--s3)">5</div>
          </div>
        </div>
      </div>
      <div class="form-row form-row-3">
        <div class="form-group">
          <label class="form-label">Duration of Itch (min)</label>
          <div class="slider-wrap sl-s3">
            <input type="range" class="form-slider" id="f_itchdur" min="0" max="120" value="20" oninput="document.getElementById('vItchdur').textContent=this.value">
            <div class="slider-val" id="vItchdur" style="color:var(--s3)">20</div>
          </div>
        </div>
        <div class="form-group">
          <label class="form-label">Body Regions</label>
          <div class="chip-group" id="regionChips">
            <div class="chip s3" data-val="scalp" onclick="toggleChip(this,'regionChips')">Scalp</div>
            <div class="chip s3" data-val="torso" onclick="toggleChip(this,'regionChips')">Torso</div>
            <div class="chip s3" data-val="arms" onclick="toggleChip(this,'regionChips')">Arms</div>
            <div class="chip s3" data-val="legs" onclick="toggleChip(this,'regionChips')">Legs</div>
            <div class="chip s3" data-val="back" onclick="toggleChip(this,'regionChips')">Back</div>
            <div class="chip s3 selected" data-val="widespread" onclick="toggleChip(this,'regionChips')">Widespread</div>
          </div>
        </div>
        <div class="form-group">
          <label class="form-label">Quality</label>
          <div class="chip-group" id="qualChips">
            <div class="chip s3" data-val="burning" onclick="toggleChip(this,'qualChips')">Burning</div>
            <div class="chip s3 selected" data-val="prickling" onclick="toggleChip(this,'qualChips')">Prickling</div>
            <div class="chip s3" data-val="stinging" onclick="toggleChip(this,'qualChips')">Stinging</div>
            <div class="chip s3" data-val="deep-itch" onclick="toggleChip(this,'qualChips')">Deep itch</div>
          </div>
        </div>
      </div>
    </div>

    <!-- STAGE IV: Descent / SGD -->
    <div>
      <div class="form-stage-header">
        <div class="form-stage-badge fsb-4">Stage IV</div>
        <div class="form-stage-name">Descent — Behavioral Parameters</div>
        <div class="form-stage-math">θ ← θ − η∇L · SGD step</div>
      </div>
      <div class="form-row form-row-4" style="margin-top:0.8rem">
        <div class="form-group">
          <label class="form-label">Drying Method</label>
          <div class="chip-group" id="dryChips">
            <div class="chip selected s4" data-val="quick-pat" onclick="toggleChip(this,'dryChips',true)">Quick pat</div>
            <div class="chip s4" data-val="thorough-pat" onclick="toggleChip(this,'dryChips',true)">Thorough pat</div>
            <div class="chip s4" data-val="rubbing" onclick="toggleChip(this,'dryChips',true)">Rubbing</div>
            <div class="chip s4" data-val="air-dry" onclick="toggleChip(this,'dryChips',true)">Air dry</div>
          </div>
        </div>
        <div class="form-group">
          <label class="form-label">Post-Bath Covering</label>
          <div class="chip-group" id="coverChips">
            <div class="chip selected s4" data-val="immediate-dress" onclick="toggleChip(this,'coverChips',true)">Immediate dress</div>
            <div class="chip s4" data-val="towel-wrap" onclick="toggleChip(this,'coverChips',true)">Towel wrap</div>
            <div class="chip s4" data-val="robe" onclick="toggleChip(this,'coverChips',true)">Robe</div>
            <div class="chip s4" data-val="naked" onclick="toggleChip(this,'coverChips',true)">Naked</div>
          </div>
        </div>
        <div class="form-group">
          <label class="form-label">Bed Protocol (if bedtime)</label>
          <div class="chip-group" id="bedChips">
            <div class="chip s4" data-val="n/a" onclick="toggleChip(this,'bedChips',true)">N/A</div>
            <div class="chip selected s4" data-val="wrapped" onclick="toggleChip(this,'bedChips',true)">Wrapped</div>
            <div class="chip s4" data-val="naked" onclick="toggleChip(this,'bedChips',true)">Naked</div>
            <div class="chip s4" data-val="light-sheet" onclick="toggleChip(this,'bedChips',true)">Light sheet</div>
          </div>
        </div>
        <div class="form-group">
          <label class="form-label">Time-to-Cover (sec)</label>
          <div class="slider-wrap sl-s4">
            <input type="range" class="form-slider" id="f_covertime" min="0" max="300" value="30" oninput="document.getElementById('vCovertime').textContent=this.value">
            <div class="slider-val" id="vCovertime" style="color:var(--s4)">30</div>
          </div>
        </div>
      </div>
      <div class="form-row form-row-3">
        <div class="form-group">
          <label class="form-label">Interventions tried</label>
          <div class="chip-group" id="interventChips">
            <div class="chip s4" data-val="antihistamine" onclick="toggleChip(this,'interventChips')">Antihistamine</div>
            <div class="chip s4" data-val="cold-compress" onclick="toggleChip(this,'interventChips')">Cold compress</div>
            <div class="chip s4" data-val="moisturiser" onclick="toggleChip(this,'interventChips')">Moisturiser</div>
            <div class="chip s4" data-val="wait-it-out" onclick="toggleChip(this,'interventChips')">Wait it out</div>
            <div class="chip s4" data-val="distraction" onclick="toggleChip(this,'interventChips')">Distraction</div>
            <div class="chip s4" data-val="none" onclick="toggleChip(this,'interventChips')">None</div>
          </div>
        </div>
        <div class="form-group">
          <label class="form-label">Perceived η (learning rate)</label>
          <div class="chip-group" id="etaChips">
            <div class="chip s4" data-val="fast" onclick="toggleChip(this,'etaChips',true)">Fast ↑↑ (strong signal)</div>
            <div class="chip selected s4" data-val="medium" onclick="toggleChip(this,'etaChips',true)">Medium ↑</div>
            <div class="chip s4" data-val="slow" onclick="toggleChip(this,'etaChips',true)">Slow — noise dominated</div>
          </div>
        </div>
        <div class="form-group">
          <label class="form-label">Outcome vs Prior Episode</label>
          <div class="chip-group" id="outcomeChips">
            <div class="chip selected s4" data-val="better" onclick="toggleChip(this,'outcomeChips',true)">Better ↓L</div>
            <div class="chip s4" data-val="same" onclick="toggleChip(this,'outcomeChips',true)">Same</div>
            <div class="chip s4" data-val="worse" onclick="toggleChip(this,'outcomeChips',true)">Worse ↑L</div>
            <div class="chip s4" data-val="first" onclick="toggleChip(this,'outcomeChips',true)">First log</div>
          </div>
        </div>
      </div>
    </div>

    <!-- STAGE V: Ukubona -->
    <div>
      <div class="form-stage-header">
        <div class="form-stage-badge fsb-5">Stage V</div>
        <div class="form-stage-name">Ukubona — Belief Update</div>
        <div class="form-stage-math">θ′ · Posterior · Seeing</div>
      </div>
      <div class="form-row form-row-2" style="margin-top:0.8rem">
        <div class="form-group">
          <label class="form-label">Insight from this episode?</label>
          <textarea class="form-textarea" id="f_insight" placeholder="e.g. 'Lukewarm + quick-pat + immediate dress → intensity 2. Hot + linger → intensity 9. The delta-T is the variable, not the water itself.'" style="min-height:100px"></textarea>
        </div>
        <div class="form-group">
          <label class="form-label">Confidence in current mechanism model</label>
          <div class="slider-wrap sl-s4" style="margin-bottom:1rem">
            <span style="font-family:var(--mono);font-size:0.55rem;color:var(--text-3);width:80px">"allergic to water"</span>
            <input type="range" class="form-slider" id="f_confidence" min="0" max="100" value="70" oninput="document.getElementById('vConfidence').textContent=this.value+'%'">
            <div class="slider-val" id="vConfidence" style="color:var(--s5)">70%</div>
            <span style="font-family:var(--mono);font-size:0.55rem;color:var(--text-3);width:100px">C-fiber mechanism</span>
          </div>
          <label class="form-label" style="margin-top:0.6rem">Current belief label</label>
          <select class="form-select" id="f_belief">
            <option value="allergic-water">Allergic to water</option>
            <option value="allergic-cold">Allergic to cold</option>
            <option value="allergic-cold-water">Allergic to cold water</option>
            <option value="thermogradient">Thermogradient hypothesis</option>
            <option value="cfib-partial">C-fiber noise (partial)</option>
            <option value="cfib-full" selected>C-fiber noise/signal (full mechanism)</option>
            <option value="refining">Refining current model</option>
          </select>
        </div>
      </div>
      <div class="form-group">
        <label class="form-label">Notes / context</label>
        <textarea class="form-textarea" id="f_notes" placeholder="Stress level, diet changes, medication, sleep quality, unusual exposures..."></textarea>
      </div>
    </div>

    <div style="display:flex;gap:0.8rem;padding-top:0.5rem;border-top:1px solid var(--border)">
      <button class="btn btn-primary" onclick="submitEpisode()" style="font-size:0.7rem;padding:0.7rem 1.5rem">
        ↓ Commit SGD Step — Save Episode
      </button>
      <button class="btn btn-ghost" onclick="resetForm()">↺ Reset</button>
    </div>

    <div id="submitFeedback" style="display:none;font-family:var(--mono);font-size:0.65rem;color:var(--s4);padding:0.5rem 0"></div>

  </div>
</div>

<!-- ════════ LANDSCAPE ════════ -->
<div class="view" id="view-landscape">
  <div class="page-header">
    <div class="page-header-left">
      <div class="page-eyebrow">Stage IV · Descent Map</div>
      <div class="page-title">Loss Landscape <span>/ Parameter Space</span></div>
      <div class="page-sub">Heatmap of L(θ) across behavioral parameter combinations</div>
    </div>
    <div class="page-actions">
      <button class="btn btn-ghost" onclick="renderLandscape()">↺ Recompute</button>
    </div>
  </div>

  <div class="tabs">
    <button class="tab active" onclick="switchTab(this,'tabHeatmap')">Parameter Heatmap</button>
    <button class="tab" onclick="switchTab(this,'tabScatter')">Scatter Plot</button>
    <button class="tab" onclick="switchTab(this,'tabGradient')">Gradient Trace</button>
  </div>

  <div id="tabHeatmap" class="tab-panel">
    <div class="canvas-wrap" style="padding-top:1.5rem">
      <div class="canvas-label">Mean L(θ) — Temperature × Drying Method (color = loss; darker = lower loss = better)</div>
      <div class="heatmap-col-labels" id="hmColLabels"></div>
      <div id="hmGrid" class="heatmap-grid"></div>
    </div>
    <div class="section" style="padding-top:0.5rem">
      <div class="section-title">Discovered Optima</div>
      <div id="optimaList">
        <div class="empty-state"><span class="empty-icon">⛰</span>Log episodes to map the landscape.</div>
      </div>
    </div>
  </div>

  <div id="tabScatter" class="tab-panel" style="display:none">
    <div class="canvas-wrap" style="padding-top:1.5rem">
      <div class="canvas-label">Intensity L(θ) vs Episode — parameter color coding</div>
      <canvas id="scatterChart" height="220"></canvas>
    </div>
  </div>

  <div id="tabGradient" class="tab-panel" style="display:none">
    <div class="canvas-wrap" style="padding-top:1.5rem">
      <div class="canvas-label">Gradient trace — cumulative ∇L over descent history</div>
      <canvas id="gradientChart" height="220"></canvas>
    </div>
  </div>
</div>

<!-- ════════ BELIEFS ════════ -->
<div class="view" id="view-beliefs">
  <div class="page-header">
    <div class="page-header-left">
      <div class="page-eyebrow">Stage V · Ukubona</div>
      <div class="page-title">Belief State <span>/ θ′ Trajectory</span></div>
      <div class="page-sub">Posterior evolution — from "allergic to water" to mechanistic model</div>
    </div>
    <div class="page-actions">
      <button class="btn btn-violet" onclick="showView('logger')">Update Beliefs</button>
    </div>
  </div>

  <div class="belief-flow">
    <div class="belief-row" style="border-bottom:1px solid var(--border);padding-bottom:0.5rem;margin-bottom:0.3rem">
      <div class="b-num" style="font-family:var(--mono);font-size:0.5rem;color:var(--text-3)">#</div>
      <div class="b-epoch" style="font-family:var(--mono);font-size:0.5rem;letter-spacing:0.2em;color:var(--text-3)">EPOCH</div>
      <div class="b-belief" style="font-family:var(--mono);font-size:0.5rem;letter-spacing:0.2em;color:var(--text-3)">BELIEF STATE θ</div>
      <div class="b-status" style="font-family:var(--mono);font-size:0.5rem;letter-spacing:0.2em;color:var(--text-3)">STATUS</div>
    </div>

    <div class="belief-row">
      <div class="b-num">1</div>
      <div class="b-epoch">~2004</div>
      <div class="b-belief crossed">"I am allergic to water" — contact with any water triggers the response. Avoidance attempted; impractical.</div>
      <div class="b-status" style="color:var(--s1);background:var(--s1d);border:1px solid rgba(224,82,82,0.2)">ABANDONED</div>
    </div>
    <div class="belief-row">
      <div class="b-num">2</div>
      <div class="b-epoch">~2007</div>
      <div class="b-belief crossed">"I am allergic to cold" — cold exposure seems correlated. But warm water also sometimes triggers. Model fails to predict.</div>
      <div class="b-status" style="color:var(--s1);background:var(--s1d);border:1px solid rgba(224,82,82,0.2)">ABANDONED</div>
    </div>
    <div class="belief-row">
      <div class="b-num">3</div>
      <div class="b-epoch">~2010</div>
      <div class="b-belief crossed">"Allergic to cold water" — combination hypothesis. Better predictive power but still fails edge cases. Hot shower also triggers.</div>
      <div class="b-status" style="color:var(--s3);background:var(--s3d);border:1px solid rgba(232,162,58,0.2)">SUPERSEDED</div>
    </div>
    <div class="belief-row">
      <div class="b-num">4</div>
      <div class="b-epoch">~2015</div>
      <div class="b-belief">"Something about the <em>change</em> in temperature triggers it — not the water, not the cold, but the delta." Thermogradient hypothesis emerges. Explains hot and cold both triggering.</div>
      <div class="b-status" style="color:var(--s3);background:var(--s3d);border:1px solid rgba(232,162,58,0.2)">PARTIAL</div>
    </div>
    <div class="belief-row">
      <div class="b-num">5</div>
      <div class="b-epoch">~2020</div>
      <div class="b-belief">"C-fiber peripheral sensitization — small unmyelinated fibers operating near noise/signal threshold. Water + thermogradient pushes past threshold. No mast cells. Explains non-urticaria." First mechanistic account.</div>
      <div class="b-status" style="color:var(--s4);background:var(--s4d);border:1px solid rgba(82,196,122,0.2)">ADOPTED</div>
    </div>
    <div class="belief-row" style="background:rgba(169,127,232,0.04)">
      <div class="b-num" style="color:var(--s5)">θ′</div>
      <div class="b-epoch" style="color:var(--s5)">2026</div>
      <div class="b-belief current">"C-fiber high noise/signal ratio, triggered by aquagenic thermogradient. No mast-cell degranulation (Stage I confirmed). Behavioral parameters (Stage IV) modulate exposure rate and delta-T. Mechanism understood. Counterfactual simulation possible. Prediction accurate."</div>
      <div class="b-status" style="color:var(--s5);background:var(--s5d);border:1px solid rgba(169,127,232,0.3)">UKUBONA ✦</div>
    </div>

    <div id="dynamicBeliefs"></div>
  </div>

  <div class="canvas-wrap">
    <div class="canvas-label">Belief confidence trajectory — % certainty in mechanistic model over time</div>
    <canvas id="beliefChart" height="160"></canvas>
    <div class="legend">
      <div class="legend-item"><div class="legend-line" style="background:var(--s5)"></div>mechanistic confidence</div>
      <div class="legend-item"><div class="legend-line" style="background:var(--s4)"></div>behavioral control</div>
    </div>
  </div>

  <span class="hand-note">"Ukubona is not the end. It is the highest-fidelity prior for the next descent."</span>
</div>

<!-- ════════ EXPORT ════════ -->
<div class="view" id="view-export">
  <div class="page-header">
    <div class="page-header-left">
      <div class="page-eyebrow">Digital Twin · Data Model</div>
      <div class="page-title">Export <span>/ Twin JSON</span></div>
      <div class="page-sub">Full model state — hand this to the colony</div>
    </div>
    <div class="page-actions">
      <button class="btn btn-primary" onclick="exportJSON()">↓ Download JSON</button>
      <button class="btn btn-ghost" onclick="copyJSON()">⎘ Copy</button>
      <button class="btn btn-danger" onclick="clearAll()">✕ Clear All Data</button>
    </div>
  </div>

  <div class="section">
    <div class="section-title">Twin Model Schema</div>
    <div class="card-grid card-grid-3" style="margin-bottom:1.5rem">
      <div class="card">
        <div class="card-label">Model ID</div>
        <div class="card-value" style="font-size:0.9rem;font-family:var(--mono)" id="exportModelId">NAP-001</div>
        <div class="card-sub">non-urticarial aquagenic pruritus</div>
      </div>
      <div class="card">
        <div class="card-label">Framework</div>
        <div class="card-value" style="font-size:0.75rem;font-family:var(--mono)">θ→L→∇L→SGD→θ′</div>
        <div class="card-sub">Ukubona Pentad v1.0</div>
      </div>
      <div class="card">
        <div class="card-label">Episodes</div>
        <div class="card-value" id="exportN">0</div>
        <div class="card-sub">training samples</div>
      </div>
    </div>
  </div>

  <div class="export-panel">
    <div class="export-header">
      <span>twin_model.json</span>
      <span id="exportTimestamp" style="color:var(--text-3)"></span>
    </div>
    <div class="export-body" id="exportBody">// Log episodes to generate model JSON</div>
  </div>
</div>

</div><!-- /content -->
</div><!-- /main -->

<script>
// ════════════════════════════════════════════════════════════
// DATA MODEL
// ════════════════════════════════════════════════════════════
let episodes = JSON.parse(localStorage.getItem('ukubona_episodes') || '[]');

function save() {
  localStorage.setItem('ukubona_episodes', JSON.stringify(episodes));
}

// ════════════════════════════════════════════════════════════
// NAVIGATION
// ════════════════════════════════════════════════════════════
function showView(id) {
  document.querySelectorAll('.view').forEach(v => v.classList.remove('active'));
  document.getElementById('view-' + id).classList.add('active');
  document.querySelectorAll('.nav-pill').forEach(p => p.classList.remove('active'));
  const pills = {'dashboard':0,'logger':1,'landscape':2,'beliefs':3,'export':4};
  document.querySelectorAll('.nav-pill')[pills[id]]?.classList.add('active');
  if (id === 'dashboard') renderDashboard();
  if (id === 'landscape') renderLandscape();
  if (id === 'beliefs') renderBeliefs();
  if (id === 'export') renderExport();
}

function switchTab(btn, panelId) {
  document.querySelectorAll('.tab').forEach(t => t.classList.remove('active'));
  document.querySelectorAll('.tab-panel').forEach(p => p.style.display = 'none');
  btn.classList.add('active');
  document.getElementById(panelId).style.display = 'block';
  if (panelId === 'tabScatter') renderScatter();
  if (panelId === 'tabGradient') renderGradient();
}

// ════════════════════════════════════════════════════════════
// CHIPS
// ════════════════════════════════════════════════════════════
function toggleChip(el, groupId, single) {
  if (single) {
    document.querySelectorAll('#' + groupId + ' .chip').forEach(c => c.classList.remove('selected'));
    el.classList.add('selected');
  } else {
    el.classList.toggle('selected');
  }
}

function getChipVal(groupId) {
  return [...document.querySelectorAll('#' + groupId + ' .chip.selected')].map(c => c.dataset.val);
}

// ════════════════════════════════════════════════════════════
// FORM INIT
// ════════════════════════════════════════════════════════════
function updateIntensityColor() {
  const v = +document.getElementById('f_intensity').value;
  const c = v <= 3 ? 'var(--s4)' : v <= 6 ? 'var(--s3)' : 'var(--s1)';
  document.getElementById('vIntensity').style.color = c;
}

window.addEventListener('load', () => {
  const now = new Date();
  const local = new Date(now.getTime() - now.getTimezoneOffset() * 60000);
  document.getElementById('f_timestamp').value = local.toISOString().slice(0,16);
  renderDashboard();
  updateIntensityColor();
  renderHeatmap();
  renderBeliefChart();
});

// ════════════════════════════════════════════════════════════
// SUBMIT EPISODE
// ════════════════════════════════════════════════════════════
function submitEpisode() {
  const intensity = +document.getElementById('f_intensity').value;
  const ts = document.getElementById('f_timestamp').value;
  if (!ts) { alert('Please set a timestamp.'); return; }

  const ep = {
    id: 'EP-' + String(episodes.length + 1).padStart(4, '0'),
    timestamp: ts,
    created: new Date().toISOString(),

    // Stage I
    s1: {
      skin_response: getChipVal('skinChips')[0] || 'none',
      mast_cell: document.getElementById('f_mast').value,
    },

    // Stage II
    s2: {
      water_type: document.getElementById('f_watertype').value,
      temperature: getChipVal('tempChips')[0] || 'lukewarm',
      duration_min: +document.getElementById('f_duration').value,
      ambient: getChipVal('ambChips')[0] || 'neutral',
      time_of_day: getChipVal('todChips')[0] || 'evening',
    },

    // Stage III
    s3: {
      intensity: intensity,
      latency_min: +document.getElementById('f_latency').value,
      duration_min: +document.getElementById('f_itchdur').value,
      regions: getChipVal('regionChips'),
      quality: getChipVal('qualChips'),
    },

    // Stage IV
    s4: {
      drying: getChipVal('dryChips')[0] || 'quick-pat',
      covering: getChipVal('coverChips')[0] || 'immediate-dress',
      bed_protocol: getChipVal('bedChips')[0] || 'n/a',
      cover_time_sec: +document.getElementById('f_covertime').value,
      interventions: getChipVal('interventChips'),
      eta: getChipVal('etaChips')[0] || 'medium',
      outcome: getChipVal('outcomeChips')[0] || 'first',
    },

    // Stage V
    s5: {
      insight: document.getElementById('f_insight').value.trim(),
      confidence: +document.getElementById('f_confidence').value,
      belief: document.getElementById('f_belief').value,
      notes: document.getElementById('f_notes').value.trim(),
    }
  };

  episodes.push(ep);
  save();

  const fb = document.getElementById('submitFeedback');
  fb.style.display = 'block';
  fb.textContent = `✓ Episode ${ep.id} committed — SGD step recorded. L(θ) = ${intensity}/10`;
  setTimeout(() => fb.style.display = 'none', 4000);
}

function resetForm() {
  document.getElementById('f_insight').value = '';
  document.getElementById('f_notes').value = '';
  document.getElementById('f_intensity').value = 5;
  document.getElementById('vIntensity').textContent = '5';
  updateIntensityColor();
}

// ════════════════════════════════════════════════════════════
// DASHBOARD
// ════════════════════════════════════════════════════════════
function renderDashboard() {
  const n = episodes.length;
  document.getElementById('statN').textContent = n;

  if (n === 0) {
    document.getElementById('statMean').textContent = '—';
    document.getElementById('statBest').textContent = '—';
    document.getElementById('statTrend').textContent = '—';
    document.getElementById('dashRecentLog').innerHTML = `<div class="empty-state"><span class="empty-icon">〰</span>No episodes logged yet.<br>Start your descent — log your first episode.</div>`;
    renderLossChart([]);
    return;
  }

  const intensities = episodes.map(e => e.s3.intensity);
  const mean = (intensities.reduce((a,b)=>a+b,0)/n).toFixed(1);
  const best = Math.min(...intensities);
  document.getElementById('statMean').textContent = mean;
  document.getElementById('statBest').textContent = best + '/10';

  const recent5 = intensities.slice(-5);
  const earlier5 = intensities.slice(-10,-5);
  let trend = '—';
  if (recent5.length >= 2 && earlier5.length >= 2) {
    const rMean = recent5.reduce((a,b)=>a+b,0)/recent5.length;
    const eMean = earlier5.reduce((a,b)=>a+b,0)/earlier5.length;
    trend = rMean < eMean ? '↓ Improving' : rMean > eMean ? '↑ Worsening' : '→ Stable';
  } else if (n >= 2) {
    const d = intensities[n-1] - intensities[n-2];
    trend = d < 0 ? '↓' : d > 0 ? '↑' : '→';
  }
  document.getElementById('statTrend').textContent = trend;

  const recent = episodes.slice(-5).reverse();
  document.getElementById('dashRecentLog').innerHTML = `
    <div class="log-table-wrap" style="padding:0">
    <table class="log-table">
      <thead><tr>
        <th>ID</th><th>Timestamp</th>
        <th>II Trigger</th><th>II Temp</th>
        <th>III L(θ)</th>
        <th>IV Drying</th><th>IV Cover</th>
        <th>V Belief</th>
      </tr></thead>
      <tbody>
        ${recent.map(e => `<tr>
          <td class="td-id">${e.id}</td>
          <td class="td-time">${e.timestamp.replace('T',' ')}</td>
          <td><span class="tag" style="color:var(--s2)">${e.s2.water_type}</span></td>
          <td><span class="tag" style="color:var(--s2)">${e.s2.temperature}</span></td>
          <td>
            <div class="loss-bar-wrap">
              <div class="loss-bar"><div class="loss-bar-fill" style="width:${e.s3.intensity*10}%;background:${e.s3.intensity<=3?'var(--s4)':e.s3.intensity<=6?'var(--s3)':'var(--s1)'}"></div></div>
              <span style="color:${e.s3.intensity<=3?'var(--s4)':e.s3.intensity<=6?'var(--s3)':'var(--s1)'};font-weight:600">${e.s3.intensity}</span>
            </div>
          </td>
          <td><span class="tag" style="color:var(--s4)">${e.s4.drying}</span></td>
          <td><span class="tag" style="color:var(--s4)">${e.s4.covering}</span></td>
          <td style="font-size:0.65rem;color:var(--s5)">${e.s5.belief}</td>
        </tr>`).join('')}
      </tbody>
    </table></div>`;

  renderLossChart(intensities);
}

// ════════════════════════════════════════════════════════════
// LOSS CHART
// ════════════════════════════════════════════════════════════
function renderLossChart(data) {
  const canvas = document.getElementById('lossChart');
  if (!canvas) return;
  const ctx = canvas.getContext('2d');
  const W = canvas.offsetWidth * devicePixelRatio;
  const H = 160 * devicePixelRatio;
  canvas.width = W; canvas.height = H;
  ctx.scale(devicePixelRatio, devicePixelRatio);
  const w = canvas.offsetWidth, h = 160;

  ctx.fillStyle = '#0d1117';
  ctx.fillRect(0,0,w,h);

  // grid
  ctx.strokeStyle = 'rgba(255,255,255,0.05)';ctx.lineWidth=1;
  for(let i=0;i<=10;i++){const y=h-h*i/10-15;ctx.beginPath();ctx.moveTo(40,y);ctx.lineTo(w-10,y);ctx.stroke()}
  // y axis labels
  ctx.fillStyle='rgba(255,255,255,0.2)';ctx.font=`${9*devicePixelRatio/devicePixelRatio}px 'Syne Mono'`;
  for(let i=0;i<=10;i+=2){
    const y=h-h*i/10-15;
    ctx.fillText(i,4,y+4);
  }

  if (data.length === 0) {
    ctx.fillStyle='rgba(255,255,255,0.15)';ctx.font=`12px 'Lora'`;
    ctx.fillText('Log episodes to see L(θ) curve',w/2-100,h/2);
    return;
  }

  const pad=40,rpad=10,bpad=15,tpad=10;
  const cw=w-pad-rpad, ch=h-bpad-tpad;
  const xScale = i => pad + i*(cw/(data.length-1||1));
  const yScale = v => tpad+ch - v*ch/10;

  // optimal threshold line
  ctx.strokeStyle='rgba(255,255,255,0.1)';ctx.lineWidth=1;ctx.setLineDash([4,4]);
  ctx.beginPath();ctx.moveTo(pad,yScale(2));ctx.lineTo(w-rpad,yScale(2));ctx.stroke();
  ctx.setLineDash([]);
  ctx.fillStyle='rgba(255,255,255,0.2)';ctx.font=`9px 'Syne Mono'`;
  ctx.fillText('optimal',w-70,yScale(2)-5);

  // fill under curve
  const grad=ctx.createLinearGradient(0,0,0,h);
  grad.addColorStop(0,'rgba(232,162,58,0.15)');grad.addColorStop(1,'rgba(232,162,58,0)');
  ctx.fillStyle=grad;
  ctx.beginPath();ctx.moveTo(xScale(0),yScale(data[0]));
  data.forEach((d,i)=>ctx.lineTo(xScale(i),yScale(d)));
  ctx.lineTo(xScale(data.length-1),h);ctx.lineTo(pad,h);ctx.closePath();ctx.fill();

  // raw line
  ctx.strokeStyle='rgba(232,162,58,0.7)';ctx.lineWidth=1.5;ctx.setLineDash([]);
  ctx.beginPath();
  data.forEach((d,i)=>{i===0?ctx.moveTo(xScale(i),yScale(d)):ctx.lineTo(xScale(i),yScale(d))});
  ctx.stroke();

  // rolling mean
  if(data.length>=3){
    const win=Math.min(7,data.length);
    const roll=data.map((_,i)=>{
      const slice=data.slice(Math.max(0,i-win+1),i+1);
      return slice.reduce((a,b)=>a+b,0)/slice.length;
    });
    ctx.strokeStyle='rgba(82,196,122,0.85)';ctx.lineWidth=2;
    ctx.beginPath();
    roll.forEach((d,i)=>{i===0?ctx.moveTo(xScale(i),yScale(d)):ctx.lineTo(xScale(i),yScale(d))});
    ctx.stroke();
  }

  // dots
  data.forEach((d,i)=>{
    const c=d<=3?'#52c47a':d<=6?'#e8a23a':'#e05252';
    ctx.beginPath();ctx.arc(xScale(i),yScale(d),3,0,Math.PI*2);
    ctx.fillStyle=c;ctx.fill();
  });
}

// ════════════════════════════════════════════════════════════
// LANDSCAPE / HEATMAP
// ════════════════════════════════════════════════════════════
const TEMPS = ['cold','cool','lukewarm','warm','hot'];
const DRYS = ['quick-pat','thorough-pat','rubbing','air-dry'];

function renderLandscape() { renderHeatmap(); }

function renderHeatmap() {
  const colLabels = document.getElementById('hmColLabels');
  const grid = document.getElementById('hmGrid');
  if (!colLabels || !grid) return;

  colLabels.innerHTML = TEMPS.map(t=>`<div class="heatmap-col-label">${t}</div>`).join('');

  // Build matrix: rows=drying, cols=temp
  const matrix = DRYS.map(dry =>
    TEMPS.map(temp => {
      const matches = episodes.filter(e => e.s2.temperature===temp && e.s4.drying===dry);
      if (!matches.length) return null;
      return matches.reduce((a,b)=>a+b.s3.intensity,0)/matches.length;
    })
  );

  // fallback demo data if no episodes
  const hasData = matrix.some(row => row.some(v=>v!==null));
  const demo = [
    [8.5, 6.5, 3.0, 5.5, 9.0],
    [7.0, 5.0, 2.5, 4.0, 7.5],
    [9.5, 8.0, 6.5, 7.0, 9.5],
    [7.5, 6.0, 4.0, 5.5, 8.0],
  ];

  const display = hasData ? matrix : demo;

  grid.innerHTML = DRYS.map((dry, ri) => `
    <div class="heatmap-row">
      <div class="heatmap-label">${dry}</div>
      ${TEMPS.map((temp, ci) => {
        const v = display[ri][ci];
        if (v === null) return `<div class="heatmap-cell" style="background:rgba(255,255,255,0.04);color:var(--text-3)" data-tip="No data yet: ${dry} × ${temp}">?</div>`;
        const norm = v / 10;
        // green (low loss) to red (high loss)
        const r = Math.round(norm * 224 + (1-norm)*52);
        const g = Math.round(norm * 82 + (1-norm)*196);
        const b = Math.round(norm * 82 + (1-norm)*122);
        return `<div class="heatmap-cell"
          style="background:rgb(${r},${g},${b})"
          data-tip="${dry} × ${temp} → L(θ)=${v.toFixed(1)}${hasData?'':'(demo)'}"
          onmouseenter="showHmTip(event,this)"
          onmouseleave="hideHmTip()"
        >${v.toFixed(1)}</div>`;
      }).join('')}
    </div>
  `).join('');

  // Optima
  const opt = document.getElementById('optimaList');
  const found = [];
  display.forEach((row,ri)=>row.forEach((v,ci)=>{if(v!==null&&v<=3)found.push({dry:DRYS[ri],temp:TEMPS[ci],loss:v})}));
  found.sort((a,b)=>a.loss-b.loss);
  opt.innerHTML = found.length
    ? `<div style="display:flex;flex-wrap:wrap;gap:0.6rem">${found.map(f=>`<div style="background:var(--s4d);border:1px solid rgba(82,196,122,0.2);padding:0.5rem 0.8rem;border-radius:3px;font-family:var(--mono);font-size:0.62rem;color:var(--s4)">${f.dry} + ${f.temp} → L(θ)=${f.loss.toFixed(1)}</div>`).join('')}</div>`
    : `<div class="empty-state"><span class="empty-icon">⛰</span>No low-loss parameter combinations found yet.<br>${hasData?'Log more episodes.':'(Demo data shown — log episodes to see real landscape.)'}</div>`;

  renderScatter();
  renderGradient();
}

function showHmTip(e, el) {
  const tip = document.getElementById('hmTooltip');
  tip.textContent = el.dataset.tip;
  tip.style.display = 'block';
  tip.style.left = e.clientX + 12 + 'px';
  tip.style.top = e.clientY + 12 + 'px';
}
function hideHmTip() { document.getElementById('hmTooltip').style.display = 'none'; }

// ════════════════════════════════════════════════════════════
// SCATTER CHART
// ════════════════════════════════════════════════════════════
function renderScatter() {
  const canvas = document.getElementById('scatterChart');
  if (!canvas) return;
  const W = canvas.offsetWidth * devicePixelRatio;
  const H = 220 * devicePixelRatio;
  canvas.width = W; canvas.height = H;
  const ctx = canvas.getContext('2d');
  ctx.scale(devicePixelRatio, devicePixelRatio);
  const w = canvas.offsetWidth, h = 220;

  ctx.fillStyle = '#0d1117'; ctx.fillRect(0,0,w,h);

  const pad=40, rpad=20, bpad=30, tpad=10;
  const cw=w-pad-rpad, ch=h-bpad-tpad;

  // grid
  ctx.strokeStyle='rgba(255,255,255,0.05)';ctx.lineWidth=1;
  for(let i=0;i<=10;i++){const y=tpad+ch-ch*i/10;ctx.beginPath();ctx.moveTo(pad,y);ctx.lineTo(w-rpad,y);ctx.stroke()}
  ctx.fillStyle='rgba(255,255,255,0.2)';ctx.font='9px Syne Mono';
  for(let i=0;i<=10;i+=2){ctx.fillText(i,4,tpad+ch-ch*i/10+4)}

  if (episodes.length === 0) {
    ctx.fillStyle='rgba(255,255,255,0.15)';ctx.font='12px Lora';
    ctx.fillText('Log episodes to populate scatter',w/2-120,h/2); return;
  }

  const n = episodes.length;
  const xScale = i => pad + i*(cw/(n-1||1));
  const yScale = v => tpad+ch - v*ch/10;

  const tempColor = {cold:'#8ecae6',cool:'#4fa8d8',lukewarm:'#52c47a',warm:'#e8a23a',hot:'#e05252'};

  episodes.forEach((e,i)=>{
    const c = tempColor[e.s2.temperature] || 'var(--text-3)';
    const x = xScale(i), y = yScale(e.s3.intensity);
    ctx.beginPath();ctx.arc(x,y,5,0,Math.PI*2);
    ctx.fillStyle=c+'aa';ctx.fill();
    ctx.strokeStyle=c;ctx.lineWidth=1;ctx.stroke();
  });

  // x axis
  ctx.fillStyle='rgba(255,255,255,0.2)';ctx.font='9px Syne Mono';
  ctx.fillText('Episode →', w-80, h-8);
}

// ════════════════════════════════════════════════════════════
// GRADIENT TRACE
// ════════════════════════════════════════════════════════════
function renderGradient() {
  const canvas = document.getElementById('gradientChart');
  if (!canvas) return;
  const W = canvas.offsetWidth * devicePixelRatio;
  const H = 220 * devicePixelRatio;
  canvas.width = W; canvas.height = H;
  const ctx = canvas.getContext('2d');
  ctx.scale(devicePixelRatio, devicePixelRatio);
  const w = canvas.offsetWidth, h = 220;
  ctx.fillStyle = '#0d1117'; ctx.fillRect(0,0,w,h);

  if (episodes.length < 2) {
    ctx.fillStyle='rgba(255,255,255,0.15)';ctx.font='12px Lora';
    ctx.fillText('Need ≥2 episodes for gradient trace',w/2-130,h/2);return;
  }

  const grads = [];
  for(let i=1;i<episodes.length;i++){
    grads.push(episodes[i].s3.intensity - episodes[i-1].s3.intensity);
  }

  const pad=40,rpad=20,bpad=30,tpad=10;
  const cw=w-pad-rpad, ch=h-bpad-tpad;
  const maxG=Math.max(...grads.map(Math.abs),1);
  const mid = tpad+ch/2;
  const xScale = i => pad+i*(cw/(grads.length-1||1));
  const yScale = v => mid - v*ch/2/maxG;

  // zero line
  ctx.strokeStyle='rgba(255,255,255,0.1)';ctx.lineWidth=1;ctx.setLineDash([4,4]);
  ctx.beginPath();ctx.moveTo(pad,mid);ctx.lineTo(w-rpad,mid);ctx.stroke();ctx.setLineDash([]);
  ctx.fillStyle='rgba(255,255,255,0.2)';ctx.font='9px Syne Mono';
  ctx.fillText('∇L=0',4,mid+4);

  grads.forEach((g,i)=>{
    const x=xScale(i),y=yScale(g);
    ctx.beginPath();ctx.moveTo(x,mid);ctx.lineTo(x,y);
    ctx.strokeStyle=g<0?'rgba(82,196,122,0.7)':'rgba(224,82,82,0.7)';ctx.lineWidth=2;ctx.stroke();
    ctx.beginPath();ctx.arc(x,y,3,0,Math.PI*2);
    ctx.fillStyle=g<0?'var(--s4)':'var(--s1)';ctx.fill();
  });

  ctx.fillStyle='rgba(255,255,255,0.2)';ctx.font='9px Syne Mono';
  ctx.fillText('↓ descent (good)',4,mid-ch/2+14);
  ctx.fillText('↑ ascent',4,mid+ch/2-4);
}

// ════════════════════════════════════════════════════════════
// BELIEFS
// ════════════════════════════════════════════════════════════
function renderBeliefs() {
  const dynamic = document.getElementById('dynamicBeliefs');
  const fromLog = episodes.filter(e=>e.s5.insight||e.s5.belief);
  if (fromLog.length) {
    dynamic.innerHTML = fromLog.map(e=>`
      <div class="belief-row" style="background:rgba(169,127,232,0.03)">
        <div class="b-num" style="color:var(--text-3);font-size:0.55rem">${e.id}</div>
        <div class="b-epoch">${e.timestamp.slice(0,10)}</div>
        <div class="b-belief">${e.s5.insight || '—'} <span style="font-family:var(--mono);font-size:0.58rem;color:var(--text-3)">[${e.s5.belief}]</span></div>
        <div class="b-status" style="color:var(--s5);background:var(--s5d);border:1px solid rgba(169,127,232,0.2)">θ update</div>
      </div>`).join('');
  } else dynamic.innerHTML='';

  renderBeliefChart();
}

function renderBeliefChart() {
  const canvas = document.getElementById('beliefChart');
  if (!canvas) return;
  const W = canvas.offsetWidth * devicePixelRatio;
  const H = 160 * devicePixelRatio;
  canvas.width=W;canvas.height=H;
  const ctx=canvas.getContext('2d');
  ctx.scale(devicePixelRatio,devicePixelRatio);
  const w=canvas.offsetWidth,h=160;
  ctx.fillStyle='#0d1117';ctx.fillRect(0,0,w,h);

  // demo belief trajectory
  const belPoints = [
    {epoch:2004,mech:5,ctrl:5},{epoch:2007,mech:10,ctrl:8},
    {epoch:2010,mech:20,ctrl:15},{epoch:2015,mech:40,ctrl:35},
    {epoch:2020,mech:65,ctrl:55},{epoch:2023,mech:80,ctrl:70},
    {epoch:2026,mech:90,ctrl:82}
  ];

  const fromLog = episodes.filter(e=>e.s5.confidence>0);
  const allPoints = fromLog.length
    ? [...belPoints, ...fromLog.map(e=>({epoch:new Date(e.timestamp).getFullYear(),mech:e.s5.confidence,ctrl:e.s5.confidence*0.9}))]
    : belPoints;

  const epochs = allPoints.map(p=>p.epoch);
  const minE=Math.min(...epochs),maxE=Math.max(...epochs);
  const pad=35,rpad=10,bpad=25,tpad=10;
  const cw=w-pad-rpad,ch=h-bpad-tpad;
  const xS=e=>pad+(e-minE)/(maxE-minE+1)*cw;
  const yS=v=>tpad+ch-v*ch/100;

  // grid
  ctx.strokeStyle='rgba(255,255,255,0.05)';ctx.lineWidth=1;
  [0,25,50,75,100].forEach(v=>{
    ctx.beginPath();ctx.moveTo(pad,yS(v));ctx.lineTo(w-rpad,yS(v));ctx.stroke();
    ctx.fillStyle='rgba(255,255,255,0.2)';ctx.font='8px Syne Mono';
    ctx.fillText(v+'%',2,yS(v)+4);
  });

  // mech line
  const drawLine=(key,color)=>{
    ctx.strokeStyle=color;ctx.lineWidth=2;
    ctx.beginPath();
    allPoints.forEach((p,i)=>i===0?ctx.moveTo(xS(p.epoch),yS(p[key])):ctx.lineTo(xS(p.epoch),yS(p[key])));
    ctx.stroke();
    allPoints.forEach(p=>{
      ctx.beginPath();ctx.arc(xS(p.epoch),yS(p[key]),3,0,Math.PI*2);
      ctx.fillStyle=color;ctx.fill();
    });
  };

  drawLine('mech','rgba(169,127,232,0.85)');
  drawLine('ctrl','rgba(82,196,122,0.7)');

  // x labels
  ctx.fillStyle='rgba(255,255,255,0.2)';ctx.font='8px Syne Mono';
  [2004,2010,2015,2020,2026].forEach(y=>{
    ctx.fillText(y,xS(y)-10,h-6);
  });
}

// ════════════════════════════════════════════════════════════
// EXPORT
// ════════════════════════════════════════════════════════════
function renderExport() {
  document.getElementById('exportN').textContent = episodes.length;
  document.getElementById('exportTimestamp').textContent = new Date().toISOString();
  const model = buildTwinModel();
  document.getElementById('exportBody').textContent = JSON.stringify(model, null, 2);
}

function buildTwinModel() {
  const intensities = episodes.map(e => e.s3.intensity);
  return {
    twin_id: 'NAP-001',
    framework: 'Ukubona-Pentad-v1.0',
    condition: 'Non-urticarial aquagenic pruritus',
    generated: new Date().toISOString(),
    pentad_schema: {
      s1_landscape: 'θ · Phantom defined by structural absence · No mast-cell degranulation',
      s2_trigger: 'Aquagenic thermogradient · C-fiber threshold stimulus',
      s3_loss: 'L(θ) · Pruritus intensity 0-10 · h(t) = f(t)/S(t)',
      s4_descent: 'θ←θ−η∇L · Behavioral parameter SGD · Patient=Optimizer',
      s5_ukubona: 'θ′ · Posterior · Causal mechanistic model'
    },
    model_state: {
      current_belief: 'cfib-full',
      belief_label: 'C-fiber high noise/signal ratio triggered by aquagenic thermogradient',
      n_episodes: episodes.length,
      mean_loss: intensities.length ? +(intensities.reduce((a,b)=>a+b,0)/intensities.length).toFixed(2) : null,
      min_loss: intensities.length ? Math.min(...intensities) : null,
      max_loss: intensities.length ? Math.max(...intensities) : null,
    },
    discovered_optima: buildOptima(),
    parameter_importance: buildImportance(),
    descent_history: episodes,
  };
}

function buildOptima() {
  const results = {};
  episodes.forEach(e=>{
    const key=`${e.s2.temperature}__${e.s4.drying}__${e.s4.covering}`;
    if(!results[key])results[key]={params:{temp:e.s2.temperature,drying:e.s4.drying,covering:e.s4.covering},losses:[],n:0};
    results[key].losses.push(e.s3.intensity);results[key].n++;
  });
  return Object.values(results)
    .map(r=>({...r.params,mean_loss:+(r.losses.reduce((a,b)=>a+b,0)/r.n).toFixed(2),n:r.n}))
    .sort((a,b)=>a.mean_loss-b.mean_loss)
    .slice(0,10);
}

function buildImportance() {
  const factors=['temperature','drying','covering','cover_time_sec'];
  return factors.map(f=>{
    const groups={};
    episodes.forEach(e=>{
      const v=e.s2[f]||e.s4[f]||'unknown';
      if(!groups[v])groups[v]=[];
      groups[v].push(e.s3.intensity);
    });
    const means=Object.entries(groups).map(([k,vs])=>({val:k,mean:vs.reduce((a,b)=>a+b,0)/vs.length}));
    const range=means.length>1?Math.max(...means.map(m=>m.mean))-Math.min(...means.map(m=>m.mean)):0;
    return {factor:f,loss_range:+range.toFixed(2),levels:means};
  }).sort((a,b)=>b.loss_range-a.loss_range);
}

function exportJSON() {
  const model = buildTwinModel();
  const blob = new Blob([JSON.stringify(model,null,2)],{type:'application/json'});
  const url = URL.createObjectURL(blob);
  const a = document.createElement('a');
  a.href=url;a.download='ukubona_twin_NAP-001.json';a.click();
  URL.revokeObjectURL(url);
}

function copyJSON() {
  const model = buildTwinModel();
  navigator.clipboard.writeText(JSON.stringify(model,null,2)).then(()=>{
    const btn = event.target;
    btn.textContent='✓ Copied';setTimeout(()=>btn.textContent='⎘ Copy',2000);
  });
}

function clearAll() {
  if(confirm('Clear all logged episodes? This cannot be undone.')) {
    episodes=[];save();renderDashboard();renderExport();
    document.getElementById('exportBody').textContent='// All data cleared';
  }
}

// ════════════════════════════════════════════════════════════
// RESIZE HANDLER
// ════════════════════════════════════════════════════════════
window.addEventListener('resize', ()=>{
  if(document.getElementById('view-dashboard').classList.contains('active')) {
    renderLossChart(episodes.map(e=>e.s3.intensity));
  }
});
</script>
</body>
</html>
```