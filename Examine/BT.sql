CREATE DATABASE CompanyDB;
USE CompanyDB;

-- 1. Bảng Department (Phòng ban)
CREATE TABLE Department (
    dept_id INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    dept_name VARCHAR(100) NOT NULL,
    location VARCHAR(100)
);

-- 2. Bảng Employee (Nhân viên)
CREATE TABLE Employee (
    emp_id INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    emp_name VARCHAR(100) NOT NULL,
    gender INT DEFAULT 1,
    birth_date DATE,
    salary DECIMAL(10, 2),
    dept_id INT,
    FOREIGN KEY (dept_id) REFERENCES Department(dept_id) ON UPDATE CASCADE
);

-- 3. Bảng Project (Dự án)
CREATE TABLE Project (
    project_id INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    project_name VARCHAR(150) NOT NULL,
    emp_id INT,
    start_date DATE DEFAULT (CURRENT_DATE),
    end_date DATE,
    FOREIGN KEY (emp_id) REFERENCES Employee(emp_id)
);
-- Thêm cột email (VARCHAR(100), UNIQUE) vào bảng Employee
ALTER TABLE Employee
ADD email VARCHAR(100) UNIQUE;

-- Sửa kiểu dữ liệu cột project_name thành VARCHAR(200)
ALTER TABLE Project
MODIFY project_name VARCHAR(200);

-- Thêm ràng buộc CHECK đảm bảo end_date >= start_date
ALTER TABLE Project
ADD CONSTRAINT chk_date_valid CHECK (end_date >= start_date);
-- Thêm dữ liệu vào bảng Department
INSERT INTO Department (dept_id, dept_name, location) VALUES
(1, 'IT', 'Ha Noi'),
(2, 'HR', 'HCM'),
(3, 'Marketing', 'Da Nang');

-- Thêm dữ liệu vào bảng Employee
INSERT INTO Employee (emp_id, emp_name, gender, birth_date, salary, dept_id, email) VALUES
(1, 'Nguyen Van A', 1, '1990-01-15', 1500, 1, 'a@gmail.com'),
(2, 'Tran Thi B', 0, '1995-05-20', 1200, 1, 'b@gmail.com'),
(3, 'Le Minh C', 1, '1988-10-10', 2000, 2, 'c@gmail.com'),
(4, 'Pham Thi D', 0, '1992-12-05', 1800, 3, 'd@gmail.com');

-- Thêm dữ liệu vào bảng Project
INSERT INTO Project (project_id, project_name, emp_id, start_date, end_date) VALUES
(101, 'Website Redesign', 1, '2024-01-01', '2024-06-01'),
(102, 'Recruitment System', 3, '2024-02-01', '2024-08-01'),
(103, 'Marketing Campaign', 4, '2024-03-01', NULL);

-- Tăng salary thêm 200 cho tất cả nhân viên thuộc phòng ban 'IT' (dept_id = 1)
UPDATE Employee
SET salary = salary + 200
WHERE dept_id = 1;

-- Cập nhật end_date thành '2024-12-31' cho các dự án đang có giá trị NULL
UPDATE Project
SET end_date = '2024-12-31'
WHERE end_date IS NULL;
-- Xóa các dự án có ngày bắt đầu trước ngày '2024-02-01'
DELETE FROM Project
WHERE start_date < '2024-02-01';
-- 1. CASE & AS: Hiển thị emp_name, email và cột gender_name
SELECT 
    emp_name, 
    email, 
    CASE 
        WHEN gender = 1 THEN 'Nam' 
        ELSE 'Nữ' 
    END AS gender_name
FROM Employee;

-- 2. Hàm hệ thống: emp_name viết hoa toàn bộ và một cột tính tuổi hiện tại
SELECT 
    UPPER(emp_name) AS emp_name_uppercase,
    TIMESTAMPDIFF(YEAR, birth_date, CURDATE()) AS age
FROM Employee;

-- 3. INNER JOIN: Hiển thị emp_name, salary và dept_name
SELECT 
    e.emp_name, 
    e.salary, 
    d.dept_name
FROM Employee e
INNER JOIN Department d ON e.dept_id = d.dept_id;

-- 4. ORDER BY & LIMIT: 2 nhân viên có mức lương cao nhất, sắp xếp giảm dần
SELECT * 
FROM Employee
ORDER BY salary DESC
LIMIT 2;

-- 5. GROUP BY & HAVING: Số lượng nhân viên theo phòng ban (>= 2 nhân viên)
SELECT 
    d.dept_name, 
    COUNT(e.emp_id) AS total_employees
FROM Department d
JOIN Employee e ON d.dept_id = e.dept_id
GROUP BY d.dept_id, d.dept_name
HAVING COUNT(e.emp_id) >= 2;

-- 6. Scalar Subquery: Nhân viên có mức lương cao hơn mức lương trung bình
SELECT * 
FROM Employee
WHERE salary > (SELECT AVG(salary) FROM Employee);

-- 7. IN Operator Subquery: Các nhân viên đang tham gia ít nhất một dự án
SELECT * 
FROM Employee
WHERE emp_id IN (SELECT DISTINCT emp_id FROM Project WHERE emp_id IS NOT NULL);

-- 8. Correlated Subquery: Nhân viên có mức lương cao nhất trong phòng ban của họ
SELECT e1.* 
FROM Employee e1
WHERE e1.salary = (
    SELECT MAX(e2.salary) 
    FROM Employee e2 
    WHERE e2.dept_id = e1.dept_id
);
