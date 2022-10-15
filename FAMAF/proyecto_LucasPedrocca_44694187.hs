-- Proyecto base de datos
-- Lucas Pedrocca 44694187


-- Definición de tipos
type Fecha = (Int, Int, Int)
type IngresosPorAnio = (Fecha, Float, Float, Float, Float, Float)
type Base = [IngresosPorAnio]

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

-- Funciones:
segmentos :: [String]
segmentos = ["streaming","descargas", "fisico", "publica", "sincronizacion"]

-- Función que devuelve el valor de un segmento.

devolverSegmento :: IngresosPorAnio -> String -> Float
devolverSegmento (fecha, st, de, fi, cp, cs) segmento
        | segmento == "streaming"= st
        | segmento == "descargas"= de
        | segmento == "fisico"= fi
        | segmento == "publica"= cp
        | segmento == "sincronizacion" = cs
devolverSegmento ingresos _ = 0

-- Función que devuelve los ingresos totales (2001 a 2020) de una determinado segmento (streming, descargas, fisico, sincronización).

ingPorSegTot :: Base -> String -> Float
ingPorSegTot [] segmento = 0
ingPorSegTot (x:xs) segmento = (devolverSegmento x segmento) + (ingPorSegTot xs segmento)


-- Función que devuelve todos los ingresos de un determinado año.

ingPorAnio :: Base -> Int -> (Int, Float, Float, Float, Float, Float)
ingPorAnio [] anio1 = (anio1, 0, 0, 0, 0, 0)
ingPorAnio (((anio,mes,dia), st, de, fi, cp, cs):xs) anio1
        | anio1 < 2001 || anio1 > 2020 = (anio1, 0, 0, 0, 0, 0)
        | anio /= anio1 = ingPorAnio xs anio1
        | anio == anio1 = (anio, st, de, fi, cp, cs)


-- Función que dada la base de datos de los ingresos, devuelve el porcentaje que representa cada segmento en todos los años.

porcPorAnio :: Base -> [(Int, Float, Float, Float, Float, Float)]
porcPorAnio [] = []
porcPorAnio (((anio,mes,dia), st, de, fi, cp, cs):xs) = 
        [(anio, (st * 100 / (st+de+fi+cp+cs)), (de * 100 / (st+de+fi+cp+cs)),(fi * 100 / (st+de+fi+cp+cs)),
        (cp * 100 / (st+de+fi+cp+cs)),(cs * 100 / (st+de+fi+cp+cs)))] ++ (porcPorAnio xs)
