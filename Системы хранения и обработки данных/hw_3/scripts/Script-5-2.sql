SELECT customer.first_name, customer.last_name
FROM customer
JOIN (
    SELECT customer_id, COALESCE(SUM(list_price), 0) AS total_amount
    FROM transaction
    GROUP BY customer_id
    HAVING COALESCE(SUM(list_price), 0) > 0
    ORDER BY total_amount DESC
    LIMIT 10
) AS max_transaction ON customer.customer_id = max_transaction.customer_id;
