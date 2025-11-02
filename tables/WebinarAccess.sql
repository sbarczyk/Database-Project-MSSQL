create table WebinarAccess
(
    accessID        int identity,
    studentID       int      not null,
    webinarID       int      not null,
    accessStartDate datetime not null,
    accessEndDate   datetime not null,
    constraint WebinarAccess_pk
        primary key (accessID),
    constraint WebinarAccess_students
        foreign key (studentID) references students,
    constraint WebinarDetails_Webinars
        foreign key (webinarID) references Webinars,
    constraint webinarAccessDateCheck
        check ([accessEndDate] > [accessStartDate])
)
go

