create procedure removeCourseModule(@CourseID int, @ModuleID int) as
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS (
        SELECT 1
        FROM CourseModules
        WHERE CourseID = @CourseID AND ModuleID = @ModuleID
    )
    BEGIN
        RAISERROR('Moduł o podanym ModuleID nie istnieje w ramach wskazanego kursu.', 16, 1);
        RETURN;
    END;

    DELETE FROM CourseModules
    WHERE CourseID = @CourseID AND ModuleID = @ModuleID;

    PRINT 'Moduł został pomyślnie usunięty z kursu.';
END
go

