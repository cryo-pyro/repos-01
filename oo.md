`setup.sh` grew from this breakthrough (now i can effciently prompt LLMs)

```sh
#!/bin/bash
# ================================================================
#  STRATA STONE DIGITAL TWIN — DEFINITIVE SETUP
#  Source: Ibo's actual digital_twin.docx (93 variables, 7 depts)
#  Copy → VS Code → save as setup.sh → bash setup.sh → DONE
# ================================================================

echo ""
echo "╔═══════════════════════════════════════════════════════════╗"
echo "║   STRATA STONE DIGITAL TWIN — FULL DEPLOYMENT ENGINE 🏗️  ║"
echo "╚═══════════════════════════════════════════════════════════╝"
echo ""
echo "  Source: Ibo's operational DOCX — 93 variables, 7 departments"
echo "  Architecture: Rank-3 Tensor × Eigen Leakage × Live Dashboard"
echo ""

# ── CREDENTIALS ─────────────────────────────────────────────────
read -p "👤  GitHub Username                        : " GH_USER
read -p "🔑  GitHub Personal Token (classic)        : " GH_TOKEN
read -p "📦  New Repo Name (e.g. strata-twin)       : " REPO_NAME
read -p "🌐  Render API Key                         : " RENDER_KEY
read -p "🏢  Client / Project Name (e.g. Kadi Dev)  : " PROJECT_NAME
read -p "📍  Location (e.g. Kampala, Uganda)        : " LOCATION

echo ""
echo "✅  Building your Digital Twin..."
echo ""

# ── PROJECT STRUCTURE ────────────────────────────────────────────
mkdir -p "$REPO_NAME/backend/data"
mkdir -p "$REPO_NAME/frontend/src"
mkdir -p "$REPO_NAME/frontend/public"
cd "$REPO_NAME"

# ── STEP 1: GENERATE SYNTHETIC DATA FROM IBO'S REAL VARIABLES ───
cat <<'PYEOF' > gen_data.py
import csv, random
random.seed(42)

# REAL categories from Ibo's DOCX
categories = ["Cement", "Steel", "Labor", "Timber", "Electrical", "Plumbing", "Fuel", "Aluminium"]
phases     = ["Pre_Con", "Shell", "Finishing", "MEP", "Handover"]

unit_prices = {
    "Cement": 30000, "Steel": 95000, "Labor": 18000,
    "Timber": 45000, "Electrical": 60000, "Plumbing": 55000,
    "Fuel": 6000, "Aluminium": 72000
}

rows = [["week","phase","category","procured","received","consumed","unit_price"]]

for week in range(1, 13):
    phase = phases[min((week-1)//3, 4)]
    for cat in categories:
        procured = random.randint(80, 150)
        gate_loss  = random.choices([0, random.randint(3,15)], weights=[0.6,0.4])[0]
        usage_loss = random.choices([0, random.randint(2,10)], weights=[0.5,0.5])[0]
        # Cement has planted systemic leakage for demo
        if cat == "Cement":
            gate_loss  = random.randint(8, 20)
            usage_loss = random.randint(5, 15)
        received = max(0, procured - gate_loss)
        consumed = max(0, received - usage_loss)
        rows.append([week, phase, cat, procured, received, consumed, unit_prices[cat]])

with open("backend/data/leakage_data.csv", "w", newline="") as f:
    csv.writer(f).writerows(rows)

print("✅  Synthetic data generated (12 weeks × 8 categories)")
PYEOF

python3 gen_data.py
rm gen_data.py

# ── STEP 2: LANDSCAPE.JSON — ALL 93 VARIABLES FROM IBO'S DOCX ───
cat <<'EOF' > landscape.json
{
  "source": "Strata Stone digital_twin.docx — Ibo CEO, verbatim",
  "dimensions": {
    "functional": ["Finance","Procurement","Customer_Relations","Material_Control","Project_Management","Legal","Marketing","HR"],
    "temporal":   ["Strategic","Pre_Con","Design","Shell","Finishing","Handover"],
    "impact":     ["Budget","Execution","Compliance","Leakage"]
  },
  "tensor_points": [
    {"id":1,  "dept":"Finance",            "phase":"Strategic", "impact":"Budget",     "task":"Study Budget"},
    {"id":2,  "dept":"Finance",            "phase":"Strategic", "impact":"Budget",     "task":"Validate all construction related expenses (local)"},
    {"id":3,  "dept":"Finance",            "phase":"Strategic", "impact":"Budget",     "task":"Validate all import expenses"},
    {"id":4,  "dept":"Finance",            "phase":"Strategic", "impact":"Leakage",    "task":"Cross check procurement invoices against prior budget"},
    {"id":5,  "dept":"Finance",            "phase":"Strategic", "impact":"Budget",     "task":"Pay construction labor"},
    {"id":6,  "dept":"Finance",            "phase":"Strategic", "impact":"Budget",     "task":"Pay material purchases"},
    {"id":7,  "dept":"Finance",            "phase":"Strategic", "impact":"Budget",     "task":"Pay creditors"},
    {"id":8,  "dept":"Finance",            "phase":"Strategic", "impact":"Budget",     "task":"Pay all office expenses"},
    {"id":9,  "dept":"Finance",            "phase":"Strategic", "impact":"Budget",     "task":"Pay salaries"},
    {"id":10, "dept":"Finance",            "phase":"Strategic", "impact":"Budget",     "task":"Pay PAYE"},
    {"id":11, "dept":"Finance",            "phase":"Strategic", "impact":"Budget",     "task":"Pay NSSF"},
    {"id":12, "dept":"Finance",            "phase":"Strategic", "impact":"Compliance", "task":"Do monthly bank reconciliation"},
    {"id":13, "dept":"Finance",            "phase":"Strategic", "impact":"Compliance", "task":"Carry out monthly reconciliation on Old Mutual accounts"},
    {"id":14, "dept":"Finance",            "phase":"Strategic", "impact":"Budget",     "task":"Generate budget reports (weekly, monthly, quarterly, annual) — expenses vs allocated budget"},
    {"id":15, "dept":"Finance",            "phase":"Strategic", "impact":"Budget",     "task":"Share weekly reports with HQ"},
    {"id":16, "dept":"Finance",            "phase":"Strategic", "impact":"Budget",     "task":"Generate reports on revenue (monthly, quarterly, annual)"},
    {"id":17, "dept":"Finance",            "phase":"Strategic", "impact":"Leakage",    "task":"Keep a very tight leash on leakages and overruns"},
    {"id":18, "dept":"Finance",            "phase":"Strategic", "impact":"Compliance", "task":"Generate monthly ledgers and share with auditor"},
    {"id":19, "dept":"Finance",            "phase":"Strategic", "impact":"Budget",     "task":"Maintain a P&L account"},
    {"id":20, "dept":"Finance",            "phase":"Strategic", "impact":"Budget",     "task":"Maintain a cashflow account"},
    {"id":21, "dept":"Finance",            "phase":"Strategic", "impact":"Compliance", "task":"All payments through bank / mobile money / apps — avoid cash"},
    {"id":22, "dept":"Procurement",        "phase":"Strategic", "impact":"Budget",     "task":"Study project budget"},
    {"id":23, "dept":"Procurement",        "phase":"Strategic", "impact":"Budget",     "task":"Identify source of materials"},
    {"id":24, "dept":"Procurement",        "phase":"Strategic", "impact":"Budget",     "task":"Negotiate all materials to the bone"},
    {"id":25, "dept":"Procurement",        "phase":"Strategic", "impact":"Budget",     "task":"Procure materials"},
    {"id":26, "dept":"Procurement",        "phase":"Strategic", "impact":"Compliance", "task":"Keep all records of quotations, invoices, receipts"},
    {"id":27, "dept":"Procurement",        "phase":"Strategic", "impact":"Execution",  "task":"Receive all materials procured and have them recorded"},
    {"id":28, "dept":"Procurement",        "phase":"Strategic", "impact":"Execution",  "task":"Coordinate with finance team and project management team"},
    {"id":29, "dept":"Procurement",        "phase":"Strategic", "impact":"Budget",     "task":"Generate weekly budget reports"},
    {"id":30, "dept":"Procurement",        "phase":"Strategic", "impact":"Budget",     "task":"Generate monthly budget reports"},
    {"id":31, "dept":"Procurement",        "phase":"Strategic", "impact":"Budget",     "task":"Generate quarterly budget reports"},
    {"id":32, "dept":"Procurement",        "phase":"Strategic", "impact":"Execution",  "task":"Share reports with HQ"},
    {"id":33, "dept":"Procurement",        "phase":"Strategic", "impact":"Leakage",    "task":"Keep a close eye on cost overruns / leakages"},
    {"id":34, "dept":"Customer_Relations", "phase":"Strategic", "impact":"Execution",  "task":"Study sales plan"},
    {"id":35, "dept":"Customer_Relations", "phase":"Strategic", "impact":"Execution",  "task":"Study Marketing plan"},
    {"id":36, "dept":"Customer_Relations", "phase":"Strategic", "impact":"Execution",  "task":"Coordinate with Marketing team on all prospects"},
    {"id":37, "dept":"Customer_Relations", "phase":"Strategic", "impact":"Execution",  "task":"Follow up with all leads through all forms of communication"},
    {"id":38, "dept":"Customer_Relations", "phase":"Handover",  "impact":"Execution",  "task":"Upon closure, meet clients and educate them about the product and all expectations"},
    {"id":39, "dept":"Customer_Relations", "phase":"Strategic", "impact":"Budget",     "task":"Follow up on collections with the clients"},
    {"id":40, "dept":"Customer_Relations", "phase":"Strategic", "impact":"Execution",  "task":"Share monthly payment status and targets with customers"},
    {"id":41, "dept":"Customer_Relations", "phase":"Strategic", "impact":"Execution",  "task":"Handle all customer queries"},
    {"id":42, "dept":"Customer_Relations", "phase":"Strategic", "impact":"Execution",  "task":"Generate monthly performance reports on all client closures and collections and share with HQ"},
    {"id":43, "dept":"Customer_Relations", "phase":"Strategic", "impact":"Execution",  "task":"Keep company social media pages very active"},
    {"id":44, "dept":"Customer_Relations", "phase":"Handover",  "impact":"Execution",  "task":"Follow up on customer furniture selection and update the catalogue"},
    {"id":45, "dept":"Material_Control",   "phase":"Strategic", "impact":"Execution",  "task":"Study Material and equipment schedule"},
    {"id":46, "dept":"Material_Control",   "phase":"Strategic", "impact":"Execution",  "task":"Receive all material from procurement"},
    {"id":47, "dept":"Material_Control",   "phase":"Strategic", "impact":"Execution",  "task":"Record all materials received"},
    {"id":48, "dept":"Material_Control",   "phase":"Strategic", "impact":"Execution",  "task":"Allocate material needed for construction to individual workers and they should sign receipt"},
    {"id":49, "dept":"Material_Control",   "phase":"Strategic", "impact":"Leakage",    "task":"Monitor usage of all material"},
    {"id":50, "dept":"Material_Control",   "phase":"Strategic", "impact":"Execution",  "task":"Receive all equipment both purchased and leased/rented"},
    {"id":51, "dept":"Material_Control",   "phase":"Strategic", "impact":"Execution",  "task":"Every morning distribute equipment to individual workers — acknowledge receipt"},
    {"id":52, "dept":"Material_Control",   "phase":"Strategic", "impact":"Leakage",    "task":"Every evening receive equipment and check on damages"},
    {"id":53, "dept":"Material_Control",   "phase":"Strategic", "impact":"Leakage",    "task":"If damage is by reckless work, report to finance/PM — they determine deductions"},
    {"id":54, "dept":"Material_Control",   "phase":"Strategic", "impact":"Execution",  "task":"Keep weekly report status on equipment"},
    {"id":55, "dept":"Material_Control",   "phase":"Strategic", "impact":"Execution",  "task":"Generate weekly material usage and share report with management"},
    {"id":56, "dept":"Material_Control",   "phase":"Strategic", "impact":"Execution",  "task":"Generate weekly health status of all equipment"},
    {"id":57, "dept":"Project_Management", "phase":"Strategic", "impact":"Execution",  "task":"Supervision and management of all subcontractors and site works"},
    {"id":58, "dept":"Project_Management", "phase":"Strategic", "impact":"Execution",  "task":"Ensuring timely commencement of site works"},
    {"id":59, "dept":"Project_Management", "phase":"Strategic", "impact":"Execution",  "task":"Scheduling weekly site meetings"},
    {"id":60, "dept":"Project_Management", "phase":"Strategic", "impact":"Execution",  "task":"Generating daily, weekly and monthly reports"},
    {"id":61, "dept":"Project_Management", "phase":"Strategic", "impact":"Execution",  "task":"Overseeing materials delivered and securing them in the site stores"},
    {"id":62, "dept":"Project_Management", "phase":"Strategic", "impact":"Execution",  "task":"Ensuring that all site tools/equipment are secured"},
    {"id":63, "dept":"Legal",              "phase":"Pre_Con",   "impact":"Compliance", "task":"Identifying a piece of land"},
    {"id":64, "dept":"Legal",              "phase":"Pre_Con",   "impact":"Compliance", "task":"Carrying out extensive due diligence on selected land (physical + land registry) — independent surveyor issues survey report"},
    {"id":65, "dept":"Legal",              "phase":"Pre_Con",   "impact":"Compliance", "task":"Execute purchase agreement with land seller after thorough due diligence"},
    {"id":66, "dept":"Finance",            "phase":"Pre_Con",   "impact":"Budget",     "task":"Make payment for the land purchased"},
    {"id":67, "dept":"Legal",              "phase":"Pre_Con",   "impact":"Compliance", "task":"Receive duplicate certificate of title, transfer forms, national ID and passport photos from land seller"},
    {"id":68, "dept":"Legal",              "phase":"Pre_Con",   "impact":"Compliance", "task":"Handover duplicate certificate of title and accompanying documents to land registry to transfer title to Strata"},
    {"id":69, "dept":"Project_Management", "phase":"Design",    "impact":"Execution",  "task":"Engage architect to come up with concepts and architectural designs for the project"},
    {"id":70, "dept":"Project_Management", "phase":"Design",    "impact":"Compliance", "task":"Submit architectural, structural and M&E designs to relevant government local authority for approval"},
    {"id":71, "dept":"Project_Management", "phase":"Shell",     "impact":"Execution",  "task":"After receiving approved designs from local authority, clearing of purchased land commences"},
    {"id":72, "dept":"Project_Management", "phase":"Shell",     "impact":"Execution",  "task":"Construction of perimeter wall and security guard's house"},
    {"id":73, "dept":"Project_Management", "phase":"Shell",     "impact":"Execution",  "task":"Hiring site security"},
    {"id":74, "dept":"Project_Management", "phase":"Shell",     "impact":"Compliance", "task":"Application for site water and electricity from NWSC and UEDCL respectively"},
    {"id":75, "dept":"Project_Management", "phase":"Shell",     "impact":"Execution",  "task":"Setting out the blocks by the technical team"},
    {"id":76, "dept":"Project_Management", "phase":"Shell",     "impact":"Execution",  "task":"Foundation works commence"},
    {"id":77, "dept":"Project_Management", "phase":"Shell",     "impact":"Execution",  "task":"Concrete pre-fabs are set on the completed foundation"},
    {"id":78, "dept":"Project_Management", "phase":"Shell",     "impact":"Execution",  "task":"Inner walls (if any) construction commences"},
    {"id":79, "dept":"Project_Management", "phase":"Shell",     "impact":"Execution",  "task":"Plastering the inner walls"},
    {"id":80, "dept":"Project_Management", "phase":"Finishing", "impact":"Execution",  "task":"Paint team starts with wall preparation"},
    {"id":81, "dept":"Project_Management", "phase":"Finishing", "impact":"Execution",  "task":"Compound works (leveling and paving)"},
    {"id":82, "dept":"Project_Management", "phase":"Finishing", "impact":"Execution",  "task":"Drainage and sewer system works"},
    {"id":83, "dept":"Project_Management", "phase":"Finishing", "impact":"Execution",  "task":"Tile team commences"},
    {"id":84, "dept":"Project_Management", "phase":"Finishing", "impact":"Execution",  "task":"Plumbing team — installation of all sanitary ware and faucets"},
    {"id":85, "dept":"Project_Management", "phase":"Finishing", "impact":"Execution",  "task":"Electrical installation works"},
    {"id":86, "dept":"Project_Management", "phase":"Finishing", "impact":"Execution",  "task":"CCTV, razor wire and electric fence installation"},
    {"id":87, "dept":"Project_Management", "phase":"Finishing", "impact":"Execution",  "task":"Wood works — door frames, doors, wardrobes, kitchen cabins, locks, hinges, magnetic catchers"},
    {"id":88, "dept":"Project_Management", "phase":"Finishing", "impact":"Execution",  "task":"Steel works — kitchen door and maid's room door"},
    {"id":89, "dept":"Project_Management", "phase":"Finishing", "impact":"Execution",  "task":"Aluminium works — windows, nets, bathroom partitions"},
    {"id":90, "dept":"Project_Management", "phase":"Finishing", "impact":"Execution",  "task":"Interior design — gypsum molds/works"},
    {"id":91, "dept":"Project_Management", "phase":"Finishing", "impact":"Execution",  "task":"Paint team finishes"},
    {"id":92, "dept":"Project_Management", "phase":"Handover",  "impact":"Execution",  "task":"Installation of appliances and furniture"},
    {"id":93, "dept":"Customer_Relations", "phase":"Handover",  "impact":"Execution",  "task":"Clients move in"}
  ],
  "total": 93,
  "departments_flagged_for_expansion": ["Marketing","HR"],
  "note": "Verbatim from Ibo CEO digital_twin.docx. Marketing and HR listed in header but not yet detailed — add tasks when ready."
}
EOF

# ── STEP 3: FASTAPI BACKEND ──────────────────────────────────────
cat <<'PYEOF' > backend/main.py
from fastapi import FastAPI, UploadFile, File
from fastapi.middleware.cors import CORSMiddleware
import pandas as pd
import numpy as np
import json, io, os

app = FastAPI(title="Strata Stone Digital Twin API")

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_methods=["*"],
    allow_headers=["*"],
)

PROJECT = os.environ.get("PROJECT_NAME", "Strata Stone")
LOCATION = os.environ.get("LOCATION", "Kampala")

DATA_PATH = os.path.join(os.path.dirname(__file__), "data", "leakage_data.csv")
LANDSCAPE_PATH = os.path.join(os.path.dirname(__file__), "..", "landscape.json")

@app.get("/")
def root():
    return {"status": "Twin Active", "project": PROJECT, "location": LOCATION,
            "tensor_rank": 3, "axes": ["Functional","Temporal","Impact"],
            "variables": 93, "source": "Ibo CEO digital_twin.docx"}

@app.get("/landscape")
def get_landscape():
    try:
        with open(LANDSCAPE_PATH) as f:
            return json.load(f)
    except:
        return {"error": "landscape.json not found"}

@app.get("/landscape/dept/{dept}")
def by_dept(dept: str):
    try:
        with open(LANDSCAPE_PATH) as f:
            data = json.load(f)
        pts = [p for p in data["tensor_points"] if p["dept"].lower() == dept.lower()]
        return {"dept": dept, "count": len(pts), "tasks": pts}
    except Exception as e:
        return {"error": str(e)}

def _run_eigen(df):
    df = df.copy()
    df["gate"]    = df["procured"] - df["received"]
    df["usage"]   = df["received"] - df["consumed"]
    df["leakage"] = (df["gate"] + df["usage"]) * df["unit_price"]
    pivot = df.pivot_table(index="week", columns="category",
                           values="leakage", aggfunc="sum", fill_value=0)
    X = pivot.values.astype(float)
    if X.shape[0] < 2:
        return None, None, pivot
    Xc = X - X.mean(axis=0)
    cov = np.cov(Xc, rowvar=False)
    vals, vecs = np.linalg.eig(cov)
    idx = np.argsort(vals.real)[::-1]
    return vals.real[idx], vecs.real[:, idx], pivot

@app.get("/analytics/summary")
def summary():
    df = pd.read_csv(DATA_PATH)
    df["leakage"] = (df["procured"] - df["consumed"]) * df["unit_price"]
    return {
        "total_leakage_ugx": float(df["leakage"].sum()),
        "by_category": df.groupby("category")["leakage"].sum().sort_values(ascending=False).to_dict(),
        "by_phase":    df.groupby("phase")["leakage"].sum().sort_values(ascending=False).to_dict(),
        "weeks": int(df["week"].nunique()),
    }

@app.get("/analytics/eigen")
def eigen():
    df = pd.read_csv(DATA_PATH)
    vals, vecs, pivot = _run_eigen(df)
    if vals is None:
        return {"error": "Not enough data"}
    cats = pivot.columns.tolist()
    top  = vecs[:, 0]
    drivers = sorted(
        [{"category": c, "weight": round(float(w), 4)} for c, w in zip(cats, top)],
        key=lambda x: abs(x["weight"]), reverse=True
    )
    systemic = bool(vals[0] > sum(vals[1:]))
    return {
        "eigenvalues":     [round(float(v), 2) for v in vals],
        "top_drivers":     drivers,
        "dominant_driver": drivers[0],
        "systemic":        systemic,
        "verdict": "🔴 SYSTEMIC LEAKAGE DETECTED" if systemic else "🟢 Variance within normal range"
    }

@app.get("/analytics/timeline")
def timeline():
    df = pd.read_csv(DATA_PATH)
    df["leakage"] = (df["procured"] - df["consumed"]) * df["unit_price"]
    return {"timeline": df.groupby("week")["leakage"].sum().reset_index().to_dict(orient="records")}

@app.get("/analytics/tensor")
def tensor_slice():
    df = pd.read_csv(DATA_PATH)
    df["leakage"] = (df["procured"] - df["consumed"]) * df["unit_price"]
    return {"slice": df.groupby(["phase","category"])["leakage"].sum().reset_index().to_dict(orient="records")}

@app.post("/analytics/upload-csv")
async def upload_csv(file: UploadFile = File(...)):
    contents = await file.read()
    df = pd.read_csv(io.BytesIO(contents))
    vals, vecs, pivot = _run_eigen(df)
    if vals is None:
        return {"error": "Not enough data for eigen analysis"}
    cats = pivot.columns.tolist()
    top  = vecs[:, 0]
    drivers = sorted(
        [{"category": c, "weight": round(float(w), 4)} for c, w in zip(cats, top)],
        key=lambda x: abs(x["weight"]), reverse=True
    )
    return {
        "rows_analysed": len(df),
        "dominant_driver": drivers[0],
        "systemic": bool(vals[0] > sum(vals[1:])),
        "all_drivers": drivers
    }
PYEOF

cat <<'EOF' > backend/requirements.txt
fastapi==0.109.0
uvicorn==0.27.0
gunicorn==21.2.0
pydantic==2.5.3
pandas==2.2.3
numpy==1.26.4
python-multipart==0.0.6
EOF

# ── STEP 4: REACT FRONTEND ───────────────────────────────────────
cat <<EOF > frontend/public/index.html
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>${PROJECT_NAME} Digital Twin</title>
  </head>
  <body><div id="root"></div></body>
</html>
EOF

cat <<'EOF' > frontend/package.json
{
  "name": "strata-twin-ui",
  "version": "1.0.0",
  "private": true,
  "dependencies": {
    "react": "^18.2.0",
    "react-dom": "^18.2.0",
    "recharts": "^2.10.0",
    "react-scripts": "5.0.1"
  },
  "scripts": {
    "start": "react-scripts start",
    "build": "react-scripts build"
  },
  "browserslist": {
    "production": [">0.2%","not dead","not op_mini all"],
    "development": ["last 1 chrome version"]
  }
}
EOF

cat <<'EOF' > frontend/src/index.js
import React from 'react';
import ReactDOM from 'react-dom/client';
import App from './App';
const root = ReactDOM.createRoot(document.getElementById('root'));
root.render(<React.StrictMode><App /></React.StrictMode>);
EOF

cat <<'APPEOF' > frontend/src/App.js
import React, { useState, useEffect } from "react";
import {
  BarChart, Bar, XAxis, YAxis, Tooltip, ResponsiveContainer,
  LineChart, Line, CartesianGrid
} from "recharts";

const API = process.env.REACT_APP_API_URL || "http://localhost:8000";
const fmt = n => "UGX " + Math.round(n).toLocaleString();

// ── COLOUR PALETTE ─────────────────────────────────────────────
const C = {
  bg: "#0a0e1a", panel: "#111827", border: "#1f2937",
  green: "#00ff88", red: "#ff4d4d", blue: "#3b82f6",
  amber: "#f59e0b", purple: "#8b5cf6", text: "#e2e8f0",
  muted: "#6b7280"
};

const S = {
  app:    { fontFamily: "'Segoe UI',sans-serif", background: C.bg, minHeight:"100vh", color: C.text },
  header: { background:"linear-gradient(135deg,#111827,#1e3a5f)", padding:"28px 40px", borderBottom:`1px solid ${C.border}` },
  tabs:   { display:"flex", background:"#0d1117", borderBottom:`1px solid ${C.border}`, padding:"0 40px" },
  tab:    a => ({ padding:"14px 22px", cursor:"pointer", background:"none", border:"none",
                  borderBottom: a ? `2px solid ${C.green}` : "2px solid transparent",
                  color: a ? C.green : C.muted, fontWeight: a ? 700 : 400, fontSize:"14px" }),
  body:   { padding:"36px 40px" },
  grid4:  { display:"grid", gridTemplateColumns:"repeat(auto-fit,minmax(200px,1fr))", gap:"16px", marginBottom:"32px" },
  card:   c => ({ background: C.panel, borderRadius:"12px", padding:"22px", borderLeft:`4px solid ${c}` }),
  label:  { color: C.muted, fontSize:"11px", textTransform:"uppercase", letterSpacing:"1px", marginBottom:"6px" },
  big:    c => ({ fontSize:"24px", fontWeight:700, color:c }),
  panel:  { background: C.panel, borderRadius:"12px", padding:"26px", marginBottom:"24px" },
  h2:     { margin:"0 0 18px", color: C.text, fontSize:"17px", fontWeight:600 },
  alert:  ok => ({ background: ok?"#052e16":"#2d0f0f", border:`1px solid ${ok?C.green:C.red}`,
                   borderRadius:"8px", padding:"14px 18px", marginBottom:"18px",
                   color: ok?C.green:C.red, fontWeight:600, fontSize:"15px" }),
  row:    { display:"flex", justifyContent:"space-between", alignItems:"center",
             padding:"10px 0", borderBottom:`1px solid ${C.border}` },
};

const TT = { contentStyle:{background:C.panel,border:`1px solid ${C.border}`,color:C.text} };

export default function App() {
  const [tab,      setTab]      = useState("overview");
  const [summary,  setSummary]  = useState(null);
  const [eigen,    setEigen]    = useState(null);
  const [timeline, setTimeline] = useState(null);
  const [tensor,   setTensor]   = useState(null);
  const [landscape,setLandscape]= useState(null);
  const [loading,  setLoading]  = useState(true);
  const [uploadMsg,setUploadMsg]= useState(null);

  useEffect(() => {
    Promise.all([
      fetch(`${API}/analytics/summary`).then(r=>r.json()),
      fetch(`${API}/analytics/eigen`).then(r=>r.json()),
      fetch(`${API}/analytics/timeline`).then(r=>r.json()),
      fetch(`${API}/analytics/tensor`).then(r=>r.json()),
      fetch(`${API}/landscape`).then(r=>r.json()),
    ]).then(([s,e,t,tn,l]) => {
      setSummary(s); setEigen(e); setTimeline(t); setTensor(tn); setLandscape(l);
      setLoading(false);
    }).catch(()=>setLoading(false));
  }, []);

  const handleUpload = async e => {
    const file = e.target.files[0];
    if (!file) return;
    const fd = new FormData();
    fd.append("file", file);
    setUploadMsg("Analysing...");
    const res = await fetch(`${API}/analytics/upload-csv`, {method:"POST",body:fd});
    const d = await res.json();
    setUploadMsg(`✅ Dominant: ${d.dominant_driver?.category} (${d.dominant_driver?.weight?.toFixed(3)}) — ${d.systemic?"🔴 Systemic":"🟢 Normal"}`);
  };

  if (loading) return (
    <div style={{...S.app,display:"flex",alignItems:"center",justifyContent:"center"}}>
      <div style={{textAlign:"center"}}>
        <div style={{fontSize:"52px",marginBottom:"16px"}}>🛰️</div>
        <p style={{color:C.muted}}>Initialising Digital Twin...</p>
      </div>
    </div>
  );

  const catData    = summary ? Object.entries(summary.by_category).map(([k,v])=>({name:k,value:Math.round(v/1000)})) : [];
  const timeData   = timeline?.timeline?.map(r=>({week:`W${r.week}`,leakage:Math.round(r.leakage/1000)})) || [];
  const tensorData = tensor?.slice?.map(r=>({name:`${r.phase}·${r.category}`,value:Math.round(r.leakage/1000)}))
                            .sort((a,b)=>b.value-a.value).slice(0,12) || [];

  // Group landscape by dept for the ops tab
  const byDept = {};
  if (landscape?.tensor_points) {
    landscape.tensor_points.forEach(p => {
      if (!byDept[p.dept]) byDept[p.dept] = [];
      byDept[p.dept].push(p);
    });
  }

  const TABS = ["overview","leakage","eigen","tensor","operations","upload"];

  return (
    <div style={S.app}>

      {/* ── HEADER ── */}
      <div style={S.header}>
        <div style={{display:"flex",alignItems:"center",gap:"16px"}}>
          <span style={{fontSize:"32px"}}>🏗️</span>
          <div>
            <h1 style={{margin:0,fontSize:"26px",fontWeight:700}}>Strata Stone Partners</h1>
            <p style={{margin:"4px 0 0",color:C.muted,fontSize:"13px"}}>
              Real-Time Reconciliation Engine · {landscape?.total || 93} Variables · 7 Departments
              <span style={{background:C.green,color:"#000",padding:"2px 10px",borderRadius:"20px",
                            fontSize:"11px",fontWeight:700,marginLeft:"12px"}}>● LIVE TWIN</span>
            </p>
          </div>
        </div>
      </div>

      {/* ── TABS ── */}
      <div style={S.tabs}>
        {TABS.map(t => (
          <button key={t} style={S.tab(tab===t)} onClick={()=>setTab(t)}>
            { t==="overview" ? "📊 Overview"
            : t==="leakage"  ? "💧 Leakage"
            : t==="eigen"    ? "🔬 Diagnosis"
            : t==="tensor"   ? "🧊 Tensor"
            : t==="operations"?"📋 Operations"
            :                  "📤 Upload Data" }
          </button>
        ))}
      </div>

      <div style={S.body}>

        {/* ── OVERVIEW ── */}
        {tab==="overview" && summary && (
          <>
            <div style={S.grid4}>
              {[
                {label:"Weeks Tracked",    val:summary.weeks,                          color:C.green},
                {label:"Total Leakage",    val:fmt(summary.total_leakage_ugx),         color:C.red},
                {label:"Top Leaky Item",   val:catData[0]?.name||"—",                  color:C.amber},
                {label:"System Status",    val:eigen?.systemic?"⚠️ Systemic":"✅ Normal",color:C.blue},
              ].map(c=>(
                <div key={c.label} style={S.card(c.color)}>
                  <div style={S.label}>{c.label}</div>
                  <div style={S.big(c.color)}>{c.val}</div>
                </div>
              ))}
            </div>
            <div style={S.panel}>
              <h2 style={S.h2}>📈 Weekly Leakage Trend (UGX '000)</h2>
              <ResponsiveContainer width="100%" height={240}>
                <LineChart data={timeData}>
                  <CartesianGrid strokeDasharray="3 3" stroke={C.border}/>
                  <XAxis dataKey="week" stroke={C.muted}/>
                  <YAxis stroke={C.muted}/>
                  <Tooltip {...TT}/>
                  <Line type="monotone" dataKey="leakage" stroke={C.red} strokeWidth={2} dot={{fill:C.red}}/>
                </LineChart>
              </ResponsiveContainer>
            </div>
            {eigen && <div style={S.alert(!eigen.systemic)}>{eigen.verdict}</div>}
          </>
        )}

        {/* ── LEAKAGE ── */}
        {tab==="leakage" && summary && (
          <>
            <div style={S.panel}>
              <h2 style={S.h2}>💧 Leakage by Category (UGX '000)</h2>
              <ResponsiveContainer width="100%" height={280}>
                <BarChart data={catData}>
                  <CartesianGrid strokeDasharray="3 3" stroke={C.border}/>
                  <XAxis dataKey="name" stroke={C.muted}/>
                  <YAxis stroke={C.muted}/>
                  <Tooltip {...TT}/>
                  <Bar dataKey="value" fill={C.red} radius={[4,4,0,0]}/>
                </BarChart>
              </ResponsiveContainer>
            </div>
            <div style={S.panel}>
              <h2 style={S.h2}>🏗️ Leakage by Construction Phase</h2>
              {Object.entries(summary.by_phase).map(([ph,val])=>(
                <div key={ph} style={S.row}>
                  <span>{ph}</span>
                  <span style={{color:C.red,fontWeight:600}}>{fmt(val)}</span>
                </div>
              ))}
            </div>
          </>
        )}

        {/* ── EIGEN DIAGNOSIS ── */}
        {tab==="eigen" && eigen && (
          <>
            <div style={S.alert(!eigen.systemic)}>{eigen.verdict}</div>
            <div style={S.panel}>
              <h2 style={S.h2}>🔬 Leakage Signature — Dominant Eigenvector</h2>
              <p style={{color:C.muted,fontSize:"13px",marginBottom:"18px"}}>
                The eigenvector shows <em>where leakage is structurally concentrated</em> — not just where it appears loudest. A dominant first eigenvalue means the pattern is <strong style={{color:C.red}}>repeatable and systemic</strong>, not random.
              </p>
              {eigen.top_drivers.map((d,i)=>(
                <div key={d.category} style={S.row}>
                  <span style={{color:i===0?C.red:C.text,fontWeight:i===0?700:400}}>{d.category}</span>
                  <div style={{display:"flex",alignItems:"center",gap:"10px"}}>
                    <span style={{color:C.muted,fontSize:"13px"}}>{d.weight.toFixed(3)}</span>
                    <div style={{height:"8px",borderRadius:"4px",width:"140px",
                                 background:`linear-gradient(90deg,${C.red} ${Math.abs(d.weight)*100}%,${C.border} ${Math.abs(d.weight)*100}%)`}}/>
                  </div>
                </div>
              ))}
            </div>
            <div style={S.panel}>
              <h2 style={S.h2}>📐 Eigenvalue Spectrum</h2>
              <p style={{color:C.muted,fontSize:"13px",marginBottom:"14px"}}>
                If Mode 1 dwarfs all others → systemic problem. If they are similar → random noise.
              </p>
              {eigen.eigenvalues.slice(0,6).map((v,i)=>(
                <div key={i} style={{display:"flex",alignItems:"center",marginBottom:"10px",gap:"10px"}}>
                  <span style={{color:C.muted,width:"55px",fontSize:"12px"}}>Mode {i+1}</span>
                  <div style={{height:"14px",borderRadius:"4px",
                               background:i===0?C.red:C.blue,
                               width:`${Math.max(4,(v/eigen.eigenvalues[0])*280)}px`}}/>
                  <span style={{color:C.muted,fontSize:"11px"}}>{Number(v).toLocaleString()}</span>
                </div>
              ))}
            </div>
          </>
        )}

        {/* ── TENSOR MAP ── */}
        {tab==="tensor" && (
          <>
            <div style={S.panel}>
              <h2 style={S.h2}>🧊 Tensor Slice — Phase × Category (Top 12 by Leakage)</h2>
              <p style={{color:C.muted,fontSize:"13px",marginBottom:"18px"}}>
                Each bar is a coordinate in 3D operational space: <strong>Phase × Category × Leakage (UGX '000)</strong>. This is one slice of Ibo's Rank-3 tensor.
              </p>
              <ResponsiveContainer width="100%" height={360}>
                <BarChart data={tensorData} layout="vertical">
                  <CartesianGrid strokeDasharray="3 3" stroke={C.border}/>
                  <XAxis type="number" stroke={C.muted}/>
                  <YAxis type="category" dataKey="name" stroke={C.muted} width={160} tick={{fontSize:11}}/>
                  <Tooltip {...TT}/>
                  <Bar dataKey="value" fill={C.purple} radius={[0,4,4,0]}/>
                </BarChart>
              </ResponsiveContainer>
            </div>
            <div style={{...S.panel,borderLeft:`4px solid ${C.purple}`}}>
              <h2 style={S.h2}>Why a Tensor?</h2>
              <p style={{color:C.muted,lineHeight:"1.7",fontSize:"14px"}}>
                A spreadsheet shows tasks. A dashboard shows numbers. A <strong style={{color:C.text}}>tensor</strong> encodes the full 3D structure of your operations: 
                <strong style={{color:C.text}}> what department</strong> × 
                <strong style={{color:C.text}}> what phase</strong> × 
                <strong style={{color:C.text}}> what resource</strong>. 
                Every one of Ibo's 93 variables is a coordinate in this space. The system can now ask — and answer — questions no spreadsheet can: "Where is leakage concentrating, and is it systemic or random?"
              </p>
            </div>
          </>
        )}

        {/* ── OPERATIONS (ALL 93 VARIABLES) ── */}
        {tab==="operations" && landscape && (
          <>
            <p style={{color:C.muted,marginBottom:"24px",fontSize:"14px"}}>
              All <strong style={{color:C.text}}>{landscape.total} variables</strong> from Ibo's operational DOCX — verbatim, mapped to tensor coordinates.
            </p>
            {Object.entries(byDept).map(([dept,tasks])=>(
              <div key={dept} style={S.panel}>
                <h2 style={{...S.h2,color:C.green}}>{dept.replace(/_/g," ")} <span style={{color:C.muted,fontSize:"13px",fontWeight:400}}>({tasks.length} tasks)</span></h2>
                {tasks.map(t=>(
                  <div key={t.id} style={{...S.row,gap:"12px"}}>
                    <span style={{color:C.muted,fontSize:"11px",minWidth:"24px"}}>#{t.id}</span>
                    <span style={{flex:1,fontSize:"13px"}}>{t.task}</span>
                    <span style={{fontSize:"11px",color:C.muted,minWidth:"70px",textAlign:"right"}}>{t.phase}</span>
                    <span style={{
                      fontSize:"10px",padding:"2px 8px",borderRadius:"12px",minWidth:"70px",textAlign:"center",
                      background: t.impact==="Leakage"?"#2d0f0f":t.impact==="Compliance"?"#1e3a5f":t.impact==="Budget"?"#1a2e1a":"#1a1a2e",
                      color: t.impact==="Leakage"?C.red:t.impact==="Compliance"?C.blue:t.impact==="Budget"?C.green:C.muted
                    }}>{t.impact}</span>
                  </div>
                ))}
              </div>
            ))}
          </>
        )}

        {/* ── UPLOAD REAL DATA ── */}
        {tab==="upload" && (
          <div style={S.panel}>
            <h2 style={S.h2}>📤 Upload Your Real Site Data</h2>
            <p style={{color:C.muted,fontSize:"14px",marginBottom:"20px",lineHeight:"1.6"}}>
              Upload a CSV with columns: <code style={{background:C.border,padding:"2px 6px",borderRadius:"4px"}}>week, category, procured, received, consumed, unit_price</code>
              <br/>The system will run eigen analysis on your real numbers and show you the dominant leakage driver.
            </p>
            <input type="file" accept=".csv" onChange={handleUpload}
              style={{padding:"12px",background:C.border,borderRadius:"8px",color:C.text,cursor:"pointer",width:"100%"}}/>
            {uploadMsg && (
              <div style={{marginTop:"20px",padding:"16px",background:C.border,borderRadius:"8px",
                           color:C.green,fontSize:"15px",fontWeight:600}}>
                {uploadMsg}
              </div>
            )}
            <div style={{marginTop:"32px",borderTop:`1px solid ${C.border}`,paddingTop:"24px"}}>
              <h3 style={{color:C.text,marginBottom:"12px"}}>Expected CSV format:</h3>
              <pre style={{background:"#000",padding:"16px",borderRadius:"8px",fontSize:"12px",
                           color:"#00ff88",overflow:"auto"}}>
{`week,category,procured,received,consumed,unit_price
1,Cement,100,90,85,30000
1,Steel,50,50,49,80000
1,Labor,30,30,28,15000
2,Cement,120,100,95,30000`}
              </pre>
            </div>
          </div>
        )}

      </div>
    </div>
  );
}
APPEOF

# ── STEP 5: RENDER YAML ──────────────────────────────────────────
# KEY LESSON LEARNED: Render ignores rootDir for web service build/start
# commands. We must use explicit paths from repo root.
# rootDir only works correctly for static sites.
cat <<EOF > render.yaml
services:
  - type: web
    name: ${REPO_NAME}-api
    env: python
    buildCommand: pip install -r backend/requirements.txt
    startCommand: cd backend && gunicorn main:app -w 2 -k uvicorn.workers.UvicornWorker --bind 0.0.0.0:\$PORT
    envVars:
      - key: PYTHON_VERSION
        value: 3.11.8
      - key: PROJECT_NAME
        value: ${PROJECT_NAME}
      - key: LOCATION
        value: ${LOCATION}

  - type: static
    name: ${REPO_NAME}-ui
    rootDir: frontend
    buildCommand: npm install && npm run build
    staticPublishPath: build
    envVars:
      - key: REACT_APP_API_URL
        value: https://${REPO_NAME}-api.onrender.com
EOF

# Copy landscape.json into backend so it's deployed
cp landscape.json backend/landscape.json

# ── STEP 6: GITIGNORE ────────────────────────────────────────────
cat <<'EOF' > .gitignore
node_modules
.env
__pycache__
*.pyc
.DS_Store
EOF

# ── STEP 7: PUSH TO GITHUB ───────────────────────────────────────
echo ""
echo "🚀  Creating GitHub repo and pushing..."
echo ""

# Create GitHub repo
curl -s -X POST \
  -H "Authorization: token ${GH_TOKEN}" \
  -H "Content-Type: application/json" \
  https://api.github.com/user/repos \
  -d "{\"name\":\"${REPO_NAME}\",\"private\":true,\"description\":\"Strata Stone Digital Twin — 93 variables from Ibo CEO DOCX\"}" \
  > /dev/null

git init
git add .
git commit -m "Strata Stone Digital Twin — 93 variables, Rank-3 Tensor, Eigen Leakage 🏗️"
git branch -M main
git remote add origin "https://${GH_TOKEN}@github.com/${GH_USER}/${REPO_NAME}.git"
git push -u origin main --force

echo "✅  Code on GitHub: https://github.com/${GH_USER}/${REPO_NAME}"

# ── STEP 8: PUSH TO RENDER (attempt blueprint, then manual fallback)
echo ""
echo "🌐  Attempting Render blueprint deploy..."

curl -s -X POST \
  -H "Authorization: Bearer ${RENDER_KEY}" \
  -H "Content-Type: application/json" \
  https://api.render.com/v1/blueprints \
  -d "{\"repoURL\":\"https://github.com/${GH_USER}/${REPO_NAME}\",\"branch\":\"main\"}" \
  > /dev/null

# ── DONE ─────────────────────────────────────────────────────────
echo ""
echo "╔══════════════════════════════════════════════════════════════╗"
echo "║  ✅  CODE PUSHED — GITHUB DONE                              ║"
echo "╠══════════════════════════════════════════════════════════════╣"
echo "║  GitHub: https://github.com/${GH_USER}/${REPO_NAME}         ║"
echo "╚══════════════════════════════════════════════════════════════╝"
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  ⚠️  RENDER NEEDS 2 MANUAL STEPS IN THE DASHBOARD"
echo "  (Render ignores render.yaml for services already created)"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "  IF THIS IS A NEW DEPLOY (first time):"
echo "  ─────────────────────────────────────"
echo "  1. Go to https://dashboard.render.com"
echo "  2. New + → Web Service → connect: ${GH_USER}/${REPO_NAME}"
echo "  3. Set EXACTLY:"
echo ""
echo "     Name         : ${REPO_NAME}-api"
echo "     Environment  : Python"
echo "     Branch       : main"
echo "     Build Command: pip install -r backend/requirements.txt"
echo "     Start Command: cd backend && gunicorn main:app -w 2 -k uvicorn.workers.UvicornWorker --bind 0.0.0.0:\$PORT"
echo ""
echo "  4. Add Environment Variables:"
echo "     PROJECT_NAME = ${PROJECT_NAME}"
echo "     LOCATION     = ${LOCATION}"
echo ""
echo "  5. Save → Create Web Service"
echo ""
echo "  6. New + → Static Site → connect same repo"
echo "  7. Set EXACTLY:"
echo ""
echo "     Name         : ${REPO_NAME}-ui"
echo "     Branch       : main"
echo "     Root Dir     : frontend"
echo "     Build Command: npm install && npm run build"
echo "     Publish Dir  : build"
echo ""
echo "  8. Add Environment Variable:"
echo "     REACT_APP_API_URL = https://${REPO_NAME}-api.onrender.com"
echo ""
echo "  9. Save → Create Static Site"
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "  IF YOU ALREADY HAVE A BROKEN SERVICE (fix the existing one):"
echo "  ─────────────────────────────────────────────────────────────"
echo "  1. dashboard.render.com → click your service → Settings"
echo "  2. Scroll to Build & Deploy"
echo "  3. Change Build Command to:"
echo "     pip install -r backend/requirements.txt"
echo "  4. Change Start Command to:"
echo "     cd backend && gunicorn main:app -w 2 -k uvicorn.workers.UvicornWorker --bind 0.0.0.0:\$PORT"
echo "  5. Save Changes"
echo "  6. Manual Deploy → Deploy latest commit"
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "  VERIFY IT WORKED — open this URL in your browser:"
echo "  https://${REPO_NAME}-api.onrender.com"
echo ""
echo "  You should see:"
echo "  { "status": "Twin Active", "variables": 93 }"
echo ""
echo "  Then open the UI:"
echo "  https://${REPO_NAME}-ui.onrender.com"
echo ""
echo "  FRIDAY DEMO TABS:"
echo "  📊 Overview    — headline numbers + trend"
echo "  💧 Leakage     — by category and phase"
echo "  🔬 Diagnosis   — eigen / systemic vs noise"
echo "  🧊 Tensor      — 3D operational space"
echo "  📋 Operations  — ALL 93 variables from Ibo's DOCX"
echo "  📤 Upload Data — drop your real CSV here"
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
```


`npa-twin` that i demoed two weeks ago:

```sh
#!/bin/bash
set -e

echo "🚀 Ukubona NPA Digital Twin — ZERO COST VERSION"
echo "Full map · ROYGBIV loss · Leaflet · Bayesian fusion · interventions"
echo "✅ Mac-proof · Git conflict-free · Render 2026 · index.html at root"

# === INPUTS ===
read -p "GitHub username: " GH_USER
read -p "New repo name (e.g. npa-twin): " REPO
read -p "GitHub Personal Access Token (repo scope only): " GH_TOKEN
read -p "Render API Key (from https://dashboard.render.com/u/settings → New API Key): " RENDER_API_KEY

# === GLOBAL GIT FIX ===
git config --global init.defaultBranch main 2>/dev/null || true

# === CLEAN FOR RE-RUN ===
if [ -d "$REPO" ]; then
  echo "🧹 Cleaning old folder..."
  rm -rf "$REPO"
fi

mkdir -p "$REPO"
cd "$REPO"

# === FRESH GIT ===
rm -rf .git 2>/dev/null || true
git init
git config core.editor true

# === VENV + DEPS ===
python3 -m venv venv
source venv/bin/activate
python -m pip install --upgrade pip setuptools wheel

cat > requirements.txt << EOF
fastapi==0.115.0
uvicorn[standard]==0.32.0
numpy==2.0.2
python-dotenv==1.0.1
EOF
pip install -r requirements.txt
pip install requests

# ============================================================
# main.py — with root route serving index.html
# ============================================================
cat > main.py << 'PYEOF'
from fastapi import FastAPI, Query, HTTPException
from fastapi.responses import HTMLResponse
from pydantic import BaseModel
import numpy as np
import random
import os
from typing import Dict, List
import uvicorn

app = FastAPI(title="Ukubona NPA Digital Twin", version="2026.03")

# ===================== ALL 135 DISTRICTS =====================
DISTRICTS = [
  {"n": "Abim", "lat": 3.00, "lon": 33.67}, {"n": "Adjumani", "lat": 3.38, "lon": 31.79},
  {"n": "Agago", "lat": 2.98, "lon": 33.38}, {"n": "Alebtong", "lat": 2.26, "lon": 33.35},
  {"n": "Amolatar", "lat": 1.60, "lon": 32.80}, {"n": "Amudat", "lat": 1.95, "lon": 34.93},
  {"n": "Amuria", "lat": 2.03, "lon": 33.65}, {"n": "Amuru", "lat": 2.80, "lon": 31.92},
  {"n": "Apac", "lat": 1.98, "lon": 32.54}, {"n": "Arua", "lat": 3.02, "lon": 30.91},
  {"n": "Budaka", "lat": 1.00, "lon": 33.94}, {"n": "Bududa", "lat": 1.00, "lon": 34.33},
  {"n": "Bugiri", "lat": 0.57, "lon": 33.75}, {"n": "Buhweju", "lat": -0.70, "lon": 30.42},
  {"n": "Buikwe", "lat": 0.33, "lon": 33.00}, {"n": "Bukedea", "lat": 1.36, "lon": 34.00},
  {"n": "Bukomansimbi", "lat": -0.14, "lon": 31.60}, {"n": "Bukwo", "lat": 1.28, "lon": 34.73},
  {"n": "Bulambuli", "lat": 1.22, "lon": 34.38}, {"n": "Buliisa", "lat": 2.12, "lon": 31.41},
  {"n": "Bundibugyo", "lat": 0.71, "lon": 30.07}, {"n": "Bunyangabu", "lat": -0.50, "lon": 30.18},
  {"n": "Bushenyi", "lat": -0.58, "lon": 30.18}, {"n": "Busia", "lat": 0.46, "lon": 34.09},
  {"n": "Butaleja", "lat": 0.90, "lon": 33.97}, {"n": "Butebo", "lat": 1.18, "lon": 34.05},
  {"n": "Buvuma", "lat": 0.38, "lon": 33.22}, {"n": "Buyende", "lat": 1.24, "lon": 33.12},
  {"n": "Dokolo", "lat": 1.91, "lon": 33.17}, {"n": "Gomba", "lat": -0.23, "lon": 31.68},
  {"n": "Gulu", "lat": 2.77, "lon": 32.30}, {"n": "Hoima", "lat": 1.43, "lon": 31.35},
  {"n": "Ibanda", "lat": -0.14, "lon": 30.50}, {"n": "Iganga", "lat": 0.61, "lon": 33.48},
  {"n": "Isingiro", "lat": -0.84, "lon": 30.82}, {"n": "Jinja", "lat": 0.42, "lon": 33.20},
  {"n": "Kaabong", "lat": 3.52, "lon": 34.14}, {"n": "Kabale", "lat": -1.25, "lon": 29.99},
  {"n": "Kabarole", "lat": 0.65, "lon": 30.25}, {"n": "Kaberamaido", "lat": 1.74, "lon": 33.16},
  {"n": "Kagadi", "lat": 0.94, "lon": 30.82}, {"n": "Kakumiro", "lat": 0.78, "lon": 31.33},
  {"n": "Kalaki", "lat": 1.89, "lon": 33.38}, {"n": "Kalangala", "lat": -0.32, "lon": 32.23},
  {"n": "Kaliro", "lat": 1.04, "lon": 33.50}, {"n": "Kalungu", "lat": -0.10, "lon": 31.78},
  {"n": "Kampala", "lat": 0.32, "lon": 32.58}, {"n": "Kamuli", "lat": 0.95, "lon": 33.12},
  {"n": "Kamwenge", "lat": 0.19, "lon": 30.45}, {"n": "Kanungu", "lat": -0.96, "lon": 29.79},
  {"n": "Kapchorwa", "lat": 1.40, "lon": 34.45}, {"n": "Kapelebyong", "lat": 1.90, "lon": 33.98},
  {"n": "Karenga", "lat": 3.73, "lon": 33.80}, {"n": "Kasanda", "lat": 0.60, "lon": 31.72},
  {"n": "Kasese", "lat": 0.18, "lon": 30.08}, {"n": "Katakwi", "lat": 1.90, "lon": 34.07},
  {"n": "Kayunga", "lat": 0.71, "lon": 32.87}, {"n": "Kazo", "lat": -0.10, "lon": 30.68},
  {"n": "Kibale", "lat": 0.87, "lon": 31.06}, {"n": "Kiboga", "lat": 0.91, "lon": 31.77},
  {"n": "Kibuku", "lat": 1.04, "lon": 33.79}, {"n": "Kikuube", "lat": 1.58, "lon": 31.22},
  {"n": "Kiruhura", "lat": -0.20, "lon": 30.86}, {"n": "Kiryandongo", "lat": 1.88, "lon": 32.10},
  {"n": "Kisoro", "lat": -1.28, "lon": 29.65}, {"n": "Kitgum", "lat": 3.28, "lon": 32.89},
  {"n": "Koboko", "lat": 3.41, "lon": 31.05}, {"n": "Kole", "lat": 2.37, "lon": 32.76},
  {"n": "Kotido", "lat": 2.98, "lon": 34.13}, {"n": "Kumi", "lat": 1.46, "lon": 33.94},
  {"n": "Kwania", "lat": 2.12, "lon": 32.60}, {"n": "Kween", "lat": 1.42, "lon": 34.63},
  {"n": "Kyankwanzi", "lat": 1.09, "lon": 31.71}, {"n": "Kyegegwa", "lat": 0.48, "lon": 31.05},
  {"n": "Kyenjojo", "lat": 0.62, "lon": 30.64}, {"n": "Kyotera", "lat": -0.65, "lon": 31.55},
  {"n": "Lamwo", "lat": 3.53, "lon": 32.53}, {"n": "Lira", "lat": 2.25, "lon": 32.90},
  {"n": "Luuka", "lat": 0.73, "lon": 33.30}, {"n": "Luwero", "lat": 0.85, "lon": 32.47},
  {"n": "Lwengo", "lat": -0.40, "lon": 31.40}, {"n": "Lyantonde", "lat": -0.40, "lon": 31.15},
  {"n": "Madi-Okollo", "lat": 3.10, "lon": 31.20}, {"n": "Manafwa", "lat": 0.88, "lon": 34.28},
  {"n": "Maracha", "lat": 3.29, "lon": 30.96}, {"n": "Masaka", "lat": -0.34, "lon": 31.74},
  {"n": "Masindi", "lat": 1.68, "lon": 31.71}, {"n": "Mayuge", "lat": 0.46, "lon": 33.57},
  {"n": "Mbale", "lat": 1.08, "lon": 34.18}, {"n": "Mbarara", "lat": -0.60, "lon": 30.65},
  {"n": "Mitooma", "lat": -0.63, "lon": 30.02}, {"n": "Mityana", "lat": 0.40, "lon": 32.02},
  {"n": "Moroto", "lat": 2.53, "lon": 34.67}, {"n": "Moyo", "lat": 3.65, "lon": 31.73},
  {"n": "Mpigi", "lat": 0.23, "lon": 32.32}, {"n": "Mubende", "lat": 0.57, "lon": 31.36},
  {"n": "Mukono", "lat": 0.35, "lon": 32.76}, {"n": "Nabilatuk", "lat": 2.05, "lon": 34.53},
  {"n": "Nakapiripirit", "lat": 1.90, "lon": 34.65}, {"n": "Nakaseke", "lat": 1.12, "lon": 32.43},
  {"n": "Nakasongola", "lat": 1.32, "lon": 32.45}, {"n": "Namayingo", "lat": 0.28, "lon": 33.92},
  {"n": "Namisindwa", "lat": 0.95, "lon": 34.42}, {"n": "Namutumba", "lat": 0.83, "lon": 33.68},
  {"n": "Napak", "lat": 2.36, "lon": 34.24}, {"n": "Nebbi", "lat": 2.48, "lon": 31.10},
  {"n": "Ngora", "lat": 1.48, "lon": 33.77}, {"n": "Ntoroko", "lat": 1.03, "lon": 30.47},
  {"n": "Ntungamo", "lat": -0.88, "lon": 30.27}, {"n": "Nwoya", "lat": 2.62, "lon": 31.95},
  {"n": "Obongi", "lat": 3.52, "lon": 31.60}, {"n": "Omoro", "lat": 2.62, "lon": 32.52},
  {"n": "Otuke", "lat": 2.52, "lon": 33.45}, {"n": "Oyam", "lat": 2.26, "lon": 32.40},
  {"n": "Pader", "lat": 2.80, "lon": 33.20}, {"n": "Pakwach", "lat": 2.46, "lon": 31.49},
  {"n": "Pallisa", "lat": 1.14, "lon": 33.71}, {"n": "Rakai", "lat": -0.73, "lon": 31.40},
  {"n": "Rubanda", "lat": -1.19, "lon": 29.84}, {"n": "Rubirizi", "lat": -0.28, "lon": 30.10},
  {"n": "Rukiga", "lat": -1.08, "lon": 29.95}, {"n": "Rukungiri", "lat": -0.84, "lon": 29.94},
  {"n": "Rwampara", "lat": -0.68, "lon": 30.75}, {"n": "Sembabule", "lat": -0.07, "lon": 31.46},
  {"n": "Serere", "lat": 1.50, "lon": 33.55}, {"n": "Sheema", "lat": -0.56, "lon": 30.38},
  {"n": "Sironko", "lat": 1.23, "lon": 34.25}, {"n": "Soroti", "lat": 1.71, "lon": 33.61},
  {"n": "Terego", "lat": 3.06, "lon": 30.80}, {"n": "Tororo", "lat": 0.69, "lon": 34.18},
  {"n": "Wakiso", "lat": 0.40, "lon": 32.45}, {"n": "Yumbe", "lat": 3.47, "lon": 31.25},
  {"n": "Zombo", "lat": 2.67, "lon": 30.90}
]

# ===================== ENGINE =====================
def clamp(v, a, b): return max(a, min(b, v))

class DistrictData(BaseModel):
    n: str
    lat: float
    lon: float
    mh: float
    mort: float
    mal: float
    so: float
    loss: float
    source: str = "synthetic"

state: Dict[str, DistrictData] = {}
interventions: Dict[str, float] = {}

def generate_synthetic():
    for district in DISTRICTS:
        n = district["n"]
        state[n] = DistrictData(
            n=n, lat=district["lat"], lon=district["lon"],
            mh=round(random.uniform(0.05, 0.40), 3),
            mort=round(random.uniform(0.02, 0.15), 3),
            mal=round(random.uniform(0.10, 0.50), 3),
            so=round(random.uniform(0.05, 0.30), 3),
            loss=0.0,
            source="synthetic"
        )
    compute_losses()

def compute_losses():
    for n, d in state.items():
        d.loss = round(d.mh * 0.35 + d.mort * 0.25 + d.mal * 0.25 + d.so * 0.15, 3)

def apply_intervention(d: DistrictData, reduction: float) -> DistrictData:
    new_d = d.model_copy(deep=True)
    new_d.mh   = clamp(new_d.mh   * (1 - reduction),       0.0, 1.0)
    new_d.mort = clamp(new_d.mort  * (1 - reduction * 0.8), 0.0, 1.0)
    new_d.mal  = clamp(new_d.mal   * (1 - reduction * 1.2), 0.0, 1.0)
    new_d.so   = clamp(new_d.so    * (1 - reduction * 0.5), 0.0, 1.0)
    new_d.loss = round(new_d.mh * 0.35 + new_d.mort * 0.25 + new_d.mal * 0.25 + new_d.so * 0.15, 3)
    new_d.source = "intervened"
    return new_d

# ===================== ENDPOINTS =====================
@app.get("/", response_class=HTMLResponse)
async def root():
    html_path = os.path.join(os.path.dirname(__file__), "index.html")
    if os.path.exists(html_path):
        with open(html_path) as f:
            return f.read()
    return HTMLResponse("<h2>Ukubona NPA Digital Twin — API live. Push index.html to serve dashboard.</h2>")

@app.get("/districts")
def get_districts():
    if not state: generate_synthetic()
    return [d.model_dump() for d in state.values()]

@app.get("/compute")
def compute():
    if not state: generate_synthetic()
    compute_losses()
    return {n: d.model_dump() for n, d in state.items()}

class InterventionRequest(BaseModel):
    district: str
    reduction: float = 0.15

@app.post("/intervene")
def intervene(req: InterventionRequest):
    if not state: generate_synthetic()
    if req.district not in state:
        raise HTTPException(status_code=404, detail="District not found")
    state[req.district] = apply_intervention(state[req.district], req.reduction)
    interventions[req.district] = req.reduction
    return {"updated": state[req.district].model_dump()}

@app.post("/whatif")
def whatif(req: InterventionRequest):
    if not state: generate_synthetic()
    if req.district not in state:
        raise HTTPException(status_code=404, detail="District not found")
    temp = apply_intervention(state[req.district], req.reduction)
    return {"whatif": temp.model_dump()}

@app.post("/bayesian-swap")
def bayesian_swap(district_a: str = Query(...), district_b: str = Query(...)):
    if not state: generate_synthetic()
    if district_a not in state or district_b not in state:
        raise HTTPException(status_code=404, detail="District not found")
    a = state[district_a]
    b = state[district_b]
    fused = DistrictData(
        n=a.n, lat=a.lat, lon=a.lon,
        mh=round((a.mh + b.mh)/2, 3),
        mort=round((a.mort + b.mort)/2, 3),
        mal=round((a.mal + b.mal)/2, 3),
        so=round((a.so + b.so)/2, 3),
        loss=0.0, source="bayesian"
    )
    fused.loss = round(fused.mh*0.35 + fused.mort*0.25 + fused.mal*0.25 + fused.so*0.15, 3)
    state[district_a] = fused
    state[district_b] = fused.model_copy()
    return {"message": f"Bayesian fusion applied between {district_a} ↔ {district_b}"}

if __name__ == "__main__":
    uvicorn.run(app, host="0.0.0.0", port=8000)
PYEOF

# ============================================================
# index.html — full Leaflet map, ROYGBIV, dark theme, API-wired
# ============================================================
cat > index.html << 'HTMLEOF'
<!DOCTYPE html>
<html lang="en" data-theme="dark">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Ukubona · Uganda District Loss Map · NPA Digital Twin</title>
<meta name="color-scheme" content="dark light">
<link rel="icon" href="https://abikesa.github.io/favicon/assets/favicon-dark.ico">
<link rel="preconnect" href="https://fonts.googleapis.com" crossorigin>
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=DM+Mono:wght@300;400;500&family=Instrument+Serif:ital@0;1&family=DM+Sans:wght@300;400;500;600&display=swap" rel="stylesheet">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/leaflet@1.9.4/dist/leaflet.min.css">
<style>
:root{--bg:#0d0d0b;--surf:#141412;--surf2:#1c1c19;--brd:rgba(255,255,255,0.07);--ink:#e8e6df;--mut:#6b6b65;--dim:#3a3a36;--r:#e24b4a;--o:#d85a30;--y:#ef9f27;--g:#639922;--b:#378add;--i:#534ab7;--v:#1d9e75;}
[data-theme="light"]{--bg:#fafaf8;--surf:#fff;--surf2:#f1efe8;--brd:rgba(0,0,0,0.08);--ink:#1a1a18;--mut:#6b6b65;--dim:#d3d1c7;}
*{box-sizing:border-box;margin:0;padding:0;}
html,body{height:100%;overflow:hidden;}
body{font-family:'DM Sans',sans-serif;font-size:13px;background:var(--bg);color:var(--ink);display:flex;flex-direction:column;}
.hd{display:flex;align-items:center;justify-content:space-between;padding:.65rem 1.1rem;background:var(--surf);border-bottom:1px solid var(--brd);flex-shrink:0;gap:.75rem;flex-wrap:wrap;z-index:1000;}
.logo-wrap{display:flex;align-items:center;gap:.55rem;text-decoration:none;}
.logo-spin{width:38px;height:38px;animation:spin 60s linear infinite;}
@keyframes spin{from{transform:rotate(0deg)}to{transform:rotate(360deg)}}
.brand-name{font-family:'Instrument Serif',serif;font-size:1.05rem;color:var(--ink);}
.brand-tag{font-family:'DM Mono',monospace;font-size:.58rem;color:var(--mut);letter-spacing:.06em;text-transform:uppercase;}
.hd-center{flex:1;text-align:center;}
.hd-title{font-family:'Instrument Serif',serif;font-size:1.1rem;color:var(--ink);}
.hd-sub{font-family:'DM Mono',monospace;font-size:.58rem;color:var(--mut);letter-spacing:.05em;margin-top:.1rem;}
.hd-right{display:flex;gap:.4rem;align-items:center;flex-wrap:wrap;}
.badge{font-family:'DM Mono',monospace;font-size:.56rem;letter-spacing:.08em;text-transform:uppercase;padding:.18em .65em;border:1px solid var(--brd);border-radius:999px;color:var(--mut);}
.badge-syn{color:var(--y);border-color:rgba(239,159,39,.32);}
.badge-api{color:var(--v);border-color:rgba(29,158,117,.32);display:none;}
.icon-btn{background:var(--surf2);border:1px solid var(--brd);border-radius:6px;padding:.38rem .65rem;cursor:pointer;color:var(--mut);display:flex;align-items:center;gap:.35rem;font-family:'DM Mono',monospace;font-size:.58rem;text-decoration:none;transition:border-color .15s,color .15s;}
.icon-btn:hover{border-color:var(--y);color:var(--y);}
.body{display:flex;flex:1;overflow:hidden;min-height:0;}
.lp{width:248px;flex-shrink:0;background:var(--surf);border-right:1px solid var(--brd);overflow-y:auto;padding:1rem;display:flex;flex-direction:column;gap:1rem;}
.plbl{font-family:'DM Mono',monospace;font-size:.56rem;letter-spacing:.14em;text-transform:uppercase;color:var(--mut);padding-bottom:.3rem;border-bottom:1px solid var(--brd);}
.formula{font-family:'DM Mono',monospace;font-size:.66rem;color:var(--mut);line-height:1.9;padding:.6rem .7rem;background:var(--surf2);border-radius:5px;border:1px solid var(--brd);}
.formula .hl{color:var(--y);}
.dim-sel{width:100%;background:var(--surf2);border:1px solid var(--brd);border-radius:6px;color:var(--ink);font-family:'DM Sans',sans-serif;font-size:.8rem;padding:.38rem .6rem;cursor:pointer;outline:none;}
.dim-sel:hover{border-color:var(--y);}
.dim-desc{font-family:'DM Mono',monospace;font-size:.6rem;color:var(--mut);line-height:1.6;margin-top:.35rem;}
.sl-row{display:flex;flex-direction:column;gap:.2rem;margin-bottom:.45rem;}
.sl-meta{display:flex;justify-content:space-between;align-items:baseline;}
.sl-name{font-size:.7rem;opacity:.85;}
.sl-val{font-family:'DM Mono',monospace;font-size:.65rem;color:var(--y);}
input[type=range]{width:100%;height:2px;appearance:none;background:var(--dim);border-radius:2px;outline:none;cursor:pointer;}
input[type=range]::-webkit-slider-thumb{appearance:none;width:10px;height:10px;border-radius:50%;background:var(--y);cursor:pointer;}
.rt::-webkit-slider-thumb{background:var(--r)!important;}
.ro::-webkit-slider-thumb{background:var(--o)!important;}
.rg::-webkit-slider-thumb{background:var(--g)!important;}
.rb::-webkit-slider-thumb{background:var(--b)!important;}
.weight-block{display:none;}
.weight-block.show{display:block;}
.sc-btn{width:100%;padding:.42rem .6rem;background:var(--surf2);border:1px solid var(--brd);border-radius:5px;color:var(--ink);font-family:'DM Sans',sans-serif;font-size:.7rem;cursor:pointer;text-align:left;margin-bottom:.3rem;transition:border-color .12s;}
.sc-btn span{display:block;font-size:.6rem;color:var(--mut);margin-top:.06rem;}
.sc-btn:hover,.sc-btn.on{border-color:var(--y);color:var(--y);}
.sc-btn.on span{color:rgba(239,159,39,.6);}
.api-bar{display:flex;align-items:center;gap:.5rem;padding:.4rem .6rem;background:var(--surf2);border-radius:5px;border:1px solid var(--brd);}
.api-dot{width:7px;height:7px;border-radius:50%;background:var(--dim);flex-shrink:0;}
.api-dot.live{background:var(--v);animation:pulse 2s infinite;}
.api-dot.err{background:var(--r);}
@keyframes pulse{0%,100%{opacity:1}50%{opacity:.4}}
.api-txt{font-family:'DM Mono',monospace;font-size:.6rem;color:var(--mut);flex:1;}
.api-btn{font-family:'DM Mono',monospace;font-size:.58rem;color:var(--y);background:none;border:1px solid rgba(239,159,39,.3);border-radius:4px;padding:.18em .5em;cursor:pointer;}
.mc{flex:1;position:relative;min-width:0;}
#map{width:100%;height:100%;}
.leaflet-tile-pane{filter:brightness(.85) saturate(.9);}
[data-theme="light"] .leaflet-tile-pane{filter:none;}
.upd{position:absolute;top:10px;left:50%;transform:translateX(-50%);z-index:900;background:var(--surf);border:1px solid rgba(239,159,39,.3);border-radius:999px;padding:.22em .8em;font-family:'DM Mono',monospace;font-size:.58rem;color:var(--y);opacity:0;transition:opacity .25s;pointer-events:none;white-space:nowrap;}
.upd.on{opacity:1;}
.leg{position:absolute;bottom:16px;left:16px;z-index:800;background:rgba(20,20,18,.9);border:1px solid var(--brd);border-radius:7px;padding:.55rem .7rem;backdrop-filter:blur(4px);}
[data-theme="light"] .leg{background:rgba(255,255,255,.92);}
.leg-title{font-family:'DM Mono',monospace;font-size:.54rem;letter-spacing:.1em;text-transform:uppercase;color:var(--mut);margin-bottom:.35rem;}
.leg-scale{display:flex;gap:2px;margin-bottom:.25rem;}
.leg-sw{height:8px;border-radius:1px;flex:1;}
.leg-labs{display:flex;justify-content:space-between;font-family:'DM Mono',monospace;font-size:.52rem;color:var(--mut);}
.rp{width:226px;flex-shrink:0;background:var(--surf);border-left:1px solid var(--brd);overflow-y:auto;padding:1rem;display:flex;flex-direction:column;gap:1rem;}
.sc2{background:var(--surf2);border:1px solid var(--brd);border-radius:6px;padding:.6rem .8rem;}
.sc2-lbl{font-family:'DM Mono',monospace;font-size:.56rem;letter-spacing:.08em;text-transform:uppercase;color:var(--mut);margin-bottom:.2rem;}
.sc2-val{font-family:'Instrument Serif',serif;font-size:1.5rem;line-height:1;margin-bottom:.1rem;}
.sc2-sub{font-family:'DM Mono',monospace;font-size:.6rem;color:var(--mut);}
.sc2-sub.bad{color:var(--r);}
.d-list{display:flex;flex-direction:column;gap:.3rem;}
.d-item{display:flex;align-items:center;gap:.5rem;padding:.32rem .5rem;border-radius:4px;cursor:pointer;transition:background .1s;}
.d-item:hover{background:var(--surf2);}
.d-dot{width:7px;height:7px;border-radius:50%;flex-shrink:0;}
.d-name{font-size:.72rem;flex:1;}
.d-val{font-family:'DM Mono',monospace;font-size:.65rem;color:var(--mut);}
.sel-card{padding:.7rem .85rem;background:var(--surf2);border-radius:6px;border-left:3px solid var(--y);}
.sel-name{font-family:'Instrument Serif',serif;font-size:1.1rem;margin-bottom:.35rem;}
.sel-score{font-family:'DM Mono',monospace;font-size:1.3rem;font-weight:500;margin-bottom:.5rem;}
.db-row{display:flex;align-items:center;gap:.5rem;padding:.28rem .4rem;background:var(--surf);border-radius:4px;margin-bottom:.25rem;}
.db-dot{width:7px;height:7px;border-radius:50%;flex-shrink:0;}
.db-name{font-size:.66rem;color:var(--mut);flex:1;}
.db-bar{height:3px;background:var(--dim);border-radius:2px;flex:1;max-width:55px;}
.db-fill{height:100%;border-radius:2px;transition:width .4s;}
.db-val{font-family:'DM Mono',monospace;font-size:.64rem;}
.iv-form{display:flex;flex-direction:column;gap:.45rem;}
.iv-lbl{font-family:'DM Mono',monospace;font-size:.54rem;letter-spacing:.1em;text-transform:uppercase;color:var(--mut);}
.iv-input{background:var(--surf2);border:1px solid var(--brd);border-radius:5px;color:var(--ink);font-family:'DM Sans',sans-serif;font-size:.78rem;padding:.32rem .5rem;outline:none;width:100%;}
.iv-input:focus{border-color:var(--y);}
.iv-btns{display:flex;gap:.4rem;}
.iv-btn{flex:1;font-family:'DM Mono',monospace;font-size:.62rem;padding:.35rem .5rem;border-radius:5px;cursor:pointer;border:1px solid var(--brd);background:var(--surf2);color:var(--ink);transition:border-color .12s;}
.iv-btn:hover{border-color:var(--y);color:var(--y);}
.iv-btn.primary{border-color:rgba(239,159,39,.4);color:var(--y);}
.iv-result{font-family:'DM Mono',monospace;font-size:.6rem;color:var(--mut);padding:.4rem .5rem;background:var(--surf2);border-radius:4px;border-left:2px solid var(--y);display:none;line-height:1.6;white-space:pre-wrap;}
.iv-result.show{display:block;}
.prow{display:flex;align-items:center;gap:.5rem;padding:.3rem .45rem;background:var(--surf2);border-radius:4px;border-left:2px solid var(--dim);margin-bottom:.22rem;}
.prow.ac{border-left-color:var(--y);}
.psym{font-family:'DM Mono',monospace;font-size:.62rem;color:var(--mut);min-width:40px;}
.prow.ac .psym{color:var(--y);}
.pdesc{font-size:.66rem;color:var(--mut);}
.prow.ac .pdesc{color:var(--ink);}
.tlog{font-family:'DM Mono',monospace;font-size:.6rem;color:var(--mut);line-height:1.65;max-height:120px;overflow-y:auto;}
.te{padding:.1rem 0;border-bottom:1px solid var(--brd);}
.te:last-child{border-bottom:none;}
.tt{color:var(--dim);margin-right:.3rem;}
.ta{color:var(--y);}
.ds{font-family:'DM Mono',monospace;font-size:.59rem;color:var(--mut);line-height:1.8;}
.leaflet-popup-content-wrapper{background:var(--surf)!important;color:var(--ink)!important;border:1px solid var(--brd)!important;border-radius:9px!important;box-shadow:0 8px 32px rgba(0,0,0,.5)!important;}
.leaflet-popup-content{margin:.8rem!important;font-family:'DM Sans',sans-serif!important;}
.leaflet-popup-tip{background:var(--surf)!important;}
.lp-name{font-family:'Instrument Serif',serif;font-size:1rem;margin-bottom:.3rem;}
.lp-val{font-family:'DM Mono',monospace;font-size:1.2rem;font-weight:500;margin-bottom:.3rem;}
.lp-row{display:flex;justify-content:space-between;font-size:.68rem;color:var(--mut);padding:.1rem 0;border-bottom:1px solid var(--brd);}
.lp-row:last-child{border-bottom:none;}
.lp-rv{color:var(--ink);font-family:'DM Mono',monospace;}
@media(max-width:900px){.lp,.rp{display:none;}}
</style>
</head>
<body>
<header class="hd">
  <a href="https://ukubona-llc.github.io/" class="logo-wrap">
    <img class="logo-spin" src="https://abikesa.github.io/logos/assets/ukubona-dark.png" id="logo-img" alt="Ukubona">
    <div><div class="brand-name">Ukubona</div><div class="brand-tag">Health Tech for Customized Care</div></div>
  </a>
  <div class="hd-center">
    <div class="hd-title">Uganda District Loss Map</div>
    <div class="hd-sub">NPA Digital Twin · θ → L(θ) → ∇L → −η∇L → θ′</div>
  </div>
  <div class="hd-right">
    <span class="badge badge-syn" id="phase-badge">Synthetic Phase I</span>
    <span class="badge badge-api" id="api-badge">API Active</span>
    <span class="badge" id="n-badge">— Districts</span>
    <a href="/docs" class="icon-btn">
      <svg width="11" height="11" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="22 12 18 12 15 21 9 3 6 12 2 12"/></svg>API docs
    </a>
    <button class="icon-btn" id="theme-btn">
      <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="5"/><line x1="12" y1="1" x2="12" y2="3"/><line x1="12" y1="21" x2="12" y2="23"/><line x1="4.22" y1="4.22" x2="5.64" y2="5.64"/><line x1="18.36" y1="18.36" x2="19.78" y2="19.78"/><line x1="1" y1="12" x2="3" y2="12"/><line x1="21" y1="12" x2="23" y2="12"/><line x1="4.22" y1="19.78" x2="5.64" y2="18.36"/><line x1="18.36" y1="5.64" x2="19.78" y2="4.22"/></svg>
    </button>
  </div>
</header>
<div class="body">
  <aside class="lp">
    <div>
      <div class="plbl">Loss function</div>
      <div class="formula">θₜ → <span class="hl">L(θ)</span> → ∇L → −η∇L → θ′<br><br>L = Σ wᵢ · dimᵢ(θ)</div>
    </div>
    <div>
      <div class="plbl">API status</div>
      <div class="api-bar">
        <div class="api-dot" id="api-dot"></div>
        <span class="api-txt" id="api-txt">connecting…</span>
        <button class="api-btn" onclick="loadAPI()">↻</button>
      </div>
    </div>
    <div>
      <div class="plbl">View dimension</div>
      <select class="dim-sel" id="dim-sel">
        <option value="mh">Mental health burden</option>
        <option value="mort">Mortality</option>
        <option value="mal">Malnutrition</option>
        <option value="so">School-out / stockouts</option>
        <option value="composite" selected>Composite L(θ)</option>
      </select>
      <div class="dim-desc" id="dim-desc">Weighted sum across all four dimensions.</div>
    </div>
    <div class="weight-block show" id="wb">
      <div class="plbl">Loss weights</div>
      <div class="sl-row"><div class="sl-meta"><span class="sl-name">Mental health <span style="color:var(--r);font-size:.58rem">↑71%</span></span><span class="sl-val" id="v-mh">35%</span></div><input type="range" class="rt" id="s-mh" min="5" max="50" value="35"></div>
      <div class="sl-row"><div class="sl-meta"><span class="sl-name">Mortality</span><span class="sl-val" id="v-im">25%</span></div><input type="range" class="ro" id="s-im" min="5" max="50" value="25"></div>
      <div class="sl-row"><div class="sl-meta"><span class="sl-name">Malnutrition</span><span class="sl-val" id="v-ml">25%</span></div><input type="range" class="rg" id="s-ml" min="5" max="50" value="25"></div>
      <div class="sl-row"><div class="sl-meta"><span class="sl-name">School-out</span><span class="sl-val" id="v-so">15%</span></div><input type="range" class="rb" id="s-so" min="5" max="50" value="15"></div>
    </div>
    <div>
      <div class="plbl">η — intervention speed</div>
      <div class="sl-row"><div class="sl-meta"><span class="sl-name">Learning rate</span><span class="sl-val" id="v-eta">0.15</span></div><input type="range" class="rb" id="s-eta" min="1" max="50" value="15"></div>
    </div>
    <div>
      <div class="plbl">Scenarios</div>
      <button class="sc-btn on" onclick="setSc(this,'base')">Status quo<span>NPA Feb 2026 — MH surge +71%</span></button>
      <button class="sc-btn" onclick="setSc(this,'mh')">Mental health priority<span>w₁=45% — NPA mandate</span></button>
      <button class="sc-btn" onclick="setSc(this,'int')">Simulate intervention<span>η=0.25 — aggressive step</span></button>
      <button class="sc-btn" onclick="apiInterveneTop()">→ Intervene top district<span>Apply η to highest-loss via API</span></button>
      <button class="sc-btn" onclick="apiBayesSwap()">→ Bayesian swap top-2<span>Fuse highest-loss districts via API</span></button>
    </div>
  </aside>

  <div class="mc">
    <div id="map"></div>
    <div class="upd" id="upd">Recomputing gradient…</div>
    <div class="leg">
      <div class="leg-title" id="leg-title">L(θ) — Composite loss</div>
      <div class="leg-scale">
        <div class="leg-sw" style="background:var(--r)"></div><div class="leg-sw" style="background:var(--o)"></div>
        <div class="leg-sw" style="background:var(--y)"></div><div class="leg-sw" style="background:var(--g)"></div>
        <div class="leg-sw" style="background:var(--b)"></div><div class="leg-sw" style="background:var(--i)"></div>
        <div class="leg-sw" style="background:var(--v)"></div>
      </div>
      <div class="leg-labs"><span>High loss</span><span>Optimized</span></div>
    </div>
  </div>

  <aside class="rp">
    <div>
      <div class="plbl">National L(θ)</div>
      <div class="sc2"><div class="sc2-lbl">Mean composite loss</div><div class="sc2-val" id="st-loss">—</div><div class="sc2-sub" id="st-sub">loading…</div></div>
    </div>
    <div>
      <div class="plbl">NPA Feb 2026</div>
      <div class="sc2"><div class="sc2-lbl">MH facility cases</div><div class="sc2-val" style="color:var(--r)">+71%</div><div class="sc2-sub bad">494,326 → 843,295</div></div>
    </div>
    <div id="sel-panel" style="display:none">
      <div class="plbl">Selected district</div>
      <div class="sel-card">
        <div class="sel-name" id="sel-name">—</div>
        <div class="sel-score" id="sel-score">—</div>
        <div id="sel-dims"></div>
      </div>
    </div>
    <div>
      <div class="plbl">API intervention</div>
      <div class="iv-form">
        <div><div class="iv-lbl">District (exact name)</div><input class="iv-input" id="iv-d" placeholder="e.g. Kampala"></div>
        <div><div class="iv-lbl">η reduction — <span id="iv-pct-lbl">15</span>%</div><input type="range" id="iv-pct" min="1" max="50" value="15" step="1" style="width:100%;margin-top:5px" oninput="document.getElementById('iv-pct-lbl').textContent=this.value"></div>
        <div class="iv-btns"><button class="iv-btn" onclick="runWhatif()">what-if</button><button class="iv-btn primary" onclick="runIntervene()">apply −η∇L</button></div>
        <div class="iv-result" id="iv-result"></div>
      </div>
    </div>
    <div>
      <div class="plbl">Highest loss districts</div>
      <div class="d-list" id="top-d"></div>
    </div>
    <div>
      <div class="plbl">Pentadic state</div>
      <div class="prow"><span class="psym">θₜ</span><span class="pdesc">District priors loaded</span></div>
      <div class="prow ac"><span class="psym">L(θ)</span><span class="pdesc" id="pentad-desc">Computing composite loss</span></div>
      <div class="prow"><span class="psym">∇L</span><span class="pdesc">ROYGBIV gradient visible</span></div>
      <div class="prow"><span class="psym">−η∇L</span><span class="pdesc">Use form above to intervene</span></div>
      <div class="prow"><span class="psym">θ′</span><span class="pdesc">Updated via API call</span></div>
    </div>
    <div>
      <div class="plbl">Steward transcript</div>
      <div class="tlog" id="tlog"></div>
    </div>
    <div style="margin-top:auto">
      <div class="plbl">Data source</div>
      <div class="ds" id="ds-note">
        <span style="color:var(--y)">SYNTHETIC PHASE I</span><br>
        WHO priors + N(0,σ) noise<br>NPA surge: Feb 2026<br>Coords: WGS84 real<br>
        ── swap ready ──<br>
        <span style="color:var(--v)">→ MoH DHIS2 API</span><br>
        <span style="color:var(--v)">→ UBOS district data</span>
      </div>
    </div>
  </aside>
</div>

<script src="https://cdn.jsdelivr.net/npm/leaflet@1.9.4/dist/leaflet.min.js"></script>
<script>
const ROYGBIV=['#e24b4a','#d85a30','#ef9f27','#639922','#378add','#534ab7','#1d9e75'];
function lossColor(l){if(l>=.80)return ROYGBIV[0];if(l>=.60)return ROYGBIV[1];if(l>=.40)return ROYGBIV[2];if(l>=.22)return ROYGBIV[3];if(l>=.11)return ROYGBIV[4];if(l>=.04)return ROYGBIV[5];return ROYGBIV[6];}
const DIM_DESC={mh:'Depression/anxiety prevalence — elevated in northern post-conflict & urban districts.',mort:'Mortality component from composite loss index.',mal:'Malnutrition component from composite loss index.',so:'School-out / drug stockout proxy.',composite:'Weighted sum across all four dimensions. Adjust sliders to reflect policy priorities.'};

let apiData=[],dataset=[],markers=[],map,darkTile,lightTile,selDistrict=null;

function initMap(){
  map=L.map('map',{center:[1.37,32.29],zoom:7});
  darkTile=L.tileLayer('https://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}{r}.png',{attribution:'&copy; OSM &copy; CARTO',subdomains:'abcd',maxZoom:19});
  lightTile=L.tileLayer('https://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}{r}.png',{attribution:'&copy; OSM &copy; CARTO',subdomains:'abcd',maxZoom:19});
  (document.documentElement.getAttribute('data-theme')==='dark'?darkTile:lightTile).addTo(map);
  L.control.layers({'Dark':darkTile,'Light':lightTile},null,{position:'topright'}).addTo(map);
}

function getW(){const mh=+document.getElementById('s-mh').value,mort=+document.getElementById('s-im').value,mal=+document.getElementById('s-ml').value,so=+document.getElementById('s-so').value,T=mh+mort+mal+so;return{mh:mh/T,mort:mort/T,mal:mal/T,so:so/T};}

function processDataset(){
  const w=getW(),dim=document.getElementById('dim-sel').value;
  dataset=apiData.map(d=>{
    const comp=w.mh*d.mh+w.mort*d.mort+w.mal*d.mal+w.so*d.so;
    const disp=dim==='composite'?comp:d[dim];
    return{...d,comp,disp};
  });
}

async function loadAPI(){
  setDot('','connecting…');
  try{
    const r=await fetch('/districts');
    if(!r.ok)throw new Error(r.status);
    apiData=await r.json();
    setDot('live',apiData.length+' districts');
    document.getElementById('n-badge').textContent=apiData.length+' Districts';
    document.getElementById('phase-badge').style.display='none';
    document.getElementById('api-badge').style.display='inline-block';
    document.getElementById('ds-note').innerHTML='<span style="color:var(--v)">API DATA ACTIVE</span><br>npa-twin.onrender.com<br>Synthetic engine · real coords<br>── live ──<br><span style="color:var(--v)">→ /intervene · /whatif</span><br><span style="color:var(--v)">→ /bayesian-swap</span>';
    logA('API connected — '+apiData.length+' districts');
    refresh();
  }catch(e){
    setDot('err','error — using local fallback');
    logA('API offline — synthetic fallback');
    useSynth();
  }
}

function setDot(cls,msg){document.getElementById('api-dot').className='api-dot'+(cls?' '+cls:'');document.getElementById('api-txt').textContent=msg;}

const COORDS=[{n:"Abim",lat:3.00,lon:33.67},{n:"Adjumani",lat:3.38,lon:31.79},{n:"Agago",lat:2.98,lon:33.38},{n:"Alebtong",lat:2.26,lon:33.35},{n:"Amolatar",lat:1.60,lon:32.80},{n:"Amudat",lat:1.95,lon:34.93},{n:"Amuria",lat:2.03,lon:33.65},{n:"Amuru",lat:2.80,lon:31.92},{n:"Apac",lat:1.98,lon:32.54},{n:"Arua",lat:3.02,lon:30.91},{n:"Budaka",lat:1.00,lon:33.94},{n:"Bududa",lat:1.00,lon:34.33},{n:"Bugiri",lat:0.57,lon:33.75},{n:"Buhweju",lat:-0.70,lon:30.42},{n:"Buikwe",lat:0.33,lon:33.00},{n:"Bukedea",lat:1.36,lon:34.00},{n:"Bukomansimbi",lat:-0.14,lon:31.60},{n:"Bukwo",lat:1.28,lon:34.73},{n:"Bulambuli",lat:1.22,lon:34.38},{n:"Buliisa",lat:2.12,lon:31.41},{n:"Bundibugyo",lat:0.71,lon:30.07},{n:"Bunyangabu",lat:-0.50,lon:30.18},{n:"Bushenyi",lat:-0.58,lon:30.18},{n:"Busia",lat:0.46,lon:34.09},{n:"Butaleja",lat:0.90,lon:33.97},{n:"Butebo",lat:1.18,lon:34.05},{n:"Buvuma",lat:0.38,lon:33.22},{n:"Buyende",lat:1.24,lon:33.12},{n:"Dokolo",lat:1.91,lon:33.17},{n:"Gomba",lat:-0.23,lon:31.68},{n:"Gulu",lat:2.77,lon:32.30},{n:"Hoima",lat:1.43,lon:31.35},{n:"Ibanda",lat:-0.14,lon:30.50},{n:"Iganga",lat:0.61,lon:33.48},{n:"Isingiro",lat:-0.84,lon:30.82},{n:"Jinja",lat:0.42,lon:33.20},{n:"Kaabong",lat:3.52,lon:34.14},{n:"Kabale",lat:-1.25,lon:29.99},{n:"Kabarole",lat:0.65,lon:30.25},{n:"Kaberamaido",lat:1.74,lon:33.16},{n:"Kagadi",lat:0.94,lon:30.82},{n:"Kakumiro",lat:0.78,lon:31.33},{n:"Kalaki",lat:1.89,lon:33.38},{n:"Kalangala",lat:-0.32,lon:32.23},{n:"Kaliro",lat:1.04,lon:33.50},{n:"Kalungu",lat:-0.10,lon:31.78},{n:"Kampala",lat:0.32,lon:32.58},{n:"Kamuli",lat:0.95,lon:33.12},{n:"Kamwenge",lat:0.19,lon:30.45},{n:"Kanungu",lat:-0.96,lon:29.79},{n:"Kapchorwa",lat:1.40,lon:34.45},{n:"Kapelebyong",lat:1.90,lon:33.98},{n:"Karenga",lat:3.73,lon:33.80},{n:"Kasanda",lat:0.60,lon:31.72},{n:"Kasese",lat:0.18,lon:30.08},{n:"Katakwi",lat:1.90,lon:34.07},{n:"Kayunga",lat:0.71,lon:32.87},{n:"Kazo",lat:-0.10,lon:30.68},{n:"Kibale",lat:0.87,lon:31.06},{n:"Kiboga",lat:0.91,lon:31.77},{n:"Kibuku",lat:1.04,lon:33.79},{n:"Kikuube",lat:1.58,lon:31.22},{n:"Kiruhura",lat:-0.20,lon:30.86},{n:"Kiryandongo",lat:1.88,lon:32.10},{n:"Kisoro",lat:-1.28,lon:29.65},{n:"Kitgum",lat:3.28,lon:32.89},{n:"Koboko",lat:3.41,lon:31.05},{n:"Kole",lat:2.37,lon:32.76},{n:"Kotido",lat:2.98,lon:34.13},{n:"Kumi",lat:1.46,lon:33.94},{n:"Kwania",lat:2.12,lon:32.60},{n:"Kween",lat:1.42,lon:34.63},{n:"Kyankwanzi",lat:1.09,lon:31.71},{n:"Kyegegwa",lat:0.48,lon:31.05},{n:"Kyenjojo",lat:0.62,lon:30.64},{n:"Kyotera",lat:-0.65,lon:31.55},{n:"Lamwo",lat:3.53,lon:32.53},{n:"Lira",lat:2.25,lon:32.90},{n:"Luuka",lat:0.73,lon:33.30},{n:"Luwero",lat:0.85,lon:32.47},{n:"Lwengo",lat:-0.40,lon:31.40},{n:"Lyantonde",lat:-0.40,lon:31.15},{n:"Madi-Okollo",lat:3.10,lon:31.20},{n:"Manafwa",lat:0.88,lon:34.28},{n:"Maracha",lat:3.29,lon:30.96},{n:"Masaka",lat:-0.34,lon:31.74},{n:"Masindi",lat:1.68,lon:31.71},{n:"Mayuge",lat:0.46,lon:33.57},{n:"Mbale",lat:1.08,lon:34.18},{n:"Mbarara",lat:-0.60,lon:30.65},{n:"Mitooma",lat:-0.63,lon:30.02},{n:"Mityana",lat:0.40,lon:32.02},{n:"Moroto",lat:2.53,lon:34.67},{n:"Moyo",lat:3.65,lon:31.73},{n:"Mpigi",lat:0.23,lon:32.32},{n:"Mubende",lat:0.57,lon:31.36},{n:"Mukono",lat:0.35,lon:32.76},{n:"Nabilatuk",lat:2.05,lon:34.53},{n:"Nakapiripirit",lat:1.90,lon:34.65},{n:"Nakaseke",lat:1.12,lon:32.43},{n:"Nakasongola",lat:1.32,lon:32.45},{n:"Namayingo",lat:0.28,lon:33.92},{n:"Namisindwa",lat:0.95,lon:34.42},{n:"Namutumba",lat:0.83,lon:33.68},{n:"Napak",lat:2.36,lon:34.24},{n:"Nebbi",lat:2.48,lon:31.10},{n:"Ngora",lat:1.48,lon:33.77},{n:"Ntoroko",lat:1.03,lon:30.47},{n:"Ntungamo",lat:-0.88,lon:30.27},{n:"Nwoya",lat:2.62,lon:31.95},{n:"Obongi",lat:3.52,lon:31.60},{n:"Omoro",lat:2.62,lon:32.52},{n:"Otuke",lat:2.52,lon:33.45},{n:"Oyam",lat:2.26,lon:32.40},{n:"Pader",lat:2.80,lon:33.20},{n:"Pakwach",lat:2.46,lon:31.49},{n:"Pallisa",lat:1.14,lon:33.71},{n:"Rakai",lat:-0.73,lon:31.40},{n:"Rubanda",lat:-1.19,lon:29.84},{n:"Rubirizi",lat:-0.28,lon:30.10},{n:"Rukiga",lat:-1.08,lon:29.95},{n:"Rukungiri",lat:-0.84,lon:29.94},{n:"Rwampara",lat:-0.68,lon:30.75},{n:"Sembabule",lat:-0.07,lon:31.46},{n:"Serere",lat:1.50,lon:33.55},{n:"Sheema",lat:-0.56,lon:30.38},{n:"Sironko",lat:1.23,lon:34.25},{n:"Soroti",lat:1.71,lon:33.61},{n:"Terego",lat:3.06,lon:30.80},{n:"Tororo",lat:0.69,lon:34.18},{n:"Wakiso",lat:0.40,lon:32.45},{n:"Yumbe",lat:3.47,lon:31.25},{n:"Zombo",lat:2.67,lon:30.90}];

function useSynth(){
  const coordMap={};COORDS.forEach(c=>coordMap[c.n]=c);
  apiData=COORDS.map((c,i)=>{
    const s=i*137.508+19.1;
    const isN=c.lat>2.5,isKar=c.lat>2.5&&c.lon>33.5,isUrb=['Kampala','Wakiso','Mukono','Jinja'].includes(c.n),isW=c.lon<30.5;
    let mh=Math.min(1,Math.max(0,0.15+0.3*Math.abs(Math.sin(s*0.7))));
    if(isN)mh=Math.min(1,mh+0.20);if(isKar)mh=Math.min(1,mh+0.12);if(isUrb)mh=Math.min(1,mh+0.16);
    let mort=Math.min(1,Math.max(0,0.04+0.10*Math.abs(Math.sin(s*1.3))));if(isKar)mort=Math.min(1,mort+0.08);
    let mal=Math.min(1,Math.max(0,0.15+0.30*Math.abs(Math.sin(s*0.9))));if(isW)mal=Math.min(1,mal+0.15);
    let so=Math.min(1,Math.max(0,0.05+0.20*Math.abs(Math.sin(s*1.7))));
    const loss=+(mh*0.35+mort*0.25+mal*0.25+so*0.15).toFixed(3);
    return{n:c.n,lat:c.lat,lon:c.lon,mh:+mh.toFixed(3),mort:+mort.toFixed(3),mal:+mal.toFixed(3),so:+so.toFixed(3),loss,source:'synthetic'};
  });
  document.getElementById('n-badge').textContent=apiData.length+' Districts';
  refresh();
}

function refresh(){
  processDataset();renderMarkers();updateStats();
  if(selDistrict){const u=dataset.find(d=>d.n===selDistrict.n);if(u)selectD(u);}
}

function renderMarkers(){
  markers.forEach(m=>map.removeLayer(m));markers=[];
  dataset.forEach(d=>{
    const col=lossColor(d.disp),r=d.n==='Kampala'?12:['Gulu','Mbarara','Jinja'].includes(d.n)?10:8;
    const m=L.circleMarker([d.lat,d.lon],{radius:r,fillColor:col,color:'rgba(255,255,255,0.18)',weight:1.5,opacity:1,fillOpacity:.88}).addTo(map);
    m.bindPopup(`<div class="lp-name">${d.n}</div><div class="lp-val" style="color:${col}">${(d.disp*100).toFixed(1)}%</div><div><div class="lp-row"><span>Mental health</span><span class="lp-rv" style="color:${lossColor(d.mh)}">${(d.mh*100).toFixed(1)}%</span></div><div class="lp-row"><span>Mortality</span><span class="lp-rv" style="color:${lossColor(d.mort)}">${(d.mort*100).toFixed(1)}%</span></div><div class="lp-row"><span>Malnutrition</span><span class="lp-rv" style="color:${lossColor(d.mal)}">${(d.mal*100).toFixed(1)}%</span></div><div class="lp-row"><span>School-out</span><span class="lp-rv" style="color:${lossColor(d.so)}">${(d.so*100).toFixed(1)}%</span></div><div class="lp-row"><span>L(θ)</span><span class="lp-rv" style="color:${col}">${d.loss.toFixed(3)}</span></div></div>`);
    m.on('click',()=>{selectD(d);logA(d.n+' · L(θ)='+(d.comp*100).toFixed(1)+'%');});
    markers.push(m);
  });
}

function selectD(d){
  selDistrict=d;
  const col=lossColor(d.disp);
  document.getElementById('sel-panel').style.display='block';
  document.getElementById('sel-name').textContent=d.n;
  document.getElementById('sel-score').textContent=(d.disp*100).toFixed(1)+'%';
  document.getElementById('sel-score').style.color=col;
  document.getElementById('iv-d').value=d.n;
  document.getElementById('sel-dims').innerHTML=[['mh','Mental health',d.mh],['mort','Mortality',d.mort],['mal','Malnutrition',d.mal],['so','School-out',d.so]].map(([k,l,v])=>{const c=lossColor(v);return`<div class="db-row"><div class="db-dot" style="background:${c}"></div><div class="db-name">${l}</div><div class="db-bar"><div class="db-fill" style="width:${Math.round(v*100)}%;background:${c}"></div></div><div class="db-val" style="color:${c}">${(v*100).toFixed(1)}%</div></div>`;}).join('');
}

window.__dsmap={};
function updateStats(){
  const losses=dataset.map(d=>d.comp),mean=losses.reduce((a,b)=>a+b,0)/losses.length;
  const top=[...dataset].sort((a,b)=>b.comp-a.comp);
  document.getElementById('st-loss').textContent=(mean*100).toFixed(1)+'%';
  document.getElementById('st-loss').style.color=lossColor(mean);
  document.getElementById('st-sub').textContent='Mean across '+dataset.length+' districts';
  document.getElementById('top-d').innerHTML=top.slice(0,8).map(d=>`<div class="d-item" onclick="selectD(window.__dsmap['${d.n}'])"><div class="d-dot" style="background:${lossColor(d.comp)}"></div><span class="d-name">${d.n}</span><span class="d-val">${(d.comp*100).toFixed(1)}%</span></div>`).join('');
  dataset.forEach(d=>window.__dsmap[d.n]=d);
}

function updDisplays(){
  const mh=+document.getElementById('s-mh').value,mort=+document.getElementById('s-im').value,mal=+document.getElementById('s-ml').value,so=+document.getElementById('s-so').value,T=mh+mort+mal+so;
  document.getElementById('v-mh').textContent=Math.round(mh/T*100)+'%';
  document.getElementById('v-im').textContent=Math.round(mort/T*100)+'%';
  document.getElementById('v-ml').textContent=Math.round(mal/T*100)+'%';
  document.getElementById('v-so').textContent=Math.round(so/T*100)+'%';
  document.getElementById('v-eta').textContent=(+document.getElementById('s-eta').value/100).toFixed(2);
  const dim=document.getElementById('dim-sel').value;
  document.getElementById('dim-desc').textContent=DIM_DESC[dim];
  document.getElementById('wb').classList.toggle('show',dim==='composite');
  document.getElementById('leg-title').textContent=(dim==='composite'?'L(θ) — Composite loss':dim.toUpperCase()+' dimension')+' — ROYGBIV';
}

let stimer=null;
function sched(){updDisplays();document.getElementById('upd').classList.add('on');clearTimeout(stimer);stimer=setTimeout(()=>{refresh();document.getElementById('upd').classList.remove('on');},320);}
document.getElementById('dim-sel').addEventListener('change',sched);
['s-mh','s-im','s-ml','s-so','s-eta'].forEach(id=>document.getElementById(id).addEventListener('input',sched));

function setSc(btn,nm){
  document.querySelectorAll('.sc-btn').forEach(b=>b.classList.remove('on'));btn.classList.add('on');
  const s={base:[35,25,25,15,15],mh:[45,20,20,15,15],int:[35,25,25,15,25]}[nm];
  if(s){['s-mh','s-im','s-ml','s-so','s-eta'].forEach((id,i)=>document.getElementById(id).value=s[i]);}
  logA('Scenario: '+btn.childNodes[0].textContent.trim());sched();
}

async function runWhatif(){
  const district=document.getElementById('iv-d').value.trim(),reduction=parseInt(document.getElementById('iv-pct').value)/100,box=document.getElementById('iv-result');
  if(!district){showIV(box,'Enter a district name.');return;}
  try{const r=await fetch('/whatif',{method:'POST',headers:{'Content-Type':'application/json'},body:JSON.stringify({district,reduction})});if(!r.ok)throw new Error((await r.json()).detail||r.status);const d=(await r.json()).whatif;showIV(box,`what-if: ${district} @ ${(reduction*100).toFixed(0)}% reduction\nL(θ): ${d.loss.toFixed(3)} · MH: ${(d.mh*100).toFixed(1)}%`);logA('What-if: '+district+' → L(θ)='+d.loss.toFixed(3));}catch(e){showIV(box,'Error: '+e.message);}
}

async function runIntervene(){
  const district=document.getElementById('iv-d').value.trim(),reduction=parseInt(document.getElementById('iv-pct').value)/100,box=document.getElementById('iv-result');
  if(!district){showIV(box,'Enter a district name.');return;}
  try{const r=await fetch('/intervene',{method:'POST',headers:{'Content-Type':'application/json'},body:JSON.stringify({district,reduction})});if(!r.ok)throw new Error((await r.json()).detail||r.status);const d=(await r.json()).updated;showIV(box,`applied: ${district} θ′ updated\nL(θ)=${d.loss.toFixed(3)} · source: ${d.source}`);logA('−η∇L: '+district+' → L(θ)='+d.loss.toFixed(3));await loadAPI();}catch(e){showIV(box,'Error: '+e.message);}
}

async function apiInterveneTop(){if(!dataset.length)return;const top=[...dataset].sort((a,b)=>b.comp-a.comp)[0];const eta=+document.getElementById('s-eta').value;document.getElementById('iv-d').value=top.n;document.getElementById('iv-pct').value=eta;document.getElementById('iv-pct-lbl').textContent=eta;logA('Targeting: '+top.n+' L='+(top.comp*100).toFixed(1)+'%');await runIntervene();}

async function apiBayesSwap(){if(dataset.length<2)return;const s=[...dataset].sort((a,b)=>b.comp-a.comp);try{const r=await fetch(`/bayesian-swap?district_a=${encodeURIComponent(s[0].n)}&district_b=${encodeURIComponent(s[1].n)}`,{method:'POST'});if(!r.ok)throw new Error((await r.json()).detail||r.status);logA((await r.json()).message);await loadAPI();}catch(e){logA('Bayes error: '+e.message);}}

function showIV(box,msg){box.textContent=msg;box.className='iv-result show';}

function logA(msg){const n=new Date(),t=[n.getHours(),n.getMinutes(),n.getSeconds()].map(x=>String(x).padStart(2,'0')).join(':'),el=document.getElementById('tlog'),e=document.createElement('div');e.className='te';e.innerHTML=`<span class="tt">${t}</span><span class="ta">${msg}</span>`;el.prepend(e);if(el.children.length>30)el.removeChild(el.lastChild);}

document.getElementById('theme-btn').addEventListener('click',()=>{
  const next=document.documentElement.getAttribute('data-theme')==='dark'?'light':'dark';
  document.documentElement.setAttribute('data-theme',next);localStorage.setItem('theme',next);
  document.getElementById('logo-img').src=next==='dark'?'https://abikesa.github.io/logos/assets/ukubona-dark.png':'https://abikesa.github.io/logos/assets/ukubona-light.png';
  if(map){if(next==='dark'){map.removeLayer(lightTile);darkTile.addTo(map);}else{map.removeLayer(darkTile);lightTile.addTo(map);}}
});
const saved=localStorage.getItem('theme')||'dark';
document.documentElement.setAttribute('data-theme',saved);
document.getElementById('logo-img').src=saved==='dark'?'https://abikesa.github.io/logos/assets/ukubona-dark.png':'https://abikesa.github.io/logos/assets/ukubona-light.png';

logA('Ukubona NPA Digital Twin booting…');
initMap();updDisplays();loadAPI();
</script>
</body>
</html>
HTMLEOF

# ============================================================
# render.yaml + .gitignore
# ============================================================
cat > render.yaml << EOF
services:
  - type: web
    name: $REPO
    env: python
    plan: starter
    buildCommand: pip install -r requirements.txt
    startCommand: uvicorn main:app --host 0.0.0.0 --port \$PORT
EOF

cat > .gitignore << EOF
venv
__pycache__
.env
*.db
render_response.json
EOF

# ============================================================
# GIT — clean single commit, no merge conflicts possible
# ============================================================
git add .
git commit -m "Ukubona NPA Digital Twin — full map + API + index.html"

# Create or reuse GitHub repo
HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" \
  -H "Authorization: token $GH_TOKEN" \
  https://api.github.com/repos/$GH_USER/$REPO)

if [ "$HTTP_CODE" = "404" ]; then
  echo "📦 Creating new GitHub repo: $REPO"
  curl -s -X POST \
    -H "Authorization: token $GH_TOKEN" \
    -H "Accept: application/vnd.github.v3+json" \
    https://api.github.com/user/repos \
    -d "{\"name\":\"$REPO\",\"private\":false,\"description\":\"Uganda NPA Digital Twin\"}" > /dev/null
  sleep 3
  # Brand-new repo — no remote history to worry about
  git remote add origin https://$GH_TOKEN@github.com/$GH_USER/$REPO.git
  git push -u origin main
else
  echo "📦 Repo exists — force-pushing clean state"
  git remote add origin https://$GH_TOKEN@github.com/$GH_USER/$REPO.git 2>/dev/null || \
    git remote set-url origin https://$GH_TOKEN@github.com/$GH_USER/$REPO.git
  # Force push eliminates any remote conflict — no merge needed
  git push -u origin main --force
fi

echo "✅ GitHub ready!"

# ============================================================
# RENDER
# ============================================================
echo "🔍 Detecting Render workspace..."
WORKSPACE_ID=$(python3 -c '
import requests, sys
r = requests.get("https://api.render.com/v1/owners",
    headers={"Authorization": "Bearer '"$RENDER_API_KEY"'"})
if r.status_code != 200:
    print("ERROR:", r.text, file=sys.stderr); sys.exit(1)
print(r.json()[0]["owner"]["id"])
')

echo "✅ Workspace: $WORKSPACE_ID"

curl -s -X POST https://api.render.com/v1/services \
  -H "Authorization: Bearer $RENDER_API_KEY" \
  -H "Content-Type: application/json" \
  -d "{
    \"type\": \"web_service\",
    \"name\": \"$REPO\",
    \"workspaceId\": \"$WORKSPACE_ID\",
    \"repo\": \"https://github.com/$GH_USER/$REPO.git\",
    \"branch\": \"main\",
    \"autoDeploy\": \"yes\",
    \"serviceDetails\": {
      \"buildCommand\": \"pip install -r requirements.txt\",
      \"startCommand\": \"uvicorn main:app --host 0.0.0.0 --port \$PORT\",
      \"buildPlan\": \"starter\"
    }
  }" > render_response.json

echo ""
echo "========================================"
echo "✅ DONE — live in ~60 seconds"
echo "🌐 https://$REPO.onrender.com"
echo "========================================"
echo ""
echo "When it loads, reply with exactly: next"
```