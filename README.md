# ORAIL-GeoPovertyProj

# 🌍 ORAIL-GeoPovertyProj

**Open Responsible AI Lab – Geospatial Poverty Mapping**  
📍 *Citizen-Centric AI + LLM + R + 3D Visualizations + Open Data Infrastructure*

---

## 🧭 Overview

`ORAIL-GeoPovertyProj` is a modular, open-source initiative to build **AI-powered geospatial intelligence** tools for poverty mapping. It integrates **multi-source rural datasets** (census, satellite, mobile, OSM), AI/ML pipelines (XGBoost, CNN), and **agentic systems** powered by **LangChain, OpenAI, and R-based rendering** for deep socio-economic insight.

Designed as a public-good project, this platform enables **citizens, researchers, and governments** to:
- 📊 Visualize poverty across space and time
- 🧠 Leverage LLMs for participatory insights
- 🛰️ Fuse satellite + open source data pipelines
- 🕸️ Run agentic workflows for real-time decision support

---

## 🏗️ Project Structure

```
├── data/                  # Raw, processed, and cache data layers
│   ├── raw/               # Input sources: census, OSM, satellite, mobile
│   ├── processed/         # Cleaned & feature-engineered datasets
├── models/                # ML models: XGBoost, CNN, Ensemble
├── outputs/
│   ├── maps/              # 2D/3D rendered poverty maps
│   ├── reports/           # PDF and HTML reports
├── scripts/               # Modular scripts: Python, R, SQL
├── config/                # API keys, environment variables
├── notebooks/             # Jupyter/VSCode notebooks
├── docs/                  # MkDocs-based GitHub Pages site
├── .github/               # GitHub workflows (CI/CD)
```

---

## 🔧 Key Features

| Capability                  | Description                                                                 |
|----------------------------|-----------------------------------------------------------------------------|
| 🧬 Agentic AI               | LangChain & MCP-based AI agents for querying, analysis, and synthesis       |
| 📈 3D Poverty Maps          | R + rayshader + satellite fusion for immersive spatial poverty visualization |
| 🤖 LLM Orchestration        | OpenAI and Anthropic models connected via function-calling & LangChain       |
| 🧩 Modular Pipelines        | Clean architecture for data → features → ML → visualization                  |
| 🌐 Citizen Data Dashboards  | Future-ready UI integrations for community insights and local action         |

---

## 📦 Tech Stack

- **Languages**: Python, R, SQL, YAML
- **ML/AI**: XGBoost, CNN, LangChain, OpenAI, Transformers
- **Geospatial**: GeoPandas, Rasterio, OSMnx, rayshader
- **3D Viz**: R + `rayshader`, Blender-ready outputs
- **Agents**: MCP (Model Context Protocol), LangChain
- **Frontend**: MkDocs (Material Theme) + GitHub Pages
- **Data**: Census, satellite imagery, mobile indicators, OSM

---

## 🚀 Getting Started

```bash
# Clone the repo
git clone https://github.com/YOUR_USERNAME/ORAIL-GeoPovertyProj.git
cd ORAIL-GeoPovertyProj

# Setup environment
conda env create -f config/environment.yml
conda activate orail_env

# Run system scan (optional)
powershell -ExecutionPolicy Bypass -File system_inventory_cursor_plus_fixed.ps1

# Launch MkDocs documentation
mkdocs serve
```

---

## 📚 Documentation

Explore the full interactive documentation and module explorer at:  
📘 [https://yourusername.github.io/ORAIL-GeoPovertyProj](https://yourusername.github.io/ORAIL-GeoPovertyProj)

---

## 🧠 Contributors & Credits

This project integrates learnings from:
- ADB Citizen AI Manual 2030
- OpenAI, LangChain, and MCP architectures
- R-based geospatial rendering systems
- MIT Data + Development Lab standards

🧑‍💻 Maintainer: [Joseph Thomas / Alswamitra.org](https://alswamitra.org)

---

## 📜 License

This project is released under the [MIT License](LICENSE).

---

## 🙌 Contributing

We welcome contributions to models, datasets, and agent workflows.
To contribute:
1. Fork the repository
2. Create a feature branch
3. Submit a pull request with documentation

---

> “AI for dignity, equity, and scale. A better life. For the many.”
> — *ORAIL Initiative, 2025*
