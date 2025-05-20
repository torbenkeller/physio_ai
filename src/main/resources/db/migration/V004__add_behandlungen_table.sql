create table behandlungen
(
    id         uuid      not null primary key,
    rezept_id  uuid      not null references rezepte (id),
    index      int       not null,
    start_zeit timestamp not null,
    end_zeit   timestamp not null,
    version    int       not null default 0
);