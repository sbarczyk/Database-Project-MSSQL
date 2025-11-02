create table OnlineSyncMeeting
(
    meetingID int           not null,
    link      nvarchar(128) not null,
    constraint OnlineSyncMeeting_pk
        primary key (meetingID),
    constraint OnlineSyncMeeting_meeting
        foreign key (meetingID) references meeting
)
go

