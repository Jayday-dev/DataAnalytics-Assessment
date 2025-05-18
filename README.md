# DataAnalytics-Assessment

This repository contains solutions to a four-question SQL assessment. Each query is saved in its own file (`Assessment_Q1.sql` to `Asessment_Q4.sql`) and answers a specific business question. Below is an overview of the objective and approach taken for each.

---

## Assessment 1: High-Value Customers with Multiple Products

**File**: `Assessment_Q1.sql`

### Objective:
The business wants to identify customers who have both savings and an investment plan (cross-selling opportunity).

### Approach:
- Joined `users_customuser`, `savings_savingsaccount`, and `plans_plan` to get user and account data.
- Used conditional aggregation (`CASE WHEN`) to count savings vs investment accounts.
- Converted confirmed amounts from Kobo to Naira using division by 100.
- Filtered users with both account types using the `HAVING` clause.
- Sorted by total deposits in descending order.

---

## Assessment 2: Transaction Frequency Analysis

**File**: `Assessment_Q2.sql`

### Objective:
The finance team wants to analyze customer transaction frequency to segment users into categories like “High Frequency,” “Medium Frequency,” and “Low Frequency” users.

### Approach:
- Used a CTE to summarize transactions per customer and calculate the number of active months.
- Calculated average transactions per month by dividing total transactions by active months.
- Applied a CASE statement to assign a frequency category.
- Aggregated results by category to get count and average transaction frequency per group.

---

## Assessment 3: Account Inactivity Alert

**File**: `Assessment_Q3.sql`

### Objective:
The operations team wants to identify all active accounts (either Savings or Investment) that have had no inflow transactions for over one year (365 days).

### Approach:
- Created a CTE to classify each account as either Savings or Investment based on the `plans_plan` flags.
- Calculated the last transaction date and days since last activity using `DATEDIFF`.
- Filtered out inactive accounts with more than 365 days of inactivity, excluding "Other" account types.
- Ensured only accounts with confirmed (non-zero) amounts were included.

---

## Assessment 4: Customer Lifetime Value (CLV) Estimation

**File**: `Assessment_Q4.sql`

### Objective:
Marketing needed a quick and data-driven way to estimate each customer’s lifetime value. This would help them identify and prioritize customers who generate the most long-term revenue.

### Approach:
- Calculated each customer’s tenure in months since joining.
- Assumed a **0.1% profit** per transaction (multiplied `confirmed_amount` by 0.001).
- Computed average profit per transaction and extrapolated to an annual CLV formula:
  
  \[
  \text{CLV} = \left(\frac{\text{Total Transactions}}{\text{Tenure in Months}}\right) \times 12 \times \text{Avg. Profit per Transaction}
  \]
- Sorted the results by estimated CLV.

---

## Challenges I Encountered & How I Resolved Them

### 1. Query Timeout / Server Lost Connection (Error Code: 2013)
**Issue:**  
While running queries involving grouped aggregations and timestamp logic, some queries timed out and returned a “Lost connection to MySQL server” error.

**Fix:**  
I refactored the queries using **Common Table Expressions (CTEs)** to isolate logic, improve readability, and reduce processing complexity. I also ensured key fields used in joins and filters were **indexed** to improve performance.

---

### 2. Assumption in Active Month Calculation
**Issue:**  
Initially, I calculated active months by finding the difference between the first and last transaction dates, which falsely assumed continuous activity.

**Fix:**  
I updated the logic to count the **distinct months with at least one transaction**, resulting in a more accurate measure of customer activity.

---

### 3. Nulls in Name Field
**Issue:**  
Some user records had null values in the `name` field, which affected grouping and display logic.

**Fix:**  
I constructed the full name by concatenating `first_name` and `last_name`, ensuring every user was properly represented and avoiding null-related errors.

---

## Notes

- All queries are written in **MySQL**.
- Calculations and assumptions (e.g., profit percentage, currency conversion) are explained inline.
- Comments are provided within each SQL file for additional clarity.
