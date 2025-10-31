CREATE TABLE students (
    student_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    birth_date DATE NOT NULL,
    email VARCHAR(100) UNIQUE,
    group_id INT NOT NULL
);

-- 1 Напишите INSERT для заполнения таблицы

INSERT INTO students (first_name, last_name, birth_date, email, group_id) VALUES
    ('Иван',   'Иванов',  '2004-01-15', 'ivan.ivanov1@example.com', 1),
    ('Мария',  'Петрова', '2003-03-22', 'maria.pet@example.com',    2),
    ('Алексей','Сидоров', '2002-11-10', 'alex.sidorov@example.com', 2),
    ('Иван',   'Иванов',  '2004-01-15', 'ivan.ivanov2@example.com', 1),
    ('Мария',  'Петрова', '2003-03-22', 'maria.pet2@example.com',   2);

-- 2 Найти дубликаты по имени и фамилии студента

SELECT first_name, last_name, COUNT(*) FROM students GROUP BY first_name, last_name HAVING count(*) > 1;

-- 3 Удалить дубликаты, оставить только первую запись

WITH numbered AS (
    SELECT
        student_id,
        ROW_NUMBER() OVER (
            PARTITION BY first_name, last_name
            ORDER BY student_id
            ) AS rn
    FROM students
)
DELETE FROM students s
    USING numbered n
WHERE s.student_id = n.student_id
  AND n.rn > 1;
