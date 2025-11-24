--Triggers
--Validacion de precio Tratamiento
CREATE OR ALTER TRIGGER TRG_ValidarPrecioTratamiento
ON TRATAMIENTO.DETALLE_TRATAMIENTO
AFTER INSERT, UPDATE
AS
BEGIN
    IF EXISTS (
        SELECT 1
        FROM inserted
        WHERE precio < 0
    )
    BEGIN
        RAISERROR('El precio del tratamiento no puede ser negativo.', 16, 1);
        ROLLBACK TRANSACTION;
    END;
END;
GO

--Validacion de precio Medicamento
CREATE OR ALTER TRIGGER TRG_ValidarPrecioMedicamento
ON CATALOGO.MEDICAMENTO
AFTER INSERT, UPDATE
AS
BEGIN
    IF EXISTS (
        SELECT 1
        FROM inserted
        WHERE precio < 0
    )
    BEGIN
        RAISERROR('El precio del medicamento no puede ser negativo.', 16, 1);
        ROLLBACK TRANSACTION;
    END;
END;
GO

--Validacion de costo total Factura
CREATE OR ALTER TRIGGER TRG_ValidarCostoTotalFactura
ON CITA.FACTURA_CITA
AFTER INSERT, UPDATE
AS
BEGIN
    IF EXISTS (
        SELECT 1
        FROM inserted
        WHERE total_costo < 0
    )
    BEGIN
        RAISERROR('El costo total de la factura no puede ser negativo.', 16, 1);
        ROLLBACK TRANSACTION;
    END;
END;
GO