SELECT transaction_id, customer_id, transaction_date
FROM (
    SELECT transaction_id, customer_id, transaction_date,
           ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY transaction_date) AS row_num
    FROM transaction
) AS ranked_transactions
WHERE row_num = 1;
