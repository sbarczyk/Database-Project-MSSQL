create procedure addInternship(@studiesID int, @startDate date, @endDate date, @internshipID int) as
BEGIN
    SET NOCOUNT ON;

    IF @endDate <= @startDate
    BEGIN
        RAISERROR ('Data zakończenia musi być późniejsza niż data rozpoczęcia.', 16, 1);
        RETURN;
    END;

    IF NOT EXISTS (SELECT 1 FROM studies WHERE studiesID = @studiesID)
    BEGIN
        RAISERROR ('Studia o podanym ID nie istnieją.', 16, 1);
        RETURN;
    END;

    INSERT INTO internship (studiesID, startDate, endDate)
    VALUES (@studiesID, @startDate, @endDate);

    -- Pobranie ID nowo dodanych praktyk
    SET @internshipID = SCOPE_IDENTITY();

    PRINT 'Praktyki zostały dodane.';
END
go

