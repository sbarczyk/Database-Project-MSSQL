create table WebinarAttendance
(
    studentID int not null,
    webinarID int not null,
    constraint WebinarAttendance_pk
        primary key (studentID, webinarID),
    constraint WebinarAttendance_Webinars
        foreign key (webinarID) references Webinars,
    constraint WebinarAttendance_students
        foreign key (studentID) references students
)
go

grant delete, insert, select, update on WebinarAttendance to Lecturer
go

grant select on WebinarAttendance to Participant
go

