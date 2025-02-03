/**
  @maralina13
 */
BEGIN;

-- 1. Удаляем старые внешние ключи, чтобы можно было менять ключи в родительских таблицах
ALTER TABLE orders DROP CONSTRAINT orders_book_id_fkey;
ALTER TABLE orders DROP CONSTRAINT orders_reader_id_fkey;
ALTER TABLE books DROP CONSTRAINT books_author_id_fkey;
ALTER TABLE books DROP CONSTRAINT books_genre_id_fkey;

-- 2. Создаем новые версии таблиц с доменными ключами

-- Таблица авторов (ключ - name + birth_date)
CREATE TABLE authors_new (
    name        VARCHAR(100) NOT NULL,
    birth_date  DATE NOT NULL,
    country     VARCHAR(50),
    PRIMARY KEY (name, birth_date)
);

INSERT INTO authors_new (name, birth_date, country)
SELECT name, birth_date, country FROM authors;

DROP TABLE authors;
ALTER TABLE authors_new RENAME TO authors;

-- Таблица жанров (ключ - name)
CREATE TABLE genres_new (
    name VARCHAR(100) PRIMARY KEY
);

INSERT INTO genres_new (name)
SELECT name FROM genres;

DROP TABLE genres;
ALTER TABLE genres_new RENAME TO genres;

-- Таблица книг (ключ - title + author_name + author_birth_date)
CREATE TABLE books_new (
    title           VARCHAR(200) NOT NULL,
    author_name     VARCHAR(100) NOT NULL,
    author_birth_date DATE NOT NULL,
    genre_name      VARCHAR(100) NOT NULL,
    publication_year INTEGER,
    isbn            VARCHAR(13) UNIQUE,
    PRIMARY KEY (title, author_name, author_birth_date),
    FOREIGN KEY (author_name, author_birth_date) REFERENCES authors (name, birth_date),
    FOREIGN KEY (genre_name) REFERENCES genres (name)
);

INSERT INTO books_new (title, author_name, author_birth_date, genre_name, publication_year, isbn)
SELECT
    b.title,
    a.name AS author_name,
    a.birth_date AS author_birth_date,
    g.name AS genre_name,
    b.publication_year,
    b.isbn
FROM books b
JOIN authors a ON b.author_id = a.id
JOIN genres g ON b.genre_id = g.id;

DROP TABLE books;
ALTER TABLE books_new RENAME TO books;

-- Таблица читателей (ключ - email)
CREATE TABLE readers_new (
    email              VARCHAR(100) PRIMARY KEY,
    name               VARCHAR(100) NOT NULL,
    registration_date  DATE DEFAULT CURRENT_DATE
);

INSERT INTO readers_new (email, name, registration_date)
SELECT email, name, registration_date FROM readers;

DROP TABLE readers;
ALTER TABLE readers_new RENAME TO readers;

-- Таблица заказов (ключи - book_title, author_name, author_birth_date, reader_email, order_date)
CREATE TABLE orders_new (
    book_title        VARCHAR(200) NOT NULL,
    author_name       VARCHAR(100) NOT NULL,
    author_birth_date DATE NOT NULL,
    reader_email      VARCHAR(100) NOT NULL,
    order_date        DATE DEFAULT CURRENT_DATE,
    return_date       DATE,
    PRIMARY KEY (book_title, author_name, author_birth_date, reader_email, order_date),
    FOREIGN KEY (book_title, author_name, author_birth_date) REFERENCES books (title, author_name, author_birth_date),
    FOREIGN KEY (reader_email) REFERENCES readers (email)
);

INSERT INTO orders_new (book_title, author_name, author_birth_date, reader_email, order_date, return_date)
SELECT
    b.title AS book_title,
    a.name AS author_name,
    a.birth_date AS author_birth_date,
    r.email AS reader_email,
    o.order_date,
    o.return_date
FROM orders o
JOIN books b ON o.book_id = b.id
JOIN authors a ON b.author_id = a.id
JOIN readers r ON o.reader_id = r.id;

DROP TABLE orders;
ALTER TABLE orders_new RENAME TO orders;

-- Если все прошло успешно, применяем изменения
COMMIT;

-- Если что-то пошло не так, откатываем все изменения
ROLLBACK;
