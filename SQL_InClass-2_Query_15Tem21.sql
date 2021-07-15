-- 15.07.2021 DawSQL Sessinon 2

----- CROSS JOIN-----

-- Soru1: Hangi markada hangi kategoride ka�ar �r�n oldu�u bilgisine ihtiya� duyuluyor
-- �r�n say�s� hesaplamadan sadece marka * kategori ihtimallerinin hepsini i�eren bir tablo olu�turun
-- ��kan sonucu daha kolay yorumlamak i�in brand_id ve category_id alanlar�na g�re s�ralay�n.

SELECT *
FROM production.brands
CROSS JOIN production.categories
ORDER BY brand_id

----- SELF JOIN------

-- Soru2: Write a query that returns the staff with their managers.
-- Expected columns: staff first name, staff last name, manager name

SELECT *
FROM sales.staffs AS A
JOIN sales.staffs AS B
ON A.manager_id = B.staff_id

SELECT A.first_name AS Staff_Name, A.last_name AS Staff_Last, B.first_name AS Manager
FROM sales.staffs A, sales.staffs B
WHERE  A.manager_id = B.staff_id


---- GROUPBY / HAVING ----

--GROUPING OPERATION SORU1-- 
--Write a query that checks if any product id is repeated in more than one row in the products table.

SELECT A.product_name, COUNT(A.product_name)
FROM production.products AS A
GROUP BY A.product_name
HAVING COUNT(A.product_name) >1; --HAVING�DE kulland���n s�tun Aggregate te kulland���n s�tun ismiyle ayn� olmal�. 

-- hocan�n ��z�m�:
-- �nce products lar� g�relim.
SELECT TOP 20* 
FROM production.products

SELECT product_id, COUNT(*) AS CNT_PRODUCT 
FROM production.products
GROUP BY 
		product_id  -- b�t�n product_id lerin product tablosunda birer kere ge�ti�ini g�rd�m.


SELECT product_id, COUNT(*) AS CNT_PRODUCT 
FROM production.products
GROUP BY 
		product_id
HAVING               
		COUNT(*) > 1  --HAVING�DE kulland���n s�tun Aggregate te kulland���n s�tun ismiyle ayn� olmal�. 

-- product_name e g�re yapal�m
SELECT product_name, COUNT(*) AS CNT_PRODUCT  -- count(*) t�m rowlar� say demek. count(product_id) de ayn� i�i g�r�r.
FROM production.products
GROUP BY 
		product_name
HAVING 
		COUNT (*) > 1
-- a�a��daki gibi de kullanabiliriz.
SELECT product_name, COUNT(product_id) AS CNT_PRODUCT  -- count(*) t�m rowlar� say demek. count(product_id) de ayn� i�i g�r�r.
FROM production.products
GROUP BY 
		product_name
HAVING 
		COUNT (product_id) > 1


SELECT production_id, production_name, COUNT (*) CNT_PRODUCT
FROM production.products
GROUP BY
		product_name
HAVING 
		COUNT (*) > 1
-- select te yazd���n s�tunlar group by da olmas� gerekiyor. production_id group by da olmad��� i�in hata verdi.

SELECT production_id, production_name, COUNT (*) CNT_PRODUCT
FROM production.products
GROUP BY
		product_name, product_id
HAVING 
		COUNT (*) > 1


SELECT	product_id, COUNT (*) AS CNT_PRODUCT
FROM	production.products
GROUP BY
		product_id
HAVING
		COUNT (*) > 1

--GROUPING OPERATION SORU 2-- 
-- Write a query that returns category ids with a maximum list price above 4000 or a minimum list price below 500
SELECT category_id, MIN(list_price) AS min_price, MAX(list_price) AS max_price -- gruplad���m�z �ey category_id oldu�u i�in SELECT'te onu getiriyoruz
FROM production.products
-- ana tablo i�inde herhangi bir k�s�tlamam var m� yani where i�lemi var m�? yok. devam ediyorum
GROUP BY
		category_id
HAVING
		MIN(list_price) < 500 OR MAX(list_price) > 4000

--GROUPING OPERATION SORU 3-- 
-- Find the average product prices of the brands.
-- As a result of the query, the average prices should be displayed in descending order.

SELECT A.brand_name, AVG(B.list_price) AS AVG_PRICE
FROM production.brands A, production.products B  
-- buradaki virg�l INNER JOIN ile ayn� i�i yap�yor! virg�lle beraber WHERE kullan�yoruz.
WHERE A.brand_id = B.brand_id
GROUP BY 
		A.brand_name
ORDER BY
		AVG_PRICE DESC

-- (virg�l + WHERE yerine--> INNER JOIN ile ��z�m)
SELECT A.brand_name, AVG(B.list_price) AS AVG_PRICE
FROM production.brands AS A
INNER JOIN production.products AS B
ON A.brand_id = B.brand_id
GROUP BY 
		A.brand_name
ORDER BY 
		AVG_PRICE DESC
-- ORDER BY 2 DESC olarak da yazabilirdik. Burada 2 --> SELECT'teki ikinci belirtilen veriyi temsil ediyor.


--GROUPING OPERATION SORU 4-- 
-- Write a query that returns BRANDS with an average product price more than 1000
SELECT A.brand_name, AVG(B.list_price) AS AVG_PRICE
FROM production.brands A, production.products B  
WHERE A.brand_id = B.brand_id
GROUP BY 
		A.brand_name
HAVING AVG(B.list_price) > 1000
ORDER BY
		2 DESC

--GROUPING OPERATION SORU 5-- 
--  Write a query that returns the net price paid by the customer for each order. (Don't neglect discounts and quantities)
SELECT *, (quantity * list_price * (1-discount)) as net_price --list_price-list_price*discount olarak da yaz�labilir
FROM sales.order_items
-- bu query ile �nce her bire order_id i�in list_price ile indirim uygulanm�� net_price lar� g�r�yoruz.

-- order'larda birden fazla �r�n sipari� verilmi� oldu�unu g�rm��t�m. 
-- O y�zden �r�nleri order_id olarak grupland�r�p her grup i�in toplama (SUM) yaparak
-- her order i�in toplam net_price'� g�rm�� olaca��m
SELECT order_id, SUM(quantity * list_price * (1-discount)) as net_price
FROM sales.order_items
GROUP BY 
		order_id


--- SUMMARY TABLE---

SELECT *
INTO NEW_TABLE -- INTO SATIRINDAK� TABLO �SEM� �LE YEN� B�R TABLO OLU�TURUYORUZ.
FROM SOURCE_TABLE  -- FROM'DAN SONRASI KAYNAK TABLOMUZ
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

SELECT *
FROM sales.sales_summary
ORDER BY 1,2,3

-- Bundan sonra bu tabloyu kullanaca��m!

--- GROUPING SETS----

-- 1. Toplam sales miktar�n� hesaplay�n�z.
SELECT SUM(total_sales_price)
FROM sales.sales_summary

-- 2. Markalar�n toplam sales miktar�n� hesaplay�n�z.
SELECT Brand, SUM(total_sales_price)
FROM sales.sales_summary
GROUP BY 
		Brand

-- 3. Kategori baz�nda toplam sales miktar�n� hesaplay�n�z
SELECT Category, SUM(total_sales_price)
FROM sales.sales_summary
GROUP BY 
		Category

-- 4. Marka ve kategori k�r�l�mlar�ndaki toplam sales miktarlar�n� hesaplay�n�z
SELECT Brand, Category, SUM(total_sales_price)
FROM sales.sales_summary
GROUP BY 
		Brand, Category

-- BU ��LERMLER� GROUPING SETS Y�NTEM� �LE YAPALIM :---
SELECT brand, category, SUM(total_sales_price)
FROM sales.sales_summary
GROUP BY
		GROUPING SETS(
						(Brand),
						(category),
						(brand, category),
						()      -- bo� parantez ile 
						)
ORDER BY
		1,2


----- ROLLUP GRUPLAMA-----
SELECT
		d1,
		d2,
		d3, 
		aggregate_function
FROM
		table_name
GROUP BY
		ROLLUP (d1,d2,d3);

		-- �nce t�m s�tu�nlar� al�yor sonra sa�dan ba�layarak teker teker silerek her defas�nda yeniden bir gruplama yap�yor;
		-- �nce �� s�tuna g�re grupluyor, sonra sondakini at�p ilk 2 s�tuna g�re grupluyor
		-- sonra sondakini yine at�p ilk s�tuna g�re grupluyor
		-- sonra hi� gruplam�yor.-- 

SELECT brand, category, SUM(total_sales_price)
FROM sales.sales_summary
GROUP BY
		ROLLUP (Brand, Category)
ORDER BY
		1,2
		;


--- CUBE GRUPLAMA----

--- �nce �nce �� s�tunu birden grupluyor
-- sonra kalanlar� 2'�er 2'�er 3 defa gruplama yap�yor
-- sonra kalanlar� teker teker grupluyor
-- en son gruplam�yor.

SELECT brand, category, SUM(total_sales_price)
FROM sales.sales_summary
GROUP BY
		CUBE (Brand, Category)
ORDER BY
		1,2
		;