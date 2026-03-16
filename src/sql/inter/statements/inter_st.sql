WITH tb_renomeada AS (
	SELECT "Data Lançamento" AS dataTransacao,
		   Histórico AS tipoTransacao,
		   Descrição AS recebedor,
		   Valor AS valor
	FROM df
),

tb_tipada AS (
	SELECT CAST(dataTransacao AS DATE) AS dataTransacao,
		   REPLACE ( TRIM( UPPER( tipoTransacao ) ), 'PAGAMENTO EFETUADO', 'PAGAMENTO DE FATURA' ) AS tipoTransacao,
		   CASE 
		   	WHEN recebedor LIKE '% - %' THEN TRIM(
		   								UPPER(
		   									SPLIT_PART(recebedor, ' - ', 2)
		   								)
		   							)
		   	WHEN TRIM( UPPER( recebedor ) ) = 'FATURA CARTÃO INTER' THEN 'BANCO INTER'
		   	ELSE TRIM( UPPER( recebedor ) )
		   END AS recebedor,
		   CAST(
		   		REPLACE(
		   			REPLACE(valor, '.', ''), 
		   		',', '.')
		   AS DECIMAL(10,2)) AS valor
	FROM tb_renomeada
)

SELECT *,
	   'BANCO INTER' AS banco
FROM tb_tipada