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
	<iframe width="250" height="125" src="https://reloj-alarma.com/embed/#theme=0&m=0&showdate=1" frameborder="0" allowfullscreen></iframe>

	<div class="container-fluid">
		<div class="row">
			<div class="col-xs-12">
				<table class="table table-sm table-bordered table-striped table-hover">
					<thead>
						<tr>
							<th>Consulta a ejecutar</th>
							<th class="text-center">Ultima ejecución</th>
							<th class="text-center">Valor</th>
							<th class="text-center">Umbral</th>
							<th class="text-center">Intervalo</th>
							<th class="text-center">Estado Ant.</th>
							<th class="text-center">Estado Act.</th>
							<th class="text-center">Envia Mail</th>
							<th class="text-center">Reintentos</th>
							<th class="text-center">Estado</th>
							<th class="text-center">Activo</th>
							<th class="text-center">Comentario</th>
						</tr>
					</thead>
					<tbody>
						<?php foreach ($consultas as $consulta) :; ?>
							<tr>
								<td class="query" id="query_<?php echo $consulta['query']; ?>" data-query="<?php echo $consulta['query']; ?>" data-intervalo="<?php echo $consulta['intervalo']; ?>"><?php echo $consulta['name']; ?></td>
								<td class="ejecutado" id="ejecutado_<?php echo $consulta['query']; ?>"></td>
								<td class="valor" id="valor_<?php echo $consulta['query']; ?>"></td>
								<td class="umbral" id="umbral_<?php echo $consulta['query']; ?>"><?php echo $consulta['umbral']; ?></td>
								<td class="intervalo" id="intervalo_<?php echo $consulta['query']; ?>"><?php echo $consulta['intervalo']; ?></td>
								<td class="estadoant" id="estadoant_<?php echo $consulta['query']; ?>"><?php echo 0; ?></td>
								<td class="estadoact" id="estadoact_<?php echo $consulta['query']; ?>"><?php echo 1; ?></td>
								<td class="enviamail" id="enviamail_<?php echo $consulta['query']; ?>"><?php echo 'NO'; ?></td>
								<td class="reint" id="reint_<?php echo $consulta['query']; ?>"><?php echo 0; ?></td>
								<td class="estado" id="estado_<?php echo $consulta['query']; ?>"><?php echo 0; ?></td>
								<td> <input type="checkbox" checked id="check_<?php echo $consulta['query']; ?>"></td>
								<td class="comentario" id="comentario_<?php echo $consulta['query']; ?>"><?php echo $consulta['comentario']; ?></td>
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
							if ($(`#reint_${response_json.query}`).html() >= 4) {
								if ( ($(`#reint_${response_json.query}`).html() % 6) == 0) {
									$(`#enviamail_${response_json.query}`).html('SI');
								} else{ 
									$(`#enviamail_${response_json.query}`).html('NO');
								}
							} else {
								$(`#enviamail_${response_json.query}`).html('SI');
							}
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
						$(`#estado_${response_json.query}`).css('color', 'white');
						$(`#estado_${response_json.query}`).css('background-color', 'red');
						$(`#estado_${response_json.query}`).html('ERROR');
					}


					$(`#ejecutado_${response_json.query}`).html(response_json.ejecutado);
					$(`#valor_${response_json.query}`).css('color', 'white');
					$(`#valor_${response_json.query}`).css('text-align', 'center');
					$(`#valor_${response_json.query}`).html(response_json.resultado[0].cantidad);
					if (response_json.resultado[0].cantidad >= $(`#umbral_${response_json.query}`).html()) {
						$(`#valor_${response_json.query}`).css('background-color', 'green');
					} else {
						$(`#valor_${response_json.query}`).css('background-color', 'red');
					}


					if (document.getElementById('check_'+`${response_json.query}`).checked == false){
						$(`#enviamail_${response_json.query}`).html('NO');
					}

						
					if ($(`#enviamail_${response_json.query}`).html() == 'SI') {
						$.ajax({
							url: "welcome/email",
							method: "POST",
							data: {
								id: id,
								asunto: 'EMV '+$(`#query_${response_json.query}`).html(),
								estado: $(`#estado_${response_json.query}`).html(),
								reintentos: $(`#reint_${response_json.query}`).html(),
								cuerpo: $(`#comentario_${response_json.query}`).html()
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