-- Топ-10 продавцов по суммарной выручке
SELECT
    CONCAT(TRIM(e.first_name), ' ', TRIM(e.last_name)) AS seller,
    COUNT(*) AS operations,
    FLOOR(SUM(p.price * s.quantity)) AS income
FROM sales s
JOIN employees e ON s.sales_person_id = e.employee_id
JOIN products p ON s.product_id = p.product_id
GROUP BY seller
ORDER BY income DESC
LIMIT 10;
-- Продавцы с низкой средней выручкой за сделку
WITH per_seller AS (
    SELECT
        CONCAT(TRIM(e.first_name), ' ', TRIM(e.last_name)) AS seller,
        SUM(p.price * s.quantity) AS total_income,
        COUNT(*) AS operations,
        SUM(p.price * s.quantity) / COUNT(*) AS avg_income
    FROM sales s
    JOIN employees e ON s.sales_person_id = e.employee_id
    JOIN products p ON s.product_id = p.product_id
    GROUP BY seller
),
overall AS (
    SELECT AVG(avg_income) AS avg_all FROM per_seller
)
SELECT
    seller,
    FLOOR(avg_income) AS average_income
FROM per_seller, overall
WHERE avg_income < avg_all
ORDER BY average_income ASC;
-- Выручка по дням недели для каждого продавца
SELECT
    CONCAT(TRIM(e.first_name), ' ', TRIM(e.last_name)) AS seller,
    TRIM(TO_CHAR(s.sale_date, 'day')) AS day_of_week,
    FLOOR(SUM(p.price * s.quantity)) AS income
FROM sales s
JOIN employees e ON s.sales_person_id = e.employee_id
JOIN products p ON s.product_id = p.product_id
GROUP BY seller, day_of_week, EXTRACT(DOW FROM s.sale_date)
ORDER BY EXTRACT(DOW FROM s.sale_date), seller;