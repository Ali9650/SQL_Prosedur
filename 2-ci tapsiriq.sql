Create DATABASE Course
USE Course
CREATE TABLE Groups (
    Id INT PRIMARY KEY IDENTITY (1,1),
    Name VARCHAR(50) NOT NULL,
    Limit INT,
    BeginDate DATE,
    EndDate DATE
);

CREATE TABLE Students (
    Id INT PRIMARY KEY IDENTITY (1,1),
    Name VARCHAR(50) NOT NULL,
    Surname VARCHAR(50) NOT NULL,
    Email VARCHAR(100) NOT NULL,
    PhoneNumber VARCHAR(20) DEFAULT ('+994000000000'),
    BirthDate DATE,
    GPA DECIMAL(3, 2),
	GroupId int FOREIGN KEY REFERENCES Groups(Id)
);


INSERT INTO Groups (Name, Limit, BeginDate, EndDate)
VALUES
('Group A', 20, '2024-01-01', '2024-06-30'),
('Group B', 15, '2024-02-15', '2024-07-31'),
('Group C', 25, '2024-03-10', '2024-08-31');


INSERT INTO Students (Name, Surname, Email, PhoneNumber, BirthDate, GPA, GroupId)
VALUES
('John', 'Doe', 'john.doe@example.com', '+994123456789', '2000-05-15', 3.50, 1),
('Jane', 'Smith', 'jane.smith@example.com', '+994987654321', '2001-08-20', 3.80, 2),
('Michael', 'Johnson', 'michael.johnson@example.com', '+994555555555', '1999-11-10', 3.20, 1),
('Emily', 'Brown', 'emily.brown@example.com', NULL, '2002-03-25', 3.90, 2),
('David', 'Wilson', 'david.wilson@example.com', '+994777777777', '2000-12-05', 3.60, 3);


SELECT * FROM Groups;
SELECT * FROM Students;

CREATE TRIGGER trigger_CheckGroupLimit ON Students
INSTEAD OF INSERT
AS
BEGIN
   
    DECLARE @GroupId INT
    DECLARE @GroupLimit INT
    DECLARE @CurrentCount INT

    
    SELECT @GroupId = GroupId
    
	SELECT @GroupLimit =  GroupLimit FROM Groups 
    WHERE Id = GroupId
           
	SELECT @CurrentCount =  COUNT(Id) FROM Students 
	WHERE GroupId = GroupId FROM inserted


    IF @CurrentCount > @GroupLimit
    BEGIN
        RAISERROR ('Adding student exceeds group limit.', 10, 1)
       RETURN
    END

	 INSERT INTO Students (Name, Surname, Email, PhoneNumber, BirthDate, GPA, GroupId)
	 SELECT Name, Surname, Email, PhoneNumber, BirthDate, GPA, GroupId FROM inserted
END


CREATE TRIGGER trigger_CheckStudentAge ON Students
INSTEAD OF INSERT
AS
BEGIN

    DECLARE @StudentId INT
    DECLARE @BirthDate DATE
    DECLARE @Age INT

    SELECT @StudentId = Id
	SELECT @BirthDate = BirthDate FROM inserted
   

    SET @Age = DATEDIFF(YEAR, @BirthDate, GETDATE());

    IF @Age <= 16
    BEGIN
        RAISERROR ('Student must be older than 16 years.', 10, 1)
        RETURN
    END

    INSERT INTO Students (Name, Surname, Email, PhoneNumber, BirthDate, GPA, GroupId)
	SELECT Name, Surname, Email, PhoneNumber, BirthDate, GPA, GroupId FROM inserted
        
END
 
 Create Function GetAverageGPA (@GroupId INT)
RETURNS DECIMAL 
AS
BEGIN
DECLARE @AverageGPA DECIMAL (3,2)

SELECT @AverageGPA=AVG (GPA)
FROM Students
WHERE GroupId=@GroupId;

RETURN @AverageGPA
END



