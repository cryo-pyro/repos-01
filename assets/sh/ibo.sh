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