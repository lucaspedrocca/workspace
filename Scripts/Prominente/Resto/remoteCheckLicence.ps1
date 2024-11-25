# Configuración del correo
$smtpServer = "smtp.office365.com"
$smtpPort = 587
$smtpUser = "Tes365Promi@grupoprominente.com"
$smtpPass = ""   
$toEmail = "lpedrocca@grupoprominente.com"
$subject = "Robinson: Estado de licencia"
$fromEmail = $smtpUser

# Ejecuta slmgr /dlv y captura la salida
$output = & cscript //Nologo "C:\Windows\System32\slmgr.vbs" /dlv
# Write-Host "Valor de output:"
# $output

# Divide la salida en líneas
$lines = $output -split "`n"
# Write-Host "Valor de lines:"
# $lines

# Procesa la salida y extrae los valores basados en posiciones específicas
$data = @{
    DateCaptured             = (Get-Date -Format "yyyy-MM-ddTHH:mm:ss")
    Hostname                 = $env:COMPUTERNAME
    OS                       = (Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion").ProductName
    CurrentBuild             = (Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion").CurrentBuild
    SoftwareLicensingVersion = if ($lines[0] -like "*:*") { ($lines[0] -split ":")[1].Trim() } else { $lines[0] }
    Name                     = if ($lines[2] -like "*:*") { ($lines[2] -split ":")[1].Trim() } else { $lines[2] }
    Description              = if ($lines[3] -like "*:*") { ($lines[3] -split ":")[1].Trim() } else { $lines[3] }
    ActivationID             = if ($lines[4] -like "*:*") { ($lines[4] -split ":")[1].Trim() } else { $lines[4] }
    ApplicationID            = if ($lines[5] -like "*:*") { ($lines[5] -split ":")[1].Trim() } else { $lines[5] }
    ExtendedPID              = if ($lines[6] -like "*:*") { ($lines[6] -split ":")[1].Trim() } else { $lines[6] }
    ProductKeyChannel        = if ($lines[7] -like "*:*") { ($lines[7] -split ":")[1].Trim() } else { $lines[7] }
    InstallationID           = if ($lines[8] -like "*:*") { ($lines[8] -split ":")[1].Trim() } else { $lines[8] }
    PartialProductKey        = if ($lines[11] -like "*:*") { ($lines[11] -split ":")[1].Trim() } else { $lines[11] }
    LicenseStatus            = if ($lines[12] -like "*:*") { ($lines[12] -split ":")[1].Trim() } else { $lines[12] }
    RemainingWindowsRearm    = if ($lines[13] -like "*:*") { ($lines[13] -split ":")[1].Trim() } else { $lines[13] }
    RemainingSKURearm        = if ($lines[14] -like "*:*") { ($lines[14] -split ":")[1].Trim() } else { $lines[14] }
    TrustedTime              = if ($lines[15] -like "*:*") { ($lines[15] -split ":")[1].Trim() } else { $lines[15] }
}

# Convierte el hash a JSON
$jsonData = $data | ConvertTo-Json -Depth 10 -Compress

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