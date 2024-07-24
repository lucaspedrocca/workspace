# Importando Bibliotecas

import requests
from bs4 import BeautifulSoup

# Definimos la URL de la pagina a scrapear y obtenemos la respuesta

url = "https://www.mercadolibre.com.ar"

response = requests.get(url)

if response.status_code == 200:
    soup = BeautifulSoup(response.content, "html.parser")
    pass
else:
    print(f"Error {response.status_code} al obtener la pagina {url}")

product_lis = soup.find_all("li", class_="ui-search-layout__item shops__layout-item")

for product_li in product_lis:
    # Aqui realizamos el scraping de los precios
    pass
    product_name = product_li.find("h2", class_="ui-search-item__title").textstrip()
    product_price = product_li.find("span", class_="andes-money-amount__fraction").textstrip()

    print(f"Producto: {product_name} - Precio: {product_price}")