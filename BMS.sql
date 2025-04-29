drop table bookings;
drop table maintainance;
drop table buggy;
drop table drivers;
drop table users;
drop table routes;


create table users (
    user_id numeric(10) primary key,
    name varchar(100) not null,
    email_id varchar(200) unique not null,
    password varchar(200) not null,
    role varchar(10) not null check (role in ('admin', 'user')),
    contact_num varchar(10) unique not null
);

create table drivers (
    driver_id numeric(10) primary key,
    name varchar(100) not null,
    email_id varchar(200) unique not null,
    password varchar(200) not null,
    contact_num varchar(10) unique not null
);

create table buggy (
    buggy_id numeric(10) primary key,
    model varchar(100) not null,
    capacity numeric(3) not null check (capacity > 0),
    status varchar(20) not null check (status in ('available', 'unavailable')),
    location varchar(200) not null,
    driver_id numeric(10) unique,
    foreign key (driver_id) references drivers on delete set null
);

create table routes (
    pickup_point varchar(200),
    drop_point varchar(200),
    primary key (pickup_point, drop_point)
);

create table bookings (
    booking_id numeric(10),
    user_id numeric(10),
    driver_id numeric(10),
    buggy_id numeric(10),
    booking_time timestamp default current_timestamp,
    status varchar(20) not null check (status in ('confirmed', 'cancelled', 'completed','reserved')),
    pickup_point varchar(200) not null,
    drop_point varchar(200) not null,
    invoice_id numeric(10) unique,
    invoice_date date,
    fare numeric(8,2) check (fare >= 0),
    primary key (booking_id, user_id, driver_id, buggy_id),
    foreign key (user_id) references users on delete cascade,
    foreign key (driver_id) references drivers on delete cascade,
    foreign key (buggy_id) references buggy on delete cascade,
    foreign key (pickup_point, drop_point) references routes on delete cascade
);

create table maintainance (
    maintainance_date date,
    buggy_id numeric(10),
    status varchar(10) not null check (status in ('pending', 'completed')),
    primary key (maintainance_date, buggy_id),
    foreign key (buggy_id) references buggy on delete cascade
);

