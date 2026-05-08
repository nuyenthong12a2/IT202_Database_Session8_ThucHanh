-- I. THIẾT KẾ CƠ SỞ DỮ LIỆU (DDL)
CREATE DATABASE BookStoreDB;
USE BookStoreDB;

CREATE TABLE Category (
    category_id INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    category_name VARCHAR(100) NOT NULL,
    description VARCHAR(255)
);

CREATE TABLE Book (
    book_id INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    title VARCHAR(150) NOT NULL,
    status INT DEFAULT 1,
    publish_date DATE,
    price DECIMAL(15, 2),
    category_id INT,
    FOREIGN KEY (category_id) REFERENCES Category(category_id)
);

CREATE TABLE BookOrder (
    order_id INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    customer_name VARCHAR(100) NOT NULL,
    book_id INT,
    order_date DATE DEFAULT (CURRENT_DATE),
    delivery_date DATE,
    FOREIGN KEY (book_id) REFERENCES Book(book_id) ON DELETE CASCADE
);

-- II. THAY ĐỔI CẤU TRÚC BẢNG (DDL)
ALTER TABLE Book ADD COLUMN author_name VARCHAR(100) NOT NULL;
ALTER TABLE BookOrder MODIFY COLUMN customer_name VARCHAR(200);
ALTER TABLE BookOrder ADD CONSTRAINT chk_delivery_date CHECK (delivery_date >= order_date);

-- III. THAO TÁC DỮ LIỆU (DML)
INSERT INTO Category (category_id, category_name, description) VALUES
(1, 'IT & Tech', 'Sách lập trình'),
(2, 'Business', 'Sách kinh doanh'),
(3, 'Novel', 'Tiểu thuyết');
select * from Category ;

INSERT INTO Book (book_id, title, status, publish_date, price, category_id, author_name) VALUES
(1, 'Clean Code', 1, '2020-05-10', 500000, 1, 'Robert C. Martin'),
(2, 'Đắc Nhân Tâm', 0, '2018-08-20', 150000, 2, 'Dale Carnegie'),
(3, 'JavaScript Nâng cao', 1, '2023-01-15', 350000, 1, 'Kyle Simpson'),
(4, 'Nhà Giả Kim', 0, '2015-11-25', 120000, 3, 'Paulo Coelho');

select * from Book;


INSERT INTO BookOrder (order_id, customer_name, book_id, order_date, delivery_date) VALUES
(101, 'Nguyen Hai Nam', 1, '2025-01-10', '2025-01-15'),
(102, 'Tran Bao Ngoc', 3, '2025-02-05', '2025-02-10'),
(103, 'Le Hoang Yen', 4, '2025-03-12', NULL);

select * from BookOrder;

UPDATE Book SET price = price + 50000 WHERE category_id = 1;
UPDATE BookOrder SET delivery_date = '2025-12-31' WHERE delivery_date IS NULL;
DELETE FROM BookOrder WHERE order_date < '2025-02-01';


-- 1. CASE & AS: Hiển thị trạng thái hàng hóa
SELECT title, author_name, 
       CASE 
           WHEN status = 1 THEN 'Còn hàng' 
           ELSE 'Hết hàng' 
       END AS status_name 
FROM Book;

-- 2. Hàm hệ thống: In hoa tiêu đề và tính số năm xuất bản
SELECT UPPER(title) AS title_uppercase, 
       (YEAR(CURDATE()) - YEAR(publish_date)) AS years_published 
FROM Book;

-- 3. INNER JOIN: Kết hợp bảng Book và Category
SELECT b.title, b.price, c.category_name 
FROM Book b 
INNER JOIN Category c ON b.category_id = c.category_id;

-- 4. ORDER BY & LIMIT: Top 2 cuốn sách giá cao nhất
SELECT * FROM Book 
ORDER BY price DESC 
LIMIT 2;

-- 5. GROUP BY & HAVING: Thống kê thể loại có từ 2 cuốn sách trở lên
SELECT c.category_name, COUNT(b.book_id) AS book_count 
FROM Category c 
JOIN Book b ON c.category_id = b.category_id 
GROUP BY c.category_name 
HAVING book_count >= 2;

-- 6. Scalar Subquery: Sách có giá cao hơn mức trung bình
SELECT * FROM Book 
WHERE price > (SELECT AVG(price) FROM Book);

-- 7. IN Operator Subquery: Sách đã từng được đặt hàng
SELECT * FROM Book 
WHERE book_id IN (SELECT DISTINCT book_id FROM BookOrder);

-- 8. Correlated Subquery: Sách đắt nhất trong từng thể loại
SELECT * FROM Book b1 
WHERE price = (SELECT MAX(price) FROM Book b2 WHERE b2.category_id = b1.category_id);