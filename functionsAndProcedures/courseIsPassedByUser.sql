create function courseIsPassedByUser(@courseID int, @studentID int) returns bit as
BEGIN
    DECLARE @attendancePercentage DECIMAL(5, 2);
    DECLARE @isPassed BIT;


    SELECT @attendancePercentage = dbo.UserCourseAttendancePercentage(@courseID, @studentID);

    IF @attendancePercentage >= 80
    BEGIN
        SET @isPassed = 1;
    END
    ELSE
    BEGIN
        SET @isPassed = 0;
    END

    RETURN @isPassed;
END
go

