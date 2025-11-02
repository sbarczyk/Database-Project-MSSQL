create view vCompletedEventAttendance as
WITH ProductMeetings AS (SELECT p.productID,
                                    p.productName,
                                    CASE
                                        WHEN c.courseID IS NOT NULL THEN 'Kurs'
                                        WHEN w.webinarID IS NOT NULL THEN 'Webinar'
                                        WHEN s.studiesID IS NOT NULL THEN 'Studium'
                                        ELSE 'Inny Produkt'
                                        END AS ProductType,
                                    m.meetingID,
                                    m.startDate,
                                    m.endDate
                             FROM products p
                                      LEFT JOIN
                                  Courses c ON p.productID = c.productID
                                      LEFT JOIN
                                  Webinars w ON p.productID = w.productID
                                      LEFT JOIN
                                  studies s ON p.productID = s.entryFeeProductID
                                      LEFT JOIN
                                  studySessions ss ON s.studiesID = ss.studiesID
                                      LEFT JOIN
                                  meeting m ON ss.meetingID = m.meetingID
                                      OR c.courseID = m.meetingID
                                      OR w.webinarID = m.meetingID
                             WHERE m.endDate < GETDATE()),
         TotalParticipants AS (SELECT pm.productID,
                                      pm.meetingID,
                                      COUNT(DISTINCT
                                            CASE
                                                WHEN pm.ProductType = 'Kurs' THEN ca.studentID
                                                WHEN pm.ProductType = 'Webinar' THEN wa.studentID
                                                WHEN pm.ProductType = 'Studium' THEN sp.studentID
                                                ELSE NULL
                                                END
                                      ) AS TotalParticipants
                               FROM ProductMeetings pm
                                        LEFT JOIN
                                    Courses c ON pm.productID = c.productID
                                        LEFT JOIN
                                    CourseAccess ca ON c.courseID = ca.courseID
                                        LEFT JOIN
                                    Webinars w ON pm.productID = w.productID
                                        LEFT JOIN
                                    WebinarAccess wa ON w.webinarID = wa.webinarID
                                        LEFT JOIN
                                    studies s ON pm.productID = s.entryFeeProductID
                                        LEFT JOIN
                                    studiesParticipants sp ON s.studiesID = sp.studiesID
                               GROUP BY pm.productID,
                                        pm.meetingID,
                                        pm.ProductType),
         TotalAttended AS (SELECT pm.productID,
                                  pm.meetingID,
                                  COUNT(DISTINCT
                                        CASE
                                            WHEN pm.ProductType = 'Kurs' AND ma.attendance = 1 THEN ma.studentID
                                            WHEN pm.ProductType = 'Webinar' AND wa_att.studentID IS NOT NULL
                                                THEN wa_att.studentID
                                            WHEN pm.ProductType = 'Studium' AND sp.studentID IS NOT NULL
                                                THEN sp.studentID
                                            ELSE NULL
                                            END
                                  ) AS TotalAttended
                           FROM ProductMeetings pm
                                    LEFT JOIN
                                Courses c ON pm.productID = c.productID
                                    LEFT JOIN
                                CourseAccess ca ON c.courseID = ca.courseID
                                    LEFT JOIN
                                Webinars w ON pm.productID = w.productID
                                    LEFT JOIN
                                WebinarAccess wa ON w.webinarID = wa.webinarID
                                    LEFT JOIN
                                WebinarAttendance wa_att ON w.webinarID = wa_att.webinarID
                                    LEFT JOIN
                                studies s ON pm.productID = s.entryFeeProductID
                                    LEFT JOIN
                                studiesParticipants sp ON s.studiesID = sp.studiesID
                                    LEFT JOIN
                                meetingAttendance ma ON pm.meetingID = ma.meetingID
                           GROUP BY pm.productID,
                                    pm.meetingID,
                                    pm.ProductType)
    SELECT pm.productID,
           pm.productName,
           pm.ProductType,
           pm.meetingID,
           pm.startDate,
           pm.endDate,
           ISNULL(tp.TotalParticipants, 0) AS TotalParticipants,
           ISNULL(ta.TotalAttended, 0)     AS TotalAttended
    FROM ProductMeetings pm
             LEFT JOIN
         TotalParticipants tp ON pm.productID = tp.productID AND pm.meetingID = tp.meetingID
             LEFT JOIN
         TotalAttended ta ON pm.productID = ta.productID AND pm.meetingID = ta.meetingID
    WHERE ISNULL(ta.TotalAttended, 0) <= ISNULL(tp.TotalParticipants, 0)
go

