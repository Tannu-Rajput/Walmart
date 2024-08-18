CREATE DATABASE walmart_sales;

USE walmart_sales;
SELECT * FROM WALMART;

# Generic Question
-- 1. How many unique cities does the data have?

SELECT 
    COUNT(DISTINCT CITY) AS unique_cities
FROM
    WALMART;

-- 2. In which city is each branch?
SELECT 
    Branch, City
FROM
    WALMART
GROUP BY Branch , City
ORDER BY Branch;


-- ---------------------------------------------

### Product 

-- 1.How many unique product lines does the data have?
SELECT 
    COUNT(DISTINCT PRODUCT_LINE) AS unique_product_lines
FROM
    WALMART;

-- 2. What is the most common payment method?
SELECT PAYMENT, COUNT(PAYMENT) AS count
FROM WALMART
GROUP BY PAYMENT
ORDER BY count DESC
LIMIT 1;

-- 3 .What is the most selling product line?
SELECT PRODUCT_LINE, SUM(Quantity) AS sold
FROM WALMART
GROUP BY PRODUCT_LINE
ORDER BY sold DESC
LIMIT 1;

-- 4. What is the total revenue by month?
SELECT 
    MONTH(date) AS month, SUM(total) AS total_revenue
FROM
    WALMART
GROUP BY month
ORDER BY month;

-- 5. What month had the largest COGS?
 SELECT MONTH(date) AS month, SUM(cogs) AS total_cogs
FROM WALMART
GROUP BY month
ORDER BY total_cogs DESC
LIMIT 1;

-- 6.What product line had the largest revenue?

SELECT product_line ,count(total) as largest_revenue
from walmart 
group by product_line
order by largest_revenue desc
limit 1;

-- 7. What is the city with the largest revenue?
SELECT CITY, SUM(total) AS largest_revenue
FROM WALMART
GROUP BY CITY
ORDER BY largest_revenue DESC
LIMIT 1;

-- 8.  What product line had the largest VAT?
SELECT PRODUCT_LINE, SUM(cogs * 0.05) AS vat
FROM WALMART
GROUP BY PRODUCT_LINE
ORDER BY vat DESC
LIMIT 1; 

-- 10. Which branch sold more products than average product sold?

SELECT Branch
FROM (
    SELECT Branch, COUNT(*) AS Product_count
    FROM WALMART
    GROUP BY Branch
) AS BranchSales
WHERE Product_count > (
    SELECT AVG(Product_count) AS avg_count
    FROM (
        SELECT COUNT(*) AS Product_count
        FROM WALMART
        GROUP BY Branch
    ) AS BranchProductCounts
);

-- 11 What is the most common product line by gender?
SELECT PRODUCT_LINE, COUNT(GENDER) AS total_gender
FROM WALMART
GROUP BY PRODUCT_LINE
ORDER BY total_gender DESC
LIMIT 1;


-- 12. What is the average rating of each product line?
SELECT PRODUCT_LINE, AVG(RATING) AS avg_rating
FROM WALMART
GROUP BY PRODUCT_LINE;


-- -----------------------------------------

### Sales

-- 1. Number of sales made in each time of the day per weekday
SELECT TIME_FORMAT(time, '%H:%i') AS time_of_day, 
       DAYNAME(date) AS weekday,
       COUNT(*) AS num_sales
FROM WALMART
GROUP BY time_of_day, weekday
ORDER BY weekday, time_of_day;


-- 2. Which of the customer types brings the most revenue?

SELECT CUSTOMER_TYPE, SUM(total) AS revenue
FROM WALMART
GROUP BY CUSTOMER_TYPE
ORDER BY revenue DESC
LIMIT 1;

-- 3. Which city has the largest tax percent/ VAT (**Value Added Tax**)?
SELECT CITY, AVG(Tax) AS avg_tax
FROM WALMART
GROUP BY CITY
ORDER BY avg_tax DESC
LIMIT 1;


-- 4. Which customer type pays the most in VAT?
SELECT CUSTOMER_TYPE, SUM(cogs * 0.05) AS total_vat
FROM WALMART
GROUP BY CUSTOMER_TYPE
ORDER BY total_vat DESC
LIMIT 1;

### Customer

-- 1. How many unique customer types does the data have?

SELECT 
    COUNT(DISTINCT CUSTOMER_TYPE) AS unique_customer_types
FROM
    WALMART;


-- 2. How many unique payment methods does the data have?

SELECT 
    COUNT(DISTINCT PAYMENT) AS unique_payment_methods
FROM
    WALMART;


-- 3. What is the most common customer type?
SELECT CUSTOMER_TYPE, COUNT(*) AS COMMON_CUSTOMER
FROM WALMART
GROUP BY CUSTOMER_TYPE
ORDER BY COMMON_CUSTOMER DESC
LIMIT 1;

-- 4. Which customer type buys the most?
SELECT CUSTOMER_TYPE, COUNT(*) AS MOST_BUY
FROM WALMART
GROUP BY CUSTOMER_TYPE
ORDER BY MOST_BUY DESC
LIMIT 1;


-- 5. What is the gender of most of the customers?
SELECT GENDER, COUNT(*) AS count
FROM WALMART
GROUP BY GENDER
ORDER BY count DESC
LIMIT 1;

-- 6. What is the gender distribution per branch?
SELECT BRANCH, GENDER, COUNT(*) AS gender_distribution_per_branch
FROM WALMART
GROUP BY BRANCH, GENDER
ORDER BY BRANCH;

-- 7. Which time of the day do customers give most ratings?
SELECT TIME_FORMAT(time, '%H:%i') AS time_of_day, AVG(rating) AS avg_rating
FROM WALMART
GROUP BY time_of_day
ORDER BY avg_rating DESC
LIMIT 1;

-- 8. Which time of the day do customers give most ratings per branch?
SELECT BRANCH, TIME_FORMAT(time, '%H:%i') AS time_of_day, AVG(rating) AS avg_rating
FROM WALMART
GROUP BY BRANCH, TIME_FORMAT(time, '%H:%i')
HAVING avg_rating = (
    SELECT MAX(avg_rating)
    FROM (
        SELECT BRANCH, TIME_FORMAT(time, '%H:%i') AS time_of_day, AVG(rating) AS avg_rating
        FROM WALMART
        GROUP BY BRANCH, TIME_FORMAT(time, '%H:%i')
    ) AS subquery
    WHERE subquery.BRANCH = WALMART.BRANCH
)
ORDER BY BRANCH, time_of_day;



-- 9. Which day of the week has the best avg ratings?

SELECT 
    DAYNAME(STR_TO_DATE(date, '%y-%m-%d')) AS day_of_week,
    AVG(rating) AS avg_rating
FROM
    WALMART
GROUP BY day_of_week
ORDER BY avg_rating DESC
LIMIT 1;

