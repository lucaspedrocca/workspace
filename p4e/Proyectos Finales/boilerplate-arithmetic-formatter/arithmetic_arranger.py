def arithmetic_arranger(problems, viewresult=False):

  # Definicion de variables

  operators = ('+', '-')
  errorTooMany = 'Error: Too many problems.'
  errorNonOperatorsValid = "Error: Operator must be '+' or '-'."
  errorType = "Error: Numbers must only contain digits."
  errorMoreThan4Digits = "Error: Numbers cannot be more than four digits."

  firstLine = ""
  secondLine = ""
  thirdLine = ""
  resultLine = ""

  # Si el numero de problemas es mayor a cinco devuelve errorTooMany

  if len(problems) > 5:
    return errorTooMany

  # Ciclo for principal

  for problem in problems:
    # Se divide cada problema en una lista de strings
    listProblem = problem.split()
    operator = listProblem[1]

    firstNumber = listProblem[0]
    lenFirstNumber = len(firstNumber)

    secondNumber = listProblem[2]
    lenSecondNumber = len(secondNumber)

    # Excepciones

    # Si el operador es distinsto a los que se encuentran en operators devuelve errorNonOperatorsValid
    if operator not in operators:
      return errorNonOperatorsValid

    # Si el numero no es un digito devuelve errorType
    try:
      int(firstNumber)
      int(secondNumber)

    except ValueError:
      return errorType

    # Si los operandos tienen mas de cuatro digitos devuelve errorMoreThan4Digits
    if lenFirstNumber > 4 or lenSecondNumber > 4:
      return errorMoreThan4Digits

    # Funcion Principal
    arranged_problems = ""

    # Obtenemos la diferencia entre la longitud de los numeros
    difNum = lenFirstNumber - lenSecondNumber
    if difNum < 0:
      difNum *= -1

    # Calculamos la diferencia de longitud entre los dos digitos y creamos los numeros con espacios
    lenMaxNum = max(lenFirstNumber, lenSecondNumber)
    formatedFirstNumber = ""
    formatedSecondNumber = ""
    spaceWithin = " "

    if lenFirstNumber < lenMaxNum:
      formatedFirstNumber = (difNum + 2) * spaceWithin + firstNumber
      formatedSecondNumber = secondNumber

    else:
      formatedSecondNumber = difNum * spaceWithin + secondNumber
      formatedFirstNumber = 2 * spaceWithin + firstNumber

    # Ver resultado
    formatedResult = ""
    if viewresult:
      if len(str(eval(firstNumber + operator + secondNumber))) > lenMaxNum:
        formatedResult = (1 * spaceWithin) + str(
            eval(firstNumber + operator + secondNumber))
        resultLine += formatedResult + (4 * spaceWithin)
      else:
        formatedResult = (2 * spaceWithin) + str(
            eval(firstNumber + operator + secondNumber))
        resultLine += formatedResult + (4 * spaceWithin)

  # Definicion de lineas de la plantilla

    firstLine += formatedFirstNumber + (4 * spaceWithin)
    secondLine += operator + spaceWithin + formatedSecondNumber + (4 *
                                                                   spaceWithin)

    thirdLine += (lenMaxNum + 2) * '-' + (4 * spaceWithin)

  # Eliminamos los espacios en blanco de la derecha
  firstLine = firstLine.rstrip()
  secondLine = secondLine.rstrip()
  thirdLine = thirdLine.rstrip()
  resultLine = resultLine.rstrip()

  #plantilla final
  if viewresult:
    arranged_problems = firstLine + '\n' + secondLine + '\n' + thirdLine + '\n' + resultLine

  else:
    arranged_problems = firstLine + '\n' + secondLine + '\n' + thirdLine

  return arranged_problems
