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