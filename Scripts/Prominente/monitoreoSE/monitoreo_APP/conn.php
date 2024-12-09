<?php
$serverName = "emvalwayson.emv.com.ar";
$connectionOptions = array("Database"=>"ServicioEfectuado20", "Authentication"=>"WindowsAuthentication");

try {
    $conn = new PDO("sqlsrv:Server=$serverName;Database=ServicioEfectuado20", NULL, NULL, $connectionOptions);
    $conn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
    echo "Conexión establecida correctamente<br>";

    $sql = "select top 10 IDLinea, FechaDespacho, HoraSale, Formacion, count(*) as cantidad from ( select d.IDLinea, d.FechaDespacho, dd.HoraSale, f.nombre as Formacion from DespachadosDetalles dd left join despachos d on d.IDDespacho = dd.IDDespacho left join ProgramacionesDetalles pd on dd.IDProgramacionDetalle = pd.IDProgramacionDetalle left join Formaciones f on dd.IDFormacion = f.IDFormacion where dd.IDDespacho in (select IDDespacho from despachos where year(d.FechaDespacho)*10000+month(d.FechaDespacho)*100+day(d.FechaDespacho) = year(getdate())*10000+month(getdate())*100+day(getdate()))	and (not dd.IDFormacion is null) and (not dd.HoraSale is null) ) qq group by IDLinea, FechaDespacho, HoraSale, Formacion --having count(*) > 1";
    $stmt = $conn->prepare($sql);
    $stmt->execute();

    $contador = 1;
    while ($row = $stmt->fetch(PDO::FETCH_ASSOC)) {
	if ($contador == 1){
    		echo $row['FechaDespacho'] . "<br />";
	}
        echo $row['IDLinea'] . "  |  " . "  |  " . $row['HoraSale'] . "  |  " . $row['Formacion'] . "<br />";
	$contador++;
    }

} catch (PDOException $e) {
    die("Error en la conexión: " . $e->getMessage());
}
?>
