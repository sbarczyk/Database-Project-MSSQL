create function studentHasCompletedInternship(@studiesID int, @studentID int, @internshipID int) returns bit as
BEGIN
    DECLARE @attendanceCount INT;
    DECLARE @hasCompleted BIT = 0;

    SELECT @attendanceCount = COUNT(*)
    FROM internshipMeeting im
    JOIN internship i ON im.internshipID = i.internshipID
    WHERE i.studiesID = @studiesID
      AND im.internshipID = @internshipID
      AND im.studentID = @studentID
      AND im.attendance = 1;

    IF @attendanceCount >= 14
    BEGIN
        SET @hasCompleted = 1;
    END

    RETURN @hasCompleted;
END
go

