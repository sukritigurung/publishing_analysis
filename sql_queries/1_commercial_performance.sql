/*
Which publishers generated the most revenue?:
"view_publisher_name","total_revenue"
"Penguin Group (USA) LLC","213817.45"
"Random House LLC","189585.20"
"Amazon Digital Services,  Inc.","148244.15"
"Hachette Book Group","137874.49"
"HarperCollins Publishers","133444.72"
"Simon and Schuster Digital Sales Inc","46988.32"
"Macmillan","32356.25"
*/
SELECT
    view_publisher_name
    , SUM(ROUND(publisher_revenue,2)) AS total_revenue
FROM
    books_data_view
GROUP BY
    view_publisher_name
ORDER BY
    total_revenue DESC
;


/*
Which publishers generate the most revenue per title?
"view_publisher_name","number_of_titles","total_revenue","revenue_per_title"
"Hachette Book Group","66","137874.49","2089.01"
"Penguin Group (USA) LLC","108","213817.45","1979.79"
"HarperCollins Publishers","79","133444.72","1689.17"
"Random House LLC","120","189585.20","1579.88"
"Simon and Schuster Digital Sales Inc","56","46988.32","839.08"
"Macmillan","41","32356.25","789.18"
"Amazon Digital Services,  Inc.","600","148244.15","247.07"
*/
SELECT
    view_publisher_name
    , COUNT(*) AS number_of_titles
    , ROUND(SUM(publisher_revenue),2) AS total_revenue
    , ROUND(SUM(publisher_revenue) / COUNT(*),2) AS revenue_per_title
FROM
    books_data_view
GROUP BY
    view_publisher_name
ORDER BY
    revenue_per_title DESC
;

/*
Which publishers sold the most units?:
"view_publisher_name","total_units_sold"
"Amazon Digital Services,  Inc.","6074136"
"Random House LLC","1315958"
"Penguin Group (USA) LLC","934303"
"HarperCollins Publishers","649294"
"Hachette Book Group","543821"
"Simon and Schuster Digital Sales Inc","501928"
"Macmillan","334929"
*/
SELECT
    view_publisher_name
    , SUM(units_sold) AS total_units_sold
FROM
    books_data_view
GROUP BY
    view_publisher_name
ORDER BY
    total_units_sold DESC
;

/*
How has publishing performance changed over time, or which publication years appear to produce books with lasting commercial success? 
*/
SELECT -- orders by most units sold per year: 2012 w/ 769,084
    publication_year_bce_ce
    , COUNT(publication_year_bce_ce) number_of_books
    , SUM(units_sold) AS total_sales
    , ROUND(SUM(publisher_revenue),2) AS total_revenue
FROM
    books_data_view
GROUP BY
    publication_year_bce_ce
ORDER BY
    total_sales DESC
;

SELECT -- orders by highest total revenue per year: 2011 w/ $71,986.69
    publication_year_bce_ce
    , COUNT(publication_year_bce_ce) number_of_books
    , SUM(units_sold) AS total_sales
    , ROUND(SUM(publisher_revenue),2) AS total_revenue
FROM
    books_data_view
GROUP BY
    publication_year_bce_ce
ORDER BY
    total_revenue DESC
;