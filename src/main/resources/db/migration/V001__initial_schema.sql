create table patienten
(
    id           uuid    not null primary key,
    titel        varchar,
    vorname      varchar not null,
    nachname     varchar not null,
    strasse      varchar,
    hausnummer   varchar,
    plz          varchar,
    stadt        varchar,
    tel_mobil    varchar,
    tel_festnetz varchar,
    email        varchar,
    geburtstag   date,
    version      int     not null default 0
);

create table aerzte
(
    id      uuid    not null primary key,
    name    varchar not null unique,
    version int     not null default 0
);

create table rezepte
(
    id                      uuid             not null primary key,
    patient_id              uuid             not null references patienten (id),
    ausgestellt_am          date             not null,
    ausgestellt_von_arzt_id uuid references aerzte (id),
    preis_gesamt            double precision not null default 0,
    rechnungsnummer         varchar,
    version                 int              not null default 0
);

create table behandlungsarten
(
    id      uuid             not null primary key,
    name    varchar          not null,
    preis   double precision not null,
    version int              not null default 0
);

create table rezept_pos
(
    id                  uuid             not null primary key,
    rezept_id           uuid             not null references rezepte (id),
    index               int              not null,
    anzahl              int              not null,
    einzelpreis         double precision not null,
    preis_gesamt        double precision not null,
    behandlungsart_name varchar          not null,
    behandlungsart_id   uuid             not null references behandlungsarten (id)
);