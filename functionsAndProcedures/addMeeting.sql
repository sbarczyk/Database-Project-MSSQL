create procedure addMeeting(@tutorID int, @startDate datetime, @endDate datetime, @languageID int,
                            @meetingTranslator int = NULL, @meetingID int) as
BEGIN
    SET NOCOUNT ON;

    -- Dodanie nowego spotkania do tabeli 'meeting'
    INSERT INTO meeting (tutorID, startDate, endDate, languageID, meetingTranslator)
    VALUES (@tutorID, @startDate, @endDate, @languageID, @meetingTranslator);

    -- Pobranie wygenerowanego meetingID
    SET @meetingID = SCOPE_IDENTITY();
END
go

