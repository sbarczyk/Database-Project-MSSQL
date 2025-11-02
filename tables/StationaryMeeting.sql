create table StationaryMeeting
(
    meetingID int not null,
    room      int not null,
    constraint StationaryMeeting_pk
        primary key (meetingID),
    constraint StationaryMeeting_meeting
        foreign key (meetingID) references meeting,
    constraint StationaryModule_Rooms
        foreign key (room) references Rooms
)
go

grant delete, insert, select, update on StationaryMeeting to Lecturer
go

grant select on StationaryMeeting to Participant
go

