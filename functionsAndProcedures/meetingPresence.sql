create procedure meetingPresence(@studentID int, @meetingID int, @attendance bit) as
BEGIN
    SET NOCOUNT ON;

    
    IF NOT EXISTS (SELECT 1 FROM students WHERE studentID = @studentID)
    BEGIN
        RAISERROR ('Student o podanym ID nie istnieje.', 16, 1);
        RETURN;
    END;

    
    IF NOT EXISTS (SELECT 1 FROM meeting WHERE meetingID = @meetingID)
    BEGIN
        RAISERROR ('Spotkanie o podanym ID nie istnieje.', 16, 1);
        RETURN;
    END;

    
    IF EXISTS (SELECT 1 FROM meetingAttendance WHERE studentID = @studentID AND meetingID = @meetingID)
    BEGIN
        UPDATE meetingAttendance
        SET attendance = @attendance
        WHERE studentID = @studentID AND meetingID = @meetingID;

        PRINT 'Obecność została zaktualizowana.';
    END
    ELSE
    BEGIN
        INSERT INTO meetingAttendance (studentID, meetingID, attendance)
        VALUES (@studentID, @meetingID, @attendance);

        PRINT 'Obecność została zarejestrowana.';
    END
END
go

grant execute on meetingPresence to Lecturer
go

