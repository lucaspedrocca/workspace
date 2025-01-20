# Configuración del correo
$smtpServer = "smtp.office365.com"
$smtpPort = 587
$smtpUser = "Tes365Promi@grupoprominente.com"
$smtpPass = ""   
$toEmail = "testRoblicencias@grupoprominente.com"
$subject = "Robinson: Estado de licencia"
$fromEmail = $smtpUser

# Ejecuta slmgr /dlv y captura la salida como string
$output = & cscript //Nologo "C:\Windows\System32\slmgr.vbs" /dlv
$outputAsString = $output -join "`n"  # Convierte el array de líneas en un solo string

# Concatena Hostname y el output
$result = "Hostname: $($env:COMPUTERNAME)`nOutput:`n$outputAsString"

# Muestra el resultado concatenado
# Write-Output $result

# Crear el mensaje de correo
$message = New-Object System.Net.Mail.MailMessage
$message.From = $fromEmail
$message.To.Add($toEmail)
$message.Subject = $subject
$message.Body = $result
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