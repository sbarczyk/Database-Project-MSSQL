create function studyAttendancePercentage(@studiesID int, @studentID int) returns decimal(5, 2) as
BEGIN
    DECLARE @totalMeetings INT;
    DECLARE @attendedMeetings INT;
    DECLARE @attendancePercentage DECIMAL(5, 2) = 0;

    SELECT @totalMeetings = COUNT(DISTINCT m.meetingID)
    FROM studyModuleParticipants smp
    JOIN studyModules sm ON smp.studiesID = sm.studiesID AND smp.moduleID = sm.moduleID
    JOIN studySessions ss ON sm.studiesID = ss.studiesID AND sm.moduleID = ss.moduleID
    JOIN meeting m ON ss.meetingID = m.meetingID
    WHERE smp.studiesID = @studiesID AND smp.studentID = @studentID;

    SELECT @attendedMeetings = COUNT(DISTINCT ma.meetingID)
    FROM studyModuleParticipants smp
    JOIN studyModules sm ON smp.studiesID = sm.studiesID AND smp.moduleID = sm.moduleID
    JOIN studySessions ss ON sm.studiesID = ss.studiesID AND sm.moduleID = ss.moduleID
    JOIN meeting m ON ss.meetingID = m.meetingID
    JOIN meetingAttendance ma ON m.meetingID = ma.meetingID
    WHERE smp.studiesID = @studiesID
      AND smp.studentID = @studentID
      AND ma.studentID = @studentID
      AND ma.attendance = 1;

    IF @totalMeetings > 0
    BEGIN
        SET @attendancePercentage = CAST(@attendedMeetings AS DECIMAL(5, 2)) / @totalMeetings * 100;
    END

    RETURN @attendancePercentage;
END
go

grant execute on studyAttendancePercentage to Lecturer
go

