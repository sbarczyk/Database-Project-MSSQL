create view vStudentadress as
SELECT
    s.StudentID,
    u.FirstName,
    u.LastName,
    a.Country,
    a.City,
    a.Street,
    a.ZipCode
FROM
    Students s
JOIN
    Users u ON s.StudentID = u.UserID
LEFT JOIN
    address a ON s.StudentID = a.userID
go

