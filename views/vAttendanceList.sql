create view vAttendanceList as
SELECT p.productID,
           p.productName,
           m.meetingID,
           m.startDate,
           m.endDate,
           u.firstName,
           u.lastName,
           CASE
               WHEN ma.attendance = 1 THEN 'Obecny'
               ELSE 'Nieobecny'
               END AS AttendanceStatus
    FROM products p
             LEFT JOIN
         Courses c ON p.productID = c.productID
             LEFT JOIN
         CourseAccess ca ON c.courseID = ca.courseID
             LEFT JOIN
         Webinars w ON p.productID = w.productID
             LEFT JOIN
         WebinarAccess wa ON w.webinarID = wa.webinarID
             LEFT JOIN
         studies s ON p.productID = s.entryFeeProductID
             LEFT JOIN
         studiesParticipants sp ON s.studiesID = sp.studiesID
             LEFT JOIN
         studySessions ss ON s.studiesID = ss.studiesID
             LEFT JOIN
         extraStudySessionsParticipants esp ON ss.studiesID = esp.studiesID AND ss.meetingID = esp.meetingID
             INNER JOIN -- Zmieniono z LEFT JOIN na INNER JOIN
        meeting m ON ss.meetingID = m.meetingID OR c.courseID = m.meetingID OR w.webinarID = m.meetingID
             LEFT JOIN
         meetingAttendance ma ON m.meetingID = ma.meetingID
             LEFT JOIN
         WebinarAttendance wa_att ON w.webinarID = wa_att.webinarID AND wa_att.studentID = wa.studentID
             LEFT JOIN
         students s_p ON (
             ma.studentID = s_p.studentID OR
             ca.studentID = s_p.studentID OR
             wa.studentID = s_p.studentID OR
             sp.studentID = s_p.studentID OR
             esp.studentID = s_p.studentID
             )
             LEFT JOIN
         users u ON s_p.studentID = u.userID
    WHERE m.endDate < GETDATE()
       OR w.webinarID IS NOT NULL
go

