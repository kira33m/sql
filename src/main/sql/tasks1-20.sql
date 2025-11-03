-- 1
SELECT
    e.id,
    e.name,
    COALESCE(d.name, 'No Department') AS department
FROM employees e
         LEFT JOIN departments d ON d.id = e.department_id
ORDER BY e.id;

-- 2
SELECT
    e.id,
    e.name  AS employee,
    m.name  AS manager
FROM employees e
         JOIN employees m ON m.id = e.manager_id
ORDER BY m.name, e.name;

-- 3
SELECT d.id, d.name
FROM departments d
         LEFT JOIN employees e ON e.department_id = d.id
WHERE e.id IS NULL
ORDER BY d.id;

-- 4
SELECT
    o.id AS order_id,
    o.order_date,
    o.amount,
    COALESCE(e.name, 'No Employee')  AS employee,
    COALESCE(c.name, 'No Customer')  AS customer
FROM orders o
         LEFT JOIN employees e ON e.id = o.employee_id
         LEFT JOIN customers c ON c.id = o.customer_id
ORDER BY o.id;

-- 5
SELECT
    o.id AS order_id,
    CASE WHEN oi.id IS NULL THEN 'No Items' ELSE p.name END AS product_name,
    oi.quantity
FROM orders o
         LEFT JOIN order_items oi ON oi.order_id = o.id
         LEFT JOIN products p     ON p.id = oi.product_id
ORDER BY o.id, product_name;

-- 6
SELECT
    d.id   AS department_id,
    d.name AS department,
    o.id   AS order_id,
    o.order_date,
    o.amount
FROM departments d
         LEFT JOIN employees e ON e.department_id = d.id
         LEFT JOIN orders o    ON o.employee_id   = e.id
ORDER BY d.id, o.id;

-- 7
SELECT
    c.id AS customer_id,
    c.name AS customer,
    p.id AS product_id,
    p.name AS product
FROM customers c
         CROSS JOIN products p
WHERE NOT EXISTS (
    SELECT 1
    FROM orders o
        JOIN order_items oi ON oi.order_id = o.id
    WHERE o.customer_id = c.id
        AND oi.product_id = p.id
);

-- 8
SELECT p.id, p.name
FROM products p
    LEFT JOIN order_items oi ON oi.product_id = p.id
WHERE oi.product_id IS NULL
ORDER BY p.id;

-- 9
SELECT
    m.id,
    m.name AS manager,
    COALESCE(SUM(o.amount), 0) AS total_amount_by_team
FROM employees m
         JOIN employees s ON s.manager_id = m.id
         LEFT JOIN orders o ON o.employee_id = s.id
GROUP BY m.id, m.name
ORDER BY total_amount_by_team DESC, m.name;

-- 10
SELECT
    COUNT(*) AS total_orders,
    COALESCE(SUM(amount), 0) AS total_revenue
FROM orders;

-- 11
SELECT
    d.id,
    d.name,
    ROUND(AVG(e.salary)::numeric, 2) AS avg_salary,
    MAX(e.salary) AS max_salary
FROM departments d
         LEFT JOIN employees e ON e.department_id = d.id
GROUP BY d.id, d.name
ORDER BY d.id;

-- 12
SELECT
    o.id AS order_id,
    COALESCE(SUM(oi.quantity), 0) AS total_quantity,
    COUNT(DISTINCT oi.product_id) AS unique_products
FROM orders o
         LEFT JOIN order_items oi ON oi.order_id = o.id
GROUP BY o.id
ORDER BY o.id;

-- 13
SELECT
    p.id,
    p.name,
    SUM(oi.quantity * p.price) AS revenue
FROM products p
         JOIN order_items oi ON oi.product_id = p.id
GROUP BY p.id, p.name
ORDER BY revenue DESC
LIMIT 3;

-- 14
SELECT COUNT(DISTINCT customer_id) AS customers_with_orders
FROM orders
WHERE customer_id IS NOT NULL;

-- 15
WITH emp AS (
    SELECT department_id,
           COUNT(*) AS employee_count,
           ROUND(AVG(salary)::numeric, 2) AS avg_salary
    FROM employees
    GROUP BY department_id
),
     ord AS (
         SELECT e.department_id,
                SUM(o.amount) AS total_orders_amount
         FROM employees e
                  JOIN orders o ON o.employee_id = e.id
         GROUP BY e.department_id
     )
SELECT
    d.id,
    d.name,
    COALESCE(emp.employee_count, 0) AS employee_count,
    emp.avg_salary,
    COALESCE(ord.total_orders_amount, 0) AS total_orders_amount
FROM departments d
         LEFT JOIN emp ON emp.department_id = d.id
         LEFT JOIN ord ON ord.department_id = d.id
ORDER BY d.id;

-- 16
SELECT
    c.id,
    c.name,
    ROUND(AVG(o.amount)::numeric, 2) AS avg_amount
FROM customers c
         JOIN orders o ON o.customer_id = c.id
GROUP BY c.id, c.name
HAVING AVG(o.amount) > (SELECT AVG(amount) FROM orders)
ORDER BY avg_amount DESC;

-- 17
SELECT name AS full_name
FROM employees e;

-- 18
SELECT
    id AS order_id,
    TO_CHAR(order_date, 'DD.MM.YYYY HH24:MI') AS order_date_fmt
FROM orders
ORDER BY id;

-- 19
SELECT
    id AS order_id,
    order_date
FROM orders
WHERE order_date < CURRENT_DATE - 30;
