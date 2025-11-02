create table studySessions
(
    meetingID int not null,
    productID int not null,
    studiesID int not null,
    moduleID  int not null,
    constraint studySessions_pk
        primary key (studiesID, meetingID, moduleID),
    constraint products_studySessions
        foreign key (productID) references products,
    constraint studySessions_meeting
        foreign key (meetingID) references meeting,
    constraint studySessions_studyModules
        foreign key (studiesID, moduleID) references studyModules
)
go

grant select on studySessions to Lecturer
go

grant select on studySessions to Participant
go

