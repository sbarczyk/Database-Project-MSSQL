create function meetingAttendanceReport(@meetingID int) returns table as
SELECT
        ma.studentID,
        u.firstName,
        u.lastName,
        ma.attendance
    FROM meetingAttendance ma
    JOIN students s ON ma.studentID = s.studentID
    JOIN users u ON s.studentID = u.userID
    WHERE ma.meetingID = @meetingID
go

