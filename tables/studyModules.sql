create table studyModules
(
    studiesID     int           not null,
    moduleID      int identity,
    moduleTitle   nvarchar(64)  not null,
    description   nvarchar(max) not null,
    coordinatorID int           not null,
    constraint studyModules_pk
        primary key (studiesID, moduleID),
    constraint studyModules_coordinators
        foreign key (coordinatorID) references coordinators,
    constraint study_modules_studies
        foreign key (studiesID) references studies
)
go

grant select on studyModules to Lecturer
go

grant select on studyModules to Participant
go

