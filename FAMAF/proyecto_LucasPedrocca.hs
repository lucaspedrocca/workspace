type Cine = (String, String, String, String, String, String, Int, Int, String)
type Base = [Cine]

-- Encabezado: "nombre", "provincia", "departamento", "localidad", "direccion", "web", "pantallas", "butacas", "tipo_de_gestion"

base :: Base
base = [("Showcase Norte", "Buenos Aires", "Vicente López", "Munro", "E. Echeverria 3750", "https://www.todoshowcase.com/", 17, 4214, "Privada"),
        ("Hoyts Unicenter", "Buenos Aires", "San Isidro", "Martínez", "Parana 3745", "https://www.cinemarkhoyts.com.ar/", 16, 3427, "Privada"),
        ("Cinepolis Avellaneda", "Buenos Aires", "Avellaneda", "Avellaneda", "Autopista Bs. As. - La Plata Km 6", "https://www.cinepolis.com.ar/", 16, 3485, "Privada"),
        ("Showcase Cinemas Haedo", "Buenos Aires", "Morón", "Haedo", "Dr. Luis Guemes 393", "https://www.todoshowcase.com/", 14, 3890, "Privada"),
        ("Showcase Rosario", "Santa Fe", "Rosario", "Rosario", "Junin 501", "https://www.todoshowcase.com/", 14, 3391, "Privada"),
        ("Cinepolis Rosario", "Santa Fe", "Rosario", "Rosario", "Eva Peron 5856", "https://www.villagecines.com/", 13, 3458, "Privada"),
        ("Hoyts General Cinema Quilmes", "Buenos Aires", "Quilmes", "Quilmes", "Av. Calchaqui 3950", "https://www.cinemarkhoyts.com.ar/", 12, 2580, "Privada"),
        ("Hoyts Abasto", "Ciudad Autónoma de Buenos Aires", "Ciudad Autonoma de Buenos Aires", "Ciudad Autónoma de Buenos Aires", "Aguero 665", "https://www.cinemarkhoyts.com.ar/", 12, 3021, "Privada"),
        ("Showcase Cordoba", "Córdoba", "Capital", "Córdoba", "J.A. Goyechea 2851", "https://www.todoshowcase.com/", 12, 2386, "Privada"),
        ("Hoyts Moreno", "Buenos Aires", "Moreno", "Moreno", "Av. Victorica 1128", "https://www.cinemarkhoyts.com.ar/", 10, 2476, "Privada"),
        ("Cinemark Malvinas Argentinas", "Buenos Aires", "Malvinas Argentinas", "Los Polvorines", "Av. Illia 3770", "https://www.cinemarkhoyts.com.ar", 10, 2414, "Privada"),
        ("Cinema Adrogue", "Buenos Aires", "Almirante Brown", "Adrogué", "Hipolito Yrigoyen 13200", "https://www.cinemaadrogue.com/", 10, 2505, "Privada"),
        ("Showcase Cinemas Belgrano", "Ciudad Autónoma de Buenos Aires", "Ciudad Autonoma de Buenos Aires", "Ciudad Autónoma de Buenos Aires", "Monroe 1655", "https://www.todoshowcase.com/", 10, 2082, "Privada"),
        ("Hoyts Panamericana", "Ciudad Autónoma de Buenos Aires", "Ciudad Autonoma de Buenos Aires", "Ciudad Autónoma de Buenos Aires", "Melian 4880", "https://www.cinemarkhoyts.com.ar/", 10, 1918, "Privada"),
        ("Cinepolis Recoleta", "Ciudad Autónoma de Buenos Aires", "Ciudad Autonoma de Buenos Aires", "Ciudad Autónoma de Buenos Aires", "Vicente Lopez 2050", "https://www.villagecines.com/", 10, 1776, "Privada"),
        ("Cinemark Palermo", "Ciudad Autónoma de Buenos Aires", "Ciudad Autonoma de Buenos Aires", "Ciudad Autónoma de Buenos Aires", "Beruti 3399", "https://www.cinemarkhoyts.com.ar", 10, 1738, "Privada"),
        ("Cinepolis Mendoza", "Mendoza", "Capital", "Mendoza", "Av. Acceso Este 3280 Lateral Norte", "https://www.villagecines.com/", 10, 2344, "Privada"),
        ("Cinemark Palmares", "Mendoza", "Godoy Cruz", "Godoy Cruz", "Ruta Panamericana 2650", "https://www.cinemarkhoyts.com.ar", 10, 1681, "Privada"),
        ("Palmas Multiplex", "Buenos Aires", "Pilar", "Pilar", "Las Magnolias 754", "https://www.multiplex.com.ar/", 9, 1407, "Privada"),
        ("Hoyts Temperley", "Buenos Aires", "Lomas de Zamora", "Temperley", "Av. Hipolito Irigoyen 10699", "https://www.cinemarkhoyts.com.ar/", 9, 2382, "Privada"),
        ("Cinepolis Pilar", "Buenos Aires", "Pilar", "Pilar", "Panamericana Ac. Norte Km 50", "https://www.villagecines.com/", 9, 2675, "Privada"),
        ("Atlas Caballito", "Ciudad Autónoma de Buenos Aires", "Ciudad Autonoma de Buenos Aires", "Ciudad Autónoma de Buenos Aires", "Av. Rivadavia 5071", "https://www.villagecines.com/", 9, 1769, "Privada"),
        ("Monumental Rosario", "Santa Fe", "Rosario", "Rosario", "San Martin 993", "https://www.multiplex.com.ar/", 9, 1471, "Privada"),
        ("Hoyts Rosario", "Santa Fe", "Rosario", "Rosario", "Nansen 323", "https://www.cinemarkhoyts.com.ar/", 9, 1911, "Privada"),
        ("Showcase Quilmes", "Buenos Aires", "Quilmes", "Quilmes", "Olavarria 180", "https://www.todoshowcase.com/", 8, 1730, "Privada"),
        ("Hoyts Moron", "Buenos Aires", "Morón", "Morón", "Juan Manuel De Rosas 658", "https://www.cinemarkhoyts.com.ar/", 8, 1865, "Privada"),
        ("Coto Lanus", "Buenos Aires", "Lanús", "Lanús", "Warnes 2450", "https://www.zonacines.com.ar", 8, 2037, "Privada"),
        ("Cinemark Tortuguitas", "Buenos Aires", "Malvinas Argentinas", "Tortuguitas", "Constituyentes Y Au. Panamericana Km 36.5", "https://www.cinemarkhoyts.com.ar", 8, 1905, "Privada"),
        ("Cinemark Puerto Madero", "Ciudad Autónoma de Buenos Aires", "Ciudad Autonoma de Buenos Aires", "Ciudad Autónoma de Buenos Aires", "Av. Alicia M De Justo 1920", "https://www.cinemarkhoyts.com.ar", 8, 1379, "Privada"),
        ("Cinema Devoto", "Ciudad Autónoma de Buenos Aires", "Ciudad Autonoma de Buenos Aires", "Ciudad Autónoma de Buenos Aires", "Jose Pedro Varela 4866", "https://cinemadevoto.com.ar/", 8, 1908, "Privada"),
        ("Belgrano Multiplex", "Ciudad Autónoma de Buenos Aires", "Ciudad Autonoma de Buenos Aires", "Ciudad Autónoma de Buenos Aires", "Vuelta De Obligado 2238", "https://www.multiplex.com.ar/", 8, 2314, "Privada"),
        ("Hoyts Patio Olmos", "Córdoba", "Capital", "Córdoba", "Av. Velez Sarsfield 361", "https://www.cinemarkhoyts.com.ar/", 8, 986, "Privada"),
        ("Cines Gran Rex", "Córdoba", "Capital", "Córdoba", "Av. Gral. Paz 174", "http://cinesgranrex.com.ar/", 8, 1201, "Privada"),
        ("Hoyts Nuevo Noa", "Salta", "Capital", "Salta", "Virrey Toledo 702", "https://www.cinemarkhoyts.com.ar/", 8, 1362, "Privada"),
        ("Cinemacenter San Juan", "San Juan", "Capital", "San Juan", "Av. Circunvalacion Y Scalabrini Ortiz", "http://www.cinemacenter.com.ar/", 8, 1803, "Privada"),
        ("Cinemacenter Bahia Blanca", "Buenos Aires", "Bahía Blanca", "Bahía Blanca", "Av. Sarmiento 2153", "http://www.cinemacenter.com.ar/", 7, 1501, "Privada"),
        ("Cinema San Martin", "Buenos Aires", "La Plata", "La Plata", "Calle 7 923", "http://www.cinemalaplata.com", 7, 2184, "Privada"),
        ("Monumental Lavalle", "Ciudad Autónoma de Buenos Aires", "Ciudad Autonoma de Buenos Aires", "Ciudad Autónoma de Buenos Aires", "Lavalle 780", "https://www.multiplex.com.ar/", 7, 1270, "Privada"),
        ("Dinosaurio Mall Ruta 20", "Córdoba", "Capital", "Córdoba", "Av. Fuerza Aerea 1700", "https://www.cinesdinomall.com.ar/Inicio", 7, 1385, "Privada"),
        ("Dinosaurio Mall Alto Verde", "Córdoba", "Capital", "Córdoba", "Rodriguez Del Busto 4086", "https://www.cinesdinomall.com.ar/Inicio", 7, 1193, "Privada"),
        ("Cinepolis Neuquen", "Neuquén", "Confluencia", "Neuquén", "Av. Antartida Argentina 1111", "https://www.villagecines.com/", 7, 1894, "Privada"),
        ("Cinemacenter San Luis", "San Luis", "La Capital", "San Luis", "J. A. Roca 260", "http://www.cinemacenter.com.ar/", 7, 1951, "Privada"),
        ("Cinemark Santa Fe", "Santa Fe", "La Capital", "Santa Fe", "Dique 1 Puerto Santa Fe", "https://www.cinemarkhoyts.com.ar", 7, 1527, "Privada"),
        ("CPM Catan", "Buenos Aires", "La Matanza", "Gonzalez Catán", "Ruta 3 Km 29 Bj Manuel De Rosas 14457", "https://cpmcines.com", 6, 1114, "Privada"),
        ("Cines Paseo Aldrey", "Buenos Aires", "General Pueyrredon", "Mar del Plata", "Alberti 1610", "http://www.cinemacenter.com.ar/", 6, 1121, "Privada"),
        ("Cinepolis Merlo", "Buenos Aires", "Merlo", "San Antonio de Padua", "Av. Juan Domingo Peron 24056", "https://www.villagecines.com/", 6, 1315, "Privada"),
        ("Cinepolis Luján", "Buenos Aires", "Luján", "Luján", "R. Payró y Mario Bravo", "https://www.cinepolis.com.ar/", 6, 1182, "Privada"),
        ("Cinemark Soleil", "Buenos Aires", "San Isidro", "Boulogne", "Bernardo De Yrigoyen 2647", "https://www.cinemarkhoyts.com.ar", 6, 1895, "Privada"),
        ("Cinemark San Justo", "Buenos Aires", "La Matanza", "San Justo", "Av. Juan Manuel De Rosas 3990", "https://www.cinemarkhoyts.com.ar", 6, 1843, "Privada"),
        ("Cinemark Alto Avellaneda", "Buenos Aires", "Avellaneda", "Avellaneda", "Guemes 897", "https://www.cinemarkhoyts.com.ar/", 6, 1275, "Privada"),
        ("Cinemacenter Florencio Varela", "Buenos Aires", "Florencio Varela", "Florencio Varela", "Av. San Martin 554", "http://www.cinemacenter.com.ar/", 6, 1327, "Privada"),
        ("Cinema Rocha", "Buenos Aires", "La Plata", "La Plata", "Calle 49 621", "http://www.cinemalaplata.com", 6, 1613, "Privada"),
        ("Canning Multiplex", "Buenos Aires", "Ezeiza", "Ezeiza", "Formosa 653", "https://www.multiplex.com.ar/", 6, 1132, "Privada"),
        ("Cinemark Caballito", "Ciudad Autónoma de Buenos Aires", "Ciudad Autonoma de Buenos Aires", "Ciudad Autónoma de Buenos Aires", "Av. La Plata 96", "https://www.cinemarkhoyts.com.ar", 6, 898, "Privada"),
        ("Sunstar Cordoba", "Córdoba", "Capital", "Villa Rivera Indarte", "Ricardo Rojas 9200", "http://www.cinesunstar.com/", 6, 1398, "Privada"),
        ("Hoyts Nuevo Centro Cordoba", "Córdoba", "Capital", "Córdoba", "Duarte Quiros 1400", "https://www.cinemarkhoyts.com.ar/", 6, 960, "Privada"),
        ("Cinemacenter Mendoza", "Mendoza", "Capital", "Mendoza", "Las Cañas 1833", "http://www.cinemacenter.com.ar/", 6, 1361, "Privada"),
        ("Cinemark Neuquén", "Neuquén", "Confluencia", "Neuquén", "Av. Dr. Ramón 355", "https://www.cinemarkhoyts.com.ar/", 6, 1113, "Privada"),
        ("Play Cinema San Juan", "San Juan", "Capital", "San Juan", "Av. Libertador 1826 (Oeste)", "http://www.playcinema.net/", 6, 1071, "Privada"),
        ("Sunstar Tucuman", "Tucumán", "Yerba Buena", "Yerba Buena", "Av. Fermin Carriola 42", "http://www.cinesunstar.com/", 6, 1295, "Privada"),
        ("Atlas Nordelta", "Buenos Aires", "Tigre", "Rincón de Milberg", "Av. De Los Lagos 7010", "http://www.nordeltacc.com.ar/", 5, 969, "Privada"),
        ("Cines Del Solar", "Catamarca", "Capital", "Catamarca", "Intendente Mamerto Medina 220", "http://www.cinemacenter.com.ar/", 5, 743, "Privada"),
        ("Cinemacenter Catamarca", "Catamarca", "Capital", "Catamarca", "Av. Guemes 850", "http://www.cinemacenter.com.ar/", 5, 914, "Privada"),
        ("Los Cines De La Costa - Sarmiento", "Chaco", "San Fernando", "Resistencia", "Av. Sarmiento 2600", "http://resistencia.loscinesdelacosta.com.ar/", 5, 820, "Privada"),
        ("Cinemacenter Avalos", "Chaco", "San Fernando", "Resistencia", "Av. Avalos y Av. Lavalle", "http://www.cinemacenter.com.ar/", 5, 792, "Privada"),
        ("Atlas Rivera Indarte", "Ciudad Autónoma de Buenos Aires", "Ciudad Autonoma de Buenos Aires", "Ciudad Autónoma de Buenos Aires", "Rivera Indarte 44", "cineatlasweb.com.ar", 5, 1263, "Privada"),
        ("Arte Multiplex", "Ciudad Autónoma de Buenos Aires", "Ciudad Autonoma de Buenos Aires", "Ciudad Autónoma de Buenos Aires", "Av. Cabildo 2829", "https://www.multiplex.com.ar/", 5, 792, "Privada"),
        ("Cinemacenter Corrientes", "Corrientes", "Capital", "Corrientes", "Av. Pedro Ferre y Chacabuco", "http://www.cinemacenter.com.ar/", 5, 1140, "Privada"),
        ("Cinepolis Arena Maipu", "Mendoza", "Maipu", "Maipú", "Emilio Civit Y Maza", "https://www.villagecines.com/", 5, 949, "Privada"),
        ("Cinemark Salta", "Salta", "Capital", "Salta", "Av. Monseñor Tavella 4400", "https://www.cinemarkhoyts.com.ar", 5, 897, "Privada"),
        ("CPM Espacio San Juan", "San Juan", "Capital", "San Juan", "Av. Jose Ignacio De La Roza Oeste 806", "https://cpmcines.com/", 5, 849, "Privada"),
        ("Sunstar Santiago del Estero", "Santiago del Estero", "Capital", "Santiago del Estero", "Av. Rivadavia Y Ejercito Argentino", "http://www.cinesunstar.com/", 5, 1585, "Privada"),
        ("Solar del Cerro", "Tucumán", "Yerba Buena", "Yerba Buena", "Av. Aconquija 1336", "http://solardelcerro.com", 5, 750, "Privada"),
        ("Cinemacenter Tucuman", "Tucumán", "Capital", "San Miguel de Tucumán", "Av. Nestor Kirchner(Ex Av. Roca) 3450", "http://www.cinemacenter.com.ar/", 5, 1051, "Privada"),
        ("Paseo Diagonal", "Buenos Aires", "General Pueyrredon", "Mar del Plata", "Belgrano Y Diag. Pueyrredon 3058", "", 4, 687, "Privada"),
        ("CPM Paseo Adrogue", "Buenos Aires", "Almirante Brown", "Adrogué", "Segui 699", "https://cpmcines.com/", 4, 710, "Privada"),
        ("Cinemacenter Tandil", "Buenos Aires", "Tandil", "Tandil", "Panama 351", "http://www.cinemacenter.com.ar/", 4, 758, "Privada"),
        ("Cinema Paradiso", "Buenos Aires", "La Plata", "La Plata", "Calle 46 780", "http://www.cinemalaplata.com", 4, 603, "Privada"),
        ("Ambassador", "Buenos Aires", "General Pueyrredon", "Mar del Plata", "Cordoba 1673", "http://www.cinemacenter.com.ar/", 4, 947, "Privada"),
        ("Atlas Liniers", "Ciudad Autónoma de Buenos Aires", "Ciudad Autonoma de Buenos Aires", "Ciudad Autónoma de Buenos Aires", "Ramón L. Falcón 7115", "www.atlascines.com", 4, 460, "Privada"),
        ("Angeba", "Ciudad Autónoma de Buenos Aires", "Ciudad Autonoma de Buenos Aires", "Ciudad Autónoma de Buenos Aires", "Lavalle 750", "", 4, 100, "Privada"),
        ("Sudcinemas", "Córdoba", "General San Martin", "Villa María", "Ruta Nacional 158 Km 155,5", "http://sudcinemas.com.ar/", 4, 800, "Privada"),
        ("Holiday Cines", "Córdoba", "Punilla", "Villa Carlos Paz", "9 De julio 53", "https://www.holidaycinemas.com.ar/", 4, 1000, "Privada"),
        ("Complejo Cinerama", "Córdoba", "Capital", "Córdoba", "Av. Colon 345", "https://www.cinerama.com.ar/", 4, 755, "Privada"),
        ("Cines Del Paseo", "Córdoba", "Rio Cuarto", "Río Cuarto", "Av. Mugnaini Y Sobremonte", "http://cba.gov.ar", 4, 955, "Privada"),
        ("De La Costa Shopping", "Corrientes", "Capital", "Corrientes", "Av. Centenario 3535", "http://www.loscinesdelacosta.com.ar/", 4, 562, "Privada"),
        ("Cinemacenter La Rioja", "La Rioja", "Capital", "La Rioja", "Av. Abel Bazan Y Bustos 710", "http://www.cinemacenter.com.ar/", 4, 769, "Privada"),
        ("Sunstar Posadas", "Misiones", "Capital", "Posadas", "Bolivar 1979", "http://www.cinesunstar.com/", 4, 559, "Privada"),
        ("Las Tipas Rafaela", "Santa Fe", "Castellanos", "Rafaela", "C. Conscripto Zurbriggen 865", "www.lastipasrafaela.com.ar/", 4, 920, "Privada"),
        ("Cines Del Centro", "Santa Fe", "Rosario", "Rosario", "Rioja 1660", "", 4, 659, "Privada"),
        ("Victor Show Cinemas", "Buenos Aires", "Tres de Febrero", "Villa Bosch", "El Payador 5539", "https://www.facebook.com/VictorShowCinemas/", 3, 413, "Privada"),
        ("Tu Cine Junin", "Buenos Aires", "Junín", "Junín", "Jorge Newbery 263", "http://www.tucine.com.ar", 3, 453, "Privada"),
        ("Teatro Auditorium", "Buenos Aires", "General Pueyrredon", "Mar del Plata", "Bv. Maritimo 2280", "http://programacionauditorium.blogspot.com/", 3, 1563, "Pública"),
        ("Cinema City", "Buenos Aires", "La Plata", "La Plata", "Calle 50 723", "http://www.cinemalaplata.com/", 3, 640, "Privada"),
        ("Cinema 8", "Buenos Aires", "La Plata", "La Plata", "Calle 8 981", "http://www.cinemalaplata.com/", 3, 1084, "Privada"),
        ("Cine Vision", "Buenos Aires", "Bahía Blanca", "Bahía Blanca", "Belgrano 153", "https://www.cinesdelcentrobb.com.ar/", 3, 907, "Privada"),
        ("Cine Ocean", "Buenos Aires", "Necochea", "Necochea", "Calle 83 350", "https://www.cinesocean.com.ar/", 3, 1620, "Privada"),
        ("Atlantica Arenas", "Buenos Aires", "La Costa", "San Bernardo", "Chiozza 1776", "", 3, 1358, "Privada"),
        ("Cinemacenter Resistencia", "Chaco", "San Fernando", "Resistencia", "Av. Dr. Sabin y Av. Nicolas Avellaneda", "http://www.cinemacenter.com.ar/", 3, 690, "Privada"),
        ("Gaumont", "Ciudad Autónoma de Buenos Aires", "Ciudad Autonoma de Buenos Aires", "Ciudad Autónoma de Buenos Aires", "Av. Rivadavia 1635", "http://www.incaa.gov.ar/", 3, 1167, "Pública"),
        ("Atlas Patio Bullrich", "Ciudad Autónoma de Buenos Aires", "Ciudad Autonoma de Buenos Aires", "Ciudad Autónoma de Buenos Aires", "Posadas 1245", "cineatlasweb.com.ar", 3, 585, "Privada"),
        ("Atlas Paseo Alcorta", "Ciudad Autónoma de Buenos Aires", "Ciudad Autonoma de Buenos Aires", "Ciudad Autónoma de Buenos Aires", "Jeronimo Salguero 3172", "cineatlasweb.com.ar", 3, 432, "Privada"),
        ("Showcase Villa Allende", "Córdoba", "Colón", "Villa Allende", "Rio De Janeiro 1725", "https://www.todoshowcase.com/", 3, 563, "Privada"),
        ("Las Tipas San Francisco", "Córdoba", "San Justo", "San Francisco", "Iturraspe 1448", "http://www.nuevocineradar.com.ar/", 3, 620, "Privada"),
        ("Las Tipas Jesus Maria", "Córdoba", "Colón", "Jesús María", "Ruta Nacional 9 Esq. Corrientes", "http://www.cinesmolise.com.ar/", 3, 623, "Privada"),
        ("Cinemacenter Alta Gracia", "Córdoba", "Santa María", "Alta Gracia", "Belgrano 466", "https://www.cinemacenter.com.ar/", 3, 431, "Privada"),
        ("El Pajarito Avenida", "Formosa", "Formosa", "Formosa", "Av. Juan Domingo Peron 757", "https://www.facebook.com/Cines-Avenida-112830095434025/", 3, 619, "Privada"),
        ("Sunstar Bariloche", "Río Negro", "Bariloche", "Bariloche", "Onelli 447", "http://www.cinesunstar.com/", 3, 461, "Privada"),
        ("Cines Fenix", "San Luis", "General Pedernera", "Villa Mercedes", "Pueyrredon 1651", "http://www.cinesfenix.com", 3, 475, "Privada"),
        ("Cine Rio Gallegos", "Santa Cruz", "Guer Aike", "Río Gallegos", "Av. Nestor Kirchner 1142", "http://www.cineriogallegos.com.ar/", 3, 290, "Privada"),
        ("E-Max Cines", "Santa Fe", "Las Colonias", "Esperanza", "Brigadier Lopez 1471", "http://www.e-max.com.ar", 3, 584, "Privada"),
        ("Cinemacenter La Banda", "Santiago del Estero", "Banda", "La Banda", "Aut. Juan D. Peron S/N Parque Industrial", "http://www.cinemacenter.com.ar/", 3, 822, "Privada"),
        ("Sunstar Ushuaia", "Tierra del Fuego", "Ushuaia", "Ushuaia", "Av. Perito Moreno 1460", "http://www.cinesunstar.com/", 3, 561, "Privada"),
        ("Atlas Tucuman", "Tucumán", "Capital", "San Miguel de Tucumán", "Monteagudo 250", "cineatlasweb.com.ar", 3, 797, "Privada")]

-- Proyecciones:

nombre :: Cine -> String
nombre (n,p,dpto,l,d,web,ps,b,tg) = n

pantallas :: Cine -> Int
pantallas (n,p,dpto,l,d,web,ps,b,tg) = ps

provincia :: Cine -> String
provincia (n,p,dpto,l,d,web,ps,b,tg) = p

butacas :: Cine -> Int
butacas (n,p,dpto,l,d,web,ps,b,tg) = b

web :: Cine -> String
web (n,p,dpto,l,d,web,ps,b,tg) = web

gestion :: Cine -> String
gestion (n,p,dpto,l,d,web,ps,b,tg) = tg

-- Funciones adicionales:

direccionCompleta :: Cine -> String
direccionCompleta (n,p,dpto,l,d,web,ps,b,tg) =  p ++ ". " ++ dpto ++ ". " ++ l ++ ". " ++ d ++ ". "

direccionMedia :: Cine -> String
direccionMedia (n,p,dpto,l,d,web,ps,b,tg) = p ++ ". " ++ dpto ++ ". " ++ l ++ ". "

cPublica :: Base -> String -> Int
cPublica [] prov = 0
cPublica (x:xs) prov
        | provincia x == prov && gestion x == "Pública" = 1 + cPublica xs prov
        | provincia x == prov && gestion x /= "Pública" = 0 + cPublica xs prov
        | provincia x /= prov = cPublica xs prov

cPrivada :: Base -> String -> Int
cPrivada [] prov = 0
cPrivada (x:xs) prov
        | provincia x == prov && gestion x == "Privada" = 1 + cPrivada xs prov
        | provincia x == prov && gestion x /= "Privada" = 0 + cPrivada xs prov
        | provincia x /= prov = cPrivada xs prov

-- Funciones:

-- Primera Funcion: Dada una base con cines y butacas y además, un número Z  te devuelve una lista con los cines con más de Z butacas.
-- Ejemplo: butacasZ base 3500 = ["Cine: Showcase Norte. Buenos Aires. Vicente L\243pez. Munro. 4214 butacas.","Cine: Showcase Cinemas Haedo. Buenos Aires. Mor\243n. Haedo. 3890 butacas."]

butacasZ :: Base -> Int ->[String]
butacasZ [] z = []
butacasZ (x:xs) z
        | butacas x >= z = ("Cine: " ++ nombre x ++ ". " ++ direccionMedia x ++ show(butacas x) ++ " butacas." ) : (butacasZ xs z) 
        | butacas x < z = butacasZ xs z 

-- Segunda Funcion: Dada una base de datos con cines y el nombre de una provincia de Argentina te devuelve la cantidad de pantallas que tiene esa provincia.

-- Ejemplo: pantallasProv base "Córdoba" = 82

pantallasProv :: Base -> String -> Int
pantallasProv [] prov = 0
pantallasProv (x:xs) prov
        | provincia x == prov = pantallas x + pantallasProv xs prov
        | provincia x /= prov = pantallasProv xs prov


-- Tercera Funcion: Dada una base de datos con cines y el nombre de una provincia te devuelve una lista de strings con; nombre, dirección y web de cada cine en esa provincia.

-- Ejemplo: cinesProv base "Salta"  = ["Cine: Hoyts Nuevo Noa. Salta. Capital. Salta. Virrey Toledo 702. https://www.cinemarkhoyts.com.ar/.","Cine: Cinemark Salta. Salta. Capital. Salta. Av. Monse\241or Tavella 4400. https://www.cinemarkhoyts.com.ar."]

cinesProv :: Base -> String -> [String]
cinesProv [] prov = []
cinesProv (x:xs) prov
        | provincia x == prov = ("Cine: " ++ nombre x ++ ". " ++ direccionCompleta x ++ web x ++ ".") : (cinesProv xs prov)
        | provincia x /= prov = (cinesProv xs prov)

-- Cuarta Funcion: Dada una base de datos con cines y el nombre de una provincia te devuelve las pantallas de los cines de la provincia en cuestión duplicadas.

-- Ejemplo: duplicarPantallas base "Córdoba" = [24,16,16,14,14,12,12,8,8,8,8,6,6,6,6]

duplicarPantallas :: Base -> String -> [Int]
duplicarPantallas [] prov = []
duplicarPantallas (x:xs) prov
        | provincia x == prov = (pantallas x * 2) : (duplicarPantallas xs prov) 
        | provincia x /= prov = (duplicarPantallas xs prov) 

-- Quinta Función: Dada una base de datos con cines y el nombre de una provincia te devuelve el número de cines con gestión pública y privada.

-- Ejemplo: tipoGestion base "Buenos Aires" = "En Buenos Aires: 40 cines son de gestion privada y 1 cine es de gestion publica."

tipoGestion :: Base -> String -> String
tipoGestion [] prov = "Ingrese una base con contenido."
tipoGestion base prov = "En "++ prov ++": " ++ show(cPrivada base prov) ++ " cines son de gestion privada y " ++ show(cPublica base prov) ++ " cine es de gestion publica."