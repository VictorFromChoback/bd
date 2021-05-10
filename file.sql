create schema if not exists project_bd;


-- Tables creation

create table if not exists project_bd.product_sale (
    application_id    integer not null,
    seller_company_id integer not null,
    buyer_company_id  integer not null,
    sell_id           integer primary key,
    price             double precision check (price > 0),
    sale_dttm         timestamp
);


create table if not exists project_bd.company (
    company_id integer primary key,
    name varchar(255) not null,
    hq_location varchar(255)
);

drop table project_bd.product cascade;

create table if not exists project_bd.product (
    application_id integer not null,
    company_owner_id integer not null,
    application_nm varchar(255) not null,
    update_id integer,
    valid_from_dttm timestamp not null,
    valid_to_dttm timestamp not null
);


create table if not exists project_bd.developer_apps (
    application_id integer primary key,
    developer_id integer not null,
    release_dt date
);


create table if not exists project_bd.developer (
    developer_nm varchar(255) not null,
    developer_id integer primary key,
    department_id integer not null,
    salary double precision check (salary > 0)
);


create table if not exists project_bd.developer_updates (
    update_id integer primary key,
    developer_id integer not null,
    version_no varchar(255) default ('1.0'),
    description varchar(255),
    update_dttm timestamp
);


create table if not exists project_bd.department (
    company_id integer not null,
    department_id integer primary key,
    department_nm varchar(255)
);


-- Set foreign keys

alter table project_bd.product_sale add constraint fk_seller_sale foreign key (seller_company_id)
    references project_bd.company (company_id);

alter table project_bd.product_sale add constraint buyer_sale foreign key (buyer_company_id)
    references project_bd.company (company_id);


alter table project_bd.product add constraint fk_owner_prod foreign key (company_owner_id)
    references project_bd.company (company_id);

alter table project_bd.product add constraint fk_upid_prod foreign key (update_id)
    references project_bd.developer_updates (update_id);


alter table project_bd.developer_apps add constraint fk_dev_devapp foreign key (developer_id)
    references project_bd.developer (developer_id);


alter table project_bd.developer add constraint fk_dep_dev foreign key (department_id)
    references project_bd.department (department_id);


alter table project_bd.developer_updates add constraint fk_dev_devup foreign key (developer_id)
    references project_bd.developer (developer_id);


alter table project_bd.department add constraint fk_cmp_dep foreign key (company_id)
    references project_bd.company (company_id);



-- Inserts for table COMPANY

truncate table project_bd.company cascade;


copy project_bd.company from '/home/victor/ffff/for_bd_data/table/company.txt' delimiter ',' csv;

insert into project_bd.company values (17, 'BestComputer', 'USA');
insert into project_bd.company values (201, 'BookFace', 'Turkey');
insert into project_bd.company values (65, 'FewFew', 'Malasia');
insert into project_bd.company values (11, 'BestTheBest', 'Russia');
insert into project_bd.company values (490, 'Zamona', 'Malasia');


-- Inserts for DEPARTMENT

copy project_bd.department from '/home/victor/ffff/for_bd_data/table/department.txt' delimiter ',' csv;


insert into project_bd.department values (501, 17, 'Highload services');
insert into project_bd.department values (109, 197, 'SQL developers');
insert into project_bd.department values (17, 345, 'Marketing');


--  Inserts for DEVELOPER

copy project_bd.developer from '/home/victor/ffff/for_bd_data/table/developers.txt' delimiter ',' csv;

insert into project_bd.developer values ('John Black', 1, 1, 340000);
insert into project_bd.developer values ('Oleg Bogdans', 2, 8, 100000);
insert into project_bd.developer values ('Vikrot Stepanovich', 6, 12, 500000);
insert into project_bd.developer values ('Maria Kekson', 5, 105, 200000);
insert into project_bd.developer values ('Andrew Dibrov', 7, 101, 1000000);
insert into project_bd.developer values ('Petr Zhmishenko', 3, 197, 230000);
insert into project_bd.developer values ('Natasha Vex', 4, 345, 330000);


-- Inserts for DEVELOPE_APPS

copy project_bd.developer_apps from '/home/victor/ffff/for_bd_data/table/developer_app.txt' delimiter ',' csv;

insert into project_bd.developer_apps values (999, 61, '2020-10-13');
insert into project_bd.developer_apps values (703, 19, '2019-07-24');
insert into project_bd.developer_apps values (491, 8, '2020-01-19');
insert into project_bd.developer_apps values (291, 91, '2021-12-01');
insert into project_bd.developer_apps values (12, 7, '2020-09-01');
insert into project_bd.developer_apps values (132, 3, '2020-05-23');


-- Inserts for DEVELOPER_UPDATES

copy project_bd.developer_updates from '/home/victor/ffff/for_bd_data/table/developer_updates.txt' delimiter ',' csv;

insert into project_bd.developer_updates values (333, 6, '13.1', 'Add stickers with cats', '2021-01-13 13:01:29');
insert into project_bd.developer_updates values (41, 6, '3.2.2', 'Check our new appearance', '2021-10-21 11:19:57');
insert into project_bd.developer_updates values (100, 7, '3.0.0', 'Now you can pay via apple-pay',
                                                                '2021-03-21 05:04:21');


--Inserts for PRODUCT_SALE

select
    d.developer_id,
    d.developer_nm,
    c.company_id,
    ap.application_id,
    ap.release_dt
from project_bd.developer as d
inner join project_bd.department as b
    on d.department_id = b.department_id
inner join project_bd.company as c
    on b.company_id = c.company_id
inner join project_bd.developer_apps ap
    on d.developer_id = ap.developer_id;


copy project_bd.product_sale from '/home/victor/ffff/for_bd_data/table/dev_sales.txt' delimiter ',' csv;

insert into project_bd.product_sale values (12, 65, 109, 301, 10000000, '2021-08-13 21:20:59');
insert into project_bd.product_sale values (703, 490, 65, 111, 2000000, '2022-05-23 11:00:00');
insert into project_bd.product_sale values (145, 17, 99, 437, 900000, '2021-07-11 22:30:24');


select *
    from project_bd.product_sale;

-- Inserts for PRODUCT

copy project_bd.product from '/home/victor/ffff/for_bd_data/table/product.txt' delimiter ',' csv;

select *
    from project_bd.developer_apps;


select *
    from project_bd.developer_updates;


select *
    from project_bd.product_sale;

select *
    from project_bd.product;




-- ИНДЕКСЫ

create index on project_bd.developer(salary);
create index on project_bd.product_sale(seller_company_id);
create index on project_bd.product_sale(buyer_company_id);
create index on project_bd.product(valid_from_dttm);
create index on project_bd.product(valid_to_dttm);
create index on project_bd.developer_apps(release_dt);


-- CRUD запросы

-- ????????


-- ЗАПРОСЫ

    -- Какая компания не участовала в продаже приложений

select
    comp.name
from project_bd.company as comp
left join project_bd.product_sale as sale
    on comp.company_id = sale.seller_company_id or
       comp.company_id = sale.buyer_company_id
where sale.price is null;

    -- Сравнение средней зарпалаты по стране и сотрудника

select
    d.salary,
    d.developer_nm,
    c.hq_location,
    avg(d.salary) over (partition by c.hq_location) as sum_over_country
from project_bd.developer as d
inner join project_bd.department as b
    on d.department_id = b.department_id
inner join project_bd.company as c
    on b.company_id = c.company_id
inner join project_bd.developer_apps ap
    on d.developer_id = ap.developer_id;


    -- Сколько приложений имело лишь 1 владельца?

select prod.application_nm as application_name
from project_bd.product as prod
group by prod.application_nm
having count(distinct prod.company_owner_id) < 2;


    -- Вычисление куммулятивных сумм для прожад приложений

select
       comp.name,
       sum(pr_sale.price) over (partition by pr_sale.seller_company_id order by pr_sale.sale_dttm asc) as
                                                                                     cummulative_sum_over_time,
       pr_sale.sale_dttm
from project_bd.product_sale as pr_sale
inner join project_bd.company as comp on
comp.company_id = pr_sale.buyer_company_id;


    -- Найдем сотрудников, написавших хотя бы 2 приложения

select count(*) as amount_of_apps,
       dev.developer_nm as developer_name
from project_bd.developer as dev
inner join project_bd.developer_apps as apps
    on dev.developer_id = apps.developer_id
group by dev.developer_id
having count(*) > 1
order by count(*) desc;



-- VIEWS

-- Создаем специальную схему
create schema project_bd_views;


-- VIEW (LIGHT)

    -- developer(hide salary)

create view project_bd_views.developers as
select dev.developer_nm,
       left(cast(dev.salary as text), 1) || 'xxxxxxx' as salary
from project_bd.developer as dev;

select *
from project_bd_views.developers;

    -- PRODUCT SALE

create view project_bd_views.sales as
select
    pr_sl.sale_dttm,
    regexp_replace(cast(price as text), '[[:alnum:]]', '#', 'g') as price
from project_bd.product_sale as pr_sl;


    -- COMPANY

create view project_bd_views.company as
select
    cmp.name,
    cmp.hq_location as location_country
from project_bd.company as cmp;


    -- PRODUCT (only name)

create view project_bd_views.product as
select
    pr.application_nm
from project_bd.product as pr;


    -- DEVELOPER_APPS (only logs - dates)

create view project_bd_views.app as
select
    app.release_dt
from project_bd.developer_apps as app;


    -- DEVELOPER_UPDATES (version + date)

create view project_bd_views.updates as
select
    upd.update_dttm as update_date,
    upd.version_no
from project_bd.developer_updates as upd;


    -- DEPARTMENT (only name)

create view project_bd_views.department as
select
    dep.department_nm as department_name
from project_bd.department as dep;


-----------------------

    -- VIEW ADVANCED:
--         1) Делаем join PRODUCT_SALES и COMPANY чтобы проанализировать прибыль компаний
--         2) Делаем join таблиц PRODUCT и UPDATES чтобы понять какие приложения чаще поддреживаются
--         3) Цепочка join, чтобы анализровать эффектиновтьс отделов с продаж приложений

    -- 1)  Делаем join PRODUCT_SALES и COMPANY чтобы проанализировать прибыль компаний

create view project_bd_views.company_income as
select
    s2.price - s1.price as income,
    s2.sale_dttm,
    cmp.name
from project_bd.product_sale as s1
inner join project_bd.product_sale as s2
on s2.seller_company_id = s1.buyer_company_id and
   s1.application_id = s2.application_id
inner join project_bd.company as cmp
on s2.buyer_company_id = cmp.company_id
order by s2.sale_dttm;


select *
from project_bd_views.company_income;


    -- 2) Делаем join таблиц PRODUCT и UPDATES чтобы понять какие приложения чаще поддреживаются

create view project_bd_views.updates_logs as
select distinct
    app.application_nm as app_name,
    dev.developer_nm as developer_name,
    upd.update_dttm as update_date
from project_bd.product as app
inner join project_bd.developer_updates as upd
    on upd.update_id = app.update_id
inner join project_bd.developer as dev
    on dev.developer_id = upd.developer_id;


select *
from project_bd_views.updates_logs;


    -- 3) Цепочка join, чтобы анализровать эффектиновтьс отделов с продаж приложений


create view project_bd_views.dep_efficiency as
select
    dep.department_nm as department_name,
    cmp.name as company_name,
    sum(price) as total_income_from_apps
from project_bd.developer_apps as app_dev
inner join project_bd.developer as dev
    on app_dev.developer_id = dev.developer_id
inner join project_bd.department as dep
    on dep.department_id = dev.department_id
inner join project_bd.company as cmp
    on cmp.company_id = dep.company_id
inner join project_bd.product_sale as sale
    on sale.application_id = app_dev.application_id
group by dep.department_nm, cmp.name;

select *
from project_bd_views.dep_efficiency;


-----------

-- Тригеры


select *
from project_bd.product_sale;


select
    regexp_replace(dev.developer_nm, '[[:alnum:]]', '#', 'g') as oleg
from project_bd.developer as dev;


select regexp_replace(regexp_replace('dbc', '%', ' '), '[^[:alnum:]]', '#', 'g') as name;

select regexp_replace('abc', '[[:alpha:]]', '#', 'g');

SELECT REGEXP_REPLACE('ABC12345xyz','[[:alpha:]]','','g');


select 'a' like '_' as check,
       'abc' like '%';

-- TEST


create function one() returns integer as $$
        select 1 as result;
    $$ language SQL;


drop function one;


create function sum(x integer, y integer) returns integer as $$
        select x + y;
    $$ language SQL;


select sum(3, 5) as print;


CREATE PROCEDURE tst_procedure(INOUT p1 TEXT)
AS $$
BEGIN
RAISE NOTICE 'Procedure Parameter: %', p1 ;
END;
$$
LANGUAGE plpgsql ;


SHOW server_version;

select version();
