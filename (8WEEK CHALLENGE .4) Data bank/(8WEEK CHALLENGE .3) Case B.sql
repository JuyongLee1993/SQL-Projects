
--What is the unique count and total amount for each transaction type?
SELECT
txn_type, COUNT(txn_type) AS count_type, SUM(txn_amount) AS total_amount
FROM
customer_transactions
GROUP BY txn_type

--What is the average total historical deposit counts and amounts for all customers?
WITH deposits AS 
(
SELECT 
customer_id, 
txn_type, COUNT(*) AS count, 
          AVG(txn_amount) AS avg_amount
FROM customer_transactions
GROUP BY customer_id, txn_type)

SELECT 
ROUND(AVG(txn_count),0) AS avg_deposit, 
ROUND(AVG(avg_amount),2) AS avg_amount
FROM
deposits
WHERE
txn_type = 'deposit';

--For each month - how many Data Bank customers make more than 1 deposit and either 1 purchase or 1 withdrawal in a single month?
WITH monthly_transactions AS (
SELECT 
customer_id, 
MONTH(txn_date) month,
SUM(CASE WHEN txn_type = 'deposit' THEN 1 ELSE 0 END) AS deposit_count,
SUM(CASE WHEN txn_type = 'purchase' THEN 1 ELSE 0 END) AS purchase_count,
SUM(CASE WHEN txn_type = 'withdrawal' THEN 1 ELSE 0 END) AS withdrawal_count
FROM customer_transactions
GROUP BY
customer_id, MONTH(txn_date)
 )
SELECT
month,
COUNT(DISTINCT customer_id) AS customer_count
FROM monthly_transactions
WHERE deposit_count >= 2 AND 
(purchase_count >= 1 OR withdrawal_count >= 1)
GROUP BY month
ORDER BY month;
--What is the closing balance for each customer at the end of the month?

--What is the percentage of customers who increase their closing balance by more than 5%?