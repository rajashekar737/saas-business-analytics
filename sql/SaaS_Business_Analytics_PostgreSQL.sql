-- SaaS Business Analytics — PostgreSQL Portfolio SQL Layer
-- Raja Shekar Ponnam | Data Analyst | Business Analytics
-- Canonical SQL layer for the cleaned datasets.
-- Expected tables: customers, plans, subscriptions, payments, usage_events, support_tickets

-- 01 Executive KPI scorecard
-- Failed payments are excluded. Refunded transactions are negative in the dataset.
WITH payment_kpis AS (
    SELECT
        SUM(CASE WHEN payment_status = 'Paid' THEN amount ELSE 0 END) AS paid_revenue,
        ABS(SUM(CASE WHEN payment_status = 'Refunded' THEN amount ELSE 0 END)) AS refund_value,
        SUM(CASE WHEN payment_status IN ('Paid','Refunded') THEN amount ELSE 0 END) AS net_collected_revenue
    FROM payments
), subscription_kpis AS (
    SELECT
        COUNT(*) FILTER (WHERE status = 'Active') AS active_subscriptions,
        COUNT(*) FILTER (WHERE status = 'Churned') AS churned_subscriptions,
        COUNT(*) AS total_subscriptions
    FROM subscriptions
)
SELECT
    ROUND(paid_revenue::numeric, 2) AS paid_revenue,
    ROUND(refund_value::numeric, 2) AS refund_value,
    ROUND(net_collected_revenue::numeric, 2) AS net_collected_revenue,
    active_subscriptions,
    churned_subscriptions,
    ROUND((churned_subscriptions::numeric / NULLIF(total_subscriptions, 0)) * 100, 2) AS churn_rate_pct
FROM payment_kpis CROSS JOIN subscription_kpis;

-- 02 Monthly paid revenue and month-over-month growth
WITH monthly AS (
    SELECT DATE_TRUNC('month', payment_date)::date AS month,
           SUM(amount) AS revenue
    FROM payments
    WHERE payment_status = 'Paid'
    GROUP BY 1
), x AS (
    SELECT month, revenue, LAG(revenue) OVER (ORDER BY month) AS previous_revenue
    FROM monthly
)
SELECT month,
       ROUND(revenue::numeric, 2) AS revenue,
       ROUND(previous_revenue::numeric, 2) AS previous_revenue,
       ROUND(((revenue - previous_revenue) / NULLIF(previous_revenue, 0) * 100)::numeric, 2) AS mom_growth_pct
FROM x
ORDER BY month;

-- 03 Revenue by plan
SELECT p.plan_name,
       ROUND(SUM(pay.amount)::numeric, 2) AS paid_revenue
FROM payments pay
JOIN subscriptions s ON pay.subscription_id = s.subscription_id
JOIN plans p ON s.plan_id = p.plan_id
WHERE pay.payment_status = 'Paid'
GROUP BY p.plan_name
ORDER BY paid_revenue DESC;

-- 04 Revenue by customer segment
SELECT c.segment,
       ROUND(SUM(pay.amount)::numeric, 2) AS paid_revenue
FROM payments pay
JOIN subscriptions s ON pay.subscription_id = s.subscription_id
JOIN customers c ON s.customer_id = c.customer_id
WHERE pay.payment_status = 'Paid'
GROUP BY c.segment
ORDER BY paid_revenue DESC;

-- 05 Customer lifetime paid revenue ranking
WITH customer_revenue AS (
    SELECT s.customer_id, SUM(pay.amount) AS revenue
    FROM payments pay
    JOIN subscriptions s ON pay.subscription_id = s.subscription_id
    WHERE pay.payment_status = 'Paid'
    GROUP BY s.customer_id
)
SELECT customer_id,
       ROUND(revenue::numeric, 2) AS lifetime_revenue,
       DENSE_RANK() OVER (ORDER BY revenue DESC) AS revenue_rank,
       ROUND((revenue / NULLIF(SUM(revenue) OVER (), 0) * 100)::numeric, 2) AS revenue_share_pct
FROM customer_revenue
ORDER BY lifetime_revenue DESC;

-- 06 Top-10 revenue concentration
WITH customer_revenue AS (
    SELECT s.customer_id, SUM(pay.amount) AS revenue
    FROM payments pay
    JOIN subscriptions s ON pay.subscription_id = s.subscription_id
    WHERE pay.payment_status = 'Paid'
    GROUP BY s.customer_id
), ranked AS (
    SELECT *, DENSE_RANK() OVER (ORDER BY revenue DESC) AS revenue_rank
    FROM customer_revenue
)
SELECT ROUND((SUM(CASE WHEN revenue_rank <= 10 THEN revenue ELSE 0 END)
              / NULLIF(SUM(revenue), 0) * 100)::numeric, 2) AS top10_revenue_share_pct
FROM ranked;

-- 07 Churn by plan
SELECT p.plan_name,
       COUNT(*) AS total_subscriptions,
       COUNT(*) FILTER (WHERE s.status = 'Churned') AS churned,
       ROUND((COUNT(*) FILTER (WHERE s.status = 'Churned')::numeric / COUNT(*) * 100), 2) AS churn_rate_pct
FROM subscriptions s
JOIN plans p ON s.plan_id = p.plan_id
GROUP BY p.plan_name
ORDER BY churn_rate_pct DESC;

-- 08 Churn by customer segment
SELECT c.segment,
       COUNT(*) AS total_subscriptions,
       COUNT(*) FILTER (WHERE s.status = 'Churned') AS churned,
       ROUND((COUNT(*) FILTER (WHERE s.status = 'Churned')::numeric / COUNT(*) * 100), 2) AS churn_rate_pct
FROM subscriptions s
JOIN customers c ON s.customer_id = c.customer_id
GROUP BY c.segment
ORDER BY churn_rate_pct DESC;

-- 09 Product engagement
SELECT feature_name,
       COUNT(*) AS usage_events,
       SUM(login_count) AS total_logins,
       ROUND(SUM(session_minutes)::numeric, 2) AS session_minutes,
       ROUND(AVG(session_minutes)::numeric, 2) AS avg_session_minutes
FROM usage_events
GROUP BY feature_name
ORDER BY usage_events DESC;

-- 10 Support operations
SELECT priority,
       COUNT(*) AS ticket_volume,
       ROUND(AVG(resolution_time)::numeric, 2) AS avg_resolution_minutes
FROM support_tickets
GROUP BY priority
ORDER BY ticket_volume DESC;

-- 11 Customers with multiple subscriptions
SELECT customer_id,
       COUNT(*) AS subscription_count
FROM subscriptions
GROUP BY customer_id
HAVING COUNT(*) > 1
ORDER BY subscription_count DESC;
