create function GetStudySchedule(@StudiesID int) returns table as
SELECT
        m.meetingID,
        m.startDate,
        m.endDate
    FROM studyModules sm
    JOIN studySessions ss ON sm.studiesID = ss.studiesID AND sm.moduleID = ss.moduleID
    JOIN meeting m ON ss.meetingID = m.meetingID
    WHERE sm.studiesID = @StudiesID
go

