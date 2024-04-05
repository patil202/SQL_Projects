select * from superstore

#Q1.view of superstore sales dataset:
 Total no of orders
 Total sales
 Total Quantity of products sold
 Average profit
 Average discount
 Total no of products
 Total number of categories
 Total number of subcategories
 Total Years
 Total countries
Answer:
select count(ï»¿order_id) as total_id,
sum(sales) as total_sales,
sum(quantity) as total_quantity,
avg(profit) as avg_profit,
avg(discount) as avg_discount,
COUNT(DISTINCT product_name) AS Total_products,
COUNT(DISTINCT category) AS Total_categories,
COUNT(DISTINCT sub_category) AS Total_subcategories,
COUNT(DISTINCT year) AS Total_years,
COUNT(DISTINCT country) AS Total_countries
 from superstore
 
 #Q2. Sales Performance Analysis:
 Identify the top-selling products and categories.
 Analyze sales trends over the years and highlight any significant patterns.
Answer:
select product_id, category, SUM(sales) AS Toatl_sales,
SUM(quantity) AS Total_quantity_sold
from superstore
GROUP BY
product_name,
category
ORDER BY SUM(sales) DESC
 
 --sales over year --
SELECT 
year,
SUM(sales) AS Total_sales
FROM superstore
GROUP BY year
ORDER BY SUM(sales) DESC

#Q3. Customer Segmentation:
 Segment customers based on their purchasing behavior.
 Understand which segments contribute most to the sales.
Answer:
SELECT
segment,
COUNT(DISTINCT customer_name) AS Toatl_customers,
SUM(sales) AS Total_sales
FROM superstore
GROUP BY segment
ORDER BY SUM(sales) DESC

Q4. Shipping and Order Management:
 Evaluate the efficiency of different shipping modes.
 Analyze shipping costs and their impact on overall profitability.
 Assess order processing times and identify areas for improvement.
Answer:
SELECT
ship_mode,
AVG(shipping_cost) AS Avg_shipping_cost,
AVG(profit) AS Avg_profit
FROM superstore
GROUP BY ship_mode
ORDER BY AVG(profit)

--time analysis --
SELECT
ship_mode,
AVG(DATEDIFF(DAY, TRY_CAST(order_date AS DATE), TRY_CAST(ship_date AS DATE))) AS Avg_time_gape
FROM superstore
GROUP BY ship_mode

Q5.Profitability and Cost Analysis:
 Analyze profit margins for different product categories and sub-categories.
 Evaluate the impact of discounts on overall profitability.
 Identify products or regions that may require cost optimization.
Answer:
SELECT
product_name,
category,
sub_category,
AVG(profit) AS Avg_profit,
AVG(discount) AS Avg_dicount
FROM superstore
GROUP BY 
product_name,
category,
sub_category
ORDER BY AVG(profit) DESC

Q6. Global Sales/Product Quantity Overview:
 Analyze the distribution of sales across different countries.
 Identify the most sold products in each country.
Answer:
SELECT
country,
SUM(sales) AS Total_sales,
SUM(quantity)  AS Total_quantity
FROM superstore
GROUP BY country
ORDER BY SUM(sales) DESC


Q7. State-Level Category Exploration:
 Understand the most used product categories in different states.
Answer:
SELECT 
product_name,
category,
SUM(quantity) AS Total_quantity_sold
FROM superstore
GROUP BY 
product_name,
category
ORDER BY SUM(quantity) DESC

Q8. Regional Sub-Category Analysis:
 Analyze the popularity of sub-categories in different regions.
Answer:
SELECT
region,
sub_category,
SUM(quantity) AS Total_quantity_sold
FROM superstore
GROUP BY region,
sub_category
ORDER BY SUM(quantity) DESC


