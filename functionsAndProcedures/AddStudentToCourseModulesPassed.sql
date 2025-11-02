create procedure AddStudentToCourseModulesPassed(@moduleID int, @studentID int) as
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS (SELECT 1 FROM students WHERE StudentID = @studentID)
    BEGIN
        RAISERROR ('Student o podanym ID nie istnieje.', 16, 1);
        RETURN;
    END

    IF NOT EXISTS (SELECT 1 FROM CourseModules WHERE ModuleID = @moduleID)
    BEGIN
        RAISERROR ('Moduł o podanym ID nie istnieje.', 16, 1);
        RETURN;
    END

    IF EXISTS (SELECT 1 FROM CourseModulesPassed WHERE ModuleID = @moduleID AND StudentID = @studentID)
    BEGIN
        RAISERROR ('Student już zaliczył ten moduł.', 16, 1);
        RETURN;
    END

    INSERT INTO CourseModulesPassed (ModuleID, StudentID)
    VALUES (@moduleID, @studentID);

    PRINT 'Student został pomyślnie dodany do tabeli zaliczonych modułów.';
END
go

grant execute on AddStudentToCourseModulesPassed to Lecturer
go

