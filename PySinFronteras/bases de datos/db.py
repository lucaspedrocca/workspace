import mysql.connector

midb = mysql.connector.connect(
    host = 'localhost',
    user='root',
    password='10Caracteres.',
    database='prueba'
)

cursor = midb.cursor()

#** listar datos

#* Todos los datos
cursor.execute('SELECT * FROM usuario')
resultado = cursor.fetchall()
print(resultado)


#* Filtrando los datos con limit
cursor.execute('SELECT * FROM usuario limit 1')
resultado = cursor.fetchall()
print(resultado)


#** Ver definiciones de tablas
# cursor.execute('show create table usuario')

#** Insertar datos

# sql = 'INSERT INTO usuario (email, username, edad) VALUES (%s, %s, %s)'
# values = ('micorreo@correo.com.ar', 'nombre usuario', 25)

# cursor.execute(sql, values)

# midb.commit()

# print(cursor.rowcount)


#** Actualizar datos

# sql = 'update usuario set email = %s where id = %s'

# values = ('micorreo@correo.com', 4)
# cursor.execute(sql, values)

# midb.commit()

# print(cursor.rowcount)

#** Eliminar registros

# sql = 'delete from Usuario where id = %s'
# values = (4, )
# cursor.execute(sql, values)
# midb.commit()
