-- 1
SELECT id, name, salary
FROM employees
WHERE salary IS NOT NULL
    AND salary > (SELECT AVG(salary) FROM employees);

-- 2
SELECT id, name, price
FROM products
WHERE price IS NOT NULL
    AND price > (SELECT AVG(price) FROM products);

-- 3
SELECT d.id, d.name
FROM departments d
WHERE EXISTS(
    SELECT 1
    FROM employees e
    WHERE e.department_id = d.id
        AND e.salary > 10000
);

-- 4
SELECT p.id, p.name, t.cnt_orders
FROM products p
         JOIN (
    SELECT product_id, COUNT(DISTINCT order_id) AS cnt_orders
    FROM order_items
    GROUP BY product_id
) t ON t.product_id = p.id
WHERE t.cnt_orders = (
    SELECT MAX(cnt_orders)
    FROM (
             SELECT COUNT(DISTINCT order_id) AS cnt_orders
             FROM order_items
             GROUP BY product_id
         ) x
);

-- 5
SELECT
    c.name,
    c.id,
    (SELECT COUNT(*) FROM orders o WHERE o.customer_id = c.id) AS orderd_count
FROM customers c
ORDER BY c.id;

-- 6
SELECT d.id, d.name,
       (SELECT AVG(e.salary) FROM employees e WHERE e.department_id = d.id) AS avg_salary
FROM departments d
WHERE (SELECT COUNT(*) FROM employees e WHERE e.department_id = d.id) > 0
ORDER BY avg_salary DESC
LIMIT 3;

-- 7
SELECT c.id, c.name
FROM customers c
WHERE NOT EXISTS(
    SELECT 1
    FROM orders o
    WHERE o.customer_id = c.id
);

-- 8
SELECT e.id, e.name, e.salary
FROM employees e
WHERE e.salary IS NOT NULL
  AND e.salary > (
    SELECT MAX(m.salary)
    FROM employees m
    WHERE m.id IN (SELECT DISTINCT manager_id FROM employees WHERE manager_id IS NOT NULL)
);

-- 9
SELECT d.id, d.name
FROM departments d
WHERE EXISTS (
    SELECT 1 FROM employees e WHERE e.department_id = d.id
)
  AND NOT EXISTS (
    SELECT 1
    FROM employees e
    WHERE e.department_id = d.id
      AND (e.salary IS NULL OR e.salary <= 5000)
);

