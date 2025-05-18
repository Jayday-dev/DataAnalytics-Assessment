WITH account_types AS (
  SELECT
    s.plan_id,
    s.owner_id,
    CASE
      WHEN p.is_regular_savings = 1 THEN 'Savings'
      WHEN p.is_a_fund = 1 THEN 'Investment'
      ELSE 'Other'
    END AS type,
    MAX(DATE(s.transaction_date)) AS last_transaction_date,
    DATEDIFF(CURDATE(), MAX(DATE(s.transaction_date))) AS inactivity_days
  FROM savings_savingsaccount s
  JOIN plans_plan p ON s.plan_id = p.id
  WHERE s.confirmed_amount > 0
  GROUP BY s.plan_id, s.owner_id
)
SELECT *
FROM account_types
WHERE type <> 'Other'
  AND inactivity_days > 365;