create procedure revokeAccessToCourse(@courseID int, @studentID int) as
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

    DELETE FROM CourseAccess
    WHERE CourseID = @courseID AND StudentID = @studentID;

    PRINT 'Dostęp do kursu został usunięty dla danego studenta.';
END
go

