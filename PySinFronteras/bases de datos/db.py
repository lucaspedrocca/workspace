import mysql.connector

midb = mysql.connector.connect(
    host = 'localhost',
    user='root',
    password='10Caracteres.',
    database='pySinFronteras'
)

cursor = midb.cursor() # Objeto quepermite interactuar con la base de datos con lenguaje SQL, gracias al método execute()

# #* listar datos

# #* Todos los datos
# cursor.execute('SELECT * FROM user')
# resultado = cursor.fetchall()
# print(resultado)


# #* Filtrando los datos con limit
# cursor.execute('SELECT * FROM user limit 1')
# resultado = cursor.fetchall()
# print(resultado)


# #* Ver definiciones de tablas
# cursor.execute('show create table user')

#* Insertar datos

sql = 'INSERT INTO user (email, username, edad) VALUES (%s, %s, %s)'
values = ('micorreo@correo.com.ar', 'nombre usuario', 25)

cursor.execute(sql, values)

midb.commit()

print(cursor.rowcount)


#* Actualizar datos

# sql = 'update usuario set email = %s where id = %s'

# values = ('micorreo@correo.com', 4)
# cursor.execute(sql, values)

# midb.commit()

# print(cursor.rowcount)

#* Eliminar registros

# sql = 'delete from Usuario where id = %s'
# values = (4, )
# cursor.execute(sql, values)
# midb.commit()
