# Background
Honeybee Group is an investment firm looking to invest in the publishing industry. The company is seeking to better understand what publisher would yield the best returns based on commercial performance and customer satisfaction.

Insights and recommendations are provided on the following key areas:
- Commercial performance - 
- Reader satisfaction - 
- Stability and risk -
- Investment opportunities -
- Pricing strategy -

The SQL queries used for this analysis can be found [here](/sql_queries/) (sql_queries folder).
# Data Structure and Initial Checks
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

# Executive Summary
## Overview of Findings
## Insights Deep Dive

# Recommendations

# Assumptions and Caveats
Throughout the analysis, multiple assumptions were made to manage challenges with the data. These assumptions and caveats are noted below:
- 'fiction' and 'genre fiction' under book_genre were treated as the same category due to the apparent overlap in classification. Similarly, 'HarperCollins Publisher', 'HarperCollins Publishing' and 'HarperCollins Christian Publishing' under publisher_name were treated as the same.
    - Relevant note for clarification: 'Penguin Group (USA) LLC' and 'Random House LLC' under publisher_name were two separate publishers that merged to form Penguin Random House in 2013. Initially, I was going to treat the two the same under 'Penguin Random House.' However, there were books published under them before the merger in the dataset, so I decided to leave them as separate companies. It's then important to note that because the dataset goes till 2016, there might be some titles from *after* the merger which could affect the analyses.
- author_rating (changed to author_tier for better understanding) was disregarded for majority of the analysis as there is an unclear standard for the categorization. language_code was also disregarded as there was not much use for it in these analyses.
- Several titles contained negative publication years representing works originally composed before the Common Era (BCE). For example, "Aesopica" was published in 560 but shows up as -560 in the dataset. These records were retained because they reflect historically significant works rather than data entry errors, so the publishing_year field was renamed in the common table expressions to publication_year_bce_ce for clarity and the values converted to positive using the absolute function (ABS()).