--Monitorear la carga en el front por cada linea    //Por cada linea cuenta la cantidad de cargas de despachos manuales o automaticos que hubo en el intervalo defino. (Si es 0 es un alerta, en caso contrario esta OK)
USE [ServicioEfectuado20]

declare @tipoDia int  --1 Habil, 2 Sabado, 3 Domingo/Feriado

set @tipoDia = case when cast(getdate() as date) in (select fecha from ServicioEfectuado20.dbo.feriados with (nolock)) then (select idTipoDia from ServicioEfectuado20.dbo.feriados with (nolock) where Fecha = cast(getdate() as date)) else (case when datepart(weekday, getdate()) between 2 and 6 then 1 else (case when datepart(weekday, getdate()) = 7 then 2 else 3 end) end) end

DROP TABLE IF EXISTS #asignaciones
CREATE TABLE #asignaciones
(
Linea varchar(10),
CantCargasFront int,
Intervalo varchar(50),
UltimaCarga varchar(8),
)

--Linea A
declare @IDDespachoA as int = (select iddespacho from Despachos with (nolock) where idlinea = 1 and FechaDespacho = cast(getdate() as date))
declare @intervaloA as int = 60
declare @inicioHabilA as time = DATEADD(MINUTE, @intervaloA, '05:30:00')
declare @finHabilA as time = '23:28:00'
declare @inicioSabadoA as time = DATEADD(MINUTE, @intervaloA, '06:00:00') 
declare @finSabadoA as time = '23:57:00'
declare @inicioDomingoFeriadoA as time = DATEADD(MINUTE, @intervaloA, '08:00:00')
declare @finDomingoFeriadoA as time = '22:36:00'


if @tipoDia = 1
	if (cast(GETDATE() as time) between @inicioHabilA and @finHabilA)
		INSERT INTO #asignaciones
		select 'Linea A', count(*), (@intervaloA), (select top 1 HoraSale from DespachadosDetalles where IDDespacho = @IDDespachoA order by HoraSale desc) from DespachadosDetalles with (nolock) where IDDespacho = @IDDespachoA and HoraSale >= cast(DATEADD(MINUTE, -@intervaloA, getdate()) as time) 
	else
		INSERT INTO #asignaciones
		select 'Linea A', 100,'-','-'
else 
	if @tipoDia = 2
		if (cast(GETDATE() as time) between @inicioSabadoA and @finSabadoA)
			INSERT INTO #asignaciones
			select 'Linea A', count(*), (@intervaloA), (select top 1 HoraSale from DespachadosDetalles where IDDespacho = @IDDespachoA order by HoraSale desc) from DespachadosDetalles with (nolock) where IDDespacho = @IDDespachoA and HoraSale >= cast(DATEADD(MINUTE, -@intervaloA, getdate()) as time) 
		else
			INSERT INTO #asignaciones
			select 'Linea A', 100,'-','-'
	else 
			if (cast(GETDATE() as time) between @inicioDomingoFeriadoA and @finDomingoFeriadoA)
				INSERT INTO #asignaciones
				select 'Linea A', count(*), (@intervaloA), (select top 1 HoraSale from DespachadosDetalles where IDDespacho = @IDDespachoA order by HoraSale desc) from DespachadosDetalles with (nolock) where IDDespacho = @IDDespachoA and HoraSale >= cast(DATEADD(MINUTE, -@intervaloA, getdate()) as time) 
			else
				INSERT INTO #asignaciones
				select 'Linea A', 100,'-' ,'-','-'

--Linea B
declare @IDDespachoB as int = (select iddespacho from Despachos with (nolock) where idlinea = 2 and FechaDespacho = cast(getdate() as date))
declare @intervaloB as int = 60
declare @inicioHabilB as time = DATEADD(MINUTE, @intervaloB, '05:30:00')
declare @finHabilB as time = '23:30:00'
declare @inicioSabadoB as time = DATEADD(MINUTE, @intervaloB, '06:00:00') 
declare @finSabadoB as time = '23:53:00'
declare @inicioDomingoFeriadoB as time = DATEADD(MINUTE, @intervaloB, '08:00:00')
declare @finDomingoFeriadoB as time = '22:28:00'



if @tipoDia = 1
	if (cast(GETDATE() as time) between @inicioHabilB and @finHabilB)
		INSERT INTO #asignaciones
		select 'Linea B', count(*), (@intervaloB), (select top 1 HoraSale from DespachadosDetalles where IDDespacho = @IDDespachoB order by HoraSale desc) from DespachadosDetalles with (nolock) where IDDespacho = @IDDespachoB and HoraSale >= cast(DATEADD(MINUTE, -@intervaloB, getdate()) as time) 
	else
		INSERT INTO #asignaciones
		select 'Linea B', 100,'-','-'
else 
	if @tipoDia = 2
		if (cast(GETDATE() as time) between @inicioSabadoB and @finSabadoB)
			INSERT INTO #asignaciones
			select 'Linea B', count(*), (@intervaloB), (select top 1 HoraSale from DespachadosDetalles where IDDespacho = @IDDespachoB order by HoraSale desc) from DespachadosDetalles with (nolock) where IDDespacho = @IDDespachoB and HoraSale >= cast(DATEADD(MINUTE, -@intervaloB, getdate()) as time) 
		else
			INSERT INTO #asignaciones
			select 'Linea B', 100,'-','-'
	else 
			if (cast(GETDATE() as time) between @inicioDomingoFeriadoB and @finDomingoFeriadoB)
				INSERT INTO #asignaciones
				select 'Linea B', count(*), (@intervaloB), (select top 1 HoraSale from DespachadosDetalles where IDDespacho = @IDDespachoB order by HoraSale desc) from DespachadosDetalles with (nolock) where IDDespacho = @IDDespachoB and HoraSale >= cast(DATEADD(MINUTE, -@intervaloB, getdate()) as time) 
			else
				INSERT INTO #asignaciones
				select 'Linea B', 100,'-','-'


--Linea C
declare @IDDespachoC as int = (select iddespacho from Despachos with (nolock) where idlinea = 3 and FechaDespacho = cast(getdate() as date))
declare @intervaloC as int = 60
declare @inicioHabilC as time = DATEADD(MINUTE, @intervaloC, '05:30:00')
declare @finHabilC as time = '23:33:00'
declare @inicioSabadoC as time = DATEADD(MINUTE, @intervaloC, '06:00:00') 
declare @finSabadoC as time = '23:54:00'
declare @inicioDomingoFeriadoC as time = DATEADD(MINUTE, @intervaloC, '08:00:00')
declare @finDomingoFeriadoC as time = '22:34:00'



if @tipoDia = 1
	if (cast(GETDATE() as time) between @inicioHabilC and @finHabilC)
		INSERT INTO #asignaciones
		select 'Linea C', count(*), (@intervaloC), (select top 1 HoraSale from DespachadosDetalles where IDDespacho = @IDDespachoC order by HoraSale desc) from DespachadosDetalles with (nolock) where IDDespacho = @IDDespachoC and HoraSale >= cast(DATEADD(MINUTE, -@intervaloC, getdate()) as time) 
	else
		INSERT INTO #asignaciones
		select 'Linea C', 100,'-','-'
else 
	if @tipoDia = 2
		if (cast(GETDATE() as time) between @inicioSabadoC and @finSabadoC)
			INSERT INTO #asignaciones
			select 'Linea C', count(*), (@intervaloC), (select top 1 HoraSale from DespachadosDetalles where IDDespacho = @IDDespachoC order by HoraSale desc) from DespachadosDetalles with (nolock) where IDDespacho = @IDDespachoC and HoraSale >= cast(DATEADD(MINUTE, -@intervaloC, getdate()) as time) 
		else
			INSERT INTO #asignaciones
			select 'Linea C', 100,'-','-'
	else 
			if (cast(GETDATE() as time) between @inicioDomingoFeriadoC and @finDomingoFeriadoC)
				INSERT INTO #asignaciones
				select 'Linea C', count(*), (@intervaloC), (select top 1 HoraSale from DespachadosDetalles where IDDespacho = @IDDespachoC order by HoraSale desc) from DespachadosDetalles with (nolock) where IDDespacho = @IDDespachoC and HoraSale >= cast(DATEADD(MINUTE, -@intervaloC, getdate()) as time) 
			else
				INSERT INTO #asignaciones
				select 'Linea C', 100,'-','-'

--Linea D
--declare @IDDespachoD as int = (select iddespacho from Despachos with (nolock) where idlinea = 4 and FechaDespacho = cast(getdate() as date))
--declare @intervaloD as int = 60
--declare @inicioHabilD as time = DATEADD(MINUTE, @intervaloD, '05:30:00')
--declare @finHabilD as time = '23:33:00'
--declare @inicioSabadoD as time = DATEADD(MINUTE, @intervaloD, '06:00:00') 
--declare @finSabadoD as time = '23:59:00'
--declare @inicioDomingoFeriadoD as time = DATEADD(MINUTE, @intervaloD, '08:00:00')
--declare @finDomingoFeriadoD as time = '22:34:00'



--if @tipoDia = 1
--	if (cast(GETDATE() as time) between @inicioHabilD and @finHabilD)
--		INSERT INTO #asignaciones
--		select 'Linea D', count(*), (@intervaloD), (select top 1 HoraSale from DespachadosDetalles where IDDespacho = @IDDespachoD order by HoraSale desc) from DespachadosDetalles with (nolock) where IDDespacho = @IDDespachoD and HoraSale >= cast(DATEADD(MINUTE, -@intervaloD, getdate()) as time) 
--	else
--		INSERT INTO #asignaciones
--		select 'Linea D', 100,'-','-'
--else 
--	if @tipoDia = 2
--		if (cast(GETDATE() as time) between @inicioSabadoD and @finSabadoD)
--			INSERT INTO #asignaciones
--			select 'Linea D', count(*), (@intervaloD), (select top 1 HoraSale from DespachadosDetalles where IDDespacho = @IDDespachoD order by HoraSale desc) from DespachadosDetalles with (nolock) where IDDespacho = @IDDespachoD and HoraSale >= cast(DATEADD(MINUTE, -@intervaloD, getdate()) as time) 
--		else
--			INSERT INTO #asignaciones
--			select 'Linea D', 100,'-','-'
--	else 
--			if (cast(GETDATE() as time) between @inicioDomingoFeriadoD and @finDomingoFeriadoD)
--				INSERT INTO #asignaciones
--				select 'Linea D', count(*), (@intervaloD), (select top 1 HoraSale from DespachadosDetalles where IDDespacho = @IDDespachoD order by HoraSale desc) from DespachadosDetalles with (nolock) where IDDespacho = @IDDespachoD and HoraSale >= cast(DATEADD(MINUTE, -@intervaloD, getdate()) as time)
--			else
--				INSERT INTO #asignaciones
--				select 'Linea D', 100,'-','-'

--Linea E
declare @IDDespachoE as int = (select iddespacho from Despachos with (nolock) where idlinea = 5 and FechaDespacho = cast(getdate() as date))
declare @intervaloE as int = 60
declare @inicioHabilE as time = DATEADD(MINUTE, @intervaloE, '05:30:00')
declare @finHabilE as time = '23:30:00'
declare @inicioSabadoE as time = DATEADD(MINUTE, @intervaloE, '06:00:00') 
declare @finSabadoE as time = '23:58:00'
declare @inicioDomingoFeriadoE as time = DATEADD(MINUTE, @intervaloE, '08:00:00')
declare @finDomingoFeriadoE as time = '22:28:00'



if @tipoDia = 1
	if (cast(GETDATE() as time) between @inicioHabilE and @finHabilE)
		INSERT INTO #asignaciones
		select 'Linea E', count(*), (@intervaloE), (select top 1 HoraSale from DespachadosDetalles where IDDespacho = @IDDespachoE order by HoraSale desc) from DespachadosDetalles with (nolock) where IDDespacho = @IDDespachoE and HoraSale >= cast(DATEADD(MINUTE, -@intervaloE, getdate()) as time) 
	else
		INSERT INTO #asignaciones
		select 'Linea E', 100,'-','-'
else 
	if @tipoDia = 2
		if (cast(GETDATE() as time) between @inicioSabadoE and @finSabadoE)
			INSERT INTO #asignaciones
			select 'Linea E', count(*), (@intervaloE), (select top 1 HoraSale from DespachadosDetalles where IDDespacho = @IDDespachoE order by HoraSale desc) from DespachadosDetalles with (nolock) where IDDespacho = @IDDespachoE and HoraSale >= cast(DATEADD(MINUTE, -@intervaloE, getdate()) as time) 
		else
			INSERT INTO #asignaciones
			select 'Linea E', 100,'-','-'
	else 
			if (cast(GETDATE() as time) between @inicioDomingoFeriadoE and @finDomingoFeriadoE)
				INSERT INTO #asignaciones
				select 'Linea E', count(*), (@intervaloE), (select top 1 HoraSale from DespachadosDetalles where IDDespacho = @IDDespachoE order by HoraSale desc) from DespachadosDetalles with (nolock) where IDDespacho = @IDDespachoE and HoraSale >= cast(DATEADD(MINUTE, -@intervaloE, getdate()) as time) 
			else
				INSERT INTO #asignaciones
				select 'Linea E', 100,'-','-'

--Linea H
declare @IDDespachoH as int = (select iddespacho from Despachos with (nolock) where idlinea = 15 and FechaDespacho = cast(getdate() as date))
declare @intervaloH as int = 60
declare @inicioHabilH as time = DATEADD(MINUTE, @intervaloH, '05:30:00')
declare @finHabilH as time = '23:51:00'
declare @inicioSabadoH as time = DATEADD(MINUTE, @intervaloH, '06:00:00') 
declare @finSabadoH as time = '23:59:00'
declare @inicioDomingoFeriadoH as time = DATEADD(MINUTE, @intervaloH, '08:00:00')
declare @finDomingoFeriadoH as time = '22:51:00'



if @tipoDia = 1
	if (cast(GETDATE() as time) between @inicioHabilH and @finHabilH)
		INSERT INTO #asignaciones
		select 'Linea H', count(*), (@intervaloH), (select top 1 HoraSale from DespachadosDetalles where IDDespacho = @IDDespachoH order by HoraSale desc) from DespachadosDetalles with (nolock) where IDDespacho = @IDDespachoH and HoraSale >= cast(DATEADD(MINUTE, -@intervaloH, getdate()) as time) 
	else
		INSERT INTO #asignaciones
		select 'Linea H', 100,'-','-'
else 
	if @tipoDia = 2
		if (cast(GETDATE() as time) between @inicioSabadoH and @finSabadoH)
			INSERT INTO #asignaciones
			select 'Linea H', count(*), (@intervaloH), (select top 1 HoraSale from DespachadosDetalles where IDDespacho = @IDDespachoH order by HoraSale desc) from DespachadosDetalles with (nolock) where IDDespacho = @IDDespachoH and HoraSale >= cast(DATEADD(MINUTE, -@intervaloH, getdate()) as time) 
		else
			INSERT INTO #asignaciones
			select 'Linea H', 100,'-','-'
	else 
			if (cast(GETDATE() as time) between @inicioDomingoFeriadoH and @finDomingoFeriadoH)
				INSERT INTO #asignaciones
				select 'Linea H', count(*), (@intervaloH), (select top 1 HoraSale from DespachadosDetalles where IDDespacho = @IDDespachoH order by HoraSale desc) from DespachadosDetalles with (nolock) where IDDespacho = @IDDespachoH and HoraSale >= cast(DATEADD(MINUTE, -@intervaloH, getdate()) as time) 
			else
				INSERT INTO #asignaciones
				select 'Linea H', 100,'-','-'



DECLARE @Mail_HTML  NVARCHAR(MAX)= ''

SET @Mail_HTML =

			   N'<font face="verdana">'+
			   N'<h4>Ejecucion: '+ cast(GETDATE() as varchar(20)) +'</h4>'+
               N'<h4>Lineas donde no hay cargas de despachos en el intervalo definido: ' +'</h4>'+
               N'</font>'
			   +
               
               N'<table border="1" cellpadding="3" cellspacing="0">'+
               N'<thead>'+
               N'<tr style=''background:#3498DB;color: black;font-weight: bold;font-size:80%;font-family:Verdana;''>'+
               N'<th>Linea</th>'+
			   N'<th>Intervalo</th>'+
			   N'<th>UltimaCarga</th>'+
               N'</tr>'+
               N'</thead>'+
               N'<tbody align="center" style=''font-size:80%; font-family:Verdana;''>'+
               CAST ( (Select td = (convert(char(50),[Linea])), '',
							  td = (convert(char(50),[Intervalo])), '',
							  td = (convert(char(50),[UltimaCarga])), ''
               FROM #asignaciones where CantCargasFront = 0 FOR XML PATH('tr'), TYPE) AS NVARCHAR(MAX) ) +
               N'</tbody>'+
               N'</table>'


IF ((select count(*) from #asignaciones where CantCargasFront = 0) <> 0)
		EXEC msdb.dbo.sp_send_dbmail
			@recipients=N'monitoreoSE20@grupoprominente.com; monitoreoSE20@emova.com.ar; sapena@emova.com.ar',  
			@subject = 'SE 2.0 Monitoreo - No hay carga de despachos',
			@body = @Mail_HTML,
			@body_format = 'HTML';

drop table #asignaciones

