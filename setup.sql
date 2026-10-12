create table address (
    address_id integer primary key,
    city varchar(35) not null,
    state char(2) not null,
    street varchar(50) not null,
    zip varchar(10) not null
);

create table school (
    school_id integer primary key,
    name varchar(50) not null,
    division varchar(20) not null,
    address_id integer not null,
    foreign key (address_id) references address (address_id)
);

create table team (
    team_id integer primary key,
    team_name varchar(50) not null,
    school_id integer not null,
    foreign key (school_id) references school (school_id)
);

create table player (
    player_id integer primary key,
    first_name varchar(35) not null,
    middle_name varchar(35),
    last_name varchar(35) not null,
    graduation_date date not null
);

create table course (
    course_id integer primary key,
    name varchar(50) not null,
    par integer not null,
    yardage integer not null,
    address_id integer not null,
    course_rating decimal(4, 1) not null,
    slope_rating integer not null,
    foreign key (address_id) references address (address_id)
);

create table tournament (
    tournament_id integer primary key,
    name varchar(50) not null,
    date date not null,
    course_id integer not null,
    foreign key (course_id) references course (course_id)
);

create table team_tournament (
    team_id integer not null,
    tournament_id integer not null,
    primary key (team_id, tournament_id),
    foreign key (team_id) references team (team_id),
    foreign key (tournament_id) references tournament (tournament_id)
);

create table player_tournament (
    player_id integer not null,
    tournament_id integer not null,
    front_nine_score integer check (front_nine_score > 0),
    back_nine_score integer check (back_nine_score > 0),
    team_id integer not null,
    primary key (player_id, tournament_id),
    foreign key (player_id) references player (player_id),
    -- composite FK: a player can only be listed under a team entered in that tournament
    foreign key (team_id, tournament_id) references team_tournament (team_id, tournament_id)
);

-- indexes for foreign keys and common lookups
create index idx_school_address on school (address_id);
create index idx_team_school on team (school_id);
create index idx_course_address on course (address_id);
create index idx_tournament_course on tournament (course_id);
create index idx_team_tournament_tournament on team_tournament (tournament_id);
create index idx_player_tournament_tournament on player_tournament (tournament_id);
create index idx_player_tournament_team on player_tournament (team_id, tournament_id);