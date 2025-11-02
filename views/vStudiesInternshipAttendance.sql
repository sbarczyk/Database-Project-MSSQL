create view vStudiesInternshipAttendance as
SELECT
    i.internshipID,
    i.studiesID,
    s.studiesName,
    im.studentID,
    u.firstName,
    u.lastName,
    (DATEDIFF(DAY, i.startDate, i.endDate) + 1) AS RequiredDays, 
    COUNT(CASE WHEN im.attendance=1 THEN 1 END) AS AttendedDays,
    CASE 
       WHEN COUNT(CASE WHEN im.attendance=1 THEN 1 END) =
            (DATEDIFF(DAY, i.startDate, i.endDate) + 1)
       THEN 1
       ELSE 0
    END AS IsFullAttendance
FROM internship i
JOIN studies s ON s.studiesID = i.studiesID
JOIN internshipMeeting im ON im.internshipID = i.internshipID
JOIN users u ON u.userID = im.studentID
GROUP BY 
    i.internshipID, 
    i.studiesID,
    s.studiesName,
    im.studentID,
    u.firstName, 
    u.lastName,
    i.startDate,
    i.endDate
go

