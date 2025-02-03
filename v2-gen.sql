/**
  @maralina13
 */
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

INSERT INTO authors (name, birth_date, country)
SELECT 
    'Author ' || generate_series(1, 20),
    DATE '1800-01-01' + (random() * 200 * 365)::int * '1 day'::interval,
    CASE WHEN random() > 0.5 THEN 'Россия' ELSE 'США' END
FROM generate_series(1, 20);

INSERT INTO genres (name)
SELECT 
    'Genre ' || generate_series(1, 10)
FROM generate_series(1, 10)
ON CONFLICT (name) DO NOTHING;

INSERT INTO books (title, author_id, genre_id, publication_year, isbn)
SELECT 
    'Book ' || generate_series(1, 100),
    (SELECT id FROM authors ORDER BY random() LIMIT 1),
    (SELECT id FROM genres ORDER BY random() LIMIT 1),
    1800 + (random() * 223)::int,
    'ISBN-' || uuid_generate_v4()
FROM generate_series(1, 100);

INSERT INTO readers (name, email, registration_date)
SELECT 
    'Reader ' || generate_series(1, 100),
    'reader' || generate_series(1, 100) || '_' || uuid_generate_v4() || '@example.com',
    CURRENT_DATE - (random() * 365)::int * '1 day'::interval
FROM generate_series(1, 100);

INSERT INTO orders (book_id, reader_id, order_date, return_date)
SELECT 
    (SELECT id FROM books ORDER BY random() LIMIT 1),
    (SELECT id FROM readers ORDER BY random() LIMIT 1),
    NOW() - (random() * 365 || ' days')::interval,
    NOW() + (random() * 30 || ' days')::interval
FROM generate_series(1, 270);

INSERT INTO orders (book_id, reader_id, order_date, return_date)
SELECT 
    (SELECT id FROM books ORDER BY random() LIMIT 1),
    (SELECT id FROM readers ORDER BY random() LIMIT 1),
    NOW() - (random() * 365 || ' days')::interval,
    NOW() + (random() * 30 || ' days')::interval
FROM generate_series(1, 230);
