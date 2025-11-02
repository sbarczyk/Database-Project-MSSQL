create procedure updateStudiesPlaceLimit(@placeLimit int, @studiesID int) as
BEGIN
    SET NOCOUNT ON;


    IF NOT EXISTS (SELECT 1 FROM studies WHERE studiesID = @studiesID)
    BEGIN
        RAISERROR ('Studia o podanym ID nie istnieją.', 16, 1);
        RETURN;
    END;

    IF @placeLimit <= 0
    BEGIN
        RAISERROR ('Limit miejsc musi być większy od 0.', 16, 1);
        RETURN;
    END;

    UPDATE studies
    SET placeLimit = @placeLimit
    WHERE studiesID = @studiesID;

    PRINT 'Limit miejsc został zaktualizowany.';
END
go

