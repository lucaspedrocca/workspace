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
  returns = "Returns:"
  days = 0
  listDays = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]




  # funcion para convertir a 24 horas
  def convertFormat24(a,b):
    if b == "PM":
      a = int(a) + 12
    else:
      a
    return a
  
  # funcion para convertir a 12 horas
  def convertFormat12(a, b):
    if a > 12 & a < 24:
      a = int(a) - 12
      if b == 'AM':
        b = 'PM'
      else:
        b
    elif a in (0,24):
      a = 12
    else:
      a
    return a
  
  # def sumaStr(a,b):
  #   c = str(int(a) + int(b))
  #   return c
  
  # def restaStr(a,b):
  #   c = str(int(a) - int(b))
  #   return c
  
  # suma de minutos
  totalMinutes = startMinutes + durationMinutes
  
  if totalMinutes >= 60:
    durationHour += 1
    totalMinutes -= 60

  # calculo de dias

  while durationHour >= 24:
    days += 1
    durationHour = durationHour - 24

  startHour = convertFormat24(startHour, startAmPm)

  totalHour = 0
  if totalHour > 12:
    totalHour = startHour + durationHour - 12
  else:
    totalHour = startHour + durationHour

  totalHour = convertFormat12(totalHour, startAmPm)

  # formateo de variables

  if totalMinutes < 10:
    totalMinutes = '0' + str(totalMinutes)

  # Devolucion por caso

  # Si se declara el dia que empieza
  dayFormated= day.capitalize()
  if dayFormated in listDays:
    indexDay = listDays.index(dayFormated)

    while (indexDay + days) >= 6:
      days -= 7
    else:
      indexDay += days
    
    dayFormated = listDays[indexDay]
    new_time = f"{returns} {totalHour}:{totalMinutes} {startAmPm}, {dayFormated}"
      
  # Cero dias
  elif days == 0:
    new_time = f"{returns} {totalHour}:{totalMinutes} {startAmPm}"

  # Un dia
  elif days == 1:
    new_time = f"{returns} {totalHour}:{totalMinutes} {startAmPm} (next day)"

  

  return new_time


print(add_time("10:10 PM", "3:30"))

































  # if startAmPm == 'AM':
  #   new_time = returns + sumaStr(startHour, durationHour) + ":" + sumaStr(startMinutes, durationMinutes) + " " + startAmPm

  # else:
  #   startHour = convertFormat24(startHour)

  #   while durationHour > 24:
  #     days += 1
  #     durationHour -= 24
    
  #   if days == 1:
  #     new_time = returns + sumaStr(startHour, durationHour) + ":" + sumaStr(startMinutes, durationMinutes) + " " + startAmPm