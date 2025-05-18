WITH customer_txn_summary AS (
  SELECT
    owner_id,
    COUNT(*) AS total_txns,
    COUNT(DISTINCT DATE_FORMAT(transaction_date, '%Y-%m')) AS active_months
  FROM savings_savingsaccount
  GROUP BY owner_id
),
frequency_classification AS (
  SELECT
    owner_id,
    ROUND(total_txns * 1.0 / active_months, 2) AS transactions_per_month,
    CASE
      WHEN total_txns * 1.0 / active_months >= 10 THEN 'High Frequency'
      WHEN total_txns * 1.0 / active_months BETWEEN 3 AND 9 THEN 'Medium Frequency'
      ELSE 'Low Frequency'
    END AS frequency_category
  FROM customer_txn_summary
)
SELECT
  frequency_category,
  COUNT(*) AS customer_count,
  ROUND(AVG(transactions_per_month), 2) AS avg_transactions_per_month
FROM frequency_classification
GROUP BY frequency_category
ORDER BY avg_transactions_per_month DESC;
