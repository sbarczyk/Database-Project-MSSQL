create table extraStudySessionsParticipants
(
    studiesID int not null,
    meetingID int not null,
    moduleID  int not null,
    studentID int not null,
    constraint PK_extraStudySessionsParticipants
        primary key (meetingID, studiesID, moduleID, studentID),
    constraint extraStudySessionsParticipants_studySessions
        foreign key (studiesID, meetingID, moduleID) references studySessions
)
go

grant delete, insert, select, update on extraStudySessionsParticipants to Lecturer
go

