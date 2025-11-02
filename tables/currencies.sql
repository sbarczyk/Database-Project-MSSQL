create table currencies
(
    currencyID   int identity,
    currencyName nvarchar(32) not null,
    currencyRate real         not null,
    constraint currencies_pk
        primary key (currencyID)
)
go

grant select on currencies to Participant
go

