create procedure addWebinar(@tutorID int, @translatorID int, @Title nvarchar(64), @productID int, @StartDate datetime,
                            @Description nvarchar(max), @recordingURL nvarchar(128), @languageID int, @webinarID int) as
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS (SELECT 1 FROM products WHERE productID = @productID)
    BEGIN
        RAISERROR ('Produkt o podanym productID nie istnieje.', 16, 1);
        RETURN;
    END;

    INSERT INTO Webinars (tutorID, translatorID, Title, productID, StartDate, Description, recordingURL, languageID)
    VALUES (@tutorID, @translatorID, @Title, @productID, @StartDate, @Description, @recordingURL, @languageID);

    SET @webinarID = SCOPE_IDENTITY();

    PRINT 'Webinar został dodany.';
END
go

