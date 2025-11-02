create view WebinarRecordingsView as
SELECT
    w.webinarID,
    w.Title,
    w.recordingURL,
    wa.studentID,
    u.firstName,
    u.lastName,
    wa.accessStartDate,
    wa.accessEndDate
FROM Webinars w
JOIN WebinarAccess wa 
    ON w.webinarID = wa.webinarID
JOIN users u
    ON u.userID = wa.studentID
go

