create function isStudentPresent(@student_id int, @meeting_id int) returns bit as
BEGIN
    DECLARE @isPresent BIT = 0;

    -- Sprawdź, czy student jest obecny na spotkaniu
    IF EXISTS (
        SELECT 1
        FROM meetingAttendance ma
        WHERE ma.studentID = @student_id
          AND ma.meetingID = @meeting_id
          AND ma.attendance = 1
    )
    BEGIN
        SET @isPresent = 1;
    END
    ELSE
    BEGIN
        -- Sprawdź, czy spotkanie jest asynchroniczne i czy moduł został zaliczony
        IF EXISTS (
            SELECT 1
            FROM moduleMeetings mm
            JOIN courseModulesPassed cmp ON mm.moduleID = cmp.moduleID
            WHERE mm.meetingID = @meeting_id
              AND cmp.studentID = @student_id
        )
        BEGIN
            SET @isPresent = 1;
        END
    END

    RETURN @isPresent;
END
go

