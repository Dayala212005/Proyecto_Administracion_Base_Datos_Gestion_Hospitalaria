--Migracion/carga de datos

--Procedimientos almacenados para cargar (importar) datos

--Importar Pacientes

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
        BULK INSERT Paciente.PACIENTE
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


EXEC USP_ImportarPacientes 'C:\importaciones\paciente.csv';


SELECT * FROM Paciente.PACIENTE
GO

--Importar medicamentos

CREATE OR ALTER PROCEDURE USP_ImportarMedicamentos
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
        BULK INSERT Catalogo.MEDICAMENTO
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


EXEC USP_ImportarMedicamentos 'C:\importaciones\medicamento.csv';

SELECT * FROM Catalogo.MEDICAMENTO



--Importar médicos

CREATE OR ALTER PROCEDURE USP_ImportarMedicos
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
        BULK INSERT Medico.MEDICO
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


EXEC USP_ImportarMedicos 'C:\importaciones\medico.csv';


SELECT * FROM Medico.MEDICO

