<?php
if (isset($_POST['exportar'])) {
    // Definir el contenido de la tabla HTML
    $html = '
    <table border="1">
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
    </table>';

    // Configurar las cabeceras HTTP
    header("Content-type: application/vnd.ms-excel");
    header("Content-Disposition: attachment; filename=nombre_del_archivo.xls");
    header("Pragma: no-cache");
    header("Expires: 0");

    // Imprimir el contenido de la tabla HTML
    echo $html;
}
?>
