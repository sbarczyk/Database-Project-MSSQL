create table onlineAsyncMeeting
(
    meetingID    int           not null,
    recordingURL nvarchar(128) not null,
    constraint onlineAsyncMeeting_pk
        primary key (meetingID),
    constraint onlineAsyncMeeting_meeting
        foreign key (meetingID) references meeting
)
go

