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
SELECT A.city, COUNT(A.city) AS number_of_customerFROM sales.customers AS AWHERE A.state = 'TX'GROUP BY A.cityORDER BY A.city



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

-- C8316 SüleymanHoca
select 	A.product_name,	A.list_pricefrom production.products as A, production.stocks as Bwhere A.product_id = B.product_idand B.store_id = 2 and B.quantity > 25order by A.product_name;



-----5. Find the customers who locate in the same zip code------ YAPAMADIM HENÜZ
SELECT *
FROM sales.customers

SELECT zip_code
FROM sales.customers

-- C8113-KaanHoca
SELECT a.zip_code,	a.first_name+' '+a.last_name as customer1,	b.first_name+' '+b.last_name as customer2FROM sales.customers as  a, sales.customers b WHERE a.customer_id > b.customer_idAND a.zip_code = b.zip_codeORDER BY zip_code, customer1, customer2

--C8329 JosephHoca
select zip_code,first_name, last_name  from sales.customers intersect select zip_code,first_name, last_name from sales.customers

--5. soruya self join ile alternatif cevap da buradadýr.SELECT A.zip_code,A.first_name+' '+A.last_name AS customer1,B.first_name+' '+B.last_name AS customer2FROM sales.customers AS AJOIN sales.customers AS BON A.zip_code = B.zip_codeWHERE a.customer_id > b.customer_idORDER BY zip_code, customer1, customer2



-----6. Return first name, last name, e-mail and phone number of the customers------
SELECT *
FROM sales.customers

SELECT ISNULL(first_name, ' ') + ' ' + ISNULL(last_name, ' ') AS full_name, email, ISNULL(phone, 'n/a')
FROM sales.customers;

--C8113-KaanHoca
select first_name, last_name,email,coalesce(phone, 'no number') phonefrom sales.customers


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
SELECT DISTINCT product_name,list_priceFROM production.productsWHERE list_price > (SELECT AVG (list_price)FROM production.productsWHERE brand_id in (SELECT brand_idFROM production.brandsWHERE brand_name = 'Electra'OR brand_name='Heller'))ORDER by list_price


--C8120 RaifeHoca
select distinct product_name, list_pricefrom production.productswhere list_price > (select avg(p.list_price)					from production.products p					inner join production.brands b					on b.brand_id = p.brand_id					where b.brand_name = 'Electra' or b.brand_name = 'Heller')order by list_price


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
SELECT product_idFROM production.productsEXCEPTSELECT product_idFROM sales.order_items


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
WITH cte_avg_sale AS(	SELECT staff_id, Count(order_id) as sales_count	FROM sales.orders	WHERE YEAR(order_date)=2017	GROUP BY staff_id	)SELECT AVG(sales_count) as 'Average Number of Sales'FROM cte_avg_sale


--C8176 DamlaHoca
SELECT AVG(A.sales_amounts) AS 'Average Number of Sales'FROM (    SELECT COUNT(order_id) sales_amounts    FROM sales.orders    WHERE order_date LIKE '%2017%'     GROUP BY staff_id    ) as A



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
select s.first_name, s.last_name, year(o.order_date) as year, avg((i.list_price-i.discount)*i.quantity) as avg_amountfrom sales.staffs sinner join sales.orders oon s.staff_id=o.staff_idinner join sales.order_items ion o.order_id=i.order_idgroup by s.first_name, s.last_name, year(o.order_date)order by first_name, last_name, year(o.order_date)

-- C8329 JosephHoca
CREATE VIEW view_table ASselect A.order_id, item_id, product_id,customer_id,B.store_id, C.staff_id,quantity,list_price, discount,C.first_name, C.last_name, year(order_date) as yearfrom sales.order_items A, sales.orders B, sales.staffs Cwhere A.order_id = B.order_idand B.staff_id = C.staff_id;select first_name, last_name,staff_id,year, avg((list_price-discount)*quantity) as avg_list_price from view_tablegroup by year,staff_id,first_name,last_nameorder by year


-- C8113 KaanHoca
CREATE VIEW sales.staff_sales (        first_name,         last_name,        year,         avg_amount)AS     SELECT         first_name,        last_name,        YEAR(order_date),        AVG(list_price * quantity) as avg_amount    FROM        sales.order_items i    INNER JOIN sales.orders o        ON i.order_id = o.order_id    INNER JOIN sales.staffs s        ON s.staff_id = o.staff_id    GROUP BY         first_name,         last_name,         YEAR(order_date);--------------SELECT      * FROM     sales.staff_salesORDER BY 	first_name,	last_name,	year;


