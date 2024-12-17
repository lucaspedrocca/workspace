--Monitorear detecciones sin procesar en el ultimo minuto//(Si es 0 es OK, en caso contrario es un alerta)
USE [ServicioEfectuado20]

DECLARE @CantDeteccionesSinProcesar int 
declare @inicio as time = '05:30:00'
declare @fin as time = '23:59:00'

if (cast(GETDATE() as time) between @inicio and @fin)
	SET @CantDeteccionesSinProcesar = (select count(*) as CantDeteccionesSinProcesar from detecciones with (nolock) where procesada = 0 and enddatetime <= DATEADD(MINUTE, -5, getdate()))
else
	SET @CantDeteccionesSinProcesar = 0


DECLARE @Mail_HTML  NVARCHAR(MAX)= ''

SET @Mail_HTML =
               N'<font face="verdana">'+
               N'<h4>Cantidad de detecciones sin procesar: '+ cast(@CantDeteccionesSinProcesar as varchar) +'</h4>'+
               N'</font>'

IF @CantDeteccionesSinProcesar <> 0
		EXEC msdb.dbo.sp_send_dbmail
			@recipients=N'monitoreoSE20@grupoprominente.com; monitoreoSE20@emova.com.ar',  
			@subject = 'SE 2.0 Monitoreo - Detecciones sin procesar',
			@body = @Mail_HTML,
			@body_format = 'HTML';

