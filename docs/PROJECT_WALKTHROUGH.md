# SaaS Business Analytics — Complete Project Walkthrough

## 1. Business scenario

Assume this is a SaaS company selling subscription plans to business customers. Management wants one analytical view of commercial performance, customer health, product engagement, and support operations.

The analyst's job is to answer business questions from operational data rather than build a prediction model.

## 2. End-to-end architecture

```text
Raw CSVs
   ↓
Data Quality Checks
   ↓
Cleaned Analytical Tables
   ↓
Python / Pandas EDA
   ↓
PostgreSQL SQL Analysis
   ↓
KPI Layer
   ↓
Power BI Dashboard
   ↓
Business Findings
   ↓
Management Investigation / Decision Support
```

## 3. Six datasets

### Customers
One row per customer. Contains signup date, country, industry, company size and segment.

### Plans
One row per plan. Contains plan name, monthly price and billing cycle.

### Subscriptions
One row per subscription. Links a customer to a plan and records lifecycle status.

### Payments
One row per payment transaction. Contains payment date, amount, payment status and payment method.

### Usage
One row per product usage event. Contains feature, login count and session minutes.

### Support
One row per support ticket. Contains date, priority, category, resolution time and status.

## 4. Relationships

```text
Customers 1 ────< Subscriptions >──── 1 Plans
                    |
                    └────< Payments

Customers 1 ────< Usage
Customers 1 ────< Support Tickets
```

This is the core relational model. Subscriptions acts as the bridge between customers, plans and payments.

## 5. Data-quality layer

Before calculating KPIs, check:

- primary-key uniqueness
- missing identifiers
- invalid dates
- negative/invalid durations
- customer foreign keys
- plan foreign keys
- subscription foreign keys
- duplicate transactions

The current cleaned layer has zero orphan relationships across the tested foreign-key paths.

## 6. Payment logic

The dataset contains three payment states:

- Paid — successful collection
- Refunded — money returned; stored as a negative amount
- Failed — transaction did not result in collection

Therefore:

```text
Gross Paid Revenue = SUM(Paid amounts)
Refund Value = ABS(SUM(Refunded amounts))
Net Collected Revenue = Paid amounts + Refunded amounts
```

For this dataset:

```text
250,380 + (-120,983) = 129,397
```

Failed amount is excluded.

## 7. Subscription health

Current lifecycle counts:

- Active: 965
- Cancelled: 263
- Churned: 130
- Total: 1,358

Observed subscription churn rate:

```text
130 / 1,358 × 100 = 9.57%
```

This is a descriptive status-based rate. It is not a cohort retention calculation.

## 8. Customer revenue

Customer lifetime paid revenue is calculated by joining payments to subscriptions and grouping successful payments by customer.

This allows:

- customer ranking
- revenue share
- top-customer concentration
- segment comparison

The top 10 customers contribute about 6.98% of paid revenue in this dataset.

## 9. Product analysis

Usage data answers:

- which features are used most often?
- how many logins are recorded?
- how much session time is generated?
- how does usage change by month?

Usage should be interpreted as behavioral evidence, not proof that a feature causes retention or revenue.

## 10. Support analysis

Support data answers:

- which priorities generate the most tickets?
- which categories generate the most demand?
- what is average resolution time?
- which customers generate repeated support demand?

Again, these are descriptive relationships.

## 11. SQL skills demonstrated

The project uses:

- SELECT / WHERE
- JOIN
- GROUP BY
- CASE
- CTEs
- aggregate functions
- window functions
- LAG
- DENSE_RANK
- FILTER
- NULLIF
- date truncation
- revenue-share calculations

The canonical portfolio SQL uses PostgreSQL syntax to match the target profile.

## 12. Python skills demonstrated

Python/Pandas is used for:

- loading CSV data
- data-quality profiling
- date parsing
- relationship validation
- joins
- aggregation
- KPI calculations
- monthly trends
- ranking
- exploratory visualization

## 13. Power BI design

### Page 1 — Executive Overview
Management-level KPIs and revenue trends.

### Page 2 — Customer & Subscription Health
Customer value, churn and subscription distribution.

### Page 3 — Product & Support Operations
Feature usage and support workload.

## 14. Interview explanation

A concise explanation is:

> I built an end-to-end SaaS business analytics project using Python, PostgreSQL, Excel and Power BI. I started by validating six relational datasets, cleaned and prepared them with Pandas, then used SQL to calculate revenue, customer, subscription, churn, product and support KPIs. Finally, I designed a three-page Power BI dashboard and translated the analysis into business observations. The main goal was to demonstrate how I move from a business question to reliable data, KPI calculation, dashboard reporting and business insight.

## 15. What the project demonstrates about the analyst

This project demonstrates the full Data Analyst workflow:

**Understand → Validate → Clean → Query → Measure → Visualize → Explain**

It should be discussed as a business analytics project, not as an ML project.
