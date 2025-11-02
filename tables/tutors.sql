create table tutors
(
    tutorID int not null,
    constraint tutors_pk
        primary key (tutorID),
    constraint tutors_users
        foreign key (tutorID) references users
)
go

