Create DATABASE Departament
USE Departament
CREATE TABLE Departments (
    Id INT PRIMARY KEY IDENTITY (1, 1),
    Name VARCHAR(50) NOT NULL
);
CREATE TABLE Positions (
    Id INT PRIMARY KEY IDENTITY (1, 1),
    Name VARCHAR(50) NOT NULL,
    Limit INT,
	DepartamentId int FOREIGN KEY REFERENCES Departaments(Id)
);
CREATE TABLE Workers (
    Id INT PRIMARY KEY IDENTITY (1, 1),
    Name VARCHAR(50) NOT NULL,
    Surname VARCHAR(50) NOT NULL,
    PhoneNumber VARCHAR(20) DEFAULT ('+994000000000'),
    Salary DECIMAL(10, 2),
    BirthDate DATE,
	PositionId int FOREIGN KEY REFERENCES Positions(Id)
);


INSERT INTO Departments (Name)
VALUES
('HR Department'),
('IT Department'),
('Finance Department');


INSERT INTO Positions (Name, Limit, DepartamentId)
VALUES
('HR Manager', NULL, 1), 
('Software Engineer', 10, 2), 
('Financial Analyst', NULL, 3); 


INSERT INTO Workers (Name, Surname, PhoneNumber, Salary, BirthDate, PositionId)
VALUES
('John', 'Smith', '+994123456789', 4000.00, '1990-05-15', 1), -
('Emily', 'Johnson', '+994987654321', 4500.00, '1995-08-20', 2), 
('Michael', 'Williams', NULL, 3800.00, '1988-11-10', 3);

CREATE TRIGGER trigger_InsertWorker ON Workers
INSTEAD OF INSERT
AS
BEGIN
   
    DECLARE @PostionId INT
    DECLARE @PositionLimit INT
    DECLARE @CurrentCount INT

    
    SELECT @PositionId = Position
    
	SELECT @PositionLimit =  @PositionLimit FROM Position 
    WHERE Id = PositionId
           
	SELECT @CurrentCount =  COUNT(Id) FROM Workers 
	WHERE PositionId = PositionId FROM inserted


    IF @CurrentCount >
    BEGIN
        RAISERROR ('Adding workers exceeds position limit.', 10, 1)
       RETURN
    END

	 INSERT INTO Name, Surname, PhoneNumber, Salary, BirthDate, PositionId
	 SELECT Name, Surname, PhoneNumber, Salary, BirthDate, PositionId FROM inserted
END


CREATE TRIGGER trigger_InsertWorker ON Workers
INSTEAD OF INSERT
AS
BEGIN

    DECLARE @Age INT


    SELECT @Age = DATEDIFF(YEAR, BirthDate, GETDATE()) FROM inserted
   


    IF @Age <= 18
    BEGIN
        RAISERROR ('Worker must be 18 years or older', 10, 1)
        RETURN
    END

    INSERT INTO Workers (Name, Surname, PhoneNumber, Salary, BirthDate, PositionId)
	SELECT Name, Surname, PhoneNumber, Salary, BirthDate, PositionId FROM inserted
        
END


CREATE FUNCTION  GetAverageSalary (@DepartmentId INT)
RETURNS DECIMAL
AS
BEGIN
    DECLARE @AverageSalary DECIMAL(10, 2)

    SELECT @AverageSalary = AVG(Salary)
    FROM Workers
    WHERE PositionId IN (SELECT Id FROM Positions WHERE DepartamentId = @DepartmentId);

    RETURN @AverageSalary;
END


