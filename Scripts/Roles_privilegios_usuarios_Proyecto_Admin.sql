--Roles, privilegios y usuarios
--logins
USE master;

CREATE LOGIN l_recepcionista WITH PASSWORD = 'r12345';
CREATE LOGIN l_admin_medico WITH PASSWORD = 'am12345';
CREATE LOGIN l_farmacia WITH PASSWORD = 'f12345';
CREATE LOGIN l_cajero WITH PASSWORD = 'c12345';
CREATE LOGIN l_analista WITH PASSWORD = 'firulay';
CREATE LOGIN l_admin WITH PASSWORD = 'a12345';
CREATE LOGIN l_backup WITH PASSWORD = 'l12345';

--roles
USE GestionHospitalaria;

CREATE ROLE r_admin;

GRANT ALTER ANY ROLE TO r_admin;
GRANT ALTER ANY USER TO r_admin;
GRANT CREATE TABLE TO r_admin;
GRANT CREATE VIEW TO r_admin;
GRANT CREATE PROCEDURE TO r_admin;
GRANT CREATE FUNCTION TO r_admin;
GRANT CREATE SEQUENCE TO r_admin;
GRANT ALTER TO r_admin;
GRANT VIEW DEFINITION TO r_admin;
GRANT SELECT TO r_admin;
GRANT EXECUTE ON OBJECT::dbo.USP_ImportarPaciente TO r_admin;
GRANT EXECUTE ON OBJECT::dbo.USP_ImportarMedicamentos TO r_admin;
GRANT EXECUTE ON OBJECT::dbo.USP_ImportarMedicos TO r_admin;


CREATE ROLE r_backup;

--grant a nivel servidor
USE master;
GRANT BACKUP DATABASE TO l_backup;
GRANT BACKUP LOG TO l_backup;

USE GestionHospitalaria;

CREATE ROLE r_recepcionista;

GRANT EXECUTE ON OBJECT::dbo.USP_RegistrarPaciente TO r_recepcionista;
GRANT EXECUTE ON OBJECT::dbo.USP_RegistrarEmailPaciente TO r_recepcionista;
GRANT EXECUTE ON OBJECT::dbo.USP_RegistrarTelefonoPaciente TO r_recepcionista;
GRANT SELECT ON OBJECT::dbo.VW_Paciente TO r_recepcionista;
GRANT SELECT ON OBJECT::dbo.VW_EmailPaciente TO r_recepcionista;
GRANT SELECT ON OBJECT::dbo.VW_TelefonoPaciente TO r_recepcionista;

CREATE ROLE r_admin_medico;

GRANT EXECUTE ON OBJECT::dbo.USP_RegistrarMedico TO r_admin_medico;
GRANT EXECUTE ON OBJECT::dbo.USP_RegistrarEmailMedico TO r_admin_medico;
GRANT EXECUTE ON OBJECT::dbo.USP_RegistrarTelefonoMedico TO r_admin_medico;
GRANT SELECT ON OBJECT::dbo.VW_Medico TO r_admin_medico;
GRANT SELECT ON OBJECT::dbo.VW_EmailMedicos TO r_admin_medico;
GRANT SELECT ON OBJECT::dbo.VW_TelefonoMedicos TO r_admin_medico;

CREATE ROLE r_farmacia;

GRANT EXECUTE ON OBJECT::dbo.USP_RegistrarMedicamento TO r_farmacia;
GRANT SELECT ON OBJECT::dbo.VW_Medicamento TO r_farmacia;

CREATE ROLE r_cajero;

GRANT EXECUTE ON OBJECT::dbo.USP_RegistrarFactura TO r_cajero;
GRANT SELECT ON OBJECT::dbo.FN_FacturasPorFechas TO r_cajero;
GRANT SELECT ON OBJECT::dbo.VW_Paciente     TO r_cajero;
GRANT SELECT ON OBJECT::dbo.VW_Medico       TO r_cajero;
GRANT SELECT ON OBJECT::dbo.VW_Medicamento  TO r_cajero;

CREATE ROLE r_analista;

GRANT SELECT ON OBJECT::dbo.VW_Paciente         TO r_analista;
GRANT SELECT ON OBJECT::dbo.VW_Medico           TO r_analista;
GRANT SELECT ON OBJECT::dbo.VW_Medicamento      TO r_analista;
GRANT SELECT ON OBJECT::dbo.VW_EmailPaciente    TO r_analista;
GRANT SELECT ON OBJECT::dbo.VW_TelefonoPaciente TO r_analista;
GRANT SELECT ON OBJECT::dbo.VW_EmailMedicos     TO r_analista;
GRANT SELECT ON OBJECT::dbo.VW_TelefonoMedicos  TO r_analista;
GRANT SELECT ON OBJECT::dbo.VW_Indices          TO r_analista;
GRANT SELECT ON OBJECT::dbo.FN_FacturasPorFechas TO r_analista;

--usuarios

USE GestionHospitalaria;

CREATE USER u_recepcionista FOR LOGIN l_recepcionista;
ALTER ROLE r_recepcionista ADD MEMBER u_recepcionista;

CREATE USER u_admin_medico FOR LOGIN l_admin_medico;
ALTER ROLE r_admin_medico ADD MEMBER u_admin_medico;

CREATE USER u_farmacia FOR LOGIN l_farmacia;
ALTER ROLE r_farmacia ADD MEMBER u_farmacia;

CREATE USER u_cajero FOR LOGIN l_cajero;
ALTER ROLE r_cajero ADD MEMBER u_cajero;

CREATE USER u_analista FOR LOGIN l_analista;
ALTER ROLE r_analista ADD MEMBER u_analista;

CREATE USER u_admin FOR LOGIN l_admin;
ALTER ROLE r_admin ADD MEMBER u_admin;

CREATE USER u_backup FOR LOGIN l_backup;
ALTER ROLE r_backup ADD MEMBER u_backup;

--Vista para ver roles

CREATE OR ALTER VIEW VW_Roles
AS
SELECT 
    dp.name AS RoleName,
    dp.type_desc AS RoleType,
    perm.permission_name,
    perm.state_desc AS PermissionState,
    obj.name AS ObjectName,
    obj.type_desc AS ObjectType,
    m.name AS RoleMember
FROM sys.database_principals dp
LEFT JOIN sys.database_permissions perm ON dp.principal_id = perm.grantee_principal_id
LEFT JOIN sys.objects obj ON perm.major_id = obj.object_id
LEFT JOIN sys.database_role_members drm ON dp.principal_id = drm.role_principal_id
LEFT JOIN sys.database_principals m ON drm.member_principal_id = m.principal_id
WHERE dp.type = 'R'
  AND dp.name LIKE 'R%';
GO

SELECT * FROM dbo.VW_Roles
GO
