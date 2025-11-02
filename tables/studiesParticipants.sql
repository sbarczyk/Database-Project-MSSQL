create table studiesParticipants
(
    studiesID int not null,
    studentID int not null,
    constraint studiesParticipants_pk
        primary key (studiesID, studentID),
    constraint studiesDetails_students
        foreign key (studentID) references students,
    constraint studiesDetails_studies
        foreign key (studiesID) references studies
)
go

grant select on studiesParticipants to Lecturer
go

