<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Reproducir WAV</title>
</head>
<body>

//chrome.exe --autoplay-policy=no-user-gesture-required

    <h1>Reproducir un archivo WAV</h1>

	<audio id="alertaSonido">
		<source src="..\media\alert.wav" type="audio/wav">
		Tu navegador no soporta la etiqueta de audio.
	</audio>

	<script>
		// Desmutear y reproducir después de cargar automáticamente
		var audio = document.getElementById('alertaSonido');

//		audio.muted = true;
//		audio.play().then(function() {
			// El audio comenzó a reproducirse, ahora desmutear
//			audio.muted = false;
//		}).catch(function(error) {
//			console.log('Autoplay bloqueado: ', error);
//		});


//		audio.muted = false;
		audio.play();
	</script>
		

</body>
</html>



