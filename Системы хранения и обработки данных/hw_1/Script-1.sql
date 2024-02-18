-- Создание таблицы transactions_products_customers
CREATE TABLE transactions_products_customers (
  transaction_product_customer_id SERIAL PRIMARY KEY,
  transaction_id INT REFERENCES transactions(transaction_id) NOT NULL,
  product_id INT REFERENCES product(product_id) NOT NULL,
  customer_id INT REFERENCES customers(customer_id) NOT NULL,
  quantity INT NOT NULL,
  discount DECIMAL NOT NULL
);
