create function GetCourseSchedule(@CourseID int) returns table as
SELECT
        m.meetingID,
        m.startDate,
        m.endDate
    FROM CourseModules cm
    JOIN moduleMeetings mm ON cm.moduleID = mm.moduleID
    JOIN meeting m ON mm.meetingID = m.meetingID
    WHERE cm.courseID = @CourseID
go

