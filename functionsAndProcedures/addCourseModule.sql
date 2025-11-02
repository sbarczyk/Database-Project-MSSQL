create procedure addCourseModule(@CourseID int, @tutorID int, @moduleID int, @moduleTitle nvarchar(100),
                                 @moduleDate date, @languageID int) as
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS (SELECT 1 FROM Courses WHERE CourseID = @CourseID)
    BEGIN
        RAISERROR('Nie istnieje kurs o podanym CourseID.', 16, 1);
        RETURN;
    END

    IF NOT EXISTS (SELECT 1 FROM Tutors WHERE TutorID = @tutorID)
    BEGIN
        RAISERROR('Nie istnieje tutor o podanym tutorID.', 16, 1);
        RETURN;
    END

    IF NOT EXISTS (SELECT 1 FROM Languages WHERE id = @languageID)
    BEGIN
        RAISERROR('Nie istnieje język o podanym languageID.', 16, 1);
        RETURN;
    END

    IF EXISTS (SELECT 1 FROM CourseModules WHERE ModuleID = @moduleID)
    BEGIN
        RAISERROR('Podany moduleID już istnieje w tabeli CourseModules.', 16, 1);
        RETURN;
    END

    INSERT INTO CourseModules (CourseID, TutorID, ModuleID, ModuleTitle, ModuleDate, LanguageID)
    VALUES (@CourseID, @tutorID, @moduleID, @moduleTitle, @moduleDate, @languageID);

    PRINT 'Moduł został pomyślnie dodany.';
END
go

