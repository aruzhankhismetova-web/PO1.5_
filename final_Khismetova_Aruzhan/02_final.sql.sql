--Part 2: DB+CREATE+Constrains

create schema if not exists hotel;

create table if not exists hotel.city (
    city_id   serial       primary key,
    name      varchar(100) not null,
    country   varchar(100) not null
);

create table if not exists hotel.hotel_branch (
    hotel_branch_id serial       primary key,
    title           varchar(150) not null,
    city_id         int          not null references hotel.city(city_id) on delete restrict,
    address         varchar(255) not null,
    phone           varchar(20)  not null,
    check           (phone like '+%')
);

create table if not exists hotel.room_type (
    room_type_id serial         primary key,
    type_name    varchar(50)    not null unique,
    description  varchar(255),
    base_price   numeric(10,2)  not null,
    check (base_price >= 0)
);
create table if not exists hotel.room (
    room_id         serial      primary key,
    room_number     varchar(10) not null,
    floor           int         not null check (floor >= 0),
    room_type_id    int         not null references hotel.room_type(room_type_id) on delete restrict,
    hotel_branch_id int         not null references hotel.hotel_branch(hotel_branch_id) on delete cascade,
    is_available    boolean     not null default true,
    unique (room_number, hotel_branch_id)
);

create table if not exists hotel.guest (
    guest_id        serial       primary key,
    first_name      varchar(80)  not null,
    last_name       varchar(80)  not null,
    email           varchar(150) not null unique,
    phone           varchar(20),
    passport_number varchar(20)  not null unique,
    gender          varchar(10)  not null check (gender in ('M', 'F', 'Other'))
);

create table if not exists hotel.service (
    service_id   serial         primary key,
    service_name varchar(100)   not null unique,
    price        numeric(10,2)  not null check (price >= 0),
    description  varchar(255)
);

create table if not exists hotel.employee (
    employee_id     serial      primary key,
    first_name      varchar(80) not null,
    last_name       varchar(80) not null,
    position        varchar(80) not null,
    hotel_branch_id int         not null references hotel.hotel_branch(hotel_branch_id) on delete cascade,
    phone           varchar(20)
);
create table if not exists hotel.room (
    room_id         serial      primary key,
    room_number     varchar(10) not null,
    floor           int         not null check (floor >= 0),
    room_type_id    int         not null references hotel.room_type(room_type_id) on delete restrict,
    hotel_branch_id int         not null references hotel.hotel_branch(hotel_branch_id) on delete cascade,
    is_available    boolean     not null default true,
    unique (room_number, hotel_branch_id)
);

create table if not exists hotel.guest (
    guest_id        serial       primary key,
    first_name      varchar(80)  not null,
    last_name       varchar(80)  not null,
    email           varchar(150) not null unique,
    phone           varchar(20),
    passport_number varchar(20)  not null unique,
    gender          varchar(10)  not null check (gender in ('M', 'F', 'Other'))
);

create table if not exists hotel.service (
    service_id   serial         primary key,
    service_name varchar(100)   not null unique,
    price        numeric(10,2)  not null check (price >= 0),
    description  varchar(255)
);

create table if not exists hotel.employee (
    employee_id     serial      primary key,
    first_name      varchar(80) not null,
    last_name       varchar(80) not null,
    position        varchar(80) not null,
    hotel_branch_id int         not null references hotel.hotel_branch(hotel_branch_id) on delete cascade,
    phone           varchar(20)
);
create table if not exists hotel.room (
    room_id         serial      primary key,
    room_number     varchar(10) not null,
    floor           int         not null check (floor >= 0),
    room_type_id    int         not null references hotel.room_type(room_type_id) on delete restrict,
    hotel_branch_id int         not null references hotel.hotel_branch(hotel_branch_id) on delete cascade,
    is_available    boolean     not null default true,
    unique (room_number, hotel_branch_id)
);

create table if not exists hotel.guest (
    guest_id        serial       primary key,
    first_name      varchar(80)  not null,
    last_name       varchar(80)  not null,
    email           varchar(150) not null unique,
    phone           varchar(20),
    passport_number varchar(20)  not null unique,
    gender          varchar(10)  not null check (gender in ('M', 'F', 'Other'))
);

create table if not exists hotel.service (
    service_id   serial         primary key,
    service_name varchar(100)   not null unique,
    price        numeric(10,2)  not null check (price >= 0),
    description  varchar(255)
);

create table if not exists hotel.employee (
    employee_id     serial      primary key,
    first_name      varchar(80) not null,
    last_name       varchar(80) not null,
    position        varchar(80) not null,
    hotel_branch_id int         not null references hotel.hotel_branch(hotel_branch_id) on delete cascade,
    phone           varchar(20)
);
create table if not exists hotel.room (
    room_id         serial      primary key,
    room_number     varchar(10) not null,
    floor           int         not null check (floor >= 0),
    room_type_id    int         not null references hotel.room_type(room_type_id) on delete restrict,
    hotel_branch_id int         not null references hotel.hotel_branch(hotel_branch_id) on delete cascade,
    is_available    boolean     not null default true,
    unique (room_number, hotel_branch_id)
);

create table if not exists hotel.guest (
    guest_id        serial       primary key,
    first_name      varchar(80)  not null,
    last_name       varchar(80)  not null,
    email           varchar(150) not null unique,
    phone           varchar(20),
    passport_number varchar(20)  not null unique,
    gender          varchar(10)  not null check (gender in ('M', 'F', 'Other'))
);

create table if not exists hotel.service (
    service_id   serial         primary key,
    service_name varchar(100)   not null unique,
    price        numeric(10,2)  not null check (price >= 0),
    description  varchar(255)
);

create table if not exists hotel.employee (
    employee_id     serial      primary key,
    first_name      varchar(80) not null,
    last_name       varchar(80) not null,
    position        varchar(80) not null,
    hotel_branch_id int         not null references hotel.hotel_branch(hotel_branch_id) on delete cascade,
    phone           varchar(20)
);
create table if not exists hotel.booking (
    booking_id   serial      primary key,
    guest_id     int         not null references hotel.guest(guest_id) on delete restrict,
    room_id      int         not null references hotel.room(room_id) on delete restrict,
    check_in     date        not null,
    check_out    date        not null,
    booking_date date        not null default current_date,
    status       varchar(20) not null default 'pending'
                             check (status in ('pending', 'confirmed', 'cancelled', 'completed')),
    nights       int         not null check (nights > 0),
    check (booking_date >= date '2026-01-01'),
    check (check_out > check_in)
);

create table if not exists hotel.booking_service (
    booking_service_id serial primary key,
    booking_id         int    not null references hotel.booking(booking_id) on delete cascade,
    service_id         int    not null references hotel.service(service_id) on delete restrict,
    unique (booking_id, service_id)
);



-- PART 3: ALTER TABLE

alter table hotel.guest
    add column if not exists loyalty_level varchar(20) default 'standard';

alter table hotel.hotel_branch
    add column if not exists rating numeric(2,1) check (rating between 1 and 5);

alter table hotel.employee
    add column if not exists hire_date date default current_date;

do $$
begin
    if exists (
        select 1 from information_schema.columns
        where table_schema = 'hotel'
          and table_name   = 'service'
          and column_name  = 'title'
    ) then
        alter table hotel.service rename column title to service_name;
    end if;
end $$;

alter table hotel.room
    alter column room_number type varchar(20);

do $$
begin
    if exists (
        select 1 from information_schema.table_constraints
        where constraint_schema = 'hotel'
          and constraint_name = 'uq_hotel_title'
    ) then
        alter table hotel.hotel_branch drop constraint uq_hotel_title;
    end if;
end $$;

alter table hotel.hotel_branch
    add constraint uq_hotel_title unique (title);


	
-- PART 4: INSERT DATA

insert into hotel.city (name, country) values
    ('Almaty',    'Kazakhstan'),
    ('Astana',    'Kazakhstan'),
    ('Atyrau',    'Kazakhstan'),
    ('Shymkent',  'Kazakhstan'),
    ('Aktobe',    'Kazakhstan')
on conflict do nothing;

insert into hotel.hotel_branch (title, city_id, address, phone) values
    ('Grand Almaty Hotel',  (select city_id from hotel.city where name = 'Almaty'),   'Dostyk Ave 12',        '+77271234567'),
    ('Astana Palace',       (select city_id from hotel.city where name = 'Astana'),   'Nurly Zhol 5',         '+77172345678'),
    ('Atyrau Riverside',    (select city_id from hotel.city where name = 'Atyrau'),   'Satpaev St 8',         '+77122456789'),
    ('Shymkent Central',    (select city_id from hotel.city where name = 'Shymkent'), 'Karatau Rd 22',        '+77252567890'),
    ('Aktobe Business',     (select city_id from hotel.city where name = 'Aktobe'),   'Abilkaiyr Khan Ave 3', '+77132678901')
on conflict (title) do nothing;

insert into hotel.room_type (type_name, description, base_price) values
    ('Standard',     'Single or double bed, basic amenities',        15000.00),
    ('Deluxe',       'King bed, city view, minibar',                 25000.00),
    ('Suite',        'Separate living area, premium furnishings',    50000.00),
    ('Economy',      'Compact room, shared facilities',               8000.00),
    ('Presidential', 'Full floor, butler service, panoramic view',  120000.00)
on conflict (type_name) do nothing;

insert into hotel.room (room_number, floor, room_type_id, hotel_branch_id, is_available) values
    ('101', 1, (select room_type_id from hotel.room_type where type_name = 'Economy'),      (select hotel_branch_id from hotel.hotel_branch where title = 'Grand Almaty Hotel'), true),
    ('202', 2, (select room_type_id from hotel.room_type where type_name = 'Standard'),     (select hotel_branch_id from hotel.hotel_branch where title = 'Grand Almaty Hotel'), true),
    ('305', 3, (select room_type_id from hotel.room_type where type_name = 'Deluxe'),       (select hotel_branch_id from hotel.hotel_branch where title = 'Astana Palace'),      true),
    ('401', 4, (select room_type_id from hotel.room_type where type_name = 'Suite'),        (select hotel_branch_id from hotel.hotel_branch where title = 'Astana Palace'),      true),
    ('102', 1, (select room_type_id from hotel.room_type where type_name = 'Economy'),      (select hotel_branch_id from hotel.hotel_branch where title = 'Atyrau Riverside'),   true),
    ('201', 2, (select room_type_id from hotel.room_type where type_name = 'Standard'),     (select hotel_branch_id from hotel.hotel_branch where title = 'Atyrau Riverside'),   true),
    ('501', 5, (select room_type_id from hotel.room_type where type_name = 'Presidential'), (select hotel_branch_id from hotel.hotel_branch where title = 'Shymkent Central'),   true),
    ('103', 1, (select room_type_id from hotel.room_type where type_name = 'Standard'),     (select hotel_branch_id from hotel.hotel_branch where title = 'Shymkent Central'),   true),
    ('301', 3, (select room_type_id from hotel.room_type where type_name = 'Deluxe'),       (select hotel_branch_id from hotel.hotel_branch where title = 'Aktobe Business'),    true),
    ('104', 1, (select room_type_id from hotel.room_type where type_name = 'Economy'),      (select hotel_branch_id from hotel.hotel_branch where title = 'Aktobe Business'),    true)
on conflict (room_number, hotel_branch_id) do nothing;

insert into hotel.service (service_name, price, description) values
    ('Airport Transfer',  5000.00, 'One-way transfer from/to airport'),
    ('Breakfast Buffet',  3500.00, 'Full buffet breakfast included'),
    ('Spa Access',        8000.00, 'Full-day spa and wellness access'),
    ('Laundry Service',   1500.00, 'Same-day laundry and pressing'),
    ('City Tour',         6000.00, 'Half-day guided city sightseeing')
on conflict (service_name) do nothing;
insert into hotel.employee (first_name, last_name, position, hotel_branch_id, phone)
select 'Aibek', 'Seitkali', 'Manager', (select hotel_branch_id from hotel.hotel_branch where title = 'Grand Almaty Hotel'), '+77001112233'
where not exists (select 1 from hotel.employee where phone = '+77001112233');

insert into hotel.employee (first_name, last_name, position, hotel_branch_id, phone)
select 'Zarina', 'Bekova', 'Receptionist', (select hotel_branch_id from hotel.hotel_branch where title = 'Grand Almaty Hotel'), '+77002223344'
where not exists (select 1 from hotel.employee where phone = '+77002223344');

insert into hotel.employee (first_name, last_name, position, hotel_branch_id, phone)
select 'Nurlan', 'Akhmetov', 'Manager', (select hotel_branch_id from hotel.hotel_branch where title = 'Astana Palace'), '+77003334455'
where not exists (select 1 from hotel.employee where phone = '+77003334455');

insert into hotel.employee (first_name, last_name, position, hotel_branch_id, phone)
select 'Madina', 'Ospanova', 'Housekeeping', (select hotel_branch_id from hotel.hotel_branch where title = 'Atyrau Riverside'), '+77004445566'
where not exists (select 1 from hotel.employee where phone = '+77004445566');

insert into hotel.employee (first_name, last_name, position, hotel_branch_id, phone)
select 'Daniyar', 'Tulegenov', 'Receptionist', (select hotel_branch_id from hotel.hotel_branch where title = 'Shymkent Central'), '+77005556677'
where not exists (select 1 from hotel.employee where phone = '+77005556677');

insert into hotel.guest (first_name, last_name, email, phone, passport_number, gender) values
    ('Aigerim',  'Nurlanova',    'aigerim.n@gmail.com',     '+77011234567', 'KZ001122', 'F'),
    ('Temirlan', 'Dzhaksybekov', 'temirlan.d@mail.ru',      '+77012345678', 'KZ002233', 'M'),
    ('Saltanat', 'Abenova',      'saltanat.a@gmail.com',    '+77013456789', 'KZ003344', 'F'),
    ('Ruslan',   'Karimov',      'ruslan.k@outlook.com',    '+77014567890', 'KZ004455', 'M'),
    ('Diana',    'Sokolova',     'diana.s@gmail.com',       '+77015678901', 'KZ005566', 'F'),
    ('Arman',    'Bekmuratov',   'arman.b@mail.ru',         '+77016789012', 'KZ006677', 'M'),
    ('Kamila',   'Yesova',       'kamila.y@gmail.com',      '+77017890123', 'KZ007788', 'F'),
    ('Seruk',    'Tursynov',     'serik.t@gmail.com',       '+77018901234', 'KZ008899', 'M'),
    ('Aliya',    'Mukhanova',    'aliya.m@gmail.com',       '+77019012345', 'KZ009900', 'F'),
    ('Marat',    'Zhumagaliev',  'marat.z@outlook.com',     '+77010123456', 'KZ010011', 'M')
on conflict (passport_number) do nothing;
insert into hotel.booking (guest_id, room_id, check_in, check_out, booking_date, status, nights)
select (select guest_id from hotel.guest where email = 'aigerim.n@gmail.com'),
       (select room_id from hotel.room where room_number = '202' and hotel_branch_id = (select hotel_branch_id from hotel.hotel_branch where title = 'Grand Almaty Hotel')),
       '2026-02-10', '2026-02-13', '2026-02-01', 'confirmed', 3
where not exists (select 1 from hotel.booking where guest_id = (select guest_id from hotel.guest where email = 'nurlanova.n@gmail.com') and check_in = '2026-02-10');

insert into hotel.booking (guest_id, room_id, check_in, check_out, booking_date, status, nights)
select (select guest_id from hotel.guest where email = 'temirlan.d@mail.ru'),
       (select room_id from hotel.room where room_number = '305' and hotel_branch_id = (select hotel_branch_id from hotel.hotel_branch where title = 'Astana Palace')),
       '2026-03-05', '2026-03-08', '2026-02-20', 'confirmed', 3
where not exists (select 1 from hotel.booking where guest_id = (select guest_id from hotel.guest where email = 'temirlan.d@mail.ru') and check_in = '2026-03-05');

insert into hotel.booking (guest_id, room_id, check_in, check_out, booking_date, status, nights)
select (select guest_id from hotel.guest where email = 'saltanat.a@gmail.com'),
       (select room_id from hotel.room where room_number = '401' and hotel_branch_id = (select hotel_branch_id from hotel.hotel_branch where title = 'Astana Palace')),
       '2026-04-01', '2026-04-05', '2026-03-15', 'confirmed', 4
where not exists (select 1 from hotel.booking where guest_id = (select guest_id from hotel.guest where email = 'saltanat.a@gmail.com') and check_in = '2026-04-01');

insert into hotel.booking (guest_id, room_id, check_in, check_out, booking_date, status, nights)
select (select guest_id from hotel.guest where email = 'karimov.k@outlook.com'),
       (select room_id from hotel.room where room_number = '102' and hotel_branch_id = (select hotel_branch_id from hotel.hotel_branch where title = 'Atyrau Riverside')),
       '2026-05-10', '2026-05-12', '2026-04-28', 'confirmed', 2
where not exists (select 1 from hotel.booking where guest_id = (select guest_id from hotel.guest where email = 'ruslan.k@outlook.com') and check_in = '2026-05-10');

insert into hotel.booking (guest_id, room_id, check_in, check_out, booking_date, status, nights)
select (select guest_id from hotel.guest where email = 'diana.s@gmail.com'),
       (select room_id from hotel.room where room_number = '501' and hotel_branch_id = (select hotel_branch_id from hotel.hotel_branch where title = 'Shymkent Central')),
       '2026-06-01', '2026-06-07', '2026-05-15', 'pending', 6
where not exists (select 1 from hotel.booking where guest_id = (select guest_id from hotel.guest where email = 'diana.s@gmail.com') and check_in = '2026-06-01');

insert into hotel.booking (guest_id, room_id, check_in, check_out, booking_date, status, nights)
select (select guest_id from hotel.guest where email = 'arman.b@mail.ru'),
       (select room_id from hotel.room where room_number = '301' and hotel_branch_id = (select hotel_branch_id from hotel.hotel_branch where title = 'Aktobe Business')),
       '2026-07-20', '2026-07-23', '2026-07-01', 'confirmed', 3
where not exists (select 1 from hotel.booking where guest_id = (select guest_id from hotel.guest where email = 'arman.b@mail.ru') and check_in = '2026-07-20');

insert into hotel.booking (guest_id, room_id, check_in, check_out, booking_date, status, nights)
select (select guest_id from hotel.guest where email = 'kamila.y@gmail.com'),
       (select room_id from hotel.room where room_number = '103' and hotel_branch_id = (select hotel_branch_id from hotel.hotel_branch where title = 'Shymkent Central')),
       '2026-08-05', '2026-08-08', '2026-07-25', 'confirmed', 3
where not exists (select 1 from hotel.booking where guest_id = (select guest_id from hotel.guest where email = 'kamila.y@gmail.com') and check_in = '2026-08-05');

insert into hotel.booking (guest_id, room_id, check_in, check_out, booking_date, status, nights)
select (select guest_id from hotel.guest where email = 'serik.t@gmail.com'),
       (select room_id from hotel.room where room_number = '201' and hotel_branch_id = (select hotel_branch_id from hotel.hotel_branch where title = 'Atyrau Riverside')),
       '2026-09-10', '2026-09-14', '2026-08-30', 'cancelled', 4
where not exists (select 1 from hotel.booking where guest_id = (select guest_id from hotel.guest where email = 'serik.t@gmail.com') and check_in = '2026-09-10');

insert into hotel.booking (guest_id, room_id, check_in, check_out, booking_date, status, nights)
select (select guest_id from hotel.guest where email = 'aliya.m@gmail.com'),
       (select room_id from hotel.room where room_number = '104' and hotel_branch_id = (select hotel_branch_id from hotel.hotel_branch where title = 'Aktobe Business')),
       '2026-10-01', '2026-10-03', '2026-09-20', 'confirmed', 2
where not exists (select 1 from hotel.booking where guest_id = (select guest_id from hotel.guest where email = 'aliya.m@gmail.com') and check_in = '2026-10-01');

insert into hotel.booking (guest_id, room_id, check_in, check_out, booking_date, status, nights)
select (select guest_id from hotel.guest where email = 'marat.z@outlook.com'),
       (select room_id from hotel.room where room_number = '101' and hotel_branch_id = (select hotel_branch_id from hotel.hotel_branch where title = 'Grand Almaty Hotel')),
       '2026-11-15', '2026-11-18', '2026-11-01', 'pending', 3
where not exists (select 1 from hotel.booking where guest_id = (select guest_id from hotel.guest where email = 'marat.z@outlook.com') and check_in = '2026-11-15');

insert into hotel.booking_service (booking_id, service_id)
select b.booking_id, s.service_id
from hotel.booking b
cross join hotel.service s
where
    ((b.guest_id = (select guest_id from hotel.guest where email = 'aigerim.n@gmail.com') and s.service_name in ('Breakfast Buffet', 'Airport Transfer'))
  or (b.guest_id = (select guest_id from hotel.guest where email = 'saltanat.a@gmail.com') and s.service_name in ('Spa Access', 'Breakfast Buffet'))
  or (b.guest_id = (select guest_id from hotel.guest where email = 'diana.s@gmail.com') and s.service_name in ('City Tour', 'Laundry Service', 'Spa Access'))
  or (b.guest_id = (select guest_id from hotel.guest where email = 'arman.b@mail.ru') and s.service_name in ('Airport Transfer'))
  or (b.guest_id = (select guest_id from hotel.guest where email = 'marat.zg@outlook.com') and s.service_name in ('Breakfast Buffet', 'Laundry Service')))
  and not exists (
      select 1 from hotel.booking_service bs 
      where bs.booking_id = b.booking_id and bs.service_id = s.service_id
  );


  
-- PART 5: UPDATE + DELETE

update hotel.room_type
set base_price = base_price * 0.90
where type_name = 'Suite';

update hotel.room
set is_available = false
where room_id in (
    select room_id
    from hotel.booking
    where status = 'confirmed'
      and current_date between check_in and check_out
);

begin;

delete from hotel.booking
where status = 'cancelled'
returning booking_id, guest_id, check_in, check_out, status;

rollback;



-- PART 6: GRANT + REVOKE

do $$
begin
    if not exists (select 1 from pg_roles where rolname = 'hotel_booking_readonly') then
        create role hotel_booking_readonly;
    end if;
    
    if not exists (select 1 from pg_roles where rolname = 'hotel_booking_writer') then
        create role hotel_booking_writer;
    end if;
end $$;

grant usage on schema hotel to hotel_booking_readonly;
grant usage on schema hotel to hotel_booking_writer;

grant select on all tables in schema hotel to hotel_booking_readonly;

grant select on hotel.guest, hotel.room, hotel.room_type, hotel.service, hotel.employee to hotel_booking_writer;
grant insert, update, select on hotel.booking to hotel_booking_writer;
grant insert, select         on hotel.guest   to hotel_booking_writer;
grant insert, select         on hotel.booking_service to hotel_booking_writer;

grant usage, select on all sequences in schema hotel to hotel_booking_writer;

revoke update on hotel.guest from hotel_booking_writer;


-- select 
--     b.booking_id,
--     concat(g.first_name, ' ', g.last_name) as guest_name,
--     hb.title as hotel_branch,
--     r.room_number,
--     b.check_in,
--     b.check_out,
--     b.nights,
--     b.status
-- from hotel.booking b
-- join hotel.guest g on b.guest_id = g.guest_id
-- join hotel.room r on b.room_id = r.room_id
-- join hotel.hotel_branch hb on r.hotel_branch_id = hb.hotel_branch_id
-- order by b.booking_id;


-- select 
--     hb.title as hotel_branch,
--     count(b.booking_id) as total_bookings,
--     round(avg(b.nights), 1) as avg_nights_per_stay
-- from hotel.hotel_branch hb
-- left join hotel.room r on hb.hotel_branch_id = r.hotel_branch_id
-- left join hotel.booking b on r.room_id = b.room_id
-- group by hb.title
-- order by total_bookings desc;


-- select 
--     s.service_name,
--     count(bs.booking_id) as times_ordered,
--     sum(s.price) as total_earned
-- from hotel.booking_service bs
-- join hotel.service s on bs.service_id = s.service_id
-- group by s.service_name
-- order by total_earned desc;


-- select 
--     concat(g.first_name, ' ', g.last_name) as guest,
--     hb.title as hotel,
--     (b.nights * rt.base_price) as accommodation_total
-- from hotel.booking b
-- join hotel.guest g on b.guest_id = g.guest_id
-- join hotel.room r on b.room_id = r.room_id
-- join hotel.room_type rt on r.room_type_id = rt.room_type_id
-- join hotel.hotel_branch hb on r.hotel_branch_id = hb.hotel_branch_id
-- where b.status != 'cancelled'
-- order by accommodation_total desc;

