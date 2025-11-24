--Migracion/carga de datos

--Procedimiento almacenado para cargar (importar) datos

CREATE OR ALTER PROCEDURE USP_ImportarPacientes
    @archivo NVARCHAR(400)
AS
BEGIN

    DECLARE @sql NVARCHAR(MAX);
    DECLARE @extension NVARCHAR(10);

    -- Obtener extensión (.csv o .dat)
    SET @extension = LOWER(RIGHT(@archivo, CHARINDEX('.', REVERSE(@archivo))));

    IF @extension NOT IN ('.csv', '.dat')
    BEGIN
        RAISERROR('Solo se permiten archivos CSV o DAT.', 16, 1);
        RETURN;
    END

    -- Generar comando BULK INSERT
    SET @sql = '
        BULK INSERT PACIENTE
        FROM ''' + @archivo + '''
        WITH (
            FIRSTROW = 2,              -- ignora encabezado
            FIELDTERMINATOR = '','',   -- separador CSV o DAT
            ROWTERMINATOR = ''\n'',    -- fin de línea
            TABLOCK
        );
    ';

    EXEC (@sql);
END;
GO


EXEC USP_ImportarPacientes 'C:\backups\pacientes_ejemplo.csv';

SELECT * FROM PACIENTE.PACIENTE