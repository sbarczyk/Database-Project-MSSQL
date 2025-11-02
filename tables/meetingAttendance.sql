create table meetingAttendance
(
    studentID  int           not null,
    meetingID  int           not null,
    attendance bit default 0 not null,
    constraint meetingAttendance_pk
        primary key (studentID, meetingID),
    constraint meetingPresence_meeting
        foreign key (meetingID) references meeting,
    constraint pressence_students
        foreign key (studentID) references students,
)
go

grant delete, insert, select, update on meetingAttendance to Lecturer
go

grant select on meetingAttendance to Participant
go

