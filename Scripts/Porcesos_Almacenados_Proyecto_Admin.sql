--Procesos almacenados
--Para registrar un médico

CREATE OR ALTER PROCEDURE USP_RegistrarMedico
	@nombre_medico NVARCHAR(100),
	@dui_medico VARCHAR(10),
	@especialidad NVARCHAR(100),
	@email_medico NVARCHAR(100),
	@telefono_medico VARCHAR(15)
AS
BEGIN
	DECLARE @id_medico INT;

	IF @email_medico NOT LIKE '%_@_%._%'
		BEGIN
			RAISERROR('El email no tiene un formato válido.', 16, 1);
			RETURN;
		END;

	IF @telefono_medico NOT LIKE '+503%'
        BEGIN
            RAISERROR('El teléfono debe comenzar con +503.', 16, 1);
            RETURN;
        END;

	INSERT INTO MEDICO.MEDICO(nombre, especialidad, dui)
	VALUES (@nombre_medico, @especialidad, @dui_medico);

	SET @id_medico = SCOPE_IDENTITY();

	INSERT INTO MEDICO.MEDICO_EMAIL(id_medico, email)
	VALUES(@id_medico, @email_medico);

	INSERT INTO MEDICO.MEDICO_TELEFONO(id_medico, telefono)
	VALUES(@id_medico, @telefono_medico);

END;
GO

EXEC dbo.USP_RegistrarMedico 'María Elizabeth', 'DUI210710', 'Pediatría','maria@gmail.com', '+50378901234';
GO

-- Registrar el email del médico

CREATE OR ALTER PROCEDURE USP_RegistrarEmailMedico
	@email_medico NVARCHAR(100),
	@dui_medico VARCHAR(10)
AS
BEGIN
	IF @email_medico NOT LIKE '%_@_%._%'
		BEGIN
			RAISERROR('El email no tiene un formato válido.', 16, 1);
			RETURN;
		END;

	DECLARE @id_medico INT;

	SELECT @id_medico = id_medico
	FROM MEDICO.MEDICO
	WHERE dui = @dui_medico;

	IF @id_medico IS NULL
		BEGIN
			RAISERROR('El médico con el DUI especificado no existe.', 16, 1);
			RETURN;
		END;

	INSERT INTO MEDICO.MEDICO_EMAIL(id_medico, email)
	VALUES(@id_medico, @email_medico);

END;
GO

EXEC dbo.USP_RegistrarEmailMedico 'maria2@gmail.com', 'DUI210710';
GO

--Registrar el teléfono del médico

CREATE OR ALTER PROCEDURE USP_RegistrarTelefonoMedico
    @telefono_medico VARCHAR(15),
    @dui_medico VARCHAR(10)
AS
BEGIN
    DECLARE @id_medico INT;

    SELECT @id_medico = id_medico
    FROM MEDICO.MEDICO
    WHERE dui = @dui_medico;

    IF @id_medico IS NULL
        BEGIN
            RAISERROR('El médico con el DUI especificado no existe.', 16, 1);
            RETURN;
        END;

    IF @telefono_medico NOT LIKE '+503%'
        BEGIN
            RAISERROR('El teléfono debe comenzar con +503.', 16, 1);
            RETURN;
        END;

    INSERT INTO MEDICO.MEDICO_TELEFONO(id_medico, telefono)
    VALUES(@id_medico, @telefono_medico);

END;
GO

EXEC dbo.USP_RegistrarTelefonoMedico '+50370001122', 'DUI210710';
GO

-- Registrar Medicamento

CREATE OR ALTER PROCEDURE USP_RegistrarMedicamento
    @nombre_medicamento NVARCHAR(100),
    @marca_medicamento NVARCHAR(100),
    @precio_medicamento DECIMAL(10,2)
AS
BEGIN
    
    INSERT INTO Catalogo.MEDICAMENTO(nombre, marca, precio)
    VALUES (@nombre_medicamento, @marca_medicamento, @precio_medicamento);

END;
GO

EXEC dbo.USP_RegistrarMedicamento 'Ibuprofeno','MK', 3.25;
GO

--Registrar Paciente

CREATE OR ALTER PROCEDURE USP_RegistrarPaciente
	@nombre_paciente NVARCHAR(100),
	@dui_paciente VARCHAR(10),
	@numero_seguro VARCHAR(20), 
	@email_paciente NVARCHAR(100),
	@telefono_paciente VARCHAR(15)
AS
BEGIN
	DECLARE @id_paciente INT;

	
    IF @email_paciente NOT LIKE '%_@_%._%'
		BEGIN
			RAISERROR('El email no tiene un formato válido.', 16, 1);
			RETURN;
		END;

	INSERT INTO PACIENTE.PACIENTE (nombre, dui, numero_seguro)
	VALUES (@nombre_paciente, @dui_paciente, @numero_seguro);

	
     SET @id_paciente = SCOPE_IDENTITY();

    INSERT INTO PACIENTE.PACIENTE_EMAIL(id_paciente, email)
    VALUES (@id_paciente, @email_paciente);

    INSERT INTO PACIENTE.PACIENTE_TELEFONO(id_paciente, telefono)
    VALUES (@id_paciente, @telefono_paciente);

END;
GO

EXEC dbo.USP_RegistrarPaciente 'Daniel Ayala','DUI212005','SEG212005','daniel@gmail.com','77552222'
GO

--Registrar Email Paciente
CREATE OR ALTER PROCEDURE USP_RegistrarEmailPaciente
	@email_paciente NVARCHAR(100),
	@dui_paciente VARCHAR(10)
AS
BEGIN
	IF @email_paciente NOT LIKE '%_@_%._%'
		BEGIN
			RAISERROR('El email no tiene un formato válido.', 16, 1);
			RETURN;
		END;
	DECLARE @id_paciente INT;

	SELECT @id_paciente = id_paciente
	FROM PACIENTE.PACIENTE 
	WHERE dui = @dui_paciente
	
	IF @id_paciente IS NULL
		BEGIN
			RAISERROR('El paciente con el DUI especificado no existe.', 16, 1);
        RETURN;
    END;

	INSERT INTO PACIENTE.PACIENTE_EMAIL(id_paciente, email)
    VALUES (@id_paciente, @email_paciente);

END;
GO

EXEC dbo.USP_RegistrarEmailPaciente 'daniel2@gmail.com','DUI212005'
GO
--Registrar Telefono Paciente

CREATE OR ALTER PROCEDURE USP_RegistrarTelefonoPaciente
	@telefono_paciente NVARCHAR(100),
	@dui_paciente VARCHAR(10)
AS
BEGIN
	DECLARE @id_paciente INT;

	SELECT @id_paciente = id_paciente
	FROM PACIENTE.PACIENTE 
	WHERE dui = @dui_paciente

	
	IF @id_paciente IS NULL
		BEGIN
			RAISERROR('El paciente con el DUI especificado no existe.', 16, 1);
        RETURN;
    END;

	INSERT INTO PACIENTE.PACIENTE_TELEFONO(id_paciente, telefono)
    VALUES (@id_paciente, @telefono_paciente);

END;
GO
EXEC dbo.USP_RegistrarTelefonoPaciente '77734565','DUI212005'
GO
--Secuencias

CREATE SEQUENCE SEQ_FacturaNumero
    AS INT
    START WITH 1
    INCREMENT BY 1;
GO

--Registrar Factura 
CREATE OR ALTER PROCEDURE USP_RegistrarFactura
	@dui_paciente VARCHAR(10),
	@fecha_cita DATE,
	@nombre_tratamiento NVARCHAR(100),
	@precio_tratamiento DECIMAL(10,2),
	@descripcion_tratamiento NVARCHAR(255),
	@id_medicamento INT,
	@cantidad_medicamento INT,
	@dui_medico VARCHAR(10)
AS
BEGIN

	DECLARE @id_paciente INT;
	DECLARE @id_medico INT;
	DECLARE @numero_factura INT;
	SET @numero_factura = CONVERT(VARCHAR(20), NEXT VALUE FOR SEQ_FacturaNumero);
	DECLARE @total_costo DECIMAL(10,2);
	SET @total_costo = dbo.FN_CalcularCosto(@precio_tratamiento,@id_medicamento,@cantidad_medicamento);
	DECLARE @id_factura INT;
	DECLARE @id_tratamiento INT;

	SELECT @id_paciente = id_paciente
	FROM PACIENTE.PACIENTE 
	WHERE dui = @dui_paciente
	
	IF @id_paciente IS NULL
		BEGIN
			RAISERROR('El paciente con el DUI especificado no existe.', 16, 1);
        RETURN;
    END;

	SELECT @id_medico = id_medico
	FROM MEDICO.MEDICO
	WHERE dui = @id_medico
	
	IF @id_medico IS NULL
		BEGIN
			RAISERROR('El Medico con el DUI especificado no existe.', 16, 1);
        RETURN;
    END;

	
	BEGIN TRY
		BEGIN TRANSACTION;

			INSERT INTO CITA.FACTURA_CITA (id_paciente,id_medico,fecha_cita, numero_factura,total_costo)
			VALUES (@id_paciente,@id_medico,@fecha_cita,@numero_factura,@total_costo);

	
			SET @id_factura = SCOPE_IDENTITY();

			INSERT INTO Tratamiento.DETALLE_TRATAMIENTO (id_factura_cita, nombre, precio, descripcion)
			VALUES (@id_factura, @nombre_tratamiento, @precio_tratamiento, @descripcion_tratamiento);

	
			SET @id_tratamiento = SCOPE_IDENTITY();

			INSERT INTO Tratamiento.DETALLEXMEDICAMENTO (id_tratamiento,id_medicamento)
			VALUES (@id_tratamiento, @id_medicamento);

			COMMIT TRANSACTION

	
		END TRY
			BEGIN CATCH
				ROLLBACK TRANSACTION;
				RAISERROR('Error al registrar la factura y detalles.', 16, 1);
			END CATCH;
END;
GO