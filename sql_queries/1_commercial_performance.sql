/*
How has publishing performance changed over time or, which publication years appear to produce books with lasting commercial success?
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

/*
Which publishers generated the most revenue?:
"cte_publisher_name","total_revenue"
"Penguin Group (USA) LLC","213817.45"
"Random House LLC","189585.20"
"Amazon Digital Services,  Inc.","148244.15"
"Hachette Book Group","137874.49"
"HarperCollins Publishers","133444.72"
"Simon and Schuster Digital Sales Inc","46988.32"
"Macmillan","32356.25"
*/
SELECT
    cte_publisher_name
    , SUM(ROUND(publisher_revenue,2)) AS total_revenue
FROM
    books_data_cte
GROUP BY
    cte_publisher_name
ORDER BY
    total_revenue DESC
;

/*
Which publishers generate the most revenue per title? REWORK ON THIS
"cte_publisher_name","number_of_titles","total_revenue","revenue_per_title"
"Hachette Book Group","66","137874.49","2089.01"
"Penguin Group (USA) LLC","108","213817.45","1979.79"
"HarperCollins Publishers","79","133444.72","1689.17"
"Random House LLC","120","189585.20","1579.88"
"Simon and Schuster Digital Sales Inc","56","46988.32","839.08"
"Macmillan","41","32356.25","789.18"
"Amazon Digital Services,  Inc.","600","148244.15","247.07"
*/
SELECT
    cte_publisher_name
    , COUNT(*) AS number_of_titles
    , ROUND(SUM(publisher_revenue),2) AS total_revenue
    , ROUND(SUM(publisher_revenue) / COUNT(*),2) AS revenue_per_title
FROM
    books_data_cte
GROUP BY
    cte_publisher_name
ORDER BY
    revenue_per_title DESC
;

/*
Which publishers sold the most units?:
"cte_publisher_name","total_units_sold"
"Amazon Digital Services,  Inc.","6074136"
"Random House LLC","1315958"
"Penguin Group (USA) LLC","934303"
"HarperCollins Publishers","649294"
"Hachette Book Group","543821"
"Simon and Schuster Digital Sales Inc","501928"
"Macmillan","334929"
*/
SELECT
    cte_publisher_name
    , SUM(units_sold) AS total_units_sold
FROM
    books_data_cte
GROUP BY
    cte_publisher_name
ORDER BY
    total_units_sold DESC
;

/*
How has publishing performance changed over time or, which publication years appear to produce books with lasting commercial success? 
*/
SELECT -- orders by year with most books: 2012 w/ 68
    publication_year_bce_ce
    , COUNT(publication_year_bce_ce) number_of_books
    , SUM(units_sold) AS total_sales
    , ROUND(SUM(publisher_revenue),2) AS total_revenue
FROM
    books_data_cte
GROUP BY
    publication_year_bce_ce
ORDER BY
    number_of_books DESC
;

SELECT -- orders by total revenue per year: 2011 w/ $71,986.69
    publication_year_bce_ce
    , COUNT(publication_year_bce_ce) number_of_books
    , SUM(units_sold) AS total_sales
    , ROUND(SUM(publisher_revenue),2) AS total_revenue
FROM
    books_data_cte
GROUP BY
    publication_year_bce_ce
ORDER BY
    total_revenue DESC
;