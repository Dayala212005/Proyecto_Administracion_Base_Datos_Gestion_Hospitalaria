--Especificaciones de auditoria
USE master;
CREATE SERVER AUDIT Audit_GestionHospitalaria
TO FILE (FILEPATH = 'C:\audits\', MAXSIZE = 100 MB, 
MAX_ROLLOVER_FILES = 4000)
WITH (QUEUE_DELAY = 1000, ON_FAILURE = CONTINUE);
ALTER SERVER AUDIT Audit_GestionHospitalaria WITH (STATE = ON);

USE GestionHospitalaria;
--Auditoria para procesos almacenados y esquemas
CREATE DATABASE AUDIT SPECIFICATION Audit_DB_GestionHospitalaria
FOR SERVER AUDIT Audit_GestionHospitalaria
ADD (EXECUTE ON OBJECT::dbo.USP_RegistrarFactura BY PUBLIC),
ADD (EXECUTE ON OBJECT::dbo.USP_RegistrarMedicamento BY PUBLIC),
ADD (EXECUTE ON OBJECT::dbo.USP_RegistrarPaciente BY PUBLIC),
ADD (EXECUTE ON OBJECT::dbo.USP_RegistrarMedico BY PUBLIC),
ADD (INSERT ON OBJECT::Cita.FACTURA_CITA BY PUBLIC),
ADD (INSERT ON OBJECT::Catalogo.MEDICAMENTO BY PUBLIC),
ADD (EXECUTE ON OBJECT::dbo.USP_ImportarPacientes BY PUBLIC),
ADD (EXECUTE ON OBJECT::dbo.USP_ImportarMedicos BY PUBLIC),
ADD (EXECUTE ON OBJECT::dbo.USP_ImportarMedicamentos BY PUBLIC)
WITH (STATE = ON);
GO

CREATE VIEW vw_AuditoriaEventos
AS
SELECT
    event_time        AS FechaEvento,         
    action_id         AS TipoAccion,           
    statement         AS SentenciaSQL,          
    database_name     AS BaseDatos,            
    schema_name       AS Esquema,               
    object_name       AS Objeto,                
    server_principal_name AS UsuarioServidor,   
    session_id        AS IdSesion,             
    client_ip         AS IPCliente            
FROM sys.fn_get_audit_file('C:\audits\*', DEFAULT, DEFAULT);
GO

SELECT * FROM vw_AuditoriaEventos

EXEC USP_RegistrarPaciente 'Pepito Juancito Perez Lopez','7781220','123456','pjuancito@gmail.com','77788811'
