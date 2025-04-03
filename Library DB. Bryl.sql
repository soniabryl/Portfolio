CREATE DATABASE hw1;
GO
USE hw1;
GO

CREATE TABLE Authors (
	AuthorID int IDENTITY(1,1) PRIMARY KEY,
	AuthorName varchar(100) NOT NULL,
	Country varchar(100)
);

CREATE TABLE Genres (
	GenreID int IDENTITY(1,1) PRIMARY KEY,
	GenreName varchar(100) NOT NULL
);

CREATE TABLE Books (
	BookID int IDENTITY(1,1) PRIMARY KEY,
	Title varchar(100),
	AuthorID int NOT NULL,
	GenreID int,
	PublicationYear int,
	FOREIGN KEY (AuthorID) REFERENCES Authors(AuthorID),
	FOREIGN KEY (GenreID) REFERENCES Genres(GenreID)
);

CREATE TABLE Members (
	MemberID int IDENTITY(1,1) PRIMARY KEY,
    MemberName varchar(255) NOT NULL,
    JoinDate DATE,
    Email varchar(255)
);

CREATE TABLE Member_books (
    LoanID  int IDENTITY(1,1) PRIMARY KEY,
    MemberID int,
    BookID int,
    DateBorrowed DATE NOT NULL,
    DateReturned DATE,
    FOREIGN KEY (MemberID) REFERENCES Members(MemberID),
    FOREIGN KEY (BookID) REFERENCES Books(BookID)
);

INSERT INTO Authors (AuthorName, Country) VALUES
('George Orwell', 'United Kingdom'),
('Harper Lee', 'United States'),
('F. Scott Fitzgerald', 'United States'),
('Herman Melville', 'United States'),
('Jane Austen', 'United Kingdom');

INSERT INTO Genres (GenreName) VALUES
('Dystopian'),
('Fiction'),
('Adventure'),
('Romance');

INSERT INTO Books (Title, AuthorID, PublicationYear, GenreID) VALUES
('1984', 1, 1949, 1),
('To Kill a Mockingbird', 2, 1960, 2),
('The Great Gatsby', 3, 1925, 1),
('Moby-Dick', 4, 1851, 3),
('Pride and Prejudice', 5, 1813, 4),
('Emma', 5, 1815, 4),
('Animal Farm', 1, 1845, 1);

INSERT INTO Members (MemberName, JoinDate, Email) VALUES
('Alice Johnson', '2022-05-01', 'alice.johnson@email.com'),
('Bob Smith', '2021-11-20', 'bob.smith@email.com'),
('Clara Davis', '2023-01-15', 'clara.davis@email.com'),
('David Brown', '2022-07-12', 'david.brown@email.com'),
('Eva Wilson', '2023-02-10', 'eva.wilson@email.com');


INSERT INTO Member_books (MemberID, BookID, DateBorrowed, DateReturned) VALUES
(1,4, '2024-01-15', '2024-02-01'),
(3,1, '2024-01-20', '2024-02-10'),
(4,3, '2024-02-05', NULL),
(4,2, '2024-02-12', '2024-02-28'),
(5,5, '2024-02-18', NULL);

---/Adding queries/
---(Books tha are borrowed now)
SELECT
    M.MemberName,
    B.Title AS BookTitle,
    MB.DateBorrowed
FROM
    Member_books AS MB
JOIN
    Members AS M ON MB.MemberID = M.MemberID
JOIN
    Books AS B ON MB.BookID = B.BookID
WHERE
    MB.DateReturned IS NULL;

---(Number of books each member borrowed)
SELECT
    M.MemberName,
    COUNT(MB.BookID) AS TotalBooksBorrowed
FROM
    Members AS M
LEFT JOIN
    Member_books AS MB ON M.MemberID = MB.MemberID
GROUP BY
    M.MemberName;


SELECT Title 
FROM Books 
WHERE PublicationYear BETWEEN 1900 AND 1970
ORDER BY PublicationYear ASC
OFFSET 2 ROWS;

SELECT GenreName AS Name, 'Genre' AS Type
FROM Genres
UNION
SELECT AuthorName, 'Author' AS Type
FROM Authors;

SELECT AuthorName, COUNT(BookID) AS TotalBooks
FROM Authors 
INNER JOIN Books ON Authors.AuthorID = Books.AuthorID
GROUP BY AuthorName
ORDER BY TotalBooks DESC;

SELECT AuthorName, COUNT(BookID) AS TotalBooks
FROM Authors 
INNER JOIN Books ON Authors.AuthorID = Books.AuthorID
GROUP BY AuthorName
HAVING COUNT(BookID) > 1;


