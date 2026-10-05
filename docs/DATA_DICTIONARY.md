# Business Data Dictionary

## Customers
Customer-level profile and segmentation attributes used for customer and revenue analysis.

## Plans
Reference table describing available SaaS plans and their pricing/plan attributes.

## Subscriptions
Subscription-level lifecycle table used for active/churned analysis and customer-plan relationships.

## Payments
Transaction-level financial table containing payment date, amount, status, method, and subscription key.

## Product Usage
Feature/session activity used to understand product engagement patterns.

## Support Tickets
Customer-service activity used to analyze ticket volume, categories, priority, and resolution behavior.

## Key relationships
- Customers → Subscriptions through customer key
- Plans → Subscriptions through plan key
- Subscriptions → Payments through subscription key
- Customers/Subscriptions → Usage and Support through their relevant customer/subscription keys

Metric definitions should always be checked against the actual columns in the supplied dataset before reuse.
