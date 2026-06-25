/* 
Do highly rated books sell more copies?
"rating_group","number_of_books","avg_units_sold"
"3","500","9826"
"4","569","9555"
"2","1","4440"
*/
SELECT
    FLOOR(book_average_rating) AS rating_group
    , COUNT(*) AS number_of_books
    , ROUND(AVG(units_sold),0) AS avg_units_sold
FROM
    books_data_view
GROUP BY
    rating_group
ORDER BY
    avg_units_sold DESC
;

-- Does the number of ratings correlate with sales performance?
SELECT
    CASE
        WHEN book_ratings_count < 1000
            THEN 'Under 1K'
        WHEN book_ratings_count BETWEEN 1000 AND 10000
            THEN '1K - 10K'
        WHEN book_ratings_count BETWEEN 10000 AND 50000
            THEN '10K - 50K' -- 24 books, 7947 units
        ELSE '50K+' -- 1046 books, 9717 units
    END AS number_of_ratings
    , COUNT(*) AS number_of_books
    , ROUND(AVG(units_sold),0) AS avg_units_sold
FROM
    books_data_view
GROUP BY
    number_of_ratings
ORDER BY
    avg_units_sold DESC
;

/*
Which publishers consistently publish highly rated books?
"view_publisher_name","number_of_titles","avg_book_rating"
"Penguin Group (USA) LLC","108","4.05"
"Simon and Schuster Digital Sales Inc","56","4.04"
"HarperCollins Publishers","79","4.03"
"Amazon Digital Services,  Inc.","600","4.00"
"Macmillan","41","4.00"
"Random House LLC","120","3.99"
"Hachette Book Group","66","3.96"
*/
SELECT
    view_publisher_name
    , COUNT(*) AS number_of_titles
    , ROUND(AVG(book_average_rating),2) AS avg_book_rating
FROM
    books_data_view
GROUP BY
    view_publisher_name
ORDER BY
    avg_book_rating DESC
;

SELECT * FROM books_data_view ORDER BY gross_sales DESC;
SELECT * FROM books_data_view ORDER BY book_average_rating DESC;
SELECT * from books_data_view where book_name = 'Words of Radiance'

-- Are reader ratings and commercial success closely aligned?
SELECT -- for top selling books
	book_name
	, view_publisher_name
	, book_average_rating
	, ROUND(gross_sales,0) AS rounded_gross_sales
FROM
	books_data_view
ORDER BY
	gross_sales DESC
LIMIT 10
;
/*
"book_name","view_publisher_name","book_average_rating","rounded_gross_sales"
"Go Set a Watchman","Amazon Digital Services,  Inc.","3.31","47795"
"When You Are Engulfed in Flames","Hachette Book Group","4.04","41250"
"Daughter of Smoke & Bone","Penguin Group (USA) LLC","4.04","37953"
"Beowulf","HarperCollins Publishers","3.42","34160"
"The Power of Habit","HarperCollins Publishers","4.03","27492"
"The Virgin Suicides","Penguin Group (USA) LLC","3.83","26904"
"Midnight in the Garden of Good and Evil","Hachette Book Group","3.90","26182"
"Hopeless","HarperCollins Publishers","4.34","26094"
"A Little Princess","Random House LLC","4.20","23792"
"The Velveteen Rabbit","Random House LLC","4.29","21798"
*/

SELECT -- for top ranked books
	book_name
	, view_publisher_name
	, book_average_rating
	, ROUND(gross_sales,0) AS rounded_gross_sales
FROM
	books_data_view
ORDER BY
	book_average_rating DESC
LIMIT 10
;
/*
"book_name","view_publisher_name","book_average_rating","rounded_gross_sales"
"Words of Radiance","HarperCollins Publishers","4.77","742"
"A Court of Mist and Fury","Simon and Schuster Digital Sales Inc","4.72","1159"
"The Essential Calvin and Hobbes: A Calvin and Hobbes Treasury","Amazon Digital Services,  Inc.","4.65","166"
"The Way of Kings","Amazon Digital Services,  Inc.","4.64","2178"
"Calvin and Hobbes","Penguin Group (USA) LLC","4.61","1886"
"Queen of Shadows","Macmillan","4.60","350"
"The Hobbit and The Lord of the Rings","Amazon Digital Services,  Inc.","4.59","184"
"A Storm of Swords: Part 2 Blood and Gold","Amazon Digital Services,  Inc.","4.56","326"
"The House of Hades","Amazon Digital Services,  Inc.","4.54","668"
"Heir of Fire","Hachette Book Group","4.53","163"
*/