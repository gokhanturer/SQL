
----------INSERT

----!!! ilgili kolonun �zelliklerine ve k�s�tlar�na uygun veri girilmeli !!!


-- Insert i�lemi yapaca��n�z tablo s�tunlar�n� a�a��daki gibi parantez i�inde belirtebilirsiniz.
-- Bu kullan�mda sadece belirtti�iniz s�tunlara de�er girmek zorundas�n�z. S�tun s�ras� �nem arz etmektedir.

INSERT INTO Person.Person (Person_ID, Person_Name, Person_Surname) VALUES (75056659595,'Zehra', 'Tekin')

INSERT INTO Person.Person (Person_ID, Person_Name) VALUES (889623212466,'Kerem')


--E�er bir tablodaki t�m s�tunlara insert etmeyecekseniz, se�ti�iniz s�tunlar�n haricindeki s�tunlar Nullable olmal�.
--E�er Not Null constrainti uygulanm�� s�tun varsa hata verecektir.

--A�a��da Person_Surname s�tununa de�er girilmemi�tir. 
--Person_Surname s�tunu Nullable oldu�u i�in Person_Surname yerine Null de�er atayarak i�lemi tamamlar.

INSERT INTO Person.Person (Person_ID, Person_Name) VALUES (78962212466,'Kerem')

--Insert edece�im de�erler tablo k�s�tlar�na ve s�tun veri tiplerine uygun olmazsa a�a��daki gibi i�lemi ger�ekle�tirmez.


--Insert keywordunden sonra Into kullanman�za gerek yoktur.
--Ayr�ca A�a��da oldu�u gibi insert etmek istedi�iniz s�tunlar� belirtmeyebilirsiniz. 
--Buna ra�men s�tun s�ras�na ve yukar�daki kurallara dikkat etmelisiniz.
--Bu kullan�mda tablonun t�m s�tunlar�na insert edilece�i farz edilir ve sizden t�m s�tunlar i�in de�er ister.

INSERT Person.Person VALUES (15078893526,'Mert','Yeti�')

--E�er de�eri bilinmeyen s�tunlar varsa bunlar yerine Null yazabilirsiniz. 
--Tabiki Null yazmak istedi�iniz bu s�tunlar Nullable olmal�d�r.

INSERT Person.Person VALUES (55556698752, 'Esra', Null)



--Ayn� anda birden fazla kay�t insert etmek isterseniz;

INSERT Person.Person VALUES (35532888963,'Ali','Tekin');-- T�m tablolara de�er atanaca�� varsay�lm��t�r.
INSERT Person.Person VALUES (88232556264,'Metin','Sakin')


--Ayn� tablonun ayn� s�tunlar�na bir�ok kay�t insert etmek isterseniz a�a��daki syntax� kullanabilirsiniz.
--Burada dikkat edece�iniz di�er bir konu Mail_ID s�tununa de�er atanmad���d�r.
--Mail_ID s�tunu tablo olu�turulurken identity olarak tan�mland��� i�in otomatik artan de�erler i�erir.
--Otomatik artan bir s�tuna de�er insert edilmesine izin verilmez.

INSERT INTO Person.Person_Mail (E_Mail, Person_ID) 
VALUES ('zehtek@gmail.com', 75056659595),
	   ('meyet@gmail.com', 15078893526),
	   ('metsak@gmail.com', 35532558963)

--Yukar�daki syntax ile a�a��daki fonksiyonlar� �al��t�rd���n�zda,
--Yapt���n�z son insert i�leminde tabloya eklenen son kayd�n identity' sini ve tabloda etkilenen kay�t say�s�n� getirirler.
--Not: fonksiyonlar� teker teker �al��t�r�n.

SELECT @@IDENTITY--last process last identity number
SELECT @@ROWCOUNT--last process row count



--A�a��daki syntax ile farkl� bir tablodaki de�erleri daha �nceden olu�turmu� oldu�unuz farkl� bir tabloya insert edebilirsiniz.
--S�tun s�ras�, tipi, constraintler ve di�er kurallar yine �nemli.

select * into Person.Person_2 from Person.Person-- Person_2 �eklinde yedek bir tablo olu�turun


INSERT Person.Person_2 (Person_ID, Person_Name, Person_Surname)
SELECT * FROM Person.Person where Person_name like 'M%'


--A�a��daki syntaxda g�rece�iniz �zere hi�bir de�er belirtilmemi�. 
--Bu �ekilde tabloya tablonun default de�erleriyle insert i�lemi yap�lacakt�r.
--Tabiki s�tun constraintleri buna elveri�li olmal�. 

INSERT Book.Publisher
DEFAULT VALUES



--update