------------- 2021-7-31 DAwSQL Session 5 (Data Functions) --------------------


-- �NCEK� DERS KONUSUNDAN B�R SORU �LE BA�LIYORUZ:

-- List customer who bought both 'Electric Bikes' and 'Comfort Bicycles' and 'Children Bicycles' in the same order.


-- �nce istenen kategorilerden elektric bikes'a bir bakal�m.
select category_id
from production.categories
where category_name = 'Electric Bikes' 

-- category_id products tablosunda oldu�undan join i�in products'a gitmem gerek.
	-- order lara ula�mam gerekti�inden product_id �zerinden order_items'a gitmem gerekecek.
SELECT B.order_id
FROM production.products A, sales.order_items B
WHERE A.product_id = B.product_id
AND   A.category_id = (

					select category_id
					from production.categories
					where category_name = 'Electric Bikes'
					)

INTERSECT

SELECT B.order_id
FROM production.products A, sales.order_items B
WHERE A.product_id = B.product_id
AND   A.category_id = (

					select category_id
					from production.categories
					where category_name = 'Comfort Bicycles'
					)

INTERSECT

SELECT B.order_id
FROM production.products A, sales.order_items B
WHERE A.product_id = B.product_id
AND   A.category_id = (

					select category_id
					from production.categories
					where category_name = 'Children Bicycles'
					)

-- order_id'lere ula�t�m. bizden customerlar� istiyordu. 
	-- yukardaki query sonucunda gelen order_id leri subquery yap�yorum ve bu id leri sipari� veren customerlara ula��yorum

SELECT	A.customer_id, A.first_name, A.last_name
FROM	sales.customers A, sales.orders B
WHERE	A.customer_id = B.customer_id
AND		B.order_id IN (
						SELECT B.order_id
						FROM production.products A, sales.order_items B
						WHERE A.product_id = B.product_id
						AND   A.category_id = (

											select category_id
											from production.categories
											where category_name = 'Electric Bikes'
											)

						INTERSECT

						SELECT B.order_id
						FROM production.products A, sales.order_items B
						WHERE A.product_id = B.product_id
						AND   A.category_id = (

											select category_id
											from production.categories
											where category_name = 'Comfort Bicycles'
											)

						INTERSECT

						SELECT B.order_id
						FROM production.products A, sales.order_items B
						WHERE A.product_id = B.product_id
						AND   A.category_id = (

											select category_id
											from production.categories
											where category_name = 'Children Bicycles'
											)
											)



------------------------		DATE FUNCTIONS		-----------------------

CREATE TABLE t_date_time (
	A_time time,
	A_date date,
	A_smalldatetime smalldatetime,
	A_datetime datetime,
	A_datetime2 datetime2,
	A_datetimeoffset datetimeoffset )


SELECT *
FROM t_date_time

-- INSERT VALUES TO THE TABLE

INSERT t_date_time (A_time, A_date, A_smalldatetime, A_datetime, A_datetime2, A_datetimeoffset)
VALUES
('12:00:00', '2021-07-17', '2021-07-17', '2021-07-17', '2021-07-17', '2021-07-17')

SELECT * 
FROM t_date_time
-- girilen value lar� s�tunlar�n (tablo olu�turulurken tan�mlanan) date ve datetime tiplerine otomatik olarak �evirdi.


----------------------------------
		-- TIMEFROMPART() FUNCTION

-- The TIMEFROMPARTS() function returns a fully initialized time value. 
	-- It requires five arguments as shown in the following syntax:
		--TIMEFROMPARTS ( hour, minute, seconds, fractions, precision)
		-- EXAMPLE:
		SELECT 
    TIMEFROMPARTS(23, 59, 59, 0, 0) AS Time;
		-- EXAMPLE:
		SELECT 
    TIMEFROMPARTS(06, 30, 15, 5, 2) Time;
	-- sondaki precision'�n 2 verildi�inde nas�l g�z�kt���ne dikkat et.(saniye fraction'u iki basamakl� g�steriyor)
	-- 2 verirsek saniyenin 100 de 1'ine kadar kesinlik sa�lar�z. 3 verirsek 1000 de biri kadar kesinlik sa�lar�z.

-- Bizim �rne�imize d�nersek:
INSERT t_date_time (A_time) VALUES (TIMEFROMPARTS(12,0,0,0,0));
-- saat 12, dakika ve saniye 0 girildi. precision 0 verildi�inde nas�l g�z�kt���ne dikkat et!

SELECT * 
FROM t_date_time

INSERT INTO t_date_time (A_date) VALUES (DATEFROMPARTS(2021,05,17));

SELECT * 
FROM t_date_time


-- FORMATI DE���T�RMEK ���N:
SELECT CONVERT(varchar, GETDATE(), 6)


INSERT INTO t_date_time(A_datetime) VALUES(DATETIMEFROMPARTS(2021,05,17,020,0,0,0));


INSERT INTO t_date_time (A_datetimeoffset) VALUES (DATETIMEOFFSETFROMPARTS(2021,05,17, 20,0,0,0, 2,0,0));


-- DATENAME() : DATENAME() function returns a string, NVARCHAR type, that represents a specified date part e.g., 
	--year, month and day of a specified date

	--SYNTAX: DATENAME(date_part,input_date)
	-- parametreler i�in : https://www.sqlservertutorial.net/sql-server-date-functions/sql-server-datename-function/

-- DATEPART() fonksiyonu da benzerdir.
SELECT
    DATEPART(year, '2018-05-10') [datepart], 
    DATENAME(year, '2018-05-10') [datename];  
	-- ikisi de tarihin ayn� par�as�n� (y�l�) getirdi.

SELECT A_time,
		DATENAME(D, A_date) [DAY] -- 1.paramtre:hangi par�ay� istiyorsun, 2.parametre:nerden istiyorsun?
from t_date_time


SELECT	A_date,
		DATENAME(DW, A_date) [WeekDay],
		DAY (A_date) [DAY2],
		MONTH(A_date),
		YEAR (A_date),
		A_time,
		DATEPART (NANOSECOND, A_time),
		DATEPART (MONTH, A_date)
FROM	t_date_time


-- DATEDIFF () : DATEDIFF() function to calculate the number of years, months, weeks, days,etc., between two dates.
	--iki tarih aras�ndaki fark� getiriyor.

SELECT A_date,
		A_datetime,
		DATEDIFF (DAY, A_date, A_datetime) Date_diff -- iki tarih aras�ndaki DAY fark�n� getir.
FROM t_date_time
-- Biri null ise de�er getirmiyor, ikisi birden dolu ise getiriyor.


-- shipdate ile order date aras�nda ka� g�n fark var?

SELECT DATEDIFF (DAY, order_date, shipped_date), order_date, shipped_date
from sales.orders
where order_id = 1
-- Dikkat!! sonraki tarihi (shipped_date) �nceki tarihten (order_date) sonra yazd�k

SELECT DATEDIFF (DAY, order_date, shipped_date), order_date, shipped_date,
		DATEDIFF (DAY, shipped_date, order_date)
from sales.orders
where order_id = 1
-- ters yaz�nca ikinci DATEDIFF eksi ��kt�..



SELECT DATEADD (D, 5, order_date), order_date --order_date'e 5 g�n ekle dedik.
FROM sales.orders
WHERE order_id = 1


-- DATEADD : The DATEADD() function adds a number to a specified date part of an input date and returns the modified value.
	--tarihin belirtilen k�sm�na, belirtilen miktarda (y�l, ay, g�n) ekliyor

SELECT DATEADD (YEAR, 5, order_date), DATEADD(DAY, 5, order_date), order_date
FROM sales.orders
WHERE order_id = 1

SELECT DATEADD (YEAR, 5, order_date), 
		DATEADD(DAY, 5, order_date), 
		DATEADD(DAY, -5, order_date), order_date -- eksi ile ��kartabiliriz de.
FROM sales.orders
WHERE order_id = 1


--- EOMONTH: ay�n son g�n�n� getiriyor

-- order_date lerin �ubat aylar� ka� �ekiyor bakal�m:
SELECT EOMONTH(order_date), order_date
FROM sales.orders
WHERE MONTH(order_date) = '02' 


--- ISDATE(): accepts an argument and returns 1 if that argument is a valid DATE, TIME, or DATETIME value; 
	-- otherwise, it returns 0.

SELECT ISDATE(CAST (order_date AS nvarchar)), order_date
FROM sales.orders
-- Burada ISDATE, orde_date'in i�erisinin varchar olup olmad���n� denetler. 1 True, 0 False

SELECT	ISDATE( CAST (order_date AS nvarchar)), order_date
FROM	sales.orders
SELECT ISDATE ('1234568779')
SELECT ISDATE ('WHERE')
SELECT ISDATE ('2021-12-02')
SELECT ISDATE ('2021.12.02')



--- GETDATE() : he GETDATE() function returns the current system timestamp as a DATETIME value without the database time zone offset
	-- saat dilimi fark�na bakmaks�z�n bilgisayar sisteminizdeki o an ki zaman� getirir.
SELECT GETDATE()

SELECT CURRENT_TIMESTAMP

SELECT GETUTCDATE()
-- Aralar�nda �nemli bir fark yok.


-- �RNE��M�ZE D�NEL�M:

INSERT t_date_time
VALUES (GETDATE(), GETDATE(), GETDATE(), GETDATE(), GETDATE(), GETDATE())
-- SON SATIR VALUE'SU OLARAK HER S�TUNDA BUG�N�N DATE'�N� GET�RD�. 
	-- TAB� K� HER B�R S�TUNUN KEND� FORMATLARINDA GET�RD�.

SELECT *
FROM t_date_time



---- SORU: Create a new column that contains labels of the shipping speed of products.
	-- 1. If the product has not been shipped yet, it will be marked as "Not Shipped"
	-- 2. If the product was shipped on the day of order, it will be labeled as "Fast"
	-- 3. If the product is shipped no later than two days after the order day, it will be labeled as "Normal"
	-- 4. If the product was shipped three or more days after the day of order, it will be labeled as "Slow" 

-- 1. �art i�in: order status 4 de�ilse kargolanmam�� demek. 4 ise kargolanm�� demek.
-- di�er �artlar i�in ise order_date ile shipped_date aras�ndaki farka bakaca��z.
SELECT *, 
		CASE WHEN order_status <> 4 THEN 'Not Shipped'
			WHEN order_date = shipped_date THEN 'Fast' -- DATEDIFF ( DAY, order_date, shipped_date) = 0 THAN 'Fast' dersek de g�n fark�n� alm�� olacakt�k.
			WHEN DATEDIFF (DAY, order_date, shipped_date) BETWEEN 1 AND 2 THEN 'Normal'
			ELSE 'Slow' -- geriye kalan t�m durumlar� Slow olarak ata
		END AS ORDER_LABEL
FROM sales.orders

-- bir s�tun daha ekleyelim ve DATEDIFF i de getirsin, aradaki g�n say�s�n� da g�relim.
SELECT *, 
		CASE WHEN order_status <> 4 THEN 'Not Shipped'
			WHEN order_date = shipped_date THEN 'Fast' -- DATEDIFF ( DAY, order_date, shipped_date) = 0 THAN 'Fast' dersek de g�n fark�n� alm�� olacakt�k.
			WHEN DATEDIFF (DAY, order_date, shipped_date) BETWEEN 1 AND 2 THEN 'Normal'
			ELSE 'Slow' -- geriye kalan t�m durumlar� Slow olarak ata
		END AS ORDER_LABEL,
		DATEDIFF(DAY, order_date, shipped_date) Date_diff
FROM sales.orders
ORDER BY Date_diff



-- SORU: Write a query returns orders that are shipped more than two days after the ordered date.

SELECT *, DATEDIFF ( DAY, order_date, shipped_date) DATE_DIFF
FROM sales.orders
WHERE DATEDIFF(DAY, order_date, shipped_date) >2



-- SORU: Write o query that returns the number distributions of the orders in the previous query result,
	-- according to the days of the week.

	-- sipari� ald�ktan sonra 2 g�nden ge� kargolanm��sa buna ge� kargolanm�� diyoruz.
		--burada hangi g�nler sipari� al�nd���nda ge� kargolanm�� oluyor onu bulmaya �al���yoruz.
		-- gecikmenin sebebi ne onu bulmak i�in bir �al��ma yapt���m�z� hayal edelim.

		--DATENAME'i kullanaca��z.. ve CASE() fonksiyonu kullanaca��z.

SELECT SUM(CASE WHEN DATENAME (DW, order_date) = 'Monday' THEN 1 ELSE 0 END) AS MONDAY, 
-- order_date varchar idi o y�zden t�rnak i�ine yazd�m. haftan�n g�n�n� k�yaslayaca��m i�in DATENAME fonksiyonunda DW (Weekday) kulland�m.
		SUM(CASE WHEN DATENAME (DW, order_date) = 'Thuesday' THEN 1 ELSE 0 END) AS THUESDAY, 
		SUM(CASE WHEN DATENAME (DW, order_date) = 'Wednesday' THEN 1 ELSE 0 END) AS WEDNESDAY,
		SUM(CASE WHEN DATENAME (DW, order_date) = 'Thursday' THEN 1 ELSE 0 END) AS THURSDAY,
		SUM(CASE WHEN DATENAME (DW, order_date) = 'Friday' THEN 1 ELSE 0 END) AS FRIDAY,
		SUM(CASE WHEN DATENAME (DW, order_date) = 'Saturday' THEN 1 ELSE 0 END) AS SATURDAY,
		SUM(CASE WHEN DATENAME (DW, order_date) = 'Sunday' THEN 1 ELSE 0 END) AS SUNDAY
FROM sales.orders
WHERE DATEDIFF(DAY, order_date, shipped_date) > 2

-- PIVOT table kullanarak da yap�labilir. Owen hoca bunu �dev olarak b�rakt�!!


-- SORU : Write a query that returns the order numbers of the states by months.

	-- states --> sales.custormers tablosunda
SELECT A.state, MONTH(B.order_date) MONTHS, -- order tarihinin aylar�n� se�mek i�in..
				COUNT(DISTINCT order_id) NUM_OF_ORDERS -- bu aylara ait farkl� sipari�leri bulmak i�in..
FROM sales.customers A, sales.orders B
WHERE A.customer_id = B.customer_id 
GROUP BY A.state, MONTH(B.order_date)-- state'leri aylara g�re gruplad�m.
ORDER BY 1 --state lere g�re s�ralad�k.
-- sorgu cevab�n� ay ay getirdik. yani 3 y�l�n aylar� i�in i�ine kat�lm��. y�l y�l bir ay�r�m yok.

-- YIL boyutunu da ekleyelim..
SELECT A.state, YEAR(B.order_date) YEARS, MONTH(B.order_date) MONTHS, -- order tarihinin aylar�n� se�mek i�in..
				COUNT(DISTINCT order_id) NUM_OF_ORDERS -- bu aylara ait farkl� sipari�leri bulmak i�in..
FROM sales.customers A, sales.orders B
WHERE A.customer_id = B.customer_id 
GROUP BY A.state, YEAR(B.order_date), MONTH(B.order_date)-- state'leri aylara g�re gruplad�m.
ORDER BY state, YEARS, MONTHS


-- order by sat�r�nda years ve months almasak da onlar� s�raya koyuyor. ama yine de yazmakta fayda var.
SELECT A.state, YEAR(B.order_date) YEARS, MONTH(B.order_date) MONTHS, -- order tarihinin aylar�n� se�mek i�in..
				COUNT(DISTINCT order_id) NUM_OF_ORDERS -- bu aylara ait farkl� sipari�leri bulmak i�in..
FROM sales.customers A, sales.orders B
WHERE A.customer_id = B.customer_id 
GROUP BY A.state, YEAR(B.order_date), MONTH(B.order_date)-- state'leri aylara g�re gruplad�m.
ORDER BY state