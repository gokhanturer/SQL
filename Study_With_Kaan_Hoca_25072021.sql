-----------BASICS----------

---- SQL is very easy to learn. ENJOY!!!


----1. All the cities in the Texas and the numbers of customers in each city.---
SELECT *
FROM sales.customers

SELECT city, COUNT(customer_id) AS number_of_customer
FROM sales.customers
WHERE state = 'TX'
GROUP BY city;

-- C8270 EmirHoca
SELECT A.city, COUNT(A.city) AS number_of_customer



----2. All the cities in the California which has more than 5 customer, by showing the cities which have more customers first.---
SELECT *
FROM sales.customers

SELECT city, COUNT(customer_id) AS 'number of customer'
FROM sales.customers
WHERE state = 'CA'
GROUP BY city
HAVING COUNT(customer_id) > 5
ORDER BY 'number of customer' DESC;


-----3. The top 10 most expensive products------
SELECT *
FROM production.products

SELECT TOP 10 product_name, list_price
FROM production.products
ORDER BY list_price DESC;


-----4. Product name and list price of the products which are located in the store id 2 and the quantity is greater than 25------
SELECT *
FROM production.products

SELECT *
FROM production.stocks

SELECT product_name, list_price
FROM production.products
WHERE product_id IN (
					SELECT product_id
					FROM production.stocks
					WHERE store_id = 2
					AND quantity > 25)
ORDER BY product_name ASC;

-- C8316 S�leymanHoca
select 



-----5. Find the customers who locate in the same zip code------ YAPAMADIM HEN�Z
SELECT *
FROM sales.customers

SELECT zip_code
FROM sales.customers

-- C8113-KaanHoca
SELECT a.zip_code,

--C8329 JosephHoca
select zip_code,first_name, last_name  from sales.customers 

--5. soruya self join ile alternatif cevap da buradad�r.



-----6. Return first name, last name, e-mail and phone number of the customers------
SELECT *
FROM sales.customers

SELECT ISNULL(first_name, ' ') + ' ' + ISNULL(last_name, ' ') AS full_name, email, ISNULL(phone, 'n/a')
FROM sales.customers;

--C8113-KaanHoca
select first_name, last_name,email,coalesce(phone, 'no number') phone


-----7. Find the sales order of the customers who lives in Houston order by order date------
SELECT *
FROM sales.customers

SELECT *
FROM sales.orders

SELECT 
	A.order_id, 
	A.order_date,
	B.customer_id
FROM sales.orders A
INNER JOIN sales.customers B
	ON A.customer_id = B.customer_id
WHERE B.city = 'Houston'
ORDER BY order_date ASC;

SELECT order_id, order_date, customer_id
FROM sales.orders
WHERE customer_id IN (
					SELECT customer_id
					FROM sales.customers
					WHERE city = 'Houston')
ORDER BY order_date ASC;


-----8. Find the products whose list price is greater than the average list price of all products with the Electra or Heller ------
SELECT *
FROM production.products

SELECT *
FROM production.brands

SELECT AVG(list_price)
FROM production.brands A
INNER JOIN production.products B
ON A.brand_id = B.brand_id
WHERE A.brand_name = 'Electra';

SELECT AVG(list_price)
FROM production.brands A
INNER JOIN production.products B
ON A.brand_id = B.brand_id
WHERE A.brand_name = 'Heller';

SELECT DISTINCT(product_name), list_price
FROM production.products
WHERE list_price > (
					SELECT AVG(list_price)
					FROM production.brands A
					INNER JOIN production.products B
						ON A.brand_id = B.brand_id
					WHERE A.brand_name IN ('Electra', 'Heller'))
ORDER BY list_price ASC;

SELECT DISTINCT(product_name), list_price
FROM production.products
WHERE list_price > (
					SELECT AVG(list_price)
					FROM production.brands A, production.products B
					WHERE A.brand_id = B.brand_id
					AND A.brand_name IN ('Electra', 'Heller'))
ORDER BY list_price ASC;

--C8113 KaanHoca
SELECT DISTINCT product_name,list_price


--C8120 RaifeHoca
select distinct product_name, list_price


-----9. Find the products that have no sales ------
SELECT *
FROM sales.order_items

SELECT *
FROM production.products

SELECT product_id
FROM production.products
WHERE product_id NOT IN (
						SELECT product_id
						FROM sales.order_items);

--C8113 KaanHoca
SELECT product_id


---- 10. Return the average number of sales orders in 2017 sales----
SELECT *
FROM sales.orders

SELECT *
FROM sales.order_items

SELECT *
FROM sales.staffs

SELECT COUNT(order_id) AS Count_of_Sales
INTO Total_Orders_2017
FROM sales.orders
WHERE YEAR(order_date) = 2017;

SELECT COUNT(first_name) AS Count_of_Staffs
INTO Staffs_Sold_2017
FROM sales.staffs
WHERE staff_id IN (
				SELECT staff_id
				FROM sales.orders
				WHERE YEAR(order_date) = 2017);

SELECT A.Count_of_Sales / B.Count_of_Staffs AS 'Average Number of Sales'
FROM Total_Orders_2017 A, Staffs_Sold_2017 B;

--C8113 KaanHoca
WITH cte_avg_sale AS(


--C8176 DamlaHoca
SELECT AVG(A.sales_amounts) AS 'Average Number of Sales'



----11.  By using view get the sales by staffs and years using the AVG() aggregate function:
SELECT *
FROM sales.staffs

SELECT *
FROM sales.orders

SELECT *
FROM sales.order_items

CREATE VIEW STUDY_WITH_KAAN_HOCA AS

SELECT	first_name, last_name, year, avg_amount
FROM
	(
	SELECT	A.first_name, A.last_name, 
		YEAR(B.order_date) AS year, 
		AVG(C.quantity * C.list_price) AS avg_amount
	FROM	sales.staffs A, sales.orders B, sales.order_items C
	WHERE	A.staff_id = B.staff_id AND
				B.order_id = C.order_id
	GROUP BY A.first_name, A.last_name, YEAR(B.order_date)
	) A
;

SELECT *
FROM STUDY_WITH_KAAN_HOCA
ORDER BY first_name, last_name, year


-- C8120 RaifeHoca
select s.first_name, s.last_name, year(o.order_date) as year, avg((i.list_price-i.discount)*i.quantity) as avg_amount

-- C8329 JosephHoca
CREATE VIEW view_table AS


-- C8113 KaanHoca
CREATE VIEW sales.staff_sales (

