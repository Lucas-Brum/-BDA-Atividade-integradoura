--1.Crie uma vis�o contendo todos os estados (c�digo e sigla) juntamente com a sua quantidade de cidades e popula��o geral.
Create VIEW VW_ESTADOS_CIDADES

AS

SELECT
	ESTADO.CODIGOESTADO,
	ESTADO.SIGLA,
	COUNT(CIDADE.CODIGOCIDADE) AS 'CIDADES',
	SUM(CIDADE.POPULACAO) AS 'POPUALACAO'
FROM
	ESTADO INNER JOIN CIDADE ON CIDADE.CODIGOESTADO = ESTADO.CODIGOESTADO
GROUP BY
	ESTADO.CODIGOESTADO,
	ESTADO.SIGLA


SELECT * FROM VW_ESTADOS_CIDADES



--2.Crie uma vis�o contendo todos os N�veis de ensino (c�digo e descri��o) cadastrados juntamente com a quantidade de escolas deste n�vel.
Create VIEW NIVEIS
AS
SELECT 
	NivelEnsino.Descricao,
	NivelEnsino.CodigoNivelEnsino,
	count(Escola_NivelEnsino.CodigoEscola) AS QuantEscola
FROM
	NivelEnsino
	INNER JOIN Escola_NivelEnsino
	ON NivelEnsino.CodigoNivelEnsino = Escola_NivelEnsino.CodigoEscola
group by 
	NivelEnsino.Descricao,
	NivelEnsino.CodigoNivelEnsino
--3.Adicione uma coluna �Nivel� na tabela Escola do tipo Char(1)

Alter table ESCOLA

add Nivel char(1) null

--4.Crie um cursor que atualize a coluna n�vel da tabela de escolas com as seguintes regras:
	--1.Escolas com mais de tr�s n�veis de ensino s�o niveladas com a categoria A
	--2.Escolas com tr�s n�veis de ensino s�o niveladas com a categoria B
	--3.Escolas com dois n�veis de ensino s�o niveladas com a categoria C
	--4.Demais escolas s�o niveladas com a categoria D 

Begin transaction

Declare @nivel char(1)

Declare @CodigoNivelEnsino int

Declare @codigoEscola int

Declare Categoria cursor for

select Nivel, count(Escola_NivelEnsino.CodigoEscola) as NivelEnsino, Escola.CodigoEscola

from Escola inner join Escola_NivelEnsino 
on Escola.CodigoEscola = Escola_NivelEnsino.CodigoEscola

group by
Escola_NivelEnsino.CodigoEscola, 
escola.nivel,
Escola.CodigoEscola

open Categoria

fetch next from Categoria into

@nivel,

@CodigoNivelEnsino,

@CodigoEscola

WHILE @@FETCH_STATUS = 0

BEGIN


if @CodigoNivelEnsino > 3

update Escola

set nivel = 'A'

where CodigoEscola = @codigoEscola



if @CodigoNivelEnsino = 3

update Escola

set nivel = 'B'

where CodigoEscola = @codigoEscola



if @CodigoNivelEnsino = 2

update Escola

set nivel = 'C'

where CodigoEscola = @codigoEscola

if @CodigoNivelEnsino <= 1

update Escola

set nivel = 'D'

where CodigoEscola = @codigoEscola


fetch next from Categoria into @nivel, @CodigoNivelEnsino, @CodigoEscola

END

close Categoria

DEALLOCATE Categoria

Commit