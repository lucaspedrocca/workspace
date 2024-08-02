import pandas as pd
from tabulate import tabulate

def filter_and_display_csv(csv_file_path, username):
    # Leer el archivo CSV
    df = pd.read_csv(csv_file_path)
    
    # Filtrar los registros que contienen el nombre de usuario
    filtered_df = df[df['username_column_name'].str.contains(username, case=False, na=False)]
    
    # Mostrar los resultados en una tabla
    print(tabulate(filtered_df, headers='keys', tablefmt='pretty'))

if __name__ == "__main__":
    csv_file_path = "/al/archivo.csv"  # Reemplaza esto con la ruta a tu archivo CSV
    username = input("Ingresa el nombre de usuario: ")
    
    filter_and_display_csv(csv_file_path, username)
