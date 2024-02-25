WITH TransactionIntervals AS (
    SELECT
        customer.customer_id,
        customer.first_name,
        customer.last_name,
        customer.job_title,
        transaction.transaction_date,
        LAG(transaction.transaction_date) OVER (PARTITION BY transaction.customer_id ORDER BY transaction.transaction_date) AS prev_transaction_date,
        LEAD(transaction.transaction_date) OVER (PARTITION BY transaction.customer_id ORDER BY transaction.transaction_date) AS next_transaction_date,
        COALESCE(transaction.transaction_date - LAG(transaction.transaction_date) OVER (PARTITION BY transaction.customer_id ORDER BY transaction.transaction_date), 0) AS interval_days
    FROM
        customer
    JOIN transaction ON customer.customer_id = transaction.customer_id
)
SELECT
    customer_id,
    first_name,
    last_name,
    job_title,
    transaction_date,
    interval_days
FROM TransactionIntervals
ORDER BY interval_days DESC
LIMIT 10