SELECT TO_CHAR(t.transaction_date, 'Month') AS month,
       c.job_industry_category,
       SUM(t.list_price) AS total_transaction_amount
FROM transaction t
JOIN customer c ON t.customer_id = c.customer_id
GROUP BY TO_CHAR(t.transaction_date, 'Month'), c.job_industry_category
ORDER BY EXTRACT(MONTH FROM MIN(t.transaction_date)), c.job_industry_category;
