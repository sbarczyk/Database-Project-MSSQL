create table moduleMeetings
(
    moduleID  int not null,
    meetingID int not null,
    constraint moduleMeetings_pk
        primary key (meetingID),
    constraint meeting_moduleMeetings
        foreign key (meetingID) references meeting,
    constraint moduleMeetings_CourseModules
        foreign key (moduleID) references CourseModules
)
go

