# Power BI Dashboard Build Specification

## Page 1 — Executive Overview
**Cards:** Paid Revenue, Net Collected Revenue, Active Subscriptions, Churn Rate, Avg Customer Revenue.
**Visuals:** monthly revenue trend, revenue by plan, revenue by segment, active vs churned.
**Slicers:** Date, Plan, Country, Segment, Industry.

## Page 2 — Customer & Subscription Health
**Visuals:** churn by plan, churn by segment, top countries by revenue, customer lifetime revenue distribution, Top-10 revenue concentration.

## Page 3 — Product & Support Operations
**Visuals:** usage events by feature, monthly session minutes, ticket volume by category, average resolution time by priority.

## Core DAX measures
```DAX
Paid Revenue = CALCULATE(SUM(Payments[Amount]), Payments[Payment_Status] = "Paid")
Refund Value = ABS(CALCULATE(SUM(Payments[Amount]), Payments[Payment_Status] = "Refunded"))
Net Revenue = CALCULATE(SUM(Payments[Amount]), Payments[Payment_Status] IN {"Paid", "Refunded"})
Active Subscriptions = CALCULATE(COUNTROWS(Subscriptions), Subscriptions[Status] = "Active")
Churned Subscriptions = CALCULATE(COUNTROWS(Subscriptions), Subscriptions[Status] = "Churned")
Churn Rate = DIVIDE([Churned Subscriptions], COUNTROWS(Subscriptions))
Average Customer Revenue = AVERAGEX(VALUES(Customers[Customer_Id]), [Paid Revenue])
```

The repository also contains the supplied PBIX as a **reference artifact**. The custom dashboard visuals in `dashboard_images/` are the portfolio rebuild outputs; they should be used as the visual blueprint when recreating the report in Power BI Desktop.
