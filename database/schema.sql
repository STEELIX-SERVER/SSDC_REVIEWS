DROP DATABASE IF EXISTS reviews;
CREATE DATABASE reviews;
\c reviews;


CREATE TABLE IF NOT EXISTS reviews(
  review_id integer GENERATED BY DEFAULT AS IDENTITY UNIQUE PRIMARY KEY,
  product_id INT NOT NULL,
  rating INT NOT NULL,
  review_date BIGINT NOT NULL,
  summary VARCHAR(300) NOT NULL,
  body VARCHAR(1000) NOT NULL,
  recommend BOOLEAN NOT NULL DEFAULT false,
  reported BOOLEAN NOT NULL DEFAULT false,
  reviewer_name VARCHAR(50) NOT NULL,
  reviewer_email VARCHAR(70) NOT NULL,
  response VARCHAR(300),
  helpfulness INT NOT NULL DEFAULT 0
);
COPY reviews(review_id, product_id, rating, review_date, summary, body, recommend, reported, reviewer_name, reviewer_email, response, helpfulness)
FROM '/Users/tiffanyvu/Desktop/sdc/reviews.csv'
DELIMITER ','
CSV HEADER;

CREATE TABLE IF NOT EXISTS reviews_photos (
  photo_id integer GENERATED BY DEFAULT AS IDENTITY UNIQUE PRIMARY KEY,
  review_id INT NOT NULL,
  photo_url VARCHAR NOT NULL,
    FOREIGN KEY(review_id)
      REFERENCES reviews(review_id)
        ON DELETE CASCADE
        );
COPY reviews_photos(photo_id, review_id, photo_url)
FROM '/Users/tiffanyvu/Desktop/sdc/reviews_photos.csv'
DELIMITER ','
CSV HEADER;

CREATE TABLE IF NOT EXISTS characteristics (
  characteristic_id integer GENERATED BY DEFAULT AS IDENTITY UNIQUE PRIMARY KEY,
  product_id INT NOT NULL,
  characteristic_name VARCHAR NOT NULL);
COPY characteristics(characteristic_id, product_id, characteristic_name)
FROM '/Users/tiffanyvu/Desktop/sdc/characteristics.csv'
DELIMITER ','
CSV HEADER;


CREATE TABLE IF NOT EXISTS characteristic_reviews (
  metadata_id integer GENERATED BY DEFAULT AS IDENTITY UNIQUE PRIMARY KEY,
  characteristic_id INT NOT NULL,
    FOREIGN KEY(characteristic_id)
      REFERENCES characteristics(characteristic_id)
        ON DELETE CASCADE,
  review_id INT NOT NULL,
    FOREIGN KEY(review_id)
      REFERENCES reviews(review_id)
        ON DELETE CASCADE,
  characteristic_value INT NOT NULL
);
COPY characteristic_reviews(metadata_id, characteristic_id, review_id, characteristic_value)
FROM '/Users/tiffanyvu/Desktop/sdc/characteristic_reviews.csv'
DELIMITER ','
CSV HEADER;


CREATE INDEX review_index ON reviews(product_id);
CREATE INDEX photo_review_index ON reviews_photos USING btree (review_id);
CREATE INDEX characteristic_index ON characteristics(product_id);
CREATE INDEX characteristic_id_index ON characteristics(characteristic_id);
CREATE INDEX characteristic_review_index ON characteristic_reviews(review_id);
CREATE INDEX characteristic_review_id_index ON characteristic_reviews USING btree (characteristic_id);


SELECT setval(pg_get_serial_sequence('reviews', 'review_id'), (SELECT MAX(review_id) FROM reviews)+1);
SELECT setval(pg_get_serial_sequence('reviews_photos', 'photo_id'), (SELECT MAX(photo_id) FROM reviews_photos)+1);
SELECT setval(pg_get_serial_sequence('characteristic_reviews', 'metadata_id'), (SELECT MAX(metadata_id) FROM characteristic_reviews)+1);