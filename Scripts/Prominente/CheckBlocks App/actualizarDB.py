import os
import glob
import pandas as pd
import sqlite3
from tqdm import tqdm  # Biblioteca para la barra de progreso

# Función para obtener las rutas de los archivos de logs desde los directorios proporcionados
def get_log_paths(directories):
    log_paths = []
    for directory in directories:
        log_paths.extend(glob.glob(os.path.join(directory, '*.log')))
    return log_paths

# Directorios donde se encuentran los archivos de logs
directories = [
    r'\\mtvcas03.metrovias.com.ar\c$\inetpub\logs\LogFiles\W3SVC1',
    r'\\mtvcas03.metrovias.com.ar\c$\inetpub\logs\LogFiles\W3SVC2',
    r'\\promisrv001.prominente.com.ar\c$\inetpub\logs\LogFiles\W3SVC1',
    r'\\promisrv001.prominente.com.ar\c$\inetpub\logs\LogFiles\W3SVC2',
    r'\\promiexchmbx10.prominente.com.ar\c$\inetpub\logs\LogFiles\W3SVC1',
    r'\\promiexchmbx10.prominente.com.ar\c$\inetpub\logs\LogFiles\W3SVC2'
]

# Obtener todas las rutas de los archivos de logs
log_paths = get_log_paths(directories)

# Función para crear las tablas necesarias si no existen
def create_tables(conn):
    cursor = conn.cursor()
    cursor.execute('''
        CREATE TABLE IF NOT EXISTS logs (
            date TEXT,
            time TEXT,
            s_ip TEXT,
            cs_method TEXT,
            cs_uri_stem TEXT,
            cs_uri_query TEXT,
            s_port INTEGER,
            cs_username TEXT,
            c_ip TEXT,
            cs_user_agent TEXT,
            cs_referer TEXT,
            sc_status INTEGER,
            sc_substatus INTEGER,
            sc_win32_status INTEGER,
            time_taken INTEGER
        )
    ''')
    cursor.execute('''
        CREATE TABLE IF NOT EXISTS processed_files (
            file_path TEXT PRIMARY KEY
        )
    ''')
    conn.commit()

# Función para verificar si un archivo ya ha sido procesado
def is_file_processed(file_path, conn):
    cursor = conn.cursor()
    cursor.execute('SELECT 1 FROM processed_files WHERE file_path = ?', (file_path,))
    return cursor.fetchone() is not None

# Función para marcar un archivo como procesado
def mark_file_as_processed(file_path, conn):
    cursor = conn.cursor()
    cursor.execute('INSERT INTO processed_files (file_path) VALUES (?)', (file_path,))
    conn.commit()

# Función para parsear y guardar los logs en una base de datos SQL
def parse_and_store_log(log_path, conn):
    print(f"Processing {log_path}...")  # Feedback en consola
    # Ajuste en el formato del archivo
    try:
        df = pd.read_csv(log_path, sep=' ', comment='#', header=None)
        df.columns = ['date', 'time', 's_ip', 'cs_method', 'cs_uri_stem', 'cs_uri_query', 's_port', 
                      'cs_username', 'c_ip', 'cs_user_agent', 'cs_referer', 'sc_status', 
                      'sc_substatus', 'sc_win32_status', 'time_taken']
        df.to_sql('logs', conn, if_exists='append', index=False)
        mark_file_as_processed(log_path, conn)
        print(f"Finished processing {log_path}.")  # Feedback en consola
    except Exception as e:
        print(f"Error processing {log_path}: {e}")  # Mensaje de error en consola

# Crear o conectar a la base de datos SQLite
conn = sqlite3.connect('logs.db')

# Crear las tablas necesarias si no existen
create_tables(conn)

# Procesar y guardar solo los archivos nuevos en la base de datos con barra de progreso
print("Starting log processing...")
for log_path in tqdm(log_paths, desc="Processing logs", unit="file"):
    if not is_file_processed(log_path, conn):
        parse_and_store_log(log_path, conn)
    else:
        print(f"File {log_path} already processed.")  # Feedback en consola

# Cerrar la conexión a la base de datos
conn.close()
print("Log processing completed.")

# Crear una aplicación Flask para exponer una API que permita consultas SQL
from flask import Flask, request, jsonify

app = Flask(__name__)

# Función para ejecutar una consulta SQL y obtener los resultados
def execute_sql_query(query):
    conn = sqlite3.connect('logs.db')
    cursor = conn.cursor()
    cursor.execute(query)
    rows = cursor.fetchall()
    conn.close()
    return rows

# Ruta de la API para realizar consultas SQL
@app.route('/query', methods=['GET'])
def query():
    query = request.args.get('query')
    result = execute_sql_query(query)
    return jsonify(result)

# Ejecutar la aplicación Flask
if __name__ == '__main__':
    app.run(debug=True)
