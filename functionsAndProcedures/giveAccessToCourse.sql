create procedure giveAccessToCourse(@courseID int, @studentID int, @accessStartDate datetime,
                                    @accessEndDate datetime) as
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS (SELECT 1 FROM Courses WHERE CourseID = @courseID)
    BEGIN
        RAISERROR('Kurs o podanym CourseID nie istnieje.', 16, 1);
        RETURN;
    END;

    IF NOT EXISTS (SELECT 1 FROM Students WHERE StudentID = @studentID)
    BEGIN
        RAISERROR('Student o podanym StudentID nie istnieje.', 16, 1);
        RETURN;
    END;

    INSERT INTO CourseAccess (CourseID, StudentID, AccessStartDate, AccessEndDate)
    VALUES (@courseID, @studentID, @accessStartDate, @accessEndDate);

    PRINT 'Dostęp został pomyślnie dodany.';
END
go

