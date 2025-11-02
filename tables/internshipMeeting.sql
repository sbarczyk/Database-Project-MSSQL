create table internshipMeeting
(
    internshipMeetingID int identity,
    internshipID        int not null,
    studentID           int not null,
    attendance          bit not null,
    constraint internshipMeeting_pk
        primary key (internshipID, studentID, internshipMeetingID),
    constraint internshipDetails_internship
        foreign key (internshipID) references internship,
    constraint internshipDetails_students
        foreign key (studentID) references students
)
go

grant select on internshipMeeting to Lecturer
go

