------------------------DAwSQL Lab3 (10.08.2021) -----------------------



-- SORU 1: Find the weekly order count for the city of Baldwin for the last 8 weeks earlier from '2016-08-18', 
	-- and also the cumulative total
	-- Desired output : [week_num, order_count, cuml_order_count]

	--(TR) --Baldwin �ehrindeki '2016-08-18' tarihinden �nceki 8 haftaya ait sipari� say�lar�n� ve k�m�latif sipari� toplamlar�n� getiriniz.

select DATEADD(WEEK, -8, '2016-08-18')
-- DATEPART(WEEK, order_date) fonksiyonu, i�ine girilen tarihe ait haftan�n, y�l�n ka��nc� haftas� oldu�unu bulur.

SELECT *
FROM sales.orders AS A, sales.stores AS B
WHERE A.store_id = B.store_id
and B.city = 'Baldwin'
and A.order_date BETWEEN DATEADD(WEEK, -8, '2016-08-18') AND '2016-08-18'
	-- 2016-08-18 tarihininde y�la g�re ka��nc� hafta ise ondan 8 ��kart ve order_date'in 
		-- belirtilen tarih ile bu tarih aras�nda olma condition'�n� uygula.
ORDER BY A.order_date ASC;

--
SELECT DATEPART(WEEK, order_date), order_date
from sales.orders


SELECT DISTINCT DATEPART(WEEK, order_date) AS week_num,
			COUNT(order_id) OVER(PARTITION BY DATEPART(WEEK, order_date)) AS order_count
FROM sales.orders AS A, sales.stores AS B
WHERE A.store_id = B.store_id
and B.city = 'Baldwin'
and A.order_date BETWEEN DATEADD(WEEK, -8, '2016-08-18') AND '2016-08-18'
ORDER BY A.order_date ASC;
-- order_date'i order by yapt���m�z i�in VE WINDOW FUNCTIONLAR �LE ORDER BY �ALI�MADI�I ���N ORDER BY'I KULLANMAMIZ HATA VERD�.
	-- (WINDOW FUNCTION ���NDEK� ORDER BY ZATEN ORDER YAPIYOR)

SELECT DISTINCT DATEPART(WEEK, order_date) AS week_num,
			COUNT(order_id) OVER(PARTITION BY DATEPART(WEEK, order_date)) AS order_count
			-- order_date'in hafta numaras�na g�re grupla ve bu gruba ait order_id'leri sayarak kar��s�na yaz.
FROM sales.orders AS A, sales.stores AS B
WHERE A.store_id = B.store_id
and B.city = 'Baldwin'
and A.order_date BETWEEN DATEADD(WEEK, -8, '2016-08-18') AND '2016-08-18';


-- BU KODUN ���NDEK� A�IKLAMALAR �OK �NEML�!
SELECT DISTINCT DATEPART(WEEK, order_date) AS week_num,
			    COUNT(order_id) OVER(PARTITION BY DATEPART(WEEK, order_date)) AS order_count,
				--count i�lemini her partition (burada week numaras�) i�in ayr� yap ve yan�na yaz.
				COUNT(order_id) OVER(ORDER BY DATEPART(WEEK, order_date)) AS cuml_order_count
				-- count i�lemini order_date s�ras�na g�re toplaya toplaya yazd�r. (partition girilmedi�i i�in;
					-- her hafta numaras�n� ayr� bir window olarak g�rmeyecek ve 
					-- order_date s�ras�na g�re order_id'lerin say�s�n� kendi i�inde (window fonksiyonunun �zelli�i gere�i) k�m�latif olarak toplayarak verecek.
FROM sales.orders AS A, sales.stores AS B
WHERE A.store_id = B.store_id
and B.city = 'Baldwin'
and A.order_date BETWEEN DATEADD(WEEK, -8, '2016-08-18') AND '2016-08-18';

-- OVER'IN ���NDE ORDER BY KULLANMADI�IMDA D�REKT WINDOW TOPLAMINI T�M SATIRLARA YAZDI�INI G�R�YORUZ:
SELECT DISTINCT DATEPART(WEEK, order_date) AS week_num,
			    COUNT(order_id) OVER(PARTITION BY DATEPART(WEEK, order_date)) AS order_count,
				COUNT(order_id) OVER() AS cuml_order_count
FROM sales.orders AS A, sales.stores AS B
WHERE A.store_id = B.store_id
and B.city = 'Baldwin'
and A.order_date BETWEEN DATEADD(WEEK, -8, '2016-08-18') AND '2016-08-18';


--#################################################################################################


---SORU 2: Write a query that returns customer who ordered the same product on two consecutive orders. 
	-- expected output: customer_id, product_id, previous order date, next order date

--(TR) Ayn� �r�n� iki ard���k sipari�te sipari� eden m��terileri d�nd�ren bir sorgu yaz�n..

SELECT
	B.customer_id,
	A.product_id,
	B.order_date,
	B.order_id
FROM sales.order_items as A, sales.orders as B
WHERE A.order_id = B.order_id
ORDER BY B.customer_id, B.order_date;


SELECT
	B.customer_id,
	A.product_id,
	B.order_date,
	B.order_id,
	DENSE_RANK() OVER(PARTITION BY B.customer_id ORDER BY order_date) -- RANK, DENSE_RANK VB. SIRALAMA FONKS�YONLARI OVER'IN ���NDEK� ORDER BY �LE �ALI�IYOR.
FROM sales.order_items as A, sales.orders as B							-- NEYE G�RE ORDER BY YAPILMI�SA ONA G�RE KEND� ���NDE AYRI NUMARALAR VER�YOR.
WHERE A.order_id = B.order_id											-- BU FONKS�YONLAR ORDER BY OLMADAN �ALI�MIYOR.
ORDER BY B.customer_id, B.order_date;
--- customer_id gruplamas�na g�re order_date lerimin s�ras�yla gelmesini istiyorum ��nk� 
	-- pe� pe�e iki order'�n ayn� sipari� olup olmad���na bakmak istiyorum. 
	-- bu y�zden DENSE_RANK yap�p i�inde order by'� order_date e g�re yapt�m.

-- fakat ayn� g�n i�inde art arda iki sipari� verilmi� olabilece�inden 
	--DENSE_RANK'teki order by'a bir de order_id'yi koydum.
SELECT
		B.customer_id,
		A.product_id,
		B.order_date,
		B.order_id,
		DENSE_RANK() OVER(PARTITION BY B.customer_id order by order_date, A.order_id) as historical_numerate
FROM sales.order_items as A, sales.orders as B
WHERE A.order_id = B.order_id
-- ayn� customer'�n farkl� product_idlerine order_date ve order_id ler baz al�narak s�ra numaras� verildi.
	-- fakat istedi�im her customer'�n ayn� product'� art arda sipari� etti�i tarihleri getirmekti!

---OWEN HOCA ��Z�ME BU �EK�LDE DEVAM ETT�:

-- EN alttaki WHERE sat�r�nda; T1 ile T2 customer_id lerini e�itlemedi�imiz i�in prev ve next_order'lar� customer_id baz�nda getirmedi
WITH T1 AS
(
SELECT	Customer_id, Order_Date, B.product_id, A.order_id,
		DENSE_RANK() OVER (PARTITION BY Customer_id ORDER BY Order_Date) historical_numerate
		-- customer_id'leri order_date e g�re s�ralay�p DENSE_RANK ile s�ra numaras� verdik.
		-- customer_id lere g�re gruplay�p, ORDER BY (Order_date) gere�i bu gruplar�n i�inde order_date'lere g�re DENSE_RANK numaralar� verecek.
FROM	sales.orders A, 
		sales.order_items B
WHERE	A.order_id=B.order_id
), T2 AS
(
SELECT	Customer_id, Order_Date, B.product_id, A.order_id,
		DENSE_RANK() OVER (PARTITION BY Customer_id ORDER BY Order_Date) historical_numerate
	-- customer'lar� gruplay�p gruplar i�inde order_date'lere g�re s�ralama yapt�k ve DENSE_RANK ile s�ra numaras� verdik.
	-- her m��terinin kendi order_date'lerine s�ra numaras� vermi� olduk.
FROM	sales.orders A, 
		sales.order_items B
WHERE	A.order_id=B.order_id
)
SELECT	T2.customer_id,
		T2.product_id,
		T1.order_date,
		T1.order_id,
		T1.historical_numerate PREV_ORD,
		T2.order_date,
		T2.historical_numerate NEXT_ORD
FROM	T1, T2
WHERE	T1.product_id = T2.product_id
AND		T1.historical_numerate + 1 = T2.historical_numerate 

-- T1.customer_id = T2.customer_id e�itlemesini yapal�m:
WITH T1 AS
(
SELECT	Customer_id, Order_Date, B.product_id, A.order_id,
		DENSE_RANK() OVER (PARTITION BY Customer_id ORDER BY Order_Date) historical_numerate
	-- customer'lar� gruplay�p gruplar i�inde order_date'lere g�re s�ralama yapt�k ve DENSE_RANK ile s�ra numaras� verdik.
	-- her m��terinin kendi order_date'lerine s�ra numaras� vermi� olduk.
FROM	sales.orders A, 
		sales.order_items B
WHERE	A.order_id=B.order_id
), T2 AS
(
SELECT	Customer_id, Order_Date, B.product_id, A.order_id,
		DENSE_RANK() OVER (PARTITION BY Customer_id ORDER BY Order_Date) historical_numerate 
FROM	sales.orders A, 
		sales.order_items B
WHERE	A.order_id=B.order_id
)
SELECT	T2.customer_id,
		T2.product_id,
		T1.order_date,
		T1.order_id,
		T1.historical_numerate PREV_ORD,
		T2.order_date,
		T2.historical_numerate NEXT_ORD
FROM	T1, T2
WHERE	T1.customer_id = T2.customer_id
AND		T1.product_id = T2.product_id
AND		T1.historical_numerate + 1 = T2.historical_numerate 
-- Burada AND ile ba�lanm�� �� condition var. 
	--1. customer_id'ler e�it mi (e�it olanlar� al)
	--2. product_id'ler e�it mi (e�it olanlar� al)
	--3. ilk iki condition sa�land���nda bir de ;
		-- birinci tablodan gelen DENCE_RANK'e 1 ekledi�imde bu ikinci tablodaki DENCE_RANK'e e�it oluyor mu? 
			-- yani customer ve product_id leri ayn� olan bu sat�rlar�n DENCE_RANK'leri birbiri ard�na m� geliyor??
		-- Bu �artlar ancak customer ve product�n ayn� fakat order_id'si birbiri ard�na geliyor ise sa�lan�r (T1.historical_numerate + 1 dedi�imiz i�in)

--AYRICA, DENSE_RANK sat�r�nda ORDER BY i�ine Order_id yi de soksayd�k, ayn� tarihte ayn� �r�n i�in verilen farkl� bir 
	-- order_id(sipari� numaras�) olmas� halinde de bunu yakalard�. ��nk� bu sefer DENCE_RANK sadece order_date e g�re de�il,
		-- order_id ler de�i�ti�inde de farkl� numara verecektir. ve ayn� �r�n (tarihi ayn� olsa da) ard���k iki order'da sipari� edilmi� oldu�u ortaya ��kacakt�r.
		-- datam�zda b�yle bir durum olmad���ndan ORDER BY i�inde Order_date'in yan�na order_id'yi eklesek de ayn� sonucu verecektir.


--CONTROL

SELECT	Customer_id, Order_Date, B.product_id, A.order_id,
		DENSE_RANK() OVER (PARTITION BY Customer_id ORDER BY Order_Date) historical_numerate
FROM	sales.orders A, 
		sales.order_items B
WHERE	A.order_id=B.order_id
AND		customer_id = 24



--


SELECT	Customer_id, B.product_id,
		DENSE_RANK() OVER (PARTITION BY Customer_id ORDER BY Order_Date) +1 historical_numerate
FROM	sales.orders A, 
		sales.order_items B
WHERE	A.order_id=B.order_id

INTERSECT

SELECT	Customer_id, B.product_id,
		DENSE_RANK() OVER (PARTITION BY Customer_id ORDER BY Order_Date) historical_numerate
FROM	sales.orders A, 
		sales.order_items B
WHERE	A.order_id=B.order_id





