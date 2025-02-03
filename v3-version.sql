/**
  @maralina13
 */
ALTER TABLE books
ALTER COLUMN publication_year TYPE SMALLINT;

ALTER TABLE books
ADD COLUMN description TEXT;

ALTER TABLE readers
ADD COLUMN phone VARCHAR(15);

ALTER TABLE books
ADD CONSTRAINT publication_year_check CHECK (publication_year >= 1800);

ALTER TABLE readers
ADD CONSTRAINT readers_phone_unique UNIQUE (phone);

ALTER TABLE readers
DROP CONSTRAINT IF EXISTS readers_phone_unique;

ALTER TABLE books
DROP CONSTRAINT IF EXISTS publication_year_check;

ALTER TABLE readers
DROP COLUMN IF EXISTS phone;

ALTER TABLE books
DROP COLUMN IF EXISTS description;

ALTER TABLE books
ALTER COLUMN publication_year TYPE INTEGER;
