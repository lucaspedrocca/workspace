use ServicioEfectuado20

DECLARE @HORAINICIO INTEGER = 645;
DECLARE @HORAFIN INTEGER = 2300;
DECLARE @HORAINICIOSAB INTEGER = 645;
DECLARE @HORAFINSAB INTEGER = 2320;
DECLARE @HORAINICIODOM INTEGER = 845;
DECLARE @HORAFINDOM INTEGER = 2220;
DECLARE @CONTROLDET INTEGER = 7;
DECLARE @CONTROLASIG INTEGER = 15;

	--uso del sistema, no puede ser 0, aca puede haber muchos falsos positivos
	select idlinea, case when datepart(weekday, getdate()) between 2 and 6 then
	case when DATENAME(HOUR, GETDATE())*100+DATENAME(MINUTE, GETDATE()) between @HORAINICIO and @HORAFIN then count(*) else 100 end
	   			 else case when datepart(weekday, getdate()) = 7 then 
  	                                 100 
				      else 100 
			              end
	   		         end as cantidad 
			from (select idlinea, (1*case when AsignacionAutoSale = 1 then 1 else 0 end) as AutoSale 
				from DespachadosDetalles dd with (nolock)
				left join despachos d with (nolock) on d.IDDespacho = dd.IDDespacho 
				left join ProgramacionesDetalles pd with (nolock) on dd.IDProgramacionDetalle = pd.IDProgramacionDetalle 
				where dd.IDDespacho in (select IDDespacho from despachos with (nolock) where d.idlinea IN (1)--, 2, 3, 4, 5, 15)
			 	and year(d.FechaDespacho)*10000+month(d.FechaDespacho)*100+day(d.FechaDespacho) = year(getdate())*10000+month(getdate())*100+day(getdate())) 
			   	and pd.horaSale >= cast(DATEADD(MINUTE, -@CONTROLASIG, getdate()) as time(3)) and (not dd.IDFormacion is null) and (not dd.HoraSale is null) 
				) qq
				group by IDLinea

	--Detecciones procesadas acumuladas, no puede ser un numero grande, deberia estar lo mas cercano a 0
	select case when DATENAME(HOUR, GETDATE())*100+DATENAME(MINUTE, GETDATE()) between @HORAINICIO and @HORAFIN then isnull(max(cantidad),0)*(-1) else 100 end as cantidad 
			from (
				select linea,estacion,count(*) as cantidad
				from detecciones with (nolock) where procesada=0
				group by linea,estacion
			) qq

	--Detecciones procesadas en el frame, no puede ser 0			
	select case when DATENAME(HOUR, GETDATE())*100+DATENAME(MINUTE, GETDATE()) between @HORAINICIO and @HORAFIN then count(*) else 100 end as cantidad
			from detecciones d with (nolock) 
			where d.procesada = 1
			and d.enddatetime >= DATEADD(MINUTE, -@CONTROLDET, GETDATE()) and d.enddatetime  < GETDATE()

	--Desplazamientos, no puede ser > a 0
	select case when DATENAME(HOUR, GETDATE())*100+DATENAME(MINUTE, GETDATE()) between @HORAINICIO and @HORAFIN then count(*)*(-1) else 100 end as cantidad
			from (
			select d.idLinea, d.IDDespacho, d.FechaDespacho, dd.NroRegistro, dd.NroOrden
			from DespachadosDetalles dd with (nolock)
			join Despachos d with (nolock) on dd.IDDespacho = d.IDDespacho
			where dd.NroRegistro <> dd.NroOrden
			and dd.NroRegistro <> 0
			and YEAR(d.FechaDespacho)*10000+MONTH(d.FechaDespacho)*100+DAY(d.FechaDespacho) >= YEAR(GETDATE())*10000+MONTH(GETDATE())*100+DAY(GETDATE())
			) qq


