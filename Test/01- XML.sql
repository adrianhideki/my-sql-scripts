IF OBJECT_ID('dbo.testeXML') IS NOT NULL
  DROP TABLE dbo.testeXML;

CREATE TABLE dbo.testeXML (id Integer, dados XML);

INSERT INTO dbo.testeXML
(id,dados)
VALUES (100, '<?xml version="1.0"?>
              <aluno cod="100">
                <nome>Jose Carlos Macoratti</nome>              
                <historico id="1">
                  <materia nome="Portugues" nota="10"/>
                  <materia nome="Matemtaica" nota="8"/>
                  <materia nome="Fisica" nota="6"/>
                  <materia nome="Ingles" nota="9"/>
                </historico>
              </aluno>');

--//Adicionando uma matéria no histórico
UPDATE dbo.testeXML
   SET dados.modify('insert <materia nome="Química" nota="10"/> into (aluno[@cod=100]/historico[@id=1])[1]');

--//adicionando um histórico
UPDATE dbo.testeXML
   SET dados.modify('insert <historico id="2"/> into (aluno[@cod=100])[1]');

--//adicionando uma matéria no novo histórico
UPDATE dbo.testeXML
   SET dados.modify('insert <materia nome="Inglês" nota="10"/> into (aluno[@cod=100]/historico[@id=2])[1]');

--//atualizando um valor de um atributo
UPDATE dbo.testeXML
   SET dados.modify('replace value of (/aluno/historico[@id=2]/materia[@nome="Inglês"]/@nome)[1] with "Espanol"');

--//atualizando um valor de um atributo
UPDATE dbo.testeXML
   SET dados.modify('replace value of (/aluno/historico[@id=1]/materia/@nota)[2] with "99"');

--//Atualizando o nome do aluno
UPDATE dbo.testeXML
   SET dados.modify('replace value of (/aluno/nome[text() = "Jose Carlos Macoratti"]/text())[1] with "Adriano"');

----//deletando a tag histórico com o id = 2
--UPDATE dbo.testeXML
--   SET dados.modify('delete /aluno/historico[@id=2]');

--//Deletando a matéria de química
UPDATE dbo.testeXML
   SET dados.modify('delete /aluno/historico/materia[@nome="Química"]');

--//Deletando a matéria que tem a nota menor que 10
UPDATE dbo.testeXML
   SET dados.modify('delete /aluno/historico/materia[@nota < 10]');

----//Deletando a tag nome do aluno que tem o nome = "Adriano"
--UPDATE dbo.testeXML
--   SET dados.modify('delete /aluno/nome[text()="Adriano"]');
--
----//Deletando a aluno que tem o nome = "Adriano"
--UPDATE dbo.testeXML
--   SET dados.modify('delete /aluno[nome/text()="Adriano"]');

SELECT * 
FROM dbo.testeXML;

--//recuperando dados XML
       --//o método query() retorna ainda um xml
SELECT dados.query('/aluno/nome/text()') --//recuperando o nome do aluno, retorna ainda como XML
      ,dados.query('/aluno/historico[@id=1]/materia[@nota > 10]') --//recupera as matérias do histórico 1 onde a nota > 10
	  ,dados.query('/aluno/historico[@id=1]') --//recupera as matérias do histórico 1
	  ,dados.query('/aluno[nome/text()="Adriano"]') --//recupera as informações do aluno com o nome adriano
	  --//o método value() retorna um valor scalar, sendo necessário informar o tipo
	  ,dados.value('(/aluno/nome)[1]', 'varchar(100)')        --recuperando o nome
	  ,dados.value('(/aluno/nome/text())[1]', 'varchar(100)') --recuperando o nome
	  ,dados.value('(/aluno/historico[@id=1]/materia[@nome="Portugues"]/@nota)[1]', 'integer') --//pegando a nota de português
	  ,dados.value('(/aluno/historico[@id=1]/materia/@nota)[2]', 'integer') --//pegando a nota da segunda matéria
	  ,dados.value('(/aluno/historico[@id=1]/materia/@nome)[1]', 'varchar(30)') --//pegando a nota da segunda matéria
	  ,dados.exist('/aluno[nome/text() = "Adriano"]') --//verificando se existe uma aluno chamado adriano
	  ,dados.exist('/aluno/historico/materia[@nome="Espanol"]') --//verificando se existe uma matéria chamada espanol
	  ,dados.exist('/aluno/historico/materia[@nota = 0]') --//verificando se existe uma matéria com nota 0
FROM dbo.testeXML

--//NODES
DECLARE @xml XML;

SELECT @xml = dados
FROM dbo.testeXML;

SELECT t.query('./materia[@nota > 0]')
      ,t.value('(./materia/@nome)[1]','varchar(30)')
FROM @xml.nodes('/aluno/historico') AS x (t)

--//fazendo um cursor com xquery
SELECT @xml.query('for $i in aluno
                   let $j := $i/historico
                   where $i/historico/@id < 3
                   order by ($j/@id)[1]
                   return 
                   <Order-orderid-element>
                    <orderid>{data($i/@id)}</orderid>
                    {$j}
                   </Order-orderid-element>') 
       AS [Filtered, sorted and reformatted orders with let clause];