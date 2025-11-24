--Funciones

--Función Tabla para ver Factura según un intérvalo de fecha 

CREATE OR ALTER FUNCTION FN_FacturasPorFechas(
    @fecha_inicio DATE,
    @fecha_fin DATE
)
RETURNS TABLE
AS
RETURN
(
    SELECT 
        Cita.FACTURA_CITA.id_factura_cita,
        Cita.FACTURA_CITA.id_paciente,
        Cita.FACTURA_CITA.id_medico,
        Cita.FACTURA_CITA.fecha_cita,
        Cita.FACTURA_CITA.numero_factura,
        Cita.FACTURA_CITA.total_costo
    FROM Cita.FACTURA_CITA 
    WHERE Cita.FACTURA_CITA.fecha_cita BETWEEN @fecha_inicio AND @fecha_fin
);
GO

-- Para probarloo
SELECT * FROM FN_FacturasPorFechas('2023-01-01', '2024-12-31');
GO

--Calcular costo total
CREATE OR ALTER FUNCTION FN_CalcularCosto(
	@precio_tratamiento DECIMAL (10,2),
	@id_medicamento INT,
	@cantidad INT
)
RETURNS DECIMAL (10,2)
AS
BEGIN
	DECLARE @precio_medicamento DECIMAL(10,2);
	DECLARE @total_costo DECIMAL(10,2);

	SELECT TOP 1 @precio_medicamento = precio
	FROM CATALOGO.MEDICAMENTO
	WHERE id_medicamento = @id_medicamento;

    IF @precio_medicamento IS NULL
        SET @total_costo = 0;
    ELSE
        SET @total_costo = @precio_tratamiento + (@cantidad * @precio_medicamento);

	RETURN @total_costo
END;
GO
SELECT dbo.FN_CalcularCosto(175.51,3,1);
GO