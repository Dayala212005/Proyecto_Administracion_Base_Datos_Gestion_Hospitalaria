--Indices
--Indices para la facilitacion 
CREATE NONCLUSTERED INDEX IX_FacturaCita_Medico ON cita.FACTURA_CITA(id_medico);
CREATE NONCLUSTERED INDEX IX_FacturaCita_Paciente ON cita.FACTURA_CITA(id_paciente);
CREATE NONCLUSTERED INDEX IX_DetalleMedicamento_Medicamento ON tratamiento.DETALLEXMEDICAMENTO(id_medicamento);
CREATE NONCLUSTERED INDEX IX_DetalleTratamiento_Tratamiento ON tratamiento.DETALLE_TRATAMIENTO(id_tratamiento);
GO
--Proceso almacenado para reconstruir indice
CREATE PROCEDURE sp_ReconstruirIndices
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @sql NVARCHAR(MAX);

    -- Genera el script para reconstruir todos los índices en la base actual
    SELECT @sql = STRING_AGG('ALTER INDEX [' + i.name + '] ON [' + s.name + '].[' + t.name + '] REBUILD;', CHAR(13))
    FROM sys.indexes i
    INNER JOIN sys.tables t ON i.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE i.type_desc <> 'HEAP' -- Solo índices, no heaps
      AND i.is_disabled = 0;

    EXEC sp_executesql @sql;
END;

EXEC sp_ReconstruirIndices;
SELECT * FROM dbo.VW_Indices;