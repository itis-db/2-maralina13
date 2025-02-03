/**
  @maralina13
 */
WITH recent_books AS (
    SELECT id, title, publication_year
    FROM books
    WHERE publication_year > 1900
),
reader_orders AS (
    SELECT o.book_id, r.name AS reader_name, b.title AS book_title, b.publication_year
    FROM orders o
    JOIN readers r ON o.reader_id = r.id
    JOIN books b ON o.book_id = b.id
)
SELECT rb.title AS book_title, rb.publication_year, ro.reader_name
FROM recent_books rb
JOIN reader_orders ro ON rb.id = ro.book_id;

SELECT b.title AS book_title, a.name AS author_name, g.name AS genre_name
FROM books b
JOIN authors a ON b.author_id = a.id
JOIN genres g ON b.genre_id = g.id;

SELECT name FROM authors
UNION ALL
SELECT name FROM readers;
