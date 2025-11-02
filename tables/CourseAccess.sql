create table CourseAccess
(
    courseID        int      not null,
    studentID       int      not null,
    accessStartDate datetime not null,
    accessEndDate   datetime not null,
    constraint CourseAccess_pk
        primary key (courseID, studentID),
    constraint CourseAccess_students
        foreign key (studentID) references students,
    constraint CourseDetails_Courses
        foreign key (courseID) references Courses,
    constraint accessDateCheck
        check ([accessEndDate] > [accessStartDate])
)
go

