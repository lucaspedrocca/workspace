<?php
defined('BASEPATH') or exit('No direct script access allowed');
?>
<!DOCTYPE html>
<html lang="en">

<head>
	<meta charset="utf-8">
	<title>Monitoreo</title>
	<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.4.1/dist/css/bootstrap.min.css" integrity="sha384-Vkoo8x4CGsO3+Hhxv8T/Q5PaXtkKtu6ug5TOeNV6gBiFeWPGFN9MuhOf23Q9Ifjh" crossorigin="anonymous">
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
</head>

<body>
	<iframe width="500" height="125" src="https://reloj-alarma.com/embed/#theme=0&m=0&showdate=1" frameborder="1" allowfullscreen></iframe>

	<audio id="alertaSonido">
		<source src="application\media\alert.wav" type="audio/wav">
		El navegador no soporta la etiqueta de audio.
	</audio>

	<div class="container-fluid">
		<div class="row">
			<div class="col-xs-12">
				<table class="table table-sm table-bordered table-striped table-hover">
					<thead>
						<tr>
							<th>Consulta a ejecutar</th>
							<th>#ID</th>
							<th class="text-center">Ultima ejecución</th>
							<th class="text-center">Valor</th>
							<th class="text-center">Umbral</th>
							<th class="text-center">Intervalo</th>
							<th class="text-center">Estado Ant.</th>
							<th class="text-center">Estado Act.</th>
							<th class="text-center">Envia Mail</th>
							<th class="text-center">Reintentos</th>
							<th class="text-center">Aviso</th>
							<th class="text-center">Estado</th>
							<th class="text-center">Activo</th>
							<th class="text-center">Comentario</th>
							<th class="text-center">Enviado</th>
						</tr>
					</thead>
					<tbody>
						<?php foreach ($consultas as $consulta) :; ?>
							<tr>
								<td class="query" id="query_<?php echo $consulta['query']; ?>" data-query="<?php echo $consulta['query']; ?>" data-intervalo="<?php echo $consulta['intervalo']; ?>"><?php echo $consulta['name']; ?></td>
								<td class="queryID" id="queryID_<?php echo $consulta['query']; ?>"><?php echo $consulta['query']; ?></td>
								<td class="ejecutado" id="ejecutado_<?php echo $consulta['query']; ?>"></td>
								<td class="valor" id="valor_<?php echo $consulta['query']; ?>"></td>
								<td class="umbral" id="umbral_<?php echo $consulta['query']; ?>"><?php echo $consulta['umbral']; ?></td>
								<td class="intervalo" id="intervalo_<?php echo $consulta['query']; ?>"><?php echo $consulta['intervalo']; ?></td>
								<td class="estadoant" id="estadoant_<?php echo $consulta['query']; ?>"><?php echo 0; ?></td>
								<td class="estadoact" id="estadoact_<?php echo $consulta['query']; ?>"><?php echo 1; ?></td>
								<td class="enviamail" id="enviamail_<?php echo $consulta['query']; ?>"><?php echo 'NO'; ?></td>
								<td class="reint" id="reint_<?php echo $consulta['query']; ?>"><?php echo 0; ?></td>
								<td class="aviso" id="aviso_<?php echo $consulta['query']; ?>"><?php echo $consulta['aviso']; ?></td>
								<td class="estado" id="estado_<?php echo $consulta['query']; ?>"><?php echo 0; ?></td>
								<td> <input type="checkbox" <?php echo $consulta['check'] == 'SI'?'checked':'';?> id="check_<?php echo $consulta['query']; ?>"></td>
								<td class="comentario" id="comentario_<?php echo $consulta['query']; ?>"><?php echo $consulta['comentario']; ?></td>
								<td class="enviado" id="enviado_<?php echo $consulta['query']; ?>"><?php echo 'NO'; ?></td>
							</tr>
							
						<?php endforeach; ?>
					</tbody>
				</table>
			</div>
		</div>

	</div>
	<script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.0/dist/umd/popper.min.js" integrity="sha384-Q6E9RHvbIyZFJoft+2mJbHaEWldlvI9IOYy5n3zV9zzTtmI3UksdQRVvoxMfooAo" crossorigin="anonymous"></script>
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@4.4.1/dist/js/bootstrap.min.js" integrity="sha384-wfSDF2E50Y2D1uUdj0O3uMBJnjuUD4Ih7YwaYd1iqfktj0Uod8GCExl3Og8ifwB6" crossorigin="anonymous"></script>
	<script>
		$(document).ready(function() {
			// Para cada elemento con la clase 'query'
			$('.query').each(function() {
				// Obtener el valor del atributo 'data-query'
				let id = $(this).data('query');
				let intervalo = $(this).data('intervalo');

				runAjax(id);
				setInterval(() => {
					runAjax(id);
				}, (intervalo * 1000 * 60));

			});
		});
		const runAjax = (id) => {

			$.ajax({
				url: "welcome/consulta",
				method: "POST",
				data: {
					id: id
				}, // Pasar el ID como datos en la solicitud
				success: function(response) {
					if (response) {
						response_json = JSON.parse(response)
					}
				//	console.log(response_json.resultado[0].cantidad);
				//	console.log(`${response_json.query}`);
				//	console.log($(`#query_${response_json.query}`).html() + " " + document.getElementById('check_'+`${response_json.query}`).checked);
				//	console.log(document.getElementById('check_20').checked);
				//	console.log($(`#estadoact_${response_json.query}`).html());
				//	console.log(`${response_json.query}` + '***');

					$(`#estadoant_${response_json.query}`).html($(`#estadoact_${response_json.query}`).html());

					if (response_json.resultado[0].cantidad >= $(`#umbral_${response_json.query}`).html()) {
						$(`#estadoact_${response_json.query}`).html(1);
					} else {
						$(`#estadoact_${response_json.query}`).html(0);
					}


					let aa = $(`#reint_${response_json.query}`).html();

					if ($(`#estadoant_${response_json.query}`).html() == $(`#estadoact_${response_json.query}`).html() ) {
						console.log('sin cambios');
						if ($(`#estadoact_${response_json.query}`).html() == 0 ) {
							$(`#reint_${response_json.query}`).html(++aa);
							$(`#enviamail_${response_json.query}`).html('SI');
						} else {
							$(`#enviamail_${response_json.query}`).html('NO');
							$(`#reint_${response_json.query}`).html(0);
						}
					} else {
						console.log('con cambios');
						if ($(`#estadoact_${response_json.query}`).html() == 1 ) {
							if ($(`#reint_${response_json.query}`).html() >= 2) {
								$(`#enviamail_${response_json.query}`).html('SI');
							} else {
								$(`#enviamail_${response_json.query}`).html('NO');
							}
							$(`#reint_${response_json.query}`).html(0);

						} else {
							$(`#enviamail_${response_json.query}`).html('SI');
							//console.log(++aa);
							$(`#reint_${response_json.query}`).html(++aa);
      						}
					}

					if ($(`#estadoact_${response_json.query}`).html() == 1) {
						$(`#estado_${response_json.query}`).css('color', 'white');
						$(`#estado_${response_json.query}`).css('background-color', 'green');
						$(`#estado_${response_json.query}`).html('OK');
					} else {
						if (parseInt($(`#reint_${response_json.query}`).html()) >= parseInt($(`#aviso_${response_json.query}`).html())){
							$(`#estado_${response_json.query}`).css('background-color', 'red');
							$(`#estado_${response_json.query}`).css('color', 'white');
						} else {
							$(`#estado_${response_json.query}`).css('background-color', 'yellow');
							$(`#estado_${response_json.query}`).css('color', 'blue');
						}
						$(`#estado_${response_json.query}`).html('ERROR');
					}

					$(`#ejecutado_${response_json.query}`).html(response_json.ejecutado);
					$(`#valor_${response_json.query}`).css('color', 'white');
					$(`#valor_${response_json.query}`).css('text-align', 'center');
					$(`#valor_${response_json.query}`).html(response_json.resultado[0].cantidad);

					if (response_json.resultado[0].cantidad >= $(`#umbral_${response_json.query}`).html()) {
						$(`#valor_${response_json.query}`).css('background-color', 'green');
					} else {
						if (parseInt($(`#reint_${response_json.query}`).html()) >= parseInt($(`#aviso_${response_json.query}`).html())){
							$(`#valor_${response_json.query}`).css('background-color', 'red');
							if (document.getElementById('check_'+`${response_json.query}`).checked){
								var audio = document.getElementById('alertaSonido');
								audio.play();
								audio.addEventListener('ended');
							}
						} else {
							$(`#valor_${response_json.query}`).css('background-color', 'yellow');
							$(`#valor_${response_json.query}`).css('color', 'blue');
						}
					}


					if (document.getElementById('check_'+`${response_json.query}`).checked == false){
						$(`#enviamail_${response_json.query}`).html('NO');
					}			

					if ($(`#enviamail_${response_json.query}`).html() == 'SI') {
						if ($(`#estadoact_${response_json.query}`).html() != 1) {
							if ($(`#reint_${response_json.query}`).html() < $(`#aviso_${response_json.query}`).html()){
								$(`#enviamail_${response_json.query}`).html('NO');
							} else {
								if ($(`#reint_${response_json.query}`).html() > $(`#aviso_${response_json.query}`).html()){
									if ( ($(`#reint_${response_json.query}`).html() % 6) != 0) {
										$(`#enviamail_${response_json.query}`).html('NO');
									}
								}
							}
						}
					}

					if ($(`#enviamail_${response_json.query}`).html() == 'SI') {
					   	if ($(`#estadoact_${response_json.query}`).html() == 0) {
							$(`#enviado_${response_json.query}`).html('SI');
						} else {
							if ($(`#enviado_${response_json.query}`).html() == 'NO') {
								$(`#enviamail_${response_json.query}`).html('NO');
							}
						}
					}

					if ($(`#enviamail_${response_json.query}`).html() == 'SI') {

					   	if ($(`#estadoact_${response_json.query}`).html() == 1) {
							$(`#enviado_${response_json.query}`).html('NO');
						}

						$cCuerpoMail = $(`#comentario_${response_json.query}`).html();
						
						if (response_json.query == 25){
							for (var i=0; i < response_json.resultadodetalle.length; i++){
								if (i==0){
									//$cCuerpoMail = $cCuerpoMail + "<br/>"+response_json.resultadodetalle[i].FechaDespacho+"<br/>";
									$cCuerpoMail = $cCuerpoMail + "<br/>";
									$cCuerpoMail = $cCuerpoMail + response_json.resultadodetalle[i].FechaDespacho;
									$cCuerpoMail = $cCuerpoMail + "<br/>";
									$cCuerpoMail = $cCuerpoMail + '<table border="1" style="border-collapse: collapse;">';
									$cCuerpoMail = $cCuerpoMail + "<tr>";
									$cCuerpoMail = $cCuerpoMail + "<th>IDLinea</th>";
									$cCuerpoMail = $cCuerpoMail + "<th>HoraSale</th>";
									$cCuerpoMail = $cCuerpoMail + "<th>Formacion</th>";
									$cCuerpoMail = $cCuerpoMail + "<th>Cantidad</th>";
									$cCuerpoMail = $cCuerpoMail + "</tr>";
								}
								//$cCuerpoMail = $cCuerpoMail + response_json.resultadodetalle[i].IDLinea + "  |  " + response_json.resultadodetalle[i].HoraSale + "  |  " + response_json.resultadodetalle[i].Formacion + "  |  " + response_json.resultadodetalle[i].cantidad + "<br/>";
								$cCuerpoMail = $cCuerpoMail + "<tr>";
								$cCuerpoMail = $cCuerpoMail + "<td>" + response_json.resultadodetalle[i].IDLinea + "</td>";
								$cCuerpoMail = $cCuerpoMail + "<td>" + response_json.resultadodetalle[i].HoraSale + "</td>";
								$cCuerpoMail = $cCuerpoMail + "<td>" + response_json.resultadodetalle[i].Formacion + "</td>";
								$cCuerpoMail = $cCuerpoMail + "<td>" + response_json.resultadodetalle[i].cantidad + "</td>";
								$cCuerpoMail = $cCuerpoMail + "</tr>";
							}
							$cCuerpoMail = $cCuerpoMail + "</table>";
						}

						if (response_json.query == 26){
							for (var i=0; i < response_json.resultadodetalle.length; i++){
								if (i==0){
									$cCuerpoMail = $cCuerpoMail + "<br/>";
									$cCuerpoMail = $cCuerpoMail + '<table border="1" style="border-collapse: collapse;">';
									$cCuerpoMail = $cCuerpoMail + "<tr>";
									$cCuerpoMail = $cCuerpoMail + "<th>Linea</th>";
									$cCuerpoMail = $cCuerpoMail + "<th>Estacion</th>";
									$cCuerpoMail = $cCuerpoMail + "<th>Cantidad</th>";
									$cCuerpoMail = $cCuerpoMail + "</tr>";
								}
								$cCuerpoMail = $cCuerpoMail + "<tr>";
								$cCuerpoMail = $cCuerpoMail + "<td>" + response_json.resultadodetalle[i].linea + "</td>";
								$cCuerpoMail = $cCuerpoMail + "<td>" + response_json.resultadodetalle[i].estacion + "</td>";
								$cCuerpoMail = $cCuerpoMail + "<td>" + response_json.resultadodetalle[i].cantidad + "</td>";
								$cCuerpoMail = $cCuerpoMail + "</tr>";
							}
							$cCuerpoMail = $cCuerpoMail + "</table>";
						}


						if (response_json.query == 28){
							for (var i=0; i < response_json.resultadodetalle.length; i++){
								if (i==0){
									$cCuerpoMail = $cCuerpoMail + "<br/>";
									$cCuerpoMail = $cCuerpoMail + '<table border="1" style="border-collapse: collapse;">';
									$cCuerpoMail = $cCuerpoMail + "<tr>";
									$cCuerpoMail = $cCuerpoMail + "<th>Linea</th>";
									$cCuerpoMail = $cCuerpoMail + "<th>FechaDespacho</th>";
									$cCuerpoMail = $cCuerpoMail + "<th>NroRegistro</th>";
									$cCuerpoMail = $cCuerpoMail + "<th>Cantidad</th>";
									$cCuerpoMail = $cCuerpoMail + "</tr>";
								}
								$cCuerpoMail = $cCuerpoMail + "<tr>";
								$cCuerpoMail = $cCuerpoMail + "<td>" + response_json.resultadodetalle[i].idLinea + "</td>";
								$cCuerpoMail = $cCuerpoMail + "<td>" + response_json.resultadodetalle[i].FechaDespacho + "</td>";
								$cCuerpoMail = $cCuerpoMail + "<td>" + response_json.resultadodetalle[i].NroRegistro + "</td>";
								$cCuerpoMail = $cCuerpoMail + "<td>" + response_json.resultadodetalle[i].cantidad + "</td>";
								$cCuerpoMail = $cCuerpoMail + "</tr>";
							}
							$cCuerpoMail = $cCuerpoMail + "</table>";
						}

						if (response_json.query == 33){
							for (var i=0; i < response_json.resultadodetalle.length; i++){
								if (i==0){
									$cCuerpoMail = $cCuerpoMail + "<br/>";
									$cCuerpoMail = $cCuerpoMail + '<table border="1" style="border-collapse: collapse;">';
									$cCuerpoMail = $cCuerpoMail + "<tr>";
									$cCuerpoMail = $cCuerpoMail + "<th>Día</th>";
									$cCuerpoMail = $cCuerpoMail + "<th>Resumen</th>";
									$cCuerpoMail = $cCuerpoMail + "<th>Reportes</th>";
									$cCuerpoMail = $cCuerpoMail + "<th>Diferencia</th>";
									$cCuerpoMail = $cCuerpoMail + "</tr>";
								}
								$cCuerpoMail = $cCuerpoMail + "<tr>";
								$cCuerpoMail = $cCuerpoMail + "<td>" + response_json.resultadodetalle[i].dia + "</td>";
								$cCuerpoMail = $cCuerpoMail + "<td>" + response_json.resultadodetalle[i].resumen + "</td>";
								$cCuerpoMail = $cCuerpoMail + "<td>" + response_json.resultadodetalle[i].reportes + "</td>";
								$cCuerpoMail = $cCuerpoMail + "<td>" + response_json.resultadodetalle[i].diferencia + "</td>";
								$cCuerpoMail = $cCuerpoMail + "</tr>";
							}
							$cCuerpoMail = $cCuerpoMail + "</table>";
						}

						$.ajax({
							url: "welcome/email",
							method: "POST",
							data: {
								id: id,
								asunto: 'EMV '+$(`#query_${response_json.query}`).html(),
								estado: $(`#estado_${response_json.query}`).html(),
								reintentos: $(`#reint_${response_json.query}`).html(),
								cuerpo: $cCuerpoMail
							}
						});
					}
				},
				error: function(xhr, status, error) {
					// Manejar errores de la solicitud
					console.error(xhr.responseText);
				}
			});
		}
	</script>

</body>

</html>