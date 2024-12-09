<?php
if (isset($_POST['exportar'])) {
    // Obtener el contenido de la tabla HTML desde el formulario
    $html = $_POST['tabla_html'];

    // Configurar las cabeceras HTTP
    header("Content-type: application/vnd.ms-excel");
    header("Content-Disposition: attachment; filename=nombre_del_archivo.xls");
    header("Pragma: no-cache");
    header("Expires: 0");

    // Imprimir el contenido de la tabla HTML
    echo $html;
}
?>
