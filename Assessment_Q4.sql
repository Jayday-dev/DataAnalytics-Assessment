WITH customer_txn_summary AS (
  SELECT
    u.id AS customer_id,
    CONCAT(u.first_name, ' ', u.last_name) AS name,
    TIMESTAMPDIFF(MONTH, u.date_joined, CURDATE()) AS tenure_months,
    COUNT(s.id) AS total_transactions,
    ROUND(AVG(s.confirmed_amount * 0.001), 2) AS avg_profit_per_transaction  -- 0.1% profit per txn
  FROM users_customuser u
  JOIN savings_savingsaccount s ON u.id = s.owner_id
  GROUP BY u.id, name, tenure_months
),
clv_estimates AS (
  SELECT
    customer_id,
	name,
    tenure_months,
    total_transactions,
	ROUND((total_transactions / tenure_months) * 12 * avg_profit_per_transaction, 2) AS estimated_clv
  FROM customer_txn_summary
)
SELECT *
FROM clv_estimates
ORDER BY estimated_clv DESC;
