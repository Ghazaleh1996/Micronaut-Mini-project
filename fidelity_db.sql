-- create user fidelity@'localhost' identified by 'test123'
-- grant all on fidelity_db.* to fidelity@'localhost'

-- create table customer(id int unsigned not null auto_increment primary key,name varchar(100),surname varchar(100),points int not null default 0)
 
-- create table merchant(id int unsigned not null auto_increment primary key,name varchar(100));

-- create table transaction (id int unsigned not null auto_increment primary key,points int not null default 0,timestamp timestamp default current_timestamp,customer_id int unsigned not null,foreign key (customer_id) references customer(id));

-- create table customer_merchant ( customer_id int unsigned not null, merchant_id int unsigned not null, primary key (customer_id, merchant_id),foreign key (customer_id) references customer(id),foreign key (merchant_id) references merchant(id));
