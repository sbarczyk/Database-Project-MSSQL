create procedure removeCourse(@courseID int) as
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS (SELECT 1 FROM Courses WHERE courseID = @courseID)
    BEGIN
        RAISERROR ('Kurs o podanym courseID nie istnieje.', 16, 1);
        RETURN;
    END;

    DELETE FROM Courses
    WHERE courseID = @courseID;

    PRINT 'Kurs został pomyślnie usunięty.';
END
go

