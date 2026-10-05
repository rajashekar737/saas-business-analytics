# Project Test Report

## Test status
**Passed with corrections applied.**

### Data integrity tests
- Customers: 1,500 rows / 1,500 unique Customer_Id
- Plans: 3 rows / 3 unique Plan_Id
- Subscriptions: 1,358 rows / 1,358 unique Subscription_Id
- Payments: 2,813 rows / 2,813 unique Payment_Id
- Usage: 22,702 rows / 22,702 unique Usage_Id
- Support: 716 rows / 716 unique Ticket_Id
- Subscription → Customer orphan records: 0
- Subscription → Plan orphan records: 0
- Payment → Subscription orphan records: 0
- Usage → Customer orphan records: 0
- Support → Customer orphan records: 0

### Payment logic correction
The original portfolio layer used total payment amount as “net collected revenue”. This incorrectly included **Failed** transactions. The corrected definition is:

**Net Collected Revenue = Paid Amount + Refunded Amount**

Because refunded transactions are negative in the dataset:

**250,380 - 120,983 = 129,397**

Failed transaction amount of 126,694 is excluded.

### Subscription KPI
- Active: 965
- Cancelled: 263
- Churned: 130
- Total: 1,358
- Observed churn rate using all subscriptions: 9.57%

The metric is explicitly labeled as an observed subscription churn rate rather than a cohort retention metric.

### Notebook execution
- `SaaS_Data_Quality_Cleaning.ipynb`: executed successfully.
- `SaaS_Business_EDA.ipynb`: executed successfully.

### SQL
The canonical portfolio SQL was converted to **PostgreSQL syntax** to match the user's target skill profile. MySQL-specific `DATE_FORMAT()` and boolean aggregation patterns were removed from the canonical portfolio layer.

### Power BI
The dashboard specification was updated so Net Revenue excludes Failed payments and includes Paid + Refunded transactions.

## Remaining manual validation
Open the PBIX in Power BI Desktop and refresh the model against the cleaned datasets. The PBIX is retained as a reference artifact; the repository's dashboard specification is the authoritative build guide for the customized portfolio version.
