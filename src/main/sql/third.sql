CREATE TABLE students (
    student_id INT PRIMARY KEY,
    full_name VARCHAR(100),
    age INT,
    group_id INT
);

CREATE TABLE groups (
    group_id INT PRIMARY KEY,
    group_name VARCHAR(50)
);

CREATE TABLE subjects (
    subject_id INT PRIMARY KEY,
    subject_name VARCHAR(50)
);

CREATE TABLE grades (
    grade_id INT PRIMARY KEY,
    student_id INT,
    subject_id INT,
    grade INT,
    FOREIGN KEY (student_id) REFERENCES students(student_id),
    FOREIGN KEY (subject_id) REFERENCES subjects(subject_id)
);

-- 1 Напишите INSERT для заполнения таблицы
INSERT INTO groups (group_id, group_name) VALUES
    (1, 'CS-101'),
    (2, 'CS-102'),
    (3, 'MATH-201');

INSERT INTO subjects (subject_id, subject_name) VALUES
    (1, 'Математика'),
    (2, 'Физика'),
    (3, 'Базы данных');

INSERT INTO students (student_id, full_name, age, group_id) VALUES
    (1, 'Иван Иванов',      19, 1),
    (2, 'Мария Петрова',    20, 1),
    (3, 'Алексей Сидоров',  22, 2),
    (4, 'Ольга Орлова',     18, 2),
    (5, 'Сергей Козлов',    21, 3),
    (6, 'Анна Смирнова',    19, 3);

INSERT INTO grades (grade_id, student_id, subject_id, grade) VALUES
(1, 1, 1, 9),
(2, 1, 2, 8),
(3, 1, 3, 9),
(4, 2, 1, 10),
(5, 2, 2, 9),
(6, 2, 3, 9),
(7, 3, 1, 7),
(8, 3, 2, 6),
(9, 3, 3, 8),
(10, 4, 1, 8),
(11, 4, 2, 8),
(12, 4, 3, 8),
(13, 5, 1, 9),
(14, 5, 2, 9),
(15, 5, 3, 9),
(16, 6, 1, 9),
(17, 6, 2, 9);

-- 2 Подсчитайте количество студентов в университете
SELECT COUNT(*) AS student_total
FROM students;

-- 3 Найдите средний возраст студентов
SELECT ROUND(AVG(age)) AS avg_age
FROM students;

-- 4 Определите минимальный и максимальный возраст студентов
SELECT MIN(age) AS min_age, MAX(age) AS max_age
FROM students;

-- 5 Подсчитайте, сколько всего оценок выставлено
SELECT COUNT(*) AS total_grades
FROM grades;

-- 6 Подсчитайте, сколько студентов учится в каждой группе
SELECT group_id, COUNT(*) AS total_students
FROM students
GROUP BY group_id
ORDER BY group_id;

-- 7 Найдите средний возраст студентов по каждой группе
SELECT group_id, ROUND(AVG(age)) AS avg_age
FROM students
GROUP BY group_id
ORDER BY group_id;

-- 8 Определите средний балл по каждому предмету
SELECT subject_id, ROUND(AVG(grade)::numeric, 2) as avg_grade
FROM grades
GROUP BY subject_id
ORDER BY subject_id;

-- 9 Найдите количество студентов, у которых есть оценки по каждому предмету
SELECT COUNT(*) AS student_with_all_grades
FROM (
    SELECT student_id
    FROM grades
    GROUP BY student_id
    HAVING COUNT(DISTINCT subject_id) = (SELECT COUNT(*) FROM subjects)
) deb;

-- 10 Выведите только те группы, где учится больше 1 студента
SELECT group_id, COUNT(student_id) AS total_students
FROM students
GROUP BY group_id
HAVING COUNT(*) > 1
ORDER BY group_id;

-- 11 Покажите предметы, где средний балл выше 8
SELECT subject_id, ROUND(AVG(grade):: numeric, 2) AS avg_grade
FROM grades
GROUP BY subject_id
HAVING AVG(grade) > 8
ORDER BY subject_id;

-- 12 Найдите студентов, у которых средний балл по всем предметам выше 8.5
SELECT student_id, ROUND(AVG(grade):: numeric, 2) AS avg_grade
FROM grades
GROUP BY student_id
HAVING COUNT(DISTINCT subject_id) = (SELECT COUNT(*) FROM subjects) AND AVG(grade) > 8.5
ORDER BY avg_grade DESC;

