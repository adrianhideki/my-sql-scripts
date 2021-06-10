--SQL 2016+
IF OBJECT_ID('dbo.MyParameters') IS NOT NULL
  DROP TABLE dbo.MyParameters;
GO

CREATE TABLE dbo.MyParameters (
  id_param integer identity(1,1) primary key
 ,params nvarchar(max)
) TEXTIMAGE_ON [Primary]; --should you setup the correct filegroup to store blob data
GO

IF OBJECT_ID('dbo.st_AddParameters') IS NOT NULL
  DROP PROCEDURE dbo.st_AddParameters;
GO

CREATE PROCEDURE dbo.st_AddParameters @params   nvarchar(max)
                                     ,@id_param integer OUTPUT
AS
BEGIN
  BEGIN TRY
  SELECT @id_param = NULL;

  IF ISJSON(@params) = 0
  BEGIN
    RAISERROR('Invalid json parameters!',18,1);
  END

  INSERT INTO dbo.MyParameters(params)
  VALUES(@params);

  SELECT @id_param = SCOPE_IDENTITY();
  END TRY
  BEGIN CATCH
    THROW;
  END CATCH
END
GO

DECLARE @params   nvarchar(max) = '{invalid json here}'
       ,@id_param integer       = 0;

EXEC dbo.st_AddParameters @params   = @params
                         ,@id_param = @id_param OUTPUT;

SELECT @id_param;
GO

--//-----------------------//--
--// add simple parameters //--
--//-----------------------//--
DECLARE @params   nvarchar(max) = '[{"initialValue":0,"finalValue":999999, "initialDate":"2021-01-01T00:00:00","finalDate":"2021-12-31T00:00:00"}]'
       ,@id_param integer       = 0;

EXEC dbo.st_AddParameters @params   = @params
                         ,@id_param = @id_param OUTPUT;

SELECT @id_param;
GO

--//------------------//--
--// add array params //--
--//------------------//--
DECLARE @params   nvarchar(max) = '[{"initialValue":0,"finalValue":999999, "selectedIdentifiers": [1,2,3,4,5,6,7,8,9,10]}]'
       ,@id_param integer       = 0;

EXEC dbo.st_AddParameters @params   = @params
                         ,@id_param = @id_param OUTPUT;

SELECT @id_param;
GO

--//-------------------------//--
--// add object array params //--
--//-------------------------//--
DECLARE @params   nvarchar(max) = '[{"id": "48dd019ad0024328ac2bec609ee41dea", "name": "pen", "price": 1.99}, {"id": "f51503812c01453397fd81c0f4621beb", "name": "paper", "price": 3.99}, {"id": "a736639b2d0e4a1abdcb0763ea6abce8", "name": "eraser", "price": 3.99}]'
       ,@id_param integer       = 0;

EXEC dbo.st_AddParameters @params   = @params
                         ,@id_param = @id_param OUTPUT;

SELECT @id_param;
GO

--//-----------------------//--
--// simple get parameters //--
--//-----------------------//--
DECLARE @json nvarchar(max) = '';

SELECT @json = (SELECT TOP (1) params
                FROM dbo.MyParameters
                WHERE id_param = 1);

SELECT initialValue
      ,finalValue
      ,initialDate
      ,finalDate
FROM OPENJSON(@json)
WITH (
  initialValue int '$.initialValue'
 ,finalValue int '$.finalValue'
 ,initialDate DateTime '$.initialDate'
 ,finalDate DateTime '$.finalDate'
);

--// OR
--// use index selector to json with brackets on json value
SELECT initialValue = JSON_VALUE(@json, '$[0].initialValue')
      ,finalValue   = JSON_VALUE(@json, '$[0].finalValue')
      ,initialDate  = JSON_VALUE(@json, '$[0].initialDate')
      ,finalDate    = JSON_VALUE(@json, '$[0].finalDate')

GO

-------------------------------------------------
--// parameters with array (with cross join) //--
-------------------------------------------------
DECLARE @arrayParam nvarchar(max) = '';

SELECT @arrayParam = (SELECT TOP (1) params
                      FROM dbo.MyParameters
                      WHERE id_param = 2);

SELECT x.initial_date
      ,x.final_date
      ,x.selected_identifiers
      ,fnx.id
FROM OPENJSON(@arrayParam)
WITH (
  initial_date int '$.initialValue'
 ,final_date int '$.finalValue'
 ,selected_identifiers nvarchar(max) '$.selectedIdentifiers' AS JSON
) AS x
   -- generate rows by array
   CROSS APPLY (SELECT *
                FROM OPENJSON(x.selected_identifiers)
                WITH (
                  id int '$'
                )) AS fnx;
GO

--------------------------
--// array of objects //--
--------------------------
DECLARE @arrayObject nvarchar(max) ='';

SELECT @arrayObject = (SELECT TOP (1) params
                       FROM dbo.MyParameters
                       WHERE id_param = 3);

SELECT *
FROM OPENJSON(@arrayObject)
WITH (
  id     varchar(32) '$."id"'
 ,[name] varchar(100) '$."name"'
 ,price  numeric(18,2) '$."price"'
) AS x;

GO