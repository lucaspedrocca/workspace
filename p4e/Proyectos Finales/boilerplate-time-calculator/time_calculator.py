def add_time(start, duration, day=""):
  # Definicion de variables start
  startSplit = start.split()
  startHour = int(startSplit[0].split(":")[0])
  startMinutes = int(startSplit[0].split(":")[1])
  startAmPm = startSplit[1]

  # Definicion de variables duration
  durationSplit = duration.split()
  durationHour = int(durationSplit[0].split(":")[0])
  durationMinutes = int(durationSplit[0].split(":")[1])
  
  # Definicion de resto de variables
  dayFormated = day.lower()
  days = 0
  listDays = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]




  # funcion para convertir a 24 horas
  def convertFormat24(hour,period):
    if period == "PM":
      hour = int(hour) + 12
    else:
      hour
    return hour
  
  # funcion para convertir a 12 horas
  def convertFormat12(hour):
    if hour == 0:
      hour = 12

    elif hour >= 13:
      hour -= 12

    period = "AM" if hour <= 12  else "PM"

    return hour, period


  
  startHour = convertFormat24(startHour, startAmPm)

  while durationHour > 0:
    # Conteo de horas
    startHour += 1
    durationHour -= 1

    # Suma de horas por minuto 
    if durationMinutes > 0:
      startMinutes += durationMinutes
      while startMinutes >= 60:
        startHour += 1
        startMinutes -= 60
      durationMinutes = 0

    # Conteo de dias
    if startHour == 24:
      days += 1
      startHour = startHour - 24
    

  startHour = convertFormat12(startHour)[0]
  startAmPm = convertFormat12(startHour)[1]

  # if startHour < 10:
  #   startHour = f"0{startHour}"
  
  if startMinutes < 10:
    startMinutes = f"0{startMinutes}"



  # Diferentes resupuestas por caso

  # Caso 1: No se define day ni pasan dias

  new_time = f"Returns: {startHour}:{startMinutes} {startAmPm}"

  #   # Caso 1: No se definio day ni pasaron dias
  # if day == "" and days == 0:
  #   new_time = returnHora


  # Caso 2: Se definio day
  if dayFormated in listDays:
    indexDay = listDays.index(dayFormated)

    # Funcion para devolver el string del dia Capitalizado
    countDays = days
    while (indexDay + countDays) >= 6:
      countDays -= 7
    else:
      indexDay += countDays
    
    dayFormated = listDays[indexDay]

    # Se suma ", dayFormated" a new time
    new_time += f", {dayFormated}" 

  # print(f'pasaron {days} dias y estoy en {day}.')


  # Caso 3: Pasaron n cantidad de dias

  if days > 0:
    if days ==  1:
      new_time += " (next day)"
    else:
      new_time += f" ({days} days later)"

  return new_time


print(add_time("3:00 PM", "3:10"))
print(add_time("11:30 AM", "2:32", "Monday"))
print(add_time("11:43 AM", "00:20"))
print(add_time("10:10 PM", "3:30"))
print(add_time("11:43 PM", "24:20", "tueSday"))
print(add_time("6:30 PM", "205:12"))





    




























































#   # funcion para convertir a 12 horas
#   def convertFormat12(a,b):
#     if b == 'PM':
#       a = int(a) - 12
#       if b == 'AM':
#         b = 'PM'
#       else:
#         b
#     elif a in (0,24):
#       a = 12
#     else:
#       a
#     return a
  
#   # def sumaStr(a,b):
#   #   c = str(int(a) + int(b))
#   #   return c
  
#   # def restaStr(a,b):
#   #   c = str(int(a) - int(b))
#   #   return c
  
#   # suma de minutos
#   totalMinutes = startMinutes + durationMinutes
  
#   while totalMinutes >= 60:
#     durationHour += 1
#     totalMinutes -= 60

#   # calculo de dias

#   while durationHour >= 24:
#     days += 1
#     durationHour = durationHour - 24

#   startHour = convertFormat24(startHour, startAmPm)

#   # totalHour = 0
#   # if totalHour > 12:
#   #   totalHour = startHour + durationHour - 12
#   # else:

#   totalHour = startHour + durationHour
#   totalHour = convertFormat12(totalHour, startAmPm)


#   # formateo de variables

#   if totalMinutes < 10:
#     totalMinutes = '0' + str(totalMinutes)

#   # Devolucion por caso

#   # Si se declara el dia que empieza
#   dayFormated = day.capitalize()
#   if dayFormated in listDays:
#     indexDay = listDays.index(dayFormated)

#     while (indexDay + days) >= 6:
#       days -= 7
#     else:
#       indexDay += days
    
#     dayFormated = listDays[indexDay]
#     new_time = f"{returns} {totalHour}:{totalMinutes} {startAmPm}, {dayFormated}"
      
#   # Cero dias
#   elif days == 0:
#     new_time = f"{returns} {totalHour}:{totalMinutes} {startAmPm}"

#   # Un dia
#   elif days == 1:
#     new_time = f"{returns} {totalHour}:{totalMinutes} {startAmPm} (next day)"
































  # if startAmPm == 'AM':
  #   new_time = returns + sumaStr(startHour, durationHour) + ":" + sumaStr(startMinutes, durationMinutes) + " " + startAmPm

  # else:
  #   startHour = convertFormat24(startHour)

  #   while durationHour > 24:
  #     days += 1
  #     durationHour -= 24
    
  #   if days == 1:
  #     new_time = returns + sumaStr(startHour, durationHour) + ":" + sumaStr(startMinutes, durationMinutes) + " " + startAmPm