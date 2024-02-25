SELECT customer.first_name, customer.last_name
FROM customer
JOIN (
    SELECT customer_id, COALESCE(SUM(list_price), 0) AS total_amount
    FROM transaction
    GROUP BY customer_id
    HAVING COALESCE(SUM(list_price), 0) > 0
    ORDER BY total_amount ASC
    LIMIT 10
) AS min_transaction ON customer.customer_id = min_transaction.customer_id;
