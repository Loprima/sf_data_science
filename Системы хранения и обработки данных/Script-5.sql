-- Создание таблицы customer_address
CREATE TABLE customer_address (
  address_id SERIAL PRIMARY KEY,
  customer_id INT REFERENCES customers(customer_id) NOT NULL,
  address VARCHAR NOT NULL,
  postcode INT NOT NULL,
  state VARCHAR NOT NULL,
  country VARCHAR NOT NULL
);