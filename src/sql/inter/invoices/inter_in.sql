WITH tb_renomeada AS (
	SELECT Data AS data,
		   Lançamento AS nomeCompra,
		   Tipo AS tipoCompra,
		   Valor AS valor
	FROM df
)

SELECT CAST(data AS DATE) AS data,
	   TRIM( UPPER(nomeCompra)) AS nomeCompra,
	   TRIM(UPPER(tipoCompra)) AS tipoCompra,
	   TRY_CAST(TRIM(
	   		REPLACE(
				REPLACE(
					REPLACE(
						REPLACE(valor, CHR(160), ''),
					'R$', ''), 
				'.', ''), 
		   	',', '.')
	   ) AS DECIMAL(10,2)) AS valor
FROM tb_renomeada