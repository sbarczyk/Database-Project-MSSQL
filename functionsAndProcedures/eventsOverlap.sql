create function eventsOverlap(@eventID1 int, @eventID2 int) returns bit as
BEGIN
    DECLARE @overlap BIT = 0;
    DECLARE @startDate1 DATETIME, @endDate1 DATETIME;
    DECLARE @startDate2 DATETIME, @endDate2 DATETIME;

    SELECT TOP 1
        @startDate1 = CASE
                        WHEN meetingID IS NOT NULL THEN m.startDate
                        ELSE w.startDate
                      END,
        @endDate1 = CASE
                     WHEN meetingID IS NOT NULL THEN m.endDate
                     ELSE w.endDate
                    END
    FROM meeting m
    LEFT JOIN Webinars w ON m.meetingID = @eventID1
    WHERE m.meetingID = @eventID1 OR w.webinarID = @eventID1;

    SELECT TOP 1
        @startDate2 = CASE
                        WHEN meetingID IS NOT NULL THEN m.startDate
                        ELSE w.startDate
                      END,
        @endDate2 = CASE
                     WHEN meetingID IS NOT NULL THEN m.endDate
                     ELSE w.endDate
                    END
    FROM meeting m
    LEFT JOIN Webinars w ON m.meetingID = @eventID2
    WHERE m.meetingID = @eventID2 OR w.webinarID = @eventID2;

    IF (@startDate1 <= @endDate2 AND @endDate1 >= @startDate2)
    BEGIN
        SET @overlap = 1;
    END

    RETURN @overlap;
END
go

