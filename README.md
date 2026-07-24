# Publishing Industry Market Analysis
## Background
Honeybee Group is an investment firm looking to invest in the publishing industry. The company is seeking to better understand what publisher would yield the best returns based on commercial performance and customer satisfaction.

The SQL queries used for this analysis along with detailed comments and result sets can be found [here](/sql_queries/).

You can find a visualized summary of the analysis [here](/dashboard_images/Publishing%20Analysis%20Dashboard%20Image.png).
### Questions to Consider
Insights and recommendations are provided on the following key areas:
- **Commercial performance:** An analysis of which publishers are generating the strongest commercial results.
    - Which publishers generated the most revenue? Which publishers generate the most revenue per title? Which publishers sold the most units? How has publishing performance changed over time, or which publication years appear to produce books with lasting commercial success? 
- **Reader satisfaction:** An assessment of which publishers consistently deliver books readers enjoy and have therefore built strong reputations among consumers.
    - Do highly rated books sell more copies? Does the number of ratings correlate with sales performance? Which publishers consistently publish highly rated books? Are reader ratings and commercial success closely aligned?
- **Revenue concentration and investment opportunities:** An evaluation of whether publisher success is sustainable or dependent on a few bestsellers. Additionally, this is useful for identifying publishers that may be undervalued in terms of commercial performance relative to reader response which could prove to be attractive investment opportunities.
    - Is the industry dependent on a smaller number of bestseller books, or is revenue concentrated or distributed across many titles? How much revenue comes from the top 10% of books? Which publishers achieve strong ratings consistently? Which publishers achieve strong ratings despite relatively modest sales?
- **Pricing strategy:** An analysis of what commercial strategies can be most effective.
    - Do higher priced books generate more revenue? Do higher priced books sell more copies? Are publishers generating more revenue through higher prices or higher sales volume?
### Tools Used
The tools used for this project were:
- SQL - data querying
- PostgreSQL - data storage and management
- pgAdmin - workspace for initial SQL code editing
- Visual Studio Code - SQL code editor for easier version control
- Tableau Public - data visualization
- Git and GitHub - version control and documentation
## Data Structure and Initial Checks
This project was conducted using Josh Murrey's Book Sales and Ratings Data from Kaggle which can be found [here](https://www.kaggle.com/datasets/thedevastator/books-sales-and-ratings/data).

The dataset features attributes like sales and ratings from nine different publishers with publishing years ranging from mostly the 1600s to 2016, with a handful of books from before the common era (BCE).

Prior to analysis, I cleaned up the data by renaming several fields using snake case (snake_case) to better work with SQL analysis and formatting the data types. The dataset consists of 1,070 records with the following columns:
- index > index_number as big integer (BIGINT) - used as primary key
- Publishing Year > publishing_year as integer (INT)
- Book Name > book_name as text (TEXT)
- Author > author_name TEXT
- language_code TEXT
- Author_Rating > author_tier TEXT
- Book_average_rating > book_average_rating as DECIMAL(10,2)
- Book_ratings_count > book_ratings_count INT
- genre > book_genre TEXT
- gross sales > gross_sales DECIMAL(10,2)
- publisher revenue > publisher_revenue DECIMAL(10,2)
- sale price > sale_price DECIMAL(10,2)
- sales rank > sales_rank INT
- Publisher > publisher_name TEXT
- units sold > units_sold INT

For the analysis, I used a view that standardized the book_genre, publishing_year, and publisher_name fields (detailed explanation for why in the [assumptions and caveats](#assumptions-and-caveats) section). Code used to create view:
```SQL
CREATE VIEW books_data_view AS
	SELECT
		index_number
		, ABS(publishing_year) AS publication_year_bce_ce
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
```
## Executive Summary
<p align="center">
    <img src="dashboard_images\overview_summary.png"/>
</p>
<p align="center">
  <i>Overview of main metrics.</i>
</p>
After evaluating the data, Honeybee Group found Penguin Group (USA) LLC to be both the highest-revenue publisher and one of the strongest performers in reader ratings. Revenue appears heavily concentrated among a relatively small percentage of bestselling titles. While higher-priced books generally generated more revenue per title, sales volume remains critical in publisher success.

### Overview of Findings
#### Commercial Performance
- Penguin Group (USA) LLC generated the highest total revenue, producing $213,817.45 in publisher revenue.
- Hachette Book Group generated the highest average publisher revenue per title at $2,089.01 across 66 books.
    - While Hachette generated less total revenue than Penguin, the higher average revenue per title may indicate stronger title selection, marketing effectiveness, or pricing strategy.
- Amazon Digital Services, Inc. sold the most units with 6,074,136 copies.
    - The second best-selling publisher was Random House LLC with 1,315,958 copies.
    - With such a large distance between the two best-selling publishers, this suggests that Amazon focuses more on a large catalog rather than maximizing revenue from individual releases.

<p align="center">
    <img src="dashboard_images\perf_over_years.png"/>
</p>
<p align="center">
  <i>Visualization of publishing performance over the years.</i>
</p>

- As seen in the chart above, books published in 2011 generated the highest publisher revenue ($71,986.69) while books published in 2012 sold the most units (769,084).
    - Because the dataset ends at 2016, this would suggest that newer titles seem to do better commercially than older titles. The earliest year in the Top 20 of highest-selling years is 1985 with 219,561 total sales.
#### Reader Satisfaction
- In order to get a general understanding, as seen in the code block below, I grouped the ratings into rating_groups based on the closest integer rather than doing the analysis with ratings that could range with such a vast number of decimals. By doing this, I found that books with ratings around 3 (out of 5) sold the most books overall.
```SQL
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
```
*SQL code to create the rating groups.*
-  Over 97% of books in the dataset received more than 50,000 ratings and averaged 9,717 units sold.
    - This suggests a close relationship between reader engagement and commercial visibility.
- Penguin Group (USA) LLC achieved the highest average rating at 4.05.
    - Combined with the fact that Penguin was the third highest-selling publisher with 934,303 units, there seems to be an ability to consistently publish books highly rated by readers while still being commercially successful.
- Harper Lee's *Go Set a Watchman* generated the highest gross sales despite receiving a relatively modest rating of 3.31. In contrast, Brandon Sanderson's *Words of Radiance* achieved the highest rating in the dataset (4.77) but generated comparatively low sales.
    - This indicates that factors beyond reader satisfaction, like maybe author recognition or market exposure, play significant roles in commercial performance.
#### Revenue Concentration and Investment Opportunities
- As seen below, the top 10% of titles generated 64.66% of total publisher revenue which suggests the industry is highly dependent on a relatively small number of bestseller books.

<p align="center">
  <img src="dashboard_images\revenue_concentration.png" />
</p>
<p align="center">
  <i>Visualization showing the top 10% of books' market share.</i>
</p>

- Penguin Group (USA) LLC achieved both the highest average rating and the highest total revenue, making the company one of the strongest investment candidates.
- Despite generating the second-lowest total revenue, Simon and Schuster Digital Sales Inc. achieved the second-highest average rating at 4.04.
#### Pricing Strategy
- Books priced above $20 generated the highest average revenue per book at $4,869.07. However, this price range contained only two titles, so the price range with the second-highest average revenue per book at $2,126.22 might be a better indicator. This group had a price range of $10 to $20 which shows that higher-priced books generally generate more revenue per title.
- Books priced between $5 and $10 sold the most copies on average (11,550 units) while books priced above $20 sold the fewest (3,231). This suggests that higher prices do not necessarily lead to higher sales volume and that demand may decline as prices increase.
- Hachette and Penguin generated the hghest average revenue per title while maintaining moderate average prices. Amazon generated lower revenue per title despite selling large volumes of books.
- Mid-priced books ($5-$20) generated the majority of industry revenue while also maintaining strong sales volume. On the other hand, extremely low-priced books sold reasonably well but generated substantially less revenue per title. Moderate pricing may provide the most sustainable commercial results.
## Recommendations
Based on the insights, the following recommendations have been provided:
- Penguin Group (USA) LLC, Simon and Schuster Digital Sales Inc., and Hachette Book Group are the strongest contenders for investment.
    - Penguin demonstrated both strong commercial performance and strong reader satisfaction which would make it a great priority investment.
    - Simon and Schuster achieved one of the highest average ratings despite generating relatively modest revenue, suggesting potential for future growth if commercial performance improves.
    - Hachette Book Group generated the highest average revenue per title, indicating a strong ability to monetize releases.
- Further evaluate publisher dependence on bestseller titles before making any investment decisions.
    - With the top ten percent of books generating more than half of the industry revenue, it's vital to understand whether this could pose any portfolio risk, especially in investing in companies that don't house a good share of the top books.
## Assumptions and Caveats
Throughout the analysis, multiple assumptions were made to manage challenges with the data. These assumptions and caveats are noted below:
- 'fiction' and 'genre fiction' under book_genre were treated as the same category due to the apparent overlap in classification. Similarly, 'HarperCollins Publisher', 'HarperCollins Publishing' and 'HarperCollins Christian Publishing' under publisher_name were treated as the same.
    - Relevant note for clarification: 'Penguin Group (USA) LLC' and 'Random House LLC' under publisher_name were two separate publishers that merged to form Penguin Random House in 2013. Initially, I was going to treat the two the same under 'Penguin Random House.' However, there were books published under them before the merger in the dataset, so I decided to leave them as separate companies. It's then important to note that because the dataset goes till 2016, there might be some titles from *after* the merger which could affect the analyses.
- author_rating (changed to author_tier for better understanding) was disregarded for majority of the analysis as there is an unclear standard for the categorization. language_code was also disregarded as there was not much use for it in these analyses.
    - After deeper evaluation into the data, a good suggestion for future analysis might be to take into consideration author tier. Something like researching into if "higher-tier" authors (maybe the categorization is based on popularity or how prolific they are) sell more or achieve higher ratings.
- Several titles contained negative publication years representing works originally composed before the Common Era (BCE). For example, "Aesopica" was published in 560 but shows up as -560 in the dataset. These records were retained because they reflect historically significant works rather than data entry errors, so the publishing_year field was renamed in the common table expressions to publication_year_bce_ce for clarity and the values converted to positive using the absolute function (ABS()).