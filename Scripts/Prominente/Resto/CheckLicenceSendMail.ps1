# Configuración del correo
$hostname = $env:COMPUTERNAME
$smtpServer = "smtp.office365.com"
$smtpPort = 587
$smtpUser = "Tes365Promi@grupoprominente.com"
$smtpPass = "" #Qu9y70wr!   
$toEmail = "testRoblicencias@grupoprominente.com" #testRoblicencias@grupoprominente.com
$subject = "Robinson: Estado de licencia $hostname"
$fromEmail = $smtpUser


# Función para normalizar las claves de JSON
function Normalize-Keys($data, $translationDictionary) {
    $normalizedData = @{}
    foreach ($key in $data.Keys) {
        # Si la clave está en el diccionario, reemplazarla
        if ($translationDictionary.ContainsKey($key)) {
            $normalizedData[$translationDictionary[$key]] = $data[$key]
        } else {
            # Si no está en el diccionario, mantener la clave original
            $normalizedData[$key] = $data[$key]
        }
    }
    return $normalizedData
}

# Diccionario de mapeo de claves
$translationDictionary = @{
    "Software licensing service version" = "Versión del Servicio de licencias de software"
    "Description" = "Descripción"
    "Validation URL" = "URL de validación"
    "Activation ID" = "Id. de activación"
    "Installation ID" = "Id. de instalación"
    "Product Key Channel" = "Canal de clave de producto"
    "Name" = "Nombre"
    "Remaining SKU rearm count" = "Recuento de rearmados de SKU restantes"
    "Trusted time" = "Hora de confianza"
    "Partial Product Key" = "Clave de producto parcial"
    "License Status" = "Estado de la licencia"
    "Estado de licencia" = "Estado de la licencia"
    "Reason for notification" = "Razón de la notificación"
    "License URL" = "URL de la licencia de uso"
    "Application ID" = "Id. de aplicación"
    "Remaining Windows rearm count" = "Recuento de rearmado de Windows restante"
    "Extended PID" = "PID extendido"
}

# Ejecutar el comando para obtener la salida
$output = & cscript //Nologo "C:\Windows\System32\slmgr.vbs" /dlv

# Divide la salida en líneas
$lines = $output -split "`n" | Where-Object { $_.Trim() -ne "" }

# Inicializar un objeto vacío para almacenar los resultados
$outputObject = @{
    "Hora de captura" = (Get-Date -Format "dd/MM/yyyy HH:mm:ss")
    "Current build" = (Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion").CurrentBuild
    Hostname = $hostname
    OS = (Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion").ProductName
    
}

# Procesar cada línea
foreach ($line in $lines) {
    # Dividir la línea en clave y valor
    $parts = $line -split ":", 2

    # Asignar la clave y el valor
    $key = $parts[0].Trim()
    $value = $parts[1].Trim()

    # Agregar el par clave-valor al objeto de salida
    $outputObject[$key] = $value
}

$jsonData = Normalize-Keys $outputObject $translationDictionary | ConvertTo-Json -Depth 3

# Crear el mensaje de correo
$message = New-Object System.Net.Mail.MailMessage
$message.From = $fromEmail
$message.To.Add($toEmail)
$message.Subject = $subject
$message.Body = $jsonData
$message.IsBodyHtml = $false

# Configura el cliente SMTP
$smtpClient = New-Object System.Net.Mail.SmtpClient($smtpServer, $smtpPort)
$smtpClient.EnableSsl = $true
$smtpClient.Credentials = New-Object System.Net.NetworkCredential($smtpUser, $smtpPass)

# Envía el correo
try {
    $smtpClient.Send($message)
    Write-Host "Correo enviado exitosamente a $toEmail."
} catch {
    Write-Host "Error al enviar el correo: $_"
}