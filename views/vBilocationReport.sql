create view vBilocationReport as
WITH AllEvents AS (
    SELECT
        ma.studentID,
        'Meeting' AS EventType,
        m.meetingID AS EventID,
        m.startDate,
        m.endDate
    FROM meeting m
    JOIN meetingAttendance ma 
        ON m.meetingID = ma.meetingID
    WHERE m.endDate > GETDATE()
 
    UNION ALL

    SELECT
        wa.studentID,
        'Webinar' AS EventType,
        w.webinarID AS EventID,
        w.startDate,
        w.endDate
    FROM Webinars w
    JOIN WebinarAttendance wa 
        ON w.webinarID = wa.webinarID
    WHERE w.endDate > GETDATE()
)
SELECT 
    u.userID AS StudentID,
    u.firstName,
    u.lastName,
    e1.EventType AS EventType1,
    e1.EventID   AS EventID1,
    e1.startDate AS StartDate1,
    e1.endDate   AS EndDate1,
    e2.EventType AS EventType2,
    e2.EventID   AS EventID2,
    e2.startDate AS StartDate2,
    e2.endDate   AS EndDate2
FROM AllEvents e1
JOIN AllEvents e2
    ON e1.studentID = e2.studentID

    AND (
         e1.EventType <> e2.EventType
         OR e1.EventID < e2.EventID
        )

    AND e1.startDate < e2.endDate
    AND e1.endDate > e2.startDate
JOIN users u
    ON u.userID = e1.studentID
go

