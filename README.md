# Prostate Cancer Metastasis Prediction

**Genomics and Science Dojo 2.0 — Team 6**
Dzakwanil Hakim · Elizabeth Loho
School of Life Sciences and Technology, Bandung Institute of Technology

---

## 🏆 Achievement

**3rd Place — Genomics and Science Dojo 2.0** (Feb 2025), supported by the British Embassy Jakarta & UK International Development.

---

## Overview

This project develops machine learning models to predict prostate adenocarcinoma metastasis using RNA-seq gene expression data from TCGA (743 samples: 52 normal, 592 non-metastatic, 99 metastatic). A two-step feature selection pipeline (DEG analysis → Lasso-Logistic Regression) identified three candidate biomarkers: **MYH11**, **PRMT1**, and **TENT4A**. An Artificial Neural Network classifier trained on these three genes achieved the best generalization performance on external validation.

---

## Repository Structure

```
prostate-cancer-metastasis-prediction/
├── data/
│   ├── raw/                        # GDC manifest for TCGA download
│   └── processed/                  # Feature importance table (Lasso coefficients)
├── src/
│   ├── samplesheet/                # Clinical metadata preparation (R)
│   ├── preprocessing/              # Data cleaning, normalization, combining (R)
│   ├── feature_selection/          # DESeq2 DEG analysis + pre-ML filtering (R)
│   ├── models/                     # Lasso-LR, RF, ANN, SVM classification (Python/Jupyter)
│   └── visualization/              # Volcano plot, violin plot, methyl-RNA plot (R)
├── notebooks/                      # Exploratory draft notebooks (not for production)
├── results/
│   ├── figures/                    # PCA plot, volcano plot, class distribution
│   └── models/                     # Saved .pkl model files
└── docs/
    └── presentation/               # Poster and slides (GSD 2.0)
```

---

## Pipeline

```
TCGA RNA-seq (GDC)
    └── src/samplesheet/       → clinical metadata + sample IDs
    └── src/preprocessing/     → KNN imputation, DESeq2 + VST normalization
    └── src/feature_selection/ → DEG (q<0.01), Lasso-LR + RF feature importance
    └── src/models/            → ANN / SVM / Logistic Regression classification
    └── src/visualization/     → Figures for publication/poster
```

---

## Key Results

| Model | Cross-val F1 | External Val F1 |
|---|---|---|
| Lasso-Logistic Regression | 100% | — |
| Neural Network | ~99% | **Best** |
| SVM | ~99% | Overfits |

Identified biomarkers:
- **MYH11** — downregulated; cytoskeleton disorganization → easier tumor cell detachment
- **PRMT1** — upregulated; EMT induction via E-cadherin/ZEB1/β-catenin axis
- **TENT4A** — upregulated; mRNA stability regulation → oncogene expression modulation

---

## Data Access

Raw RNA-seq count matrices are not included due to size. Download via GDC using the manifest:

```bash
gdc-client download -m data/raw/gdc_manifest.txt -d data/raw/
```

---

## Requirements

**R packages:** `DESeq2`, `limma`, `edgeR`, `ggplot2`, `dplyr`, `impute`

**Python packages:** `scikit-learn`, `torch` / `tensorflow`, `pandas`, `numpy`, `matplotlib`, `shap`

---

## Deployed Model

An interactive prediction app built with Streamlit is available at:

**[https://github.com/dzakwanilhakim/PMD3](https://github.com/dzakwanilhakim/PMD3)**

To run locally:

```bash
git clone https://github.com/dzakwanilhakim/PMD3
cd PMD3
pip install -r requirements.txt
streamlit run app.py
```

---

## Citation

> Hakim D., Loho E. (2025). *Lasso-Logistic Regression and Artificial Neural Network for Prostate Adenocarcinoma Metastasis Prediction and Biomarker Discovery Based on Gene Expression Profile.* Genomics and Science Dojo 2.0, British Embassy Jakarta.
