create procedure updateModuleCoordinator(@studiesID int, @moduleID int, @coordinatorID int) as
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS (SELECT 1 FROM studies WHERE studiesID = @studiesID)
    BEGIN
        RAISERROR ('Studia o podanym ID nie istnieją.', 16, 1);
        RETURN;
    END;

    IF NOT EXISTS (SELECT 1 FROM studyModules WHERE moduleID = @moduleID AND studiesID = @studiesID)
    BEGIN
        RAISERROR ('Moduł o podanym ID nie istnieje w danych studiach.', 16, 1);
        RETURN;
    END;

    IF NOT EXISTS (SELECT 1 FROM coordinators WHERE coordinatorID = @coordinatorID)
    BEGIN
        RAISERROR ('Koordynator o podanym ID nie istnieje.', 16, 1);
        RETURN;
    END;

    UPDATE studyModules
    SET coordinatorID = @coordinatorID
    WHERE moduleID = @moduleID AND studiesID = @studiesID;

    PRINT 'Koordynator modułu został zaktualizowany.';
END
go

