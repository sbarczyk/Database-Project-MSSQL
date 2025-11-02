create procedure addStudies(@placeLimit int, @studiesName nvarchar(255), @studiesID int) as
BEGIN
    SET NOCOUNT ON;

    IF @placeLimit <= 0
    BEGIN
        RAISERROR ('Limit miejsc musi być większy od 0.', 16, 1);
        RETURN;
    END;

    IF @studiesName IS NULL OR LEN(@studiesName) = 0
    BEGIN
        RAISERROR ('Nazwa studiów nie może być pusta.', 16, 1);
        RETURN;
    END;

    INSERT INTO studies (placeLimit, studiesName)
    VALUES (@placeLimit, @studiesName);

    SET @studiesID = SCOPE_IDENTITY();

    PRINT 'Nowe studia zostały dodane.';
END
go

