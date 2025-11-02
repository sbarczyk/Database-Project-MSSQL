create view vFutureEventsRegistrations as
SELECT p.productID,
           p.productName,
           CASE
               WHEN c.courseID IS NOT NULL THEN 'Kurs'
               WHEN w.webinarID IS NOT NULL THEN 'Webinar'
               WHEN s.studiesID IS NOT NULL THEN 'Studium'
               ELSE 'Inny Produkt'
               END  AS ProductType,
           COUNT(DISTINCT CASE
                              WHEN c.courseID IS NOT NULL THEN ca.studentID
                              WHEN w.webinarID IS NOT NULL THEN wa.studentID
                              WHEN s.studiesID IS NOT NULL THEN sp.studentID
                              ELSE NULL
               END) AS TotalParticipants,
           CASE
               WHEN m.meetingID IS NOT NULL AND sm.room IS NOT NULL THEN 'Stacjonarnie'
               ELSE 'Zdalnie'
               END  AS DeliveryMode
    FROM products p
             LEFT JOIN
         Courses c ON p.productID = c.productID -- Powiązanie kursów z produktami
             LEFT JOIN
         Webinars w ON p.productID = w.productID -- Powiązanie webinarów z produktami
             LEFT JOIN
         studies s ON p.productID = s.entryFeeProductID -- Powiązanie wpisowego na studia z produktami
             LEFT JOIN
         studySessions ss ON s.studiesID = ss.studiesID -- Powiązanie studiów z sesjami
             LEFT JOIN
         extraStudySessionsParticipants essp
         ON ss.studiesID = essp.studiesID AND ss.meetingID = essp.meetingID -- Powiązanie dodatkowych uczestników z sesjami
             LEFT JOIN
         studiesParticipants sp
         ON s.studiesID = sp.studiesID -- Powiązanie uczestników bezpośrednio zapisanych na studia
             LEFT JOIN
         CourseAccess ca ON c.courseID = ca.courseID -- Powiązanie kursów z uczestnikami
             LEFT JOIN
         WebinarAccess wa ON w.webinarID = wa.webinarID -- Powiązanie webinarów z uczestnikami (WebinarAccess)
             LEFT JOIN
         meeting m ON ss.meetingID = m.meetingID -- Powiązanie sesji z tabelą spotkań
             LEFT JOIN
         StationaryMeeting sm ON m.meetingID = sm.meetingID -- Powiązanie spotkań z salami stacjonarnymi
    WHERE m.startDate > GETDATE() -- Filtr dla przyszłych wydarzeń
    GROUP BY p.productID,
             p.productName,
             CASE
                 WHEN c.courseID IS NOT NULL THEN 'Kurs'
                 WHEN w.webinarID IS NOT NULL THEN 'Webinar'
                 WHEN s.studiesID IS NOT NULL THEN 'Studium'
                 ELSE 'Inny Produkt'
                 END,
             CASE
                 WHEN m.meetingID IS NOT NULL AND sm.room IS NOT NULL THEN 'Stacjonarnie'
                 ELSE 'Zdalnie'
                 END
go

