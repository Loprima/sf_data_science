-- Создание таблицы transactions
CREATE TABLE transactions (
  transaction_id SERIAL PRIMARY KEY,
  transaction_date DATE NOT NULL,
  online_order BOOLEAN,
  order_status VARCHAR NOT NULL
);
