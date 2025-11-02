create table studies
(
    studiesID         int identity,
    placeLimit        int          not null,
    studiesName       nvarchar(64) not null,
    entryFeeProductID int          not null,
    constraint studies_pk
        primary key (studiesID),
    constraint fk_studies_entryFeeProduct
        foreign key (entryFeeProductID) references products,
    check ([placeLimit] > 0),
    constraint chk_entryFeeProductID
        check ([entryFeeProductID] >= 0)
)
go

grant select on studies to Lecturer
go

grant select on studies to Participant
go

