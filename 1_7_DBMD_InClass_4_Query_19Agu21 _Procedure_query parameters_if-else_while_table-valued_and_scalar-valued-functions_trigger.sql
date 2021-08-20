----------------------------DBMD 19-08-2021 -----------------------------------


---------------------------- PROCEDURE------------------------
CREATE PROC sp_sampleproc_1
AS
BEGIN
	SELECT 'HELLO WORLD'

END;

EXECUTE sp_sampleproc_1   -- PROCEDURE'� �ALI�TIRMAK ���N.

EXEC sp_sampleproc_1  -- BU �EK�LDE DE �ALI�IR.

sp_sampleproc_1  -- VE BU �EK�LDE DE �ALI�IR.


-- PROCEDURE'� DE���T�REL�M.
ALTER PROC sp_sampleproc_1
AS
BEGIN
	SELECT 'QUERY COMPLETED' RESULT

END;

sp_sampleproc_1







--- BBUNDAN SONRAK� ��LEMLER ���N �RNEK TABLO OLU�TURUYORUZ

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


-- BU TABLO TESL�MATIN GER�EKLE�T�R�LME ZAMANINI B�ZE SERG�L�YOR
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

--ORDER LARI SAYDIRAN B�R PROC YAZALIM:
CREATE PROC sp_sumorder
AS
BEGIN
		SELECT COUNT(ORDER_ID) FROM Order_tbl

END;
-- BUNU ARTIK �STED���M HER YERE �A�IRIP �ALI�TIRALB�L�R�M.
	--VE ORDER TABLOSUNDAK� S�PAR�� SAYISINI GET�REB�L�R�M.
	--ORDER TABLOSU G�NCELLEND�K�E BU PROCEDURE'�N SONUCU DA ONA BA�LI OLARAK DE���ECEKT�R.
	-- VE HER DEFASINDA G�NCEL B�LG�Y� GET�RECEKT�R.
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

EXEC sp_wanted_dayorder '2021-08-12' -- buraya bir tarih girece�im ve procedure bana o g�ne ait order_id leri say�s�n� getirecek


---------------------

-- SORGU PARAMETRELER� TANIMLIYORUZ:

	-- PARAMETRELERE DE�ER ATAMAK ���N SET VEYEA SELECT D�YORUZ
DECLARE @P1 INT, @P2 INT, @SUM INT

SET @P1 = 6

SELECT @P2  =4

SELECT @SUM = @P1 + @P2

SELECT @SUM  -- SELECT �LE YAZDIRDI�INDA SONU� RESULT KISMINDA �IKAR.

PRINT @SUM  -- PRINT �LE YAZDIRDI�INDA SONU� MESSSAGE KISMINDA �IKAR.
-- DE�ER ATAMAK ���N SET VEYA SELECT, 
-- PARAMETREY� �A�IRMAK ���N SELECT




