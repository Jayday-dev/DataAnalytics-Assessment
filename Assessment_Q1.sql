-- High-Value Customers with Multiple Products
SELECT 
    u.id AS owner_id, 
    CONCAT(u.first_name, ' ', u.last_name) as name, 
    COUNT(DISTINCT CASE WHEN p.is_regular_savings = 1 THEN s.id END) AS savings_count,
    COUNT(DISTINCT CASE WHEN p.is_a_fund = 1 THEN s.id END) AS investment_count,
    ROUND(SUM(s.confirmed_amount)/100, 2) AS total_deposits -- Converting Kobo to Naira (100 Kobo = 1 Naira)
FROM users_customuser u
JOIN savings_savingsaccount s ON s.owner_id = u.id
JOIN plans_plan p ON s.plan_id = p.id
WHERE s.confirmed_amount > 0
GROUP BY u.id, name
HAVING savings_count > 0 AND investment_count > 0
ORDER BY total_deposits DESC;