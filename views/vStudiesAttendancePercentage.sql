create view vStudiesAttendancePercentage as
SELECT
    sp.studiesID,
    st.studiesName,
    sp.studentID,
    u.firstName,
    u.lastName,
    COUNT(DISTINCT ss.meetingID) AS TotalMeetings, 
    SUM(CASE WHEN ma.attendance = 1 THEN 1 ELSE 0 END) AS AttendedMeetings,
    CASE 
       WHEN COUNT(DISTINCT ss.meetingID)=0 THEN 0
       ELSE 100.0 * SUM(CASE WHEN ma.attendance = 1 THEN 1 ELSE 0 END)
                / COUNT(DISTINCT ss.meetingID)
    END AS AttendancePercent
FROM studiesParticipants sp
JOIN studies st 
    ON st.studiesID = sp.studiesID
JOIN users u 
    ON u.userID = sp.studentID
LEFT JOIN studySessions ss 
    ON ss.studiesID = sp.studiesID
LEFT JOIN meetingAttendance ma 
    ON ma.meetingID = ss.meetingID
    AND ma.studentID = sp.studentID
GROUP BY 
    sp.studiesID,
    st.studiesName,
    sp.studentID,
    u.firstName,
    u.lastName
go

