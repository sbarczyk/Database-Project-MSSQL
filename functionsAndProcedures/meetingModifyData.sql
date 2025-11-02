create procedure meetingModifyData(@meetingID int, @tutorID int, @startDate datetime, @endDate datetime,
                                   @languageID int, @meetingTranslator int = NULL) as
BEGIN
    SET NOCOUNT ON;

    -- Sprawdzenie, czy spotkanie o podanym meetingID istnieje
    IF EXISTS (SELECT 1 FROM meeting WHERE meetingID = @meetingID)
    BEGIN
        -- Aktualizacja danych spotkania
        UPDATE meeting
        SET
            tutorID = @tutorID,
            startDate = @startDate,
            endDate = @endDate,
            languageID = @languageID,
            meetingTranslator = @meetingTranslator
        WHERE meetingID = @meetingID;

        PRINT 'Dane spotkania zostały zaktualizowane.';
    END
    ELSE
    BEGIN
        -- Jeśli spotkanie nie istnieje
        RAISERROR ('Spotkanie o podanym meetingID nie istnieje.', 16, 1);
    END
END
go

