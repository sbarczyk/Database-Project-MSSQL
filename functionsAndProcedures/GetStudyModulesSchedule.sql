create function GetStudyModulesSchedule(@StudiesID int, @ModuleID int) returns table as
SELECT
        m.meetingID,
        m.startDate,
        m.endDate,
        u.firstName AS tutorFirstName,
        u.lastName AS tutorLastName
    FROM studySessions ss
    JOIN meeting m ON ss.meetingID = m.meetingID
    JOIN tutors t ON m.tutorID = t.tutorID
    JOIN users u ON t.tutorID = u.userID
    WHERE ss.studiesID = @StudiesID AND ss.moduleID = @ModuleID
go

