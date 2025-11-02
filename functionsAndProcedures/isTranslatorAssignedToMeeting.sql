create function isTranslatorAssignedToMeeting(@meetingID int) returns nvarchar(64) as
BEGIN
    DECLARE @languageName NVARCHAR(64);

    SELECT @languageName = CASE
                              WHEN m.meetingTranslator IS NOT NULL THEN l.name
                              ELSE NULL
                           END
    FROM meeting m
    LEFT JOIN translators t ON m.meetingTranslator = t.translatorID
    LEFT JOIN languages l ON t.languageID = l.id
    WHERE m.meetingID = @meetingID;

    RETURN @languageName;
END
go

grant execute on isTranslatorAssignedToMeeting to Participant
go

