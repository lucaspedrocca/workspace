-- Ejercicio 1

esCero :: Int -> Bool
esCero n = n == 0

esPositivo :: Int -> Bool
esPositivo x = x > 0

esVocal :: Char -> Bool
esVocal 'a' = True
esVocal 'e' = True
esVocal 'i' = True
esVocal 'o' = True
esVocal 'u' = True
esVocal _ = False

-- Ejercicio 2

paratodo :: [Bool] -> Bool
paratodo [] = True
paratodo (x:xs) = x && paratodo xs

sumatoria :: [Int] -> Int
sumatoria [] = 0
sumatoria (x:xs) = x + sumatoria xs

productoria :: [Int] -> Int
productoria [] = 1
productoria (x:xs) = x * productoria xs

factorial :: Int -> Int 
factorial 0 = 1
factorial n = n * factorial (n - 1)

promedio :: [Int] -> Int
promedio xs = sumatoria xs `div` length xs

-- Ejercicio 3

pertenece :: Int -> [Int] -> Bool
pertenece _ [] = False
pertenece n (x:xs) = n == x || pertenece n xs

-- Ejercicio 4

paratodo' :: [a] -> (a -> Bool) -> Bool
paratodo' [] _ = True
paratodo' (x:xs) a = a x && paratodo' xs a


existe' :: [a] -> (a -> Bool) -> Bool
existe' [] _ = False
existe' (x:xs) a = a x || existe' xs a


sumatoria' :: [a] -> (a -> Int) -> Int
sumatoria' [] _ = 0
sumatoria' (x:xs) a = a x + sumatoria' xs a

productoria' :: [a] -> (a -> Int) -> Int
productoria' [] _ = 1
productoria' (x:xs) a = a x * productoria' xs a

-- Ejercicio 5

paratodo'' :: [Bool] -> Bool
paratodo'' xs = paratodo' xs id

-- Ejercicio 6

todosPares :: [Int] -> Bool
todosPares xs = paratodo' xs even

hayMultiplo :: Int -> [Int] -> Bool
hayMultiplo n = existe' (\x -> x `mod` n == 0)

sumaCuadrados :: Int -> Int
sumaCuadrados n = sumatoria' [0..n-1] (\x -> x^2)

factorial :: Int -> Int 
factorial n = productoria' [1..n] id

multiplicaPares :: [Int] -> Int
multiplicaPares xs = productoria' (filter even xs) id

-- Ejercicio 7

-- Las funciones map y filter son funciones de orden superior que se utilizan comúnmente en programación funcional.

-- La función map recibe una función y una lista como argumentos y aplica la función a cada elemento de la lista, devolviendo una nueva lista con los resultados. Es decir, transforma una lista de un tipo en otra lista del mismo tipo aplicando una función a cada elemento.

-- La función filter recibe una función booleana y una lista como argumentos y devuelve una nueva lista que contiene solo los elementos de la lista original para los que la función booleana devuelve True. Es decir, filtra los elementos de una lista según una condición booleana.

-- La expresión map succ [1, -4, 6, 2, -8] aplica la función succ (que incrementa en 1 el valor de un número) a cada elemento de la lista [1, -4, 6, 2, -8]. Por lo tanto, la expresión devuelve la lista [2, -3, 7, 3, -7].

-- La expresión filter esPositivo [1, -4, 6, 2, -8] utiliza la función esPositivo definida en el ejercicio 1 para filtrar los elementos de la lista [1, -4, 6, 2, -8] y devolver una nueva lista que contiene solo los elementos positivos. Por lo tanto, la expresión devuelve la lista [1, 6, 2].

-- Ejercicio 8 

-- Usando recursión

duplicar :: [Int] -> [Int]
duplicar [] = []
duplicar (x:xs) = 2*x : duplicar xs


-- Usando la funcion Map

duplicar :: [Int] -> [Int]
duplicar xs = map (\x -> 2*x) xs

-- Ejercicio 9

-- Usando recursión

paresRecursivo :: [Int] -> [Int]
paresRecursivo [] = []
paresRecursivo (x:xs) = if even x then x:paresRecursivo xs else paresRecursivo xs

-- Usando funcion Filter

paresFilter :: [Int] -> [Int]
paresFilter = filter even

-- 6e mejorada
--  En la definición de multiplicaPares del ejercicio 6e, se puede mejorar la función para que sólo multiplique 
-- los números pares en lugar de multiplicar todos los números y luego filtrar los pares. Esto se puede hacer 
--utilizando la función foldl para aplicar una función de multiplicación acumulativa sólo a los números pares en la lista:

multiplicaPares :: [Int] -> Int
multiplicaPares = foldl (*) 1 . filter even

-- Ejercicio 10

-- Usando recursión

primIgualesA :: Eq a => a -> [a] -> [a]
primIgualesA _ [] = []
primIgualesA x (y:ys) | x == y = x : primIgualesA x ys
                      | otherwise = []

-- Usando takeWhile

primIgualesA :: Eq a => a -> [a] -> [a]
primIgualesA x = takeWhile (== x)

-- Ejercicio 11

-- Usando recursión

primIguales :: Eq a => [a] -> [a]
primIguales [] = []
primIguales [x] = [x]
primIguales (x:y:xs)
  | x == y = x : primIguales (y:xs)
  | otherwise = [x]

-- Usando prinIgualesA

primIguales :: Eq a => [a] -> [a]
primIguales [] = []
primIguales xs = maximumBy (comparing length) [primIgualesA x xs | x <- xs]


-- Ejercicio 12

paratodo'' :: [a] -> (a -> Bool) -> Bool
paratodo'' xs t = cuantGen (&&) True xs t

existe'' :: [a] -> (a -> Bool) -> Bool
existe'' xs t = cuantGen (||) False xs t

sumatoria'' :: Num b => [a] -> (a -> b) -> b
sumatoria'' xs t = cuantGen (+) 0 xs t

productoria'' :: Num b => [a] -> (a -> b) -> b
productoria'' xs t = cuantGen (*) 1 xs t

-- Ejercicio 13

-- a) Está bien tipado. El tipo de x es a y el tipo de y es b. El patrón no cubre todos los 
-- casos de definición, ya que solo se corresponde con tuplas de dos elementos.

-- b) No está bien tipado. En el patrón, a y b son variables, pero en la expresión se 
-- utiliza a y b como patrones en sí mismos. Debería ser f [(x, y)] = ... o f [(a, b)] = ....

-- c) Está bien tipado. El tipo de x es (a, b) y el tipo de xs es [(a, b)]. El patrón no 
-- cubre todos los casos de definición, ya que solo se corresponde con listas que tengan al 
-- menos un elemento.

-- d) Está bien tipado. El tipo de x es (a, b) y el tipo de xs es [(a, b)]. El patrón cubre 
-- solamente los casos en los que la lista tenga al menos dos elementos y el primer elemento 
-- sea una tupla de dos elementos.

-- e) Está bien tipado. El tipo de a es arbitrario y el tipo de la lista es [(Int, a)]. El 
-- patrón cubre solamente los casos en los que la lista tenga un solo elemento, cuyo primer 
-- elemento sea 0 y cuyo segundo elemento tenga un tipo arbitrario a.

-- Ejercicio 14

-- a) f (x,y) = y

-- b) No se puede dar una definicion para esta funcion ya que el retorno de la funcion es 
-- completamente abstracto. La funcion recibe una tupla de dos elementos y devuelve un 
-- valor desconocido.

-- c) f = id

-- Otra definición posible es:

-- f g x = g x

-- d) f _ [] = []
-- f g (x:xs) = g x : f g xs

-- Otra definición posible es:

-- f g xs = map g xs

-- e) f g h x = h (g x)

-- Otra definición posible es:

-- f g h = (.) h g