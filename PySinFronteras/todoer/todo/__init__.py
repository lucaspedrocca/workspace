# import os
# from flask import Flask

# app = Flask(__name__)
# # Configuración del entorno de desarrollo
# def create_app():
# 	app = Flask(__name__)
     
# 	app.config.from_mapping(
#         ENV = 'development',
#         DEBUG = True,
# 		SECRET_KEY='mikey',
# 		DATABASE_HOST=os.environ.get('FlASK_DATABASE_HOST'),
# 		DATABASE_PASSWORD=os.environ.get('FLASK_DATABASE_PASSWORD'),
# 		DATABASE_USER=os.environ.get('FLASK_DATABASE_USER'),
# 		DATABASE=os.environ.get('FLASK_DATABASE'), 	
#     )

#     @app.route('/hola')
#         def hola():
#         return 'Hola Mundo!'


# return app