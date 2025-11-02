create procedure updateModuleDescription(@studiesID int, @moduleID int, @description nvarchar(max)) as
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS (SELECT 1 FROM studies WHERE studiesID = @studiesID)
    BEGIN
        RAISERROR ('Studia o podanym ID nie istnieją.', 16, 1);
        RETURN;
    END;

    IF NOT EXISTS (SELECT 1 FROM studyModules WHERE moduleID = @moduleID AND studiesID = @studiesID)
    BEGIN
        RAISERROR ('Moduł o podanym ID nie istnieje w ramach tych studiów.', 16, 1);
        RETURN;
    END;

    UPDATE studyModules
    SET description = @description
    WHERE moduleID = @moduleID AND studiesID = @studiesID;

    PRINT 'Opis modułu został zaktualizowany.';
END
go

