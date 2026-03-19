#%%
import duckdb
from pathlib import Path
#%%
root_path = Path(__file__).parent.parent            # Comando para pegar o diretório raiz

silver_path = root_path / 'data' / '03_silver'
gold_path = root_path / 'data' / '04_gold'

sql_path = Path(__file__).parent / 'sql'

bank_paths = {
    'inter_st': Path('inter') / 'statements',
    'inter_in': Path('inter') / 'invoices',

    'nubank_st': Path('nubank') / 'statements',
    'nubank_in': Path('nubank') / 'invoices'
}

for file_prefix, relative_path in bank_paths.items():

    p_in = silver_path / relative_path / '*.parquet'
    p_out = gold_path / relative_path / f'{file_prefix}.parquet'

p_in1 = silver_path / 'inter' / 'statements' / 'inter_st.parquet'
p_in2 = silver_path / 'nubank' / 'statements' / 'nubank_st.parquet'

df_inter = duckdb.read_parquet(str(p_in1))
df_nubank = duckdb.read_parquet(str(p_in2))



sql_file = (sql_path / 'union.sql').read_text(encoding='utf-8')

result = duckdb.sql(sql_file)

result.show()