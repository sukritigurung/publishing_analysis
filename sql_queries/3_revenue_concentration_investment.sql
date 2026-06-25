-- Is the industry dependent on a smaller number of bestseller books, or is revenue concentrated or distributed across many titles? MAKE TABLE
SELECT
    book_name
    , view_publisher_name
    , publisher_revenue
FROM
    books_data_view
ORDER BY
    publisher_revenue DESC
;

-- How much revenue comes from the top 10% of books? - 64.66%
SELECT -- total revenue
    ROUND(SUM(publisher_revenue),2) AS total_revenue
FROM
    books_data_view
; -- $902,310.58

SELECT -- what is 10%
    COUNT(*) AS total_books_count
FROM
    books_data_view
; -- 1070
SELECT 1070 * .10 -- = 107

SELECT -- top 10% of revenue
    ROUND(SUM(publisher_revenue),2) AS top_10_percent_revenue
FROM
    (
        SELECT
            publisher_revenue
        FROM
            books_data_view
        ORDER BY
            publisher_revenue DESC
        LIMIT 107
    ) AS top_10_percent_books
; -- $583,466.77
SELECT ROUND((583466.77 / 902310.58) * 100,2) AS top_10_percent_revenue_percentage -- 64.66%

/*
Which publishers achieve strong ratings consistently? Which publishers achieve strong ratings despite relatively modest sales?
"view_publisher_name","number_of_titles","average_rating","average_number_of_ratings","total_publisher_revenue"
"Penguin Group (USA) LLC","108","4.05","96464","213817.45"
"Simon and Schuster Digital Sales Inc","56","4.04","92056","46988.32"
"HarperCollins Publishers","79","4.03","93470","133444.72"
"Amazon Digital Services,  Inc.","600","4.00","94914","148244.15"
"Macmillan","41","4.00","93127","32356.25"
"Random House LLC","120","3.99","94760","189585.20"
"Hachette Book Group","66","3.96","97859","137874.49"
*/
SELECT
    view_publisher_name
    , COUNT(*) AS number_of_titles
    , ROUND(AVG(book_average_rating),2) AS average_rating
    , ROUND(AVG(book_ratings_count),0) AS average_number_of_ratings
    , ROUND(SUM(publisher_revenue),2) AS total_publisher_revenue
FROM
    books_data_view
GROUP BY
    view_publisher_name
ORDER by
    average_rating DESC
;
