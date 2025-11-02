create function CourseFeeFullyPaid(@courseID int, @studentID int) returns bit as
BEGIN
    DECLARE @isFullyPaid BIT = 0;
    DECLARE @startDate DATE;

    SELECT @startDate = startDate
    FROM Courses
    WHERE courseID = @courseID;

    IF EXISTS (
        SELECT 1
        FROM Orders o
        JOIN OrderPayment op ON o.orderID = op.orderID
        JOIN OrderDetails od ON o.orderID = od.orderID
        JOIN Products p ON od.productID = p.productID
        WHERE o.studentID = @studentID
          AND p.productID = @courseID
          AND op.advance = 1
          AND op.PaymentStatus = 1
          AND op.paymentDate <= DATEADD(DAY, -3, @startDate)
    )
    BEGIN
        SET @isFullyPaid = 1;
    END

    RETURN @isFullyPaid;
END
go

