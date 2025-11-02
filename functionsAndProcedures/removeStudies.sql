create procedure removeStudies(@studiesID int) as
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS (SELECT 1 FROM studies WHERE studiesID = @studiesID)
    BEGIN
        RAISERROR ('Studia o podanym ID nie istnieją.', 16, 1);
        RETURN;
    END;

    DELETE FROM studies
    WHERE studiesID = @studiesID;

    PRINT 'Studia zostały usunięte.';
END
go

