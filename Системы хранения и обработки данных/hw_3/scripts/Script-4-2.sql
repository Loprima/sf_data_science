SELECT DISTINCT
       customer_id,
       SUM(list_price) OVER (PARTITION BY customer_id) AS total_amount,
       MAX(list_price) OVER (PARTITION BY customer_id) AS max_transaction,
       MIN(list_price) OVER (PARTITION BY customer_id) AS min_transaction,
       COUNT(*) OVER (PARTITION BY customer_id) AS transaction_count
FROM transaction
ORDER BY total_amount DESC, transaction_count DESC;
