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
//		$this->config_to = "vmeseri@gmail.com, vmeseri@grupoprominente.com";
		$this->config_to = "vmeseri@gmail.com";
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
			['name' => 'Linea A - PTO', 'query' => 1,'intervalo'=>2/*4*/,'umbral'=>1,'comentario'=>'detecciones'],
			['name' => 'Linea A - PMA', 'query' => 2,'intervalo'=>2,'umbral'=>1,'comentario'=>'detecciones'],
			['name' => 'Linea C - CON', 'query' => 3,'intervalo'=>2/*4*/,'umbral'=>1,'comentario'=>'detecciones'],
			['name' => 'Linea C - RET', 'query' => 4,'intervalo'=>2/*3*/,'umbral'=>1,'comentario'=>'detecciones'],
			['name' => 'Linea E - RET', 'query' => 5,'intervalo'=>2,'umbral'=>1,'comentario'=>'detecciones'],
			['name' => 'Linea E - VIR', 'query' => 6,'intervalo'=>2/*3*/,'umbral'=>1,'comentario'=>'detecciones'],
			['name' => 'Linea H - FDE', 'query' => 7,'intervalo'=>2/*3*/,'umbral'=>1,'comentario'=>'detecciones'],
			['name' => 'Linea H - HOS', 'query' => 8,'intervalo'=>2/*3*/,'umbral'=>1,'comentario'=>'detecciones'],
			['name' => 'C.Linea A', 'query' => 9,'intervalo'=>2,'umbral'=>3,'comentario'=>'asignaciones'],
			['name' => 'C.Linea C', 'query' => 10,'intervalo'=>2,'umbral'=>3,'comentario'=>'asignaciones'],
			['name' => 'C.Linea E', 'query' => 11,'intervalo'=>2,'umbral'=>3,'comentario'=>'asignaciones'],
			['name' => 'C.Linea H', 'query' => 12,'intervalo'=>2,'umbral'=>3,'comentario'=>'asignaciones'],
			['name' => 'Cam.A - PTO', 'query' => 13,'intervalo'=>2,'umbral'=>1,'comentario'=>'asignaciones x estacion'],
			['name' => 'Cam.A - PMA', 'query' => 14,'intervalo'=>2,'umbral'=>1,'comentario'=>'asignaciones x estacion'],
			['name' => 'Cam.C - CON', 'query' => 15,'intervalo'=>2,'umbral'=>1,'comentario'=>'asignaciones x estacion'],
			['name' => 'Cam.C - RET', 'query' => 16,'intervalo'=>2,'umbral'=>1,'comentario'=>'asignaciones x estacion'],
			['name' => 'Cam.E - RET', 'query' => 17,'intervalo'=>2,'umbral'=>1,'comentario'=>'asignaciones x estacion'],
			['name' => 'Cam.E - VIR', 'query' => 18,'intervalo'=>2,'umbral'=>1,'comentario'=>'asignaciones x estacion'],
			['name' => 'Cam.H - FDE', 'query' => 19,'intervalo'=>2,'umbral'=>1,'comentario'=>'asignaciones x estacion'],
			['name' => 'Cam.H - HOS', 'query' => 20,'intervalo'=>2,'umbral'=>1,'comentario'=>'asignaciones x estacion']
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
			//	'resultado' => [['cantidad'=>0]],
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
//		$this->email->message('Este es el contenido del correo.');

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
