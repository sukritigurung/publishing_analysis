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

-- Is the industry dependent on a smaller number of bestseller books, or is revenue concentrated or distributed across many titles?
SELECT
    book_name
    , cte_publisher_name
    , publisher_revenue
FROM
    books_data_cte
ORDER BY
    publisher_revenue DESC
;

-- How much revenue comes from the top 10% of books? - 64.66%
SELECT -- total revenue
    ROUND(SUM(publisher_revenue),2) AS total_revenue
FROM
    books_data_cte
; -- $902,310.58

SELECT -- what is 10%
    COUNT(*) AS total_books_count
FROM
    books_data_cte
; -- 1070
SELECT 1070 * .10 -- = 107

SELECT -- top 10% of revenue
    ROUND(SUM(publisher_revenue),2) AS top_10_percent_revenue
FROM
    (
        SELECT
            publisher_revenue
        FROM
            books_data_cte
        ORDER BY
            publisher_revenue DESC
        LIMIT 107
    ) AS top_10_percent_books
; -- $583,466.77
SELECT ROUND((583466.77 / 902310.58) * 100,2) AS top_10_percent_revenue_percentage -- 64.66%
