#!/bin/bash
# ================================================================
#  STRATA STONE DIGITAL TWIN — UNIFIED SETUP v4 (username: muzaale@github)
#  Combines: React/FastAPI twin (93 vars) + Geo Map (13 sites)
#  Geo map lives at /ops-geo.html — not linked from index
#  bash setup.sh → answer prompts → DONE
# ================================================================

echo ""
echo "╔═══════════════════════════════════════════════════════════╗"
echo "║   STRATA STONE DIGITAL TWIN v4 — FULL SUITE 🏗️           ║"
echo "╚═══════════════════════════════════════════════════════════╝"
echo ""
echo "  React dashboard + FastAPI backend + Geo map (hidden route)"
echo "  93 variables · 7 departments · 13 real sites · live trucks"
echo ""

# ── CREDENTIALS ─────────────────────────────────────────────────
read -p "👤  GitHub Username                           : " GH_USER
read -p "🔑  GitHub Personal Token (classic)           : " GH_TOKEN
read -p "📦  Repo Name (e.g. strata-twin)              : " REPO_NAME
read -p "🌐  Render API Key                            : " RENDER_KEY
read -p "🏢  Project Name (e.g. Kadi Dev)              : " PROJECT_NAME
read -p "📍  Location (e.g. Kampala, Uganda)           : " LOCATION

echo ""
echo "✅  Building your Digital Twin suite..."
echo ""

# ── PROJECT STRUCTURE ────────────────────────────────────────────
mkdir -p "${REPO_NAME}/backend/data"
mkdir -p "${REPO_NAME}/frontend/src"
mkdir -p "${REPO_NAME}/frontend/public"
cd "${REPO_NAME}" || exit 1

# ── STEP 1: SYNTHETIC DATA ───────────────────────────────────────
cat <<'PYEOF' > gen_data.py
import csv, random
random.seed(42)

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
        if cat == "Cement":
            gate_loss  = random.randint(8, 20)
            usage_loss = random.randint(5, 15)
        received = max(0, procured - gate_loss)
        consumed = max(0, received - usage_loss)
        rows.append([week, phase, cat, procured, received, consumed, unit_prices[cat]])

with open("backend/data/leakage_data.csv", "w", newline="") as f:
    csv.writer(f).writerows(rows)
print("Data generated: 12 weeks x 8 categories")
PYEOF

python3 gen_data.py
rm gen_data.py

# ── STEP 2: LANDSCAPE.JSON (93 VARIABLES) ───────────────────────
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
    {"id":14, "dept":"Finance",            "phase":"Strategic", "impact":"Budget",     "task":"Generate budget reports (weekly, monthly, quarterly, annual)"},
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
    {"id":38, "dept":"Customer_Relations", "phase":"Handover",  "impact":"Execution",  "task":"Upon closure, meet clients and educate them about the product"},
    {"id":39, "dept":"Customer_Relations", "phase":"Strategic", "impact":"Budget",     "task":"Follow up on collections with the clients"},
    {"id":40, "dept":"Customer_Relations", "phase":"Strategic", "impact":"Execution",  "task":"Share monthly payment status and targets with customers"},
    {"id":41, "dept":"Customer_Relations", "phase":"Strategic", "impact":"Execution",  "task":"Handle all customer queries"},
    {"id":42, "dept":"Customer_Relations", "phase":"Strategic", "impact":"Execution",  "task":"Generate monthly performance reports on all client closures and collections"},
    {"id":43, "dept":"Customer_Relations", "phase":"Strategic", "impact":"Execution",  "task":"Keep company social media pages very active"},
    {"id":44, "dept":"Customer_Relations", "phase":"Handover",  "impact":"Execution",  "task":"Follow up on customer furniture selection and update the catalogue"},
    {"id":45, "dept":"Material_Control",   "phase":"Strategic", "impact":"Execution",  "task":"Study Material and equipment schedule"},
    {"id":46, "dept":"Material_Control",   "phase":"Strategic", "impact":"Execution",  "task":"Receive all material from procurement"},
    {"id":47, "dept":"Material_Control",   "phase":"Strategic", "impact":"Execution",  "task":"Record all materials received"},
    {"id":48, "dept":"Material_Control",   "phase":"Strategic", "impact":"Execution",  "task":"Allocate material needed for construction — workers sign receipt"},
    {"id":49, "dept":"Material_Control",   "phase":"Strategic", "impact":"Leakage",    "task":"Monitor usage of all material"},
    {"id":50, "dept":"Material_Control",   "phase":"Strategic", "impact":"Execution",  "task":"Receive all equipment both purchased and leased/rented"},
    {"id":51, "dept":"Material_Control",   "phase":"Strategic", "impact":"Execution",  "task":"Every morning distribute equipment to individual workers — acknowledge receipt"},
    {"id":52, "dept":"Material_Control",   "phase":"Strategic", "impact":"Leakage",    "task":"Every evening receive equipment and check on damages"},
    {"id":53, "dept":"Material_Control",   "phase":"Strategic", "impact":"Leakage",    "task":"If damage by reckless work, report to finance/PM — they determine deductions"},
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
    {"id":64, "dept":"Legal",              "phase":"Pre_Con",   "impact":"Compliance", "task":"Carrying out extensive due diligence on selected land"},
    {"id":65, "dept":"Legal",              "phase":"Pre_Con",   "impact":"Compliance", "task":"Execute purchase agreement with land seller after thorough due diligence"},
    {"id":66, "dept":"Finance",            "phase":"Pre_Con",   "impact":"Budget",     "task":"Make payment for the land purchased"},
    {"id":67, "dept":"Legal",              "phase":"Pre_Con",   "impact":"Compliance", "task":"Receive duplicate certificate of title, transfer forms, national ID from land seller"},
    {"id":68, "dept":"Legal",              "phase":"Pre_Con",   "impact":"Compliance", "task":"Handover duplicate certificate of title to land registry to transfer title to Strata"},
    {"id":69, "dept":"Project_Management", "phase":"Design",    "impact":"Execution",  "task":"Engage architect for concepts and architectural designs"},
    {"id":70, "dept":"Project_Management", "phase":"Design",    "impact":"Compliance", "task":"Submit architectural, structural and M&E designs to government authority for approval"},
    {"id":71, "dept":"Project_Management", "phase":"Shell",     "impact":"Execution",  "task":"After approved designs received, clearing of purchased land commences"},
    {"id":72, "dept":"Project_Management", "phase":"Shell",     "impact":"Execution",  "task":"Construction of perimeter wall and security guard house"},
    {"id":73, "dept":"Project_Management", "phase":"Shell",     "impact":"Execution",  "task":"Hiring site security"},
    {"id":74, "dept":"Project_Management", "phase":"Shell",     "impact":"Compliance", "task":"Application for site water and electricity from NWSC and UEDCL"},
    {"id":75, "dept":"Project_Management", "phase":"Shell",     "impact":"Execution",  "task":"Setting out the blocks by the technical team"},
    {"id":76, "dept":"Project_Management", "phase":"Shell",     "impact":"Execution",  "task":"Foundation works commence"},
    {"id":77, "dept":"Project_Management", "phase":"Shell",     "impact":"Execution",  "task":"Concrete pre-fabs are set on the completed foundation"},
    {"id":78, "dept":"Project_Management", "phase":"Shell",     "impact":"Execution",  "task":"Inner walls construction commences"},
    {"id":79, "dept":"Project_Management", "phase":"Shell",     "impact":"Execution",  "task":"Plastering the inner walls"},
    {"id":80, "dept":"Project_Management", "phase":"Finishing", "impact":"Execution",  "task":"Paint team starts with wall preparation"},
    {"id":81, "dept":"Project_Management", "phase":"Finishing", "impact":"Execution",  "task":"Compound works (leveling and paving)"},
    {"id":82, "dept":"Project_Management", "phase":"Finishing", "impact":"Execution",  "task":"Drainage and sewer system works"},
    {"id":83, "dept":"Project_Management", "phase":"Finishing", "impact":"Execution",  "task":"Tile team commences"},
    {"id":84, "dept":"Project_Management", "phase":"Finishing", "impact":"Execution",  "task":"Plumbing team — installation of all sanitary ware and faucets"},
    {"id":85, "dept":"Project_Management", "phase":"Finishing", "impact":"Execution",  "task":"Electrical installation works"},
    {"id":86, "dept":"Project_Management", "phase":"Finishing", "impact":"Execution",  "task":"CCTV, razor wire and electric fence installation"},
    {"id":87, "dept":"Project_Management", "phase":"Finishing", "impact":"Execution",  "task":"Wood works — door frames, doors, wardrobes, kitchen cabins"},
    {"id":88, "dept":"Project_Management", "phase":"Finishing", "impact":"Execution",  "task":"Steel works — kitchen door and maid's room door"},
    {"id":89, "dept":"Project_Management", "phase":"Finishing", "impact":"Execution",  "task":"Aluminium works — windows, nets, bathroom partitions"},
    {"id":90, "dept":"Project_Management", "phase":"Finishing", "impact":"Execution",  "task":"Interior design — gypsum molds/works"},
    {"id":91, "dept":"Project_Management", "phase":"Finishing", "impact":"Execution",  "task":"Paint team finishes"},
    {"id":92, "dept":"Project_Management", "phase":"Handover",  "impact":"Execution",  "task":"Installation of appliances and furniture"},
    {"id":93, "dept":"Customer_Relations", "phase":"Handover",  "impact":"Execution",  "task":"Clients move in"}
  ],
  "total": 93,
  "departments_flagged_for_expansion": ["Marketing","HR"],
  "note": "Verbatim from Ibo CEO digital_twin.docx. Marketing and HR listed in header but not yet detailed."
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

PROJECT  = os.environ.get("PROJECT_NAME", "Strata Stone")
LOCATION = os.environ.get("LOCATION", "Kampala")

DATA_PATH      = os.path.join(os.path.dirname(__file__), "data", "leakage_data.csv")
LANDSCAPE_PATH = os.path.join(os.path.dirname(__file__), "landscape.json")

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
    except Exception as e:
        return {"error": str(e)}

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
        "verdict": "SYSTEMIC LEAKAGE DETECTED" if systemic else "Variance within normal range"
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
        "rows_analysed":  len(df),
        "dominant_driver": drivers[0],
        "systemic":        bool(vals[0] > sum(vals[1:])),
        "all_drivers":     drivers
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

# Copy landscape into backend so it deploys with the API
cp landscape.json backend/landscape.json

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
  const [tab,       setTab]       = useState("overview");
  const [summary,   setSummary]   = useState(null);
  const [eigen,     setEigen]     = useState(null);
  const [timeline,  setTimeline]  = useState(null);
  const [tensor,    setTensor]    = useState(null);
  const [landscape, setLandscape] = useState(null);
  const [loading,   setLoading]   = useState(true);
  const [uploadMsg, setUploadMsg] = useState(null);

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
    setUploadMsg(`Done: ${d.dominant_driver?.category} (${d.dominant_driver?.weight?.toFixed(3)}) — ${d.systemic?"SYSTEMIC":"Normal"}`);
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

      <div style={S.tabs}>
        {TABS.map(t => (
          <button key={t} style={S.tab(tab===t)} onClick={()=>setTab(t)}>
            { t==="overview"    ? "📊 Overview"
            : t==="leakage"     ? "💧 Leakage"
            : t==="eigen"       ? "🔬 Diagnosis"
            : t==="tensor"      ? "🧊 Tensor"
            : t==="operations"  ? "📋 Operations"
            :                     "📤 Upload Data" }
          </button>
        ))}
      </div>

      <div style={S.body}>

        {tab==="overview" && summary && (
          <>
            <div style={S.grid4}>
              {[
                {label:"Weeks Tracked",  val:summary.weeks,                          color:C.green},
                {label:"Total Leakage",  val:fmt(summary.total_leakage_ugx),         color:C.red},
                {label:"Top Leaky Item", val:catData[0]?.name||"—",                  color:C.amber},
                {label:"System Status",  val:eigen?.systemic?"⚠️ Systemic":"✅ Normal",color:C.blue},
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

        {tab==="eigen" && eigen && (
          <>
            <div style={S.alert(!eigen.systemic)}>{eigen.verdict}</div>
            <div style={S.panel}>
              <h2 style={S.h2}>🔬 Leakage Signature — Dominant Eigenvector</h2>
              <p style={{color:C.muted,fontSize:"13px",marginBottom:"18px"}}>
                The eigenvector shows where leakage is structurally concentrated — not just where it appears loudest.
                A dominant first eigenvalue means the pattern is <strong style={{color:C.red}}>repeatable and systemic</strong>.
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

        {tab==="tensor" && (
          <>
            <div style={S.panel}>
              <h2 style={S.h2}>🧊 Tensor Slice — Phase × Category (Top 12)</h2>
              <p style={{color:C.muted,fontSize:"13px",marginBottom:"18px"}}>
                Each bar is a coordinate in 3D operational space: <strong>Phase × Category × Leakage (UGX '000)</strong>.
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
          </>
        )}

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

        {tab==="upload" && (
          <div style={S.panel}>
            <h2 style={S.h2}>📤 Upload Your Real Site Data</h2>
            <p style={{color:C.muted,fontSize:"14px",marginBottom:"20px",lineHeight:"1.6"}}>
              Upload a CSV with columns: <code style={{background:C.border,padding:"2px 6px",borderRadius:"4px"}}>week, category, procured, received, consumed, unit_price</code>
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

# ── STEP 5: GEO MAP — lives at ops-geo.html (not index) ─────────
# Placed in frontend/public so React build copies it as-is.
# Accessible at: https://your-ui.onrender.com/ops-geo.html
# Not linked from the main app — you share the URL directly.

cat <<'GEOEOF' > frontend/public/ops-geo.html
<!DOCTYPE html>
<html lang="en" data-theme="dark">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Strata Stone · Geo Operations Map</title>
<link rel="preconnect" href="https://fonts.googleapis.com" crossorigin>
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=DM+Mono:wght@300;400;500&family=Playfair+Display:ital,wght@0,600;1,400&family=DM+Sans:wght@300;400;500;600&display=swap" rel="stylesheet">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/leaflet@1.9.4/dist/leaflet.min.css">
<style>
:root {
  --bg:#080c0a; --surf:#0f1410; --surf2:#161d17;
  --brd:rgba(200,160,80,0.12); --ink:#efe8d8; --mut:#706040; --dim:#252018;
  --r:#e84040; --o:#d87030; --y:#d4a820; --g:#30b060; --b:#2880d8; --i:#9050c0; --v:#20b890;
  --accent:#d4a820; --accent2:#80e0ff;
}
[data-theme="light"] {
  --bg:#faf8f2; --surf:#fff; --surf2:#f5f0e4;
  --brd:rgba(150,110,20,0.14); --ink:#1a1408; --mut:#605030; --dim:#d8d0b8;
}
*{box-sizing:border-box;margin:0;padding:0;}
html,body{height:100%;overflow:hidden;}
body{font-family:'DM Sans',sans-serif;font-size:13px;background:var(--bg);color:var(--ink);display:flex;flex-direction:column;}
.hd{display:flex;align-items:center;justify-content:space-between;padding:.6rem 1.1rem;background:var(--surf);border-bottom:1px solid var(--brd);flex-shrink:0;gap:.75rem;flex-wrap:wrap;}
.hd-title{font-family:'Playfair Display',serif;font-size:1.1rem;color:var(--ink);}
.hd-sub{font-family:'DM Mono',monospace;font-size:.52rem;color:var(--mut);letter-spacing:.06em;margin-top:.1rem;}
.hd-right{display:flex;gap:.4rem;align-items:center;}
.badge{font-family:'DM Mono',monospace;font-size:.52rem;letter-spacing:.08em;text-transform:uppercase;padding:.18em .65em;border:1px solid var(--brd);border-radius:999px;color:var(--mut);}
.badge-gold{color:var(--accent);border-color:rgba(212,168,32,.3);}
.icon-btn{background:var(--surf2);border:1px solid var(--brd);border-radius:6px;padding:.38rem .6rem;cursor:pointer;color:var(--mut);font-family:'DM Mono',monospace;font-size:.55rem;transition:border-color .15s,color .15s;text-decoration:none;display:flex;align-items:center;gap:4px;}
.icon-btn:hover{border-color:var(--accent);color:var(--accent);}
.body{display:flex;flex:1;overflow:hidden;min-height:0;}
.lp{width:240px;flex-shrink:0;background:var(--surf);border-right:1px solid var(--brd);overflow-y:auto;padding:.9rem;display:flex;flex-direction:column;gap:.8rem;}
.plbl{font-family:'DM Mono',monospace;font-size:.52rem;letter-spacing:.14em;text-transform:uppercase;color:var(--mut);padding-bottom:.3rem;border-bottom:1px solid var(--brd);margin-bottom:.1rem;}
.layer-grid{display:flex;flex-direction:column;gap:.28rem;}
.layer-btn{width:100%;text-align:left;padding:.42rem .65rem;background:var(--surf2);border:1px solid var(--brd);border-radius:6px;color:var(--ink);cursor:pointer;font-family:'DM Sans',sans-serif;font-size:.68rem;transition:border-color .12s,background .12s;display:flex;align-items:center;gap:.48rem;}
.layer-btn:hover{border-color:var(--accent);background:rgba(212,168,32,.06);}
.layer-btn.on{border-color:var(--accent);background:rgba(212,168,32,.10);color:var(--accent);}
.layer-dot{width:8px;height:8px;border-radius:50%;flex-shrink:0;}
.layer-sub{font-size:.57rem;color:var(--mut);display:block;margin-top:.03rem;}
.layer-btn.on .layer-sub{color:rgba(212,168,32,.6);}
.formula{font-family:'DM Mono',monospace;font-size:.59rem;color:var(--mut);line-height:1.9;padding:.55rem .65rem;background:var(--surf2);border-radius:5px;border:1px solid var(--brd);}
.formula .hl{color:var(--accent);}
.formula .hl2{color:var(--accent2);}
.sl-row{display:flex;flex-direction:column;gap:.18rem;margin-bottom:.38rem;}
.sl-meta{display:flex;justify-content:space-between;align-items:baseline;}
.sl-name{font-size:.64rem;opacity:.85;}
.sl-val{font-family:'DM Mono',monospace;font-size:.60rem;color:var(--accent);}
input[type=range]{width:100%;height:2px;appearance:none;background:var(--dim);border-radius:2px;outline:none;cursor:pointer;}
input[type=range]::-webkit-slider-thumb{appearance:none;width:10px;height:10px;border-radius:50%;background:var(--accent);cursor:pointer;}
.rr::-webkit-slider-thumb{background:#e84040!important;}
.ro::-webkit-slider-thumb{background:#d87030!important;}
.rg::-webkit-slider-thumb{background:#30b060!important;}
.rb::-webkit-slider-thumb{background:#2880d8!important;}
.ri::-webkit-slider-thumb{background:#9050c0!important;}
.sc-btn{width:100%;padding:.38rem .58rem;background:var(--surf2);border:1px solid var(--brd);border-radius:5px;color:var(--ink);font-family:'DM Sans',sans-serif;font-size:.67rem;cursor:pointer;text-align:left;margin-bottom:.25rem;transition:border-color .12s;}
.sc-btn span{display:block;font-size:.56rem;color:var(--mut);margin-top:.04rem;}
.sc-btn:hover{border-color:var(--accent);}
.sc-btn.on{border-color:var(--accent);color:var(--accent);}
.sc-btn.on span{color:rgba(212,168,32,.6);}
.mc{flex:1;position:relative;min-width:0;}
#map{width:100%;height:100%;}
.leaflet-tile-pane{filter:brightness(.72) saturate(.65) sepia(.15);}
[data-theme="light"] .leaflet-tile-pane{filter:sepia(.08) saturate(.9);}
.upd{position:absolute;top:10px;left:50%;transform:translateX(-50%);z-index:900;background:var(--surf);border:1px solid rgba(212,168,32,.45);border-radius:999px;padding:.2em .8em;font-family:'DM Mono',monospace;font-size:.56rem;color:var(--accent);opacity:0;transition:opacity .25s;pointer-events:none;white-space:nowrap;}
.upd.on{opacity:1;}
.leg{position:absolute;bottom:16px;left:16px;z-index:800;background:rgba(8,12,10,.92);border:1px solid var(--brd);border-radius:7px;padding:.52rem .68rem;backdrop-filter:blur(4px);}
[data-theme="light"] .leg{background:rgba(255,255,255,.92);}
.leg-title{font-family:'DM Mono',monospace;font-size:.51rem;letter-spacing:.1em;text-transform:uppercase;color:var(--mut);margin-bottom:.28rem;}
.leg-scale{display:flex;gap:2px;margin-bottom:.2rem;}
.leg-sw{height:8px;border-radius:1px;flex:1;}
.leg-labs{display:flex;justify-content:space-between;font-family:'DM Mono',monospace;font-size:.49rem;color:var(--mut);}
.leg-rows{margin-top:.3rem;display:flex;flex-direction:column;gap:.11rem;}
.leg-row{display:flex;align-items:center;gap:.38rem;font-family:'DM Mono',monospace;font-size:.50rem;color:var(--mut);}
.leg-dot{width:7px;height:7px;border-radius:50%;flex-shrink:0;}
.rp{width:222px;flex-shrink:0;background:var(--surf);border-left:1px solid var(--brd);overflow-y:auto;padding:.9rem;display:flex;flex-direction:column;gap:.8rem;}
.sc2{background:var(--surf2);border:1px solid var(--brd);border-radius:6px;padding:.55rem .75rem;}
.sc2-lbl{font-family:'DM Mono',monospace;font-size:.52rem;letter-spacing:.08em;text-transform:uppercase;color:var(--mut);margin-bottom:.18rem;}
.sc2-val{font-family:'Playfair Display',serif;font-size:1.45rem;line-height:1;margin-bottom:.08rem;}
.sc2-delta{font-family:'DM Mono',monospace;font-size:.55rem;color:var(--mut);}
.sc2-delta.bad{color:var(--r);}
.sc2-delta.good{color:var(--v);}
.d-list{display:flex;flex-direction:column;gap:.25rem;}
.d-item{display:flex;align-items:center;gap:.45rem;padding:.28rem .45rem;border-radius:4px;cursor:pointer;transition:background .1s;}
.d-item:hover{background:var(--surf2);}
.d-dot{width:7px;height:7px;border-radius:50%;flex-shrink:0;}
.d-name{font-size:.68rem;flex:1;}
.d-val{font-family:'DM Mono',monospace;font-size:.61rem;color:var(--mut);}
.sel-block{padding:.6rem .75rem;background:var(--surf2);border-radius:6px;border-left:3px solid var(--accent);}
.sel-d-name{font-family:'Playfair Display',serif;font-size:.95rem;margin-bottom:.28rem;}
.sel-score{font-family:'DM Mono',monospace;font-size:1.1rem;font-weight:500;margin-bottom:.38rem;}
.dim-breakdown{display:flex;flex-direction:column;gap:.25rem;}
.db-row{display:flex;align-items:center;gap:.45rem;padding:.25rem .38rem;background:var(--surf);border-radius:4px;}
.db-dot{width:7px;height:7px;border-radius:50%;flex-shrink:0;}
.db-name{font-size:.60rem;color:var(--mut);flex:1;}
.db-bar-bg{height:3px;background:var(--dim);border-radius:2px;flex:1;max-width:50px;}
.db-bar-fill{height:100%;border-radius:2px;transition:width .4s;}
.db-val{font-family:'DM Mono',monospace;font-size:.60rem;color:var(--ink);}
.tlog{font-family:'DM Mono',monospace;font-size:.56rem;color:var(--mut);line-height:1.6;max-height:110px;overflow-y:auto;}
.te{padding:.08rem 0;border-bottom:1px solid var(--brd);}
.te:last-child{border-bottom:none;}
.tt2{color:var(--dim);margin-right:.28rem;}
.ta{color:var(--accent);}
.leaflet-popup-content-wrapper{background:var(--surf)!important;color:var(--ink)!important;border:1px solid var(--brd)!important;border-radius:9px!important;box-shadow:0 8px 28px rgba(0,0,0,.75)!important;}
.leaflet-popup-content{margin:.75rem!important;font-family:'DM Sans',sans-serif!important;}
.leaflet-popup-tip{background:var(--surf)!important;}
.lp-name{font-family:'Playfair Display',serif;font-size:.92rem;margin-bottom:.28rem;}
.lp-val{font-family:'DM Mono',monospace;font-size:1.15rem;font-weight:500;margin-bottom:.28rem;}
.lp-rows{display:flex;flex-direction:column;gap:.1rem;}
.lp-row{display:flex;justify-content:space-between;font-size:.63rem;color:var(--mut);padding:.1rem 0;border-bottom:1px solid var(--brd);}
.lp-row:last-child{border-bottom:none;}
.lp-rv{color:var(--ink);font-family:'DM Mono',monospace;}
@media(max-width:860px){.lp,.rp{display:none;}}
</style>
</head>
<body>
<header class="hd">
  <div>
    <div class="hd-title">Strata Stone Partners · Geo Operations Map</div>
    <div class="hd-sub">Construction completion · leakage · logistics · Uganda + East Africa</div>
  </div>
  <div class="hd-right">
    <span class="badge badge-gold">93 Variables</span>
    <span class="badge">7 Departments</span>
    <span class="badge">Rank-3 Tensor</span>
    <button class="icon-btn" id="theme-btn" title="Toggle theme">
      <svg width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="5"/><line x1="12" y1="1" x2="12" y2="3"/><line x1="12" y1="21" x2="12" y2="23"/><line x1="4.22" y1="4.22" x2="5.64" y2="5.64"/><line x1="18.36" y1="18.36" x2="19.78" y2="19.78"/><line x1="1" y1="12" x2="3" y2="12"/><line x1="21" y1="12" x2="23" y2="12"/><line x1="4.22" y1="19.78" x2="5.64" y2="18.36"/><line x1="18.36" y1="5.64" x2="19.78" y2="4.22"/></svg>
      Theme
    </button>
  </div>
</header>
<div class="body">
  <aside class="lp">
    <div>
      <div class="plbl">Map layer</div>
      <div class="layer-grid">
        <button class="layer-btn on" onclick="setLayer(this,'completion')">
          <div class="layer-dot" style="background:#d4a820"></div>
          <div><span>Completion heatmap</span><span class="layer-sub">% complete per site · phase</span></div>
        </button>
        <button class="layer-btn" onclick="setLayer(this,'leakage')">
          <div class="layer-dot" style="background:#e84040"></div>
          <div><span>Leakage L(θ)</span><span class="layer-sub">Weighted loss · eigen signal</span></div>
        </button>
        <button class="layer-btn" onclick="setLayer(this,'logistics')">
          <div class="layer-dot" style="background:#2880d8"></div>
          <div><span>Logistics / GPS</span><span class="layer-sub">Trucks · routes · cargo</span></div>
        </button>
        <button class="layer-btn" onclick="setLayer(this,'composite')">
          <div class="layer-dot" style="background:#80e0ff"></div>
          <div><span>Composite L(θ)</span><span class="layer-sub">Full operational loss surface</span></div>
        </button>
      </div>
    </div>
    <div>
      <div class="plbl">Loss function</div>
      <div class="formula">θₜ → <span class="hl">L(θ)</span> → ∇L → −η∇L → θ′<br><br>L = Σ wᵢ · <span class="hl2">opᵢ</span>(θ)<br><br><span style="color:var(--r)">Cement: systemic leakage</span><br><span style="color:var(--b)">Tensor: dept × phase × resource</span></div>
    </div>
    <div>
      <div class="plbl">Leakage weights</div>
      <div class="sl-row"><div class="sl-meta"><span class="sl-name">Cement</span><span class="sl-val" id="v-cement">35%</span></div><input type="range" class="ro" id="s-cement" min="5" max="60" value="35"></div>
      <div class="sl-row"><div class="sl-meta"><span class="sl-name">Steel</span><span class="sl-val" id="v-steel">25%</span></div><input type="range" class="rg" id="s-steel" min="5" max="50" value="25"></div>
      <div class="sl-row"><div class="sl-meta"><span class="sl-name">Labor</span><span class="sl-val" id="v-labor">20%</span></div><input type="range" class="rr" id="s-labor" min="5" max="40" value="20"></div>
      <div class="sl-row"><div class="sl-meta"><span class="sl-name">Timber</span><span class="sl-val" id="v-timber">12%</span></div><input type="range" class="rb" id="s-timber" min="2" max="30" value="12"></div>
      <div class="sl-row"><div class="sl-meta"><span class="sl-name">Electrical / other</span><span class="sl-val" id="v-elec">8%</span></div><input type="range" class="ri" id="s-elec" min="2" max="25" value="8"></div>
    </div>
    <div>
      <div class="plbl">η — intervention speed</div>
      <div class="sl-row"><div class="sl-meta"><span class="sl-name">Learning rate</span><span class="sl-val" id="v-eta">0.10</span></div><input type="range" class="rb" id="s-eta" min="1" max="30" value="10"></div>
    </div>
    <div>
      <div class="plbl">Scenarios</div>
      <button class="sc-btn on" onclick="setSc(this,'base')">Status quo<span>Live data · all weights nominal</span></button>
      <button class="sc-btn" onclick="setSc(this,'cement')">Cement emergency<span>w_cement=55% · systemic flag</span></button>
      <button class="sc-btn" onclick="setSc(this,'finish')">Finishing push<span>η=0.28 · Handover phase priority</span></button>
      <button class="sc-btn" onclick="setSc(this,'logistics')">Logistics audit<span>Truck routes · material tracking</span></button>
      <button class="sc-btn" onclick="setSc(this,'eigen')">Eigen mode<span>→ Dominant leakage eigenvector</span></button>
    </div>
  </aside>
  <div class="mc">
    <div id="map"></div>
    <div class="upd" id="upd">Recomputing gradient…</div>
    <div class="leg">
      <div class="leg-title" id="leg-title">Completion heatmap</div>
      <div class="leg-scale">
        <div class="leg-sw" style="background:#e84040"></div>
        <div class="leg-sw" style="background:#d87030"></div>
        <div class="leg-sw" style="background:#d4a820"></div>
        <div class="leg-sw" style="background:#30b060"></div>
        <div class="leg-sw" style="background:#2880d8"></div>
        <div class="leg-sw" style="background:#9050c0"></div>
        <div class="leg-sw" style="background:#20b890"></div>
      </div>
      <div class="leg-labs"><span>0% / high loss</span><span>100% / complete</span></div>
      <div class="leg-rows" id="leg-rows"></div>
    </div>
  </div>
  <aside class="rp">
    <div><div class="sc2"><div class="sc2-lbl">Portfolio loss L(θ)</div><div class="sc2-val" id="st-loss">—</div><div class="sc2-delta bad" id="st-delta">computing…</div></div></div>
    <div><div class="sc2"><div class="sc2-lbl">Sites at risk (&lt;50%)</div><div class="sc2-val" id="st-crit" style="color:var(--r)">—</div><div class="sc2-delta bad">below completion threshold</div></div></div>
    <div><div class="sc2"><div class="sc2-lbl">Dominant leakage signal</div><div class="sc2-val" style="color:var(--r);font-size:1.1rem;">Cement</div><div class="sc2-delta bad">eigen weight 0.48 · systemic flag</div></div></div>
    <div><div class="sc2"><div class="sc2-lbl">Active trucks</div><div class="sc2-val" style="color:var(--b)">4</div><div class="sc2-delta">2 en route · 1 loading · 1 delayed</div></div></div>
    <div id="sel-panel" style="display:none;">
      <div class="plbl">Selected site</div>
      <div class="sel-block">
        <div class="sel-d-name" id="sel-name">—</div>
        <div class="sel-score" id="sel-score">—</div>
        <div class="dim-breakdown" id="sel-dims"></div>
      </div>
    </div>
    <div><div class="plbl">Sites ranked by loss</div><div class="d-list" id="top-d"></div></div>
    <div><div class="plbl">Transcript</div><div class="tlog" id="tlog"></div></div>
  </aside>
</div>
<script src="https://cdn.jsdelivr.net/npm/leaflet@1.9.4/dist/leaflet.min.js"></script>
<script>
const SITES = [
  {id:'s01',name:'Kadi Dev — Ntinda',         lat:0.354, lon:32.610,pct:82,phase:'Finishing',units:48,city:'Kampala'},
  {id:'s02',name:'Pearl Heights — Entebbe',   lat:0.062, lon:32.466,pct:61,phase:'Shell',    units:36,city:'Entebbe'},
  {id:'s03',name:'Nakawa Gardens',            lat:0.335, lon:32.630,pct:45,phase:'Shell',    units:60,city:'Kampala'},
  {id:'s04',name:'Naalya Estate',             lat:0.381, lon:32.668,pct:74,phase:'Finishing',units:32,city:'Kampala'},
  {id:'s05',name:'Wakiso Residences',         lat:0.403, lon:32.454,pct:38,phase:'Pre_Con',  units:44,city:'Wakiso'},
  {id:'s06',name:'Mbarara Ridge',             lat:-0.606,lon:30.655,pct:90,phase:'Handover', units:24,city:'Mbarara'},
  {id:'s07',name:'Jinja Riverside',           lat:0.446, lon:33.202,pct:33,phase:'Pre_Con',  units:42,city:'Jinja'},
  {id:'s08',name:'Gulu North',                lat:2.774, lon:32.299,pct:55,phase:'Shell',    units:30,city:'Gulu'},
  {id:'s09',name:'Fort Portal Heights',       lat:0.671, lon:30.275,pct:68,phase:'Finishing',units:28,city:'Fort Portal'},
  {id:'s10',name:'Masaka Gardens',            lat:-0.336,lon:31.740,pct:22,phase:'Pre_Con',  units:36,city:'Masaka'},
  {id:'s11',name:'Nairobi Heights — Westlands',lat:-1.268,lon:36.806,pct:70,phase:'Finishing',units:40,city:'Nairobi'},
  {id:'s12',name:'Arusha Gardens — TZ',       lat:-3.370,lon:36.680,pct:25,phase:'Pre_Con',  units:32,city:'Arusha'},
  {id:'s13',name:'Kigali Ridge — Rwanda',     lat:-1.944,lon:30.059,pct:48,phase:'Shell',    units:20,city:'Kigali'},
];
const TRUCKS = [
  {id:'T-01',name:'Cement run',    from:[0.354,32.610],to:[0.335,32.630],cargo:'Cement 20t',   pct:0.38},
  {id:'T-02',name:'Steel delivery',from:[0.062,32.466],to:[0.403,32.454],cargo:'Steel bars 8t',pct:0.71},
  {id:'T-03',name:'Timber — Gulu', from:[0.354,32.610],to:[2.774,32.299],cargo:'Timber 12t',   pct:0.18},
  {id:'T-04',name:'Finishings',    from:[-0.606,30.655],to:[0.671,30.275],cargo:'Finishing kit',pct:0.54},
];
const RC=['#e84040','#d87030','#d4a820','#30b060','#2880d8','#9050c0','#20b890'];
let curLayer='completion',dataset=[...SITES],markers=[],truckMarkers=[],truckLines=[],selSite=null;
let map,darkTile,lightTile,truckPct;
function clamp(v,a,b){return Math.max(a,Math.min(b,v));}
function getWeights(){return{cement:+document.getElementById('s-cement').value,steel:+document.getElementById('s-steel').value,labor:+document.getElementById('s-labor').value,timber:+document.getElementById('s-timber').value,elec:+document.getElementById('s-elec').value};}
function getEta(){return+document.getElementById('s-eta').value/100;}
function synthLeakage(site,idx){
  const s=idx*137.5+7.3,isK=['Kampala','Entebbe','Wakiso'].includes(site.city);
  let cement=clamp(0.35+0.45*Math.abs(Math.sin(s*1.1))+0.18+(isK?0.1:0),0,1);
  let steel=clamp(0.20+0.35*Math.abs(Math.sin(s*0.9))+(isK?0.08:0),0,1);
  let labor=clamp(0.15+0.30*Math.abs(Math.sin(s*1.4)),0,1);
  let timber=clamp(0.10+0.28*Math.abs(Math.sin(s*1.8)),0,1);
  let elec=clamp(0.08+0.25*Math.abs(Math.sin(s*2.1)),0,1);
  return{cement,steel,labor,timber,elec};
}
function compositeLeakage(lk,w){const T=w.cement+w.steel+w.labor+w.timber+w.elec;return(w.cement/T)*lk.cement+(w.steel/T)*lk.steel+(w.labor/T)*lk.labor+(w.timber/T)*lk.timber+(w.elec/T)*lk.elec;}
function siteLoss(site,idx){
  const lk=synthLeakage(site,idx),w=getWeights(),eta=getEta();
  if(curLayer==='completion')return 1-(site.pct/100);
  if(curLayer==='leakage')return clamp(compositeLeakage(lk,w)-eta*compositeLeakage(lk,w)*0.3,0,1);
  if(curLayer==='composite')return clamp((compositeLeakage(lk,w)*0.6+(1-site.pct/100)*0.4)-eta*0.2,0,1);
  return compositeLeakage(lk,w);
}
function loss2col(loss){if(loss>=0.82)return RC[0];if(loss>=0.64)return RC[1];if(loss>=0.46)return RC[2];if(loss>=0.28)return RC[3];if(loss>=0.13)return RC[4];if(loss>=0.05)return RC[5];return RC[6];}
function initMap(){
  map=L.map('map',{center:[1.37,32.29],zoom:7});
  darkTile=L.tileLayer('https://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}{r}.png',{attribution:'© OpenStreetMap © CARTO',subdomains:'abcd',maxZoom:19});
  lightTile=L.tileLayer('https://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}{r}.png',{attribution:'© OpenStreetMap © CARTO',subdomains:'abcd',maxZoom:19});
  darkTile.addTo(map);
}
function clearMarkers(){markers.forEach(m=>map.removeLayer(m));truckMarkers.forEach(m=>map.removeLayer(m));truckLines.forEach(l=>map.removeLayer(l));markers=[];truckMarkers=[];truckLines=[];}
function renderSites(){
  dataset.forEach((site,idx)=>{
    const loss=siteLoss(site,idx),col=loss2col(loss),isK=site.city==='Kampala';
    const r=isK?14:['Entebbe','Mbarara','Jinja','Gulu','Nairobi'].includes(site.city)?11:9;
    if(loss>0.64){const halo=L.circleMarker([site.lat,site.lon],{radius:r+8,fillColor:'transparent',color:col,weight:1.2,opacity:0.35}).addTo(map);markers.push(halo);}
    const lk=synthLeakage(site,idx);
    const dRows=['cement','steel','labor','timber','elec'].map(k=>`<div class="lp-row"><span>${k}</span><span class="lp-rv" style="color:${loss2col(lk[k])}">${(lk[k]*100).toFixed(0)}%</span></div>`).join('');
    const m=L.circleMarker([site.lat,site.lon],{radius:r,fillColor:col,color:'rgba(255,255,255,0.15)',weight:1.5,opacity:1,fillOpacity:0.88}).addTo(map);
    m.bindPopup(`<div class="lp-name">${site.name}</div><div class="lp-val" style="color:${col}">${site.pct}% complete</div><div class="lp-rows"><div class="lp-row"><span>Phase</span><span class="lp-rv">${site.phase}</span></div><div class="lp-row"><span>Units</span><span class="lp-rv">${site.units}</span></div><div class="lp-row"><span>L(θ)</span><span class="lp-rv" style="color:${col}">${(loss*100).toFixed(1)}%</span></div>${dRows}<div class="lp-row"><span>Priority</span><span class="lp-rv">${loss>0.65?'🔴 Urgent':loss>0.40?'🟠 Watch':'🟢 On track'}</span></div></div>`);
    m.on('click',()=>{selectSite(site,idx);logA(`${site.name} · ${site.pct}% · L=${(loss*100).toFixed(1)}%`);});
    markers.push(m);
  });
}
function renderTrucks(){
  if(curLayer!=='logistics')return;
  if(!truckPct)truckPct=TRUCKS.map(t=>t.pct);
  TRUCKS.forEach((t,i)=>{
    const p=truckPct[i],lat=t.from[0]+(t.to[0]-t.from[0])*p,lon=t.from[1]+(t.to[1]-t.from[1])*p;
    const line=L.polyline([t.from,t.to],{color:'#2880d8',weight:1.5,dashArray:'5,7',opacity:0.5}).addTo(map);
    truckLines.push(line);
    const tm=L.circleMarker([lat,lon],{radius:7,fillColor:'#2880d8',color:'#fff',weight:1.5,opacity:1,fillOpacity:0.9}).bindPopup(`<div class="lp-name">${t.id} — ${t.name}</div><div class="lp-val" style="color:#2880d8">${t.cargo}</div><div class="lp-rows"><div class="lp-row"><span>Progress</span><span class="lp-rv">${Math.round(p*100)}%</span></div></div>`).addTo(map);
    truckMarkers.push(tm);
  });
}
function animateTrucks(){
  if(curLayer==='logistics'&&truckPct&&truckMarkers.length===TRUCKS.length){
    truckPct=truckPct.map((p,i)=>{const spd=[0.0005,0.0004,0.0008,0.0006][i];return p>=1?0:p+spd;});
    truckMarkers.forEach((m,i)=>{const t=TRUCKS[i],p=truckPct[i];m.setLatLng([t.from[0]+(t.to[0]-t.from[0])*p,t.from[1]+(t.to[1]-t.from[1])*p]);});
  }
  requestAnimationFrame(animateTrucks);
}
function renderAll(){
  clearMarkers();renderSites();
  if(curLayer==='logistics')renderTrucks();
  renderStats();renderLegend();renderTopList();
  if(selSite){const idx=SITES.findIndex(s=>s.id===selSite.id);if(idx>=0)selectSite(SITES[idx],idx);}
}
function selectSite(site,idx){
  selSite=site;const loss=siteLoss(site,idx),col=loss2col(loss),lk=synthLeakage(site,idx);
  document.getElementById('sel-panel').style.display='block';
  document.getElementById('sel-name').textContent=site.name;
  document.getElementById('sel-score').textContent=`${site.pct}% · L=${(loss*100).toFixed(1)}%`;
  document.getElementById('sel-score').style.color=col;
  document.getElementById('sel-dims').innerHTML=['cement','steel','labor','timber','elec'].map(k=>{const lv=lk[k],c=loss2col(lv),p=Math.round(lv*100);return`<div class="db-row"><div class="db-dot" style="background:${c}"></div><div class="db-name">${k}</div><div class="db-bar-bg"><div class="db-bar-fill" style="width:${p}%;background:${c}"></div></div><div class="db-val">${p}%</div></div>`;}).join('');
}
function renderStats(){
  const losses=dataset.map((s,i)=>siteLoss(s,i)),mean=losses.reduce((a,b)=>a+b,0)/losses.length,atRisk=losses.filter(l=>l>0.5).length;
  const lel=document.getElementById('st-loss');lel.textContent=(mean*100).toFixed(1)+'%';lel.style.color=loss2col(mean);
  document.getElementById('st-delta').textContent=mean>0.5?`↑ ${((mean-0.5)*100).toFixed(1)}pt above threshold`:`↓ ${((0.5-mean)*100).toFixed(1)}pt below threshold`;
  document.getElementById('st-delta').className='sc2-delta '+(mean>0.5?'bad':'good');
  document.getElementById('st-crit').textContent=atRisk+' / '+dataset.length;
}
function renderTopList(){
  const sorted=[...dataset].map((s,i)=>({s,i,loss:siteLoss(s,i)})).sort((a,b)=>b.loss-a.loss);
  window.__sm={};dataset.forEach((s,i)=>{window.__sm[s.id]={s,i};});
  document.getElementById('top-d').innerHTML=sorted.slice(0,8).map(({s,loss})=>`<div class="d-item" onclick="(function(){var si=window.__sm['${s.id}'];selectSite(si.s,si.i);})()"><div class="d-dot" style="background:${loss2col(loss)}"></div><span class="d-name">${s.name}</span><span class="d-val">${s.pct}%</span></div>`).join('');
}
function renderLegend(){
  const titles={completion:'Completion heatmap',leakage:'Leakage L(θ)',logistics:'Logistics / GPS',composite:'Composite L(θ)'};
  document.getElementById('leg-title').textContent=titles[curLayer];
  document.getElementById('leg-rows').innerHTML=[{col:RC[0],label:'0–20% / critical'},{col:RC[1],label:'20–36% / high'},{col:RC[2],label:'36–54% / moderate'},{col:RC[3],label:'54–72% / on track'},{col:RC[4],label:'72–87% / low loss'},{col:RC[5],label:'87–95% / managed'},{col:RC[6],label:'95–100% / complete'}].map(r=>`<div class="leg-row"><div class="leg-dot" style="background:${r.col}"></div><span>${r.label}</span></div>`).join('');
}
function updWeightLabels(){
  const w=getWeights(),T=Object.values(w).reduce((a,b)=>a+b,0);
  Object.entries(w).forEach(([k,v])=>{const el=document.getElementById('v-'+k);if(el)el.textContent=Math.round(v/T*100)+'%';});
  document.getElementById('v-eta').textContent=getEta().toFixed(2);
}
function logA(msg){
  const n=new Date(),t=[n.getHours(),n.getMinutes(),n.getSeconds()].map(x=>String(x).padStart(2,'0')).join(':');
  const el=document.getElementById('tlog'),e=document.createElement('div');
  e.className='te';e.innerHTML=`<span class="tt2">${t}</span><span class="ta">${msg}</span>`;
  el.prepend(e);if(el.children.length>22)el.removeChild(el.lastChild);
}
let sched_tmr=null;
function sched(){
  updWeightLabels();document.getElementById('upd').classList.add('on');
  clearTimeout(sched_tmr);
  sched_tmr=setTimeout(()=>{renderAll();document.getElementById('upd').classList.remove('on');},260);
}
function setLayer(btn,layer){
  document.querySelectorAll('.layer-btn').forEach(b=>b.classList.remove('on'));
  btn.classList.add('on');curLayer=layer;logA('Layer: '+layer);
  if(layer==='logistics')truckPct=TRUCKS.map(t=>t.pct);
  sched();
}
function setSc(btn,nm){
  document.querySelectorAll('.sc-btn').forEach(b=>b.classList.remove('on'));btn.classList.add('on');
  const sc={base:[35,25,20,12,8,10],cement:[55,15,15,10,5,12],finish:[20,20,20,20,20,28],logistics:[25,25,20,15,15,10],eigen:[48,28,12,8,4,15]};
  const v=sc[nm];['s-cement','s-steel','s-labor','s-timber','s-elec','s-eta'].forEach((id,i)=>{document.getElementById(id).value=v[i];});
  logA('Scenario: '+btn.childNodes[0].textContent.trim());sched();
}
document.getElementById('theme-btn').addEventListener('click',()=>{
  const next=document.documentElement.getAttribute('data-theme')==='dark'?'light':'dark';
  document.documentElement.setAttribute('data-theme',next);
  if(next==='dark'){map.removeLayer(lightTile);darkTile.addTo(map);}else{map.removeLayer(darkTile);lightTile.addTo(map);}
});
['s-cement','s-steel','s-labor','s-timber','s-elec','s-eta'].forEach(id=>{document.getElementById(id).addEventListener('input',sched);});
initMap();updWeightLabels();renderAll();requestAnimationFrame(animateTrucks);
logA('Strata Stone Geo Twin initialized');
logA('13 sites · Uganda + East Africa · real coordinates');
logA('Cement: systemic leakage signal detected');
logA('Tensor: 93 variables x 7 departments');
</script>
</body>
</html>
GEOEOF

# ── STEP 6: RENDER YAML ──────────────────────────────────────────
# API: Python web service
# UI:  React static site (ops-geo.html ends up at /ops-geo.html automatically)
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

# ── STEP 7: GITIGNORE ────────────────────────────────────────────
cat <<'EOF' > .gitignore
node_modules
.env
__pycache__
*.pyc
.DS_Store
EOF

# ── STEP 8: PUSH TO GITHUB ───────────────────────────────────────
echo ""
echo "🚀  Creating GitHub repo and pushing..."
echo ""

curl -s -X POST \
  -H "Authorization: token ${GH_TOKEN}" \
  -H "Content-Type: application/json" \
  https://api.github.com/user/repos \
  -d "{\"name\":\"${REPO_NAME}\",\"private\":true,\"description\":\"Strata Stone Digital Twin v4 — 93 vars + Geo Map\"}" \
  > /dev/null

git init
git add .
git commit -m "Strata Stone Digital Twin v4 — React dashboard + FastAPI + Geo Map (ops-geo.html)"
git branch -M main
git remote add origin "https://${GH_TOKEN}@github.com/${GH_USER}/${REPO_NAME}.git"
git push -u origin main --force

echo "✅  GitHub: https://github.com/${GH_USER}/${REPO_NAME}"

# ── STEP 9: TRIGGER RENDER BLUEPRINT ────────────────────────────
echo ""
echo "🌐  Triggering Render blueprint..."

curl -s -X POST \
  -H "Authorization: Bearer ${RENDER_KEY}" \
  -H "Content-Type: application/json" \
  https://api.render.com/v1/blueprints \
  -d "{\"repoURL\":\"https://github.com/${GH_USER}/${REPO_NAME}\",\"branch\":\"main\"}" \
  > /dev/null

# ── DONE ─────────────────────────────────────────────────────────
echo ""
echo "╔══════════════════════════════════════════════════════════════════╗"
echo "║  ✅  STRATA STONE DIGITAL TWIN v4 — DEPLOYED                    ║"
echo "╚══════════════════════════════════════════════════════════════════╝"
echo ""
echo "  GitHub  : https://github.com/${GH_USER}/${REPO_NAME}"
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  RENDER — IF BLUEPRINT DIDN'T AUTO-CREATE, DO THIS ONCE:"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "  1. dashboard.render.com → New + → Web Service"
echo "     Repo          : ${GH_USER}/${REPO_NAME}"
echo "     Environment   : Python"
echo "     Build Command : pip install -r backend/requirements.txt"
echo "     Start Command : cd backend && gunicorn main:app -w 2 -k uvicorn.workers.UvicornWorker --bind 0.0.0.0:\$PORT"
echo "     Env vars      : PROJECT_NAME=${PROJECT_NAME}  LOCATION=${LOCATION}"
echo ""
echo "  2. New + → Static Site"
echo "     Repo          : ${GH_USER}/${REPO_NAME}"
echo "     Root Dir      : frontend"
echo "     Build Command : npm install && npm run build"
echo "     Publish Dir   : build"
echo "     Env var       : REACT_APP_API_URL=https://${REPO_NAME}-api.onrender.com"
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  YOUR URLS (live after Render finishes ~3 min):"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "  API check  : https://${REPO_NAME}-api.onrender.com"
echo "               → should show: { status: Twin Active, variables: 93 }"
echo ""
echo "  Main app   : https://${REPO_NAME}-ui.onrender.com"
echo "               📊 Overview · 💧 Leakage · 🔬 Diagnosis · 🧊 Tensor"
echo "               📋 Operations (all 93 variables) · 📤 Upload CSV"
echo ""
echo "  Geo map    : https://${REPO_NAME}-ui.onrender.com/ops-geo.html"
echo "               🗺️  13 real sites · live trucks · 4 map layers"
echo "               → NOT linked from main app — share URL directly"
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"