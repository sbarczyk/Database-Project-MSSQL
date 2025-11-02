create function userHasAccessToWebinar(@studentID int, @webinarID int) returns bit as
BEGIN
    DECLARE @isPaid BIT;
    DECLARE @hasAccess BIT;
    DECLARE @currentDate DATETIME = GETDATE();

    SELECT @isPaid = CASE
                        WHEN p.price > 0 THEN 1
                        ELSE 0
                     END
    FROM Webinars w
    JOIN products p ON w.productID = p.productID
    WHERE w.webinarID = @webinarID;

    IF @isPaid = 0
    BEGIN
        IF EXISTS (
            SELECT 1
            FROM students
            WHERE studentID = @studentID
        )
        BEGIN
            SET @hasAccess = 1;
        END
        ELSE
        BEGIN
            SET @hasAccess = 0;
        END
    END
    ELSE
    BEGIN
        IF EXISTS (
            SELECT 1
            FROM WebinarAccess wa
            WHERE wa.studentID = @studentID
              AND wa.webinarID = @webinarID
              AND wa.AccessEndDate >= @currentDate
        )
        BEGIN
            SET @hasAccess = 1;
        END
        ELSE
        BEGIN
            SET @hasAccess = 0;
        END
    END

    RETURN @hasAccess;
END
go

