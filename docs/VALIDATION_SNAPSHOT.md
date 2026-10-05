# Validation Snapshot

This snapshot is generated from the cleaned datasets included in this portfolio rebuild.

- **Customers:** 1500
- **Plans:** 3
- **Subscriptions:** 1358
- **Payments:** 2813
- **Paid Revenue:** 250380.0
- **Refunded Amount:** 120983.0
- **Active Subscriptions:** 965
- **Churned Subscriptions:** 130
- **Churn Rate Pct:** 9.57
- **Customers With Paid Revenue:** 920
- **Support Tickets:** 716
- **Usage Events:** 22702
- **Avg Resolution Minutes:** 36.49


## Payment treatment
Failed payment amounts are excluded from collected revenue. Refunded transactions are stored as negative amounts, so **Net Collected Revenue = Paid + Refunded = 129,397**. This prevents failed transaction amounts from being incorrectly treated as cash collected.
