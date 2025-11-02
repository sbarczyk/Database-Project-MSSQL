create function userCourseAttendancePercentage(@courseID int, @studentID int) returns decimal(5, 2) as
BEGIN
    DECLARE @totalModules INT;
    DECLARE @passedModules INT;
    DECLARE @attendancePercentage DECIMAL(5, 2);

    SELECT @totalModules = COUNT(*)
    FROM CourseModules
    WHERE courseID = @courseID;

    SELECT @passedModules = COUNT(*)
    FROM CourseModules cm
    JOIN courseModulesPassed cmp ON cm.moduleID = cmp.moduleID
    WHERE cm.courseID = @courseID
      AND cmp.studentID = @studentID;

    IF @totalModules > 0
    BEGIN
        SET @attendancePercentage = CAST(@passedModules AS DECIMAL(5, 2)) / @totalModules * 100;
    END
    ELSE
    BEGIN
        SET @attendancePercentage = 0;
    END

    RETURN @attendancePercentage;
END
go

grant execute on userCourseAttendancePercentage to Lecturer
go

grant execute on userCourseAttendancePercentage to Participant
go

