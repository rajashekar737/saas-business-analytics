-- SaaS Business Analytics | Rebuilt SQL Analysis Layer
-- Purpose: business KPIs, trends, customer value, churn, engagement and support.
-- Compatible with MySQL 8+.

CREATE DATABASE IF NOT EXISTS saas_business_analytics;
USE saas_business_analytics;

-- Load the six cleaned CSVs into tables before running the analysis queries.
-- Table names expected: customers, plans, subscriptions, payments, usage_events, support_tickets.

-- 01. Data quality and reconciliation
SELECT COUNT(*) AS customers, COUNT(DISTINCT Customer_Id) AS unique_customers FROM customers;
SELECT COUNT(*) AS subscriptions, COUNT(DISTINCT Subscription_Id) AS unique_subscriptions FROM subscriptions;
SELECT COUNT(*) AS payments, COUNT(DISTINCT Payment_Id) AS unique_payments FROM payments;
SELECT Payment_Status, COUNT(*) AS transactions, ROUND(SUM(Amount),2) AS amount FROM payments GROUP BY Payment_Status;

-- 02. Executive KPI scorecard
SELECT
 ROUND(SUM(CASE WHEN Payment_Status='Paid' THEN Amount ELSE 0 END),2) AS paid_revenue,
 ROUND(SUM(CASE WHEN Payment_Status='Refunded' THEN ABS(Amount) ELSE 0 END),2) AS refund_value,
 ROUND(SUM(Amount),2) AS net_collected_revenue,
 COUNT(DISTINCT CASE WHEN Payment_Status='Paid' THEN Subscription_Id END) AS subscriptions_with_paid_transactions,
 (SELECT COUNT(*) FROM subscriptions WHERE Status='Active') AS active_subscriptions,
 (SELECT COUNT(*) FROM subscriptions WHERE Status='Churned') AS churned_subscriptions;

-- 03. Revenue by commercial dimensions
SELECT p.Plan_Name, ROUND(SUM(pay.Amount),2) AS paid_revenue
FROM payments pay JOIN subscriptions s ON pay.Subscription_Id=s.Subscription_Id JOIN plans p ON s.Plan_Id=p.Plan_Id
WHERE pay.Payment_Status='Paid' GROUP BY p.Plan_Name ORDER BY paid_revenue DESC;

SELECT c.Country, ROUND(SUM(pay.Amount),2) AS paid_revenue
FROM payments pay JOIN subscriptions s ON pay.Subscription_Id=s.Subscription_Id JOIN customers c ON s.Customer_Id=c.Customer_Id
WHERE pay.Payment_Status='Paid' GROUP BY c.Country ORDER BY paid_revenue DESC;

SELECT c.Segment, ROUND(SUM(pay.Amount),2) AS paid_revenue
FROM payments pay JOIN subscriptions s ON pay.Subscription_Id=s.Subscription_Id JOIN customers c ON s.Customer_Id=c.Customer_Id
WHERE pay.Payment_Status='Paid' GROUP BY c.Segment ORDER BY paid_revenue DESC;

SELECT c.Industry, ROUND(SUM(pay.Amount),2) AS paid_revenue
FROM payments pay JOIN subscriptions s ON pay.Subscription_Id=s.Subscription_Id JOIN customers c ON s.Customer_Id=c.Customer_Id
WHERE pay.Payment_Status='Paid' GROUP BY c.Industry ORDER BY paid_revenue DESC;

-- 04. Monthly revenue and growth
WITH monthly AS (
 SELECT DATE_FORMAT(Payment_Date,'%Y-%m') AS month, SUM(Amount) AS revenue
 FROM payments WHERE Payment_Status='Paid' GROUP BY DATE_FORMAT(Payment_Date,'%Y-%m')
)
SELECT month, ROUND(revenue,2) AS revenue,
 ROUND(LAG(revenue) OVER(ORDER BY month),2) AS previous_month,
 ROUND((revenue-LAG(revenue) OVER(ORDER BY month))/NULLIF(LAG(revenue) OVER(ORDER BY month),0)*100,2) AS mom_growth_pct
FROM monthly ORDER BY month;

-- 05. Customer lifetime revenue and concentration
WITH customer_revenue AS (
 SELECT c.Customer_Id,c.Country,c.Segment,SUM(pay.Amount) AS revenue
 FROM payments pay JOIN subscriptions s ON pay.Subscription_Id=s.Subscription_Id JOIN customers c ON s.Customer_Id=c.Customer_Id
 WHERE pay.Payment_Status='Paid' GROUP BY c.Customer_Id,c.Country,c.Segment
), ranked AS (
 SELECT *, DENSE_RANK() OVER(ORDER BY revenue DESC) AS revenue_rank,
 SUM(revenue) OVER() AS total_revenue FROM customer_revenue
)
SELECT Customer_Id,Country,Segment,ROUND(revenue,2) AS revenue,revenue_rank,ROUND(revenue/NULLIF(total_revenue,0)*100,2) AS revenue_share_pct
FROM ranked ORDER BY revenue DESC LIMIT 20;

-- 06. Top-10 customer concentration
WITH customer_revenue AS (
 SELECT s.Customer_Id,SUM(pay.Amount) AS revenue
 FROM payments pay JOIN subscriptions s ON pay.Subscription_Id=s.Subscription_Id
 WHERE pay.Payment_Status='Paid' GROUP BY s.Customer_Id
)
SELECT ROUND(SUM(CASE WHEN revenue_rank<=10 THEN revenue ELSE 0 END)/SUM(revenue)*100,2) AS top10_revenue_share_pct
FROM (SELECT revenue,DENSE_RANK() OVER(ORDER BY revenue DESC) AS revenue_rank FROM customer_revenue) x;

-- 07. Churn by plan and segment
SELECT p.Plan_Name, COUNT(*) AS total_subscriptions,
 SUM(CASE WHEN s.Status='Churned' THEN 1 ELSE 0 END) AS churned,
 ROUND(SUM(CASE WHEN s.Status='Churned' THEN 1 ELSE 0 END)/COUNT(*)*100,2) AS churn_rate_pct
FROM subscriptions s JOIN plans p ON s.Plan_Id=p.Plan_Id GROUP BY p.Plan_Name ORDER BY churn_rate_pct DESC;

SELECT c.Segment, COUNT(*) AS total_subscriptions,
 SUM(CASE WHEN s.Status='Churned' THEN 1 ELSE 0 END) AS churned,
 ROUND(SUM(CASE WHEN s.Status='Churned' THEN 1 ELSE 0 END)/COUNT(*)*100,2) AS churn_rate_pct
FROM subscriptions s JOIN customers c ON s.Customer_Id=c.Customer_Id GROUP BY c.Segment ORDER BY churn_rate_pct DESC;

-- 08. Product engagement
SELECT Feature_Name, COUNT(*) AS events, SUM(Login_Count) AS total_logins,
 ROUND(SUM(Session_Minutes),2) AS session_minutes, ROUND(AVG(Session_Minutes),2) AS avg_session_minutes
FROM usage_events GROUP BY Feature_Name ORDER BY events DESC;

SELECT DATE_FORMAT(Event_Date,'%Y-%m') AS month, COUNT(*) AS events,
 ROUND(SUM(Session_Minutes),2) AS session_minutes
FROM usage_events GROUP BY DATE_FORMAT(Event_Date,'%Y-%m') ORDER BY month;

-- 09. Support operations
SELECT Priority, COUNT(*) AS tickets, ROUND(AVG(Resolution_Time),2) AS avg_resolution_minutes
FROM support_tickets GROUP BY Priority ORDER BY tickets DESC;

SELECT Category, COUNT(*) AS tickets, ROUND(AVG(Resolution_Time),2) AS avg_resolution_minutes
FROM support_tickets GROUP BY Category ORDER BY tickets DESC;

-- 10. Customers with multiple subscriptions
SELECT Customer_Id, COUNT(*) AS subscription_count
FROM subscriptions GROUP BY Customer_Id HAVING COUNT(*)>1 ORDER BY subscription_count DESC;

-- 11. Customers above average lifetime revenue
WITH customer_revenue AS (
 SELECT s.Customer_Id,SUM(pay.Amount) AS revenue
 FROM payments pay JOIN subscriptions s ON pay.Subscription_Id=s.Subscription_Id
 WHERE pay.Payment_Status='Paid' GROUP BY s.Customer_Id
)
SELECT Customer_Id,ROUND(revenue,2) AS revenue
FROM customer_revenue WHERE revenue>(SELECT AVG(revenue) FROM customer_revenue) ORDER BY revenue DESC;

-- 12. Revenue by plan and month
SELECT DATE_FORMAT(pay.Payment_Date,'%Y-%m') AS month,p.Plan_Name,ROUND(SUM(pay.Amount),2) AS revenue,
 RANK() OVER(PARTITION BY DATE_FORMAT(pay.Payment_Date,'%Y-%m') ORDER BY SUM(pay.Amount) DESC) AS monthly_plan_rank
FROM payments pay JOIN subscriptions s ON pay.Subscription_Id=s.Subscription_Id JOIN plans p ON s.Plan_Id=p.Plan_Id
WHERE pay.Payment_Status='Paid' GROUP BY DATE_FORMAT(pay.Payment_Date,'%Y-%m'),p.Plan_Name ORDER BY month,monthly_plan_rank;
