--Vistas y funciones ventanas
--Vista para calcular total por pacientes
CREATE VIEW vw_TotalPorPaciente
AS
SELECT
    NombrePaciente,
    PacienteID,
    TotalFacturas
FROM (
    SELECT 
        PACIENTE.nombre AS NombrePaciente,
        PACIENTE.id_paciente AS PacienteID,
        SUM(total_costo) OVER (PARTITION BY PACIENTE.id_paciente) AS TotalFacturas,
        ROW_NUMBER() OVER (PARTITION BY PACIENTE.id_paciente ORDER BY FACTURA_CITA.fecha_cita DESC) AS rn
    FROM cita.FACTURA_CITA
    INNER JOIN Paciente.PACIENTE 
        ON PACIENTE.id_paciente = FACTURA_CITA.id_paciente
) AS sub
WHERE rn = 1;
GO
SELECT * FROM dbo.vw_TotalPorPaciente;
GO
--Vista para ver medicamentos con mayor demanda

CREATE VIEW vw_DemandaMedicamentos
AS
SELECT 
    ID_Medicamento,
    NombreMedicamento,
    VecesRecetado,
    RANK() OVER (ORDER BY VecesRecetado DESC) AS RankingMedicamento
FROM (
    SELECT 
        MEDICAMENTO.id_medicamento AS ID_Medicamento,
        MEDICAMENTO.nombre AS NombreMedicamento,
        COUNT(*) OVER (PARTITION BY MEDICAMENTO.id_medicamento) AS VecesRecetado,
        ROW_NUMBER() OVER (PARTITION BY MEDICAMENTO.id_medicamento ORDER BY MEDICAMENTO.id_medicamento) AS rn
    FROM tratamiento.DETALLEXMEDICAMENTO
    INNER JOIN Catalogo.MEDICAMENTO 
        ON MEDICAMENTO.id_medicamento = DETALLEXMEDICAMENTO.id_medicamento
) AS sub
WHERE rn = 1;

GO
SELECT * FROM dbo.vw_DemandaMedicamentos;
GO

--Vista de Ranking de medicos 
CREATE VIEW vw_MedicosRanking
AS
SELECT 
    IdMedico,
    NombreMedico,
    PacientesAtendidos,
    TotalGenerado,
    RANK() OVER (ORDER BY TotalGenerado DESC) AS RankingPorIngresos
FROM (
    SELECT 
        MEDICO.id_medico AS IdMedico,
        MEDICO.nombre AS NombreMedico,
        COUNT(DISTINCT FACTURA_CITA.id_paciente) AS PacientesAtendidos,
        SUM(FACTURA_CITA.total_costo) AS TotalGenerado
    FROM cita.FACTURA_CITA
    INNER JOIN Medico.MEDICO 
        ON MEDICO.id_medico = FACTURA_CITA.id_medico
    GROUP BY MEDICO.id_medico, MEDICO.nombre
) AS sub;
GO
SELECT * FROM dbo.vw_MedicosRanking
GO
--Vista para ver los ingresos acumulados por fechas
CREATE VIEW vw_IgresosAcumuladosFechas
AS
SELECT
    fecha_cita,
    SUM(total_costo) OVER (ORDER BY fecha_cita ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS IngresoAcumulado
FROM cita.FACTURA_CITA;;
GO
SELECT * FROM dbo.vw_IgresosAcumuladosFechas
GO

--VISTAS
--Para ver los email de los médicos

CREATE OR ALTER VIEW VW_EmailMedicos
AS
SELECT 
    MEDICO.MEDICO.id_medico,
    MEDICO.MEDICO.nombre AS 'Nombre del médico',
    MEDICO.MEDICO_EMAIL.email
FROM MEDICO.MEDICO 
INNER JOIN MEDICO.MEDICO_EMAIL
    ON MEDICO.id_medico = MEDICO_EMAIL.id_medico;
GO

SELECT * FROM dbo.VW_EmailMedicos
GO

--Para ver los telefonos de los médicos

CREATE OR ALTER VIEW VW_TelefonoMedicos
AS
SELECT 
    MEDICO.MEDICO.id_medico,
    MEDICO.MEDICO.nombre AS 'Nombre del médico',
    MEDICO.MEDICO_TELEFONO.telefono
FROM MEDICO.MEDICO
INNER JOIN MEDICO.MEDICO_TELEFONO
    ON MEDICO.id_medico = MEDICO_TELEFONO.id_medico;

GO
SELECT * FROM dbo.VW_TelefonoMedicos
GO

--Paciente
CREATE OR ALTER VIEW VW_Paciente AS
SELECT nombre AS 'Nombre del Paciente',
dui AS 'DUI del Paciente',
numero_seguro AS 'Numero de seguro del Paciente'
FROM PACIENTE.PACIENTE;
GO
SELECT * FROM dbo.VW_Paciente 
GO
--Medicos
CREATE OR ALTER VIEW VW_Medico AS
SELECT  nombre AS 'Nombre del Medico',
especialidad AS 'Especialidad',
dui AS 'DUI del Medico'
FROM MEDICO.MEDICO;
GO
SELECT * FROM dbo.VW_Medico;
GO
--Medicamentos
CREATE OR ALTER VIEW VW_Medicamento AS
SELECT nombre AS 'Nombre del Medicamento',
marca AS 'Marca',
CONCAT('$' ,FORMAT(precio, 'N2')) AS 'Precio del Medicamento'
FROM CATALOGO.MEDICAMENTO;
GO
SELECT * FROM dbo.VW_Medicamento;
GO
--Email Paciente
CREATE OR ALTER VIEW VW_EmailPaciente AS
SELECT PACIENTE.nombre AS 'Nombre del paciente', 
paciente.numero_seguro AS 'Numero de seguro',
PACIENTE_EMAIL.email AS 'Email del paciente'
FROM PACIENTE.PACIENTE_EMAIL 
INNER JOIN PACIENTE.PACIENTE
ON PACIENTE.PACIENTE.id_paciente = PACIENTE.PACIENTE_EMAIL.id_paciente;
GO
SELECT * FROM dbo.VW_EmailPaciente
GO
--Telefono
CREATE OR ALTER VIEW VW_TelefonoPaciente AS
SELECT PACIENTE.nombre AS 'Nombre del paciente',
PACIENTE.numero_seguro AS 'Numero de seguro',
PACIENTE_TELEFONO.telefono AS 'Numero Telefonico del paciente'
FROM PACIENTE.PACIENTE_TELEFONO
INNER JOIN PACIENTE.PACIENTE
ON PACIENTE.id_paciente = PACIENTE_TELEFONO.id_paciente;
GO
SELECT * FROM dbo.VW_TelefonoPaciente;
GO
USE GestionHospitalaria
GO
CREATE OR ALTER VIEW VW_FActuraCita 
AS
SELECT 
FACTURA_CITA.numero_factura 'Numero de factura',
PACIENTE.nombre 'Nombre del Paciente',
MEDICO.nombre 'Medico que atendio la cita',
DETALLE_TRATAMIENTO.descripcion 'Descripcion de tratamiento',
MEDICAMENTO.nombre 'Mediamento usado',
FACTURA_CITA.fecha_cita 'Fecha de realizacion de cita',
FACTURA_CITA.total_costo 'Costo total de la cita'
FROM Cita.FACTURA_CITA
INNER JOIN Paciente.PACIENTE ON PACIENTE.id_paciente = FACTURA_CITA.id_paciente
INNER JOIN Medico.MEDICO ON MEDICO.id_medico = FACTURA_CITA.id_medico
INNER JOIN Tratamiento.DETALLE_TRATAMIENTO ON DETALLE_TRATAMIENTO.id_factura_cita = FACTURA_CITA.id_factura_cita
INNER JOIN Tratamiento.DETALLEXMEDICAMENTO ON DETALLEXMEDICAMENTO.id_tratamiento = DETALLE_TRATAMIENTO.id_tratamiento
INNER JOIN Catalogo.MEDICAMENTO ON MEDICAMENTO.id_medicamento = DETALLEXMEDICAMENTO.id_medicamento;


