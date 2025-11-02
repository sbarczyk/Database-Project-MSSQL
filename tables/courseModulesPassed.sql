create table courseModulesPassed
(
    moduleID  int not null,
    studentID int not null,
    constraint courseModulesPassed_pk
        primary key (moduleID, studentID),
    constraint courseModulesPassed_CourseModules
        foreign key (moduleID) references CourseModules,
    constraint courseModulesPassed_students
        foreign key (studentID) references students
)
go

grant delete, insert, select, update on courseModulesPassed to Lecturer
go

grant select on courseModulesPassed to Participant
go

