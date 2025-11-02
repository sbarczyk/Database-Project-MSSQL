create function availableSeatsForStudiesSession(@meetingID int, @moduleID int, @studiesID int) returns int as
BEGIN
    DECLARE @roomCapacity INT;
    DECLARE @studentsFromModule INT;
    DECLARE @extraParticipants INT;
    DECLARE @availableSeats INT;

    SELECT @roomCapacity = r.placeLimit
    FROM studySessions ss
    JOIN StationaryMeeting sm ON ss.meetingID = sm.meetingID
    JOIN Rooms r ON sm.room = r.id
    WHERE ss.meetingID = @meetingID AND ss.studiesID = @studiesID AND ss.moduleID = @moduleID;

    SELECT @studentsFromModule = COUNT(*)
    FROM studyModuleParticipants smp
    WHERE smp.studiesID = @studiesID AND smp.moduleID = @moduleID;

    SELECT @extraParticipants = COUNT(*)
    FROM extraStudySessionsParticipants esp
    WHERE esp.meetingID = @meetingID AND esp.studiesID = @studiesID AND esp.moduleID = @moduleID;

    SET @availableSeats = @roomCapacity - (@studentsFromModule + @extraParticipants);

    IF @availableSeats < 0
    BEGIN
        SET @availableSeats = 0;
    END

    RETURN @availableSeats;
END
go

grant execute on availableSeatsForStudiesSession to Participant
go

