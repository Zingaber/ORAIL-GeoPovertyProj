# ORAIL CITIZEN AI – Geospatial Poverty Mapping Framework

**Open Source Responsible AI Literacy (ORAIL) Initiative**

📍 *Citizen-Centric AI + LLM + R + 3D Visualizations + Open Data Infrastructure*

---

## 🧭 Project Overview

`ORAIL-GeoPovertyProj` is a modular, open-source framework designed to enable researchers, citizens, and policymakers to perform **AI-powered poverty mapping and spatial analysis**. It integrates rural datasets (census, satellite, mobile, OSM), ML pipelines (XGBoost, CNN), agentic systems (LangChain, OpenAI), and R-based 3D rendering for impactful insights.

---

## 💻 System Configuration (Dev Setup)

| Component     | Configuration |
|---------------|---------------|
| Project Dir   | `C:/Users/josze/MYRworkspace-CitizenAI-poverty-mapping` |
| Python        | 3.12.3 (Anaconda) |
| TensorFlow    | 2.19.0 |
| PyTorch       | 2.5.1 |
| GPU           | NVIDIA GeForce RTX 4070 |
| IDE           | Cursor IDE |
| Platform      | Windows 11 |

---

## 🏗️ Project Structure

```bash
MYRworkspace-CitizenAI-poverty-mapping/
├── config/              # Python + R environments, API keys
├── data/                # Raw, processed, and cache data
├── models/              # ML models and configs
├── outputs/             # Maps (2D/3D), reports, charts
├── scripts/             # Python, R, SQL scripts
├── notebooks/           # Exploratory + modeling notebooks
├── docs/                # MkDocs GitHub Pages site
├── .github/, .vscode/   # CI/CD & IDE config


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
📘https://github.com/Zingaber/ORAIL-GeoPovertyProj.git

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
>>>>>>> 7d666744302e7a0d299cbf874dd9c3b6c335b69b
