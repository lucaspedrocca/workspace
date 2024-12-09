use Emova_CV

DECLARE @HORAINICIO INTEGER = 645;
DECLARE @HORAFIN INTEGER = 2300;
DECLARE @HORAINICIOSAB INTEGER = 645;
DECLARE @HORAFINSAB INTEGER = 2320;
DECLARE @HORAINICIODOM INTEGER = 845;
DECLARE @HORAFINDOM INTEGER = 2220;
DECLARE @CONTROLDET INTEGER = 7;

-- Detecciones, no puede estar en 0
select /*line_name, station_name,*/ case when datepart(weekday, getdate()) between 2 and 6 then
    case when DATENAME(HOUR, GETDATE())*100+DATENAME(MINUTE, GETDATE()) between @HORAINICIO and @HORAFIN then count(*) else 100 end
	else case when datepart(weekday, getdate()) = 7 then 
    case when DATENAME(HOUR, GETDATE())*100+DATENAME(MINUTE, GETDATE()) between @HORAINICIOSAB and @HORAFINSAB then count(*) else 100 end
	else case when DATENAME(HOUR, GETDATE())*100+DATENAME(MINUTE, GETDATE()) between @HORAINICIODOM and @HORAFINDOM then count(*) else 100 end
	end
	end as cantidad 
	from (SELECT distinct r.hash, s.line_name, s.station_name 
				FROM records_resumen r with (nolock) 
				inner join sources s with (nolock) on r.source_id = s.id 
				inner join markers m with (nolock) ON m.id = r.marker_id 
				where r.source_datetime >= DATEADD(MINUTE, -@CONTROLDET, GETDATE()) and r.source_datetime  < GETDATE() 
				and (m.line_name = 'A' and s.station_name IN ('PTO', 'PMA'))
				--or (m.line_name = 'B' and s.station_name IN ('ALM', 'ROS'))
				--or (m.line_name = 'C' and s.station_name IN ('CON', 'RET'))
				--or (m.line_name = 'D' and s.station_name IN ('COT', 'CAT'))
				--or (m.line_name = 'E' and s.station_name IN ('RET', 'VIR'))
				--or (m.line_name = 'H' and s.station_name IN ('FDE', 'HOS'))
	) qq
	--group by line_name, station_name
	--order by 1,2;

 	