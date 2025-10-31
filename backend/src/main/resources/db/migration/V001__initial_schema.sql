create table patienten
(
    id           uuid              not null primary key,
    titel        varchar,
    vorname      varchar           not null,
    nachname     varchar           not null,
    strasse      varchar,
    hausnummer   varchar,
    plz          varchar,
    stadt        varchar,
    tel_mobil    varchar,
    tel_festnetz varchar,
    email        varchar,
    geburtstag   date,
    version      integer default 0 not null
);

create table aerzte
(
    id      uuid              not null primary key,
    name    varchar           not null unique,
    version integer default 0 not null
);


create table rezepte
(
    id                      uuid                       not null primary key,
    patient_id              uuid                       not null references patienten,
    ausgestellt_am          date                       not null,
    ausgestellt_von_arzt_id uuid references aerzte,
    preis_gesamt            double precision default 0 not null,
    rechnungsnummer         varchar,
    version                 integer          default 0 not null
);


create table behandlungsarten
(
    id      uuid              not null primary key,
    name    varchar           not null,
    preis   double precision  not null,
    version integer default 0 not null
);


create table rezept_pos
(
    id                  uuid             not null primary key,
    rezept_id           uuid             not null references rezepte,
    index               integer          not null,
    anzahl              integer          not null,
    einzelpreis         double precision not null,
    preis_gesamt        double precision not null,
    behandlungsart_name varchar          not null,
    behandlungsart_id   uuid             not null references behandlungsarten
);

create table profiles
(
    id                  uuid              not null primary key,
    praxis_name         varchar           not null,
    inhaber_name        varchar           not null,
    profile_picture_url varchar,
    version             integer default 0 not null,
    access_token        uuid              not null
);

create table behandlungen
(
    id         uuid              not null primary key,
    patient_id uuid              not null references patienten,
    rezept_id  uuid references rezepte,
    start_zeit timestamp         not null,
    end_zeit   timestamp         not null,
    version    integer default 0 not null
);