---Question: List customers who have an order prior to the last order of a customer named Sharyn Hopkins and are residents of the city of San Diego.---



with T1 AS
( 
select max(B.order_date) LAST_ORDER
from sales.customers A, sales.orders B
where A.customer_id = B.customer_id
and A.first_name = 'Sharyn'
and A.last_name = 'Hopkins'
)

select *
from sales.customers A, sales.orders B, T1 C 
where A.customer_id = B.customer_id
and B.order_date < C.LAST_ORDER
and A.city = 'San Diego'


---0'dan 9'a kadar herbir rakam bir satırda olacak şekilde bir tablo oluşturun--

WITH T1 AS
		  (
		  SELECT 0 AS number
		  UNION ALL
		  SELECT number + 1
		  FROM T1
		  WHERE number <= 8
		  )
SELECT *
FROM T1
----ALTER

-------her seferinde aynı tabloyu tekrar tekrar kullanmak istersem:
WITH T1 AS
(
SELECT 0 number
UNION ALL
SELECT number +1 
FROM T1
WHERE  number < 9       --sonsuza kadar yapmaması için ve hata vermemesi için burada limitliyoruz.
)
SELECT * FROM T1



----



select B.brand_id, B.brand_name
from production.products A, production.brands B 
where A.brand_id = B.brand_id
and A.model_year = 2016 
INTERSECT
select B.brand_id, B.brand_name
from production.products A, production.brands B 
where A.brand_id = B.brand_id
and A.model_year = 2017



-----------Question: Write a query that returns customers who have orders for both 2016, 2017, and 2018
select A.first_name, A.last_name
from sales.customers A, sales.orders B 
where A.customer_id = B.customer_id
and year(order_date) = 2016
INTERSECT
select A.first_name, A.last_name
from sales.customers A, sales.orders B 
where A.customer_id = B.customer_id
and year(order_date) = 2017
INTERSECT
select A.first_name, A.last_name
from sales.customers A, sales.orders B 
where A.customer_id = B.customer_id
and year(order_date) = 2018
----

SELECT	first_name, last_name
FROM	sales.customers
WHERE	customer_id IN (
						SELECT	customer_id
						FROM	sales.orders
						WHERE	order_date BETWEEN '2016-01-01' AND '2016-12-31'
						INTERSECT
						SELECT	customer_id
						FROM	sales.orders
						WHERE	order_date BETWEEN '2017-01-01' AND '2017-12-31'
						INTERSECT
						SELECT	customer_id
						FROM	sales.orders
						WHERE	order_date BETWEEN '2018-01-01' AND '2018-12-31'
						) 


---------Question: Write a query that returns only products ordered in 2017 (not ordered in other years).

select B.brand_id, B.brand_name
from production.products A, production.brands B 
where A.brand_id = B.brand_id
and A.model_year = 2016 
EXCEPT
select B.brand_id, B.brand_name
from production.products A, production.brands B 
where A.brand_id = B.brand_id
and Amodel_year = 2017




----


---

select A.product_id, a.product_name
from production.products A, sales.orders B, sales.order_items C
where A.product_id = C.product_id
and B.order_id = C.order_id
and year(order_date) = 2017
except
select A.product_id, a.product_name
from production.products A, sales.orders B, sales.order_items C
where A.product_id = C.product_id
and B.order_id = C.order_id
and YEAR(order_date) <> 2017

----

select order_status,
    CASE order_status WHEN 1 THEN 'Pending'
                      WHEN 2 THEN 'Processing'
                      WHEN 3 THEN 'Rejected'
                      WHEN 4 THEN 'Completed'
    END AS MEANOFSTATUS
FROM sales.orders



from sales.orders


----Create a new column containing the labels of the customers' email service providers ( "Gmail", "Hotmail", "Yahoo" or "Other" )


SELECT email,
		CASE        WHEN email LIKE '%gmail%' THEN 'GMAIL'
					WHEN email LIKE '%hotmail%' THEN 'HOTMAIL'
					WHEN email LIKE '%yahoo%' THEN 'YAHOO'
					ELSE 'OTHER'
		END AS email_service_providers
FROM sales.customers




