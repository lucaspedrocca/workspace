from selenium import webdriver
from selenium.webdriver.common.proxy import Proxy, ProxyType

def run_firefox_with_proxy(proxy_host, proxy_port):
    # Configura el proxy
    proxy = Proxy()
    proxy.proxy_type = ProxyType.MANUAL
    proxy.http_proxy = f"{proxy_host}:{proxy_port}"
    proxy.ssl_proxy = f"{proxy_host}:{proxy_port}"

    # Configura las opciones del navegador Firefox
    firefox_options = webdriver.FirefoxOptions()
    firefox_options.add_argument('-private')
    firefox_options.add_argument(f"--proxy-server={proxy_host}:{proxy_port}")

    # Inicia el navegador Firefox con las opciones configuradas
    driver = webdriver.Firefox(options=firefox_options)
    return driver

if __name__ == "__main__":
    # Ingresa la configuración del proxy
    proxy_host = "64.79.70.59"
    proxy_port = "80"

    # Ejecuta Firefox con la configuración de proxy especificada
    driver = run_firefox_with_proxy(proxy_host, proxy_port)

    # Abre una página web de ejemplo para verificar la configuración del proxy
    driver.get("https://www.whatismyip.com/es/mi-ip-ubicacion/")

    # Espera un momento para que se cargue la página y luego cierra el navegador
    input("Presiona Enter para cerrar el navegador...")
    driver.quit()


#comentario 