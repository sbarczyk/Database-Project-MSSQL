create function availableSeatsForCourses(@courseID int) returns int as
BEGIN
    DECLARE @minRoomCapacity INT;
    DECLARE @studentsWithAccess INT;
    DECLARE @availableSeats INT;

    -- Znajdź najmniejszą pojemność pokoju w stacjonarnych spotkaniach kursu
    SELECT @minRoomCapacity = MIN(r.placeLimit)
    FROM CourseModules cm
    JOIN moduleMeetings mm ON cm.moduleID = mm.moduleID
    JOIN meeting m ON mm.meetingID = m.meetingID
    JOIN StationaryMeeting sm ON m.meetingID = sm.meetingID
    JOIN Rooms r ON sm.room = r.id
    WHERE cm.courseID = @courseID;

    -- Policz liczbę studentów z dostępem do kursu
    SELECT @studentsWithAccess = COUNT(*)
    FROM CourseAccess
    WHERE courseID = @courseID;

    -- Oblicz liczbę dostępnych miejsc
    SET @availableSeats = @minRoomCapacity - @studentsWithAccess;

    -- Upewnij się, że nie zwrócisz wartości ujemnej
    IF @availableSeats < 0
    BEGIN
        SET @availableSeats = 0;
    END

    RETURN @availableSeats;
END
go

grant execute on availableSeatsForCourses to Participant
go

