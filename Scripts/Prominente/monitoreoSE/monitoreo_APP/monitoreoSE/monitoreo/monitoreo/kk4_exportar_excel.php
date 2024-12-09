<?php
if (isset($_POST['exportar'])) {
    // Conectar a la base de datos
    $servername = "localhost";
    $username = "tu_usuario";
    $password = "tu_contraseña";
    $dbname = "tu_base_de_datos";

    $conn = new mysqli($servername, $username, $password, $dbname);

    if ($conn->connect_error) {
        die("Conexión fallida: " . $conn->connect_error);
    }

    // Realizar la consulta SQL
    $sql = "SELECT nombre, edad, correo FROM tu_tabla";
    $result = $conn->query($sql);

    if ($result->num_rows > 0) {
        // Definir el contenido de la tabla HTML
        $html = '<table border="1">';
        $html .= '<tr><th>Nombre</th><th>Edad</th><th>Correo</th></tr>';

        while ($row = $result->fetch_assoc()) {
            $html .= '<tr>';
            $html .= '<td>' . $row['nombre'] . '</td>';
            $html .= '<td>' . $row['edad'] . '</td>';
            $html .= '<td>' . $row['correo'] . '</td>';
            $html .= '</tr>';
        }
        $html .= '</table>';
    } else {
        $html = 'No se encontraron datos';
    }

    $conn->close();

    // Configurar las cabeceras HTTP
    header("Content-type: application/vnd.ms-excel");
    header("Content-Disposition: attachment; filename=datos.xls");
    header("Pragma: no-cache");
    header("Expires: 0");

    // Imprimir el contenido de la tabla HTML
    echo $html;
}
?>
