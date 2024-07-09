-- Proyecto base de datos
-- Lucas Pedrocca 44694187


-- Definición de tipos
type Fecha = (Int, Int, Int)
type Ingresos = (Fecha, Float, Float, Float, Float, Float)
type Base = [Ingresos]

-- Encabezado: "indice_tiempo", "ingresos_ventas_musica_streaming", "ingresos_ventas_musica_descargas", "ingresos_ventas_musica_formato_fisico", "ingresos_derechos_comunicacion_publica", "ingresos_contratos_sincronizacion"


base :: Base
base = [((2001,01,01), 0, 0, 23.0, 0.6, 0),
        ((2002,01,01), 0, 0, 21.3, 0.7, 0),
        ((2003,01,01), 0, 0, 19.7, 0.8, 0),
        ((2004,01,01), 0, 0.4, 19.1, 0.9, 0),
        ((2005,01,01), 0.1, 1.0, 17.9, 0.9, 0),
        ((2006,01,01), 0.1, 2.0, 16.2, 1.0, 0),
        ((2007,01,01), 0.2, 2.7, 14.0, 1.2, 0),
        ((2008,01,01), 0.3, 3.4, 11.9, 1.2, 0),
        ((2009,01,01), 0.4, 3.7, 10.3, 1.3, 0),
        ((2010,01,01), 0.4, 3.9, 8.9, 1.4, 0.3),
        ((2011,01,01), 0.6, 4.2, 8.2, 1.4, 0.3),
        ((2012,01,01), 1.0, 4.4, 7.6, 1.5, 0.3),
        ((2013,01,01), 1.4, 4.3, 6.7, 1.7, 0.3),
        ((2014,01,01), 1.9, 4.0, 6.0, 1.8, 0.3),
        ((2015,01,01), 2.8, 3.7, 5.7, 1.9, 0.4),
        ((2016,01,01), 4.6, 3.2, 5.5, 2.2, 0.4),
        ((2017,01,01), 6.5, 2.6, 5.2, 2.3, 0.4),
        ((2018,01,01), 9.2, 1.7, 4.7, 2.6, 0.5),
        ((2019,01,01), 11.2, 1.5, 4.4, 2.5, 0.5),
        ((2020,01,01), 13.4, 1.2, 4.2, 2.3, 0.4)]

-- Todos los ingresos estan expresados en mil millones de dolares.

-- Funciones:

-- Función que devuelve el valor de un segmento.
-- (Función extra para facilitar las demás funciones.)

valorSegmento :: Ingresos -> String -> Float
valorSegmento (fecha, st, de, fi, cp, cs) segmento
        | segmento == "streaming"= st
        | segmento == "descargas"= de
        | segmento == "fisico"= fi
        | segmento == "publica"= cp
        | segmento == "sincronizacion" = cs
valorSegmento ingresos _ = 0

-- Función que dada la base de datos y el nombre de uno de los segmentos posibles, devuelve los ingresos totales (2001 a 2020) de una determinado segmento.
-- Posibles segmentos: (streming, descargas, fisico, sincronización).
--Ejemplo: ingresosTotalesPorSegmento "sincronizacion" = 4.1
-- Filter Fold

ingresosTotalesPorSegmento :: Base -> String -> Float
ingresosTotalesPorSegmento [] segmento = 0
ingresosTotalesPorSegmento (x:xs) segmento = (valorSegmento x segmento) + (ingresosTotalesPorSegmento xs segmento)


-- Función que dada la base de datos y un año, devuelve todos los ingresos del año seleccionado.
-- Ejemplo: ingresosPorAño base 2012 = (2012,1.0,4.4,7.6,1.5,0.3)

ingresosPorAño :: Base -> Int -> (Int, Float, Float, Float, Float, Float)
ingresosPorAño [] año = (año, 0, 0, 0, 0, 0)
ingresosPorAño (((año1,mes,dia), st, de, fi, cp, cs):xs) año
        | año < 2001 || año > 2020 = (año, 0, 0, 0, 0, 0)
        | año1 /= año = ingresosPorAño xs año
        | año1 == año = (año1, st, de, fi, cp, cs)

-- Función que dada la base de datos, devuelve el porcentaje que representa cada segmento en todos los años.

porcentajePorAño :: Base -> [(Int, Float, Float, Float, Float, Float)]
porcentajePorAño [] = []
porcentajePorAño (((año1,mes,dia), st, de, fi, cp, cs):xs) = 
        (año1, (st * 100 / (st+de+fi+cp+cs)), (de * 100 / (st+de+fi+cp+cs)),(fi * 100 / (st+de+fi+cp+cs)),
        (cp * 100 / (st+de+fi+cp+cs)),(cs * 100 / (st+de+fi+cp+cs))) : (porcentajePorAño xs)

-- Función que dada una base de datos, un segmento, un año y valor del dolar blue del dia te devuelve el ingreso del segmento y año especificado expresado en pesos.
-- Ejemplo: ingresosEnPesos base "streaming" 2015 285 = "798.0 mil millones pesos de argentinos."

ingresosEnPesos :: Base -> String -> Int -> Float -> String
ingresosEnPesos [] segmento año dolar = "Ingrese una bases de datos con contenido."
ingresosEnPesos (((año1,mes,dia), st, de, fi, cp, cs):xs) segmento año dolar
        | año < 2001 || año > 2020 = "Ingrese un año dentro del rango: (2001 - 2020)."        
        | dolar <= 0 = "Valor de dolar no valido. Ingrese un numero positivo."        
        |año1 == año = show((valorSegmento((año1,mes,dia), st, de, fi, cp, cs) segmento * dolar)) ++ " mil millones de pesos argentinos."
        |otherwise = (ingresosEnPesos xs segmento año dolar)

