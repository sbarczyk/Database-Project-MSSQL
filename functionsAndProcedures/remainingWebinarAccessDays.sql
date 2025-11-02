create function remainingWebinarAccessDays(@studentID int, @webinarID int) returns int as
BEGIN
    DECLARE @remainingDays INT = 0;
    DECLARE @currentDate DATETIME = GETDATE();

    IF dbo.UserHasAccessToWebinar(@studentID, @webinarID) = 0
    BEGIN
        RETURN @remainingDays;
    END

    SELECT @remainingDays = DATEDIFF(DAY, @currentDate, wa.AccessEndDate)
    FROM WebinarAccess wa
    WHERE wa.studentID = @studentID
      AND wa.webinarID = @webinarID;

    IF @remainingDays < 0
    BEGIN
        SET @remainingDays = 0;
    END

    RETURN @remainingDays;
END
go

grant execute on remainingWebinarAccessDays to Participant
go

