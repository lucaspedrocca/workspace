--Monitorear por cada camara si dentro de los ultimos n minutos hubo al menos una deteccion en Emova_CV.records_resumen dentro de un rango especifico que depende del tipo de dia
USE [Emova_CV]

declare @tipoDia int  --1 Habil, 2 Sabado, 3 Domingo/Feriado

set @tipoDia = case when cast(getdate() as date) in (select fecha from ServicioEfectuado20.dbo.feriados with (nolock)) then (select idTipoDia from ServicioEfectuado20.dbo.feriados with (nolock) where Fecha = cast(getdate() as date)) else (case when datepart(weekday, getdate()) between 2 and 6 then 1 else (case when datepart(weekday, getdate()) = 7 then 2 else 3 end) end) end

DROP TABLE IF EXISTS #detecciones
CREATE TABLE #detecciones
(
linea varchar(10),
cabecera varchar(10),
camara varchar(50),
estado varchar(50),
intervalo varchar(50),
)

DROP TABLE IF EXISTS #deteccionesAgrupadas
CREATE TABLE #deteccionesAgrupadas
(
linea varchar(10),
cabecera varchar(10),
intervalo varchar(50),
cantidad int,
)

--Linea A
declare @intervaloA as int = 10
declare @inicioHabilA as time = DATEADD(MINUTE, @intervaloA, '05:30:00')
declare @finHabilA as time = '23:28:00'
declare @inicioSabadoA as time = DATEADD(MINUTE, @intervaloA, '06:00:00') 
declare @finSabadoA as time = '23:57:00'
declare @inicioDomingoFeriadoA as time = DATEADD(MINUTE, @intervaloA, '08:00:00')
declare @finDomingoFeriadoA as time = '22:36:00'



if @tipoDia = 1
	if (cast(GETDATE() as time) between @inicioHabilA and @finHabilA)
		INSERT INTO #detecciones
		select s.line_name as Linea, s.station_name as Cabecera, s.name ,case when (select count(*) from EMOVA_CV.dbo.records_resumen rr with (nolock) where source_datetime between DATEADD(MINUTE, -@intervaloA, GETDATE()) and GETDATE() and s.id = rr.source_id) = 0 then 'Sin Detecciones' else 'OK' end as Estado, (@intervaloA) as intervalo from EMOVA_CV.dbo.sources s with (nolock)
		where s.line_name = 'A'
	else
		INSERT INTO #detecciones
		select 'Linea A', 'Todas', 'Todas', 'OK (fuera de horario de servicio)', '-'
else 
	if @tipoDia = 2
		if (cast(GETDATE() as time) between @inicioSabadoA and @finSabadoA)
			INSERT INTO #detecciones
			select s.line_name as Linea, s.station_name as Cabecera, s.name ,case when (select count(*) from EMOVA_CV.dbo.records_resumen rr with (nolock) where source_datetime between DATEADD(MINUTE, -@intervaloA, GETDATE()) and GETDATE() and s.id = rr.source_id) = 0 then 'Sin Detecciones' else 'OK' end as Estado, (@intervaloA) as intervalo from EMOVA_CV.dbo.sources s with (nolock)
			where s.line_name = 'A'
		else
			INSERT INTO #detecciones
			select 'Linea A', 'Todas', 'Todas', 'OK (fuera de horario de servicio)', '-'
	else 
			if (cast(GETDATE() as time) between @inicioDomingoFeriadoA and @finDomingoFeriadoA)
				INSERT INTO #detecciones
				select s.line_name as Linea, s.station_name as Cabecera, s.name ,case when (select count(*) from EMOVA_CV.dbo.records_resumen rr with (nolock) where source_datetime between DATEADD(MINUTE, -@intervaloA, GETDATE()) and GETDATE() and s.id = rr.source_id) = 0 then 'Sin Detecciones' else 'OK' end as Estado, (@intervaloA) as intervalo from EMOVA_CV.dbo.sources s with (nolock)
				where s.line_name = 'A'
			else
				INSERT INTO #detecciones
			select 'Linea A', 'Todas', 'Todas', 'OK (fuera de horario de servicio)', '-'

--Linea B
declare @intervaloB as int = 10
declare @inicioHabilB as time =  DATEADD(MINUTE, @intervaloB, '05:30:00')
declare @finHabilB as time = '23:30:00'
declare @inicioSabadoB as time = DATEADD(MINUTE, @intervaloB, '06:00:00') 
declare @finSabadoB as time = '23:53:00'
declare @inicioDomingoFeriadoB as time = DATEADD(MINUTE, @intervaloB, '08:00:00')
declare @finDomingoFeriadoB as time = '22:28:00'



if @tipoDia = 1
	if (cast(GETDATE() as time) between @inicioHabilB and @finHabilB)
		INSERT INTO #detecciones
		select s.line_name as Linea, s.station_name as Cabecera, s.name ,case when (select count(*) from EMOVA_CV.dbo.records_resumen rr with (nolock) where source_datetime between DATEADD(MINUTE, -@intervaloB, GETDATE()) and GETDATE() and s.id = rr.source_id) = 0 then 'Sin Detecciones' else 'OK' end as Estado, (@intervaloB) as intervalo from EMOVA_CV.dbo.sources s with (nolock)
		where s.line_name = 'B'
	else
		INSERT INTO #detecciones
		select 'Linea B', 'Todas', 'Todas', 'OK (fuera de horario de servicio)', '-'
else 
	if @tipoDia = 2
		if (cast(GETDATE() as time) between @inicioSabadoB and @finSabadoB)
			INSERT INTO #detecciones
			select s.line_name as Linea, s.station_name as Cabecera, s.name ,case when (select count(*) from EMOVA_CV.dbo.records_resumen rr with (nolock) where source_datetime between DATEADD(MINUTE, -@intervaloB, GETDATE()) and GETDATE() and s.id = rr.source_id) = 0 then 'Sin Detecciones' else 'OK' end as Estado, (@intervaloB) as intervalo from EMOVA_CV.dbo.sources s with (nolock)
		where s.line_name = 'B'
		else
			INSERT INTO #detecciones
			select 'Linea B', 'Todas', 'Todas', 'OK (fuera de horario de servicio)', '-'
	else 
			if (cast(GETDATE() as time) between @inicioDomingoFeriadoB and @finDomingoFeriadoB)
				INSERT INTO #detecciones
				select s.line_name as Linea, s.station_name as Cabecera, s.name ,case when (select count(*) from EMOVA_CV.dbo.records_resumen rr with (nolock) where source_datetime between DATEADD(MINUTE, -@intervaloB, GETDATE()) and GETDATE() and s.id = rr.source_id) = 0 then 'Sin Detecciones' else 'OK' end as Estado, (@intervaloB) as intervalo from EMOVA_CV.dbo.sources s with (nolock)
				where s.line_name = 'B'
			else
				INSERT INTO #detecciones
				select 'Linea B', 'Todas', 'Todas', 'OK (fuera de horario de servicio)', '-'


--Linea C
declare @intervaloC as int = 10
declare @inicioHabilC as time = DATEADD(MINUTE, @intervaloC, '05:30:00')
declare @finHabilC as time = '23:33:00'
declare @inicioSabadoC as time = DATEADD(MINUTE, @intervaloC, '06:00:00') 
declare @finSabadoC as time = '23:54:00'
declare @inicioDomingoFeriadoC as time = DATEADD(MINUTE, @intervaloC, '08:00:00')
declare @finDomingoFeriadoC as time = '22:34:00'



if @tipoDia = 1
	if (cast(GETDATE() as time) between @inicioHabilC and @finHabilC)
		INSERT INTO #detecciones
		select s.line_name as Linea, s.station_name as Cabecera, s.name ,case when (select count(*) from EMOVA_CV.dbo.records_resumen rr with (nolock) where source_datetime between DATEADD(MINUTE, -@intervaloC, GETDATE()) and GETDATE() and s.id = rr.source_id) = 0 then 'Sin Detecciones' else 'OK' end as Estado, (@intervaloC) as intervalo from EMOVA_CV.dbo.sources s with (nolock)
		where s.line_name = 'C'
	else
		INSERT INTO #detecciones
		select 'Linea C', 'Todas', 'Todas', 'OK (fuera de horario de servicio)', '-'
else 
	if @tipoDia = 2
		if (cast(GETDATE() as time) between @inicioSabadoC and @finSabadoC)
			INSERT INTO #detecciones
			select s.line_name as Linea, s.station_name as Cabecera, s.name ,case when (select count(*) from EMOVA_CV.dbo.records_resumen rr with (nolock) where source_datetime between DATEADD(MINUTE, -@intervaloC, GETDATE()) and GETDATE() and s.id = rr.source_id) = 0 then 'Sin Detecciones' else 'OK' end as Estado, (@intervaloC) as intervalo from EMOVA_CV.dbo.sources s with (nolock)
			where s.line_name = 'C'
		else
			INSERT INTO #detecciones
			select 'Linea C', 'Todas', 'Todas', 'OK (fuera de horario de servicio)', '-'
	else 
			if (cast(GETDATE() as time) between @inicioDomingoFeriadoC and @finDomingoFeriadoC)
				INSERT INTO #detecciones
				select s.line_name as Linea, s.station_name as Cabecera, s.name ,case when (select count(*) from EMOVA_CV.dbo.records_resumen rr with (nolock) where source_datetime between DATEADD(MINUTE, -@intervaloC, GETDATE()) and GETDATE() and s.id = rr.source_id) = 0 then 'Sin Detecciones' else 'OK' end as Estado, (@intervaloC) as intervalo from EMOVA_CV.dbo.sources s with (nolock)
				where s.line_name = 'C'
			else
				INSERT INTO #detecciones
				select 'Linea C', 'Todas', 'Todas', 'OK (fuera de horario de servicio)', '-'

--Linea D
declare @intervaloD as int = 10
declare @inicioHabilD as time = DATEADD(MINUTE, @intervaloD, '05:30:00')
declare @finHabilD as time = '23:33:00'
declare @inicioSabadoD as time = DATEADD(MINUTE, @intervaloD, '06:00:00') 
declare @finSabadoD as time = '23:59:00'
declare @inicioDomingoFeriadoD as time = DATEADD(MINUTE, @intervaloD, '08:00:00')
declare @finDomingoFeriadoD as time = '22:34:00'



if @tipoDia = 1
	if (cast(GETDATE() as time) between @inicioHabilD and @finHabilD)
		INSERT INTO #detecciones
		select s.line_name as Linea, s.station_name as Cabecera, s.name ,case when (select count(*) from EMOVA_CV.dbo.records_resumen rr with (nolock) where source_datetime between DATEADD(MINUTE, -@intervaloD, GETDATE()) and GETDATE() and s.id = rr.source_id) = 0 then 'Sin Detecciones' else 'OK' end as Estado, (@intervaloD) as intervalo from EMOVA_CV.dbo.sources s with (nolock)
		where s.line_name = 'D'
	else
		INSERT INTO #detecciones
		select 'Linea D', 'Todas', 'Todas', 'OK (fuera de horario de servicio)', '-'
else 
	if @tipoDia = 2
		if (cast(GETDATE() as time) between @inicioSabadoD and @finSabadoD)
			INSERT INTO #detecciones
			select s.line_name as Linea, s.station_name as Cabecera, s.name ,case when (select count(*) from EMOVA_CV.dbo.records_resumen rr with (nolock) where source_datetime between DATEADD(MINUTE, -@intervaloD, GETDATE()) and GETDATE() and s.id = rr.source_id) = 0 then 'Sin Detecciones' else 'OK' end as Estado, (@intervaloD) as intervalo from EMOVA_CV.dbo.sources s with (nolock)
			where s.line_name = 'D'
		else
			INSERT INTO #detecciones
			select 'Linea D', 'Todas', 'Todas', 'OK (fuera de horario de servicio)', '-'
	else 
			if (cast(GETDATE() as time) between @inicioDomingoFeriadoD and @finDomingoFeriadoD)
				INSERT INTO #detecciones
				select s.line_name as Linea, s.station_name as Cabecera, s.name ,case when (select count(*) from EMOVA_CV.dbo.records_resumen rr with (nolock) where source_datetime between DATEADD(MINUTE, -@intervaloD, GETDATE()) and GETDATE() and s.id = rr.source_id) = 0 then 'Sin Detecciones' else 'OK' end as Estado, (@intervaloD) as intervalo from EMOVA_CV.dbo.sources s with (nolock)
				where s.line_name = 'D'
			else
				INSERT INTO #detecciones
				select 'Linea D', 'Todas', 'Todas', 'OK (fuera de horario de servicio)', '-'

--Linea E
declare @intervaloE as int = 10
declare @inicioHabilE as time = DATEADD(MINUTE, @intervaloE, '05:30:00')
declare @finHabilE as time = '23:30:00'
declare @inicioSabadoE as time = DATEADD(MINUTE, @intervaloE, '06:00:00') 
declare @finSabadoE as time = '23:58:00'
declare @inicioDomingoFeriadoE as time = DATEADD(MINUTE, @intervaloE, '08:00:00')
declare @finDomingoFeriadoE as time = '22:28:00'



if @tipoDia = 1
	if (cast(GETDATE() as time) between @inicioHabilE and @finHabilE)
		INSERT INTO #detecciones
		select s.line_name as Linea, s.station_name as Cabecera, s.name ,case when (select count(*) from EMOVA_CV.dbo.records_resumen rr with (nolock) where source_datetime between DATEADD(MINUTE, -@intervaloE, GETDATE()) and GETDATE() and s.id = rr.source_id) = 0 then 'Sin Detecciones' else 'OK' end as Estado, (@intervaloE) as intervalo from EMOVA_CV.dbo.sources s with (nolock)
		where s.line_name = 'E'
	else
		INSERT INTO #detecciones
		select 'Linea E', 'Todas', 'Todas', 'OK (fuera de horario de servicio)', '-'
else 
	if @tipoDia = 2
		if (cast(GETDATE() as time) between @inicioSabadoE and @finSabadoE)
			INSERT INTO #detecciones
			select s.line_name as Linea, s.station_name as Cabecera, s.name ,case when (select count(*) from EMOVA_CV.dbo.records_resumen rr with (nolock) where source_datetime between DATEADD(MINUTE, -@intervaloE, GETDATE()) and GETDATE() and s.id = rr.source_id) = 0 then 'Sin Detecciones' else 'OK' end as Estado, (@intervaloE) as intervalo from EMOVA_CV.dbo.sources s with (nolock)
			where s.line_name = 'E'
		else
			INSERT INTO #detecciones
			select 'Linea E', 'Todas', 'Todas', 'OK (fuera de horario de servicio)', '-'
	else 
			if (cast(GETDATE() as time) between @inicioDomingoFeriadoE and @finDomingoFeriadoE)
				INSERT INTO #detecciones
				select s.line_name as Linea, s.station_name as Cabecera, s.name ,case when (select count(*) from EMOVA_CV.dbo.records_resumen rr with (nolock) where source_datetime between DATEADD(MINUTE, -@intervaloE, GETDATE()) and GETDATE() and s.id = rr.source_id) = 0 then 'Sin Detecciones' else 'OK' end as Estado, (@intervaloE) as intervalo from EMOVA_CV.dbo.sources s with (nolock)
				where s.line_name = 'E'
			else
				INSERT INTO #detecciones
				select 'Linea E', 'Todas', 'Todas', 'OK (fuera de horario de servicio)', '-'

--Linea H
declare @intervaloH as int = 10
declare @inicioHabilH as time = DATEADD(MINUTE, @intervaloH, '05:30:00')
declare @finHabilH as time = '23:51:00'
declare @inicioSabadoH as time = DATEADD(MINUTE, @intervaloH, '06:00:00') 
declare @finSabadoH as time = '23:59:00'
declare @inicioDomingoFeriadoH as time = DATEADD(MINUTE, @intervaloH, '08:00:00')
declare @finDomingoFeriadoH as time = '22:51:00'



if @tipoDia = 1
	if (cast(GETDATE() as time) between @inicioHabilH and @finHabilH)
		INSERT INTO #detecciones
		select s.line_name as Linea, s.station_name as Cabecera, s.name ,case when (select count(*) from EMOVA_CV.dbo.records_resumen rr with (nolock) where source_datetime between DATEADD(MINUTE, -@intervaloH, GETDATE()) and GETDATE() and s.id = rr.source_id) = 0 then 'Sin Detecciones' else 'OK' end as Estado, (@intervaloH) as intervalo from EMOVA_CV.dbo.sources s with (nolock)
		where s.line_name = 'H'
	else
		INSERT INTO #detecciones
		select 'Linea H', 'Todas', 'Todas', 'OK (fuera de horario de servicio)', '-'
else 
	if @tipoDia = 2
		if (cast(GETDATE() as time) between @inicioSabadoH and @finSabadoH)
			INSERT INTO #detecciones
			select s.line_name as Linea, s.station_name as Cabecera, s.name ,case when (select count(*) from EMOVA_CV.dbo.records_resumen rr with (nolock) where source_datetime between DATEADD(MINUTE, -@intervaloH, GETDATE()) and GETDATE() and s.id = rr.source_id) = 0 then 'Sin Detecciones' else 'OK' end as Estado, (@intervaloH) as intervalo from EMOVA_CV.dbo.sources s with (nolock)
			where s.line_name = 'H'
		else
			INSERT INTO #detecciones
			select 'Linea E', 'Todas', 'Todas', 'OK (fuera de horario de servicio)', '-'
	else 
			if (cast(GETDATE() as time) between @inicioDomingoFeriadoH and @finDomingoFeriadoH)
				INSERT INTO #detecciones
				select s.line_name as Linea, s.station_name as Cabecera, s.name ,case when (select count(*) from EMOVA_CV.dbo.records_resumen rr with (nolock) where source_datetime between DATEADD(MINUTE, -@intervaloH, GETDATE()) and GETDATE() and s.id = rr.source_id) = 0 then 'Sin Detecciones' else 'OK' end as Estado, (@intervaloH) as intervalo from EMOVA_CV.dbo.sources s with (nolock)
				where s.line_name = 'H'
			else
				INSERT INTO #detecciones
				select 'Linea E', 'Todas', 'Todas', 'OK (fuera de horario de servicio)', '-'


INSERT INTO #deteccionesAgrupadas
select linea, cabecera, intervalo, count(*) from #detecciones
where estado = 'Sin detecciones'
group by linea, cabecera, intervalo
having count(*) = 4


DECLARE @cant int
SET @cant = (select count(*) from #deteccionesAgrupadas) 

DECLARE @Mail_HTML  NVARCHAR(MAX)= ''

SET @Mail_HTML =
               N'<font face="verdana">'+
               N'<h4>Cabeceras sin detecciones: '+ cast(@cant as varchar(10)) +'</h4>'+
               N'</font>'
			   +
               
               N'<table border="1" cellpadding="3" cellspacing="0">'+
               N'<thead>'+
               N'<tr style=''background:#3498DB;color: black;font-weight: bold;font-size:80%;font-family:Verdana;''>'+
               N'<th>Linea</th>'+
               N'<th>Cabecera</th>'+
			   N'<th>Intervalo</th>'+
               N'</tr>'+
               N'</thead>'+
               N'<tbody align="center" style=''font-size:80%; font-family:Verdana;''>'+
               CAST ( (Select td = (convert(char(50),[linea])), '',
                                            td = (convert(char(50),[cabecera])), '',
											td = (convert(char(50),[intervalo])), ''
               FROM #deteccionesAgrupadas  FOR XML PATH('tr'), TYPE) AS NVARCHAR(MAX) ) +
               N'</tbody>'+
               N'</table>'


IF @cant <> 0
		EXEC msdb.dbo.sp_send_dbmail
			@recipients=N'monitoreoSE20@grupoprominente.com; monitoreoSE20@emova.com.ar',  
			@subject = 'SE 2.0 Monitoreo - Cabeceras sin detecciones',
			@body = @Mail_HTML,
			@body_format = 'HTML';

drop table #detecciones
drop table #deteccionesAgrupadas

