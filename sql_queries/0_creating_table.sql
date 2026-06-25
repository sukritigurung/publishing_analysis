/*
Creating the table in the database. I usually use VARCHAR(255) for text fields as that is how I learned to do it. 
However, there were a couple of records in the book_name and author_name fields that were way too long to fit the VARCHAR(255) specifications. 
Therefore, I decided to use TEXT for all the string fields for consistency.
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

SELECT -- double-checking that I hadn't misremembered seeing two different "fiction" values
	book_genre
	, COUNT(*) AS book_count
FROM 
	books_data_clean
GROUP BY
	book_genre
ORDER BY book_count DESC
;

SELECT -- doing the same for publisher
	publisher_name
	, COUNT(*) AS publisher_count
FROM
	books_data_clean
GROUP BY
	publisher_name
ORDER BY publisher_count DESC
;

/*
Creating a view for the standardized genre and publisher columns. Originally used CTEs but had to use over multiple queries.
*/
CREATE VIEW books_data_view AS
	SELECT
		index_number
		, ABS(publishing_year) AS publication_year_bce_ce -- coding as absolute value
		, book_name
		, author_name
		, CASE
			WHEN LOWER(book_genre) IN ('fiction','genre fiction')
				THEN 'fiction'
			ELSE book_genre
		  END AS view_book_genre
		, book_average_rating
		, book_ratings_count
		, sale_price
		, units_sold
		, gross_sales
		, sales_rank
		, CASE
			WHEN LOWER(publisher_name) ILIKE 'harpercollins%'
				THEN 'HarperCollins Publishers'
			ELSE publisher_name
		  END AS view_publisher_name
		, publisher_revenue
	FROM
		books_data_clean
;