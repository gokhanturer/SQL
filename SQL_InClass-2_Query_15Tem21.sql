-- 15.07.2021 DawSQL Sessinon 2

----- CROSS JOIN-----

-- Soru1: Hangi markada hangi kategoride kaçar ürün olduðu bilgisine ihtiyaç duyuluyor
-- Ürün sayýsý hesaplamadan sadece marka * kategori ihtimallerinin hepsini içeren bir tablo oluþturun
-- Çýkan sonucu daha kolay yorumlamak için brand_id ve category_id alanlarýna göre sýralayýn.

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
HAVING COUNT(A.product_name) >1; --HAVING’DE kullandýðýn sütun Aggregate te kullandýðýn sütun ismiyle ayný olmalý. 

-- hocanýn çözümü:
-- önce products larý görelim.
SELECT TOP 20* 
FROM production.products

SELECT product_id, COUNT(*) AS CNT_PRODUCT 
FROM production.products
GROUP BY 
		product_id  -- bütün product_id lerin product tablosunda birer kere geçtiðini gördüm.


SELECT product_id, COUNT(*) AS CNT_PRODUCT 
FROM production.products
GROUP BY 
		product_id
HAVING               
		COUNT(*) > 1  --HAVING’DE kullandýðýn sütun Aggregate te kullandýðýn sütun ismiyle ayný olmalý. 

-- product_name e göre yapalým
SELECT product_name, COUNT(*) AS CNT_PRODUCT  -- count(*) tüm rowlarý say demek. count(product_id) de ayný iþi görür.
FROM production.products
GROUP BY 
		product_name
HAVING 
		COUNT (*) > 1
-- aþaðýdaki gibi de kullanabiliriz.
SELECT product_name, COUNT(product_id) AS CNT_PRODUCT  -- count(*) tüm rowlarý say demek. count(product_id) de ayný iþi görür.
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
-- select te yazdýðýn sütunlar group by da olmasý gerekiyor. production_id group by da olmadýðý için hata verdi.

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
SELECT category_id, MIN(list_price) AS min_price, MAX(list_price) AS max_price -- grupladýðýmýz þey category_id olduðu için SELECT'te onu getiriyoruz
FROM production.products
-- ana tablo içinde herhangi bir kýsýtlamam var mý yani where iþlemi var mý? yok. devam ediyorum
GROUP BY
		category_id
HAVING
		MIN(list_price) < 500 OR MAX(list_price) > 4000

--GROUPING OPERATION SORU 3-- 
-- Find the average product prices of the brands.
-- As a result of the query, the average prices should be displayed in descending order.

SELECT A.brand_name, AVG(B.list_price) AS AVG_PRICE
FROM production.brands A, production.products B  
-- buradaki virgül INNER JOIN ile ayný iþi yapýyor! virgülle beraber WHERE kullanýyoruz.
WHERE A.brand_id = B.brand_id
GROUP BY 
		A.brand_name
ORDER BY
		AVG_PRICE DESC

-- (virgül + WHERE yerine--> INNER JOIN ile çözüm)
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
SELECT *, (quantity * list_price * (1-discount)) as net_price --list_price-list_price*discount olarak da yazýlabilir
FROM sales.order_items
-- bu query ile önce her bire order_id için list_price ile indirim uygulanmýþ net_price larý görüyoruz.

-- order'larda birden fazla ürün sipariþ verilmiþ olduðunu görmüþtüm. 
-- O yüzden ürünleri order_id olarak gruplandýrýp her grup için toplama (SUM) yaparak
-- her order için toplam net_price'ý görmüþ olacaðým
SELECT order_id, SUM(quantity * list_price * (1-discount)) as net_price
FROM sales.order_items
GROUP BY 
		order_id


--- SUMMARY TABLE---

SELECT *
INTO NEW_TABLE -- INTO SATIRINDAKÝ TABLO ÝSEMÝ ÝLE YENÝ BÝR TABLO OLUÞTURUYORUZ.
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

-- Bundan sonra bu tabloyu kullanacaðým!

--- GROUPING SETS----

-- 1. Toplam sales miktarýný hesaplayýnýz.
SELECT SUM(total_sales_price)
FROM sales.sales_summary

-- 2. Markalarýn toplam sales miktarýný hesaplayýnýz.
SELECT Brand, SUM(total_sales_price)
FROM sales.sales_summary
GROUP BY 
		Brand

-- 3. Kategori bazýnda toplam sales miktarýný hesaplayýnýz
SELECT Category, SUM(total_sales_price)
FROM sales.sales_summary
GROUP BY 
		Category

-- 4. Marka ve kategori kýrýlýmlarýndaki toplam sales miktarlarýný hesaplayýnýz
SELECT Brand, Category, SUM(total_sales_price)
FROM sales.sales_summary
GROUP BY 
		Brand, Category

-- BU ÝÞLERMLERÝ GROUPING SETS YÖNTEMÝ ÝLE YAPALIM :---
SELECT brand, category, SUM(total_sales_price)
FROM sales.sales_summary
GROUP BY
		GROUPING SETS(
						(Brand),
						(category),
						(brand, category),
						()      -- boþ parantez ile 
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

		-- önce tüm sütuýnlarý alýyor sonra saðdan baþlayarak teker teker silerek her defasýnda yeniden bir gruplama yapýyor;
		-- önce üç sütuna göre grupluyor, sonra sondakini atýp ilk 2 sütuna göre grupluyor
		-- sonra sondakini yine atýp ilk sütuna göre grupluyor
		-- sonra hiç gruplamýyor.-- 

SELECT brand, category, SUM(total_sales_price)
FROM sales.sales_summary
GROUP BY
		ROLLUP (Brand, Category)
ORDER BY
		1,2
		;


--- CUBE GRUPLAMA----

--- önce önce üç sütunu birden grupluyor
-- sonra kalanlarý 2'þer 2'þer 3 defa gruplama yapýyor
-- sonra kalanlarý teker teker grupluyor
-- en son gruplamýyor.

SELECT brand, category, SUM(total_sales_price)
FROM sales.sales_summary
GROUP BY
		CUBE (Brand, Category)
ORDER BY
		1,2
		;