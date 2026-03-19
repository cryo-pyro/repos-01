#!/usr/bin/env bash
# ╔══════════════════════════════════════════════════════════════════╗
# ║  UKUBONA SOVEREIGN ENGINE  ·  v2.0.0                            ║
# ║  Local → GitHub → Render · Full deployment in one script        ║
# ╚══════════════════════════════════════════════════════════════════╝
set -euo pipefail

# ── Colours ────────────────────────────────────────────────────────
Y='\033[0;33m'; G='\033[0;32m'; R='\033[0;31m'; B='\033[0;34m'; NC='\033[0m'
info()    { echo -e "${B}▸${NC} $*"; }
success() { echo -e "${G}✓${NC} $*"; }
warn()    { echo -e "${Y}!${NC} $*"; }
die()     { echo -e "${R}✗ ERROR:${NC} $*"; exit 1; }

echo ""
echo -e "${Y}╔══════════════════════════════════════════════════╗${NC}"
echo -e "${Y}║  UKUBONA SOVEREIGN ENGINE  ·  v2.0.0             ║${NC}"
echo -e "${Y}║  135-District Digital Twin OS · Uganda           ║${NC}"
echo -e "${Y}╚══════════════════════════════════════════════════╝${NC}"
echo ""

# ── Prerequisites check ─────────────────────────────────────────────
for cmd in git curl python3; do
    command -v "$cmd" &>/dev/null || die "Required command not found: $cmd"
done
success "Prerequisites OK (git, curl, python3)"
echo ""

# ── Prompts ─────────────────────────────────────────────────────────
read -rp "$(echo -e ${Y})GitHub username      : $(echo -e ${NC})" GH_USER
read -rp "$(echo -e ${Y})Repository name      : $(echo -e ${NC})" REPO
read -rsp "$(echo -e ${Y})GitHub token (hidden): $(echo -e ${NC})" GH_TOKEN; echo ""
read -rp "$(echo -e ${Y})Repo visibility [public/private] (default: private): $(echo -e ${NC})" VISIBILITY
VISIBILITY=${VISIBILITY:-private}
[[ "$VISIBILITY" == "public" || "$VISIBILITY" == "private" ]] || die "Visibility must be 'public' or 'private'"
read -rsp "$(echo -e ${Y})Render API token (hidden): $(echo -e ${NC})" RENDER_TOKEN; echo ""
echo ""

# ── Validate GitHub token ───────────────────────────────────────────
info "Validating GitHub credentials..."
GH_CHECK=$(curl -sf -H "Authorization: token $GH_TOKEN" https://api.github.com/user | python3 -c "import sys,json; d=json.load(sys.stdin); print(d.get('login',''))" 2>/dev/null || echo "")
[[ "$GH_CHECK" == "$GH_USER" ]] || die "GitHub token invalid or username mismatch (got: '$GH_CHECK')"
success "GitHub authenticated as: $GH_USER"

# ── Create project directory ────────────────────────────────────────
[[ -d "$REPO" ]] && die "Directory '$REPO' already exists. Remove it first."
mkdir -p "$REPO"
cd "$REPO"
info "Created project directory: $REPO/"

# ════════════════════════════════════════════════════════════════════
# FILE GENERATION
# ════════════════════════════════════════════════════════════════════

# ── main.py ─────────────────────────────────────────────────────────
info "Writing main.py..."
cat > main.py << 'PYEOF'
"""
Ukubona Sovereign Engine v2.0.0
FastAPI backend — 135-district Uganda digital twin
"""

import math
import random
import time
from typing import Optional

from fastapi import FastAPI, WebSocket, WebSocketDisconnect
from fastapi.responses import HTMLResponse
from fastapi.staticfiles import StaticFiles
from fastapi.middleware.cors import CORSMiddleware

app = FastAPI(title="Ukubona Sovereign Engine", version="2.0.0")

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_methods=["*"],
    allow_headers=["*"],
)

# ── 135-District node table ──────────────────────────────────────────
DISTRICTS = [
    {"n": "Abim",          "lat":  3.00, "lon": 33.67, "pop": 130000},
    {"n": "Adjumani",      "lat":  3.38, "lon": 31.79, "pop": 231000},
    {"n": "Agago",         "lat":  2.98, "lon": 33.38, "pop": 340000},
    {"n": "Alebtong",      "lat":  2.26, "lon": 33.35, "pop": 263000},
    {"n": "Amolatar",      "lat":  1.60, "lon": 32.80, "pop": 170000},
    {"n": "Amudat",        "lat":  1.95, "lon": 34.93, "pop":  98000},
    {"n": "Amuria",        "lat":  2.03, "lon": 33.65, "pop": 253000},
    {"n": "Amuru",         "lat":  2.80, "lon": 31.92, "pop": 197000},
    {"n": "Apac",          "lat":  1.98, "lon": 32.54, "pop": 298000},
    {"n": "Arua",          "lat":  3.02, "lon": 30.91, "pop": 832000},
    {"n": "Budaka",        "lat":  1.00, "lon": 33.94, "pop": 233000},
    {"n": "Bududa",        "lat":  1.00, "lon": 34.33, "pop": 213000},
    {"n": "Bugiri",        "lat":  0.57, "lon": 33.75, "pop": 473000},
    {"n": "Buhweju",       "lat": -0.70, "lon": 30.42, "pop": 120000},
    {"n": "Buikwe",        "lat":  0.33, "lon": 33.00, "pop": 457000},
    {"n": "Bukedea",       "lat":  1.36, "lon": 34.00, "pop": 228000},
    {"n": "Bukomansimbi",  "lat": -0.14, "lon": 31.60, "pop": 161000},
    {"n": "Bukwo",         "lat":  1.28, "lon": 34.73, "pop": 119000},
    {"n": "Bulambuli",     "lat":  1.22, "lon": 34.38, "pop": 200000},
    {"n": "Buliisa",       "lat":  2.12, "lon": 31.41, "pop": 132000},
    {"n": "Bundibugyo",    "lat":  0.71, "lon": 30.07, "pop": 281000},
    {"n": "Bunyangabu",    "lat": -0.50, "lon": 30.18, "pop": 205000},
    {"n": "Bushenyi",      "lat": -0.58, "lon": 30.18, "pop": 234000},
    {"n": "Busia",         "lat":  0.46, "lon": 34.09, "pop": 343000},
    {"n": "Butaleja",      "lat":  0.90, "lon": 33.97, "pop": 255000},
    {"n": "Butebo",        "lat":  1.18, "lon": 34.05, "pop": 147000},
    {"n": "Buvuma",        "lat":  0.38, "lon": 33.22, "pop": 106000},
    {"n": "Buyende",       "lat":  1.24, "lon": 33.12, "pop": 326000},
    {"n": "Dokolo",        "lat":  1.91, "lon": 33.17, "pop": 205000},
    {"n": "Gomba",         "lat": -0.23, "lon": 31.68, "pop": 169000},
    {"n": "Gulu",          "lat":  2.77, "lon": 32.30, "pop": 557000},
    {"n": "Hoima",         "lat":  1.43, "lon": 31.35, "pop": 573000},
    {"n": "Ibanda",        "lat": -0.14, "lon": 30.50, "pop": 262000},
    {"n": "Iganga",        "lat":  0.61, "lon": 33.48, "pop": 561000},
    {"n": "Isingiro",      "lat": -0.84, "lon": 30.82, "pop": 497000},
    {"n": "Jinja",         "lat":  0.42, "lon": 33.20, "pop": 506000},
    {"n": "Kaabong",       "lat":  3.52, "lon": 34.14, "pop": 228000},
    {"n": "Kabale",        "lat": -1.25, "lon": 29.99, "pop": 524000},
    {"n": "Kabarole",      "lat":  0.65, "lon": 30.25, "pop": 451000},
    {"n": "Kaberamaido",   "lat":  1.74, "lon": 33.16, "pop": 192000},
    {"n": "Kagadi",        "lat":  0.94, "lon": 30.82, "pop": 370000},
    {"n": "Kakumiro",      "lat":  0.78, "lon": 31.33, "pop": 302000},
    {"n": "Kalaki",        "lat":  1.89, "lon": 33.38, "pop": 145000},
    {"n": "Kalangala",     "lat": -0.32, "lon": 32.23, "pop":  54000},
    {"n": "Kaliro",        "lat":  1.04, "lon": 33.50, "pop": 239000},
    {"n": "Kalungu",       "lat": -0.10, "lon": 31.78, "pop": 237000},
    {"n": "Kampala",       "lat":  0.32, "lon": 32.58, "pop": 1680000},
    {"n": "Kamuli",        "lat":  0.95, "lon": 33.12, "pop": 522000},
    {"n": "Kamwenge",      "lat":  0.19, "lon": 30.45, "pop": 385000},
    {"n": "Kanungu",       "lat": -0.96, "lon": 29.79, "pop": 270000},
    {"n": "Kapchorwa",     "lat":  1.40, "lon": 34.45, "pop": 176000},
    {"n": "Kapelebyong",   "lat":  1.90, "lon": 33.98, "pop": 131000},
    {"n": "Karenga",       "lat":  3.73, "lon": 33.80, "pop":  88000},
    {"n": "Kasanda",       "lat":  0.60, "lon": 31.72, "pop": 262000},
    {"n": "Kasese",        "lat":  0.18, "lon": 30.08, "pop": 700000},
    {"n": "Katakwi",       "lat":  1.90, "lon": 34.07, "pop": 211000},
    {"n": "Kayunga",       "lat":  0.71, "lon": 32.87, "pop": 390000},
    {"n": "Kazo",          "lat": -0.10, "lon": 30.68, "pop": 240000},
    {"n": "Kibale",        "lat":  0.87, "lon": 31.06, "pop": 385000},
    {"n": "Kiboga",        "lat":  0.91, "lon": 31.77, "pop": 196000},
    {"n": "Kibuku",        "lat":  1.04, "lon": 33.79, "pop": 215000},
    {"n": "Kikuube",       "lat":  1.58, "lon": 31.22, "pop": 274000},
    {"n": "Kiruhura",      "lat": -0.20, "lon": 30.86, "pop": 278000},
    {"n": "Kiryandongo",   "lat":  1.88, "lon": 32.10, "pop": 289000},
    {"n": "Kisoro",        "lat": -1.28, "lon": 29.65, "pop": 268000},
    {"n": "Kitgum",        "lat":  3.28, "lon": 32.89, "pop": 274000},
    {"n": "Koboko",        "lat":  3.41, "lon": 31.05, "pop": 227000},
    {"n": "Kole",          "lat":  2.37, "lon": 32.76, "pop": 234000},
    {"n": "Kotido",        "lat":  2.98, "lon": 34.13, "pop": 200000},
    {"n": "Kumi",          "lat":  1.46, "lon": 33.94, "pop": 232000},
    {"n": "Kwania",        "lat":  2.12, "lon": 32.60, "pop": 179000},
    {"n": "Kween",         "lat":  1.42, "lon": 34.63, "pop": 107000},
    {"n": "Kyankwanzi",    "lat":  1.09, "lon": 31.71, "pop": 264000},
    {"n": "Kyegegwa",      "lat":  0.48, "lon": 31.05, "pop": 275000},
    {"n": "Kyenjojo",      "lat":  0.62, "lon": 30.64, "pop": 430000},
    {"n": "Kyotera",       "lat": -0.65, "lon": 31.55, "pop": 299000},
    {"n": "Lamwo",         "lat":  3.53, "lon": 32.53, "pop": 135000},
    {"n": "Lira",          "lat":  2.25, "lon": 32.90, "pop": 634000},
    {"n": "Luuka",         "lat":  0.73, "lon": 33.30, "pop": 274000},
    {"n": "Luwero",        "lat":  0.85, "lon": 32.47, "pop": 500000},
    {"n": "Lwengo",        "lat": -0.40, "lon": 31.40, "pop": 287000},
    {"n": "Lyantonde",     "lat": -0.40, "lon": 31.15, "pop": 127000},
    {"n": "Madi-Okollo",   "lat":  3.10, "lon": 31.20, "pop": 186000},
    {"n": "Manafwa",       "lat":  0.88, "lon": 34.28, "pop": 270000},
    {"n": "Maracha",       "lat":  3.29, "lon": 30.96, "pop": 188000},
    {"n": "Masaka",        "lat": -0.34, "lon": 31.74, "pop": 528000},
    {"n": "Masindi",       "lat":  1.68, "lon": 31.71, "pop": 381000},
    {"n": "Mayuge",        "lat":  0.46, "lon": 33.57, "pop": 413000},
    {"n": "Mbale",         "lat":  1.08, "lon": 34.18, "pop": 576000},
    {"n": "Mbarara",       "lat": -0.60, "lon": 30.65, "pop": 700000},
    {"n": "Mitooma",       "lat": -0.63, "lon": 30.02, "pop": 211000},
    {"n": "Mityana",       "lat":  0.40, "lon": 32.02, "pop": 387000},
    {"n": "Moroto",        "lat":  2.53, "lon": 34.67, "pop": 122000},
    {"n": "Moyo",          "lat":  3.65, "lon": 31.73, "pop": 218000},
    {"n": "Mpigi",         "lat":  0.23, "lon": 32.32, "pop": 261000},
    {"n": "Mubende",       "lat":  0.57, "lon": 31.36, "pop": 596000},
    {"n": "Mukono",        "lat":  0.35, "lon": 32.76, "pop": 952000},
    {"n": "Nabilatuk",     "lat":  2.05, "lon": 34.53, "pop": 111000},
    {"n": "Nakapiripirit", "lat":  1.90, "lon": 34.65, "pop": 155000},
    {"n": "Nakaseke",      "lat":  1.12, "lon": 32.43, "pop": 265000},
    {"n": "Nakasongola",   "lat":  1.32, "lon": 32.45, "pop": 185000},
    {"n": "Namayingo",     "lat":  0.28, "lon": 33.92, "pop": 210000},
    {"n": "Namisindwa",    "lat":  0.95, "lon": 34.42, "pop": 196000},
    {"n": "Namutumba",     "lat":  0.83, "lon": 33.68, "pop": 253000},
    {"n": "Napak",         "lat":  2.36, "lon": 34.24, "pop": 166000},
    {"n": "Nebbi",         "lat":  2.48, "lon": 31.10, "pop": 313000},
    {"n": "Ngora",         "lat":  1.48, "lon": 33.77, "pop": 155000},
    {"n": "Ntoroko",       "lat":  1.03, "lon": 30.47, "pop":  81000},
    {"n": "Ntungamo",      "lat": -0.88, "lon": 30.27, "pop": 476000},
    {"n": "Nwoya",         "lat":  2.62, "lon": 31.95, "pop": 143000},
    {"n": "Obongi",        "lat":  3.52, "lon": 31.60, "pop": 130000},
    {"n": "Omoro",         "lat":  2.62, "lon": 32.52, "pop": 221000},
    {"n": "Otuke",         "lat":  2.52, "lon": 33.45, "pop": 135000},
    {"n": "Oyam",          "lat":  2.26, "lon": 32.40, "pop": 378000},
    {"n": "Pader",         "lat":  2.80, "lon": 33.20, "pop": 258000},
    {"n": "Pakwach",       "lat":  2.46, "lon": 31.49, "pop": 154000},
    {"n": "Pallisa",       "lat":  1.14, "lon": 33.71, "pop": 362000},
    {"n": "Rakai",         "lat": -0.73, "lon": 31.40, "pop": 348000},
    {"n": "Rubanda",       "lat": -1.19, "lon": 29.84, "pop": 196000},
    {"n": "Rubirizi",      "lat": -0.28, "lon": 30.10, "pop": 181000},
    {"n": "Rukiga",        "lat": -1.08, "lon": 29.95, "pop": 193000},
    {"n": "Rukungiri",     "lat": -0.84, "lon": 29.94, "pop": 316000},
    {"n": "Rwampara",      "lat": -0.68, "lon": 30.75, "pop": 188000},
    {"n": "Sembabule",     "lat": -0.07, "lon": 31.46, "pop": 241000},
    {"n": "Serere",        "lat":  1.50, "lon": 33.55, "pop": 247000},
    {"n": "Sheema",        "lat": -0.56, "lon": 30.38, "pop": 247000},
    {"n": "Sironko",       "lat":  1.23, "lon": 34.25, "pop": 248000},
    {"n": "Soroti",        "lat":  1.71, "lon": 33.61, "pop": 384000},
    {"n": "Terego",        "lat":  3.06, "lon": 30.80, "pop": 190000},
    {"n": "Tororo",        "lat":  0.69, "lon": 34.18, "pop": 573000},
    {"n": "Wakiso",        "lat":  0.40, "lon": 32.45, "pop": 2007000},
    {"n": "Yumbe",         "lat":  3.47, "lon": 31.25, "pop": 609000},
    {"n": "Zombo",         "lat":  2.67, "lon": 30.90, "pop": 190000},
]

# ── Spatially-correlated loss simulation ───────────────────────────
# Seed a slow-moving wave across the landscape so neighbouring
# districts move together — a simple analogue of epidemic diffusion
# or policy-gradient propagation.

_phase_offsets = [random.uniform(0, 2 * math.pi) for _ in DISTRICTS]
_base_losses   = [random.uniform(0.15, 0.85)     for _ in DISTRICTS]

def _loss_at(idx: int, t: float) -> float:
    """
    Smoothly time-varying loss with spatial autocorrelation seeded
    by latitude/longitude proximity.  Returns value in [0.05, 0.97].
    """
    d     = DISTRICTS[idx]
    phase = _phase_offsets[idx]
    base  = _base_losses[idx]

    # slow sinusoidal drift  (period ≈ 60 s)
    drift = 0.18 * math.sin(2 * math.pi * t / 60.0 + phase)

    # spatial coupling: pull toward weighted mean of neighbours
    coupling = 0.0
    weight   = 0.0
    for j, other in enumerate(DISTRICTS):
        if j == idx:
            continue
        dist = math.sqrt(
            (d["lat"] - other["lat"]) ** 2 +
            (d["lon"] - other["lon"]) ** 2
        )
        if dist < 2.0:          # ~200 km influence radius
            w         = 1.0 / (dist + 0.1)
            coupling += w * _base_losses[j]
            weight   += w

    neighbour_pull = (coupling / weight - base) * 0.08 if weight > 0 else 0.0

    raw = base + drift + neighbour_pull + random.gauss(0, 0.015)
    return max(0.05, min(0.97, raw))


# ── History buffer (last 20 ticks per district) ────────────────────
_HISTORY_LEN = 20
_history: list[list[float]] = [[] for _ in DISTRICTS]
_t0 = time.time()


def _tick() -> None:
    t = time.time() - _t0
    for i in range(len(DISTRICTS)):
        val = _loss_at(i, t)
        _base_losses[i] = _base_losses[i] * 0.98 + val * 0.02  # slow EMA drift
        buf = _history[i]
        buf.append(round(val, 4))
        if len(buf) > _HISTORY_LEN:
            buf.pop(0)


# ── REST endpoints ─────────────────────────────────────────────────

@app.get("/", response_class=HTMLResponse)
async def root():
    with open("index.html") as f:
        return f.read()


@app.get("/telemetry")
async def get_telemetry():
    _tick()
    t = time.time() - _t0
    return [
        {
            "n":       d["n"],
            "lat":     d["lat"],
            "lon":     d["lon"],
            "pop":     d["pop"],
            "loss":    round(_loss_at(i, t), 4),
            "history": list(_history[i]),
        }
        for i, d in enumerate(DISTRICTS)
    ]


@app.get("/telemetry/{name}")
async def get_district(name: str):
    _tick()
    t = time.time() - _t0
    for i, d in enumerate(DISTRICTS):
        if d["n"].lower() == name.lower():
            return {
                "n":       d["n"],
                "lat":     d["lat"],
                "lon":     d["lon"],
                "pop":     d["pop"],
                "loss":    round(_loss_at(i, t), 4),
                "history": list(_history[i]),
            }
    return {"error": "district not found"}


@app.get("/stats")
async def get_stats():
    _tick()
    t = time.time() - _t0
    losses = [_loss_at(i, t) for i in range(len(DISTRICTS))]
    losses_sorted = sorted(losses)
    n = len(losses)
    return {
        "n_districts": n,
        "mean":        round(sum(losses) / n, 4),
        "min":         round(min(losses), 4),
        "max":         round(max(losses), 4),
        "p25":         round(losses_sorted[n // 4], 4),
        "p75":         round(losses_sorted[3 * n // 4], 4),
        "gradient_norm": round(
            math.sqrt(sum((l - sum(losses) / n) ** 2 for l in losses) / n), 4
        ),
    }


@app.get("/health")
async def health():
    return {"status": "ok", "version": "2.0.0", "districts": len(DISTRICTS)}


# ── WebSocket live feed ────────────────────────────────────────────
import asyncio

@app.websocket("/ws")
async def websocket_endpoint(websocket: WebSocket):
    await websocket.accept()
    try:
        while True:
            _tick()
            t = time.time() - _t0
            payload = [
                {
                    "n":    d["n"],
                    "loss": round(_loss_at(i, t), 4),
                }
                for i, d in enumerate(DISTRICTS)
            ]
            await websocket.send_json(payload)
            await asyncio.sleep(3)
    except WebSocketDisconnect:
        pass
PYEOF

# ── index.html ──────────────────────────────────────────────────────
info "Writing index.html..."
cat > index.html << 'HTMLEOF'
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Ukubona · Sovereign Telemetry</title>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link href="https://fonts.googleapis.com/css2?family=IBM+Plex+Mono:wght@300;400;500&family=Cormorant+Garamond:ital,wght@0,300;0,600;1,300;1,600&display=swap" rel="stylesheet">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/leaflet@1.9.4/dist/leaflet.min.css">
<style>
  :root {
    --bg:      #080806;
    --surf:    #0e0e0c;
    --panel:   #121210;
    --border:  #252520;
    --text:    #d8d5cc;
    --dim:     #5a5a52;
    --gold:    #e8a020;
    --amber:   #c86020;
    --crimson: #c83838;
    --sage:    #5a8a60;
    --mono:    'IBM Plex Mono', monospace;
    --serif:   'Cormorant Garamond', Georgia, serif;
  }

  *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }

  html, body { height: 100%; overflow: hidden; }

  body {
    background: var(--bg);
    color: var(--text);
    font-family: var(--mono);
    font-size: 13px;
    display: grid;
    grid-template-rows: 52px 1fr;
    grid-template-columns: 1fr 340px;
    grid-template-areas:
      "header  header"
      "map     sidebar";
  }

  /* ── HEADER ── */
  #header {
    grid-area: header;
    background: var(--surf);
    border-bottom: 1px solid var(--border);
    display: flex;
    align-items: center;
    padding: 0 20px;
    gap: 24px;
    z-index: 1000;
  }
  .header-logo {
    font-family: var(--serif);
    font-size: 1.3rem;
    font-weight: 600;
    letter-spacing: 0.02em;
    color: var(--gold);
  }
  .header-logo span { font-style: italic; font-weight: 300; color: var(--dim); font-size: 1rem; }
  .header-pill {
    font-size: 9px;
    letter-spacing: 0.18em;
    text-transform: uppercase;
    padding: 3px 8px;
    border: 1px solid var(--border);
    color: var(--dim);
    border-radius: 2px;
  }
  .header-pill.live { border-color: var(--sage); color: var(--sage); }
  .header-pill.live::before { content: '● '; animation: pulse 1.4s infinite; }
  @keyframes pulse { 0%,100%{opacity:1} 50%{opacity:0.3} }
  #header-stats {
    margin-left: auto;
    display: flex;
    gap: 28px;
  }
  .hstat {
    text-align: right;
  }
  .hstat-val {
    font-size: 14px;
    font-weight: 500;
    color: var(--gold);
  }
  .hstat-label {
    font-size: 9px;
    letter-spacing: 0.14em;
    text-transform: uppercase;
    color: var(--dim);
    margin-top: 1px;
  }

  /* ── MAP ── */
  #map {
    grid-area: map;
    background: #030302;
  }
  .leaflet-tile-pane { filter: saturate(0.15) brightness(0.55) sepia(0.3); }
  .leaflet-control-attribution { display: none !important; }
  .leaflet-control-zoom a {
    background: var(--panel) !important;
    color: var(--dim) !important;
    border-color: var(--border) !important;
  }

  /* ── SIDEBAR ── */
  #sidebar {
    grid-area: sidebar;
    background: var(--panel);
    border-left: 1px solid var(--border);
    display: flex;
    flex-direction: column;
    overflow: hidden;
  }
  .sidebar-section {
    border-bottom: 1px solid var(--border);
    padding: 16px 18px;
  }
  .sidebar-section:last-child { border-bottom: none; flex: 1; overflow-y: auto; }
  .section-label {
    font-size: 9px;
    letter-spacing: 0.22em;
    text-transform: uppercase;
    color: var(--dim);
    margin-bottom: 12px;
  }

  /* District inspector */
  #district-name {
    font-family: var(--serif);
    font-size: 1.6rem;
    font-weight: 600;
    color: var(--gold);
    line-height: 1.1;
    margin-bottom: 4px;
    min-height: 2rem;
  }
  #district-meta { color: var(--dim); font-size: 11px; margin-bottom: 14px; }

  .loss-bar-wrap {
    height: 4px;
    background: var(--border);
    border-radius: 2px;
    margin: 8px 0 4px;
    overflow: hidden;
  }
  #loss-bar-fill {
    height: 100%;
    border-radius: 2px;
    transition: width 0.6s ease, background 0.6s ease;
  }
  #loss-value {
    font-size: 22px;
    font-weight: 500;
    color: var(--text);
    letter-spacing: -0.03em;
  }
  #loss-label { font-size: 9px; letter-spacing: 0.18em; text-transform: uppercase; color: var(--dim); margin-left: 4px; }

  /* Sparkline */
  #sparkline-wrap {
    margin-top: 10px;
    height: 42px;
    position: relative;
  }
  #sparkline {
    width: 100%;
    height: 42px;
    display: block;
  }

  /* Stats grid */
  .stats-grid {
    display: grid;
    grid-template-columns: 1fr 1fr;
    gap: 10px;
  }
  .stat-box {
    background: var(--bg);
    border: 1px solid var(--border);
    padding: 10px 12px;
    border-radius: 3px;
  }
  .stat-val {
    font-size: 16px;
    font-weight: 500;
    color: var(--text);
    letter-spacing: -0.02em;
  }
  .stat-name {
    font-size: 9px;
    letter-spacing: 0.14em;
    text-transform: uppercase;
    color: var(--dim);
    margin-top: 3px;
  }

  /* ‖∇L‖ gradient norm strip */
  #grad-norm-bar {
    margin-top: 10px;
    height: 3px;
    background: var(--border);
    border-radius: 2px;
    overflow: hidden;
  }
  #grad-norm-fill {
    height: 100%;
    background: linear-gradient(90deg, var(--sage), var(--gold), var(--crimson));
    transition: width 1s ease;
  }
  #grad-norm-label {
    font-size: 9px;
    letter-spacing: 0.14em;
    text-transform: uppercase;
    color: var(--dim);
    margin-top: 5px;
  }

  /* District list */
  #district-list { list-style: none; }
  .dl-item {
    display: flex;
    align-items: center;
    gap: 10px;
    padding: 6px 0;
    border-bottom: 1px solid #1a1a17;
    cursor: pointer;
    transition: background 0.15s;
  }
  .dl-item:hover { background: #1a1a17; margin: 0 -18px; padding: 6px 18px; }
  .dl-dot {
    width: 8px; height: 8px;
    border-radius: 50%;
    flex-shrink: 0;
  }
  .dl-name {
    flex: 1;
    color: var(--dim);
    font-size: 11px;
    white-space: nowrap;
    overflow: hidden;
    text-overflow: ellipsis;
  }
  .dl-loss {
    font-size: 11px;
    font-weight: 500;
    min-width: 36px;
    text-align: right;
  }

  /* Legend */
  .legend {
    display: flex;
    align-items: center;
    gap: 6px;
    font-size: 9px;
    letter-spacing: 0.1em;
    color: var(--dim);
    text-transform: uppercase;
    margin-top: 8px;
  }
  .legend-grad {
    flex: 1;
    height: 4px;
    border-radius: 2px;
    background: linear-gradient(90deg, var(--sage), var(--gold), var(--crimson));
  }
</style>
</head>
<body>

<!-- HEADER -->
<header id="header">
  <div class="header-logo">Ukubona <span>· sovereign telemetry</span></div>
  <div class="header-pill live">live</div>
  <div class="header-pill">135 districts · Uganda</div>
  <div id="header-stats">
    <div class="hstat">
      <div class="hstat-val" id="h-mean">—</div>
      <div class="hstat-label">mean L(θ)</div>
    </div>
    <div class="hstat">
      <div class="hstat-val" id="h-max">—</div>
      <div class="hstat-label">max loss</div>
    </div>
    <div class="hstat">
      <div class="hstat-val" id="h-grad">—</div>
      <div class="hstat-label">‖∇L‖</div>
    </div>
    <div class="hstat">
      <div class="hstat-val" id="h-tick">—</div>
      <div class="hstat-label">tick</div>
    </div>
  </div>
</header>

<!-- MAP -->
<div id="map"></div>

<!-- SIDEBAR -->
<aside id="sidebar">

  <div class="sidebar-section">
    <div class="section-label">District Inspector</div>
    <div id="district-name">—</div>
    <div id="district-meta">hover or click a district</div>
    <div style="display:flex;align-items:baseline;gap:4px;margin-top:6px;">
      <span id="loss-value">—</span>
      <span id="loss-label">L(θ)</span>
    </div>
    <div class="loss-bar-wrap">
      <div id="loss-bar-fill" style="width:0%;background:var(--gold)"></div>
    </div>
    <div id="sparkline-wrap">
      <canvas id="sparkline"></canvas>
    </div>
  </div>

  <div class="sidebar-section">
    <div class="section-label">System Stats</div>
    <div class="stats-grid">
      <div class="stat-box">
        <div class="stat-val" id="s-mean">—</div>
        <div class="stat-name">mean</div>
      </div>
      <div class="stat-box">
        <div class="stat-val" id="s-max">—</div>
        <div class="stat-name">max</div>
      </div>
      <div class="stat-box">
        <div class="stat-val" id="s-p25">—</div>
        <div class="stat-name">p25</div>
      </div>
      <div class="stat-box">
        <div class="stat-val" id="s-p75">—</div>
        <div class="stat-name">p75</div>
      </div>
    </div>
    <div id="grad-norm-bar"><div id="grad-norm-fill" style="width:0%"></div></div>
    <div id="grad-norm-label">‖∇L‖ = <span id="grad-val">—</span></div>
    <div class="legend" style="margin-top:10px;">
      <span>low</span><div class="legend-grad"></div><span>high</span>
    </div>
  </div>

  <div class="sidebar-section">
    <div class="section-label">All Districts</div>
    <ul id="district-list"></ul>
  </div>

</aside>

<script src="https://cdn.jsdelivr.net/npm/leaflet@1.9.4/dist/leaflet.min.js"></script>
<script>
// ── Colour scale ───────────────────────────────────────────────────
function lossColour(v) {
  // sage (0) → gold (0.5) → crimson (1)
  if (v < 0.5) {
    const t = v * 2;
    const r = Math.round(90  + t * (232 - 90));
    const g = Math.round(138 + t * (160 - 138));
    const b = Math.round(96  + t * (32  - 96));
    return `rgb(${r},${g},${b})`;
  } else {
    const t = (v - 0.5) * 2;
    const r = Math.round(232 + t * (200 - 232));
    const g = Math.round(160 + t * (56  - 160));
    const b = Math.round(32  + t * (56  - 32));
    return `rgb(${r},${g},${b})`;
  }
}

function popRadius(pop) {
  return 4 + Math.sqrt(pop / 1680000) * 18;
}

// ── Map init ───────────────────────────────────────────────────────
const map = L.map('map', { zoomControl: true, attributionControl: false })
             .setView([1.37, 32.29], 7);

L.tileLayer('https://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}{r}.png', {
  maxZoom: 18
}).addTo(map);

// ── State ──────────────────────────────────────────────────────────
let markers      = {};
let selectedName = null;
let tickCount    = 0;

// ── Sparkline ──────────────────────────────────────────────────────
const sparkCanvas = document.getElementById('sparkline');
const sparkCtx    = sparkCanvas.getContext('2d');

function drawSparkline(history) {
  const W = sparkCanvas.offsetWidth;
  const H = 42;
  sparkCanvas.width  = W;
  sparkCanvas.height = H;
  sparkCtx.clearRect(0, 0, W, H);

  if (!history || history.length < 2) return;

  const n  = history.length;
  const dx = W / (n - 1);

  sparkCtx.beginPath();
  history.forEach((v, i) => {
    const x = i * dx;
    const y = H - v * (H - 4) - 2;
    i === 0 ? sparkCtx.moveTo(x, y) : sparkCtx.lineTo(x, y);
  });

  // gradient fill under line
  const last  = history[history.length - 1];
  const grad  = sparkCtx.createLinearGradient(0, 0, W, 0);
  grad.addColorStop(0,   'rgba(90,138,96,0.15)');
  grad.addColorStop(0.5, 'rgba(232,160,32,0.3)');
  grad.addColorStop(1,   lossColour(last) + '66');

  const fill = new Path2D(sparkCtx.currentPath);
  sparkCtx.lineTo(W, H);
  sparkCtx.lineTo(0, H);
  sparkCtx.closePath();
  sparkCtx.fillStyle = grad;
  sparkCtx.fill();

  sparkCtx.beginPath();
  history.forEach((v, i) => {
    const x = i * dx;
    const y = H - v * (H - 4) - 2;
    i === 0 ? sparkCtx.moveTo(x, y) : sparkCtx.lineTo(x, y);
  });
  sparkCtx.strokeStyle = lossColour(last);
  sparkCtx.lineWidth   = 1.5;
  sparkCtx.stroke();
}

// ── Inspector ─────────────────────────────────────────────────────
function inspectDistrict(d) {
  selectedName = d.n;
  document.getElementById('district-name').textContent = d.n;
  document.getElementById('district-meta').textContent =
    `pop. ${(d.pop / 1000).toFixed(0)}k  ·  ${d.lat.toFixed(2)}°, ${d.lon.toFixed(2)}°`;

  const v = d.loss;
  document.getElementById('loss-value').textContent = v.toFixed(3);
  document.getElementById('loss-value').style.color = lossColour(v);

  const fill = document.getElementById('loss-bar-fill');
  fill.style.width      = (v * 100) + '%';
  fill.style.background = lossColour(v);

  drawSparkline(d.history);
}

// ── District list ──────────────────────────────────────────────────
function buildList(data) {
  const ul = document.getElementById('district-list');
  if (ul.children.length === 0) {
    // first build
    const sorted = [...data].sort((a, b) => b.loss - a.loss);
    sorted.forEach(d => {
      const li = document.createElement('li');
      li.className     = 'dl-item';
      li.dataset.name  = d.n;
      li.innerHTML = `
        <div class="dl-dot" style="background:${lossColour(d.loss)}"></div>
        <span class="dl-name">${d.n}</span>
        <span class="dl-loss" style="color:${lossColour(d.loss)}">${d.loss.toFixed(2)}</span>
      `;
      li.addEventListener('click', () => {
        inspectDistrict(d);
        map.flyTo([d.lat, d.lon], 9, { duration: 1 });
      });
      ul.appendChild(li);
    });
  } else {
    // update values
    data.forEach(d => {
      const li = ul.querySelector(`[data-name="${d.n}"]`);
      if (!li) return;
      li.querySelector('.dl-dot').style.background = lossColour(d.loss);
      const lv = li.querySelector('.dl-loss');
      lv.textContent  = d.loss.toFixed(2);
      lv.style.color  = lossColour(d.loss);
    });
  }
}

// ── Stats update ───────────────────────────────────────────────────
function updateStats(stats) {
  document.getElementById('s-mean').textContent = stats.mean.toFixed(3);
  document.getElementById('s-max').textContent  = stats.max.toFixed(3);
  document.getElementById('s-p25').textContent  = stats.p25.toFixed(3);
  document.getElementById('s-p75').textContent  = stats.p75.toFixed(3);

  document.getElementById('h-mean').textContent = stats.mean.toFixed(3);
  document.getElementById('h-max').textContent  = stats.max.toFixed(3);
  document.getElementById('h-grad').textContent = stats.gradient_norm.toFixed(4);

  const pct = Math.min(stats.gradient_norm * 200, 100);
  document.getElementById('grad-norm-fill').style.width = pct + '%';
  document.getElementById('grad-val').textContent = stats.gradient_norm.toFixed(4);
}

// ── Main poll loop ─────────────────────────────────────────────────
async function poll() {
  try {
    const [telR, statR] = await Promise.all([
      fetch('/telemetry'),
      fetch('/stats'),
    ]);
    const data  = await telR.json();
    const stats = await statR.json();

    tickCount++;
    document.getElementById('h-tick').textContent = tickCount;

    // map circles
    data.forEach(d => {
      const colour = lossColour(d.loss);
      const radius = popRadius(d.pop);

      if (!markers[d.n]) {
        const circle = L.circleMarker([d.lat, d.lon], {
          radius:      radius,
          color:       colour,
          fillColor:   colour,
          fillOpacity: 0.55,
          weight:      1.2,
          opacity:     0.8,
        }).addTo(map);

        circle.on('mouseover', () => inspectDistrict(d));
        circle.on('click',     () => {
          inspectDistrict(d);
          map.flyTo([d.lat, d.lon], 9, { duration: 0.8 });
        });

        markers[d.n] = circle;
      } else {
        markers[d.n].setStyle({
          color:       colour,
          fillColor:   colour,
          fillOpacity: 0.55,
          radius:      radius,
        });
        // update data ref for click handler
        markers[d.n].off('mouseover').on('mouseover', () => inspectDistrict(d));
        markers[d.n].off('click').on('click', () => {
          inspectDistrict(d);
          map.flyTo([d.lat, d.lon], 9, { duration: 0.8 });
        });
      }
    });

    // update selected inspector in-place
    if (selectedName) {
      const sel = data.find(d => d.n === selectedName);
      if (sel) inspectDistrict(sel);
    }

    buildList(data);
    updateStats(stats);

  } catch (e) {
    console.warn('poll error', e);
  }
}

poll();
setInterval(poll, 4000);
</script>
</body>
</html>
HTMLEOF

# ── requirements.txt ────────────────────────────────────────────────
info "Writing requirements.txt..."
cat > requirements.txt << 'EOF'
fastapi==0.111.0
uvicorn[standard]==0.29.0
EOF

# ── render.yaml ─────────────────────────────────────────────────────
info "Writing render.yaml..."
cat > render.yaml << RENDERYAML
services:
  - type: web
    name: ${REPO}
    runtime: python
    buildCommand: pip install -r requirements.txt
    startCommand: uvicorn main:app --host 0.0.0.0 --port \$PORT
    healthCheckPath: /health
    envVars:
      - key: PYTHON_VERSION
        value: 3.11.0
RENDERYAML

# ── .gitignore ───────────────────────────────────────────────────────
cat > .gitignore << 'EOF'
__pycache__/
*.pyc
.env
venv/
.venv/
*.egg-info/
dist/
EOF

# ── README.md ────────────────────────────────────────────────────────
cat > README.md << READMEEOF
# ${REPO}

**Ukubona Sovereign Engine v2.0.0**
135-district Uganda digital twin OS.

## Endpoints

| Path | Description |
|------|-------------|
| \`GET /\` | Dashboard UI |
| \`GET /telemetry\` | All 135 districts with loss + history |
| \`GET /telemetry/{name}\` | Single district |
| \`GET /stats\` | System-level statistics (mean, max, p25, p75, ‖∇L‖) |
| \`GET /health\` | Health check |
| \`WS  /ws\` | WebSocket live feed (3 s interval) |

## Run locally

\`\`\`bash
pip install -r requirements.txt
uvicorn main:app --reload
# open http://localhost:8000
\`\`\`
READMEEOF

success "All project files written."
echo ""

# ════════════════════════════════════════════════════════════════════
# GITHUB
# ════════════════════════════════════════════════════════════════════

info "Creating GitHub repository ($VISIBILITY)..."

GH_CREATE=$(curl -sf \
  -H "Authorization: token $GH_TOKEN" \
  -H "Content-Type: application/json" \
  -d "{\"name\":\"$REPO\",\"private\":$([ \"$VISIBILITY\" = \"private\" ] && echo true || echo false),\"auto_init\":false}" \
  https://api.github.com/user/repos)

GH_CLONE_URL=$(echo "$GH_CREATE" | python3 -c "import sys,json; print(json.load(sys.stdin)['clone_url'])" 2>/dev/null || echo "")

if [[ -z "$GH_CLONE_URL" ]]; then
  # repo may already exist — check
  GH_CLONE_URL="https://github.com/$GH_USER/$REPO.git"
  warn "Repo may already exist — continuing with $GH_CLONE_URL"
fi

success "GitHub repo: $GH_CLONE_URL"

# ── Git init & push ──────────────────────────────────────────────────
git init -q
git add .
git commit -q -m "feat: Ukubona Sovereign Engine v2.0.0 — initial deploy"
git remote add origin "https://${GH_TOKEN}@github.com/${GH_USER}/${REPO}.git"
git branch -M main
git push -u origin main --force -q

success "Code pushed to GitHub."
echo ""

# ════════════════════════════════════════════════════════════════════
# RENDER
# ════════════════════════════════════════════════════════════════════

info "Validating Render token..."
RENDER_USER=$(curl -sf \
  -H "Authorization: Bearer $RENDER_TOKEN" \
  https://api.render.com/v1/owners?limit=1 \
  | python3 -c "import sys,json; owners=json.load(sys.stdin); print(owners[0]['owner']['email'] if owners else '')" 2>/dev/null || echo "")

[[ -n "$RENDER_USER" ]] || die "Render token invalid or API unreachable."
success "Render authenticated: $RENDER_USER"

# Get owner id
RENDER_OWNER_ID=$(curl -sf \
  -H "Authorization: Bearer $RENDER_TOKEN" \
  https://api.render.com/v1/owners?limit=1 \
  | python3 -c "import sys,json; owners=json.load(sys.stdin); print(owners[0]['owner']['id'])" 2>/dev/null || echo "")

info "Creating Render web service..."

RENDER_PAYLOAD=$(python3 -c "
import json
payload = {
    'type': 'web_service',
    'name': '${REPO}',
    'ownerId': '${RENDER_OWNER_ID}',
    'repo': 'https://github.com/${GH_USER}/${REPO}',
    'branch': 'main',
    'runtime': 'python',
    'buildCommand': 'pip install -r requirements.txt',
    'startCommand': 'uvicorn main:app --host 0.0.0.0 --port \$PORT',
    'plan': 'free',
    'envVars': [
        {'key': 'PYTHON_VERSION', 'value': '3.11.0'}
    ],
    'autoDeploy': 'yes',
    'healthCheckPath': '/health'
}
print(json.dumps(payload))
")

RENDER_RESPONSE=$(curl -sf \
  -X POST \
  -H "Authorization: Bearer $RENDER_TOKEN" \
  -H "Content-Type: application/json" \
  -d "$RENDER_PAYLOAD" \
  https://api.render.com/v1/services 2>/dev/null || echo "{}")

SERVICE_ID=$(echo "$RENDER_RESPONSE" | python3 -c "
import sys, json
d = json.load(sys.stdin)
svc = d.get('service', d)
print(svc.get('id',''))
" 2>/dev/null || echo "")

SERVICE_URL=$(echo "$RENDER_RESPONSE" | python3 -c "
import sys, json
d = json.load(sys.stdin)
svc = d.get('service', d)
slug = svc.get('slug','')
name = svc.get('name','${REPO}')
url  = svc.get('serviceDetails',{}).get('url','')
if url:
    print(url)
elif slug:
    print(f'https://{slug}.onrender.com')
else:
    print(f'https://${REPO}.onrender.com')
" 2>/dev/null || echo "https://${REPO}.onrender.com")

echo ""
echo -e "${Y}╔══════════════════════════════════════════════════╗${NC}"
echo -e "${Y}║  DEPLOYMENT COMPLETE                             ║${NC}"
echo -e "${Y}╚══════════════════════════════════════════════════╝${NC}"
echo ""
echo -e "  ${G}GitHub  ${NC}→  https://github.com/${GH_USER}/${REPO}"
echo -e "  ${G}Render  ${NC}→  ${SERVICE_URL}"
if [[ -n "$SERVICE_ID" ]]; then
  echo -e "  ${G}Service ${NC}→  https://dashboard.render.com/web/${SERVICE_ID}"
fi
echo ""
echo -e "  ${Y}Note:${NC} Render free tier takes ~60 s for first deploy."
echo -e "  ${Y}Note:${NC} First cold start may take ~15 s (free tier spins down)."
echo -e "  ${Y}Note:${NC} Watch build logs at the dashboard URL above."
echo ""
success "Done. θ → L(θ) → ∇L → −η∇L → θ′"
echo ""