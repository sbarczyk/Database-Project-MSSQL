create table studyModuleParticipants
(
    studentID int not null,
    studiesID int not null,
    moduleID  int not null,
    constraint studyModuleParticipants_pk
        primary key (studentID, studiesID, moduleID),
    constraint studyModuleParticipants_students
        foreign key (studentID) references students,
    constraint studyModuleParticipants_studyModules
        foreign key (studiesID, moduleID) references studyModules
)
go

grant select on studyModuleParticipants to Lecturer
go

