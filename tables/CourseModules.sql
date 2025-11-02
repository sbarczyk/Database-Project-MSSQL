create table CourseModules
(
    moduleID    int          not null,
    courseID    int          not null,
    tutorID     int          not null,
    moduleTitle nvarchar(64) not null,
    moduleDate  datetime     not null,
    languageID  int          not null,
    constraint CourseModules_pk
        primary key (moduleID),
    constraint CourseModules_Courses
        foreign key (courseID) references Courses,
    constraint CourseModules_languages
        foreign key (languageID) references languages,
    constraint CourseModules_tutors
        foreign key (tutorID) references tutors
)
go

grant select on CourseModules to Lecturer
go

grant select on CourseModules to Participant
go

