# Importando Bibliotecas

import requests
from bs4 import BeautifulSoup

# Definimos la URL de la pagina a scrapear y obtenemos la respuesta

url = "https://www.mercadolibre.com.ar/ofertas?domain_id=MLA-CELLPHONES&container_id=MLA779505-1#deal_print_id=b5ff3ae0-4adf-11ef-99ec-87708a9dba04&c_id=carouseldynamic-home&c_element_order=undefined&c_campaign=VER-MAS&c_uid=b5ff3ae0-4adf-11ef-99ec-87708a9dba04"

response = requests.get(url)

if response.status_code == 200:
    soup = BeautifulSoup(response.content, "html.parser")
    pass
else:
    print(f"Error {response.status_code} al obtener la pagina {url}")

product_lis = soup.find_all("li", class_="promotion-item")

for product_li in product_lis:
    # Aqui realizamos el scraping de los precios
    # pass
    product_name = product_li.find("p", class_="promotion-item__title").textstrip()
    product_price = product_li.find("span", class_="andes-money-amount__fraction").textstrip()

    print(f"Producto: {product_name} - Precio: {product_price}")