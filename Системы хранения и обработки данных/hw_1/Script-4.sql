-- Создание таблицы customers
CREATE TABLE customers (
  customer_id SERIAL PRIMARY KEY,
  first_name VARCHAR NOT NULL,
  last_name VARCHAR NOT NULL,
  gender VARCHAR NOT NULL,
  dob DATE NOT NULL,
  job_title VARCHAR NOT NULL,
  job_industry_category VARCHAR NOT NULL,
  wealth_segment VARCHAR NOT NULL,
  deceased_indicator VARCHAR NOT NULL,
  owns_car VARCHAR NOT NULL
);