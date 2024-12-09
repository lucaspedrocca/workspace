<?php
defined('BASEPATH') or exit('No direct script access allowed');

class Consulta_model extends CI_Model
{

    public function __construct()
    {
        parent::__construct();

//$this->dbSE20 = $this->load->database('default', TRUE);
//var_dump('primer db');die();
//$this->dbSE20 = $this->load->database('SE20', TRUE);
//var_dump('segunda db');die();

	$this->db = $this->load->database('default', TRUE);
	$this->dbSE20 = $this->load->database('SE20', TRUE);
    }

    public function consulta($query_id)
    {
        //return $query_id;

	$cTextoDetPrim = "select case when DATENAME(HOUR, GETDATE())*100+DATENAME(MINUTE, GETDATE()) between 645 and 2330 then count(*) else 100 end as cantidad 
			from (SELECT distinct r.hash, s.line_name, s.station_name 
				FROM records_resumen r with (nolock) 
				inner join sources s on r.source_id = s.id inner join markers m WITH(NOLOCK) ON m.id = r.marker_id 
				where r.source_datetime >= DATEADD(MINUTE, -6, GETDATE()) and r.source_datetime  < GETDATE() and m.line_name = ";
	
	$cTextoDetSeg = " and s.station_name = ";

	$cTextoDetTerc = ") qq";


        $cTextoAsigPrim = "select case when DATENAME(HOUR, GETDATE())*100+DATENAME(MINUTE, GETDATE()) between 645 and 2330 then count(*) else 100 end as cantidad 
			from (select (1*case when AsignacionAutoSale = 1 then 1 else 0 end) as AutoSale 
				from DespachadosDetalles dd 
				left join despachos d on d.IDDespacho = dd.IDDespacho 
				left join ProgramacionesDetalles pd on dd.IDProgramacionDetalle = pd.IDProgramacionDetalle 
				where dd.IDDespacho in (select IDDespacho from despachos where d.idlinea = ";
	
	$cTextoAsigSeg = " and year(d.FechaDespacho)*10000+month(d.FechaDespacho)*100+day(d.FechaDespacho) = year(getdate())*10000+month(getdate())*100+day(getdate())) 
			   and pd.horaSale >= cast(DATEADD(MINUTE, -15, getdate()) as time(3)) and (not dd.IDFormacion is null) and (not dd.HoraSale is null) ) qq";


        $cTextoAsigEstPrim = "select case when DATENAME(HOUR, GETDATE())*100+DATENAME(MINUTE, GETDATE()) between 645 and 2330 then count(*) else 100 end as cantidad 
			from (select d.idlinea, pd.IDEstacionSale, e.estacion, (1*case when dd.AsignacionAutoSale = 1 then 1 else 0 end) as AutoSale 
				from DespachadosDetalles dd 
				left join despachos d on d.IDDespacho = dd.IDDespacho 
				left join ProgramacionesDetalles pd on dd.IDProgramacionDetalle = pd.IDProgramacionDetalle 
				left join Estaciones e on pd.IDEstacionSale = e.IDEstacion 
				where dd.IDDespacho in (select IDDespacho from despachos where d.idlinea = ";

	$cTextoAsigEstSeg = " and pd.IDEstacionSale = ";

	$cTextoAsigEstTerc = " and year(d.FechaDespacho)*10000+month(d.FechaDespacho)*100+day(d.FechaDespacho) = year(getdate())*10000+month(getdate())*100+day(getdate())) and pd.horaSale >= cast(DATEADD(MINUTE, -15, getdate()) as time(3)) 
			       and (not dd.IDFormacion is null) and (not dd.HoraSale is null) ) qq";

        switch ($query_id) {
            case 1:
                $query = $cTextoDetPrim."'A'".$cTextoDetSeg."'PTO'".$cTextoDetTerc;
	        return $this->db->query($query)->result();
                break;
            case 2:
                $query = $cTextoDetPrim."'A'".$cTextoDetSeg."'PMA'".$cTextoDetTerc;
	        return $this->db->query($query)->result();
                break;
            case 3:
                $query = $cTextoDetPrim."'B'".$cTextoDetSeg."'ALM'".$cTextoDetTerc;
	        return $this->db->query($query)->result();
                break;
            case 4:
                $query = $cTextoDetPrim."'B'".$cTextoDetSeg."'ROS'".$cTextoDetTerc;
	        return $this->db->query($query)->result();
                break;
            case 5:
                $query = $cTextoDetPrim."'C'".$cTextoDetSeg."'CON'".$cTextoDetTerc;
	        return $this->db->query($query)->result();
                break;
            case 6:
                $query = $cTextoDetPrim."'C'".$cTextoDetSeg."'RET'".$cTextoDetTerc;
	        return $this->db->query($query)->result();
                break;
            case 7:
                $query = $cTextoDetPrim."'E'".$cTextoDetSeg."'RET'".$cTextoDetTerc;
	        return $this->db->query($query)->result();
                break;
            case 8:
                $query = $cTextoDetPrim."'E'".$cTextoDetSeg."'VIR'".$cTextoDetTerc;
	        return $this->db->query($query)->result();
                break;
            case 9:
                $query = $cTextoDetPrim."'H'".$cTextoDetSeg."'FDE'".$cTextoDetTerc;
	        return $this->db->query($query)->result();
                break;
            case 10:
                $query = $cTextoDetPrim."'H'".$cTextoDetSeg."'HOS'".$cTextoDetTerc;
	        return $this->db->query($query)->result();
                break;
            case 11:
		$query = $cTextoAsigPrim."1".$cTextoAsigSeg;
	        return $this->dbSE20->query($query)->result();
                break;
            case 12:
		$query = $cTextoAsigPrim."3".$cTextoAsigSeg;
	        return $this->dbSE20->query($query)->result();
                break;
            case 13:
		$query = $cTextoAsigPrim."5".$cTextoAsigSeg;
	        return $this->dbSE20->query($query)->result();
                break;
            case 14:
		$query = $cTextoAsigPrim."15".$cTextoAsigSeg;
	        return $this->dbSE20->query($query)->result();
                break;
            case 15:
                $query = $cTextoAsigEstPrim."1".$cTextoAsigEstSeg."99".$cTextoAsigEstTerc;
	        return $this->dbSE20->query($query)->result();
                break;
            case 16:
                $query = $cTextoAsigEstPrim."1".$cTextoAsigEstSeg."17".$cTextoAsigEstTerc;
	        return $this->dbSE20->query($query)->result();
                break;
            case 17:
                $query = $cTextoAsigEstPrim."3".$cTextoAsigEstSeg."24".$cTextoAsigEstTerc;
	        return $this->dbSE20->query($query)->result();
                break;
            case 18:
                $query = $cTextoAsigEstPrim."3".$cTextoAsigEstSeg."23".$cTextoAsigEstTerc;
	        return $this->dbSE20->query($query)->result();
                break;
            case 19:
                $query = $cTextoAsigEstPrim."5".$cTextoAsigEstSeg."117".$cTextoAsigEstTerc;
	        return $this->dbSE20->query($query)->result();
                break;
            case 20:
                $query = $cTextoAsigEstPrim."5".$cTextoAsigEstSeg."26".$cTextoAsigEstTerc;
	        return $this->dbSE20->query($query)->result();
                break;
            case 21:
                $query = $cTextoAsigEstPrim."15".$cTextoAsigEstSeg."113".$cTextoAsigEstTerc;
	        return $this->dbSE20->query($query)->result();
                break;
            case 22:
                $query = $cTextoAsigEstPrim."15".$cTextoAsigEstSeg."107".$cTextoAsigEstTerc;
	        return $this->dbSE20->query($query)->result();
                break;
            case 23:
                $query = "select case when DATENAME(HOUR, GETDATE())*100+DATENAME(MINUTE, GETDATE()) between 645 and 2330 then count(*)*(-1) else 100 end as cantidad 
			from (
			select IDLinea, FechaDespacho, HoraSale, Formacion, count(*) as cantidad
			from (
				select d.IDLinea, d.FechaDespacho, dd.HoraSale, f.nombre as Formacion 
				from DespachadosDetalles dd 
				left join despachos d on d.IDDespacho = dd.IDDespacho 
				left join ProgramacionesDetalles pd on dd.IDProgramacionDetalle = pd.IDProgramacionDetalle 
				left join Formaciones f on dd.IDFormacion = f.IDFormacion
				where dd.IDDespacho in (select IDDespacho from despachos  
							where year(d.FechaDespacho)*10000+month(d.FechaDespacho)*100+day(d.FechaDespacho) = year(getdate())*10000+month(getdate())*100+day(getdate())
							)
				and (not dd.IDFormacion is null) and (not dd.HoraSale is null) 
				) qq
				group by IDLinea, FechaDespacho, HoraSale, Formacion
				having count(*) > 1
				) qqq";
	        return $this->dbSE20->query($query)->result();
                break;
        }
 //       return $this->db->query($query)->result();
    }
}
