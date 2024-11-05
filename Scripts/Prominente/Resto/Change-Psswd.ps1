# Define el nombre de usuario y la nueva contraseña
$username = Read-Host "Ingrese el usuario" # Reemplaza con el nombre del usuario
$newPassword = Read-Host "Nueva contraseña" | ConvertTo-SecureString -AsPlainText -Force

# Lista de dominios a los que quieres conectarte
$dominios = @("cliba.com.ar", "brt.com.ar", "emv.com.ar", "metrovias.com.ar","prominente.com.ar")  # usuarios.local y haug.local no tengo usuario

# Itera a través de cada dominio y cambia la contraseña
foreach ($dominio in $dominios) {
    try {
        # Establece la conexión con el dominio
        $session = New-Object DirectoryServices.DirectoryEntry("LDAP://$dominio")
        
        # Obtiene el objeto de usuario en el dominio
        $user = Get-ADUser -Identity $username -Server $dominio

        if ($user) {
            # Cambia la contraseña del usuario
            $user | Set-ADAccountPassword -NewPassword $newPassword -Reset
            Write-Output "Contraseña cambiada con éxito para $username en $dominio"
        } else {
            Write-Output "No se encontró el usuario $username en $dominio"
        }
    } catch {
        Write-Output "Error al cambiar la contraseña para $username en $dominio : $_"
    }
}
