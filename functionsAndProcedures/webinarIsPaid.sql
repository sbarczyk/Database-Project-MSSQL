create function webinarIsPaid(@webinarID int) returns bit as
BEGIN
    DECLARE @isPaid BIT;

    SELECT @isPaid = CASE
                        WHEN p.price > 0 THEN 1
                        ELSE 0
                     END
    FROM Webinars w
    JOIN products p ON w.productID = p.productID
    WHERE w.webinarID = @webinarID;

    RETURN @isPaid;
END
go

