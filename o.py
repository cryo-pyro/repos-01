# ukb_renal_epsilon_sgd_prototype_svg_html.py
# Exact same math + data as before, but now auto-generates a perfect self-contained HTML
# with BOTH charts as fully embedded SVGs (no placeholders, no blanks, infinitely scalable)

import torch
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns
import io

# ====================== SYNTHETIC DATA (same as before) ======================
np.random.seed(42)
torch.manual_seed(42)

N_DISTRICTS = 146
N_OBSERVED = 11

population = np.random.lognormal(mean=12.65, sigma=0.6, size=N_DISTRICTS)
population = (population / population.sum() * 45_905_417).astype(int)

facilities = np.random.poisson(lam=15, size=N_DISTRICTS)
facilities[:N_OBSERVED] += np.random.poisson(lam=25, size=N_OBSERVED)

X = np.column_stack([population, facilities]).astype(np.float32)
X = (X - X.mean(axis=0)) / X.std(axis=0)

epsilon = np.ones(N_DISTRICTS, dtype=np.float32)
epsilon[:N_OBSERVED] = 0.0

true_burden = 0.0008 * population + 0.3 * facilities + np.random.normal(0, 5, N_DISTRICTS)
true_burden = np.clip(true_burden, 5, 55).astype(np.float32)

y_obs = true_burden[:N_OBSERVED].copy()

# ====================== PYTORCH ε-SGD (unchanged) ======================
class BurdenPredictor(torch.nn.Module):
    def __init__(self):
        super().__init__()
        self.linear = torch.nn.Linear(2, 1)
    
    def forward(self, x):
        return self.linear(x).squeeze(-1)

model = BurdenPredictor()
optimizer = torch.optim.SGD(model.parameters(), lr=0.05, momentum=0.9)
criterion = torch.nn.MSELoss()

X_tensor = torch.from_numpy(X)
y_obs_tensor = torch.from_numpy(y_obs)

lambda_epsilon = 0.8
epochs = 1200

for epoch in range(epochs):
    optimizer.zero_grad()
    pred = model(X_tensor)
    loss_obs = criterion(pred[:N_OBSERVED], y_obs_tensor)
    loss_epsilon = lambda_epsilon * (epsilon * (pred - torch.from_numpy(true_burden))**2).mean()
    loss = loss_obs + loss_epsilon
    loss.backward()
    optimizer.step()

pred_final = model(X_tensor).detach().numpy()

# ====================== QUANTIFICATION (same brutal numbers) ======================
pop_covered = population[:N_OBSERVED].sum()
pop_blank = population.sum() - pop_covered
print(f"Population covered by published data: {pop_covered/1e6:.1f}M ({pop_covered/population.sum()*100:.1f}%)")
print(f"Population in 135 blanks: {pop_blank/1e6:.1f}M ({pop_blank/population.sum()*100:.1f}%)")

# ====================== VISUALISATION 1: BAR CHART (as SVG) ======================
fig1 = plt.figure(figsize=(12, 6))
epsilon_weighted_burden = epsilon * pred_final
top20_idx = np.argsort(epsilon_weighted_burden)[-20:][::-1]

bars = plt.bar(range(20), epsilon_weighted_burden[top20_idx], 
               color=sns.color_palette("Reds", 20))
plt.title('Top 20 Districts by ε-weighted Burden (the "gravity wells" SGD is now descending)')
plt.xlabel('District ID (synthetic)')
plt.ylabel('ε × Predicted Kidney Burden')
plt.xticks(range(20), top20_idx, rotation=45)
plt.grid(axis='y', alpha=0.3)
plt.tight_layout()

bar_svg_io = io.StringIO()
fig1.savefig(bar_svg_io, format='svg', bbox_inches='tight')
bar_svg = bar_svg_io.getvalue()
plt.close(fig1)

# ====================== VISUALISATION 2: SCATTER (as SVG) ======================
fig2 = plt.figure(figsize=(10, 7))
scatter = plt.scatter(population, pred_final, 
                      c=epsilon, cmap='RdYlGn_r', s=80, alpha=0.85,
                      edgecolors='k', linewidth=0.5)

plt.colorbar(scatter, label='ε (Missingness)', ticks=[0, 1])
plt.title('Predicted Burden vs Population\n(green = data districts, red = ε=1 blanks)')
plt.xlabel('Population')
plt.ylabel('Predicted Burden')
plt.grid(alpha=0.3)
plt.tight_layout()

scatter_svg_io = io.StringIO()
fig2.savefig(scatter_svg_io, format='svg', bbox_inches='tight')
scatter_svg = scatter_svg_io.getvalue()
plt.close(fig2)

# ====================== AUTO-GENERATE SELF-CONTAINED HTML ======================
html = f"""<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>UKB Renal Atlas — ε-SGD Visuals (SVG)</title>
    <style>
        body {{ font-family: system-ui, sans-serif; margin: 40px; background: #f8f9fa; }}
        h1 {{ text-align: center; color: #1a1a1a; margin: 40px 0 20px; }}
        svg {{ max-width: 100%; height: auto; display: block; margin: 30px auto; border: 1px solid #ddd; background: white; box-shadow: 0 4px 12px rgba(0,0,0,0.1); }}
        .container {{ max-width: 1100px; margin: 0 auto; padding: 20px; }}
        .note {{ text-align: center; color: #555; font-size: 0.95em; margin-top: 40px; }}
    </style>
</head>
<body>
    <div class="container">
        <h1>Top 20 Districts by ε-weighted Burden<br>(the "gravity wells" SGD is now descending)</h1>
        {bar_svg}

        <h1>Predicted Burden vs Population<br>(green = data districts, red = ε=1 blanks)</h1>
        {scatter_svg}

        <div class="note">
            ✅ These are real vector SVGs — zoom forever, no pixelation.<br>
            Generated {__import__('datetime').datetime.now().strftime('%Y-%m-%d %H:%M')} from the exact ε-SGD run.<br>
            Copy this HTML file anywhere or drop it straight into your repo/Atlas UI.
        </div>
    </div>
</body>
</html>"""

with open('ukb_renal_svgs.html', 'w', encoding='utf-8') as f:
    f.write(html)

print("✅ DONE!")
print("   Full self-contained HTML created → ukb_renal_svgs.html")
print("   Open it in any browser — the charts are now crisp vectors (no blanks).")
print("   The file is 100% standalone — you can email it, upload it, or embed it directly.")