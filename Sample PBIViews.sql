DROP VIEW IF EXISTS dbo.vw_pbiAction
GO

CREATE VIEW dbo.vw_pbiAction
AS
SELECT DISTINCT 
	CAST(ActionCode AS VARCHAR(5)) AS ActionID, 
	CAST(Action AS VARCHAR(40)) AS [Action]
FROM dbo.StageIncident
GO


DROP VIEW IF EXISTS dbo.vw_pbiAttendanceType
GO

CREATE VIEW dbo.vw_pbiAttendanceType
AS
SELECT DISTINCT
	CAST(IIF(AttendCode='.', 'Pr', AttendCode) AS VARCHAR(5)) AttendanceTypeID,
	CAST(AttendType AS VARCHAR(40)) AttendType
FROM dbo.StageClassAttendance

GO



DROP VIEW IF EXISTS dbo.vw_pbiCourse
GO

CREATE VIEW dbo.vw_pbiCourse
AS
SELECT 
	DISTINCT
		CAST(mstuniq AS BIGINT) CourseID,
		CAST(CourseCode AS VARCHAR(15)) CourseCode,
		CAST(CourseName AS VARCHAR(40)) CourseName
FROM dbo.StageClassAttendance

GO


DROP VIEW IF EXISTS dbo.vw_pbiIncident
GO

CREATE VIEW dbo.vw_pbiIncident
AS
SELECT DISTINCT
	CAST(incidentcode AS VARCHAR(5)) IncidentCodeID,
	CAST(incident AS VARCHAR(40)) Incident
FROM dbo.StageIncident
GO

DROP VIEW IF EXISTS dbo.vw_pbiInvolvement
GO

CREATE VIEW dbo.vw_pbiInvolvement
AS
SELECT	DISTINCT
	CAST(involvementcode AS VARCHAR(5)) InvolvementCodeID,
	CAST(involvement AS VARCHAR(20)) Involvement
FROM dbo.StageIncident
GO


DROP VIEW IF EXISTS dbo.vw_pbiSchool
GO

CREATE VIEW dbo.vw_pbiSchool
AS
SELECT 
	DISTINCT
		CAST(SchoolCode AS INT) SchoolID,
		CAST(SchoolName AS VARCHAR(40)) SchoolName
FROM dbo.Schools
GO

DROP VIEW IF EXISTS dbo.vw_pbiStudent
GO

CREATE VIEW dbo.vw_pbiStudent
AS
SELECT 
	CAST(d.StudentID AS BIGINT) StudentID,
	RIGHT(NEWID(),12)+', '+ IIF(d.GenderCode = 'F', 'Female', 'Male') StudentName,
	IIF(d.GenderCode = 'F', 'Female', 'Male') Gender,
	CAST(d.FederalRaceRptCategory AS VARCHAR(50)) FederalRaceCategory,
	CAST(d.PrimaryLanguage AS VARCHAR(25)) PrimaryLanguage,
	CAST(d.Grade as int) GradeNum,
	CASE 
		WHEN d.Grade = '1' THEN 'First'
		WHEN d.Grade = '2' THEN 'Second'
		WHEN d.Grade = '3' THEN 'Third'
		WHEN d.Grade = '4' THEN 'Fourth'
		WHEN d.Grade = '5' THEN 'Fifth'
		WHEN d.Grade = '6' THEN 'Sixth'
		WHEN d.Grade = '7' THEN 'Seventh'
		WHEN d.Grade = '8' THEN 'Eighth'
		WHEN d.Grade = '9' THEN 'Ninth'
		WHEN d.Grade = '10' THEN 'Tenth'
		WHEN d.Grade = '11' THEN 'Eleventh'
		WHEN d.Grade = '12' THEN 'Twelfth'
	ELSE 'PreK'
	END Grade,
	w.CumulativeGPA
FROM dbo.StageDemographics d
LEFT OUTER JOIN dbo.StageWarningSystem w
	ON d.StudentID = w.StudentID

GO

DROP VIEW IF EXISTS dbo.vw_pbiDailyAttendance
GO

CREATE VIEW dbo.vw_pbiDailyAttendance
AS
SELECT 
	SchoolCode SchoolID,
	AttendanceDate,
	StudentID,
	NumofPossiblePeriods,
	NumofTardies,
	NumofUnexecusedAbsent NumofUnexcusedAbsent,
	NumofExecusedAbsent NumofExcusedAbsent
FROM StageDailyAttendance


GO

DROP VIEW IF EXISTS dbo.vw_pbiDailyIncident
GO

CREATE VIEW dbo.vw_pbiDailyIncident
AS
SELECT 
	StudentID,
	SchoolCode SchoolID,
	IncidentCode IncidentID,
	InvolvementCode InvolvementID,
	IncidentDate,
	ActionCode ActionID
FROM dbo.StageIncident

GO

DROP VIEW IF EXISTS dbo.vw_pbiClassAttendance
GO

CREATE VIEW dbo.vw_pbiClassAttendance
AS
SELECT
	CASE WHEN MONTH(CAST(AttendanceDate as date)) < 8 THEN 2 ELSE 1 END Term ,
	CAST(AttendanceDate as date) AttendanceDate,
	StudentID,
	SchoolCode SchoolID,
	mstuniq CourseID,
	IIF(AttendCode = '.','Pr', AttendCode) AttendTypeID
FROM [dbo].[StageClassAttendance]