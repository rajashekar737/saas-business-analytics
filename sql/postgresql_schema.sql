-- PostgreSQL-ready analytical layer for Raja Shekar's SaaS Business Analytics project.
-- Load the cleaned CSV files into matching staging tables, then apply these relationships.

CREATE SCHEMA IF NOT EXISTS analytics;

-- Recommended logical tables:
-- analytics.customers
-- analytics.plans
-- analytics.subscriptions
-- analytics.payments
-- analytics.usage
-- analytics.support_tickets

-- Primary analytical keys:
-- customers.customer_id
-- plans.plan_id
-- subscriptions.subscription_id
-- payments.payment_id
-- usage.usage_id (or the dataset's usage event key)
-- support_tickets.ticket_id

-- Use PostgreSQL DATE/TIMESTAMP types for date fields and NUMERIC for money.
