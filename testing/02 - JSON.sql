use AdventureWorks2017

SELECT TOP (1)
       FirstName
      ,MiddleName
	  ,LastName
	  ,PersonType
	  ,ModifiedDate
FROM [Person].[Person]
FOR JSON AUTO

SELECT TOP (1)
       FirstName
      ,MiddleName
	  ,LastName
	  ,PersonType
	  ,ModifiedDate
FROM [Person].[Person]
FOR JSON PATH

--//Alterando o auto map do json
SELECT TOP (1)
       FirstName    AS [Person.FirstName]
      ,MiddleName   AS [Person.MiddleName]
	  ,LastName	    AS [Person.LastName]
	  ,PersonType   AS [Person.Information.PersonType]
	  ,ModifiedDate AS [Person.Information.ModifiedDate]
FROM [Person].[Person]
FOR JSON PATH


--//Observações o JSON é case sensitive, cuidade ao informar as propriedades
DECLARE @json AS NVARCHAR(MAX) = N' 
{  
   "Customer":{  
      "Id":1,  
      "Name":"Customer NRZBB", 
      "Order":{  
         "Id":10692,  
         "Date":"2015-10-03", 
         "Delivery":null 
      } 
   } 
}';  

SELECT JSON_VALUE(@json, '$.Customer.Id')    AS CustomerId,  --//retorna somente o valor
       JSON_VALUE(@json, '$.Customer.Name')  AS CustomerName, --//retornar somente o valor 
	   JSON_QUERY(@json, '$.Customer')       AS Curtomer, --retorna um objeto JSON
       JSON_QUERY(@json, '$.Customer.Order') AS Orders; --no caso retorna o conjunto da propriedade Order

SET @json = JSON_MODIFY(@json, '$.Customer.Id', 322) --//Alterando a propriedade Id do objeto Customer para 322

SELECT @json

SET @json = JSON_MODIFY (@json, '$.Customer.Name', 'Adrian') --//Alterando o customer.name para adrian
 
SELECT JSON_VALUE(@json, '$.Customer.Name')

--//Deletando a propriedade Customer.Order.Date
SET @json = JSON_MODIFY (@json, '$.Customer.Order.Date', NULL)

SELECT @json

--//Adicionando a propriedade Customer.Order.Date
SET @json = JSON_MODIFY (@json, '$.Customer.Order.Date', '20171231')

SELECT @json

--//Adicionando um objeto JSON no objeto Customer
SET @json = JSON_MODIFY (@json, '$.Customer.Person', '{age: 23, hobby:run}')

SELECT @json

--//validando se um arquivo ou texto é realmente um JSON

SELECT ISJSON('a')        AS [teste 1]
      ,ISJSON('{}')	      AS [teste 2]
	  ,ISJSON('{a 1}')    AS [teste 3]
	  ,ISJSON('{a: 1}')   AS [teste 4]
	  ,ISJSON('{"a": 1}') AS [teste 5]