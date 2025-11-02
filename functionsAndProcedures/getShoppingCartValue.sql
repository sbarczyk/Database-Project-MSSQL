create function getShoppingCartValue(@student_id int) returns money as
BEGIN
    DECLARE @totalValue MONEY = 0;

    SELECT @totalValue = SUM(p.price)
    FROM cart c
    JOIN cartDetails cd ON c.cartID = cd.cartID
    JOIN products p ON cd.productID = p.productID
    WHERE c.studentID = @student_id;

    RETURN ISNULL(@totalValue, 0);
END
go

grant execute on getShoppingCartValue to Participant
go

