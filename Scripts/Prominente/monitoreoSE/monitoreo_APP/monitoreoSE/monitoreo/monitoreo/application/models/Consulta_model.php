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
	$this->dbDWH_SE20 = $this->load->database('DWH_SE20', TRUE);
	$this->dbDWH_TYF = $this->load->database('DWH_TYF', TRUE);
    }

    public function consulta($query_id)
    {
        //return $query_id;

	$HoraInicioSab = "645";
	$HoraInicioDom = "845";
	$HoraInicio = "645";
	$HoraFinSab = "2320";
	$HoraFinDom = "2220";
	$HoraFin = "2300";
	$ControlDet = "7";
	$ControlAsig = "15";

	$dias = array("Domingo","Lunes","Martes","Miercoles","Jueves","Viernes","Sábado");
	if ((date('w') < 1) or (date('w') > 5)) {
		$HoraInicio = "700";
		$HoraFin = "2250";
		$ControlDet = "8";
	}

	$cQueryDetAux = "select case when datepart(weekday, getdate()) between 2 and 6 then
	        		     case when DATENAME(HOUR, GETDATE())*100+DATENAME(MINUTE, GETDATE()) between HORAINICIO and HORAFIN then count(*) else 100 end
	   			else case when datepart(weekday, getdate()) = 7 then 
  	                                  case when DATENAME(HOUR, GETDATE())*100+DATENAME(MINUTE, GETDATE()) between HORAINICIOSAB and HORAFINSAB then count(*) else 100 end
				     else case when DATENAME(HOUR, GETDATE())*100+DATENAME(MINUTE, GETDATE()) between HORAINICIODOM and HORAFINDOM then count(*) else 100 end
			             end
	   		        end as cantidad 
			from (SELECT distinct r.hash, s.line_name, s.station_name 
				FROM records_resumen r with (nolock) 
				inner join sources s with (nolock) on r.source_id = s.id 
				inner join markers m with (nolock) ON m.id = r.marker_id 
				where r.source_datetime >= DATEADD(MINUTE, -CONTROLDET, GETDATE()) and r.source_datetime  < GETDATE() 
				and m.line_name = LINENAME and s.station_name = STATIONNAME
			) qq";


	$cQueryAsigAux = "select case when datepart(weekday, getdate()) between 2 and 6 then
	        		      case when DATENAME(HOUR, GETDATE())*100+DATENAME(MINUTE, GETDATE()) between HORAINICIO and HORAFIN then count(*) else 100 end
	   			 else case when datepart(weekday, getdate()) = 7 then 
  	                                 100 -- case when DATENAME(HOUR, GETDATE())*100+DATENAME(MINUTE, GETDATE()) between HORAINICIOSAB and HORAFINSAB then count(*) else 100 end
				      else 100 -- case when DATENAME(HOUR, GETDATE())*100+DATENAME(MINUTE, GETDATE()) between HORAINICIODOM and HORAFINDOM then count(*) else 100 end
			              end
	   		         end as cantidad 
			from (select (1*case when AsignacionAutoSale = 1 then 1 else 0 end) as AutoSale 
				from DespachadosDetalles dd with (nolock)
				left join despachos d with (nolock) on d.IDDespacho = dd.IDDespacho 
				left join ProgramacionesDetalles pd with (nolock) on dd.IDProgramacionDetalle = pd.IDProgramacionDetalle 
				where dd.IDDespacho in (select IDDespacho from despachos with (nolock) where d.idlinea = IDLINEA
			 	and year(d.FechaDespacho)*10000+month(d.FechaDespacho)*100+day(d.FechaDespacho) = year(getdate())*10000+month(getdate())*100+day(getdate())) 
			   	and pd.horaSale >= cast(DATEADD(MINUTE, -CONTROLASIG, getdate()) as time(3)) and (not dd.IDFormacion is null) and (not dd.HoraSale is null) ) qq";

        $cQueryAsigEstAux = "select case when datepart(weekday, getdate()) between 2 and 6 then
	        		     case when DATENAME(HOUR, GETDATE())*100+DATENAME(MINUTE, GETDATE()) between HORAINICIO and HORAFIN then count(*) else 100 end
	   			else case when datepart(weekday, getdate()) = 7 then 
  	                               100 --   case when DATENAME(HOUR, GETDATE())*100+DATENAME(MINUTE, GETDATE()) between HORAINICIOSAB and HORAFINSAB then count(*) else 100 end
				     else 100 -- case when DATENAME(HOUR, GETDATE())*100+DATENAME(MINUTE, GETDATE()) between HORAINICIODOM and HORAFINDOM then count(*) else 100 end
			             end
	   		        end as cantidad 
			from (select d.idlinea, pd.IDEstacionSale, e.estacion, (1*case when dd.AsignacionAutoSale = 1 then 1 else 0 end) as AutoSale 
				from DespachadosDetalles dd with (nolock)
				left join despachos d with (nolock) on d.IDDespacho = dd.IDDespacho 
				left join ProgramacionesDetalles pd with (nolock) on dd.IDProgramacionDetalle = pd.IDProgramacionDetalle 
				left join Estaciones e with (nolock) on pd.IDEstacionSale = e.IDEstacion 
				where dd.IDDespacho in (select IDDespacho from despachos with (nolock) where d.idlinea = IDLINEA
				and pd.IDEstacionSale = ESTACIONSALE
				and year(d.FechaDespacho)*10000+month(d.FechaDespacho)*100+day(d.FechaDespacho) = year(getdate())*10000+month(getdate())*100+day(getdate())) and pd.horaSale >= cast(DATEADD(MINUTE, -CONTROLASIG, getdate()) as time(3)) 
			        and (not dd.IDFormacion is null) and (not dd.HoraSale is null) ) qq";
	
	$cQueryDupAux = "select case when DATENAME(HOUR, GETDATE())*100+DATENAME(MINUTE, GETDATE()) between HORAINICIO and HORAFIN then count(*)*(-1) else 100 end as cantidad 
			from (
			select IDLinea, FechaDespacho, HoraSale, Formacion, count(*) as cantidad
			from (
				select d.IDLinea, d.FechaDespacho, dd.HoraSale, f.nombre as Formacion 
				from DespachadosDetalles dd with (nolock)
				left join despachos d with (nolock) on d.IDDespacho = dd.IDDespacho 
				left join ProgramacionesDetalles pd with (nolock) on dd.IDProgramacionDetalle = pd.IDProgramacionDetalle 
				left join Formaciones f with (nolock) on dd.IDFormacion = f.IDFormacion
				where dd.IDDespacho in (select IDDespacho from despachos with (nolock) 
							where year(d.FechaDespacho)*10000+month(d.FechaDespacho)*100+day(d.FechaDespacho) = year(getdate())*10000+month(getdate())*100+day(getdate())
							)
				and (not dd.IDFormacion is null) and (not dd.HoraSale is null) 
				) qq
				group by IDLinea, FechaDespacho, HoraSale, Formacion
				having count(*) > 1
				) qqq";

	$cQueryDetProc = "select case when DATENAME(HOUR, GETDATE())*100+DATENAME(MINUTE, GETDATE()) between HORAINICIO and HORAFIN then isnull(max(cantidad),0)*(-1) else 100 end as cantidad 
			from (
				select linea,estacion,count(*) as cantidad
				from detecciones with (nolock) where procesada=0
				group by linea,estacion
			) qq";

	$cQueryFrame = "select case when DATENAME(HOUR, GETDATE())*100+DATENAME(MINUTE, GETDATE()) between HORAINICIO and HORAFIN then count(*) else 100 end as cantidad
			from detecciones d with (nolock) 
			where d.procesada = 1
			and d.enddatetime >= DATEADD(MINUTE, -CONTROLDET, GETDATE()) and d.enddatetime  < GETDATE()";

	$cQueryDespl = "select case when DATENAME(HOUR, GETDATE())*100+DATENAME(MINUTE, GETDATE()) between HORAINICIO and HORAFIN then count(*)*(-1) else 100 end as cantidad
			from (
			select d.idLinea, d.IDDespacho, d.FechaDespacho, dd.NroRegistro, dd.NroOrden
			from DespachadosDetalles dd with (nolock)
			join Despachos d with (nolock) on dd.IDDespacho = d.IDDespacho
			where dd.NroRegistro <> dd.NroOrden
			and dd.NroRegistro <> 0
			and YEAR(d.FechaDespacho)*10000+MONTH(d.FechaDespacho)*100+DAY(d.FechaDespacho) >= YEAR(GETDATE())*10000+MONTH(GETDATE())*100+DAY(GETDATE())
			) qq";

	$cQueryDespl = "select case when DATENAME(HOUR, GETDATE())*100+DATENAME(MINUTE, GETDATE()) between HORAINICIO and HORAFIN then coalesce(sum(Cantidad)*(-1),0) else 100 end as cantidad
			from (
			select d.idLinea, d.IDDespacho, d.FechaDespacho, dd.NroRegistro, COUNT(*) as Cantidad
			from DespachadosDetalles dd with (nolock)
			join Despachos d with (nolock) on dd.IDDespacho = d.IDDespacho
			where YEAR(d.FechaDespacho)*10000+MONTH(d.FechaDespacho)*100+DAY(d.FechaDespacho) >= YEAR(GETDATE())*10000+MONTH(GETDATE())*100+DAY(GETDATE())
			group by d.idLinea, d.IDDespacho, d.FechaDespacho, dd.NroRegistro
			having COUNT(*) > 2
			) qq";

	$cQueryDWH_SE20 = "select case when datepart(weekday, getdate()) between 2 and 6 then
	        		        case when DATENAME(HOUR, GETDATE())*100+DATENAME(MINUTE, GETDATE()) between HORAINICIO and HORAFIN then count(*) else 100 end
	   			   else 100
				   end as cantidad 
			   from (
			   select top 10 * from [dbo].[vistaDespachosDetalles] 
			   where year(fecha)*10000+month(fecha)*100+day(fecha) = year(getdate())*10000+month(getdate())*100+day(getdate())
			   and SalidaE >= cast(DATEADD(MINUTE, -20, getdate()) as time(3)) 
			   ) qq";

	$cQueryDWH_TYF_Leg = "select case when datepart(weekday, getdate()) between 2 and 6 then
							case when DATENAME(HOUR, GETDATE())*100+DATENAME(MINUTE, GETDATE()) between 900 and 1700 then count(*) else 100 end
							else 100
							end as cantidad 
					  from (
						   select LEG_LEGAJO from [dbo].[LEGAJO] (nolock) 
					  ) qq";

	$cQueryDWH_TYF_Fic = "select case when datepart(weekday, getdate()) between 2 and 6 then
					   case when DATENAME(HOUR, GETDATE())*100+DATENAME(MINUTE, GETDATE()) between 900 and 1700 then count(*) else 100 end
					   else 100
					   end as cantidad 
				      from (
						  select * from [dbo].[FICHADA] (nolock) 
						  where fechahora >= DATEADD(MINUTE, -20, getdate())
					  ) qq";

	$cQueryDWH_TYF_Tur = "select case when datepart(weekday, getdate()) between 2 and 6 then
					   case when DATENAME(HOUR, GETDATE())*100+DATENAME(MINUTE, GETDATE()) between 900 and 1700 then count(*) else 100 end
					   else 100
					   end as cantidad 
					  from (
					  select * from [dbo].TURNOS (nolock) 
					  where (fechahorainicio >= DATEADD(MINUTE, -30, getdate())
					  or fechahorafin >= DATEADD(MINUTE, -30, getdate()))) qq";

	$cQueryResRep = "select count(*)*(-1) as cantidad from (
				select dia, sum(resumen) as resumen, sum(reportes) as reportes, SUM(resumen-reportes) as diferencia
				from (
				select year(source_datetime)*10000+month(source_datetime)*100+day(source_datetime) as dia, count(*) as resumen, 0 as reportes
				from records_resumen
				group by year(source_datetime)*10000+month(source_datetime)*100+day(source_datetime)
				union all
				select year(source_datetime)*10000+month(source_datetime)*100+day(source_datetime) as dia, 0 as resumen, count(*) as resportes
				from records_resumen_reportes
				group by year(source_datetime)*10000+month(source_datetime)*100+day(source_datetime)
				) qq
				group by dia
				having SUM(resumen) > 0
				) qqq
				where diferencia <> 0";

	if (($query_id >= 1) and ($query_id <= 12)){
        	$query = $cQueryDetAux;
	}
//	if (($query_id >= 11) and ($query_id <= 14)){
//        	$query = $cQueryAsigAux;
//	}
	if (($query_id >= 13) and ($query_id <= 24)){
        	$query = $cQueryAsigEstAux;
	}
	if (($query_id >= 25) and ($query_id <= 25)){
        	$query = $cQueryDupAux;
	}
	if (($query_id >= 26) and ($query_id <= 26)){
        	$query = $cQueryDetProc;
	}
	if (($query_id >= 27) and ($query_id <= 27)){
        	$query = $cQueryFrame;
	}
	if (($query_id >= 28) and ($query_id <= 28)){
        	$query = $cQueryDespl;
	}
	if (($query_id >= 29) and ($query_id <= 29)){
        	$query = $cQueryDWH_SE20;
	}
	if (($query_id >= 30) and ($query_id <= 30)){
        	$query = $cQueryDWH_TYF_Leg;
	}
	if (($query_id >= 31) and ($query_id <= 31)){
        	$query = $cQueryDWH_TYF_Fic;
	}
	if (($query_id >= 32) and ($query_id <= 32)){
        	$query = $cQueryDWH_TYF_Tur;
	}
	if (($query_id >= 33) and ($query_id <= 33)){
        	$query = $cQueryResRep;
	}
		
	$query = str_replace("HORAINICIOSAB", $HoraInicioSab, $query);
	$query = str_replace("HORAINICIODOM", $HoraInicioDom, $query);
	$query = str_replace("HORAINICIO", $HoraInicio, $query);
	$query = str_replace("HORAFINSAB", $HoraFinSab, $query);
	$query = str_replace("HORAFINDOM", $HoraFinDom, $query);
	$query = str_replace("HORAFIN", $HoraFin, $query);
	$query = str_replace("CONTROLDET", $ControlDet, $query);
	$query = str_replace("CONTROLASIG", $ControlAsig, $query);
        switch ($query_id) {
            case 1:
		$query = str_replace("LINENAME", "'A'", $query);
		$query = str_replace("STATIONNAME", "'PTO'", $query);
	        return $this->db->query($query)->result();
                break;
            case 2:
		$query = str_replace("LINENAME", "'A'", $query);
		$query = str_replace("STATIONNAME", "'PMA'", $query);
	        return $this->db->query($query)->result();
                break;
            case 3:
		$query = str_replace("LINENAME", "'B'", $query);
		$query = str_replace("STATIONNAME", "'ALM'", $query);
	        return $this->db->query($query)->result();
                break;
            case 4:
		$query = str_replace("LINENAME", "'B'", $query);
		$query = str_replace("STATIONNAME", "'ROS'", $query);
	        return $this->db->query($query)->result();
                break;
            case 5:
		$query = str_replace("LINENAME", "'C'", $query);
		$query = str_replace("STATIONNAME", "'CON'", $query);
	        return $this->db->query($query)->result();
                break;
            case 6:
		$query = str_replace("LINENAME", "'C'", $query);
		$query = str_replace("STATIONNAME", "'RET'", $query);
	        return $this->db->query($query)->result();
                break;
            case 7:
		$query = str_replace("LINENAME", "'D'", $query);
		$query = str_replace("STATIONNAME", "'COT'", $query);
	        return $this->db->query($query)->result();
                break;
            case 8:
		$query = str_replace("LINENAME", "'D'", $query);
		$query = str_replace("STATIONNAME", "'CAT'", $query);
	        return $this->db->query($query)->result();
                break;
            case 9:
		$query = str_replace("LINENAME", "'E'", $query);
		$query = str_replace("STATIONNAME", "'RET'", $query);
	        return $this->db->query($query)->result();
                break;
            case 10:
		$query = str_replace("LINENAME", "'E'", $query);
		$query = str_replace("STATIONNAME", "'VIR'", $query);
	        return $this->db->query($query)->result();
                break;
            case 11:
		$query = str_replace("LINENAME", "'H'", $query);
		$query = str_replace("STATIONNAME", "'FDE'", $query);
	        return $this->db->query($query)->result();
                break;
            case 12:
		$query = str_replace("LINENAME", "'H'", $query);
		$query = str_replace("STATIONNAME", "'HOS'", $query);
	        return $this->db->query($query)->result();
                break;
//            case 11:
//		$query = str_replace("IDLINEA", "1", $query);
//	        return $this->dbSE20->query($query)->result();
//                break;
//            case 12:
//		$query = str_replace("IDLINEA", "3", $query);
//	        return $this->dbSE20->query($query)->result();
//                break;
//            case 13:
//		$query = str_replace("IDLINEA", "5", $query);
//	        return $this->dbSE20->query($query)->result();
//                break;
//            case 14:
//		$query = str_replace("IDLINEA", "15", $query);
//	        return $this->dbSE20->query($query)->result();
//                break;
            case 13:
		$query = str_replace("IDLINEA", "1", $query);
		$query = str_replace("ESTACIONSALE", "99", $query);
	        return $this->dbSE20->query($query)->result();
                break;
            case 14:
		$query = str_replace("IDLINEA", "1", $query);
		$query = str_replace("ESTACIONSALE", "17", $query);
	        return $this->dbSE20->query($query)->result();
                break;
            case 15:
		$query = str_replace("IDLINEA", "2", $query);
		$query = str_replace("ESTACIONSALE", "19", $query);
	        return $this->dbSE20->query($query)->result();
                break;
            case 16:
		$query = str_replace("IDLINEA", "2", $query);
		$query = str_replace("ESTACIONSALE", "109", $query);
	        return $this->dbSE20->query($query)->result();
                break;
            case 17:
		$query = str_replace("IDLINEA", "3", $query);
		$query = str_replace("ESTACIONSALE", "24", $query);
	        return $this->dbSE20->query($query)->result();
                break;
            case 18:
		$query = str_replace("IDLINEA", "3", $query);
		$query = str_replace("ESTACIONSALE", "23", $query);
	        return $this->dbSE20->query($query)->result();
                break;
            case 19:
		$query = str_replace("IDLINEA", "4", $query);
		$query = str_replace("ESTACIONSALE", "54", $query);
	        return $this->dbSE20->query($query)->result();
                break;
            case 20:
		$query = str_replace("IDLINEA", "4", $query);
		$query = str_replace("ESTACIONSALE", "20", $query);
	        return $this->dbSE20->query($query)->result();
                break;
            case 21:
		$query = str_replace("IDLINEA", "5", $query);
		$query = str_replace("ESTACIONSALE", "117", $query);
	        return $this->dbSE20->query($query)->result();
                break;
            case 22:
		$query = str_replace("IDLINEA", "5", $query);
		$query = str_replace("ESTACIONSALE", "26", $query);
	        return $this->dbSE20->query($query)->result();
                break;
            case 23:
		$query = str_replace("IDLINEA", "15", $query);
		$query = str_replace("ESTACIONSALE", "113", $query);
	        return $this->dbSE20->query($query)->result();
                break;
            case 24:
		$query = str_replace("IDLINEA", "15", $query);
		$query = str_replace("ESTACIONSALE", "107", $query);
	        return $this->dbSE20->query($query)->result();
                break;
            case 25:
	        return $this->dbSE20->query($query)->result();
                break;
            case 26:
	        return $this->dbSE20->query($query)->result();
                break;
            case 27:
	        return $this->dbSE20->query($query)->result();
                break;
            case 28:
	        return $this->dbSE20->query($query)->result();
                break;
            case 29:
	        return $this->dbDWH_SE20->query($query)->result();
                break;
            case 30:
	        return $this->dbDWH_TYF->query($query)->result();
                break;
            case 31:
	        return $this->dbDWH_TYF->query($query)->result();
                break;
            case 32:
	        return $this->dbDWH_TYF->query($query)->result();
                break;
            case 33:
	        return $this->db->query($query)->result();
                break;
        }
 //       return $this->db->query($query)->result();
    }


    public function consultadetalle($query_id)
    {
	$cQueryDup = "select IDLinea, FechaDespacho, HoraSale, Formacion, count(*) as cantidad
			from (
				select d.IDLinea, d.FechaDespacho, dd.HoraSale, f.nombre as Formacion 
				from DespachadosDetalles dd with (nolock)
				left join despachos d with (nolock) on d.IDDespacho = dd.IDDespacho 
				left join ProgramacionesDetalles pd with (nolock) on dd.IDProgramacionDetalle = pd.IDProgramacionDetalle 
				left join Formaciones f with (nolock) on dd.IDFormacion = f.IDFormacion
				where dd.IDDespacho in (select IDDespacho from despachos with (nolock) 
							where year(d.FechaDespacho)*10000+month(d.FechaDespacho)*100+day(d.FechaDespacho) = year(getdate())*10000+month(getdate())*100+day(getdate())
							)
				and (not dd.IDFormacion is null) and (not dd.HoraSale is null) 
				) qq
				group by IDLinea, FechaDespacho, HoraSale, Formacion
				having count(*) > 1";

	$cQueryDet = "select linea,estacion,count(*) as cantidad
			from detecciones with (nolock) where procesada=0
			group by linea,estacion
			order by 3,1";

	$cQueryDespl = "select idLinea, FechaDespacho, COUNT(*) as cantidad, 
			(case when exists(select * from DespachadosDetalles desp with (nolock) where IDDespacho = desp.IDDespacho and nroRegistro = 0 ) then 1 else 0 end) as tieneAdicional
			from (
			select d.idLinea, d.IDDespacho, d.FechaDespacho, dd.NroRegistro, dd.NroOrden
			from DespachadosDetalles dd with (nolock)
			join Despachos d with (nolock) on dd.IDDespacho = d.IDDespacho
			where dd.NroRegistro <> dd.NroOrden
			and dd.NroRegistro <> 0
			and YEAR(d.FechaDespacho)*10000+MONTH(d.FechaDespacho)*100+DAY(d.FechaDespacho) >= YEAR(GETDATE())*10000+MONTH(GETDATE())*100+DAY(GETDATE())
			) qq
			group by idLinea, FechaDespacho
			having count(*) > 2";

	$cQueryDespl = "select idLinea, FechaDespacho, NroRegistro, count(*) as cantidad
			from (
			select d.idLinea, d.IDDespacho, d.FechaDespacho, dd.NroRegistro, dd.NroOrden
			from DespachadosDetalles dd with (nolock)
			join Despachos d with (nolock) on dd.IDDespacho = d.IDDespacho
			where YEAR(d.FechaDespacho)*10000+MONTH(d.FechaDespacho)*100+DAY(d.FechaDespacho) >= YEAR(GETDATE())*10000+MONTH(GETDATE())*100+DAY(GETDATE())
			) qq
			group by idLinea, FechaDespacho, NroRegistro
			having COUNT(*) > 2
			order by 2, 1, 3";

	$cQueryResRep = "select * from (
			select dia, sum(resumen) as resumen, sum(reportes) as reportes, SUM(resumen-reportes) as diferencia
			from (
			select year(source_datetime)*10000+month(source_datetime)*100+day(source_datetime) as dia, count(*) as resumen, 0 as reportes
			from records_resumen
			group by year(source_datetime)*10000+month(source_datetime)*100+day(source_datetime)
			union all
			select year(source_datetime)*10000+month(source_datetime)*100+day(source_datetime) as dia, 0 as resumen, count(*) as resportes
			from records_resumen_reportes
			group by year(source_datetime)*10000+month(source_datetime)*100+day(source_datetime)
			) qq
			group by dia
			having SUM(resumen) > 0
			) qqq
			where diferencia <> 0
			order by 1";
	
	if ($query_id == 25){
        	 return $this->dbSE20->query($cQueryDup)->result();
        }
	if ($query_id == 26){
        	 return $this->dbSE20->query($cQueryDet)->result();
        }
	if ($query_id == 28){
        	 return $this->dbSE20->query($cQueryDespl)->result();
        }
	if ($query_id == 33){
        	 return $this->db->query($cQueryResRep)->result();
        }

    }
}
