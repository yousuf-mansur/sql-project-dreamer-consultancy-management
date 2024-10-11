/*
								DML
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

				- Table of Contents -
				1.0 Insert Data in The defined Tables
				2.0 Insert/Update/Delete Data through Stored Procedure
				3.0 Basic Queries
				4.0 Joins
				5.0 Aggregate Functions
				6.0 Advanced Groupings
				7.0 Subqueries
				8.0 Set Operations
				9.0 Conditional Expressions
				10.0 Null Handling
				11.0 Function Calls
				12.0 CTE (Common Table Expressions)
				13.0 Cursor Example
				
*/


USE DreamerConsultancyDB
GO

					----------------------------------------------------------
					-- SECTION 1.0
					-- Insert Data in The defined Tables
					----------------------------------------------------------
	

-- Insert data into 'designation' table
INSERT INTO designation (designationName)
VALUES ('Senior Counselor'), ('Junior Counselor');

-- Insert data into 'gender' table
INSERT INTO gender (genderName)
VALUES ('Male'), ('Female');

-- Insert data into 'counselor' table
INSERT INTO counselor (counselorFName, counselorLName, designationId, counselorFullName)
VALUES ('Rafiq', 'Hasan', 1, 'Rafiq Hasan'),
       ('Shila', 'Begum', 2, 'Shila Begum');

-- Insert data into 'country' table
INSERT INTO country (countryName)
VALUES ('Germany'), ('France'), ('Netherlands');

-- Insert data into 'university' table
INSERT INTO university (universityName, countryId)
VALUES ('Technical University of Munich', 1), 
       ('Sorbonne University', 2), 
       ('University of Amsterdam', 3);

-- Insert data into 'subject' table
INSERT INTO subject (subjectName)
VALUES ('CSE'), ('Creative Writing'), ('Social Work');

-- Insert data into 'intake' table
INSERT INTO intake (intakeName, intakeDate)
VALUES ('Fall 2024', '2024-09-01'),
       ('Spring 2025', '2025-02-01');

-- Insert data into 'applicationStatus' table
INSERT INTO applicationStatus (applicationStatusName)
VALUES ('Pending'), ('Approved'), ('Rejected');

-- Insert data into 'student' table
INSERT INTO student (studentFName, studentLName, nid, email, phone, passportId, passExDate, lastStudyLevel, lastMarks, genderId, dateOfBirth)
VALUES ('Tanvir', 'Rahman', '1234567890', 'tanvir@example.com', '01234567890', 'A1234567', '2028-05-20', 'Bachelor', 3.80, 1, '2000-07-15'),
       ('Sadia', 'Khan', '0987654321', 'sadia@example.com', '09876543211', 'B7654321', '2026-12-31', 'Master', 4.00, 2, '1998-03-25'),
       ('Farid', 'Hossain', '1122334455', 'farid@example.com', '01122334455', 'C1122334', '2027-09-15', 'Bachelor', 3.50, 1, '1999-11-05');

-- Insert data into 'application' table
INSERT INTO application (studentId, countryId, intakeId, universityId, subjectId, applicationStatusId, applicationDate)
VALUES (1, 1, 1, 1, 1, 1, GETDATE()),  -- Tanvir applying to Technical University of Munich for CSE
       (2, 2, 2, 2, 2, 2, GETDATE()),  -- Sadia applying to Sorbonne University for Creative Writing
       (3, 3, 1, 3, 3, 3, GETDATE());  -- Farid applying to University of Amsterdam for Social Work

-- Insert data into 'payment' table
INSERT INTO payment (applicationId, paymentDate, paymentAmount, paymentMethod)
VALUES (1, GETDATE(), 2000.00, 'Bank Transfer'),
       (2, GETDATE(), 1500.00, 'Credit Card'),
       (3, GETDATE(), 1800.00, 'Paypal');

-- Insert data into 'course' table
INSERT INTO course (courseName, description)
VALUES ('Data Structures', 'Learn about fundamental data structures in computer science'),
       ('Fiction Writing', 'Learn how to write creative fiction stories'),
       ('Human Services', 'Focus on social work practices in communities');

-- Insert data into 'universityCourse' table
INSERT INTO universityCourse (universityId, courseId, universityCourseFee)
VALUES (1, 1, 3000.00),  -- Data Structures at Technical University of Munich
       (2, 2, 2500.00),  -- Fiction Writing at Sorbonne University
       (3, 3, 2200.00);  -- Human Services at University of Amsterdam

-- Insert data into 'studentCourse' table
INSERT INTO studentCourse (studentId, courseId, grade)
VALUES (1, 1, 3.90),  -- Tanvir enrolled in Data Structures
       (2, 2, 4.00),  -- Sadia enrolled in Fiction Writing
       (3, 3, 3.60);  -- Farid enrolled in Human Services

-- Insert data into 'counselorStudent' table
INSERT INTO counselorStudent (counselorId, studentId, assignedDate)
VALUES (1, 1, GETDATE()),  -- Rafiq assigned to Tanvir
       (2, 2, GETDATE()),  -- Shila assigned to Sadia
       (1, 3, GETDATE());  -- Rafiq assigned to Farid

-- Insert data into 'visaReason' table
INSERT INTO visaReason (visaReasonName, description)
VALUES ('Study Permit', 'Visa for educational purposes'),
       ('Temporary Visa', 'Visa for short-term visits'),
       ('Work Visa', 'Visa for work purposes');

-- Insert data into 'applicationReason' table
INSERT INTO applicationReason (applicationId, visaReasonId)
VALUES (1, 1),  -- Tanvir applied for Study Permit
       (2, 1),  -- Sadia applied for Study Permit
       (3, 2);  -- Farid applied for Temporary Visa

-- Insert data into 'document' table
INSERT INTO document (documentName, description)
VALUES ('Passport Copy', 'Student Passport Copy'),
       ('Transcript', 'Last Academic Transcript'),
       ('Letter of Recommendation', 'Recommendation from a professor or employer');

-- Insert data into 'studentDocument' table
INSERT INTO studentDocument (studentId, documentId, documentStatus)
VALUES (1, 1, 'Submitted'),  -- Tanvir submitted Passport Copy
       (2, 2, 'Pending'),    -- Sadia is yet to submit Transcript
       (3, 3, 'Submitted');  -- Farid submitted Letter of Recommendation

-- Insert data into 'visaApplication' table
INSERT INTO visaApplication (applicationId, visaType, submissionDate, status, decisionDate)
VALUES (1, 'Study Permit', GETDATE(), 'Pending', NULL),  -- Tanvir's visa pending
       (2, 'Study Permit', GETDATE(), 'Approved', GETDATE()),  -- Sadia's visa approved
       (3, 'Temporary Visa', GETDATE(), 'Rejected', GETDATE());  -- Farid's visa rejected

-- Insert data into 'scholarship' table
INSERT INTO scholarship (scholarshipName, description, amount)
VALUES ('Merit-Based Scholarship', 'Awarded to students with outstanding academic records', 1000.00),
       ('Need-Based Scholarship', 'Awarded to students with financial needs', 1500.00);

-- Insert data into 'studentScholarship' table
INSERT INTO studentScholarship (studentId, scholarshipId, awardDate)
VALUES (1, 1, GETDATE()),  -- Tanvir awarded Merit-Based Scholarship
       (2, 2, GETDATE());  -- Sadia awarded Need-Based Scholarship


					----------------------------------------------------------
					-- SECTION 2.0
					-- INSERT/UPDATE/DELTE DATA THROUGH STORED PROCEDURES
					----------------------------------------------------------


-- INSERT Example

EXEC spStudent_CRUD
    @studentFName = 'Monsur',
    @studentLName = 'Sakar',
    @nid = '9857463849',
    @passportId = 'A4746383',
    @passExDate = '2025-12-30',
    @phone = '01726839485',
    @email = 'sarkar@email.com',
    @lastStudyLevel = 'Bachelor',
    @lastMarks = 85.50,
    @genderId = 1, 
    @dateOfBirth = '1995-06-15',
    @Action = 'INSERT';
GO


-- 2.0 UPDATE Example

EXEC spStudent_CRUD
    @studentId = 2, 
    @studentFName = 'Sayed', --update fname
    @studentLName = 'Abu', --update lastname
    @nid = '9283738393',
    @passportId = 'A8374637',
    @passExDate = '2025-12-29',
    @phone = '01928393839',
    @email = 'mir.sayed@email.com', -- Updated email
    @lastStudyLevel = 'Masters', -- Updated study level
    @lastMarks = 90.00, -- Updated marks
    @genderId = 1,
    @dateOfBirth = '1995-06-15',
    @Action = 'UPDATE';
GO


-- DELETE Example

EXEC spStudent_CRUD
    @studentId = 2, 
    @Action = 'DELETE';
GO

SELECT * FROM student
GO

					----------------------------------------------------------
					-- SECTION 3.0
					-- BASIC QUERIES
					----------------------------------------------------------
					
					

-- 3.1 SELECT with WHERE
SELECT studentId, studentFName, studentLName, lastMarks
FROM student
WHERE lastMarks > 80;

-- 3.2 ORDER BY
SELECT studentId, studentFName, studentLName, lastStudyLevel, lastMarks
FROM student
ORDER BY lastMarks DESC;

-- 3.3 DISTINCT
SELECT DISTINCT lastStudyLevel
FROM student;

-- 3.4 TOP with TIES
SELECT TOP 5 WITH TIES studentId, studentFName, lastMarks
FROM student
ORDER BY lastMarks DESC;

-- 3.5 OFFSET-FETCH (Pagination)
SELECT studentId, studentFName, studentLName
FROM student
ORDER BY studentId
OFFSET 0 ROWS FETCH NEXT 10 ROWS ONLY;

					----------------------------------------------------------
					-- SECTION 4.0 
					-- JOINS
					----------------------------------------------------------

					

-- 4.1 INNER JOIN
SELECT s.studentId, s.studentFName, a.applicationId, u.universityName
FROM student s
INNER JOIN application a ON s.studentId = a.studentId
INNER JOIN university u ON a.universityId = u.universityId;

-- 4.2 LEFT JOIN
SELECT s.studentId, s.studentFName, a.applicationId
FROM student s
LEFT JOIN application a ON s.studentId = a.studentId;

-- 4.3 RIGHT JOIN
SELECT c.counselorId, c.counselorFName, cs.studentId
FROM counselorStudent cs
RIGHT JOIN counselor c ON cs.counselorId = c.counselorId;

-- 4.4 FULL OUTER JOIN
SELECT s.studentId, s.studentFName, a.applicationId
FROM student s
FULL OUTER JOIN application a ON s.studentId = a.studentId;


					----------------------------------------------------------
					-- SECTION 5.0
					-- AGGREGATE FUNCTIONS
					----------------------------------------------------------
					

-- 5.1 Basic Aggregates
SELECT 
    COUNT(*) AS TotalStudents,
    AVG(lastMarks) AS AverageMarks,
    MAX(lastMarks) AS HighestMark,
    MIN(lastMarks) AS LowestMark
FROM student;

-- 5.2 GROUP BY
SELECT lastStudyLevel, COUNT(*) AS StudentCount, AVG(lastMarks) AS AverageMarks
FROM student
GROUP BY lastStudyLevel;

-- 5.3 HAVING
SELECT lastStudyLevel, COUNT(*) AS StudentCount
FROM student
GROUP BY lastStudyLevel
HAVING COUNT(*) > 1;

					----------------------------------------------------------
					-- SECTION 6.0
					-- ADVANCED GROUPING
					----------------------------------------------------------

-- 6.1 ROLLUP
SELECT u.countryId, u.universityId, COUNT(a.applicationId) as ApplicationCount
FROM university u
LEFT JOIN application a ON u.universityId = a.universityId
GROUP BY ROLLUP (u.countryId, u.universityId);

-- 6.2 CUBE
SELECT s.lastStudyLevel, g.genderName, COUNT(*) as StudentCount
FROM student s
JOIN gender g ON s.genderId = g.genderId
GROUP BY CUBE (s.lastStudyLevel, g.genderName);

-- 6.3 GROUPING SETS
SELECT 
    COALESCE(u.universityName, 'All Universities') as University,
    COALESCE(s.subjectName, 'All Subjects') as Subject,
    COUNT(a.applicationId) as ApplicationCount
FROM application a
JOIN university u ON a.universityId = u.universityId
JOIN subject s ON a.subjectId = s.subjectId
GROUP BY GROUPING SETS (
    (u.universityName, s.subjectName),
    (u.universityName),
    (s.subjectName),
    ()
);

					----------------------------------------------------------
					-- SECTION 7.0
					-- SUBQUERIES
					----------------------------------------------------------


-- 7.1 Subquery in WHERE
SELECT studentFName, studentLName, lastMarks
FROM student
WHERE lastMarks > (SELECT AVG(lastMarks) FROM student);

-- 7.2 Correlated Subquery
SELECT s.studentFName, s.lastMarks
FROM student s
WHERE s.lastMarks > (
    SELECT AVG(s2.lastMarks)
    FROM student s2
    WHERE s2.lastStudyLevel = s.lastStudyLevel
);

-- 7.3 EXISTS
SELECT c.counselorFName, c.counselorLName
FROM counselor c
WHERE EXISTS (
    SELECT 1 
    FROM counselorStudent cs
    WHERE cs.counselorId = c.counselorId
);


					----------------------------------------------------------
					-- SECTION 8.0
					-- SET OPERATIONS
					----------------------------------------------------------

-- 8.1 UNION
SELECT studentFName, studentLName, 'Student' as Type FROM student
UNION
SELECT counselorFName, counselorLName, 'Counselor' as Type FROM counselor;

-- 8.2 INTERSECT (if applicable)
SELECT countryId FROM university
INTERSECT
SELECT countryId FROM application;



					----------------------------------------------------------
					-- SECTION 9.0
					-- CONDITIONAL EXPRESSIONS
					----------------------------------------------------------


-- 9.1 CASE
SELECT 
    studentFName,
    lastMarks,
    CASE 
        WHEN lastMarks >= 90 THEN 'Excellent'
        WHEN lastMarks >= 80 THEN 'Very Good'
        WHEN lastMarks >= 70 THEN 'Good'
        ELSE 'Average'
    END AS Performance
FROM student;

-- 9.2 IIF
SELECT 
    studentFName,
    lastMarks,
    IIF(lastMarks >= 60, 'Pass', 'Fail') AS Status
FROM student;



					----------------------------------------------------------
					-- SECTION 10.0
					-- NULL HANDLING
					----------------------------------------------------------

-- 10.1 COALESCE
SELECT 
    studentFName,
    COALESCE(passportId, 'No Passport') AS PassportStatus
FROM student;

-- 10.2 ISNULL
SELECT 
    studentFName,
    ISNULL(email, 'No Email') AS ContactEmail
FROM student;



					----------------------------------------------------------
					-- SECTION 11.0
					-- FUNCTION CALLS
					----------------------------------------------------------

					
-- 11.1 Scalar Function
SELECT 
    studentFName,
    dateOfBirth,
    dbo.fnCalculateAge(dateOfBirth) AS Age
FROM student;

-- 11.2 Table-Valued Function
SELECT * FROM dbo.fnStudentApplications(1);

-- 11.3 Aggregate Function
SELECT 
    s.studentId,
    s.studentFName,
    dbo.fnStudentGPA(s.studentId) AS GPA
FROM student s;


					----------------------------------------------------------
					-- SECTION 12.0
					-- CTE (Common Table Expressions)
					----------------------------------------------------------
-- Application CTE

WITH ApplicationCTE AS (
    SELECT 
        a.applicationId,
        a.applicationDate,
        s.studentFName + ' ' + s.studentLName AS studentFullName,
        c.countryName,
        u.universityName,
        sub.subjectName,
        i.intakeName,
        i.intakeDate,
        aps.applicationStatusName,
        DATEDIFF(DAY, a.applicationDate, GETDATE()) AS daysSinceApplication
    FROM 
        application a
    INNER JOIN 
        student s ON a.studentId = s.studentId
    INNER JOIN 
        country c ON a.countryId = c.countryId
    INNER JOIN 
        university u ON a.universityId = u.universityId
    INNER JOIN 
        subject sub ON a.subjectId = sub.subjectId
    INNER JOIN 
        intake i ON a.intakeId = i.intakeId
    INNER JOIN 
        applicationStatus aps ON a.applicationStatusId = aps.applicationStatusId
)
SELECT 
    applicationId,
    applicationDate,
    studentFullName,
    countryName,
    universityName,
    subjectName,
    intakeName,
    intakeDate,
    applicationStatusName,
    daysSinceApplication,
    CASE 
        WHEN daysSinceApplication <= 30 THEN 'Recent'
        WHEN daysSinceApplication <= 90 THEN 'Medium'
        ELSE 'Old'
    END AS applicationAge
FROM 
    ApplicationCTE
ORDER BY 
    applicationDate DESC;
GO


-- Student application CTE

WITH StudentApplicationCTE AS (
    SELECT 
        s.studentId,
        s.studentFName,
        COUNT(a.applicationId) AS ApplicationCount
    FROM student s
    LEFT JOIN application a ON s.studentId = a.studentId
    GROUP BY s.studentId, s.studentFName
)
SELECT * FROM StudentApplicationCTE WHERE ApplicationCount > 0;
GO

						
					----------------------------------------------------------
					-- SECTION 13.0
					-- CURSOR Example
					----------------------------------------------------------


DECLARE @studentId INT, @studentName NVARCHAR(100), @marks DECIMAL(5,2)
DECLARE student_cursor CURSOR FOR
SELECT studentId, studentFName, lastMarks FROM student;

OPEN student_cursor
FETCH NEXT FROM student_cursor INTO @studentId, @studentName, @marks

WHILE @@FETCH_STATUS = 0
BEGIN
    -- Process each row here
    PRINT 'Student ID: ' + CAST(@studentId AS NVARCHAR(10)) + 
          ', Name: ' + @studentName + 
          ', Marks: ' + CAST(@marks AS NVARCHAR(10))
    
    FETCH NEXT FROM student_cursor INTO @studentId, @studentName, @marks
END

CLOSE student_cursor
DEALLOCATE student_cursor;