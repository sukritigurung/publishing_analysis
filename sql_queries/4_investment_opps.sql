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
Which publishers achieve strong ratings consistently? Which publishers achieve strong ratings despite relatively modest sales?
"cte_publisher_name","number_of_titles","average_rating","average_number_of_ratings","total_publisher_revenue"
"Penguin Group (USA) LLC","108","4.05","96464","213817.45"
"Simon and Schuster Digital Sales Inc","56","4.04","92056","46988.32"
"HarperCollins Publishers","79","4.03","93470","133444.72"
"Amazon Digital Services,  Inc.","600","4.00","94914","148244.15"
"Macmillan","41","4.00","93127","32356.25"
"Random House LLC","120","3.99","94760","189585.20"
"Hachette Book Group","66","3.96","97859","137874.49"
*/
SELECT
    cte_publisher_name
    , COUNT(*) AS number_of_titles
    , ROUND(AVG(book_average_rating),2) AS average_rating
    , ROUND(AVG(book_ratings_count),0) AS average_number_of_ratings
    , ROUND(SUM(publisher_revenue),2) AS total_publisher_revenue
FROM
    books_data_cte
GROUP BY
    cte_publisher_name
ORDER by
    average_rating DESC
;
