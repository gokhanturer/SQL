/* 15 july 2021 -- Data Analysis with SQL - 2 - Tr*/

USE BikeStores

-- CROSS JOIN
-- Write a query that returns the table to be used to add products that are in the Products table but not in the stocks table to the stocks table with quantity = 0. 
-- (Do not forget to add products to all stores.)
-- Expected columns: store_id, product_id, quantity

SELECT B.store_id, A.product_id, A.product_name, 0 quantity
FROM production.products AS A
CROSS JOIN sales.stores AS B
WHERE A.product_id NOT IN (SELECT product_id FROM production.stocks)
ORDER BY A.product_id, B.store_id


-- CROSS JOIN 
-- Hangi markada hangi kategoride kaçar ürün olduðu bilgisine ihtiyaç duyuluyor
-- Ürün sayýsý hesaplamadan sadece marka * kategori ihtimallerinin hepsini içeren bir tablo oluþturun.
-- Çýkan sonucu daha kolay yorumlamak için brand_id ve category_id alanlarýna göre sýralayýn

SELECT * 
FROM production.brands
CROSS JOIN production.categories
ORDER BY production.brands.brand_id

-- SELF JOIN
-- Write a query that returns the staff with their managers.
-- Expected columns: staff first name, staff last name, manager name

SELECT *
FROM sales.staffs AS A
JOIN sales.staffs AS B
ON A.manager_id = B.staff_id

-- GROUPING OPERATIONS -1
-- Write a query that checks if any product id is repeated in more than one row in the products table.

SELECT TOP 20 *
FROM production.products

SELECT A.product_name, COUNT(A.product_name)
FROM production.products AS A
GROUP BY A.product_name
HAVING COUNT(A.product_name) >1;
-- WHERE is useful for another new table, for current table HAVING is okay.

SELECT product_id, COUNT(product_id) AS CNT_PRODUCT
FROM production.products
GROUP BY product_id, product_name
HAVING COUNT (product_id) > 1;

SELECT	product_id, COUNT (*) AS CNT_PRODUCT
FROM	production.products
GROUP BY product_id
HAVING COUNT (*) > 1


-- GROUPING OPERATIONS -2
-- Write a query that returns category ids with a maximum list price above 4000 or a minimum list price below 500.

SELECT category_id, MAX(list_price) AS max_list_price , MIN(list_price) AS min_list_price
FROM production.products
GROUP BY category_id
HAVING MAX(list_price)>4000 OR MIN(list_price)<500;

-- GROUPING OPERATIONS -3
-- Find the average product prices of the brands.
-- As a result of the query, the average prices should be displayed in descending order.

SELECT A.brand_name, AVG(B.list_price) AS avg_list_price
FROM production.brands AS A
INNER JOIN production.products AS B
ON A.brand_id = B.brand_id
GROUP BY A.brand_name
ORDER BY AVG(B.list_price) DESC;

SELECT A.brand_name, AVG(B.list_price) AS avg_list_price
FROM production.brands AS A, production.products AS B
WHERE A.brand_id = B.brand_id
GROUP BY A.brand_name
ORDER BY avg_list_price DESC;
-- As you can see, if you will write two table side by side with comma after FROM expression, you can use WHERE instead of INNER JOIN


-- GROUPING OPERATIONS -4
-- Write a query that returns BRANDS with an average product price of more than 1000.

SELECT B.brand_name, AVG(list_price) as avg_price
FROM production.products as A
INNER JOIN production.brands as B
ON A.brand_id = B.brand_id
GROUP BY brand_name
HAVING AVG (list_price) > 1000
ORDER BY avg_price ASC;

SELECT brands.brand_name, AVG(products.list_price) AS avg_price
FROM production.products, production.brands
WHERE products.brand_id = brands.brand_id
GROUP BY brands.brand_name
HAVING AVG(products.list_price) > 1000
ORDER BY AVG(products.list_price) ASC;


-- GROUPING OPERATIONS -5
-- Write a query that returns the net price paid by the customer for each order. (Don't neglect discounts and quantities)

SELECT A.order_id, SUM(quantity * list_price * (1-discount)) AS net_value -- (1-discount) for percentile
FROM sales.order_items AS A
GROUP BY A.order_id

SELECT order_id, SUM(quantity * (list_price-list_price*discount)) AS net_value -- (1-discount) for percentile
FROM sales.order_items
GROUP BY order_id


-- CREATING SUMMARY TABLE INTO OUR BIKESTORES TABLES

SELECT *
INTO NEW_TABLE
FROM SOURCE_TABLE
WHERE ...

SELECT C.brand_name as Brand, D.category_name as Category, B.model_year as Model_Year,
ROUND (SUM (A.quantity * A.list_price * (1 - A.discount)), 0) total_sales_price
INTO sales.sales_summary

FROM sales.order_items A, production.products B, production.brands C, production.categories D
WHERE A.product_id = B.product_id
AND B.brand_id = C.brand_id
AND B.category_id = D.category_id
GROUP BY
C.brand_name, D.category_name, B.model_year

-- GROUP BY with GROUPING SETS

-- 1. Total Sales (grouping by Brand)

SELECT SUM(total_sales_price)
FROM sales.sales_summary
GROUP BY Brand

-- 2. Total Sales (grouping by Category)

SELECT SUM(total_sales_price)
FROM sales.sales_summary
GROUP BY Category

-- 3. Total Sales (grouping by Brand and Category)

SELECT Brand, Category, SUM(total_sales_price)
FROM sales.sales_summary
GROUP BY Brand, Category

-- 4. Total Sales (grouping by Brand and Category and Brand-Category with GROUPING SETS)

SELECT	Brand, Category, SUM(total_sales_price)
FROM	sales.sales_summary
GROUP BY 
GROUPING SETS ((Brand),(Category),(Brand,Category),()) -- blank paranthesis is bringing us double null
ORDER BY 1,2;


-- GROUP BY with ROLLUP

-- 1. Total Sales (grouping by Brand and Category and Brand-Category with ROLLUP)

SELECT	Brand, Category, SUM(total_sales_price)
FROM	sales.sales_summary
GROUP BY 
ROLLUP (Brand, Category)
ORDER BY 1,2;

-- GROUP BY with CUBE

-- 1. Total Sales (grouping by Brand and Category and Brand-Category with CUBE)

SELECT	Brand, Category, SUM(total_sales_price)
FROM	sales.sales_summary
GROUP BY 
CUBE (Brand, Category)
ORDER BY 1,2;