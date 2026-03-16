WITH tb_renomeada AS (
	SELECT "Data" AS dataTransacao,
		   Descrição AS descTransacao,
		   Valor AS valor
	FROM df
),

tb_tipada AS (
	SELECT CAST(dataTransacao AS DATE) AS dataTransacao,
		   TRIM(
		   		UPPER(
		   			SPLIT_PART(descTransacao, ' - ', 1)
		   		)
		   ) AS tipoTransacao,
		   TRIM(
		   		UPPER(
		   			SPLIT_PART(descTransacao, ' - ', 2)
		   		)
		   ) AS recebedor,
		   CAST(valor AS DECIMAL(10, 2)) AS valor
		   
	FROM tb_renomeada
),

tb_completa AS (
	SELECT *,
		   CASE
		   	WHEN TRIM(UPPER(tipoTransacao)) = 'TRANSFERÊNCIA RECEBIDA PELO PIX' THEN 'PIX RECEBIDO'
		   	WHEN TRIM(UPPER(tipoTransacao)) = 'TRANSFERÊNCIA RECEBIDA' THEN 'PIX RECEBIDO'
		   	WHEN TRIM(UPPER(tipoTransacao)) = 'TRANSFERÊNCIA ENVIADA PELO PIX' THEN 'PIX ENVIADO'
		   	ELSE TRIM(UPPER(tipoTransacao))
		   END AS tipoTransacaoFormatada,
		   COALESCE(NULLIF(recebedor, ''), 'NUBANK') as recebedorFormatado
	FROM tb_tipada
)

SELECT dataTransacao,
	   tipoTransacaoFormatada AS tipoTransacao,
	   recebedorFormatado AS recebedor,
	   valor,
	   'NUBANK' AS banco
FROM tb_completa

