create table profiles
(
    id                  uuid    not null primary key,
    praxis_name         varchar not null,
    inhaber_name        varchar not null,
    profile_picture_url varchar,
    version             int     not null default 0
);