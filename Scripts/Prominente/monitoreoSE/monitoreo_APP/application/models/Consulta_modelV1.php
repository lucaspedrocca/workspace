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
        switch ($query_id) {
            case 1:
                $query = "select case when DATENAME(HOUR, GETDATE()) between 6 and 23 then count(*) else 100 end as cantidad from (SELECT distinct r.hash, s.line_name, s.station_name FROM records_resumen r with (nolock) inner join sources s on r.source_id = s.id inner join markers m WITH(NOLOCK) ON m.id = r.marker_id where r.source_datetime >= DATEADD(MINUTE, -7, GETDATE()) and r.source_datetime  < GETDATE() and m.line_name = 'A' and s.station_name = 'PTO') qq --group by qq.station_name";
	        return $this->db->query($query)->result();
                break;
            case 2:
                $query = "select case when DATENAME(HOUR, GETDATE()) between 6 and 23 then count(*) else 100 end as cantidad from (SELECT distinct r.hash, s.line_name, s.station_name FROM records_resumen r with (nolock) inner join sources s on r.source_id = s.id inner join markers m WITH(NOLOCK) ON m.id = r.marker_id where r.source_datetime >= DATEADD(MINUTE, -7, GETDATE()) and r.source_datetime  < GETDATE() and m.line_name = 'A' and s.station_name = 'PMA') qq --group by qq.station_name";
	        return $this->db->query($query)->result();
                break;
            case 3:
                $query = "select case when DATENAME(HOUR, GETDATE()) between 6 and 23 then count(*) else 100 end as cantidad from (SELECT distinct r.hash, s.line_name, s.station_name FROM records_resumen r with (nolock) inner join sources s on r.source_id = s.id inner join markers m WITH(NOLOCK) ON m.id = r.marker_id where r.source_datetime >= DATEADD(MINUTE, -7, GETDATE()) and r.source_datetime  < GETDATE() and m.line_name = 'C' and s.station_name = 'CON') qq --group by qq.station_name";
	        return $this->db->query($query)->result();
                break;
            case 4:
                $query = "select case when DATENAME(HOUR, GETDATE()) between 6 and 23 then count(*) else 100 end as cantidad from (SELECT distinct r.hash, s.line_name, s.station_name FROM records_resumen r with (nolock) inner join sources s on r.source_id = s.id inner join markers m WITH(NOLOCK) ON m.id = r.marker_id where r.source_datetime >= DATEADD(MINUTE, -7, GETDATE()) and r.source_datetime  < GETDATE() and m.line_name = 'C' and s.station_name = 'RET') qq --group by qq.station_name";
	        return $this->db->query($query)->result();
                break;
            case 5:
                $query = "select case when DATENAME(HOUR, GETDATE()) between 6 and 23 then count(*) else 100 end as cantidad from (SELECT distinct r.hash, s.line_name, s.station_name FROM records_resumen r with (nolock) inner join sources s on r.source_id = s.id inner join markers m WITH(NOLOCK) ON m.id = r.marker_id where r.source_datetime >= DATEADD(MINUTE, -7, GETDATE()) and r.source_datetime  < GETDATE() and m.line_name = 'E' and s.station_name = 'RET') qq --group by qq.station_name";
	        return $this->db->query($query)->result();
                break;
            case 6:
                $query = "select case when DATENAME(HOUR, GETDATE()) between 6 and 23 then count(*) else 100 end as cantidad from (SELECT distinct r.hash, s.line_name, s.station_name FROM records_resumen r with (nolock) inner join sources s on r.source_id = s.id inner join markers m WITH(NOLOCK) ON m.id = r.marker_id where r.source_datetime >= DATEADD(MINUTE, -7, GETDATE()) and r.source_datetime  < GETDATE() and m.line_name = 'E' and s.station_name = 'VIR') qq --group by qq.station_name";
	        return $this->db->query($query)->result();
                break;
            case 7:
                $query = "select case when DATENAME(HOUR, GETDATE()) between 6 and 23 then count(*) else 100 end as cantidad from (SELECT distinct r.hash, s.line_name, s.station_name FROM records_resumen r with (nolock) inner join sources s on r.source_id = s.id inner join markers m WITH(NOLOCK) ON m.id = r.marker_id where r.source_datetime >= DATEADD(MINUTE, -7, GETDATE()) and r.source_datetime  < GETDATE() and m.line_name = 'H' and s.station_name = 'FDE') qq --group by qq.station_name";
	        return $this->db->query($query)->result();
                break;
            case 8:
                $query = "select case when DATENAME(HOUR, GETDATE()) between 6 and 23 then count(*) else 100 end as cantidad from (SELECT distinct r.hash, s.line_name, s.station_name FROM records_resumen r with (nolock) inner join sources s on r.source_id = s.id inner join markers m WITH(NOLOCK) ON m.id = r.marker_id where r.source_datetime >= DATEADD(MINUTE, -7, GETDATE()) and r.source_datetime  < GETDATE() and m.line_name = 'H' and s.station_name = 'HOS') qq --group by qq.station_name";
	        return $this->db->query($query)->result();
                break;
            case 9:
                $query = "select case when DATENAME(HOUR, GETDATE()) between 6 and 23 then count(*) else 100 end as cantidad from (select (1*case when AsignacionAutoSale = 1 then 1 else 0 end) as AutoSale from DespachadosDetalles dd left join despachos d on d.IDDespacho = dd.IDDespacho left join ProgramacionesDetalles pd on dd.IDProgramacionDetalle = pd.IDProgramacionDetalle where dd.IDDespacho in (select IDDespacho from despachos where d.idlinea = 1 and year(d.FechaDespacho)*10000+month(d.FechaDespacho)*100+day(d.FechaDespacho) = year(getdate())*10000+month(getdate())*100+day(getdate())) and pd.horaSale >= cast(DATEADD(MINUTE, -15, getdate()) as time(3)) and (not dd.IDFormacion is null) and (not dd.HoraSale is null) ) qq";
	        return $this->dbSE20->query($query)->result();
                break;
            case 10:
                $query = "select case when DATENAME(HOUR, GETDATE()) between 6 and 23 then count(*) else 100 end as cantidad from (select (1*case when AsignacionAutoSale = 1 then 1 else 0 end) as AutoSale from DespachadosDetalles dd left join despachos d on d.IDDespacho = dd.IDDespacho left join ProgramacionesDetalles pd on dd.IDProgramacionDetalle = pd.IDProgramacionDetalle where dd.IDDespacho in (select IDDespacho from despachos where d.idlinea = 3 and year(d.FechaDespacho)*10000+month(d.FechaDespacho)*100+day(d.FechaDespacho) = year(getdate())*10000+month(getdate())*100+day(getdate())) and pd.horaSale >= cast(DATEADD(MINUTE, -15, getdate()) as time(3)) and (not dd.IDFormacion is null) and (not dd.HoraSale is null) ) qq";
	        return $this->dbSE20->query($query)->result();
                break;
            case 11:
                $query = "select case when DATENAME(HOUR, GETDATE()) between 6 and 23 then count(*) else 100 end as cantidad from (select (1*case when AsignacionAutoSale = 1 then 1 else 0 end) as AutoSale from DespachadosDetalles dd left join despachos d on d.IDDespacho = dd.IDDespacho left join ProgramacionesDetalles pd on dd.IDProgramacionDetalle = pd.IDProgramacionDetalle where dd.IDDespacho in (select IDDespacho from despachos where d.idlinea = 5 and year(d.FechaDespacho)*10000+month(d.FechaDespacho)*100+day(d.FechaDespacho) = year(getdate())*10000+month(getdate())*100+day(getdate())) and pd.horaSale >= cast(DATEADD(MINUTE, -15, getdate()) as time(3)) and (not dd.IDFormacion is null) and (not dd.HoraSale is null) ) qq";
	        return $this->dbSE20->query($query)->result();
                break;
            case 12:
                $query = "select case when DATENAME(HOUR, GETDATE()) between 6 and 23 then count(*) else 100 end as cantidad from (select (1*case when AsignacionAutoSale = 1 then 1 else 0 end) as AutoSale from DespachadosDetalles dd left join despachos d on d.IDDespacho = dd.IDDespacho left join ProgramacionesDetalles pd on dd.IDProgramacionDetalle = pd.IDProgramacionDetalle where dd.IDDespacho in (select IDDespacho from despachos where d.idlinea = 15 and year(d.FechaDespacho)*10000+month(d.FechaDespacho)*100+day(d.FechaDespacho) = year(getdate())*10000+month(getdate())*100+day(getdate())) and pd.horaSale >= cast(DATEADD(MINUTE, -15, getdate()) as time(3)) and (not dd.IDFormacion is null) and (not dd.HoraSale is null) ) qq";
	        return $this->dbSE20->query($query)->result();
                break;
            case 13:
                $query = "select case when DATENAME(HOUR, GETDATE()) between 6 and 23 then count(*) else 100 end as cantidad from (select d.idlinea, pd.IDEstacionSale, e.estacion, (1*case when dd.AsignacionAutoSale = 1 then 1 else 0 end) as AutoSale from DespachadosDetalles dd left join despachos d on d.IDDespacho = dd.IDDespacho left join ProgramacionesDetalles pd on dd.IDProgramacionDetalle = pd.IDProgramacionDetalle left join Estaciones e on pd.IDEstacionSale = e.IDEstacion where dd.IDDespacho in (select IDDespacho from despachos where d.idlinea = 1 and pd.IDEstacionSale = 99 and year(d.FechaDespacho)*10000+month(d.FechaDespacho)*100+day(d.FechaDespacho) = year(getdate())*10000+month(getdate())*100+day(getdate())) and pd.horaSale >= cast(DATEADD(MINUTE, -15, getdate()) as time(3)) and (not dd.IDFormacion is null) and (not dd.HoraSale is null) ) qq";
	        return $this->dbSE20->query($query)->result();
                break;
            case 14:
                $query = "select case when DATENAME(HOUR, GETDATE()) between 6 and 23 then count(*) else 100 end as cantidad from (select d.idlinea, pd.IDEstacionSale, e.estacion, (1*case when dd.AsignacionAutoSale = 1 then 1 else 0 end) as AutoSale from DespachadosDetalles dd left join despachos d on d.IDDespacho = dd.IDDespacho left join ProgramacionesDetalles pd on dd.IDProgramacionDetalle = pd.IDProgramacionDetalle left join Estaciones e on pd.IDEstacionSale = e.IDEstacion where dd.IDDespacho in (select IDDespacho from despachos where d.idlinea = 1 and pd.IDEstacionSale = 17 and year(d.FechaDespacho)*10000+month(d.FechaDespacho)*100+day(d.FechaDespacho) = year(getdate())*10000+month(getdate())*100+day(getdate())) and pd.horaSale >= cast(DATEADD(MINUTE, -15, getdate()) as time(3)) and (not dd.IDFormacion is null) and (not dd.HoraSale is null) ) qq";
	        return $this->dbSE20->query($query)->result();
                break;
            case 15:
                $query = "select case when DATENAME(HOUR, GETDATE()) between 6 and 23 then count(*) else 100 end as cantidad from (select d.idlinea, pd.IDEstacionSale, e.estacion, (1*case when dd.AsignacionAutoSale = 1 then 1 else 0 end) as AutoSale from DespachadosDetalles dd left join despachos d on d.IDDespacho = dd.IDDespacho left join ProgramacionesDetalles pd on dd.IDProgramacionDetalle = pd.IDProgramacionDetalle left join Estaciones e on pd.IDEstacionSale = e.IDEstacion where dd.IDDespacho in (select IDDespacho from despachos where d.idlinea = 3 and pd.IDEstacionSale = 24 and year(d.FechaDespacho)*10000+month(d.FechaDespacho)*100+day(d.FechaDespacho) = year(getdate())*10000+month(getdate())*100+day(getdate())) and pd.horaSale >= cast(DATEADD(MINUTE, -15, getdate()) as time(3)) and (not dd.IDFormacion is null) and (not dd.HoraSale is null) ) qq";
	        return $this->dbSE20->query($query)->result();
                break;
            case 16:
                $query = "select case when DATENAME(HOUR, GETDATE()) between 6 and 23 then count(*) else 100 end as cantidad from (select d.idlinea, pd.IDEstacionSale, e.estacion, (1*case when dd.AsignacionAutoSale = 1 then 1 else 0 end) as AutoSale from DespachadosDetalles dd left join despachos d on d.IDDespacho = dd.IDDespacho left join ProgramacionesDetalles pd on dd.IDProgramacionDetalle = pd.IDProgramacionDetalle left join Estaciones e on pd.IDEstacionSale = e.IDEstacion where dd.IDDespacho in (select IDDespacho from despachos where d.idlinea = 3 and pd.IDEstacionSale = 23 and year(d.FechaDespacho)*10000+month(d.FechaDespacho)*100+day(d.FechaDespacho) = year(getdate())*10000+month(getdate())*100+day(getdate())) and pd.horaSale >= cast(DATEADD(MINUTE, -15, getdate()) as time(3)) and (not dd.IDFormacion is null) and (not dd.HoraSale is null) ) qq";
	        return $this->dbSE20->query($query)->result();
                break;
            case 17:
                $query = "select case when DATENAME(HOUR, GETDATE()) between 6 and 23 then count(*) else 100 end as cantidad from (select d.idlinea, pd.IDEstacionSale, e.estacion, (1*case when dd.AsignacionAutoSale = 1 then 1 else 0 end) as AutoSale from DespachadosDetalles dd left join despachos d on d.IDDespacho = dd.IDDespacho left join ProgramacionesDetalles pd on dd.IDProgramacionDetalle = pd.IDProgramacionDetalle left join Estaciones e on pd.IDEstacionSale = e.IDEstacion where dd.IDDespacho in (select IDDespacho from despachos where d.idlinea = 5 and pd.IDEstacionSale = 117 and year(d.FechaDespacho)*10000+month(d.FechaDespacho)*100+day(d.FechaDespacho) = year(getdate())*10000+month(getdate())*100+day(getdate())) and pd.horaSale >= cast(DATEADD(MINUTE, -15, getdate()) as time(3)) and (not dd.IDFormacion is null) and (not dd.HoraSale is null) ) qq";
	        return $this->dbSE20->query($query)->result();
                break;
            case 18:
                $query = "select case when DATENAME(HOUR, GETDATE()) between 6 and 23 then count(*) else 100 end as cantidad from (select d.idlinea, pd.IDEstacionSale, e.estacion, (1*case when dd.AsignacionAutoSale = 1 then 1 else 0 end) as AutoSale from DespachadosDetalles dd left join despachos d on d.IDDespacho = dd.IDDespacho left join ProgramacionesDetalles pd on dd.IDProgramacionDetalle = pd.IDProgramacionDetalle left join Estaciones e on pd.IDEstacionSale = e.IDEstacion where dd.IDDespacho in (select IDDespacho from despachos where d.idlinea = 5 and pd.IDEstacionSale = 26 and year(d.FechaDespacho)*10000+month(d.FechaDespacho)*100+day(d.FechaDespacho) = year(getdate())*10000+month(getdate())*100+day(getdate())) and pd.horaSale >= cast(DATEADD(MINUTE, -15, getdate()) as time(3)) and (not dd.IDFormacion is null) and (not dd.HoraSale is null) ) qq";
	        return $this->dbSE20->query($query)->result();
                break;
            case 19:
                $query = "select case when DATENAME(HOUR, GETDATE()) between 6 and 23 then count(*) else 100 end as cantidad from (select d.idlinea, pd.IDEstacionSale, e.estacion, (1*case when dd.AsignacionAutoSale = 1 then 1 else 0 end) as AutoSale from DespachadosDetalles dd left join despachos d on d.IDDespacho = dd.IDDespacho left join ProgramacionesDetalles pd on dd.IDProgramacionDetalle = pd.IDProgramacionDetalle left join Estaciones e on pd.IDEstacionSale = e.IDEstacion where dd.IDDespacho in (select IDDespacho from despachos where d.idlinea = 15 and pd.IDEstacionSale = 113 and year(d.FechaDespacho)*10000+month(d.FechaDespacho)*100+day(d.FechaDespacho) = year(getdate())*10000+month(getdate())*100+day(getdate())) and pd.horaSale >= cast(DATEADD(MINUTE, -15, getdate()) as time(3)) and (not dd.IDFormacion is null) and (not dd.HoraSale is null) ) qq";
	        return $this->dbSE20->query($query)->result();
                break;
            case 20:
                $query = "select case when DATENAME(HOUR, GETDATE()) between 6 and 23 then count(*) else 100 end as cantidad from (select d.idlinea, pd.IDEstacionSale, e.estacion, (1*case when dd.AsignacionAutoSale = 1 then 1 else 0 end) as AutoSale from DespachadosDetalles dd left join despachos d on d.IDDespacho = dd.IDDespacho left join ProgramacionesDetalles pd on dd.IDProgramacionDetalle = pd.IDProgramacionDetalle left join Estaciones e on pd.IDEstacionSale = e.IDEstacion where dd.IDDespacho in (select IDDespacho from despachos where d.idlinea = 15 and pd.IDEstacionSale = 107 and year(d.FechaDespacho)*10000+month(d.FechaDespacho)*100+day(d.FechaDespacho) = year(getdate())*10000+month(getdate())*100+day(getdate())) and pd.horaSale >= cast(DATEADD(MINUTE, -15, getdate()) as time(3)) and (not dd.IDFormacion is null) and (not dd.HoraSale is null) ) qq";
	        return $this->dbSE20->query($query)->result();
                break;
        }
 //       return $this->db->query($query)->result();
    }
}
