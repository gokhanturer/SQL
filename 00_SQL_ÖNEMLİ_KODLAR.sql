-----------SQL SERVER �NEML� KODLAR ---------------
-- kaynak:   https://www.sqlkodlari.com/31-sql-primary-key-kullanimi.asp
-- Kaynak  : https://sqlserveregitimleri.com/sql-server-primary-key-constraint-kullanimi

-- INDEX
--		1. DATABASE CREATE ETME 
--		2. TABLO CREATE ETME
--		3. INSERT INTO �LE TABLOYA VER� G�RMEK
--		4. INSERT INTO �LE B�R TABLODAK� VER�LER� ALIP VAROLAN B�R TABLO ���NE KOPYALAMAK
--		5. PRIMARY KEY TANIMLAMAK
--		6. PRIMARY KEY ALANINI KALDIRMAK
--		7. FOREIGN KEY TANIMLAMAK
--		8. FOREIGN KEY ALANINI KALDIRMAK
--		9. ALTER TABLE
--		10.DROP
--		11.DELETE
--		12.CONVERT KULLANIMI
--		13.CREATE VIEW ...AS
--		14.CTE COMMON TABLE EXPRESSIONS 
--		15.CREATE INDEX
--		16.LIKE



-- 1. DATABASE CREATE ETME-----------------------------------------------------------------------------------
	-- Bu i�lemi yapabilmek i�in mevcut kullan�c�m�z�n veritaban� olu�turma yetkisine sahip olmas� gerekmektedir.

CREATE DATABASE veritabani_adi


-- 2. TABLO CREATE ETME---------------------------------------------------------------------------------------
	-- Bu i�lemi yapabilmek i�in mevcut kullan�c�m�z�n tablo olu�turma yetkisine sahip olmas� gerekmektedir.

CREATE TABLE tablo_ad�
(
alan_adi1 veri_tipi(boyut) Constraint_Ad�,
alan_adi2 veri_tipi(boyut),
alan_adi3 veri_tipi(boyut),
....
)
-- CONSTRAINT'LER:

--NOT NULL   : Alan�nda bo� ge�ilemeyece�ini belirtir.
--UNIQUE     : Bu alana girilecek verilerin hi� biri birbirine benzeyemez. Yani tekrarl� kay�t i�eremez.
--PRIMERY KEY: Not Null ve Unique kriterlerinin her ikisini birden uygulanmas�d�r.
--FOREIGN KEY: Ba�ka bir tablodaki kay�tlarla e�le�tirmek i�in alandaki kay�tlar�n tutarl�l���n� belirtir.
--CHECK      : Alandaki de�erlerin belli bir ko�ulu sa�lamas� i�in kullan�l�r.
--DEFAULT    : Alan i�in herhangi bir de�er girilmezse, vars�yalan olarak bir de�er giremeyi sa�lar.

-- �rnek:
CREATE TABLE Personel
(
id int,
adi_soyadi varchar(25),
sehir varchar(15),
bolum varchar(15),
medeni_durum bolean
)


-- 3. INSERT INTO �LE TABLOYA VER� G�RMEK-----------------------------------------------------------------------

	-- Burada dikkat edece�imiz nokta eklenecek de�er tablomuzdaki alan s�ras�na g�re olmal�d�r.
	-- Values ifadesinden yaz�lacak de�erler s�ras� ile i�lenir.

INSERT INTO  tablo_adi
VALUES (deger1, deger2, ...)

-- di�er y�ntem:
	--Bu y�ntemde ise eklenecek alanlar� ve de�erleri kendimiz belirtiriz. 
	-- Burada dikkat edilmesi gereken �ey; yazd���m�z alan ad�n�n s�ras�na g�re de�erleri eklememiz olacakt�r.
INSERT INTO  tablo_adi (alan_adi1, alan_adi2, alan_adi3)
VALUES (deger1, deger2, deger3)

--�rnek1 (tablonun t�m s�tunlar�na veri giri�i)
INSERT INTO Personel 
VALUES (3, 'Serkan �ZG�REL', 'Erzincan', 'Muhasebe', 3456789)
-- �rnek2 (tablonun yaln�zca 3 alan�na veri giri�i) 
INSERT INTO Personel (id, adi_soyadi, sehir)
VALUES (3, 'Serkan �ZG�REL', 'Erzincan')



-- 4. INSERT INTO �LE B�R TABLODAK� VER�LER� ALIP VAROLAN B�R TABLO ���NE KOPYALAMAK-----------------------------

	-- Hedefte belirtti�imiz tablonun var olmas� gerekmektedir. 
	-- Hedef tabloda var olan alanlar silinmez. Var olan alanlar�n yan�na yeni alanlar eklenir.

INSERT INTO Hedef_tablo (alan_adi1,alan_adi2...)
SELECT alan_adi1,alan_adi2...
FROM tablo1

---- 4. a. T�m s�tunlar� kopyalama
INSERT INTO personel_yedek
SELECT *
FROM personel

---- 4. b. S�tun isimlerini de�i�tirerek kopyalama
INSERT INTO personel_yedek (isim, sehir)
SELECT  ad_soyad, sehir
FROM personel

---- 4. c. Belirli kriterlere g�re kopyalama 
INSERT INTO istanbul_personelleri (isim)
SELECT ad_soyad
FROM personel
WHERE sehir='istanbul'

-- 5. PRIMARY KEY TANIMLAMAK ----------------------------------------------------------------------------

----- 5. a. TABLO OLU�TURURKEN TANIMLAMAK

---------5. a. (1) sadece bir alanda kullan�m bi�imine �rnek
CREATE TABLE Personel
(
id int NOT NULL PRIMARY KEY,
adi_soyadi varchar(20) ,
Sehir varchar(20)
)

--------5. a. (2) birden fazla alanda kullan�m bi�imine �rnek
CREATE TABLE Personel
(
id int NOT NULL,
adi_soyadi varchar(20) NOT NULL ,
Sehir varchar(20),
CONSTRAINT id_no PRIMARY KEY  (id,adi_soyadi)
)
-- Burada g�r�lece�i �zere birden fazla alan PRIMARY KEY yap�s� i�ine al�n�yor. 
	-- CONSTRAINT ifadesi ile bu i�leme bir tan�m giriliyor. Asl�nda bu tan�m bizim tablomuzun index alan�n� olu�turmaktad�r. 
	-- �ndexleme sayesinde tablomuzdaki verilerin b�t�l��� daha sa�lam olurken aramalarda da daha h�zl� sonu�lar elde ederiz. 
	-- Ayr�ca kulland���nz uygulama geli�tirme ortamlar�nda (�r .Net) tablo �zerinde daha etkin kullan�m imkan�n�z olacakt�r.
	-- PRIMARY KEY ifadesinden sonra ise ilgili alanlar� virg�l ile ay�rarak yazar�z.


-----5. b. PRIMARY KEY TANIMLAMAK (VAR OLAN B�R TABLOYA)

--------5. b. (1) Sadece bir alanda (s�tunda) kullan�m bi�imine �rnek:
ALTER TABLE Personel
ADD PRIMARY KEY (id)

-- VEYA:
ALTER TABLE Calisanlar
ADD CONSTRAINT PK_CalisanID PRIMARY KEY (ID); 
--Kodu �al��t�rd���m�z zaman Calisanlar tablomuzdaki ID alan�n� Primary Key olarak yapm�� oluyoruz. 
	--PK_CalisanID ifadesi ise bu primary key ifadesine verdi�imiz isimdir. �stedi�iniz ismi verebilirsiniz. 
	-- Ben primary key alan� belli olsun diye PK ifadesi koydum ve 
	-- sonras�nda CalisanID diyerek �al��an id de�eri oldu�unu belirttim.


--------5. b. (2) Birden fazla alanda (s�tunda) kullan�m bi�imine �rnek:
ALTER TABLE Personel
ADD CONSTRAINT  id_no PRIMARY KEY (id,adi_soyadi)

-- Burada dikkat edilecek nokta; ALTER ile sonradan bir alana PRIMARY KEY kriteri tan�mlan�rken 
	-- ilgili alanda veya alanlarda NULL yani bo� kay�t olmamal�d�r.


-------5. b. (3) Tabloya yeni bir s�tun ekleyerek PRIMARY KEY tan�mlamak:
ALTER TABLE market_fact
ADD Market_ID INT PRIMARY KEY IDENTITY(1,1)


--6. PRIMARY KEY ALANINI KALDIRMAK---------------------------------------------------------------------------
ALTER TABLE Personel
DROP  CONSTRAINT id_no

--!!! Burada dikkat edilmesi gereken nokta e�er �oklu alanda PRIMARY KEY i�lemi yapt�ysak, 
	-- CONSTRAINT ifadesinden sonra tablomuzdaki alan ad� de�il, olu�turdu�umuz "index ad�" yaz�lmal�d�r. 
	-- E�er tek bir alanda olu�turduysak o zaman CONSTRAINT  ifadesinden sonra sadece alana ad�n� yazabiliriz.


-- 7. FOREIGN KEY TANIMLAMAK---------------------------------------------------------------------------------

	--Temel olarak FOREIGN KEY yard�mc� index olu�turmak i�in kullan�l�r. 
	-- Bir tabloda "id" alan�na PRIMARY KEY uygulayabiliriz. Ancak ayn� tablodaki ba�ka bir alan farkl� bir tablodaki kayda ba�l� �al��abilir
	-- ��te bu iki tablo aras�nda bir ba� kurmak gerekti�i durumlarda FOREIGN KEY devreye giriyor.
	-- B�ylece tablolar aras� veri ak��� daha h�zl� oldu�u gibi ileride artan kay�t say�s� sonucu veri bozulmalar�n�n �n�ne ge�ilmi� olunur.

------ 7. a. Tablo olu�tururken FOREIGN KEY tan�mlama:
CREATE TABLE Satislar
(
id int NOT NULL PRIMARY KEY,
Urun varchar(20) ,
Satis_fiyati varchar(20),
satan_id int CONSTRAINT fk_satici FOREIGN KEY References Personel(id)
)
-- !! FOREIGN KEY tan�mlamas� yap�l�rken hangi tablodaki hangi alanla ili�kili old�unu 
	-- REFERENCES ifadesinden sonra yazmak gerekir!!
--  CONSTRAINT ile ona bir isim veriliyor. B�ylece daha sonra bu FOREIGN KEY yap�s�n� kald�rmak istersek 
	-- bu verdi�imiz ismi kullanmam�z gerekecektir.

------ 7. b. Var olan tabloya FOREIGN KEY tan�mlama:
ALTER TABLE Satislar
ADD CONSTRAIN fk_satici FOREIGN KEY (satan_id) REFERENCES Personel(id)

ALTER TABLE [dbo].[market_fact] 
ADD CONSTRAIN FK_PROPID FOREIGN KEY ([Prod_id]) REFERENCES [dbo].[prod_dimen]



--8. FOREIGN KEY ALANINI KALDIRMAK ---------------------------------------------------------------------------

ALTER TABLE Satislar
DROP  CONSTRAINT fk_satici



--9. ALTER TABLE -----------------------------------------------------------------------------------------

---- 9. a. S�tun eklemek i�in:
ALTER TABLE tablo_adi
ADD alan_adi veri_tipi

ALTER TABLE dbo.doc_exa 
ADD column_b VARCHAR(20) NULL, 
	column_c INT NULL ;

---- 9. b. S�tun silmek i�in:
ALTER TABLE tablo_adi
DROP COLUMN alan_adi

---- 9. c. S�tun tipini de�i�tirmek:
ALTER TABLE tablo_adi
ALTER COLUMN  alan_adi  veri_tipi



--10.  DROP -----------------------------------------------------------------------------------------------

	-- DROP yap�s� ile indexler, alanlar, tablolar ve veritabanlar� kolayl�kla silinebilir. 
	-- DELETE yap�s� ile kar��t�r�labilir. DELETE ile sadece tablomuzdaki kay�tlar� silebiliriz. 
	-- E�er tablomuzu veya veritaban�m�z� silmek istiyorsak DROP yap�s�n� kullanmam�z gerekmektedir.

DROP INDEX tablo_adi.index_adi
DROP TABLE tablo_adi
DROP DATABASE veritabani_adi
ALTER TABLE dbo.doc_exb DROP COLUMN column_b;

--TRUNCATE TABLE Kullan�m Bi�imi
	--E�er tablomuzu de�ilde sadece i�indeki kay�tlar� silmek istiyorsak yani tablomuzun i�ini bo�altmak istiyorsak 
	--a�a��daki kodu kullanabiliriz:
TRUNCATE TABLE tablo_adi
--Truncate yap�s�nda parametre girilmez direkt olarak t�m kay�tlar� siler. Yeni kay�t yap�l�rsa numaras� 1 den ba�lar.
-- Delete ile b�t�n kay�tlar� sildi�imiz zaman otomatik numara s�ras� ba�tan ba�lamaz.
	-- �rne�in 150 kay�t silindi�inde ve yeni kay�t ekledi�imizde bu 151 olur.



--11. DELETE -------------------------------------------------------------------------------------------

	-- Burada dikkat edilecek nokta WHERE ifadesi ile belli bir kay�t se�ilip silinir. 
	-- E�er WHERE ifadesini kullanmadan yaparsak tablodaki b�t�n kay�tlar� silmi� oluruz.

DELETE  FROM tablo_adi
WHERE secilen_alan_adi=alan_degeri

DELETE FROM Personel 
WHERE Sehir='�stanbul'
AND id = 3



--12. CONVERT KULLANIMI-----------------------------------------------------------------------------------
	--tarih alan�n� farkl� bi�imlerde ekrana yazd�rmak i�in:

SELECT  CONVERT(hedef_veri_tipi, alan_adi, gosterim_formati)
FROM tablo_adi

-- �rnek:
SELECT ad_soyad, CONVERT(VARCHAR(11), dogum_tar, 106) AS [Do�um Tarihi] 
FROM Personel

CONVERT(VARCHAR(19),GETDATE())
CONVERT(VARCHAR(10),GETDATE(),10)
CONVERT(VARCHAR(10),GETDATE(),110)
CONVERT(VARCHAR(11),GETDATE(),6)
CONVERT(VARCHAR(11),GETDATE(),106)
CONVERT(VARCHAR(24),GETDATE(),113)

��kt�s�:
Nov 04 2014 11:45 PM
11-04-14
11-04-2014
04 Nov 14
04 Nov 2014
04 Nov 2014 11:45:34:243



-- 13. CREATE VIEW ...AS ---------------------------------------------------------------------------------

---- 13. a. Yeni VIEW olu�turmak:
CREATE VIEW view_adi AS
Select * From Tablo_adi
Where sorgulama_sartlari

---- 13. b. Var olan bir VIEW �zerinde de�i�iklik yapmak (CREATE OR REPLACE VIEW .. AS)
CREATE OR REPLACE VIEW view_adi AS
Select * From Tablo_adi
Where sorgulama_sartlari

---- 13. c. VIEW silmek:
DROP VIEW view_adi


-- 14. CTE - COMMON TABLE ESPRESSIONS ------------------------------------------------------------------

-- Subquery mant��� ile ayn�. Subquery'de i�erde bir tablo ile ilgileniyorduk CTE'de yukarda yaz�yoruz.

--(CTE), ba�ka bir SELECT, INSERT, DELETE veya UPDATE deyiminde ba�vurabilece�iniz veya i�inde kullanabilece�iniz ge�ici bir sonu� k�mesidir. 
-- Ba�ka bir SQL sorgusu i�inde tan�mlayabilece�iniz bir sorgudur. Bu nedenle, di�er sorgular CTE'yi bir tablo gibi kullanabilir. 
-- CTE, daha b�y�k bir sorguda kullan�lmak �zere yard�mc� ifadeler yazmam�z� sa�lar.


-----14. a. ORDINARY CTE

	--subquery den hi� bir fark� yok. subquery i�erde kullan�l�yor, Ordinary CTE yukarda WITH ile olu�turuluyor.

WITH query_name [(column_name1, ....)] AS
	(SELECT ....)   -- CTE Definition

SQL_Statement

-- sadece WITH k�sm�n� yazarsan tek ba��na �al��maz. WITH ile belirtti�im query'yi birazdan kullanaca��m demek bu. 
-- as�l SQL statement i�inde bunu kullan�yoruz.

---- 14. B. RECURSIVE CTE

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




--15. CREATE INDEX--------------------------------------------------------------------------------------------

	-- E�er tablomuza index tan�m� yaparsak yazaca��m�z uygulamada kay�t arama esnas�nda b�t�n veritaban�n� taramak yerine
	-- indexleri kullanarak daha h�zl� sonu�lar elde ederiz

	-- Tekrar eden de�erlere sahip alana index tan�m� yap�lacaksa:
CREATE INDEX index_adi
ON tablo_adi(alan_adi)

	-- "id" gibi tekrar etmeyen numaralar� bar�nd�ran bir alana index tan�m� yap�lacak ise :
CREATE UNIQUE INDEX index_adi
ON tablo_adi(alan_adi)




--16. LIKE -------------------------------------------------------------------------------------------------

SELECT *
FROM Personel 
WHERE Sehir LIKE '�%'
--Sehir alan�nda � harfi ile ba�layan kay�tlar se�ilmi�tir. 
SELECT *
FROM Personel 
WHERE Bolum LIKE '%Y�netici%'
--Bolum alan�n�n herhangi bir yerinde (ba��nda, ortas�nda veya sonunda) Y�netici kelimesini se�er.
SELECT *
FROM Personel 
WHERE Bolum NOT LIKE '%Y�netici%'
--Bolum alan�n�n herhangi bir yerinde Y�netici yazmayan kay�tlar� se�er
SELECT *
FROM Personel 
WHERE Sehir  LIKE '�zmi_'
--�zmi ile ba�layan ve son harfi ne olursa olsun farketmeyen
SELECT *
FROM Personel 
WHERE Adi_soyadi  LIKE '[S,A]%'
--ilk harfi S veya A ile ba�layan kay�tlar� se�er. 
SELECT *
FROM Personel 
WHERE Adi_soyadi  LIKE '[A-K]%'
--ilk harfi A ile K harfleri aras�nda ki herhangi bir harf ile ba�layan
SELECT *
FROM Personel 
WHERE Adi_soyadi  LIKE '%[A-K]'
-- A ile K harfleri aras�nda ki herhangi bir harf ile biten


