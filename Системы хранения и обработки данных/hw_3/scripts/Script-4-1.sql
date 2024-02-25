SELECT customer_id,
       SUM(list_price) AS total_amount,
       MAX(list_price) AS max_transaction,
       MIN(list_price) AS min_transaction,
       COUNT(*) AS transaction_count
FROM transaction
GROUP BY customer_id
ORDER BY total_amount DESC, transaction_count DESC;
