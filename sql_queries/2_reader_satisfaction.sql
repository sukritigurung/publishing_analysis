/*
Which publishers consistently publish highly rated books? Are reader ratings and commercial success closely aligned?
*/
WITH books_data_cte AS ( -- creating the cte 
    SELECT
        index_number
        , ABS(publishing_year) AS publication_year_bce_ce
        , book_name
        , author_name
        , CASE WHEN
            LOWER(book_genre) IN ('fiction','genre fiction') -- 884
                THEN 'fiction'
            ELSE book_genre
          END AS cte_book_genre
        , book_average_rating
        , book_ratings_count
        , sale_price
        , units_sold
        , gross_sales
        , sales_rank
        , CASE WHEN
            LOWER(publisher_name) ILIKE 'harpercollins%' -- 79
                THEN 'HarperCollins Publishers'
            ELSE publisher_name
          END AS cte_publisher_name
        , publisher_revenue
    FROM
        books_data_clean
)

SELECT -- for top ranked books
	book_name
	, cte_publisher_name
	, book_average_rating
	, gross_sales
FROM
	books_data_cte
ORDER BY
	book_average_rating DESC
LIMIT 10
;

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
    books_data_cte
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
            THEN '10K - 50K'
        ELSE '50K+'
    END AS number_of_ratings
    , COUNT(*) AS number_of_books
    , ROUND(AVG(units_sold),0) AS avg_units_sold
FROM
    books_data_cte
GROUP BY
    number_of_ratings
ORDER BY
    avg_units_sold DESC
;

/*
Which publishers consistently publish highly rated books?
"cte_publisher_name","number_of_titles","avg_book_rating"
"Penguin Group (USA) LLC","108","4.05"
"Simon and Schuster Digital Sales Inc","56","4.04"
"HarperCollins Publishers","79","4.03"
"Amazon Digital Services,  Inc.","600","4.00"
"Macmillan","41","4.00"
"Random House LLC","120","3.99"
"Hachette Book Group","66","3.96"
*/
SELECT
    cte_publisher_name
    , COUNT(*) AS number_of_titles
    , ROUND(AVG(book_average_rating),2) AS avg_book_rating
FROM
    books_data_cte
GROUP BY
    cte_publisher_name
ORDER BY
    avg_book_rating DESC
;

-- Are reader ratings and commercial success closely aligned?
SELECT -- for top selling books
	book_name
	, cte_publisher_name
	, book_average_rating
	, gross_sales
FROM
	books_data_cte
ORDER BY
	gross_sales DESC
LIMIT 10
;
/*
"book_name","cte_publisher_name","book_average_rating","gross_sales"
"Go Set a Watchman","Amazon Digital Services,  Inc.","3.31","47795.00"
"When You Are Engulfed in Flames","Hachette Book Group","4.04","41250.00"
"Daughter of Smoke & Bone","Penguin Group (USA) LLC","4.04","37952.50"
"Beowulf","HarperCollins Publishers","3.42","34160.00"
"The Power of Habit","HarperCollins Publishers","4.03","27491.67"
"The Virgin Suicides","Penguin Group (USA) LLC","3.83","26904.06"
"Midnight in the Garden of Good and Evil","Hachette Book Group","3.90","26182.00"
"Hopeless","HarperCollins Publishers","4.34","26093.67"
"A Little Princess","Random House LLC","4.20","23792.34"
"The Velveteen Rabbit","Random House LLC","4.29","21797.82"
*/

SELECT -- for top ranked books
	book_name
	, cte_publisher_name
	, book_average_rating
	, gross_sales
FROM
	books_data_cte
ORDER BY
	book_average_rating DESC
LIMIT 10
;
/*
"book_name","cte_publisher_name","book_average_rating","gross_sales"
"Words of Radiance","HarperCollins Publishers","4.77","741.52"
"A Court of Mist and Fury","Simon and Schuster Digital Sales Inc","4.72","1158.84"
"The Essential Calvin and Hobbes: A Calvin and Hobbes Treasury","Amazon Digital Services,  Inc.","4.65","166.32"
"The Way of Kings","Amazon Digital Services,  Inc.","4.64","2178.00"
"Calvin and Hobbes","Penguin Group (USA) LLC","4.61","1886.22"
"Queen of Shadows","Macmillan","4.60","349.83"
"The Hobbit and The Lord of the Rings","Amazon Digital Services,  Inc.","4.59","184.14"
"A Storm of Swords: Part 2 Blood and Gold","Amazon Digital Services,  Inc.","4.56","325.91"
"The House of Hades","Amazon Digital Services,  Inc.","4.54","668.25"
"Heir of Fire","Hachette Book Group","4.53","163.35"
*/