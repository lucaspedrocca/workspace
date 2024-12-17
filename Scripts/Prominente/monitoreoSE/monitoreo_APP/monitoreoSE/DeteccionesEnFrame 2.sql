--Monitorear si hay detecciones en el Frame de detecciones //Para todas las lineas, de forma general se cuenta la cantidad de detecciones que hubo en el intervalo definido. (Si es 0 es un alerta, en caso contrario esta OK)
USE [ServicioEfectuado20]

declare @tipoDia int  --1 Habil, 2 Sabado, 3 Domingo/Feriado

set @tipoDia = case when cast(getdate() as date) in (select fecha from ServicioEfectuado20.dbo.feriados with (nolock)) then (select idTipoDia from ServicioEfectuado20.dbo.feriados with (nolock) where Fecha = cast(getdate() as date)) else (case when datepart(weekday, getdate()) between 2 and 6 then 1 else (case when datepart(weekday, getdate()) = 7 then 2 else 3 end) end) end

DECLARE @CantDeteccionesEnFrame int 
declare @intervaloHabil as int = 5
declare @intervaloSabado as int = 7
declare @intervaloDomingoFeriado as int = 8
declare @intervaloGenerico as int
declare @inicioHabil as time = DATEADD(MINUTE, @intervaloHabil, '05:30:00')
declare @finHabil as time = '23:51:00'
declare @inicioSabado as time = DATEADD(MINUTE, @intervaloSabado, '06:00:00')
declare @finSabado as time = '23:59:00'
declare @inicioDomingoFeriado as time = DATEADD(MINUTE, @intervaloDomingoFeriado, '08:00:00')
declare @finDomingoFeriado as time = '22:51:00'


if @tipoDia = 1
	if (cast(GETDATE() as time) between @inicioHabil and @finHabil)
		BEGIN
		set @CantDeteccionesEnFrame = (select count(*) as CantDeteccionesEnFrame from ServicioEfectuado20.dbo.DeteccionesProcesadas with (nolock) where HoraE between DATEADD(MINUTE, -@intervaloHabil, GETDATE()) and GETDATE())
		set @intervaloGenerico = @intervaloHabil
		END
	else
		set @CantDeteccionesEnFrame = (select 100 as CantDeteccionesEnFrame)
else 
	if @tipoDia = 2
		if (cast(GETDATE() as time) between @inicioSabado and @finSabado)
			BEGIN
			set @CantDeteccionesEnFrame = (select count(*) as CantDeteccionesEnFrame from ServicioEfectuado20.dbo.DeteccionesProcesadas with (nolock) where HoraE between DATEADD(MINUTE, -@intervaloSabado, GETDATE()) and GETDATE())
			set @intervaloGenerico = @intervaloSabado
			END
		else
			set @CantDeteccionesEnFrame = (select 100 as CantDeteccionesEnFrame)
	else 
			if (cast(GETDATE() as time) between @inicioDomingoFeriado and @finDomingoFeriado)
				BEGIN
				set @CantDeteccionesEnFrame = (select count(*) as CantDeteccionesEnFrame from ServicioEfectuado20.dbo.DeteccionesProcesadas with (nolock) where HoraE between DATEADD(MINUTE, -@intervaloDomingoFeriado, GETDATE()) and GETDATE())
				set @intervaloGenerico = @intervaloDomingoFeriado
				END
			else
				set @CantDeteccionesEnFrame = (select 100 as CantDeteccionesEnFrame	)


DECLARE @Mail_HTML  NVARCHAR(MAX)= ''

SET @Mail_HTML =
               N'<font face="verdana">'+
               N'<h4>No hay detecciones en el frame de detecciones dentro de los ultimos: '+ cast((@intervaloGenerico) as varchar(10)) + ' minutos'+'</h4>'+
               N'</font>'

IF  @CantDeteccionesEnFrame =  0
		EXEC msdb.dbo.sp_send_dbmail
			@recipients=N'monitoreoSE20@grupoprominente.com; monitoreoSE20@emova.com.ar',  
			@subject = 'SE 2.0 Monitoreo - No hay detecciones en el frame de detecciones',
			@body = @Mail_HTML,
			@body_format = 'HTML';


