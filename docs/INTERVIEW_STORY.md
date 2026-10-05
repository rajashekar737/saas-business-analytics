# Interview Story — 60 Second Version

I built an end-to-end SaaS business analytics project to demonstrate how I approach a real Data Analyst problem. I started with six related datasets covering customers, plans, subscriptions, payments, product usage, and support tickets. I first validated the data and handled quality issues using Python and Pandas. Then I used SQL/PostgreSQL to calculate business KPIs and investigate revenue, customer value, churn, product engagement, and support performance. Finally, I structured the results into Power BI reporting and an Excel KPI workbook. The main focus was not machine learning; it was turning raw business data into reliable metrics and clear insights that a business team could use.

## Common follow-up questions

### Why did you use both Python and SQL?
Python was useful for data-quality checks, cleaning, exploratory analysis, and repeatable calculations. SQL was useful for relational analysis, joins, aggregations, KPI queries, and business reporting logic.

### Why Power BI?
Power BI makes the analysis accessible to business stakeholders through KPI cards, trends, segmentation, and interactive filtering.

### What was the hardest part?
The important part was making metric definitions consistent across multiple related datasets, especially revenue, subscription status, and churn.

### What would you improve next?
I would add cohort retention analysis, a formal date dimension, more granular revenue-recognition rules, and a production database pipeline if the project were deployed in a real business environment.
