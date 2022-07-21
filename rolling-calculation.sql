-- Get number of monthly active customers.
CREATE VIEW monthly_active_clients AS
SELECT DATE_FORMAT(rental_date, '%Y-%m') AS year, MONTHNAME(rental_date) AS month, COUNT(DISTINCT customer_id) AS active_customers
FROM rental
GROUP BY year, month;

SELECT * FROM monthly_active_clients;

-- Active users in the previous month.
CREATE VIEW last_month AS
SELECT year, month, active_customers, LAG(active_customers, 1, 0) OVER (ORDER BY year) AS previous_month
FROM monthly_active_clients;

SELECT * FROM last_month;

-- Percentage change in the number of active customers.
SELECT *, ROUND(((active_customers - previous_month) * 100 / previous_month), 1) AS percent_diff
FROM last_month;

-- Retained customers every month.
CREATE VIEW customer_month AS
SELECT DISTINCT customer_id AS customer_id, DATE_FORMAT(rental_date, '%Y-%m') AS year, MONTHNAME(rental_date) AS month
FROM rental;