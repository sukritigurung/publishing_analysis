/*
Creating the table in the database. I usually use VARCHAR(255) for text fields as that is how I learned to do it. However, there were a couple of records in the book_name and author_name fields that were way too long to fit the VARCHAR(255) specifications. Therefore, I decided to use TEXT for all the string fields for consistency.
*/
CREATE TABLE books_data_clean (
	index_number BIGINT -- primary key
	, publishing_year INT
	, book_name TEXT
	, author_name TEXT
	, language_code TEXT
	, author_tier TEXT
	, book_average_rating DECIMAL(10,2)
	, book_ratings_count INT
	, book_genre TEXT
	, gross_sales DECIMAL(10,2)
	, publisher_revenue DECIMAL(10,2)
	, sale_price DECIMAL(10,2)
	, sales_rank INT
	, publisher_name TEXT
	, units_sold INT
)
;
