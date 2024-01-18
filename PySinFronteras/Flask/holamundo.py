from flask import Flask, request, url_for, redirect, abort, render_template
import mysql.connector

mi_db = mysql.connector.connect(
    host="localhost",
    user="root",
    passwd="10Caracteres.",
    database="prueba"
)

cursor = mi_db.cursor(dictionary=True)



app = Flask(__name__)

# Configuración del entorno de desarrollo
app.config['ENV'] = 'development'
app.config['DEBUG'] = True

@app.route('/')
def index():
    return 'Hola Mundo!'


# GET -> Obtener información
# POST -> Crear información
# PUT -> Actualizar información
# DELETE -> Eliminar información

@app.route('/post/<post_id>', methods=['GET', 'POST'])
def lala(post_id):
    if request.method == 'GET':
        return 'El id del post es: ' + post_id
    else:
        return 'Este es otro método y no GET'

# @app.route('/post/<post_id>', methods=['GET'])
# def lala(post_id):
#     return 'El id del post es: ' + post_id


# @app.route('/post/<post_id>', methods=['POST'])
# def lili(post_id):
#     return 'El id del post es: ' + post_id

# Probar metodos desde URL --> curl -X POST http://localhost:5000/post/1

@app.route('/lele', methods=['POST', 'GET'])
def lele():
    cursor.execute("SELECT * FROM Usuario")
    usuarios= cursor.fetchall()
    print(usuarios)
    # abort(403)
    # return redirect(url_for('lala', post_id=2))
    # print(request.form)
    # print(request.form["llave1"])
    # print(request.form["llave2"])
    # return render_template('lele.html')
    # return {
    #     "username": "Lucas",
    #     "email": "lucaspedrocca@gmail.com"
    #     }
    return render_template('lele.html', usuarios=usuarios)



@app.route('/home', methods=['GET'])
def home():
    
    return render_template('home.html', mensaje="Hola Mundo")


@app.route('/crear', methods=['GET', 'POST'])	
def crear():
    if request.method == 'POST':
        username = request.form["username"]
        email = request.form["email"]
        edad = request.form["edad"]
        sql = 'INSERT into Usuario (username, email, edad) values (%s, %s, %s)'
        values = (username, email, edad)
        cursor.execute(sql, values)
        mi_db.commit()

        return redirect(url_for('lele'))

    return render_template('crear.html')

# Inicia la aplicación Flask
if __name__ == '__main__':
    app.run()
