create function studySessionsFeePaid(@studiesID int, @meetingID int, @moduleID int, @studentID int) returns bit as
BEGIN
    DECLARE @isPaid BIT = 0;

    IF EXISTS (
        SELECT 1
        FROM studySessions ss
        JOIN products p ON ss.productID = p.productID
        JOIN orderDetails od ON p.productID = od.productID
        JOIN orders o ON od.orderID = o.orderID
        JOIN OrderPayment op ON o.orderID = op.orderID
        WHERE ss.meetingID = @meetingID
          AND ss.studiesID = @studiesID
          AND ss.moduleID = @moduleID
          AND o.studentID = @studentID
          AND op.PaymentStatus = 1
    )
    BEGIN
        SET @isPaid = 1;
    END

    RETURN @isPaid;
END
go

