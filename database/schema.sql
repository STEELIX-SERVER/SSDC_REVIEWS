-- fill in your schema here
DROP DATABASE IF EXISTS reviews;
CREATE DATABASE reviews;
\c reviews;
-- DROP TABLE IF EXISTS reviews;
-- DROP TABLE IF EXISTS reviews_photos;
-- DROP TABLE IF EXISTS characteristics;
-- DROP TABLE IF EXISTS characteristic_reviews;

CREATE TABLE IF NOT EXISTS reviews(
  review_id integer GENERATED BY DEFAULT AS IDENTITY UNIQUE PRIMARY KEY,
  product_id INT NOT NULL,
  rating INT NOT NULL,
  review_date VARCHAR NOT NULL,
  summary VARCHAR(300) NOT NULL,
  body VARCHAR(1000) NOT NULL,
  recommend BOOLEAN,
  reported BOOLEAN,
  reviewer_name VARCHAR(30) NOT NULL,
  reviewer_email VARCHAR(70) NOT NULL,
  response VARCHAR(200) NOT NULL,
  helpfulness VARCHAR NOT NULL
);
CREATE INDEX review_index ON reviews(product_id);
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
CREATE INDEX photo_review_index ON reviews_photos USING btree (review_id);
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
