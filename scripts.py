
for n in range(33):
    if n > 0:
        print ("/* Ejercicio "+ str(n) +" */")
    else:
        pass


nombre = 'lucas' #input("Ingrese su nombre: ")
edad = 19 #input("Ingrese su edad: ")

print(f"Hola mi nombre es {nombre} y tengo {edad} años.")

print("En {casas} hay {perros} perros.".format(casas=2,perros='catorce'))
print("En {} hay {} perros.".format(2,'catorce'))

resultados = 100/888
print('los resultados son {r:1.3f}'.format(r=resultados))

#Listas

mi_lista = [1,2,3]
mi_lista[2] = 'Lucas'
print(mi_lista[1:])

mi_lista.append('Santiago')
mi_lista.pop()

num_lista = [9,4,1,8,5,2,0,6,3,7]

print(f"Esta es la lista en su orden definido: {num_lista}")

num_lista.sort() #Ordena la lista
print(f"Esta es la lista en orden de menor a mayor: {num_lista}")

num_lista.reverse() #Ordena la lista en reversa
print(f"Esta es la lista en orden de mayor a menor: {num_lista}")

#Diccionarios

diccionario = {'manzana':['verde','roja'],'pera':'280','banana':'400'}
print(diccionario)
print(diccionario['manzana'])

diccionario['naranjas']= '300'
print(diccionario)

primer_set = set()

primer_set.add(1)
primer_set.add(2)

print(primer_set)
