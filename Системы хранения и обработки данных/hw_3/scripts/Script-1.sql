SELECT job_industry_category, COUNT(*) AS count_clients
FROM customer
GROUP BY job_industry_category
ORDER BY count_clients DESC;
