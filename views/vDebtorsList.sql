create view vDebtorsList as
SELECT DISTINCT u.userID,
                    u.firstName,
                    u.lastName,
                    u.email,
                    o.orderID,
                    p.productID,
                    p.productName,
                    o.orderDate,
                    SUM(p.price) AS totalOrderAmount
    FROM users u
             INNER JOIN
         students s ON u.userID = s.studentID
             INNER JOIN
         orders o ON s.studentID = o.studentID
             INNER JOIN
         orderDetails od ON o.orderID = od.orderID
             INNER JOIN
         products p ON od.productID = p.productID
             LEFT JOIN
         OrderPayment op ON o.orderID = op.orderID
    WHERE op.paymentID IS NULL
       OR op.PaymentStatus = 0
    GROUP BY u.userID, u.firstName, u.lastName, u.email, o.orderID, p.productID, p.productName, o.orderDate
go

