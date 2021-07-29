------------------------------ 28.07.2021 SQL InClass -------------


              --------------- VIEWS -------------------(�nceki derste i�lendi. tekrar mahiyetinde buraya al�nd�)

-- Subquery'ler, CTE(Common Table Expression)'lar, VIEW'lar hep ayn� amaca hizmet ediyor. Tablolarla daha rahat �al��mam�z� sa�l�yorlar. ,
	-- Di�er bir avantaj� da performans� art�rmakt�r. Siz query'nizi joinlerle tek bir query i�inde de�il, subery lerle, CTE'lerle,
	-- VIEW'larla daralta daralta (daralt�lm�� tablolarla) sonuca gitmeye �al���yorsunuz.
				-----------AVANTAJLARI:-------------
	--        Performans + Simplicity + Security + Storage 
	
	-- VIEW : Tek bir tabloda yapaca��m�z i�lemleri a�amalar b�lerek yapmam�z� sa�l�yor. Bu da h�z�m�z� artt�r�yor.
	-- VIEW ile ayn� tablo gibi olu�turuyoruz ve bu VIEW'a kimleri eri�ebilece�ini belirleyebiliyoruz. bu da security sa�l�yor.
	-- VIEW'lar�n kullan�m� da olu�turmas� basittir. b�y�k tablonun i�erisinde biz bir k�s�m ilgilendimiz verileri al�p onlar �zerinden �al���yoruz.
	-- VIEW'lar �ok az yer kaplar. ��bk� as�l tablonun bir g�r�nt�s�d�r.


			-------------- CTE - COMMON TABLE ESPRESSIONS -------------

-- Subquery mant��� ile ayn�. Subquery'de i�erde bir tablo ile ilgileniyorduk CTE'de yukarda yaz�yoruz.

--(CTE), ba�ka bir SELECT, INSERT, DELETE veya UPDATE deyiminde ba�vurabilece�iniz veya i�inde kullanabilece�iniz ge�ici bir sonu� k�mesidir. 
-- Ba�ka bir SQL sorgusu i�inde tan�mlayabilece�iniz bir sorgudur. Bu nedenle, di�er sorgular CTE'yi bir tablo gibi kullanabilir. 
-- CTE, daha b�y�k bir sorguda kullan�lmak �zere yard�mc� ifadeler yazmam�z� sa�lar.


--ORDINARY

	--subquery den hi� bir fark� yok. subquery i�erde kullan�l�yor, Ordinary CTE yukarda WITH ile olu�turuluyor.

WITH query_name [(column_name1, ....)] AS
	(SELECT ....)   -- CTE Definition

SQL_Statement

-- sadece WITH k�sm�n� yazarsan tek ba��na �al��maz. WITH ile belirtti�im query'yi birazdan kullanaca��m demek bu. 
-- as�l SQL statement i�inde bunu kullan�yoruz.

-- RECURSIVE

	-- UNION ALL ile kullan�l�yor.

WITH table_name (colum_list)
AS
(
	-- Anchor member
	initial_query
	UNION ALL
	-- Recursive member that references table_name.
	recursive_query
)
-- references table_name
SELECT *
FROM table_name

-- WITH ile yukarda tablo olu�turuyor, a�a��da da SELECT FROM ile bu tabloyu kullan�yor



-- Question: List customers who have an order prior to the last order of a customer named Sharyn Hopkins 
	-- and are residents of the city of San Diego.
--(TR) Sharyn Hopkins adl� bir m��terinin son sipari�inden �nce sipari�i olan ve 
	--San Diego �ehrinde ikamet eden m��terileri listeleyin

-- bu isimli m��teriyi nerden bulaca��m? sales.customers tan.
-- son sipari�ini nerden bulaca��m? sales.orders tan

SELECT MAX(B.order_date) --son sipari� tarihini getirmek i�in MAX fonksiyonunu kulland�m. ORDER BY DESC de yapabilirdim
FROM sales.customers A, sales.orders B
WHERE A.customer_id = B.customer_id
AND A.first_name = 'Sharyn'
AND A.last_name = 'Hopkins'

WITH T1 AS
(
SELECT MAX(B.order_date) LAST_ORDER 
FROM sales.customers A, sales.orders B
WHERE A.customer_id = B.customer_id
AND A.first_name = 'Sharyn'
AND A.last_name = 'Hopkins'
)

SELECT A.customer_id, A.first_name, last_name, city, order_date
FROM sales.customers A, sales.orders B, T1 C
WHERE A.customer_id = B.customer_id 
AND B.order_date < C.LAST_ORDER
AND A.city = 'San Diego'
-- WITH ile ba�layan CTE blo�u tek ba��na �al��t�r�rsan hata verir. 
	-- ard�ndan gelen i�inde CTE yi kulland���n query ile beraber se�erek �al��t�rmal�s�n.

-- SORU2: 0'dan 9'a kadar her bir rakam bir sat�rda olacak �ekilde bir tablo olu�turun

SELECT 0 number
UNION ALL
SELECT 1

SELECT 0 number
UNION ALL
SELECT 1
UNION ALL
SELECT 2

WITH T1 AS
(
SELECT 0 number
UNION ALL
SELECT 1
)

SELECT * 
FROM T1

-------her seferinde ayn� tabloyu tekrar tekrar kullanmak istersem:
WITH T1 AS
(
SELECT 0 number
UNION ALL
SELECT number +1 
FROM T1
WHERE  number < 9 --sonsuza kadar yapmamas� i�in ve hata vermemesi i�in burada limitliyoruz.
)

SELECT * FROM T1


--- WITH �LE SADECE VAR OLAN DE�ERLERDEN B�R TABLO OLU�TURMAK DE��L, 
	--YEN� DE�ERLER EKLEYEREK B�R TABLO DA OLU�TURAB�L�R�Z


--------------------------- SET----------------------------------

				------- IMPORTANT----------

-- Her iki select statemen da ayn� say�da column i�ermeli.

-- INTERSECT VE EXCEPT �ok �nemli. UNION hayat kurtarmaz ama di�er ikisi �ok �nemli i�ler yaparlar.

-- UNION ve INTERSECT'te positional ordering �nemli de�il 
	-- yani hangi tablo �nce hangisi sonra gelece�inin �nemi yok. 
	-- ama EXCEPT te bu �nemli!!!

-- Select statement ta birbirine kar��l�k gelen s�tunlar�n data tipleri ayn� olmal�.

-- ORDER BY ile bir s�ralama yapmak istiyorsak, ORDER BY'� son tablonun FROM'unun sonuna yazmal�s�n.
	-- di�er tabololarda bireysel olarak ORDER BY kullanamazs�n!!

-- UNION, dublikasyonlar� filtreleyip g�stermedi�i i�in fazladan i�lem yapmaktad�r. 
	-- fakat UNION ALL bu i�lemi yapmad��� (dublikasyonlarla beraber sonu�lar� getirdi�i) i�in
	-- performans a��s�ndan daha iyidir.

-- S�TUN �S�MLER� AYNI OLMAK ZORUNDA DE��LD�R. �K�NC� TABLONUN S�TUN �S�MLER� FARKLI �SE; 
	-- UNION �LE YAPTI�IMIZ SORGU SONUCU; SONU� TABLOSUNUN S�TUN �S�MLER� �LK TABLONUN S�TUN �S�MLER� OLUR!!



-- SET-SORU 1: Sacremento �ehrindeki m��teriler ile Monroe �ehrindeki m��terilerin soyisimlerini listeleyin

SELECT last_name
FROM sales.customers
WHERE city = 'Sacramento'
-- 6 tane sat�r geldi.

SELECT last_name
FROM sales.customers
WHERE city = 'Monroe'
-- 11 sat�r geldi. �imdi iki tabloyu birle�tirelim

SELECT last_name
FROM sales.customers
WHERE city = 'Sacramento'

UNION ALL

SELECT last_name
FROM sales.customers
WHERE city = 'Monroe'
-- 17 sonu� geldi. Rasmussen soyad� iki defa tekrar etmi�. �imdi UNION ile yapaca��m ve tekrar� almayacak.

-- ayn� i�lemi UNION ile yaparsak dublikasyonu g�z �n�ne alarak i�lem yapacak ve:
SELECT last_name
FROM sales.customers
WHERE city = 'Sacramento'

UNION

SELECT last_name
FROM sales.customers
WHERE city = 'Monroe'
-- 16 sat�r getirecektir.

-- soyisimle birlikte ismi de select sat�r�nda getirirsek...
SELECT first_name, last_name
FROM sales.customers
WHERE city = 'Sacramento'

UNION

SELECT first_name, last_name
FROM sales.customers
WHERE city = 'Monroe'
-- iki Rasmussen soyad�n�n farkl� isimleri oldu�undan UNION'da da 17 sat�r getirdi. ��nk� art�k tekrar eden sat�r yok.

-- Another Way 'OR' 'IN'
SELECT last_name
FROM sales.customers
WHERE city = 'Sacramento' or city = 'Monroe'

SELECT last_name
FROM sales.customers
WHERE city IN ('Sacramento', 'Monroe')


-------------------------
-------------------------

SELECT city
from sales.stores

UNION ALL

SELECT state
from sales.stores
-- sonu� tablosunda ilk tablonun s�tun ismini ald���na dikkat et!!

SELECT city, 'STATE' AS STATE
from sales.stores

UNION ALL

SELECT state
from sales.stores
-- ilk tabloya select te bir s�tun daha �a��rd�k. �imdi ilk tablodan 2, ikinciden 1 s�tun �a��rm�� olduk.
-- iki sorgunun da ayn� say�da s�tun i�ermesi gerekti�inden bu hata verdi!!

SELECT city, 'STATE' AS STATE
from sales.stores

UNION ALL

SELECT state, 'BALDWIN' AS city
from sales.stores
-- iki tablonun isimleri ve i�erikleri farkl� olsa da ikisini de birle�tirdi.
-- ��nk� �nemli olan s�tun say�lar�n�n ayn� olmas�. 
-- UNION �LE SORGU SONUCU; SONU� TABLOSUNUN S�TUN �S�MLER� �LK TABLONUN S�TUN �S�MLER� OLUR!!


SELECT city, 'STATE' AS STATE
from sales.stores

UNION ALL

SELECT state, 1 AS city
from sales.stores
-- iki tablonun data tipleri farkl� oldu�undan hata verdi!!!




-- SET- SORU 2: write a query that returns brands that have products for both 2016 and 2017

SELECT *
FROM production.products
WHERE model_year = 2016

INTERSECT

SELECT *
FROM production.products
WHERE model_year = 2017
-- SELECT * �LE T�M S�TUNLARI �A�IRDI�IMIZ ���N B�T�N S�TUNLARIN ���NDEK� DE�ERLER� 
	--KES��T�RMEYE �ALI�IYOR AMA KES��T�REM�YOR BU Y�ZDEN B�R DE�ER D�ND�REM�YOR.

SELECT brand_id
FROM production.products
WHERE model_year = 2016

INTERSECT

SELECT brand_id
FROM production.products
WHERE model_year = 2017
-- g�rd���n gibi brand_id s�tunlar�n� kesi�tirdi ve sonu� getirdi.

SELECT brand_id
FROM production.products
WHERE model_year = 2016

INTERSECT

SELECT brand_id
FROM production.products
WHERE model_year = 2017
ORDER BY brand_id DESC  -- ORDER BY SATIRINI BURADAK� G�B� EN ALTTA KULLANMALIYIZ.


SELECT DISTINCT A.brand_name
FROM production.brands A, production.products B
WHERE A.brand_id = B.brand_id
AND B.model_year = 2016

INTERSECT

SELECT DISTINCT A.brand_name
FROM production.brands A, production.products B
WHERE A.brand_id = B.brand_id
AND B.model_year = 2017
-- INTERSECT TE DISTINCT KULLANMANA GEREK YOK!! O ZATEN DISTINCT YAPAR!!

-- Yukarda INTERSECT ile yapt���m�z SET operation'u �imdi de bir subquery olarak kullanal�m.
	-- ve brands tablosunda brand_id'lerin bu operation sonucu gelen id'ler olmas�n� sa�layal�m.
SELECT *
FROM	production.brands
WHERE	brand_id IN (
					SELECT	brand_id
					FROM	production.products
					WHERE	model_year= 2016
					INTERSECT
					SELECT	brand_id
					FROM	production.products
					WHERE	model_year= 2017
					)
-- production.brands tablosunda yaln�zca brand_id ve brand_name oldu�u i�in bir �stteki sorguya ilave olarak
	-- brand_name'i getirmi� oldukk.



-- SET-SORU 4: write a query that returns customer who have orders for each 2016, 2017, and 2018
-- (TR) 2016, 2017 ve 2018 i�in sipari�leri olan m��teriyi d�nd�ren bir sorgu yaz�n.


SELECT customer_id
FROM sales.orders
WHERE order_date BETWEEN '2016-01-01' AND '2016-12-31' 

INTERSECT

SELECT customer_id
FROM sales.orders
WHERE order_date BETWEEN '2017-01-01' AND '2017-12-31' 

INTERSECT

SELECT customer_id
FROM sales.orders
WHERE order_date BETWEEN '2018-01-01' AND '2018-12-31'
-- buraya kadar sadece customer_id leri getirdik. ancak customer isimleri istiyordu.
	-- bunu sales.custormers tablosundan alaca��m. 

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
-- az �nceki INTERCEPT etti�im (ve customer_id'leri getiren) tablolar� subquery yapt�m ve 
	-- where de customer_id IN (subquery) kullanarak sales.customers tablosundan isim, soyisim s�tunlar�n� getirdim.



------------- EXCEPT------------
--TABLE A dan TABLE B'yi ��kartmak istiyorsan TABLE A'y� YUKARIYA yazmal�s�n.


-- SORU 5: Write a query that returns only products produced in 2016 (not ordered in 2017)

SELECT brand_id, model_year, product_name
FROM production.products
ORDER by 1
-- y�llara bakt���m�da 2017 de olup di�er y�llarda �retilmeyen modelleri g�rebiliyoruz. bunlar�n pe�indeyiz.

SELECT brand_id
FROM production.products 
WHERE model_year = 2016
-- bu brandlerden 2017 de de �retilenleri ��kartmak istiyorum.


SELECT brand_id
FROM production.products 
WHERE model_year = 2016

EXCEPT

SELECT brand_id
FROM production.products 
WHERE model_year = 2017
ORDER BY 1
-- 3, 4 ve 5 brand_id si olan markalar�n sadece 2017 y�l� �retimleri oldu�unu g�rd�m.


-- peki bir EXCEPT daha kullanarak 2018 y�l�nda �retilenleri de ��kartabilir miyiz?:
SELECT brand_id
FROM production.products 
WHERE model_year = 2016

EXCEPT

SELECT brand_id
FROM production.products 
WHERE model_year = 2017

EXCEPT

SELECT brand_id
FROM production.products 
WHERE model_year = 2018
ORDER BY 1
-- iki EXCEPT kullanarak 2017 ve 2018 leri 2016'lardan ��katm�� olduk.

-- ikinci blokta 2017 ile 2018 y�llar�n� beraber condition'a sokarsak:
SELECT brand_id
FROM production.products 
WHERE model_year = 2016

EXCEPT

SELECT brand_id
FROM production.products 
WHERE model_year = 2017 or model_year = 2018
ORDER BY 1


--�imdi brand isimlerini de getirelim. products tablosunda brand name yok. bunun i�in production.brands tablosuna gidece�iz.
SELECT	*
FROM	production.brands 
WHERE	brand_id IN (
					SELECT	brand_id
					FROM	production.products
					WHERE	model_year = 2016
					EXCEPT
					SELECT	brand_id
					FROM	production.products
					WHERE	model_year = 2017
					)
;


-- SORU 6 : write a query that returns only products ordered in 2017 (not ordered in other years)

SELECT *
FROM sales.orders A, sales.order_items B
WHERE A.order_id = B.order_id
AND A.order_date BETWEEN '2017-01-01' and '2017-12-31'
-- buraya kadar sadece 2017 de sipari� verilen �r�leri getirdik. 
	--ama bu �r�nlerden 2017 haricinde sipari� edilen varsa bunlar� ��kartmam� istiyor

SELECT DISTINCT B.product_id --product_idlerin tekrarlar�n� �nledik. a�a��daki �artlar� sa�layan ka� farkl� product_id var onu g�rmek i�in. 
FROM sales.orders A, sales.order_items B
WHERE A.order_id = B.order_id
AND A.order_date BETWEEN '2017-01-01' and '2017-12-31'

EXCEPT

SELECT DISTINCT B.product_id 
FROM sales.orders A, sales.order_items B
WHERE A.order_id = B.order_id
AND A.order_date NOT BETWEEN '2017-01-01' and '2017-12-31' --2017 d���ndakiler i�in NOT BETWEEN DED�K!!!! 

--�imdi bu �r�nlerin isimlerini de products tablosuna m�racaat ederek getirelim.
SELECT	product_id, product_name
FROM	production.products
WHERE	product_id IN (
					SELECT	DISTINCT B.product_id
					FROM	sales.orders A, sales.order_items B
					WHERE	A.order_id= B.order_id
					AND		A.order_date BETWEEN '2017-01-01' AND '2017-12-31'
					EXCEPT
					SELECT	DISTINCT B.product_id
					FROM	sales.orders A, sales.order_items B
					WHERE	A.order_id= B.order_id
					AND		A.order_date NOT BETWEEN '2017-01-01' AND '2017-12-31'
					)


-- C8329 JOSEPH HOCANIN KODU:
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


-----------------------------------
-- NOT EXISTS YER�NE EXCEPT KULLANAB�L�YORUZ:

SELECT DISTINCT state
FROM sales.customers X
WHERE NOT EXISTS (
					SELECT DISTINCT D.STATE -- BURAYA HERHANG� B�R RAKAM KOYAB�L�RS�N. SELECT SATIRINA BAKMIYOR
					FROM production.products A, sales.order_items B, sales.orders C, sales.customers D
					WHERE A.product_id = B.product_id
					and B.order_id = C.order_id
					and C.customer_id = D.customer_id 
					and A.product_name = 'Trek Remedy 9.8 - 2017'
					and X.state = D.state
					) 

-- �NCEK� DERS YAPILAN YUKARDAK� �RNEKTE NOT EXISTS YER�NE EXCEPT KULLANIRSAK:

SELECT	D.STATE
FROM	sales.customers D

EXCEPT

SELECT	D.STATE
FROM	production.products A, sales.order_items B, sales.orders C, sales.customers D
WHERE	A.product_id = B.product_id
AND		B.order_id = C.order_id
AND		C.customer_id = D.customer_id
AND		A.product_name = 'Trek Remedy 9.8 - 2017'


-------------------------------------------------------------------------

-------------------CASE EXPRESSION-------------------

--CASE-SORU 1 : Generate a new column containing what the mean of the values in the Order_Status column
	-- 1= Pending; 2= Processing, 3 = Rejected, 4 = Completed

SELECT order_status,
		CASE order_status WHEN 1 THEN 'Pending'  -- order_status'u WHEN'in d���nda kulland���m�z i�in bu zaten e�ittir anlam�na geliyor
							WHEN 2 THEN 'Processing' -- e�er WHEN'in i�inde kullansayd�k yan�na = koymam�z gerekecekti.
							WHEN 3 THEN 'Rejected'
							WHEN 4 THEN 'Completed'
		END AS meanofstatus
FROM sales.orders


-- CASE-SORU 2: -- Create a new column containing the labels of the customers' email service providers
	-- ( "Gmail", "Hotmail", "Yahoo" or "Other" )

select email from sales.customers

SELECT email, 
	CASE	   WHEN email like '%gmail%' THEN 'GMAIL'
			   WHEN email like '%hotmail%' THEN 'HOTMAIL'
			   WHEN email like '%yahoo%' THEN 'YAHOO'
			   ELSE 'OTHER'
	END AS email_service_providers
FROM sales.customers

--- CASE'in WHERE'DE NASIL KULLANAB�LECE��M�Z� �ALI�. NE �EK�LDE KULLANAB�L�R�Z?
