# Olist E-Commerce Analysis 🛒

End-to-end data analysis project using Python, SQL Server and Power BI on a real Brazilian e-commerce dataset with 100k+ orders.

## Business Questions
- Which product categories have the highest freight-to-price ratio, reducing margins?
- How do delivery delays impact customer satisfaction?
- Which states generate the most revenue and have the worst delivery performance?
- Which sellers have high revenue but poor customer satisfaction?

## Key Insights
- 📦 Orders delayed by just 1-7 days drop review score from 4.2 to 2.99 — a 29% satisfaction loss
- 🚚 Northern states (AM, AP, RR) average 27+ delivery days vs 8 days in SP
- 🛋️ Furniture categories show 30%+ freight-to-price ratio, significantly reducing margins
- ⭐ health_beauty leads in revenue ($1.4M) with a strong 4.19 avg review score
- 📈 The business grew 10x in 14 months, peaking at $1.2M during Black Friday 2017

## Tech Stack
- **Python** (pandas) — ETL pipeline
- **SQL Server** — data modeling and analytical queries
- **Power BI** — interactive dashboard

## Project Structure
\```
olist-ecommerce-analysis/
├── notebooks/
│   ├── 01_exploracion.ipynb   # EDA
│   └── 02_etl.ipynb           # ETL pipeline
├── sql/
│   └── 01_analisis_rentabilidad.sql  # Analytical queries
└── .gitignore
\```

## Dataset
[Brazilian E-Commerce by Olist](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce) — 100k orders, 9 tables, 2016-2018
