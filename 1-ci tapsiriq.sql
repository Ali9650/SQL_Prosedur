CREATE DATABASE MoviesApp
USE MoviesApp
CREATE TABLE Directors(
Id INT PRIMARY KEY IDENTITY(1,1),
Name NVARCHAR(50) NOT NULL,
Surname NVARCHAR(50) NOT NULL,
)

CREATE TABLE Languages(
Id INT PRIMARY KEY IDENTITY(1,1),
Name NVARCHAR(50) NOT NULL
)
CREATE TABLE Actors(
Id INT PRIMARY KEY IDENTITY(1,1),
Name NVARCHAR(50) NOT NULL,
Surname NVARCHAR(50) NOT NULL,
)

CREATE TABLE Movies(
Id INT PRIMARY KEY IDENTITY(1,1),
Name NVARCHAR(50) NOT NULL,
Description NVARCHAR(50) NOT NULL,
CoverPhoto NVARCHAR (50) NOT NULL,
LanguageId INT FOREIGN KEY REFERENCES Languages(Id)
)

CREATE TABLE Genres(
Id INT PRIMARY KEY IDENTITY(1,1),
Name NVARCHAR(50) NOT NULL UNIQUE
)

CREATE TABLE DirectorsMovies(
Id INT PRIMARY KEY IDENTITY(1,1),
DirectorId INT FOREIGN KEY REFERENCES Directors(Id),
MovieId INT FOREIGN KEY REFERENCES Movies(Id)
)

CREATE TABLE ActorsMovies(
Id INT PRIMARY KEY IDENTITY(1,1),
ActorId INT FOREIGN KEY REFERENCES Actors(Id),
MovieId INT FOREIGN KEY REFERENCES Movies(Id)
)

CREATE TABLE MoviesGenres(
Id INT PRIMARY KEY IDENTITY(1,1),
MovieId INT FOREIGN KEY REFERENCES Movies(Id),
GenreId INT FOREIGN KEY REFERENCES Genres(Id)
)

INSERT INTO Directors (Name, Surname) VALUES ('Steven', 'Spielberg');
INSERT INTO Directors (Name, Surname) VALUES ('Quentin', 'Tarantino');

INSERT INTO Languages (Name) VALUES ('English');
INSERT INTO Languages (Name) VALUES ('Spanish');

INSERT INTO Actors (Name, Surname) VALUES ('Leonardo', 'DiCaprio');
INSERT INTO Actors (Name, Surname) VALUES ('Natalie', 'Portman');

INSERT INTO Movies (Name, Description, CoverPhoto, LanguageId) 
VALUES ('Inception', 'A mind-bending thriller about dreams.', 'inception_cover.jpg', 1);

INSERT INTO Movies (Name, Description, CoverPhoto, LanguageId) 
VALUES ('Pulp Fiction', 'A crime film that intertwines multiple stories.', 'pulp_fiction_cover.jpg', 1);

INSERT INTO Genres (Name) VALUES ('Action');
INSERT INTO Genres (Name) VALUES ('Drama');

INSERT INTO DirectorsMovies (DirectorId, MovieId) 
VALUES (1, 1)

INSERT INTO DirectorsMovies (DirectorId, MovieId) 
VALUES (2, 2)

INSERT INTO ActorsMovies (ActorId, MovieId) 
VALUES (1, 1)

INSERT INTO ActorsMovies (ActorId, MovieId) 
VALUES (2, 2)

INSERT INTO MoviesGenres (MovieId, GenreId) 
VALUES (1, 1)

INSERT INTO MoviesGenres (MovieId, GenreId) 
VALUES (2, 2)

CREATE FUNCTION CountMoviesByLanguage
    (@languageId INT)
RETURNS INT
AS
BEGIN
    DECLARE @count INT;

    SELECT @count = COUNT(*)
    FROM Movies
    WHERE LanguageId = @languageId;

    RETURN @count;
END;

CREATE FUNCTION CountMoviesByLanguage (@languageId INT)
RETURNS INT
AS
BEGIN
    DECLARE @count INT;

    SELECT @count = COUNT(0)
    FROM Movies
    WHERE LanguageId = @languageId

    RETURN @count
END

CREATE FUNCTION ActorMovies (@actorId INT)
RETURNS BIT
AS
BEGIN
    DECLARE @count INT;

    SELECT @count = COUNT(3)
    FROM ActorsMovies
    WHERE ActorId = @actorId;

    RETURN CASE 
        WHEN @count > 3 THEN 1 
        ELSE 0                  
    END
END

CREATE PROCEDURE GetMoviesByDirector (@directorId INT)
AS
BEGIN
    SELECT 
        m.Name AS MovieName,
        l.Name AS LanguageName
    FROM 
        Movies m
    JOIN DirectorsMovies dm 
	ON m.Id = dm.MovieId
    JOIN Directors d 
	ON dm.DirectorId = d.Id
    JOIN Languages l 
	ON m.LanguageId = l.Id
    WHERE 
        d.Id = @directorId;
END

CREATE PROCEDURE GetMoviesByGenre (@genreId INT)
AS
BEGIN
    SELECT 
        m.Name AS MovieName,
        d.Name AS DirectorName,
        d.Surname AS DirectorSurname
    FROM 
        Movies m
    JOIN MoviesGenres mg 
	ON m.Id = mg.MovieId
    JOIN Genres g 
	ON mg.GenreId = g.Id
    JOIN  DirectorsMovies dm 
	ON m.Id = dm.MovieId
    JOIN Directors d 
	ON dm.DirectorId = d.Id
    WHERE 
        g.Id = @genreId;
END


CREATE TRIGGER ShowMovies
ON Movies
AFTER INSERT
AS
BEGIN
    SELECT 
        m.Name AS MovieName,
        d.Name AS DirectorName,
        d.Surname AS DirectorSurname   
    FROM 
        Movies m
    JOIN DirectorsMovies dm 
	ON m.Id = dm.MovieId
    JOIN Directors d ON 
	dm.DirectorId = d.Id
END

