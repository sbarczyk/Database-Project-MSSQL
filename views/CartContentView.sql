create view CartContentView as
SELECT
    c.cartID,
    c.studentID,
    u.firstName,
    u.lastName,
    p.productID,
    p.productName,
    p.price
FROM cart c
JOIN cartDetails cd ON cd.cartID = c.cartID
JOIN products p ON p.productID = cd.productID
JOIN users u ON u.userID = c.studentID
go

