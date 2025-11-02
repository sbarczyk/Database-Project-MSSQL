create procedure meetingGet(@studentID int) as
BEGIN
    SET NOCOUNT ON;

    -- Sprawdzenie, czy student o podanym ID istnieje
    IF NOT EXISTS (SELECT 1 FROM students WHERE studentID = @studentID)
    BEGIN
        RAISERROR ('Student o podanym ID nie istnieje.', 16, 1);
        RETURN;
    END;

    -- Pobranie wszystkich spotkań, w których uczestniczył student
    SELECT meetingID, attendance
    FROM meetingAttendance
    WHERE studentID = @studentID

END
go

