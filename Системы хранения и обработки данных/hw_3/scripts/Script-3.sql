SELECT brand, COUNT(*) AS online_orders_count
FROM transaction
JOIN customer ON transaction.customer_id = customer.customer_id
WHERE customer.job_industry_category = 'IT'
  AND transaction.order_status = 'Approved'
  AND transaction.online_order = 'Yes'
  AND transaction.brand IS NOT NULL
GROUP BY brand;

