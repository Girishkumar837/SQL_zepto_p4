DROP TABLE IF EXISTS 

CREATE TABLE zepto(
		sku_id SERIAL PRIMARY KEY,
		Category VARCHAR(120),
		name VARCHAR(150) NOT NULL,
		mrp	NUMERIC(8,2),
		discountPercent	NUMERIC(5,2),
		availableQuantity	INTEGER,
		discountedSellingPrice	NUMERIC(8,2),
		weightInGms	 INTEGER,
		outOfStock BOOLEAN,
		quantity INTEGER
);

-- Date Exploration 

-- Count of rows
SELECT COUNT(*) FROM zepto;

SELECT * FROM zepto
LIMIT 10;

--  Null values 
SELECT * FROM zepto 
WHERE name IS NULL 
	OR category IS NULL
	OR mrp IS NULL 
	OR discountpercent IS NULL 
	OR availablequantity IS NULL 
	OR discountedsellingprice IS NULL 
	OR weightingms IS NULL 
	OR outofstock is NULL
	OR quantity IS NULL;

-- Different product category 
SELECT 
	DISTINCT(category)
FROM zepto 
ORDER BY 1;

-- Products instock vs outofstock
SELECT 
	outofstock,
	COUNT(sku_id)
FROM ZEPTO 
GROUP BY 1;

-- Product name present multiple times
SELECT 
	NAME,
	COUNT(sku_id) as stock_keeping_units 
FROM zepto 
GROUP BY 1
HAVING COUNT(sku_id) > 1
ORDER BY 2 DESC;

-- Data cleaning 
-- Products with price = 0
SELECT 
	sku_id,
	name 
FROM zepto 
WHERE mrp = 0;

DELETE FROM zepto 
WHERE mrp = 0;

-- Convert Paise into rupees 
UPDATE zepto 
SET mrp = mrp/100.0,
discountedsellingprice = discountedsellingprice/100.0;

SELECT 
	mrp, 
	discountedsellingprice
FROM zepto;

-- Q1. Find top 10 best-value products based on discount percentage
SELECT 
	DISTINCT name,
	category,
	discountpercent
FROM zepto 
ORDER BY 3 DESC
LIMIT 10;


-- Q2.Identified high-MRP products that are currently out of stock
SELECT 
	DISTINCT name,
	mrp
FROM zepto 
WHERE outofstock = TRUE AND mrp > 300
ORDER BY 2;

-- Q3.Estimated potential revenue for each product category
SELECT 
	category,
	SUM(discountedsellingprice*availablequantity) as revenue
FROM zepto 
GROUP BY category
ORDER BY 2;

-- Q4.Filtered expensive products (MRP > ₹500) with minimal discount

SELECT 
	DISTINCT name,
	mrp,
	discountpercent
FROM zepto 
WHERE mrp > 500 AND discountpercent < 10
ORDER BY 2 DESC, 3 DESC;

-- Q5.Identify top Ranked 5 categories offering highest average discounts
SELECT 
	category,
	ROUND(AVG(discountpercent),2) as avg_discount 
FROM zepto 
GROUP BY 1 
ORDER BY 2 DESC
LIMIT 5;

-- Q6. Find the price per gram for products above 100g and sort by best value
SELECT
	DISTINCT name,
	weightingms,
	discountedsellingprice,
	ROUND(discountedsellingprice/weightingms,2) as price_per_gram
FROM zepto
WHERE weightingms >= 100
ORDER BY 4;

-- 7.Grouped products into categories like Low, Medium, and Bulk.
SELECT 
	DISTINCT name,
	weightingms,
	CASE WHEN weightingms < 1000 THEN 'Low'
		 WHEN weightingms < 5000 THEN 'Medium'
		 ELSE 'Bulk'
		 END AS weight_category 
FROM zepto;

-- 8. What is the total inventory weight per product category

SELECT 
	category,
	SUM(weightingms * availablequantity) as total_weight
FROM zepto 
GROUP BY 1
ORDER BY 2;

--------------- END OF PROJECT ------------------