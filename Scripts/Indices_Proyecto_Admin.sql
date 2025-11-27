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

CREATE VIEW vw_IndicesDetalles AS
SELECT  
    t.name AS Tabla,
    i.name AS Indice,
    i.index_id AS IdIndice,
    i.type_desc AS TipoIndice,
    i.is_unique AS EsUnico,
    i.is_primary_key AS EsPrimaryKey,
    i.is_unique_constraint AS EsUniqueConstraint,
    STUFF((
        SELECT ', ' + c.name
        FROM sys.index_columns ic2
        JOIN sys.columns c 
            ON ic2.object_id = c.object_id 
           AND ic2.column_id = c.column_id
        WHERE ic2.object_id = i.object_id
          AND ic2.index_id = i.index_id
          AND ic2.is_included_column = 0
        ORDER BY ic2.key_ordinal
        FOR XML PATH(''), TYPE).value('.', 'nvarchar(max)'),1,2,'') AS ColumnasClave,
    STUFF((
        SELECT ', ' + c.name
        FROM sys.index_columns ic2
        JOIN sys.columns c 
            ON ic2.object_id = c.object_id 
           AND ic2.column_id = c.column_id
        WHERE ic2.object_id = i.object_id
          AND ic2.index_id = i.index_id
          AND ic2.is_included_column = 1
        FOR XML PATH(''), TYPE).value('.', 'nvarchar(max)'),1,2,'') AS ColumnasIncluidas
FROM sys.indexes i
JOIN sys.tables t 
     ON i.object_id = t.object_id
WHERE i.index_id > 0;   -- excluye el heap
GO