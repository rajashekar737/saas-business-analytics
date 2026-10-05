# SaaS Business Performance & Customer Analytics

**Raja Shekar Ponnam — Data Analyst | Business Analytics | SQL | Python | Power BI**

An end-to-end **business analytics portfolio project** built to demonstrate the exact workflow I am targeting for entry-level Data Analyst and Business Analytics roles:

> **Business problem → Data validation → Data cleaning → SQL/Python analysis → KPI reporting → Power BI dashboard → Business insight**

## About the project

This project analyzes a SaaS business across **revenue, customers, subscriptions, churn, product usage, and support operations**. The objective is not to build a machine-learning model; it is to show how a Data Analyst converts operational data into measurable business insights and decision-support reporting.

### Business questions
- How is revenue performing over time?
- Which plans, countries, segments, and industries contribute revenue?
- What is the observed subscription churn rate?
- Which customer groups require closer retention monitoring?
- How concentrated is revenue among high-value customers?
- Which product features receive the most usage?
- Where is support demand concentrated?
- How can management use KPIs to investigate commercial and customer-health changes?

## My analytics workflow

1. **Understand the business problem** and define measurable questions.
2. **Validate the data** for duplicates, missing values, invalid dates, key integrity, and relationship consistency.
3. **Clean and prepare the data** using Python/Pandas.
4. **Analyze business performance** using SQL and Python.
5. **Build KPI definitions** that can be reproduced in a dashboard.
6. **Create Power BI reporting** for executive, customer/subscription, and product/support views.
7. **Translate findings into business observations** without claiming unsupported causality.

## Dataset model

The project contains six related business datasets:

| Dataset | Purpose |
|---|---|
| Customers | Customer profile and segmentation attributes |
| Plans | Subscription plan information |
| Subscriptions | Subscription lifecycle and status |
| Payments | Payment, refund, and failure transactions |
| Product Usage | Feature/session activity |
| Support Tickets | Customer support demand and resolution |

## Current dataset snapshot

| Dataset | Rows |
|---|---:|
| Customers | 1,500 |
| Plans | 3 |
| Subscriptions | 1,358 |
| Payments | 2,813 |
| Usage events | 22,702 |
| Support tickets | 716 |

## KPI snapshot

| KPI | Value |
|---|---:|
| Paid Revenue | 250,380 |
| Refund Value | 120,983 |
| Net Collected Revenue | 129,397 |
| Active Subscriptions | 965 |
| Churned Subscriptions | 130 |
| Observed Churn Rate | 9.57% |
| Top-10 Revenue Share | 6.98% |

> These are descriptive metrics from the supplied dataset. They are not evidence of causal relationships.

## Tools used

**Primary:** Python, Pandas, SQL, PostgreSQL, Power BI, Excel

**Python analytics:** data validation, cleaning, EDA, aggregation, KPI calculations, visualization

**SQL:** joins, CTEs, CASE expressions, aggregates, subqueries, window functions, ranking, monthly trend analysis

**Power BI:** KPI cards, trend analysis, segmentation, churn monitoring, product usage and support reporting

## Repository structure

```text
data/raw/                  supplied source datasets
data/cleaned/              cleaned analytical datasets
notebooks/                 Python data-quality and business-EDA notebooks
sql/                       SQL analysis and PostgreSQL scripts
powerbi/                   dashboard specification and reference artifact
dashboard_images/         dashboard/report visuals
excel/                    Excel KPI workbook
docs/                      findings, methodology, profile alignment, attribution
portfolio/                ready-to-use portfolio copy
```

## Profile alignment

This project is intentionally aligned to my target professional profile:

**Raja Shekar Ponnam**  
B.Tech — Computer Science & Data Science  
Target: **Data Analyst / Business Analytics**

Core skills demonstrated through this project:

- SQL
- Python
- Pandas
- Data Cleaning
- Data Preprocessing
- Exploratory Data Analysis
- KPI Development
- Business Analytics
- Data Visualization
- Power BI
- Excel
- PostgreSQL

The project avoids positioning me as an AI/ML engineer. Machine learning is part of my broader academic skill set, but this portfolio project specifically demonstrates **data analysis and business decision support**.

## Portfolio / GitHub positioning

**Suggested project title:** SaaS Business Performance & Customer Analytics

**One-line description:** End-to-end SaaS analytics project using Python, SQL, PostgreSQL, Power BI, and Excel to analyze revenue, customers, subscriptions, churn, product usage, and support performance.

## Attribution

This project started from an open-source SaaS analytics reference. The reference is preserved in `docs/ATTRIBUTION.md`. The portfolio version has been reorganized and customized around a Data Analyst / Business Analytics workflow, including business questions, KPI framing, analysis structure, documentation, and reporting artifacts.

Do not remove attribution or present reused source assets as independently authored work.

## Professional links

- **Portfolio:** https://raja-portfolio-nine.vercel.app/
- **GitHub:** https://github.com/rajashekar737
- **Email:** ponnamrajashekar3@gmail.com
- **Location:** Hyderabad, Telangana, India
