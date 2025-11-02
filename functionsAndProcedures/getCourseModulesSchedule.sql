create function getCourseModulesSchedule(@CourseID int, @ModuleID int) returns table as
SELECT
        m.meetingID,
        m.startDate,
        m.endDate,
        u.firstName AS tutorFirstName,
        u.lastName AS tutorLastName
    FROM CourseModules cm
    JOIN moduleMeetings mm ON cm.moduleID = mm.moduleID
    JOIN meeting m ON mm.meetingID = m.meetingID
    JOIN tutors t ON m.tutorID = t.tutorID
    JOIN users u ON t.tutorID = u.userID
    WHERE cm.courseID = @CourseID AND cm.moduleID = @ModuleID
go

