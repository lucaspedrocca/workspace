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

	<button onclick="reproducirSonido()">Reproducir Sonido</button>

	<!-- Archivo de sonido -->
	<audio id="miSonido" autoplay>
    		<source src="application\media\alert.wav" type="audio/mpeg">
    		Tu navegador no soporta la reproducción de audio.
	</audio>

	<script>
    	// Reproduce automáticamente el sonido cuando la página se carga
    	window.onload = function() {
        	var sonido = document.getElementById("miSonido");
        	sonido.play();
    	};


    	// Función para reproducir el sonido
    	function reproducirSonido() {
        	var sonido = document.getElementById("miSonido");
        	sonido.play();
    	};

	</script>

</body>
</html>
