#%%
import duckdb
from pathlib import Path
#%%
root_path = Path(__file__).parent.parent            # Comando para pegar o diretório raiz

bronze_path = root_path / 'data' / '02_bronze'
silver_path = root_path / 'data' / '03_silver'

sql_path = Path(__file__).parent / 'sql'

bank_paths = {
    'inter_st': Path('inter') / 'statements',
    'inter_in': Path('inter') / 'invoices',

    'nubank_st': Path('nubank') / 'statements',
    'nubank_in': Path('nubank') / 'invoices'
}

for file_prefix, relative_path in bank_paths.items():

    p_in = bronze_path / relative_path / '*.parquet'
    p_out = silver_path / relative_path / f'{file_prefix}.parquet'
    sql_file = sql_path / relative_path / f'{file_prefix}.sql'

    # Verifica se o arquivo SQL já existe antes de tentar ler
    if not sql_file.exists():
        print(f'[INFO] Arquivo SQL não encontrado para {file_prefix}. Pulando...')
        continue

    p_out.parent.mkdir(parents=True, exist_ok=True)
    sql_content = sql_file.read_text(encoding="utf-8")

    try:

        df = duckdb.read_parquet(str(p_in)) #Será lido dentro da query SQL
        
        result = duckdb.sql(sql_content)
        
        result.to_parquet(str(p_out))
        print(f'[OK] {file_prefix}.parquet salvo com sucesso!')

    except duckdb.IOException:
        print(f'[AVISO] Nenhum parquet encontrado em {relative_path}. Pulando...\n')
        