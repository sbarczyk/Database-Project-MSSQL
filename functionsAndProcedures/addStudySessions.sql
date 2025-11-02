create procedure addStudySessions(@meetingID int, @studiesID int, @moduleID int, @productID int) as
BEGIN
    SET NOCOUNT ON;

    IF EXISTS (SELECT 1 FROM StudySessions WHERE MeetingID = @meetingID)
    BEGIN
        RAISERROR ('Podany meetingID już istnieje w tabeli StudySessions.', 16, 1);
        RETURN;
    END

    IF NOT EXISTS (SELECT 1 FROM Products WHERE ProductID = @productID)
    BEGIN
        RAISERROR ('Podany productID nie istnieje w tabeli Products.', 16, 1);
        RETURN;
    END

    IF NOT EXISTS (SELECT 1 FROM Studies WHERE StudiesID = @studiesID)
    BEGIN
        RAISERROR ('Podany studiesID nie istnieje w tabeli Studies.', 16, 1);
        RETURN;
    END

    IF NOT EXISTS (SELECT 1 FROM StudyModules WHERE ModuleID = @moduleID AND StudiesID = @studiesID)
    BEGIN
        RAISERROR ('Podany moduleID nie istnieje dla podanego studiesID w tabeli StudyModules.', 16, 1);
        RETURN;
    END

    INSERT INTO StudySessions (MeetingID, StudiesID, ModuleID, ProductID)
    VALUES (@meetingID, @studiesID, @moduleID, @productID);

    PRINT 'Spotkanie zostało pomyślnie dodane.';
END
go

