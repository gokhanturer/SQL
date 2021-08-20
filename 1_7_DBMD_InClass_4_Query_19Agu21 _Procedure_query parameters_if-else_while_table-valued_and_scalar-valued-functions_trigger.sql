----------------------------DBMD 19-08-2021 -----------------------------------


---------------------------- PROCEDURE------------------------
CREATE PROC sp_sampleproc_1
AS
BEGIN
	SELECT 'HELLO WORLD'

END;

EXECUTE sp_sampleproc_1   -- PROCEDURE'Ü ÇALIÞTIRMAK ÝÇÝN.

EXEC sp_sampleproc_1  -- BU ÞEKÝLDE DE ÇALIÞIR.

sp_sampleproc_1  -- VE BU ÞEKÝLDE DE ÇALIÞIR.


-- PROCEDURE'Ü DEÐÝÞTÝRELÝM.
ALTER PROC sp_sampleproc_1
AS
BEGIN
	SELECT 'QUERY COMPLETED' RESULT

END;

sp_sampleproc_1







--- BBUNDAN SONRAKÝ ÝÞLEMLER ÝÇÝN ÖRNEK TABLO OLUÞTURUYORUZ

CREATE TABLE ORDER_TBL
(
ORDER_ID TINYINT NOT NULL,
CUSTOMER_ID TINYINT NOT NULL,
CUSTOMER_NAME VARCHAR(50),
ORDER_DATE DATE,
EST_DELIVERY_DATE DATE--estimated delivery date
);
INSERT ORDER_TBL VALUES (1, 1, 'Adam', GETDATE()-10, GETDATE()-5 ),
						(2, 2, 'Smith',GETDATE()-8, GETDATE()-4 ),
						(3, 3, 'John',GETDATE()-5, GETDATE()-2 ),
						(4, 4, 'Jack',GETDATE()-3, GETDATE()+1 ),
						(5, 5, 'Owen',GETDATE()-2, GETDATE()+3 ),
						(6, 6, 'Mike',GETDATE(), GETDATE()+5 ),
						(7, 6, 'Rafael',GETDATE(), GETDATE()+5 ),
						(8, 7, 'Johnson',GETDATE(), GETDATE()+5 )


-- BU TABLO TESLÝMATIN GERÇEKLEÞTÝRÝLME ZAMANINI BÝZE SERGÝLÝYOR
CREATE TABLE ORDER_DELIVERY
(
ORDER_ID TINYINT NOT NULL,
DELIVERY_DATE DATE -- tamamlanan delivery date
);
SET NOCOUNT ON
INSERT ORDER_DELIVERY VALUES (1, GETDATE()-6 ),
						(2, GETDATE()-2 ),
						(3, GETDATE()-2 ),
						(4, GETDATE() ),
						(5, GETDATE()+2 ),
						(6, GETDATE()+3 ),
						(7, GETDATE()+5 ),
						(8, GETDATE()+5 )


SELECT * FROM ORDER_DELIVERY

--ORDER LARI SAYDIRAN BÝR PROC YAZALIM:
CREATE PROC sp_sumorder
AS
BEGIN
		SELECT COUNT(ORDER_ID) FROM Order_tbl

END;
-- BUNU ARTIK ÝSTEDÝÐÝM HER YERE ÇAÐIRIP ÇALIÞTIRALBÝLÝRÝM.
	--VE ORDER TABLOSUNDAKÝ SÝPARÝÞ SAYISINI GETÝREBÝLÝRÝM.
	--ORDER TABLOSU GÜNCELLENDÝKÇE BU PROCEDURE'ÜN SONUCU DA ONA BAÐLI OLARAK DEÐÝÞECEKTÝR.
	-- VE HER DEFASINDA GÜNCEL BÝLGÝYÝ GETÝRECEKTÝR.
sp_sumorder


------------------

CREATE PROC sp_wanted_dayorder (@DAY DATE)
AS
BEGIN

	SELECT COUNT (ORDER_ID)
	FROM ORDER_TBL
	WHERE ORDER_DATE = @DAY

END;

SELECT * FROM ORDER_TBL

EXEC sp_wanted_dayorder '2021-08-12' -- buraya bir tarih gireceðim ve procedure bana o güne ait order_id leri sayýsýný getirecek


---------------------

-- SORGU PARAMETRELERÝ TANIMLIYORUZ:

	-- PARAMETRELERE DEÐER ATAMAK ÝÇÝN SET VEYEA SELECT DÝYORUZ
DECLARE @P1 INT, @P2 INT, @SUM INT

SET @P1 = 6

SELECT @P2  =4

SELECT @SUM = @P1 + @P2

SELECT @SUM  -- SELECT ÝLE YAZDIRDIÐINDA SONUÇ RESULT KISMINDA ÇIKAR.

PRINT @SUM  -- PRINT ÝLE YAZDIRDIÐINDA SONUÇ MESSSAGE KISMINDA ÇIKAR.
-- DEÐER ATAMAK ÝÇÝN SET VEYA SELECT, 
-- PARAMETREYÝ ÇAÐIRMAK ÝÇÝN SELECT




