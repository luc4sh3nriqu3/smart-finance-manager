#%%
from pathlib import Path
import duckdb
#%%
#Lendo arquivo csv e salvando em formato parquet na camada bronze


current_path = Path(__file__).parent            # Comando para pegar o diretório atual do arquivo (para garantir o caminho correto)
root_path = current_path.parent                 # Pasta raiz (pasta pai do caminho atual que é src) 

import_path = root_path / 'data' / '01_raw'     # Caminho referência que utilizaremos para importar os dados dos bancos
save_path = root_path / 'data' / '02_bronze'    # Local raiz onde salvaremos as tabelas no formato parquet. Aqui é a primeira camada da arquitertura medalhão

bank_paths = {
    'inter_st': Path('inter') / 'statements',
    'inter_in': Path('inter') / 'invoices',

    'nubank_st': Path('nubank') / 'statements',
    'nubank_in': Path('nubank') / 'invoices'
}

for file_prefix, relative_path in bank_paths.items():

    p_in = import_path / relative_path / '*.csv'    # Caminho de entrada dos arquivos
    p_out = save_path / relative_path / f'{file_prefix}.parquet' # Caminho de saída dos arquivos

    p_out.parent.mkdir(parents=True, exist_ok=True)

    try:
        df = duckdb.read_csv(str(p_in))
        df.to_parquet(str(p_out))
        print(f'[OK] {file_prefix}.parquet salvo com sucesso!')
    except duckdb.IOException:
        print(f'[AVISO] Nenhum csv encontrado em {relative_path}. Pulando...\n')

print('Ingestão finalizada!')