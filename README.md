# Dreamer Consultancy Management System (SQL Database Version)

This version of the **Dreamer Consultancy Management System** focuses exclusively on the SQL database aspect. It highlights the schema, stored procedures, triggers, and views used for managing the consultancy firm's data.

## Features

- Complex SQL database schema with multiple interrelated entities.
- Stored procedures for handling complex queries and data operations.
- Database functions and triggers to maintain data integrity.
- Focus on key data aspects such as students, applications, counselors, payments, and visa tracking.
- No application-specific code—only the database structure and SQL queries are provided.

## Prerequisites

- SQL Server 2019 or later
- SQL Server Management Studio (SSMS) for managing the database

## Installation

1. **Clone the repository** (if applicable):
   ```bash
   git clone https://github.com/yousuf-mansur/dreamer-consultancy-management-system-sql-only.git
   ```

2. **Open the SQL scripts**:
   - Use SQL Server Management Studio (SSMS) to open the SQL files provided in the `/Database/` folder.

3. **Set up the database**:
   - Create a new database in SQL Server for the Dreamer Consultancy Management System.
   - Run the provided SQL scripts to create tables, relationships, and any other database objects.

   Example:
   ```sql
   CREATE DATABASE DreamerConsultancyDB;
   USE DreamerConsultancyDB;

   -- Run the table creation script
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

   
   -- Create more tables like Applications, Counselors, Universities, Payments, etc.
   ```

4. **Run Stored Procedures and Functions**:
   - The system includes stored procedures for managing CRUD operations on various entities such as students, counselors, applications, and payments.

   Example:
```sql
   -- Stored Procedure to add a new student
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
 ```

## Database Structure

The database is designed to handle complex relationships and track various aspects of the student application process.

### Key Tables

1. **student**: Stores information about students, including contact details and personal data.
2. **application**: Tracks student applications to different universities, along with statuses like "In Progress," "Submitted," or "Accepted."
3. **counselor**: Stores data about the consultants or counselors assisting the students with their applications.
4. **payment**: Tracks student payments and any scholarships they might receive.
5. **universitie**: Stores information about the universities students are applying to.
6. **course**: Tracks the different courses students are applying for at each university.

### Sample Relationships

- **student** → **Applications**: One student can have many applications.
- **counselor** → **Students**: Each student is assigned a counselor to assist with their application process.
- **application** → **Universities**: Each application is associated with a university and a specific course.


## Stored Procedures, Functions, and Triggers

### Stored Procedures

- **AddStudent**: Inserts a new student into the `Students` table.
- **UpdateStudent**: Updates existing student information.
- **DeleteStudent**: Removes a student from the database.
- **TrackApplicationStatus**: Updates the status of a student’s application.
- **GenerateReport**: Creates reports on the application success rates of students.

### Triggers

- **ApplicationStatusUpdateTrigger**: Automatically logs a change when the status of an application is updated.
- **PaymentTrigger**: Ensures that payment data is properly tracked and linked with the correct student.

### Example: Trigger

```sql
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
```

## Case Study: Dreamer Consultancy

This database design helps Dreamer Consultancy manage the following:

1. **Complex Relationships**: The database handles relationships between students, applications, counselors, and payments.
2. **Tracking Applications**: Applications are tracked through various stages, from submission to acceptance.
3. **Counselor Assignment**: The system tracks which counselors are helping each student.
4. **Visa and Payment Tracking**: The database stores and tracks payments and the visa application process for students.
5. **Reports**: The use of stored procedures allows for the generation of complex reports based on student performance and success rates in applications.

## Usage

To manage and query the database, run the SQL scripts for CRUD operations, or execute stored procedures for reporting and data manipulation.

Example of querying students:
```sql
SELECT * FROM student;
```

To update a student record:
```sql
EXEC UpdateStudent @StudentId = 1, @FirstName = 'Monsur', @LastName = 'Sarkar', @Email = 'sarkar@example.com';
```

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

This SQL-only version of the Dreamer Consultancy Management System focuses on providing a robust and scalable database that supports complex data relationships, stored procedures, and triggers for managing the educational consultancy's operations.

## About Me
I am Md. Yousuf Mansur, a full-stack developer specializing in web application development. My skills include:

ASP.NET MVC and ASP.NET Core
Angular and React for front-end development
Entity Framework and Entity Framework Core
SQL Server database management
RESTful APIs and Web Services
JavaScript, jQuery, and Ajax

My journey in software development began in 2023 with an IsDB-BISEW scholarship. I have completed my scholarship course at Star Computer Systems Limited and gained practical experience.
With a year of experience in web development, I am proficient in modern technologies and methodologies, enabling me to develop complex systems like the Dreamer Consultancy Management System.

Contact me For your Project
E-mail: mansurmdyousuf@gmail.com
WhatsApp: +880 1719983377
LinkedIn: https://www.linkedin.com/in/md-yousuf-mansur/
