create table students
(
    studentID int not null,
    constraint students_pk
        primary key (studentID),
    constraint students_users
        foreign key (studentID) references users
)
go

grant select on students to Lecturer
go

