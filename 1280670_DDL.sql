/*
								DDL
				----------------------------------------
				- Dreamer Consultancy Management System -
				----------------------------------------
				- Trainee Information 
				- Trainee Name: Md. Yousuf Mansur 
				- Developer ID: 1280670 
				- Batch ID: CS/SCSL-A/58/01 
				- SQL Project for Monthly Exam

				----------------------------------------
				- Table of Contents -
				1.0 Database Creation
				2.0 Table Design
				3.0 Table Alterations
				4.0 Indexing
				5.0 Sequences
				6.0 Views
				7.0 Stored Procedures
				8.0 Functions
				9.0 Triggers
				10.0 Logon Triggers
				

*/
				----------------------------------------
				-- SECTION 1.0 : Database Creation 
				----------------------------------------


-- Create Database
USE master
GO

IF DB_ID('DreamerConsultancyDB') IS NOT NULL
DROP DATABASE DreamerConsultancyDB
GO

CREATE DATABASE DreamerConsultancyDB
ON
(
    name = 'dreamer_consultancy_data',
    filename = 'C:\Program Files\Microsoft SQL Server\MSSQL16.SQLEXPRESS\MSSQL\DATA\dreamer_consultancy_data.mdf',
    size = 5MB,
    maxsize = 50MB,
    filegrowth = 5%
)
LOG ON
(
    name = 'dreamer_consultancy_log',
    filename = 'C:\Program Files\Microsoft SQL Server\MSSQL16.SQLEXPRESS\MSSQL\DATA\dreamer_consultancy_log.ldf',
    size = 8MB,
    maxsize = 40MB,
    filegrowth = 5MB
)
GO

USE DreamerConsultancyDB
GO


					-------------------------------------------------
					-- SECTION 2.0 : Table Design					
					-------------------------------------------------


BEGIN TRY
BEGIN TRANSACTION

CREATE TABLE designation (
	designationId INT PRIMARY KEY IDENTITY(1,1),
	designationName NVARCHAR(150) NOT NULL
);
PRINT 'designation table created successfully.';

CREATE TABLE gender (
	genderId INT PRIMARY KEY IDENTITY(1,1),
	genderName NVARCHAR(50) NOT NULL
);
PRINT 'gender table created successfully.';

CREATE TABLE counselor (
	counselorId INT PRIMARY KEY IDENTITY(1,1),
	counselorFName NVARCHAR(50) NOT NULL,
	counselorLName NVARCHAR(50) NOT NULL,
	designationId INT NOT NULL,
	FOREIGN KEY (designationId) REFERENCES designation(designationId),
	CONSTRAINT UQ_counselorName UNIQUE (counselorFName, counselorLName)
);
PRINT 'counselor table created successfully.';

CREATE TABLE country (
	countryId INT PRIMARY KEY IDENTITY(1,1),
	countryName NVARCHAR(50) NOT NULL
);
PRINT 'country table created successfully.';

CREATE TABLE university (
	universityId INT PRIMARY KEY IDENTITY(1,1),
	universityName NVARCHAR(200) NOT NULL,
	countryId INT NOT NULL,
	FOREIGN KEY (countryId) REFERENCES country(countryId),
	CONSTRAINT UQ_university UNIQUE (universityName, countryId)
);
PRINT 'university table created successfully.';

CREATE TABLE subject (
	subjectId INT PRIMARY KEY IDENTITY(1,1),
	subjectName NVARCHAR(50) NOT NULL
);
PRINT 'subject table created successfully.';

CREATE TABLE intake (
	intakeId INT PRIMARY KEY IDENTITY(1,1),
	intakeName NVARCHAR(50) NOT NULL,
	intakeDate DATE NOT NULL
);
PRINT 'intake table created successfully.';

CREATE TABLE applicationStatus (
	applicationStatusId INT PRIMARY KEY IDENTITY(1,1),
	applicationStatusName NVARCHAR(50) NOT NULL
);
PRINT 'applicationStatus table created successfully.';

CREATE TABLE student (
	studentId INT PRIMARY KEY IDENTITY(1,1),
	studentFName NVARCHAR(50) NOT NULL,
	studentLName NVARCHAR(50) NOT NULL,
	nid CHAR(10) UNIQUE CHECK(nid LIKE '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'),
	email VARCHAR(40) UNIQUE CONSTRAINT ck_email CHECK (email LIKE '%@%' ),
	phone CHAR(20) UNIQUE CHECK(phone LIKE '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'),
	passportId NVARCHAR(50) NULL,
	passExDate DATE NULL,
	lastStudyLevel NVARCHAR(50) NOT NULL,
	lastMarks DECIMAL(5, 2) NOT NULL,
	genderId INT NOT NULL,
	dateOfBirth DATE,
	studentAddress NVARCHAR(100),
	FOREIGN KEY (genderId) REFERENCES gender(genderId)
);
PRINT 'student table created successfully.';

CREATE TABLE application (
	applicationId INT PRIMARY KEY IDENTITY(1,1),
	studentId INT NOT NULL,
	countryId INT NOT NULL,
	intakeId INT NOT NULL,
	universityId INT NOT NULL,
	subjectId INT NOT NULL,
	applicationStatusId INT NOT NULL,
	applicationDate DATE NOT NULL DEFAULT GETDATE(),
	FOREIGN KEY (studentId) REFERENCES student(studentId),
	FOREIGN KEY (countryId) REFERENCES country(countryId),
	FOREIGN KEY (intakeId) REFERENCES intake(intakeId),
	FOREIGN KEY (universityId) REFERENCES university(universityId),
	FOREIGN KEY (subjectId) REFERENCES subject(subjectId),
	FOREIGN KEY (applicationStatusId) REFERENCES applicationStatus(applicationStatusId),
	CONSTRAINT UQ_studentApplication UNIQUE (studentId, universityId, subjectId)
);
PRINT 'application table created successfully.';

CREATE TABLE payment (
	paymentId INT PRIMARY KEY IDENTITY(1,1),
	applicationId INT NOT NULL,
	paymentDate DATE NOT NULL,
	paymentAmount DECIMAL(10, 2) NOT NULL,
	paymentMethod NVARCHAR(50) NOT NULL,
	FOREIGN KEY (applicationId) REFERENCES application(applicationId)
);
PRINT 'payment table created successfully.';

CREATE TABLE course (
	courseId INT PRIMARY KEY IDENTITY(1,1),
	courseName NVARCHAR(100) NOT NULL,
	description NVARCHAR(200) NULL
);
PRINT 'course table created successfully.';

CREATE TABLE universityCourse (
	universityCourseId INT PRIMARY KEY IDENTITY(1,1),
	universityId INT NOT NULL,
	courseId INT NOT NULL,
	FOREIGN KEY (universityId) REFERENCES university(universityId),
	FOREIGN KEY (courseId) REFERENCES course(courseId),
	CONSTRAINT UQ_universityCourse UNIQUE (universityId, courseId)
);
PRINT 'universityCourse table created successfully.';

CREATE TABLE studentCourse (
	studentCourseId INT PRIMARY KEY IDENTITY(1,1),
	studentId INT NOT NULL,
	courseId INT NOT NULL,
	grade DECIMAL(3, 2) NULL,
	FOREIGN KEY (studentId) REFERENCES student(studentId),
	FOREIGN KEY (courseId) REFERENCES course(courseId),
	CONSTRAINT UQ_studentCourse UNIQUE (studentId, courseId)
);
PRINT 'studentCourse table created successfully.';

CREATE TABLE counselorStudent (
	counselorStudentId INT PRIMARY KEY IDENTITY(1,1),
	counselorId INT NOT NULL,
	studentId INT NOT NULL,
	assignedDate DATE NOT NULL DEFAULT GETDATE(),
	FOREIGN KEY (counselorId) REFERENCES counselor(counselorId),
	FOREIGN KEY (studentId) REFERENCES student(studentId),
	CONSTRAINT UQ_counselorStudent UNIQUE (counselorId, studentId)
);
PRINT 'counselorStudent table created successfully.';

CREATE TABLE visaReason (
	visaReasonId INT PRIMARY KEY IDENTITY(1,1),
	visaReasonName NVARCHAR(100) NOT NULL,
	description NVARCHAR(200) NULL,
	createdAt DATETIME2 NOT NULL DEFAULT GETDATE(),
	updatedAt DATETIME2 NOT NULL DEFAULT GETDATE(),
	deletedAt DATETIME2 NULL
);
PRINT 'visaReason table created successfully.';

CREATE TABLE applicationReason (
	applicationReasonId INT PRIMARY KEY IDENTITY(1,1),
	applicationId INT NOT NULL,
	visaReasonId INT NOT NULL,
	FOREIGN KEY (applicationId) REFERENCES application(applicationId),
	FOREIGN KEY (visaReasonId) REFERENCES visaReason(visaReasonId)
);
PRINT 'applicationReason table created successfully.';

CREATE TABLE document (
	documentId INT PRIMARY KEY IDENTITY(1,1),
	documentName NVARCHAR(100) NOT NULL,
	description NVARCHAR(200) NULL
);
PRINT 'document table created successfully.';

CREATE TABLE studentDocument (
	studentDocumentId INT PRIMARY KEY IDENTITY(1,1),
	studentId INT NOT NULL,
	documentId INT NOT NULL,
	submissionDate DATE NOT NULL DEFAULT GETDATE(),
	documentStatus NVARCHAR(50) NOT NULL,
	FOREIGN KEY (studentId) REFERENCES student(studentId),
	FOREIGN KEY (documentId) REFERENCES document(documentId),
	CONSTRAINT UQ_studentDocument UNIQUE (studentId, documentId)
);
PRINT 'studentDocument table created successfully.';

CREATE TABLE visaApplication (
	visaApplicationId INT PRIMARY KEY IDENTITY(1,1),
	applicationId INT NOT NULL,
	visaType NVARCHAR(50) NOT NULL,
	submissionDate DATE NOT NULL,
	status NVARCHAR(50) NOT NULL,
	decisionDate DATE NULL,
	FOREIGN KEY (applicationId) REFERENCES application(applicationId)
);
PRINT 'visaApplication table created successfully.';

CREATE TABLE scholarship (
	scholarshipId INT PRIMARY KEY IDENTITY(1,1),
	scholarshipName NVARCHAR(100) NOT NULL,
	description NVARCHAR(200) NULL,
	amount DECIMAL(10, 2) NOT NULL
);
PRINT 'scholarship table created successfully.';

CREATE TABLE studentScholarship (
	studentScholarshipId INT PRIMARY KEY IDENTITY(1,1),
	studentId INT NOT NULL,
	scholarshipId INT NOT NULL,
	awardDate DATE NOT NULL,
	FOREIGN KEY (studentId) REFERENCES student(studentId),
	FOREIGN KEY (scholarshipId) REFERENCES scholarship(scholarshipId),
	CONSTRAINT UQ_studentScholarship UNIQUE (studentId, scholarshipId)
);
PRINT 'studentScholarship table created successfully.';

CREATE TABLE studentArchive (
    studentArchiveId INT PRIMARY KEY IDENTITY(1,1),
    studentFName NVARCHAR(50) NOT NULL,
    studentLName NVARCHAR(50) NOT NULL,
    NID NVARCHAR(50) NULL,
    passportId NVARCHAR(50) NULL,
    passExDate DATE NULL,
    phone NVARCHAR(20) NOT NULL,
    lastStudyLevel NVARCHAR(50) NOT NULL,
    lastMarks DECIMAL(5, 2) NOT NULL,
    genderId INT NOT NULL,
    archivedAt DATETIME2 NOT NULL DEFAULT GETDATE()
);
PRINT 'studentArchive table created successfully.';

COMMIT TRANSACTION
    PRINT 'All tables created successfully. Transaction committed.';
END TRY
BEGIN CATCH
    ROLLBACK TRANSACTION
    PRINT 'An error occurred. Transaction rolled back.';
    PRINT 'Error Number: ' + CAST(ERROR_NUMBER() AS NVARCHAR(10));
    PRINT 'Error Message: ' + ERROR_MESSAGE();
END CATCH
GO

					----------------------------------------------------------
					--SECTION 3.0
					--ALTER, DROP AND MODIFY TABLES, SCHEMA & COLUMNS
					----------------------------------------------------------

-- Create Schema
CREATE SCHEMA dreamer_consultancy;
GO

----------------- ALTER TABLE SCHEMA -------------

ALTER SCHEMA dreamer_consultancy TRANSFER course
GO

ALTER SCHEMA dbo TRANSFER dreamer_consultancy.course
GO

----------------- Update column definition -----------

ALTER TABLE counselor
ADD counselorFullName CHAR(50) NOT NULL
GO

----------------- ADD column with DEFAULT CONSTRAINT ----------------

ALTER TABLE universityCourse
ADD universityCourseFee MONEY DEFAULT 0.00
GO

---------------- ADD CHECK CONSTRAINT with defining name --------------

ALTER TABLE student
ADD CONSTRAINT CK_nidValidate CHECK(nid LIKE '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'),
CONSTRAINT CK_phoneValidate CHECK(phone LIKE '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'),
CONSTRAINT CK_emailValidate CHECK(email LIKE '%@%' )
GO

---------------- DROP COLUMN -------------------

ALTER TABLE student
DROP COLUMN studentAddress
GO

------------------- DROP TABLE -------------------

IF OBJECT_ID('studentArchive') IS NOT NULL
DROP TABLE studentArchive
GO

------------------- DROP SCHEMA -------------------

DROP SCHEMA dreamer_consultancy;
GO


					----------------------------------------------------------
					-- SECTION 4.0
					-- Create Indexes
					----------------------------------------------------------

CREATE INDEX idx_studentID ON student (studentId);
CREATE INDEX idx_applicationId ON Application (applicationId);
CREATE INDEX idx_applicationDate ON Application (applicationDate);
CREATE NONCLUSTERED INDEX idx_countryId ON country (countryId);



					----------------------------------------------------------
					-- SECTION 5.0
					-- Create Sequence
					----------------------------------------------------------

CREATE SEQUENCE sqNumeric
AS INT
START WITH 1
INCREMENT BY 10
MINVALUE 0
MAXVALUE 500
CYCLE
CACHE 10;

					----------------------------------------------------------
					-- SECTION 6.0
					-- Create View 
					----------------------------------------------------------

CREATE OR ALTER VIEW vwStudentInformation AS
SELECT 
    S.studentId, 
    S.studentFName AS FirstName, 
    S.studentLName AS LastName, 
    S.nid AS NID, 
    S.passportId AS PassportNumber, 
    S.passExDate AS PassportExpiryDate, 
    S.phone AS PhoneNumber, 
    S.email AS EmailAddress, 
    S.lastStudyLevel AS LastStudyLevel, 
    S.lastMarks AS LastAcademicMarks, 
    G.genderName AS Gender,
    C.countryName AS Country, 
    U.universityName AS University, 
    Sub.subjectName AS Subject, 
    I.intakeName AS Intake, 
    A.applicationDate AS ApplicationDate, 
    AST.applicationStatusName AS ApplicationStatus, 
    S.dateOfBirth AS DateOfBirth
FROM 
    student S
INNER JOIN 
    application A ON S.studentId = A.studentId
INNER JOIN 
    country C ON A.countryId = C.countryId
INNER JOIN 
    intake I ON A.intakeID = I.intakeId
INNER JOIN 
    university U ON A.universityId = U.universityId
INNER JOIN 
    subject Sub ON A.subjectId = Sub.subjectId
INNER JOIN 
    gender G ON S.genderId = G.genderId
INNER JOIN 
    applicationStatus AST ON A.applicationStatusId = AST.applicationStatusId;
GO

	
					----------------------------------------------------------
					-- SECTION 7.0
					-- Create Stored Procedures
					----------------------------------------------------------


CREATE OR ALTER PROCEDURE spStudent_CRUD
    @studentId INT = NULL, -- Only required for UPDATE/DELETE
    @studentFName NVARCHAR(50),
    @studentLName NVARCHAR(50),
    @nid CHAR(10),
    @passportId NVARCHAR(50) = NULL,
    @passExDate DATE = NULL,
    @phone CHAR(20),
    @email VARCHAR(40),
    @lastStudyLevel NVARCHAR(50),
    @lastMarks DECIMAL(5, 2),
    @genderId INT,
    @dateOfBirth DATE,
    @Action NVARCHAR(10)
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY
        IF @Action = 'INSERT'
            BEGIN
                INSERT INTO student (
                    studentFName, 
                    studentLName, 
                    nid, 
                    passportId, 
                    passExDate, 
                    phone, 
                    email, 
                    lastStudyLevel, 
                    lastMarks, 
                    genderId, 
                    dateOfBirth
                )
                VALUES (
                    @studentFName, 
                    @studentLName, 
                    @nid, 
                    @passportId, 
                    @passExDate, 
                    @phone, 
                    @email, 
                    @lastStudyLevel, 
                    @lastMarks, 
                    @genderId, 
                    @dateOfBirth
                );
            END
        ELSE IF @Action = 'UPDATE'
            BEGIN
                IF @studentId IS NULL
                    BEGIN
                        RAISERROR('studentId is required for UPDATE.', 16, 1);
                        RETURN;
                    END
                    
                UPDATE student
                SET 
                    studentFName = @studentFName,
                    studentLName = @studentLName,
                    nid = @nid,
                    passportId = @passportId,
                    passExDate = @passExDate,
                    phone = @phone,
                    email = @email,
                    lastStudyLevel = @lastStudyLevel,
                    lastMarks = @lastMarks,
                    genderId = @genderId,
                    dateOfBirth = @dateOfBirth
                WHERE 
                    studentId = @studentId;
            END
        ELSE IF @Action = 'DELETE'
            BEGIN
                IF @studentId IS NULL
                    BEGIN
                        RAISERROR('studentId is required for DELETE.', 16, 1);
                        RETURN;
                    END
                    
                DELETE FROM student
                WHERE studentId = @studentId;
            END
        ELSE
            RAISERROR('Invalid @Action parameter. Use ''INSERT'', ''UPDATE'', or ''DELETE''.', 16, 1);
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE(),
                @ErrorSeverity INT = ERROR_SEVERITY(),
                @ErrorState INT = ERROR_STATE();

        RAISERROR(@ErrorMessage, @ErrorSeverity, @ErrorState);
    END CATCH;
END;

GO

					----------------------------------------------------------
					-- SECTION 8.0
					-- Create Functions
					----------------------------------------------------------

-- Function to calculate student GPA
CREATE OR ALTER FUNCTION fnStudentGPA (@studentId INT)
RETURNS DECIMAL(3, 2)
AS
BEGIN
    DECLARE @GPA DECIMAL(3, 2);
    
    -- Calculate average GPA, handling NULL grades
    SELECT @GPA = AVG(CAST(grade AS DECIMAL(5, 2)))
    FROM studentCourse
    WHERE studentId = @studentId
      AND grade IS NOT NULL;
    
    RETURN ISNULL(@GPA, 0); -- Return 0 if no grades found
END;
GO


-- Function to calculate age
CREATE OR ALTER FUNCTION fnCalculateAge (@dateOfBirth DATE)
RETURNS INT
AS
BEGIN
    RETURN DATEDIFF(YEAR, @dateOfBirth, GETDATE()) - 
           CASE 
               WHEN (MONTH(@dateOfBirth) > MONTH(GETDATE())) OR 
                    (MONTH(@dateOfBirth) = MONTH(GETDATE()) AND DAY(@dateOfBirth) > DAY(GETDATE()))
               THEN 1 
               ELSE 0 
           END;
END;
GO


----------- Student Application Function ---------------------

CREATE OR ALTER FUNCTION fnStudentApplications(@studentId INT)
RETURNS TABLE
AS
RETURN
(
    SELECT 
        a.applicationId, 
        c.countryName, 
        u.universityName, 
        s.subjectName, 
        i.intakeName, 
        ast.applicationStatusName
    FROM application a
    JOIN country c ON a.countryId = c.countryId
    JOIN university u ON a.universityId = u.universityId
    JOIN subject s ON a.subjectId = s.subjectId
    JOIN intake i ON a.intakeId = i.intakeId
    JOIN applicationStatus ast ON a.applicationStatusId = ast.applicationStatusId
    WHERE a.studentId = @studentId
);
GO


-- Create a new inline table-valued function (ITVF)
-- Get student by country

CREATE OR ALTER FUNCTION fnGetStudentsByCountry (@countryId INT)
RETURNS TABLE
AS
RETURN
(
    SELECT DISTINCT
        s.studentId, 
        s.studentFName, 
        s.studentLName, 
        c.countryName
    FROM student s
    JOIN application a ON s.studentId = a.studentId
    JOIN country c ON a.countryId = c.countryId
    WHERE c.countryId = @countryId
);
GO


-- Create a new multi-statement table-valued function (MSTVF)
-- Get student grades
CREATE OR ALTER FUNCTION fnGetStudentGrades (@studentId INT)
RETURNS @StudentGrades TABLE
(
    courseId INT,
    courseName NVARCHAR(100),
    grade DECIMAL(5, 2)
)
AS
BEGIN
    INSERT INTO @StudentGrades (courseId, courseName, grade)
    SELECT c.courseId, c.courseName, sc.grade
    FROM studentCourse sc
    JOIN course c ON sc.courseId = c.courseId
    WHERE sc.studentId = @studentId
      AND sc.grade IS NOT NULL;
    
    RETURN;
END;
GO



					----------------------------------------------------------
					-- SECTION 9.0
					-- Create Triggers
					----------------------------------------------------------

-- Trigger for passport expiry validation
CREATE TRIGGER trRestrictPassportExpiry
ON student
AFTER INSERT, UPDATE
AS
BEGIN
    IF EXISTS (SELECT 1 FROM inserted WHERE passExDate <= GETDATE())
    BEGIN
        RAISERROR ('Passport expiry date must be greater than the current date', 16, 1);
        ROLLBACK TRANSACTION;
    END
END;
GO

-- Trigger for application status update
CREATE TRIGGER trApplicationStatus
ON application
AFTER INSERT
AS
BEGIN
    DECLARE @applicationId INT;
    DECLARE @statusId INT;
    
    -- Fetch the newly inserted application's ID and status ID
    SELECT @applicationId = applicationId,
           @statusId = applicationStatusId
    FROM inserted;
    
    -- Only print messages based on application status
    IF @statusId = 1
        PRINT 'New application created';
    ELSE IF @statusId = 2
        PRINT 'Application is in progress';
    ELSE IF @statusId = 3
        PRINT 'Application is completed';
    ELSE
        PRINT 'Unknown application status';
END;
GO



-- Create the StudentUpdateLog table
CREATE TABLE studentUpdateLog (
    logId INT PRIMARY KEY IDENTITY(1,1),
    studentId INT NOT NULL,
    updatedAt DATETIME2 NOT NULL DEFAULT GETDATE(),
    updatedBy NVARCHAR(100) NOT NULL,
    FOREIGN KEY (studentId) REFERENCES student(studentId)
);
GO


-- Create trigger on student table to manage student records
CREATE OR ALTER TRIGGER trStudentRecordManage
ON student
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    DECLARE @studentId INT;
    
    -- Handle INSERT and UPDATE (inserted exists)
    IF EXISTS(SELECT * FROM inserted)
    BEGIN
        -- Log update if both inserted and deleted rows exist (UPDATE)
        IF EXISTS(SELECT * FROM deleted)
        BEGIN
            INSERT INTO studentUpdateLog (studentId, updatedBy)
            SELECT i.studentId, SYSTEM_USER
            FROM inserted i;
            PRINT 'Student record updated';
        END
        -- Log insert if only inserted rows exist (INSERT)
        ELSE
        BEGIN
            INSERT INTO studentUpdateLog (studentId, updatedBy)
            SELECT i.studentId, SYSTEM_USER
            FROM inserted i;
            PRINT 'New student record inserted';
        END
    END
    
    -- Handle DELETE (deleted exists)
    IF EXISTS(SELECT * FROM deleted) AND NOT EXISTS(SELECT * FROM inserted)
    BEGIN
        INSERT INTO studentUpdateLog (studentId, updatedBy)
        SELECT d.studentId, SYSTEM_USER
        FROM deleted d;
        PRINT 'Student record deleted';
    END
END;
GO


------------------------------------------------------------------------------------------------------------------
---------------------------------- Create ApplicationUpdateLog table ---------------------------------------------
------------------------------------------------------------------------------------------------------------------

CREATE TABLE applicationUpdateLog (
    logId INT PRIMARY KEY IDENTITY(1,1),
    applicationId INT NOT NULL,
    updatedAt DATETIME2 NOT NULL DEFAULT GETDATE(),
    updatedBy NVARCHAR(100) NOT NULL,
    FOREIGN KEY (applicationId) REFERENCES application(applicationId)
);
GO


-- Create trigger on application table to manage application records
CREATE TRIGGER trApplicationRecord
ON application
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    DECLARE @applicationId INT;

    -- Handle UPDATE (both inserted and deleted rows exist)
    IF EXISTS(SELECT * FROM inserted) AND EXISTS(SELECT * FROM deleted)
    BEGIN
        INSERT INTO applicationUpdateLog (applicationId, updatedBy)
        SELECT i.applicationId, SYSTEM_USER
        FROM inserted i;
        
        PRINT 'Application record updated';
    END

    -- Handle INSERT (only inserted rows exist)
    ELSE IF EXISTS(SELECT * FROM inserted) AND NOT EXISTS(SELECT * FROM deleted)
    BEGIN
        INSERT INTO applicationUpdateLog (applicationId, updatedBy)
        SELECT i.applicationId, SYSTEM_USER
        FROM inserted i;
        
        PRINT 'New application record inserted';
    END

    -- Handle DELETE (only deleted rows exist)
    ELSE IF EXISTS(SELECT * FROM deleted) AND NOT EXISTS(SELECT * FROM inserted)
    BEGIN
        INSERT INTO applicationUpdateLog (applicationId, updatedBy)
        SELECT d.applicationId, SYSTEM_USER
        FROM deleted d;
        
        PRINT 'Application record deleted';
    END
END;
GO



------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------

-- Add deletedAt column to student table if not exists
IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID('student') AND name = 'deletedAt')
BEGIN
    ALTER TABLE student ADD deletedAt DATETIME2 NULL;
END;
GO

---- Add deletedAt column to student table
--ALTER TABLE student ADD deletedAt DATETIME2 NULL;
--GO

-- Soft Delete Trigger
CREATE OR ALTER TRIGGER trSoftDelete
ON student
INSTEAD OF DELETE
AS
BEGIN
    UPDATE student
    SET deletedAt = GETDATE()
    FROM student s
    INNER JOIN deleted d ON s.studentId = d.studentId
    WHERE s.deletedAt IS NULL; -- Ensures the record isn't already deleted
END;
GO

-- Log Updates Trigger
CREATE OR ALTER TRIGGER trLogStudentUpdates
ON student
AFTER UPDATE
AS
BEGIN
    INSERT INTO studentUpdateLog (studentId, updatedAt, updatedBy)
    SELECT i.studentId, GETDATE(), SYSTEM_USER
    FROM inserted i;
END;
GO


-- Prevent Duplicate Students Trigger
CREATE OR ALTER TRIGGER trPreventDuplicateStudents
ON student
INSTEAD OF INSERT
AS
BEGIN
    -- Exclude NULL values when checking for duplicates
    IF EXISTS (
        SELECT 1 
        FROM student s
        INNER JOIN inserted i ON s.nid = i.nid 
            OR (s.passportId = i.passportId AND s.passportId IS NOT NULL AND i.passportId IS NOT NULL)
        WHERE s.deletedAt IS NULL
    )
    BEGIN
        RAISERROR ('A student with the same NID or Passport ID already exists.', 16, 1);
        RETURN;
    END
    
    INSERT INTO student (
        studentFName, studentLName, nid, passportId, passExDate, 
        phone, email, lastStudyLevel, lastMarks, genderId, dateOfBirth
    )
    SELECT 
        studentFName, studentLName, nid, passportId, passExDate, 
        phone, email, lastStudyLevel, lastMarks, genderId, dateOfBirth
    FROM inserted;
END;
GO


-- Restrict Delete Trigger (Note: This conflicts with the soft delete trigger)
CREATE OR ALTER TRIGGER trRestrictDelete
ON student
FOR DELETE
AS
IF @@ROWCOUNT > 0
BEGIN
    RAISERROR ('You are not permitted to delete a student record', 11, 1)
    ROLLBACK TRANSACTION
END
GO


-- Restrict Student Insert Trigger
CREATE OR ALTER TRIGGER trRestrictStudentInsert
ON student
FOR INSERT
AS
BEGIN
    IF EXISTS (
        SELECT 1
        FROM inserted i
        WHERE i.dateOfBirth > DATEADD(year, -18, GETDATE()) -- Restrict students under 18 years old
        OR (i.passExDate IS NOT NULL AND i.passExDate < GETDATE()) -- Restrict students with expired passports
        OR i.lastMarks < 50 -- Restrict students with marks less than 50
    )
    BEGIN
        RAISERROR ('Invalid student data. Students must be 18 or older, have valid passports, and marks of 50 or higher.', 16, 1);
        ROLLBACK TRANSACTION;
    END
END;
GO




					----------------------------------------------------------
					-- SECTION 10.0
					-- Create a new logon trigger
					----------------------------------------------------------

USE master;
GO

-- Create the audit table if it doesn't exist
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'dbo.loginAudit') AND type in (N'U'))
BEGIN
    CREATE TABLE dbo.loginAudit
    (
        auditId INT IDENTITY(1,1) PRIMARY KEY,
        loginName NVARCHAR(100) NOT NULL,
        loginTime DATETIME2 NOT NULL DEFAULT GETDATE(),
        hostName NVARCHAR(128) NULL,
        applicationName NVARCHAR(128) NULL
    );
END
GO

-- Create or alter the server trigger
CREATE OR ALTER TRIGGER trAuditLogon 
ON ALL SERVER 
FOR LOGON 
AS 
BEGIN
    -- Use TRY/CATCH to prevent login failures if trigger errors
    BEGIN TRY
        INSERT INTO master.dbo.loginAudit 
            (loginName, hostName, applicationName)
        VALUES 
            (ORIGINAL_LOGIN(), 
             HOST_NAME(), 
             APP_NAME());
    END TRY
    BEGIN CATCH
       
    END CATCH
END;
GO

-- Enable the trigger
ENABLE TRIGGER trAuditLogon ON ALL SERVER;
GO