
## 1. Avancerad SQL och Normalisering  

   **a) Beskriv en komplex databasstruktur du har arbetat med (eller skapa en hypotetisk struktur med minst 4 relaterade tabeller**

Jag b�rjar med att skapa fyra relaterade tabeller: Product, Order, Customer, Transportation, och OrderDetail.

**product tabellet**
- product_id : innerh�ller product id och det �r increment
- product_name : innerh�ller product name med varchar (255)
- product_price : innerh�ller product price med decimal data type.
- product_description : innerh�ller product description med varchar (255)

 **order tabellet**
- order_id : innerh�ller order id och det �r increment
- order_date : innerh�ller order date med date data type
- order_status : innerh�ller order status med varchar (255)
- order_total : innerh�ller order total med integer data type.
- kunde_id : innerh�ller kunde id med foreign key
- transportation_id : innerh�ller transportation id med foreign key

 **kunde tabellet**
- client_id : innerh�ller kunde id och det �r increment
- client_name : innerh�ller kunde name med varchar (255)
- client_email : innerh�ller kunde email med varchar (255)
- client_phone : innerh�ller kunde phone med varchar (255)

 **transportation tabellet**
- transportation_id : innerh�ller transportation id och det �r increment
- transportation_name : innerh�ller transportation name med varchar (255)

**order detail**
- orderdetail_id inneh�ller best�lling detailj id
- order_id : innerh�ller order id med foreign key.
- product_id : innerh�ller product id med foreign key
- quality : innerh�ller totalt av varor som best�llas med int data type.
- price : innerh�ller totalt pris med decimal data type.

Mina tankar �r baserade p� ett diagram som jag f�rst skissade f�r hand, f�r att kunna se relationerna mellan tabellerna, som om de �r en-till-m�nga eller m�nga-till-m�nga, och om det finns n�gon terti�r relation. Order ska fungera som en entitet som kopplar ihop Product och Customer, samt Transportation.
Det �r viktigt att f�rst� relationerna mellan tabellerna innan man skapar dem. Diagrammet hj�lper till att visualisera detta, men det �r ocks� viktigt att t�nka p� schema-designen. Ett schema visar b�de prim�rnycklar (PK) och fr�mmande nycklar (FK), vilket g�r det l�ttare att f�rst� vad som ska finnas i varje tabell.

![I M G 0457](IMG_0457.JPG)

**shema som skriva jag efter�t** 
- client: [client_id (PK), name, email]
- product : [product_id (PK), product_name, product_description, product_price]
- order : [order_id (PK), order_date, order_status, client.id(Fk to client)]
- order_detail : [orderdetail_id (PK), product_id (FK to product),order_id(FK to product), quantity,price]
- transport :[ transport_id (PK), transport_name]

Efter att jag skapat tabellerna b�rjade jag s�tta relationer mellan dem. N�r jag ritade ER-diagrammet valde jag att representera Customer och Product som huvudobjekt (subject), medan Order och Transport fungerar som relationer (verb) mellan kunder och produkter. Detta g�r det tydligare f�r mig att f�rst� hur relationerna ska struktureras, vilket illustreras i diagrammet.
Tabellerna �r baserade p� en m�nga-till-m�nga-relation, eftersom en kund kan best�lla flera produkter, och varje produkt kan best�llas av flera kunder. Detta ger en m�nga-till-m�nga-relation mellan Customer och Product via Order.
N�r det g�ller Transport blir det lite mer komplext. Transport kan ses som b�de ett subjekt och ett verb, men i mitt fall har jag valt att betrakta det som ett subjekt. Relationen mellan Order och Transport �r ocks� m�nga-till-m�nga, eftersom en transport kan leverera flera best�llningar, och en best�llning kan levereras med flera olika transporter.

![Sk�rmbild 2024 10 25 212746](Sk�rmbild%202024-10-25%20212746.png)

   **b) Skriv en avancerad SQL-fr�ga som involverar minst tv� JOIN-operationer och en sub-fr�ga. F�rklara hur fr�gan fungerar och varf�r den �r strukturerad p� detta s�tt.**  
   
   Jag vill veta vilken kund som har best�llt fler �n 10 artiklar och den totala best�llningen per kund.
```sql
SELECT C.Name, O.OrderID, SUM(OD.Quantity) AS TotalQuantity
FROM Customers C
JOIN Orders O ON C.CustomerID = O.CustomerID
JOIN OrderDetails OD ON O.OrderID = OD.OrderID
WHERE O.OrderID IN (SELECT OrderID FROM OrderDetails GROUP BY OrderID HAVING SUM(Quantity) > 10)
GROUP BY C.Name, O.OrderID;
```
En effektiv metod f�r att h�mta data �r att anv�nda en subquery f�r att f�rst r�kna en summa (t.ex. summan av en best�llning) och sedan filtrera med en WHERE-sats. Subqueryn h�mtar och summerar relevant data, och i WHERE-satsen anv�nds den f�r att filtrera s� att endast de poster som matchar med t.ex. OrderID inkluderas i huvudfr�gan.
Efter att subqueryn har filtrerat best�llningarna (med hj�lp av OrderID) anv�nds JOIN-satser f�r att koppla ihop flera tabeller, s�som Customers, Orders och OrderDetails. Detta g�r att man kan h�mta relaterad information fr�n dessa tabeller, t.ex. CustomerID och OrderID, vilket ger en komplett bild av de data man �r intresserad av.
Till slut summeras den filtrerade datan f�r varje order, och den sorteras enkelt f�r att f� en strukturerad �versikt.

   **c) Analysera din databasstruktur ur ett normaliseringsperspektiv. Identifiera vilken normaliseringsform den uppfyller och motivera ditt svar.**

Jag anv�nder 3NF (tredje normalformen) eftersom jag f�rs�ker undvika transitiv beroende i databasen, s� att det inte finns n�gra transitiva beroenden mellan icke-nyckelf�lten. D�rf�r skapas separata tabeller mellan dem.

**Unnormalized Form (UNF)**

| Order ID | Customer Name | Product Names        | Product Quantities | Order Date  |
|----------|---------------|----------------------|--------------------|-------------|
| 1        | Alice Smith   | Apples, Bananas      | 5, 2               | 2024-10-20  |
| 2        | Bob Johnson    | Oranges              | 3                  | 2024-10-21  |
| 3        | Alice Smith   | Bananas, Grapes      | 2, 1               | 2024-10-22  |

efter gjorde normalisering.

**Customers Table**

| Customer ID | Customer Name | 
|-------------|---------------|
| 1           | Alice Smith   |
| 2           | Bob Johnson    |

**Orders Table**

| Order ID | Customer ID | Order Date  |
|----------|-------------|-------------|
| 1        | 1           | 2024-10-20  |
| 2        | 2           | 2024-10-21  |
| 3        | 1           | 2024-10-22  |

**Order Details Table**

| Order ID | Product ID | Product Quantity |
|----------|------------|------------------|
| 1        | 1          | 5                |
| 1        | 2          | 2                |
| 2        | 3          | 3                |
| 3        | 2          | 2                |
| 3        | 4          | 1                |

**Products Table**

| Product ID | Product Name | 
|------------|--------------|
| 1          | Apples       |
| 2          | Bananas      |
| 3          | Oranges      |
| 4          | Grapes       |


## 2. Databasdesign och Alternativa L�sningar:  
 **a) F�resl� minst tv� f�rb�ttringar till din databasdesign. Motivera varf�r dessa f�rb�ttringar skulle vara f�rdelaktiga.**  
    
 - I Customer-tabellen kan adressen delas upp i separata f�lt, s�som gata och l�genhetsnummer, f�r att underl�tta s�kning.
 - Jag funderar p� relationerna mellan tabellerna. Ist�llet f�r att anv�nda separata prim�rnycklar kan man anv�nda en sammansatt prim�rnyckel best�ende av (order_id, product_id). Detta inneb�r att det direkt l�nkar till b�de Order och Product, vilket minskar dataduplicering. Det �r viktigt att t�nka p� att kunder kan best�lla samma produkt flera g�nger, och varje g�ng dyker produkten upp i OrderDetail.
 - I OrderDetail kan det l�ggas till ett f�lt f�r datum f�r senaste uppdatering. Detta �r anv�ndbart f�r dem som arbetar med att kolla orderstatus, s� att de ocks� kan se n�r best�llningen senast uppdaterades. Detta underl�ttar n�r man f�ljer upp �renden med kunderna.

    **b) Diskutera minst ett alternativt s�tt att strukturera din databas. J�mf�r f�r- och nackdelar mellan din ursprungliga design och det alternativa f�rslaget.**
    
    Man kan ocks� skapa en separat tabell f�r Invoice f�r att hantera fakturor och kvitton, vilket skulle ha en relation med Order. Stored procedures och transaktioner kan anv�ndas i detta sammanhang eftersom de g�r det enklare och smidigare att samla alla queries i en stored procedure och bara anropa den. Dessutom kan transaktioner hj�lpa till att kontrollera tillst�ndet f�r queryn. Ibland kan ov�ntade h�ndelser intr�ffa n�r man best�ller varor, och d� kan rollback anv�ndas f�r att �terst�lla systemet. Jag tror att detta kan leda till b�ttre prestanda och snabbhet.
    Samtidigt kan detta �ka komplexiteten och g�ra systemet mer komplicerat, eftersom det kan skapa fler beroenden och relationer mellan tabellerna. Om man g�r ett felaktigt val av data kan det p�verka hela systemet negativt.

## 3. J�mf�relse mellan Relationsdatabaser och Dokumentdatabaser:  
 **a) Hur skulle din databasstruktur se ut om den implementerades i en dokumentdatabas som MongoDB ist�llet f�r en relationsdatabas?**  
    
 Att skapa olika samlingar (collections) i samma databas och spara alla f�lt i en JSON-fil innan de implementeras i MongoDB

 **b) Diskutera f�rdelar och nackdelar med att anv�nda en dokumentdatabas j�mf�rt med en relationsdatabas f�r din specifika datastruktur.**
    
 **F�rdelarna** med att anv�nda en dokumentdatabas inkluderar enkelhet och flexibilitet f�r att l�gga till nya f�lt utan att beh�va �ndra hela strukturen. Det m�jligg�r ocks� att lagra all information i ett enda dokument, vilket minskar behovet av att g�ra JOINs mellan olika tabeller.
 
 **Nackdelarna** med att anv�nda en dokumentdatabas inkluderar risken f�r dataduplicering och bristande dataintegritet, vilket kan leda till inkonsistenser. Dessutom �r normalisering, som �r viktig i relationsdatabaser, inte lika str�ng i dokumentdatabaser, vilket kan g�ra det sv�rare att s�kerst�lla att data �r korrekt och konsekvent.  

## 4. Reflektion och Argumentation:  
 **a) Reflektera �ver dina designval i databasstrukturen. Vilka �verv�ganden gjorde du och varf�r?**  
 
 Jag har h�nsyn till flera faktorer, s�som dataintegritet, hantering av relationer och flexibilitet vid uppdatering. D�rf�r valde jag att designa min databas med en relationsdatabas, eftersom jag vill s�kerst�lla datakvalitet genom att anv�nda normalisering i tredje normalform (3NF). Genom att g�ra detta undviker jag transitiva beroenden mellan icke-nyckelf�lt.
 Jag lade ocks� stor vikt vid ER-diagrammet f�r att underl�tta tolkningen av tabellerna, som visat i bild (1). Detta hj�lper mig att b�ttre f�rst� relationerna och kopplingarna mellan tabellerna, s�rskilt under normaliseringen.
 I relationen mellan kunder och produkter representeras best�llningen (order) som en diamant i ER-diagrammet. Detta indikerar att det beh�vs en ny tabell, s�som OrderDetail, f�r att hantera detaljerna kring best�llningarna. Jag valde att skapa denna nya tabell f�r att undvika dataduplicering, vilket f�rb�ttrar b�de prestanda och effektivitet vid s�kning och h�mtning av data senare.

 **b) Argumentera f�r varf�r din valda design �r l�mplig f�r �ndam�let. Inkludera en diskussion om potentiella konsekvenser av dina val.**
 
 Min valda design �r flexibel och passar bra f�r framtida uppdateringar. Till exempel, i framtiden kan jag vilja l�gga till en ny entitet som heter Faktura genom att l�gga till nya kolumner och f�lt, vilket g�r det m�jligt att koppla relationer mellan tabellerna utan att p�verka den existerande strukturen. Jag tror att detta �r en mycket bra l�sning.Dessutom �r min design effektiv och optimerad. Genom att anv�nda normalisering och dela upp informationen i tabeller kan jag optimera queries, b�de f�r enklare och mer komplexa fr�gor. Till exempel kan jag enkelt fr�ga efter kunder som har k�pt produkter mer �n 10 g�nger.
 Avslutningsvis bidrar dataintegritet, som s�kerst�lls genom anv�ndning av prim�ra nycklar och fr�mmande nycklar, till en mer ordnad och strukturerad information.
