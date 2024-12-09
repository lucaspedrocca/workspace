<?php
defined('BASEPATH') or exit('No direct script access allowed');

class Welcome extends CI_Controller
{
	private $config_email;
	private $config_from_email;
	private $config_from_name;
	private $config_to;
	public function __construct()
	{
		parent::__construct();
		date_default_timezone_set('America/Argentina/Buenos_Aires');
		$this->load->library('email');
		$this->config_email = array(
			'protocol' => 'smtp',
			'smtp_host' => 'mail.soportetecnico-pc.com',
			'smtp_user' => 'nmeseri@soportetecnico-pc.com',
			'smtp_pass' => 'Moorea5458',
			'smtp_port' => 587,
			'smtp_crypto' => 'STARTTLS',
			'charset' => 'utf-8',
			'wordwrap' => TRUE,
			'mailtype' => 'html',
			'newline' => "\r\n"
		);

		$this->config_from_email = "nmeseri@soportetecnico-pc.com";
		$this->config_from_name = "Mail Automatico Monitoreo";
		$this->config_to = "vmeseri@gmail.com, vmeseri@grupoprominente.com";
	}

	public function index()
	{
		/**
		 * name= titulo de la consulta,
		 * query= id de query a consultar en el modelo
		 * intervalo = valor en minutos, indica cada x minutos se va a ejecutar la query.
		 * 
		 */

		/*echo date('l, d M Y');*/
		/*$dias = array("Domingo","Lunes","Martes","Miercoles","Jueves","Viernes","Sábado");*/
		/*echo $dias[date('w')+1] ;*/
		/*echo date('w') ;*/

		/*if ((date('w') >= 1) and (date('w') <= 5))
		{*/
						
			$data['consultas'] = [
			['name' => 'Linea A - PTO', 'query' => 1,'intervalo'=>2,'umbral'=>1,'aviso'=>2,'check'=>'SI','comentario'=>'Detecciones'],
			['name' => 'Linea A - PMA', 'query' => 2,'intervalo'=>2,'umbral'=>1,'aviso'=>2,'check'=>'SI','comentario'=>'Detecciones'],
			['name' => 'Linea B - ALM', 'query' => 3,'intervalo'=>2,'umbral'=>1,'aviso'=>2,'check'=>'SI','comentario'=>'Detecciones'],
			['name' => 'Linea B - ROS', 'query' => 4,'intervalo'=>2,'umbral'=>1,'aviso'=>2,'check'=>'SI','comentario'=>'Detecciones'],
			['name' => 'Linea C - CON', 'query' => 5,'intervalo'=>2,'umbral'=>1,'aviso'=>2,'check'=>'SI','comentario'=>'Detecciones'],
			['name' => 'Linea C - RET', 'query' => 6,'intervalo'=>2,'umbral'=>1,'aviso'=>2,'check'=>'SI','comentario'=>'Detecciones'],
			['name' => 'Linea D - COT', 'query' => 7,'intervalo'=>2,'umbral'=>1,'aviso'=>2,'check'=>'SI','comentario'=>'Detecciones'],
			['name' => 'Linea D - CAT', 'query' => 8,'intervalo'=>2,'umbral'=>1,'aviso'=>2,'check'=>'SI','comentario'=>'Detecciones'],
			['name' => 'Linea E - RET', 'query' => 9,'intervalo'=>2,'umbral'=>1,'aviso'=>2,'check'=>'SI','comentario'=>'Detecciones'],
			['name' => 'Linea E - VIR', 'query' => 10,'intervalo'=>2,'umbral'=>1,'aviso'=>2,'check'=>'SI','comentario'=>'Detecciones'],
			['name' => 'Linea H - FDE', 'query' => 11,'intervalo'=>2,'umbral'=>1,'aviso'=>2,'check'=>'SI','comentario'=>'Detecciones'],
			['name' => 'Linea H - HOS', 'query' => 12,'intervalo'=>2,'umbral'=>1,'aviso'=>2,'check'=>'SI','comentario'=>'Detecciones'],
		//	['name' => 'C.Linea A', 'query' => 11,'intervalo'=>2,'umbral'=>3,'aviso'=>5,'check'=>'NO','comentario'=>'Asignaciones'],
		//	['name' => 'C.Linea C', 'query' => 12,'intervalo'=>2,'umbral'=>3,'aviso'=>5,'check'=>'NO','comentario'=>'Asignaciones'],
		//	['name' => 'C.Linea E', 'query' => 13,'intervalo'=>2,'umbral'=>3,'aviso'=>5,'check'=>'NO','comentario'=>'Asignaciones'],
		//	['name' => 'C.Linea H', 'query' => 14,'intervalo'=>2,'umbral'=>3,'aviso'=>3,'check'=>'SI','comentario'=>'Asignaciones'],
			['name' => 'Cam.A - PTO', 'query' => 13,'intervalo'=>2,'umbral'=>1,'aviso'=>5,'check'=>'NO','comentario'=>'Asignaciones x Estacion'],
			['name' => 'Cam.A - PMA', 'query' => 14,'intervalo'=>2,'umbral'=>1,'aviso'=>5,'check'=>'NO','comentario'=>'Asignaciones x Estacion'],
			['name' => 'Cam.B - ALM', 'query' => 15,'intervalo'=>2,'umbral'=>1,'aviso'=>5,'check'=>'NO','comentario'=>'Asignaciones x Estacion'],
			['name' => 'Cam.B - ROS', 'query' => 16,'intervalo'=>2,'umbral'=>1,'aviso'=>5,'check'=>'NO','comentario'=>'Asignaciones x Estacion'],
			['name' => 'Cam.C - CON', 'query' => 17,'intervalo'=>2,'umbral'=>1,'aviso'=>5,'check'=>'NO','comentario'=>'Asignaciones x Estacion'],
			['name' => 'Cam.C - RET', 'query' => 18,'intervalo'=>2,'umbral'=>1,'aviso'=>5,'check'=>'NO','comentario'=>'Asignaciones x Estacion'],
			['name' => 'Cam.D - COT', 'query' => 19,'intervalo'=>2,'umbral'=>1,'aviso'=>5,'check'=>'NO','comentario'=>'Asignaciones x Estacion'],
			['name' => 'Cam.D - CAT', 'query' => 20,'intervalo'=>2,'umbral'=>1,'aviso'=>5,'check'=>'NO','comentario'=>'Asignaciones x Estacion'],
			['name' => 'Cam.E - RET', 'query' => 21,'intervalo'=>2,'umbral'=>1,'aviso'=>5,'check'=>'NO','comentario'=>'Asignaciones x Estacion'],
			['name' => 'Cam.E - VIR', 'query' => 22,'intervalo'=>2,'umbral'=>1,'aviso'=>5,'check'=>'NO','comentario'=>'Asignaciones x Estacion'],
			['name' => 'Cam.H - FDE', 'query' => 23,'intervalo'=>2,'umbral'=>1,'aviso'=>3,'check'=>'NO','comentario'=>'Asignaciones x Estacion'],
			['name' => 'Cam.H - HOS', 'query' => 24,'intervalo'=>2,'umbral'=>1,'aviso'=>3,'check'=>'NO','comentario'=>'Asignaciones x Estacion'],
			['name' => 'Duplicadas', 'query' => 25,'intervalo'=>60,'umbral'=>0,'aviso'=>1,'check'=>'SI','comentario'=>'Duplicadas'],
			['name' => 'Detecciones sin Procesar', 'query' => 26,'intervalo'=>2,'umbral'=>0,'aviso'=>3,'check'=>'SI','comentario'=>'Detecciones sin Procesar'],
			['name' => 'Frames Detecciones', 'query' => 27,'intervalo'=>2,'umbral'=>1,'aviso'=>2,'check'=>'SI','comentario'=>'Frame de Detecciones'],
			['name' => 'Desplazamientos', 'query' => 28,'intervalo'=>5,'umbral'=>0,'aviso'=>1,'check'=>'SI','comentario'=>'Desplazamientos de registros'],
			['name' => 'DWH_SE20', 'query' => 29,'intervalo'=>60,'umbral'=>1,'aviso'=>1,'check'=>'SI','comentario'=>'DWH SE 2.0'],
			['name' => 'DWH_TYF - Legajos', 'query' => 30,'intervalo'=>30,'umbral'=>1,'aviso'=>1,'check'=>'SI','comentario'=>'Turnos y fichadas - Legajos'],
			['name' => 'DWH_TYF - Fichadas', 'query' => 31,'intervalo'=>30,'umbral'=>1,'aviso'=>1,'check'=>'SI','comentario'=>'Turnos y fichadas - Fichadas'],
			['name' => 'DWH_TYF - Turnos', 'query' => 32,'intervalo'=>30,'umbral'=>1,'aviso'=>1,'check'=>'SI','comentario'=>'Turnos y fichadas - Turnos'],
			['name' => 'Resumen vs Reportes', 'query' => 33,'intervalo'=>60,'umbral'=>0,'aviso'=>1,'check'=>'SI','comentario'=>'Resumen vs reportes']
			];

		$this->load->view('welcome_message', $data);
	}

	public function consulta()
	{
		$this->load->model('Consulta_model');
		echo json_encode(
			[
				'query' => $this->input->post('id'),
				'ejecutado' => date('d-m-Y H:i:s'),
				'resultado' => $this->Consulta_model->consulta($this->input->post('id')),
				'resultadodetalle' => $this->Consulta_model->consultadetalle($this->input->post('id')),
				//'resultado' => [['cantidad'=>0]],
			]
		);
	}

	public function email()
	{
		$this->email->initialize($this->config_email);
		$this->email->from($this->config_from_email,$this->config_from_name);
		$this->email->to($this->config_to);

//		switch ($this->input->post('id')) {
//			case 1:
//				$this->email->subject('Asunto del Correo Q1-A');
//				$this->email->message('Este es el contenido del correo.');
//				break;
//			case 2:
//				$this->email->subject('que tal?'.$this->input->post('asunto'));
//				$this->email->message('Este es el contenido del correo.');
//				break;
//			case 3:
//				$this->email->subject('Asunto del Correo Q3-E');
//				$this->email->message('Este es el contenido del correo.');
//				break;
//			case 4:
//				$this->email->subject('Asunto del Correo Q4-H');
//				$this->email->message('Este es el contenido del correo.');
//				break;
//		}

		$this->email->subject($this->input->post('asunto').' / '.$this->input->post('estado').' R: '.$this->input->post('reintentos'));
		$this->email->message($this->input->post('cuerpo'));

		// Enviar el correo electrónico
		if ($this->email->send()) {
			echo json_encode(
				['message' => 'Correo electrónico enviado exitosamente.']
			);
		} else {
			echo json_encode(
				['message' => 'Error al enviar el correo electrónico: ' . $this->email->print_debugger()]
			);
		}
	}
}
