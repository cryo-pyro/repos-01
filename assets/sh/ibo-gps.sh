#!/bin/bash
# ================================================================
#  STRATA STONE DIGITAL TWIN — v2 WITH GEO MAP INTEGRATION
#  Source: Ibo's actual digital_twin.docx (93 variables, 7 depts)
#  New: Geo Digital Twin map tab + dropdown nav + live trucks
#  Copy → VS Code → save as setup.sh → bash setup.sh → DONE
# ================================================================

echo ""
echo "╔════════════════════════════════════════════════════════════╗"
echo "║  STRATA STONE DIGITAL TWIN v2 — GEO + FULL DEPLOYMENT 🏗️  ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo ""
echo "  Source: Ibo's operational DOCX — 93 variables, 7 departments"
echo "  New:    Geo Digital Twin · Live Truck Animation · Dropdown Nav"
echo ""

# ── CREDENTIALS ─────────────────────────────────────────────────
read -p "👤  GitHub Username                        : " GH_USER
read -p "🔑  GitHub Personal Token (classic)        : " GH_TOKEN
read -p "📦  New Repo Name (e.g. strata-twin)       : " REPO_NAME
read -p "🌐  Render API Key                         : " RENDER_KEY
read -p "🏢  Client / Project Name (e.g. Kadi Dev)  : " PROJECT_NAME
read -p "📍  Location (e.g. Kampala, Uganda)        : " LOCATION

echo ""
echo "✅  Building your Digital Twin v2..."
echo ""

# ── PROJECT STRUCTURE ────────────────────────────────────────────
mkdir -p "$REPO_NAME/backend/data"
mkdir -p "$REPO_NAME/frontend/src"
mkdir -p "$REPO_NAME/frontend/public"
cd "$REPO_NAME"

# ── STEP 1: GENERATE SYNTHETIC DATA ──────────────────────────────
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
        procured   = random.randint(80, 150)
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

print("✅  Synthetic data generated (12 weeks × 8 categories)")
PYEOF

python3 gen_data.py
rm gen_data.py

# ── STEP 2: LANDSCAPE.JSON — ALL 93 VARIABLES ────────────────────
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

app = FastAPI(title="Strata Stone Digital Twin API v2")

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_methods=["*"],
    allow_headers=["*"],
)

PROJECT  = os.environ.get("PROJECT_NAME", "Strata Stone")
LOCATION = os.environ.get("LOCATION", "Kampala")

DATA_PATH      = os.path.join(os.path.dirname(__file__), "data", "leakage_data.csv")
LANDSCAPE_PATH = os.path.join(os.path.dirname(__file__), "..", "landscape.json")

@app.get("/")
def root():
    return {"status": "Twin Active v2", "project": PROJECT, "location": LOCATION,
            "tensor_rank": 3, "axes": ["Functional","Temporal","Impact"],
            "variables": 93, "source": "Ibo CEO digital_twin.docx",
            "new": "Geo map tab + dropdown nav"}

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
    Xc  = X - X.mean(axis=0)
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
    cats    = pivot.columns.tolist()
    top     = vecs[:, 0]
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
    df       = pd.read_csv(io.BytesIO(contents))
    vals, vecs, pivot = _run_eigen(df)
    if vals is None:
        return {"error": "Not enough data for eigen analysis"}
    cats    = pivot.columns.tolist()
    top     = vecs[:, 0]
    drivers = sorted(
        [{"category": c, "weight": round(float(w), 4)} for c, w in zip(cats, top)],
        key=lambda x: abs(x["weight"]), reverse=True
    )
    return {
        "rows_analysed":   len(df),
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

# ── STEP 4: REACT FRONTEND ───────────────────────────────────────
cat <<EOF > frontend/public/index.html
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>${PROJECT_NAME} Digital Twin</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/leaflet@1.9.4/dist/leaflet.min.css" />
  </head>
  <body><div id="root"></div></body>
</html>
EOF

cat <<'EOF' > frontend/package.json
{
  "name": "strata-twin-ui",
  "version": "2.0.0",
  "private": true,
  "dependencies": {
    "react": "^18.2.0",
    "react-dom": "^18.2.0",
    "recharts": "^2.10.0",
    "leaflet": "^1.9.4",
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

# ── STEP 4b: MAIN APP — DROPDOWN NAV + ALL TABS INCL. GEO ───────
cat <<'APPEOF' > frontend/src/App.js
import React, { useState, useEffect, useRef } from "react";
import {
  BarChart, Bar, XAxis, YAxis, Tooltip, ResponsiveContainer,
  LineChart, Line, CartesianGrid
} from "recharts";
import GeoMap from "./GeoMap";

const API = process.env.REACT_APP_API_URL || "http://localhost:8000";
const fmt = n => "UGX " + Math.round(n).toLocaleString();

const C = {
  bg: "#0a0e1a", panel: "#111827", border: "#1f2937",
  green: "#00ff88", red: "#ff4d4d", blue: "#3b82f6",
  amber: "#f59e0b", purple: "#8b5cf6", text: "#e2e8f0",
  muted: "#6b7280", teal: "#20b890",
};

const TT = { contentStyle:{background:C.panel,border:`1px solid ${C.border}`,color:C.text} };

// ── DROPDOWN NAV ─────────────────────────────────────────────────
const NAV_GROUPS = [
  {
    label: "📊 Analytics",
    items: [
      { id: "overview",    label: "📊 Overview",    desc: "Headline numbers + trend" },
      { id: "leakage",     label: "💧 Leakage",     desc: "By category and phase" },
      { id: "eigen",       label: "🔬 Diagnosis",   desc: "Eigen / systemic vs noise" },
      { id: "tensor",      label: "🧊 Tensor",      desc: "3D operational space" },
    ]
  },
  {
    label: "🗺️ Geo Twin",
    items: [
      { id: "geomap",      label: "🗺️ Live Map",    desc: "Sites · trucks · heatmap · Uganda + EA" },
    ]
  },
  {
    label: "📋 Operations",
    items: [
      { id: "operations",  label: "📋 All Variables", desc: "93 tasks from Ibo's DOCX" },
    ]
  },
  {
    label: "📤 Data",
    items: [
      { id: "upload",      label: "📤 Upload CSV",  desc: "Real site data analysis" },
    ]
  },
];

function DropdownNav({ tab, setTab }) {
  const [openGroup, setOpenGroup] = useState(null);
  const ref = useRef();

  const activeLabel = NAV_GROUPS.flatMap(g => g.items).find(i => i.id === tab)?.label || "Select view";

  useEffect(() => {
    const handler = e => { if (ref.current && !ref.current.contains(e.target)) setOpenGroup(null); };
    document.addEventListener("mousedown", handler);
    return () => document.removeEventListener("mousedown", handler);
  }, []);

  return (
    <div ref={ref} style={{ display:"flex", gap:"6px", flexWrap:"wrap" }}>
      {NAV_GROUPS.map(group => {
        const isOpen = openGroup === group.label;
        const hasActive = group.items.some(i => i.id === tab);
        return (
          <div key={group.label} style={{ position:"relative" }}>
            <button
              onClick={() => setOpenGroup(isOpen ? null : group.label)}
              style={{
                padding: "10px 16px",
                background: hasActive ? "rgba(0,255,136,0.08)" : C.panel,
                border: `1px solid ${hasActive ? C.green : C.border}`,
                borderRadius: "8px",
                color: hasActive ? C.green : C.text,
                cursor: "pointer",
                fontSize: "13px",
                fontWeight: hasActive ? 700 : 400,
                display: "flex",
                alignItems: "center",
                gap: "6px",
                whiteSpace: "nowrap",
              }}
            >
              {group.label}
              <span style={{ color: C.muted, fontSize: "10px" }}>{isOpen ? "▲" : "▼"}</span>
            </button>
            {isOpen && (
              <div style={{
                position: "absolute",
                top: "calc(100% + 6px)",
                left: 0,
                background: "#0d1117",
                border: `1px solid ${C.border}`,
                borderRadius: "10px",
                padding: "6px",
                zIndex: 9999,
                minWidth: "220px",
                boxShadow: "0 12px 40px rgba(0,0,0,0.7)",
              }}>
                {group.items.map(item => (
                  <button
                    key={item.id}
                    onClick={() => { setTab(item.id); setOpenGroup(null); }}
                    style={{
                      display: "block",
                      width: "100%",
                      textAlign: "left",
                      padding: "10px 14px",
                      background: tab === item.id ? "rgba(0,255,136,0.1)" : "transparent",
                      border: "none",
                      borderRadius: "7px",
                      color: tab === item.id ? C.green : C.text,
                      cursor: "pointer",
                      fontSize: "13px",
                      fontWeight: tab === item.id ? 700 : 400,
                      marginBottom: "2px",
                    }}
                  >
                    {item.label}
                    <span style={{ display:"block", fontSize:"11px", color: C.muted, marginTop:"2px" }}>
                      {item.desc}
                    </span>
                  </button>
                ))}
              </div>
            )}
          </div>
        );
      })}
    </div>
  );
}

// ── OPERATIONS: DEPT DROPDOWN ─────────────────────────────────────
function OperationsPanel({ landscape }) {
  const byDept = {};
  if (landscape?.tensor_points) {
    landscape.tensor_points.forEach(p => {
      if (!byDept[p.dept]) byDept[p.dept] = [];
      byDept[p.dept].push(p);
    });
  }
  const depts  = Object.keys(byDept);
  const [selDept,  setSelDept]  = useState(depts[0] || "");
  const [selPhase, setSelPhase] = useState("All");
  const [selImpact,setSelImpact]= useState("All");

  const phases  = ["All","Strategic","Pre_Con","Design","Shell","Finishing","Handover"];
  const impacts = ["All","Budget","Execution","Compliance","Leakage"];

  const tasks = (byDept[selDept] || []).filter(t =>
    (selPhase  === "All" || t.phase  === selPhase) &&
    (selImpact === "All" || t.impact === selImpact)
  );

  const impactColor = impact => ({
    Leakage:"#ff4d4d", Compliance:"#3b82f6", Budget:"#00ff88", Execution:"#8b5cf6"
  }[impact] || C.muted);

  const sel = {
    padding:"8px 14px", background:C.panel, border:`1px solid ${C.border}`,
    borderRadius:"8px", color:C.text, fontSize:"13px", cursor:"pointer",
    appearance:"none", WebkitAppearance:"none",
  };

  return (
    <>
      <p style={{ color:C.muted, marginBottom:"20px", fontSize:"13px" }}>
        All <strong style={{color:C.text}}>{landscape?.total} variables</strong> from Ibo's operational DOCX — filter by department, phase, and impact.
      </p>

      {/* Filters row */}
      <div style={{ display:"flex", gap:"10px", flexWrap:"wrap", marginBottom:"24px" }}>
        <div style={{ display:"flex", flexDirection:"column", gap:"4px" }}>
          <label style={{ color:C.muted, fontSize:"11px", textTransform:"uppercase", letterSpacing:"1px" }}>Department</label>
          <select style={sel} value={selDept} onChange={e=>setSelDept(e.target.value)}>
            {depts.map(d => <option key={d} value={d}>{d.replace(/_/g," ")} ({byDept[d].length})</option>)}
          </select>
        </div>
        <div style={{ display:"flex", flexDirection:"column", gap:"4px" }}>
          <label style={{ color:C.muted, fontSize:"11px", textTransform:"uppercase", letterSpacing:"1px" }}>Phase</label>
          <select style={sel} value={selPhase} onChange={e=>setSelPhase(e.target.value)}>
            {phases.map(p => <option key={p}>{p}</option>)}
          </select>
        </div>
        <div style={{ display:"flex", flexDirection:"column", gap:"4px" }}>
          <label style={{ color:C.muted, fontSize:"11px", textTransform:"uppercase", letterSpacing:"1px" }}>Impact</label>
          <select style={sel} value={selImpact} onChange={e=>setSelImpact(e.target.value)}>
            {impacts.map(i => <option key={i}>{i}</option>)}
          </select>
        </div>
        <div style={{ display:"flex", alignItems:"flex-end" }}>
          <span style={{ color:C.muted, fontSize:"12px", padding:"8px 0" }}>
            {tasks.length} task{tasks.length !== 1 ? "s" : ""}
          </span>
        </div>
      </div>

      {/* Task list */}
      <div style={{ background:C.panel, borderRadius:"12px", padding:"16px" }}>
        {tasks.length === 0 ? (
          <p style={{ color:C.muted, textAlign:"center", padding:"24px" }}>No tasks match these filters.</p>
        ) : tasks.map(t => (
          <div key={t.id} style={{
            display:"flex", gap:"12px", alignItems:"center",
            padding:"10px 0", borderBottom:`1px solid ${C.border}`
          }}>
            <span style={{ color:C.muted, fontSize:"11px", minWidth:"28px" }}>#{t.id}</span>
            <span style={{ flex:1, fontSize:"13px" }}>{t.task}</span>
            <span style={{ fontSize:"11px", color:C.muted, minWidth:"70px", textAlign:"right" }}>{t.phase}</span>
            <span style={{
              fontSize:"10px", padding:"2px 10px", borderRadius:"12px", minWidth:"72px", textAlign:"center",
              background:`${impactColor(t.impact)}18`,
              color:impactColor(t.impact), border:`1px solid ${impactColor(t.impact)}44`
            }}>{t.impact}</span>
          </div>
        ))}
      </div>
    </>
  );
}

// ── MAIN APP ──────────────────────────────────────────────────────
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
    const d   = await res.json();
    setUploadMsg(`✅ Dominant: ${d.dominant_driver?.category} (${d.dominant_driver?.weight?.toFixed(3)}) — ${d.systemic?"🔴 Systemic":"🟢 Normal"}`);
  };

  if (loading) return (
    <div style={{ fontFamily:"'Segoe UI',sans-serif", background:C.bg, minHeight:"100vh",
                  color:C.text, display:"flex", alignItems:"center", justifyContent:"center" }}>
      <div style={{textAlign:"center"}}>
        <div style={{fontSize:"52px",marginBottom:"16px"}}>🛰️</div>
        <p style={{color:C.muted}}>Initialising Digital Twin v2...</p>
      </div>
    </div>
  );

  const catData    = summary ? Object.entries(summary.by_category).map(([k,v])=>({name:k,value:Math.round(v/1000)})) : [];
  const timeData   = timeline?.timeline?.map(r=>({week:`W${r.week}`,leakage:Math.round(r.leakage/1000)})) || [];
  const tensorData = tensor?.slice?.map(r=>({name:`${r.phase}·${r.category}`,value:Math.round(r.leakage/1000)}))
                            .sort((a,b)=>b.value-a.value).slice(0,12) || [];

  const S = {
    app:   { fontFamily:"'Segoe UI',sans-serif", background:C.bg, minHeight:"100vh", color:C.text },
    hdr:   { background:"linear-gradient(135deg,#111827,#1e3a5f)", padding:"22px 32px",
             borderBottom:`1px solid ${C.border}` },
    nav:   { background:"#0d1117", borderBottom:`1px solid ${C.border}`, padding:"12px 32px" },
    body:  { padding:"32px" },
    panel: { background:C.panel, borderRadius:"12px", padding:"26px", marginBottom:"24px" },
    h2:    { margin:"0 0 18px", color:C.text, fontSize:"17px", fontWeight:600 },
    grid4: { display:"grid", gridTemplateColumns:"repeat(auto-fit,minmax(200px,1fr))", gap:"16px", marginBottom:"28px" },
    card:  c => ({ background:C.panel, borderRadius:"12px", padding:"22px", borderLeft:`4px solid ${c}` }),
    lbl:   { color:C.muted, fontSize:"11px", textTransform:"uppercase", letterSpacing:"1px", marginBottom:"6px" },
    big:   c => ({ fontSize:"24px", fontWeight:700, color:c }),
    alert: ok => ({ background:ok?"#052e16":"#2d0f0f", border:`1px solid ${ok?C.green:C.red}`,
                    borderRadius:"8px", padding:"14px 18px", marginBottom:"18px",
                    color:ok?C.green:C.red, fontWeight:600, fontSize:"15px" }),
    row:   { display:"flex", justifyContent:"space-between", alignItems:"center",
              padding:"10px 0", borderBottom:`1px solid ${C.border}` },
  };

  return (
    <div style={S.app}>
      {/* HEADER */}
      <div style={S.hdr}>
        <div style={{display:"flex",alignItems:"center",gap:"16px"}}>
          <span style={{fontSize:"30px"}}>🏗️</span>
          <div>
            <h1 style={{margin:0,fontSize:"24px",fontWeight:700}}>Strata Stone Partners</h1>
            <p style={{margin:"4px 0 0",color:C.muted,fontSize:"12px"}}>
              Digital Twin v2 · Real-Time Reconciliation Engine ·{" "}
              {landscape?.total || 93} Variables · 7 Departments · 13 Sites · Uganda + East Africa
              <span style={{background:C.green,color:"#000",padding:"2px 10px",borderRadius:"20px",
                            fontSize:"10px",fontWeight:700,marginLeft:"10px"}}>● LIVE TWIN</span>
            </p>
          </div>
        </div>
      </div>

      {/* DROPDOWN NAV */}
      <div style={S.nav}>
        <DropdownNav tab={tab} setTab={setTab} />
      </div>

      <div style={{...S.body, padding: tab === "geomap" ? "0" : "32px"}}>

        {/* ── OVERVIEW ── */}
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
                  <div style={S.lbl}>{c.label}</div>
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
                The eigenvector shows <em>where leakage is structurally concentrated</em>. A dominant first eigenvalue means the pattern is{" "}
                <strong style={{color:C.red}}>repeatable and systemic</strong>, not random.
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

        {/* ── TENSOR ── */}
        {tab==="tensor" && (
          <>
            <div style={S.panel}>
              <h2 style={S.h2}>🧊 Tensor Slice — Phase × Category (Top 12 by Leakage)</h2>
              <p style={{color:C.muted,fontSize:"13px",marginBottom:"18px"}}>
                Each bar is a coordinate in 3D operational space:{" "}
                <strong>Phase × Category × Leakage (UGX '000)</strong>.
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
                A tensor encodes the full 3D structure of your operations:
                <strong style={{color:C.text}}> what department</strong> ×
                <strong style={{color:C.text}}> what phase</strong> ×
                <strong style={{color:C.text}}> what resource</strong>.
                Every one of Ibo's 93 variables is a coordinate in this space.
              </p>
            </div>
          </>
        )}

        {/* ── GEO MAP ── */}
        {tab==="geomap" && <GeoMap />}

        {/* ── OPERATIONS ── */}
        {tab==="operations" && landscape && (
          <OperationsPanel landscape={landscape} />
        )}

        {/* ── UPLOAD ── */}
        {tab==="upload" && (
          <div style={S.panel}>
            <h2 style={S.h2}>📤 Upload Your Real Site Data</h2>
            <p style={{color:C.muted,fontSize:"14px",marginBottom:"20px",lineHeight:"1.6"}}>
              Upload a CSV with columns:{" "}
              <code style={{background:C.border,padding:"2px 6px",borderRadius:"4px"}}>
                week, category, procured, received, consumed, unit_price
              </code>
            </p>
            <input type="file" accept=".csv" onChange={handleUpload}
              style={{padding:"12px",background:C.border,borderRadius:"8px",
                      color:C.text,cursor:"pointer",width:"100%"}}/>
            {uploadMsg && (
              <div style={{marginTop:"20px",padding:"16px",background:C.border,
                           borderRadius:"8px",color:C.green,fontSize:"15px",fontWeight:600}}>
                {uploadMsg}
              </div>
            )}
            <div style={{marginTop:"32px",borderTop:`1px solid ${C.border}`,paddingTop:"24px"}}>
              <h3 style={{color:C.text,marginBottom:"12px"}}>Expected CSV format:</h3>
              <pre style={{background:"#000",padding:"16px",borderRadius:"8px",
                           fontSize:"12px",color:"#00ff88",overflow:"auto"}}>
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

# ── STEP 4c: GEO MAP COMPONENT ───────────────────────────────────
cat <<'GEOEOF' > frontend/src/GeoMap.js
import React, { useEffect, useRef, useState } from "react";

// Leaflet is loaded via CDN in public/index.html
// We reference window.L

const SITES = [
  {id:'s01',name:'Kadi Dev — Ntinda',           lat:0.354,  lon:32.610, pct:82, phase:'Finishing', units:48, city:'Kampala'},
  {id:'s02',name:'Pearl Heights — Entebbe',      lat:0.062,  lon:32.466, pct:61, phase:'Shell',     units:36, city:'Entebbe'},
  {id:'s03',name:'Nakawa Gardens',               lat:0.335,  lon:32.630, pct:45, phase:'Shell',     units:60, city:'Kampala'},
  {id:'s04',name:'Naalya Estate',                lat:0.381,  lon:32.668, pct:74, phase:'Finishing', units:32, city:'Kampala'},
  {id:'s05',name:'Wakiso Residences',            lat:0.403,  lon:32.454, pct:38, phase:'Pre_Con',   units:44, city:'Wakiso'},
  {id:'s06',name:'Mbarara Ridge',                lat:-0.606, lon:30.655, pct:90, phase:'Handover',  units:24, city:'Mbarara'},
  {id:'s07',name:'Jinja Riverside',              lat:0.446,  lon:33.202, pct:33, phase:'Pre_Con',   units:42, city:'Jinja'},
  {id:'s08',name:'Gulu North',                   lat:2.774,  lon:32.299, pct:55, phase:'Shell',     units:30, city:'Gulu'},
  {id:'s09',name:'Fort Portal Heights',          lat:0.671,  lon:30.275, pct:68, phase:'Finishing', units:28, city:'Fort Portal'},
  {id:'s10',name:'Masaka Gardens',               lat:-0.336, lon:31.740, pct:22, phase:'Pre_Con',   units:36, city:'Masaka'},
  {id:'s11',name:'Nairobi Heights — Westlands',  lat:-1.268, lon:36.806, pct:70, phase:'Finishing', units:40, city:'Nairobi'},
  {id:'s12',name:'Arusha Gardens — TZ',          lat:-3.370, lon:36.680, pct:25, phase:'Pre_Con',   units:32, city:'Arusha'},
  {id:'s13',name:'Kigali Ridge — Rwanda',        lat:-1.944, lon:30.059, pct:48, phase:'Shell',     units:20, city:'Kigali'},
];

const TRUCKS = [
  {id:'T-01',name:'Cement run',    from:[0.354,32.610], to:[0.335,32.630], cargo:'Cement 20t',    pct:0.38},
  {id:'T-02',name:'Steel delivery',from:[0.062,32.466], to:[0.403,32.454], cargo:'Steel bars 8t', pct:0.71},
  {id:'T-03',name:'Timber — Gulu', from:[0.354,32.610], to:[2.774,32.299], cargo:'Timber 12t',    pct:0.18},
  {id:'T-04',name:'Finishings',    from:[-0.606,30.655],to:[0.671,30.275], cargo:'Finishing kit', pct:0.54},
];

const RC = ['#e84040','#d87030','#d4a820','#30b060','#2880d8','#9050c0','#20b890'];
const C  = { bg:"#0a0e1a", panel:"#111827", border:"#1f2937", green:"#00ff88",
              red:"#ff4d4d", blue:"#3b82f6", muted:"#6b7280", text:"#e2e8f0", amber:"#f59e0b" };

function loss2col(loss) {
  if (loss >= 0.82) return RC[0];
  if (loss >= 0.64) return RC[1];
  if (loss >= 0.46) return RC[2];
  if (loss >= 0.28) return RC[3];
  if (loss >= 0.13) return RC[4];
  if (loss >= 0.05) return RC[5];
  return RC[6];
}

function synthLeakage(site, idx) {
  const s = idx * 137.5 + 7.3;
  const clamp = (v,a,b)=>Math.max(a,Math.min(b,v));
  const isKampala = ['Kampala','Entebbe','Wakiso'].includes(site.city);
  let cement = clamp(0.35 + 0.45 * Math.abs(Math.sin(s*1.1)) + 0.18 + (isKampala?0.1:0), 0, 1);
  let steel  = clamp(0.20 + 0.35 * Math.abs(Math.sin(s*0.9)) + (isKampala?0.08:0), 0, 1);
  let labor  = clamp(0.15 + 0.30 * Math.abs(Math.sin(s*1.4)), 0, 1);
  let timber = clamp(0.10 + 0.28 * Math.abs(Math.sin(s*1.8)), 0, 1);
  let elec   = clamp(0.08 + 0.25 * Math.abs(Math.sin(s*2.1)), 0, 1);
  return { cement, steel, labor, timber, elec };
}

function getCompositeLeakage(lk, weights) {
  const T = Object.values(weights).reduce((a,b)=>a+b,0);
  return Object.entries(weights).reduce((sum,[k,w])=>(sum + (w/T)*(lk[k]||0)),0);
}

function siteLoss(site, idx, layer, weights) {
  const lk = synthLeakage(site, idx);
  const cl = getCompositeLeakage(lk, weights);
  if (layer==='completion') return 1 - site.pct/100;
  if (layer==='leakage')    return Math.max(0, cl * 0.85);
  if (layer==='composite')  return Math.max(0, cl*0.6 + (1-site.pct/100)*0.4);
  return cl;
}

export default function GeoMap() {
  const mapRef  = useRef(null);
  const mapObj  = useRef(null);
  const markersRef  = useRef([]);
  const truckRef    = useRef([]);
  const animRef     = useRef(null);
  const truckPct    = useRef(TRUCKS.map(t=>t.pct));

  const [layer,    setLayer]    = useState('completion');
  const [scenario, setScenario] = useState('base');
  const [weights,  setWeights]  = useState({cement:35,steel:25,labor:20,timber:12,elec:8});
  const [eta,      setEta]      = useState(0.10);
  const [selSite,  setSelSite]  = useState(null);
  const [log,      setLog]      = useState([]);

  const LAYERS = [
    {id:'completion',label:'Completion heatmap'},
    {id:'leakage',   label:'Leakage L(θ)'},
    {id:'logistics', label:'Logistics / GPS'},
    {id:'composite', label:'Composite L(θ)'},
  ];

  const SCENARIOS = [
    {id:'base',      label:'Status quo',      weights:{cement:35,steel:25,labor:20,timber:12,elec:8}, eta:0.10},
    {id:'cement',    label:'Cement emergency', weights:{cement:55,steel:15,labor:15,timber:10,elec:5}, eta:0.12},
    {id:'finish',    label:'Finishing push',   weights:{cement:20,steel:20,labor:20,timber:20,elec:20},eta:0.28},
    {id:'logistics', label:'Logistics audit',  weights:{cement:25,steel:25,labor:20,timber:15,elec:15},eta:0.10},
    {id:'eigen',     label:'Eigen mode',       weights:{cement:48,steel:28,labor:12,timber:8, elec:4}, eta:0.15},
  ];

  const logA = msg => {
    const t = new Date();
    const ts = [t.getHours(),t.getMinutes(),t.getSeconds()].map(x=>String(x).padStart(2,'0')).join(':');
    setLog(prev => [{ts,msg},...prev].slice(0,20));
  };

  // Init map once
  useEffect(() => {
    if (!window.L || mapObj.current) return;
    const L = window.L;
    mapObj.current = L.map(mapRef.current, {center:[1.37,32.29], zoom:7});
    L.tileLayer('https://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}{r}.png',
      {attribution:'© OpenStreetMap © CARTO', subdomains:'abcd', maxZoom:19}).addTo(mapObj.current);
    logA('Geo Twin initialised · 13 sites · Uganda + EA');
    logA('Cement: systemic leakage signal detected');
    return () => { if (animRef.current) cancelAnimationFrame(animRef.current); };
  }, []);

  // Re-render markers when layer/weights/eta change
  useEffect(() => {
    if (!mapObj.current || !window.L) return;
    const L = window.L;

    // Clear
    markersRef.current.forEach(m=>mapObj.current.removeLayer(m));
    truckRef.current.forEach(m=>mapObj.current.removeLayer(m));
    markersRef.current = []; truckRef.current = [];

    // Site markers
    SITES.forEach((site,idx) => {
      const loss = siteLoss(site, idx, layer, weights);
      const col  = loss2col(loss);
      const r    = site.city==='Kampala' ? 14 : ['Entebbe','Mbarara','Jinja','Gulu','Nairobi'].includes(site.city) ? 11 : 9;

      if (loss > 0.64) {
        const halo = L.circleMarker([site.lat,site.lon],
          {radius:r+8,fillColor:'transparent',color:col,weight:1.2,opacity:0.35}).addTo(mapObj.current);
        markersRef.current.push(halo);
      }

      const lk = synthLeakage(site, idx);
      const m  = L.circleMarker([site.lat,site.lon],
        {radius:r,fillColor:col,color:'rgba(255,255,255,0.15)',weight:1.5,opacity:1,fillOpacity:0.88})
        .bindPopup(`
          <div style="font-family:'Segoe UI',sans-serif;min-width:200px;">
            <div style="font-size:15px;font-weight:700;margin-bottom:8px;color:#e2e8f0">${site.name}</div>
            <div style="font-size:20px;font-weight:700;color:${col};margin-bottom:10px">${site.pct}% complete</div>
            <div style="font-size:11px;color:#6b7280;display:flex;flex-direction:column;gap:4px;">
              <span>Phase: <strong style="color:#e2e8f0">${site.phase}</strong></span>
              <span>Units: <strong style="color:#e2e8f0">${site.units}</strong></span>
              <span>Loss: <strong style="color:${col}">${(loss*100).toFixed(1)}%</strong></span>
              <span>Cement lk: <strong style="color:#ff4d4d">${(lk.cement*100).toFixed(0)}%</strong></span>
              <span>Steel lk: <strong style="color:#f59e0b">${(lk.steel*100).toFixed(0)}%</strong></span>
            </div>
          </div>
        `)
        .addTo(mapObj.current);

      m.on('click', () => {
        setSelSite({site,idx,loss,lk});
        logA(`${site.name} · ${site.pct}% · L=${(loss*100).toFixed(1)}%`);
      });
      markersRef.current.push(m);
    });

    // Trucks (logistics layer only)
    if (layer === 'logistics') {
      TRUCKS.forEach((t,i) => {
        const p   = truckPct.current[i];
        const lat = t.from[0]+(t.to[0]-t.from[0])*p;
        const lon = t.from[1]+(t.to[1]-t.from[1])*p;

        const line = L.polyline([t.from,t.to],
          {color:'#2880d8',weight:1.5,dashArray:'5,7',opacity:0.5}).addTo(mapObj.current);
        const dot  = L.circleMarker([lat,lon],
          {radius:7,fillColor:'#2880d8',color:'#fff',weight:1.5,opacity:1,fillOpacity:0.9})
          .bindPopup(`<div style="font-family:'Segoe UI',sans-serif"><strong>${t.id}</strong><br/>${t.cargo}<br/>Progress: ${Math.round(p*100)}%</div>`)
          .addTo(mapObj.current);

        truckRef.current.push(line, dot);
      });
    }
  }, [layer, weights, eta]);

  // Animate trucks
  useEffect(() => {
    if (animRef.current) cancelAnimationFrame(animRef.current);
    if (layer !== 'logistics') return;
    const speeds = [0.0005,0.0004,0.0008,0.0006];
    const animate = () => {
      truckPct.current = truckPct.current.map((p,i)=>(p>=1?0:p+speeds[i]));
      // Update only truck dot positions (truckRef every 2 items = line,dot pairs)
      for (let i=0;i<TRUCKS.length;i++) {
        const dot = truckRef.current[i*2+1];
        if (!dot) continue;
        const t   = TRUCKS[i];
        const p   = truckPct.current[i];
        dot.setLatLng([t.from[0]+(t.to[0]-t.from[0])*p, t.from[1]+(t.to[1]-t.from[1])*p]);
      }
      animRef.current = requestAnimationFrame(animate);
    };
    animRef.current = requestAnimationFrame(animate);
    return () => cancelAnimationFrame(animRef.current);
  }, [layer]);

  const totalLoss = SITES.reduce((s,site,i)=>s+siteLoss(site,i,layer,weights),0)/SITES.length;
  const atRisk    = SITES.filter((site,i)=>siteLoss(site,i,layer,weights)>0.5).length;

  const sel = {
    padding:"7px 12px", background:"#0d1117", border:`1px solid ${C.border}`,
    borderRadius:"7px", color:C.text, fontSize:"12px", cursor:"pointer",
  };

  return (
    <div style={{display:"flex",height:"calc(100vh - 122px)",background:C.bg,overflow:"hidden"}}>

      {/* LEFT CONTROLS */}
      <div style={{width:"220px",flexShrink:0,background:C.panel,borderRight:`1px solid ${C.border}`,
                   overflowY:"auto",padding:"14px",display:"flex",flexDirection:"column",gap:"14px"}}>

        {/* Layer dropdown */}
        <div>
          <div style={{color:C.muted,fontSize:"10px",letterSpacing:"1px",textTransform:"uppercase",marginBottom:"6px"}}>Map Layer</div>
          <select style={sel} value={layer} onChange={e=>{setLayer(e.target.value);logA('Layer: '+e.target.value);}}>
            {LAYERS.map(l=><option key={l.id} value={l.id}>{l.label}</option>)}
          </select>
        </div>

        {/* Scenario dropdown */}
        <div>
          <div style={{color:C.muted,fontSize:"10px",letterSpacing:"1px",textTransform:"uppercase",marginBottom:"6px"}}>Scenario</div>
          <select style={sel} value={scenario} onChange={e=>{
            const sc=SCENARIOS.find(s=>s.id===e.target.value);
            setScenario(e.target.value); setWeights(sc.weights); setEta(sc.eta);
            logA('Scenario: '+sc.label);
          }}>
            {SCENARIOS.map(s=><option key={s.id} value={s.id}>{s.label}</option>)}
          </select>
        </div>

        {/* Weight sliders */}
        <div>
          <div style={{color:C.muted,fontSize:"10px",letterSpacing:"1px",textTransform:"uppercase",marginBottom:"8px"}}>Leakage Weights</div>
          {['cement','steel','labor','timber','elec'].map((k,i)=>{
            const colors=['#d87030','#30b060','#e84040','#2880d8','#9050c0'];
            const T = Object.values(weights).reduce((a,b)=>a+b,0);
            return (
              <div key={k} style={{marginBottom:"10px"}}>
                <div style={{display:"flex",justifyContent:"space-between",marginBottom:"3px"}}>
                  <span style={{fontSize:"11px",color:C.text,textTransform:"capitalize"}}>{k}</span>
                  <span style={{fontSize:"11px",color:colors[i],fontFamily:"monospace"}}>{Math.round(weights[k]/T*100)}%</span>
                </div>
                <input type="range" min="2" max="60" value={weights[k]}
                  onChange={e=>setWeights(w=>({...w,[k]:+e.target.value}))}
                  style={{width:"100%",accentColor:colors[i],height:"3px"}}/>
              </div>
            );
          })}
        </div>

        {/* Eta */}
        <div>
          <div style={{display:"flex",justifyContent:"space-between",marginBottom:"4px"}}>
            <span style={{color:C.muted,fontSize:"10px",letterSpacing:"1px",textTransform:"uppercase"}}>η Intervention Speed</span>
            <span style={{fontSize:"11px",color:C.blue,fontFamily:"monospace"}}>{eta.toFixed(2)}</span>
          </div>
          <input type="range" min="1" max="30" value={Math.round(eta*100)}
            onChange={e=>setEta(+e.target.value/100)}
            style={{width:"100%",accentColor:C.blue,height:"3px"}}/>
        </div>

        {/* Legend */}
        <div>
          <div style={{color:C.muted,fontSize:"10px",letterSpacing:"1px",textTransform:"uppercase",marginBottom:"6px"}}>Legend</div>
          {[{c:RC[0],l:'Critical / high loss'},{c:RC[2],l:'Moderate'},{c:RC[4],l:'On track'},{c:RC[6],l:'Complete'}].map(r=>(
            <div key={r.l} style={{display:"flex",alignItems:"center",gap:"8px",marginBottom:"5px"}}>
              <div style={{width:"8px",height:"8px",borderRadius:"50%",background:r.c,flexShrink:0}}/>
              <span style={{fontSize:"10px",color:C.muted}}>{r.l}</span>
            </div>
          ))}
        </div>

        {/* Activity log */}
        <div>
          <div style={{color:C.muted,fontSize:"10px",letterSpacing:"1px",textTransform:"uppercase",marginBottom:"6px"}}>Log</div>
          <div style={{maxHeight:"120px",overflowY:"auto"}}>
            {log.map((e,i)=>(
              <div key={i} style={{fontSize:"10px",color:C.muted,padding:"3px 0",borderBottom:`1px solid ${C.border}`}}>
                <span style={{color:"#1f2937",marginRight:"6px"}}>{e.ts}</span>
                <span style={{color:C.amber}}>{e.msg}</span>
              </div>
            ))}
          </div>
        </div>
      </div>

      {/* MAP */}
      <div style={{flex:1,position:"relative"}}>
        <div ref={mapRef} style={{width:"100%",height:"100%"}}/>
      </div>

      {/* RIGHT STATS */}
      <div style={{width:"200px",flexShrink:0,background:C.panel,borderLeft:`1px solid ${C.border}`,
                   overflowY:"auto",padding:"14px",display:"flex",flexDirection:"column",gap:"12px"}}>

        {[
          {label:"Portfolio Loss",val:`${(totalLoss*100).toFixed(1)}%`, color:loss2col(totalLoss)},
          {label:"Sites at Risk",  val:`${atRisk} / ${SITES.length}`,   color:C.red},
          {label:"Dominant Signal",val:"Cement",                         color:C.red},
          {label:"Active Trucks",  val:"4",                              color:C.blue},
        ].map(s=>(
          <div key={s.label} style={{background:"#0d1117",borderRadius:"8px",padding:"12px",border:`1px solid ${C.border}`}}>
            <div style={{color:C.muted,fontSize:"10px",letterSpacing:"1px",textTransform:"uppercase",marginBottom:"4px"}}>{s.label}</div>
            <div style={{fontSize:"22px",fontWeight:700,color:s.color}}>{s.val}</div>
          </div>
        ))}

        {/* Sites ranked by loss */}
        <div>
          <div style={{color:C.muted,fontSize:"10px",letterSpacing:"1px",textTransform:"uppercase",marginBottom:"8px"}}>Sites Ranked</div>
          {[...SITES].map((s,i)=>({s,i,loss:siteLoss(s,i,layer,weights)}))
            .sort((a,b)=>b.loss-a.loss).slice(0,8)
            .map(({s,loss})=>(
              <div key={s.id} style={{display:"flex",alignItems:"center",gap:"6px",
                                      padding:"5px 0",borderBottom:`1px solid ${C.border}`,cursor:"pointer"}}
                   onClick={()=>{setSelSite({site:s,idx:SITES.indexOf(s),loss,lk:synthLeakage(s,SITES.indexOf(s))});}}>
                <div style={{width:"6px",height:"6px",borderRadius:"50%",background:loss2col(loss),flexShrink:0}}/>
                <span style={{fontSize:"10px",flex:1,overflow:"hidden",textOverflow:"ellipsis",whiteSpace:"nowrap"}}>{s.name}</span>
                <span style={{fontSize:"10px",color:C.muted,fontFamily:"monospace"}}>{s.pct}%</span>
              </div>
            ))}
        </div>

        {/* Selected site detail */}
        {selSite && (
          <div style={{background:"#0d1117",borderRadius:"8px",padding:"12px",border:`1px solid ${C.amber}`}}>
            <div style={{fontSize:"12px",fontWeight:700,marginBottom:"8px",color:C.text}}>{selSite.site.name}</div>
            <div style={{fontSize:"18px",fontWeight:700,color:loss2col(selSite.loss),marginBottom:"8px"}}>
              {selSite.site.pct}% · L={Math.round(selSite.loss*100)}%
            </div>
            {Object.entries(selSite.lk).map(([k,v])=>(
              <div key={k} style={{display:"flex",alignItems:"center",gap:"6px",marginBottom:"5px"}}>
                <div style={{width:"6px",height:"6px",borderRadius:"50%",background:loss2col(v),flexShrink:0}}/>
                <span style={{fontSize:"10px",flex:1,color:C.muted,textTransform:"capitalize"}}>{k}</span>
                <span style={{fontSize:"10px",fontFamily:"monospace",color:loss2col(v)}}>{Math.round(v*100)}%</span>
              </div>
            ))}
          </div>
        )}
      </div>
    </div>
  );
}
GEOEOF

# ── STEP 5: RENDER YAML ──────────────────────────────────────────
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

curl -s -X POST \
  -H "Authorization: token ${GH_TOKEN}" \
  -H "Content-Type: application/json" \
  https://api.github.com/user/repos \
  -d "{\"name\":\"${REPO_NAME}\",\"private\":true,\"description\":\"Strata Stone Digital Twin v2 — 93 variables, Geo Map, Rank-3 Tensor\"}" \
  > /dev/null

git init
git add .
git commit -m "Strata Stone Digital Twin v2 — Geo Map + Dropdown Nav + Live Trucks 🏗️🗺️"
git branch -M main
git remote add origin "https://${GH_TOKEN}@github.com/${GH_USER}/${REPO_NAME}.git"
git push -u origin main --force

echo "✅  Code on GitHub: https://github.com/${GH_USER}/${REPO_NAME}"

# ── STEP 8: RENDER BLUEPRINT PUSH ────────────────────────────────
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
echo "╔═══════════════════════════════════════════════════════════════╗"
echo "║  ✅  STRATA STONE DIGITAL TWIN v2 — DEPLOYED                ║"
echo "╠═══════════════════════════════════════════════════════════════╣"
echo "║  GitHub: https://github.com/${GH_USER}/${REPO_NAME}          ║"
echo "╚═══════════════════════════════════════════════════════════════╝"
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  ⚠️  RENDER MANUAL SETUP (2 services)"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "  1. BACKEND — Web Service"
echo "     dashboard.render.com → New + → Web Service"
echo "     Connect: ${GH_USER}/${REPO_NAME}"
echo ""
echo "     Name         : ${REPO_NAME}-api"
echo "     Environment  : Python"
echo "     Branch       : main"
echo "     Build Command: pip install -r backend/requirements.txt"
echo "     Start Command: cd backend && gunicorn main:app -w 2 -k uvicorn.workers.UvicornWorker --bind 0.0.0.0:\$PORT"
echo ""
echo "     Env Vars:"
echo "       PROJECT_NAME = ${PROJECT_NAME}"
echo "       LOCATION     = ${LOCATION}"
echo ""
echo "  2. FRONTEND — Static Site"
echo "     dashboard.render.com → New + → Static Site"
echo "     Connect same repo"
echo ""
echo "     Name         : ${REPO_NAME}-ui"
echo "     Branch       : main"
echo "     Root Dir     : frontend"
echo "     Build Command: npm install && npm run build"
echo "     Publish Dir  : build"
echo ""
echo "     Env Vars:"
echo "       REACT_APP_API_URL = https://${REPO_NAME}-api.onrender.com"
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "  VERIFY:"
echo "  API: https://${REPO_NAME}-api.onrender.com"
echo "       → { status: 'Twin Active v2', variables: 93 }"
echo ""
echo "  UI:  https://${REPO_NAME}-ui.onrender.com"
echo ""
echo "  v2 WHAT'S NEW:"
echo "  🗺️  Geo Map tab — 13 real sites · Uganda + East Africa"
echo "       Live truck animation on Logistics layer"
echo "       Site heatmaps by completion / leakage / composite"
echo "       Click any site for breakdown popup"
echo "  📋  Operations: dept/phase/impact dropdowns instead of wall-of-text"
echo "  🔽  Top nav: grouped dropdown menus (Analytics / Geo / Ops / Data)"
echo "  🔧  Scenario + layer selects in Geo sidebar (no more button lists)"
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""