create view RenevueByMonthView as
SELECT
    YEAR(op.paymentDate) AS PaymentYear,
    MONTH(op.paymentDate) AS PaymentMonth,
    SUM(p.price) AS MonthlyRevenue
FROM OrderPayment op
JOIN orders o 
    ON o.orderID = op.orderID
JOIN orderDetails od
    ON od.orderID = o.orderID
JOIN products p
    ON p.productID = od.productID
WHERE op.PaymentStatus = 1
GROUP BY 
    YEAR(op.paymentDate),
    MONTH(op.paymentDate)
go

