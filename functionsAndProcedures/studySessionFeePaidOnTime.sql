create function studySessionFeePaidOnTime(@meetingID int, @studentID int, @moduleID int, @studyID int) returns bit as
BEGIN
    DECLARE @isPaidOnTime BIT = 0;

    -- Sprawdź, czy płatność została dokonana na czas
    IF EXISTS (
        SELECT 1
        FROM studySessions ss
        JOIN products p ON ss.productID = p.productID
        JOIN orderDetails od ON p.productID = od.productID
        JOIN orders o ON od.orderID = o.orderID
        JOIN OrderPayment op ON o.orderID = op.orderID
        JOIN meeting m ON ss.meetingID = m.meetingID
        WHERE ss.meetingID = @meetingID
          AND ss.studiesID = @studyID
          AND ss.moduleID = @moduleID
          AND o.studentID = @studentID
          AND op.PaymentStatus = 1
          AND op.paymentDate <= DATEADD(DAY, -3, m.startDate)
    )
    BEGIN
        SET @isPaidOnTime = 1;
    END

    RETURN @isPaidOnTime;
END
go

