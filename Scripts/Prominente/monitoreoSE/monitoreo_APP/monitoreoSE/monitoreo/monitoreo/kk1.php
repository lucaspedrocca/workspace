<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Exportar Tabla a Excel</title>
</head>
<body>
    <table id="tabla" border="1">
        <tr>
            <th>Nombre</th>
            <th>Edad</th>
            <th>Correo</th>
        </tr>
        <tr>
            <td>Juan</td>
            <td>30</td>
            <td>juan@example.com</td>
        </tr>
        <tr>
            <td>María</td>
            <td>25</td>
            <td>maria@example.com</td>
        </tr>
    </table>
    <form action="kk1_exportar_excel.php" method="post">
        <button type="submit" name="exportar">Exportar a Excel</button>
    </form>
</body>
</html>
