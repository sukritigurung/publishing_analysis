/*
Do higher priced books generate more revenue?
"price_range","number_of_books","total_publisher_revenue","avg_revenue_per_book"
"$20+","2","9738.13","4869.07"
"$10 - $20","100","212622.13","2126.22"
"$5 - $10","285","486646.04","1707.53"
"Under $5","683","193304.28","283.02"
*/
SELECT
    CASE
        WHEN sale_price < 5
            THEN 'Under $5' -- 683
        WHEN sale_price BETWEEN 5 AND 10
            THEN '$5 - $10' -- 285
        WHEN sale_price BETWEEN 10 AND 20
            THEN '$10 - $20' -- 100
        ELSE '$20+' -- 2
    END AS price_range
    , COUNT(*) AS number_of_books
    , ROUND(SUM(publisher_revenue),2) AS total_publisher_revenue
    , ROUND(AVG(publisher_revenue),2) AS avg_revenue_per_book
FROM
    books_data_view
GROUP BY
    price_range
ORDER BY
    avg_revenue_per_book DESC
;

/*
Do higher priced books sell more copies?
"price_range","avg_units_sold","avg_price"
"$5 - $10","11550","7.50"
"Under $5","9148","2.67"
"$10 - $20","8077","11.88"
"$20+","3231","29.88"
*/
SELECT
	CASE
		WHEN sale_price < 5 
			THEN 'Under $5'
		WHEN sale_price BETWEEN 5 AND 10
			THEN '$5 - $10'
		WHEN sale_price BETWEEN 10 AND 20 
			THEN '$10 - $20'
		ELSE '$20+'
	END AS price_range
	, ROUND(AVG(units_sold),0) AS avg_units_sold
	, ROUND(AVG(sale_price),2) AS avg_price
FROM
	books_data_view
GROUP BY
	price_range
ORDER BY
	avg_units_sold DESC
;

/*
Are publishers generating more revenue through higher prices or higher sales volume?
"view_publisher_name","number_of_titles","avg_sale_price","avg_units_sold","avg_revenue_per_book"
"Hachette Book Group","66","6.36","8240","2089.01"
"Penguin Group (USA) LLC","108","8.65","8651","1979.79"
"HarperCollins Publishers","79","6.20","8219","1689.17"
"Random House LLC","120","7.34","10966","1579.88"
"Simon and Schuster Digital Sales Inc","56","5.87","8963","839.08"
"Macmillan","41","5.40","8169","789.18"
"Amazon Digital Services,  Inc.","600","3.23","10124","247.07"
*/
SELECT
    view_publisher_name
    , COUNT(*) AS number_of_titles
    , ROUND(AVG(sale_price),2) AS avg_sale_price
    , ROUND(AVG(units_sold),0) AS avg_units_sold
    , ROUND(AVG(publisher_revenue),2) AS avg_revenue_per_book
FROM
    books_data_view
GROUP BY
    view_publisher_name
ORDER BY
    avg_revenue_per_book DESC
;