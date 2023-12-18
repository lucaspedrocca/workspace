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
  dayFormated = day.capitalize()
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
    period = "AM" if hour <= 12  else "PM"
    if hour == 0:
      hour = 12

    elif hour >= 13:
      hour -= 12
    return hour, period


  
  startHour = convertFormat24(startHour, startAmPm)

  while durationMinutes > 0:
      # Suma de horas por minuto 
    startMinutes += durationMinutes
    while startMinutes >= 60:
      startHour += 1
      startMinutes -= 60
    durationMinutes = 0

  while durationHour > 0:
    # Conteo de horas
    startHour += 1
    durationHour -= 1

    # Conteo de dias
    if startHour >= 24:
      days += 1
      startHour = startHour - 24
    
  convertedHour = convertFormat12(startHour)
  startAmPm = convertedHour[1]
  startHour = convertedHour[0]
  
  if startMinutes < 10:
    startMinutes = f"0{startMinutes}"

  # Diferentes resupuestas por caso

  # Caso 1: No se define day ni pasan dias

  new_time = f"Returns: {startHour}:{startMinutes} {startAmPm}"

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