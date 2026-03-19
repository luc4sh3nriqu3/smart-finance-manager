WITH tb_renomeada AS (
	SELECT date AS data,
		   title AS tipoTransacao,
		   amount AS valor
	FROM df
),

tb_formatada AS (
	SELECT valor,
		   CAST( data AS DATE) AS data,
		   TRIM(
		   		UPPER(
		   			SPLIT_PART(tipoTransacao, ' - ', 1)
		   		)
		   ) AS nomeCompra,
		   TRIM(
		   		UPPER(
		   			SPLIT_PART(tipoTransacao, ' - ', 2)
		   		)
		   ) AS aux,	
		   CASE
			   WHEN SUBSTR(aux, 1, 1) ~ '^[0-9]' THEN 'PARCELA ' || aux
			   WHEN SUBSTR(aux, 1, 1) ~ '^[A-Z]' THEN aux
			   ELSE 'COMPRA À VISTA'
		   END AS tipoCompra
	FROM tb_renomeada
)

SELECT data,
	   nomeCompra,
	   tipoCompra,
	   valor
FROM tb_formatada