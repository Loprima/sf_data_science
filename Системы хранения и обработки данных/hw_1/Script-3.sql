-- Создание таблицы product
CREATE TABLE product (
  product_id SERIAL PRIMARY KEY,
  brand VARCHAR NOT NULL,
  product_line VARCHAR NOT NULL,
  product_class VARCHAR NOT NULL,
  product_size VARCHAR NOT NULL,
  list_price DECIMAL NOT NULL,
  standard_cost DECIMAL NOT NULL
);