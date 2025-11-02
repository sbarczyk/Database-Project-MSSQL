create view vFinancialReports as
SELECT p.productID,
           p.productName,
           CASE
               WHEN c.courseID IS NOT NULL THEN 'Kurs'
               WHEN w.webinarID IS NOT NULL THEN 'Webinar'
               WHEN s.studiesID IS NOT NULL THEN 'Studium'
               ELSE 'Inny Produkt'
               END  AS ProductType,
           SUM(CASE
                   WHEN op.PaymentStatus = 1 THEN p.price
                   ELSE 0
               END) AS TotalRevenue
    FROM products p
             LEFT JOIN
         Courses c ON p.productID = c.productID
             LEFT JOIN
         Webinars w ON p.productID = w.productID
             LEFT JOIN
         studies s ON p.productID = s.entryFeeProductID -- Powiązanie wpisowego
             LEFT JOIN
         studySessions ss ON p.productID = ss.productID -- Powiązanie z opłatami za zjazdy
             LEFT JOIN
         orderDetails od ON p.productID = od.productID -- Powiązanie produktu z zamówieniem
             LEFT JOIN
         orders o ON od.orderID = o.orderID -- Powiązanie szczegółów zamówienia z zamówieniem
             LEFT JOIN
         OrderPayment op ON o.orderID = op.orderID -- Powiązanie zamówienia z płatnościami
    GROUP BY p.productID,
             p.productName,
             CASE
                 WHEN c.courseID IS NOT NULL THEN 'Kurs'
                 WHEN w.webinarID IS NOT NULL THEN 'Webinar'
                 WHEN s.studiesID IS NOT NULL THEN 'Studium'
                 ELSE 'Inny Produkt'
                 END
go

