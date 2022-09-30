drop database if exists radiology;

create database if not exists radiology;

use radiology;

create table users(
	id bigint unsigned not null auto_increment,
    username varchar(20) not null,
    `password` varchar(100) not null,
    email varchar(150) not null,
    `name` varchar(150) not null,
    lastname varchar(150) not null,
    phone_number varchar(15) not null,
    birthdate date not null,
    gender enum("MALE", "FEMALE") not null,
    second_name varchar(100),
    mothers_lastname varchar(100),
    `active` boolean not null,
    constraint primary key(id)
);

create table roles(
	id bigint unsigned not null auto_increment,
    `name` varchar(50) not null,
    constraint primary key (id)
);

create table user_roles(
	id bigint unsigned not null auto_increment,
	role_id bigint unsigned not null,
    user_id bigint unsigned not null,
    constraint primary key(id),
    constraint foreign key(role_id) references roles(id),
    constraint foreign key(user_id) references users(id)
);

create table technicians(
	id bigint unsigned not null auto_increment,
    user_id bigint unsigned not null,
    constraint primary key (id),
    constraint foreign key(user_id) references users(id)
);

create table receptionists(
	id bigint unsigned not null auto_increment,
    user_id bigint unsigned not null,
    constraint primary key (id),
    constraint foreign key(user_id) references users(id)
);

create table state(
	id bigint unsigned not null auto_increment,
    `name` varchar(200) not null,
    abreviation varchar(10) not null,
    constraint primary key(id)
);

create table patients(
	id bigint unsigned not null auto_increment,
    birth_state_id bigint unsigned not null,
    curp varchar(20) not null,
	user_id bigint unsigned not null,
	state_id bigint unsigned not null,
    constraint primary key (id),
    constraint foreign key(user_id) references users(id),
    constraint foreign key(state_id) references state(id)
);

create table specialties(
	id bigint unsigned not null,
    `name` varchar(150) not null,
    constraint primary key(id)
);

create table doctors(
	id bigint unsigned not null auto_increment,
	federal_id varchar(100),
	user_id bigint unsigned not null,
    constraint primary key (id),
    constraint foreign key(user_id) references users(id)
);

create table areas(
	id bigint unsigned not null auto_increment,
    `name` varchar(150) not null,
    constraint primary key (id)
);

create table businesses(
	id bigint unsigned not null auto_increment,
    `name` varchar(100) not null,
    phone_number varchar(15) not null,
    email varchar(150) not null,
    state_id bigint unsigned not null,
    street varchar(150) not null,
    `number` varchar(10) not null,
    constraint primary key(id),
	constraint foreign key(state_id) references state(id)
);

create table doctor_business(
	id bigint unsigned not null auto_increment,
    doctor_id bigint unsigned not null,
    business_id bigint unsigned not null,
    start_date date not null,
	`active` boolean not null,
    constraint primary key(id),
    constraint foreign key(doctor_id) references doctors(id),
    constraint foreign key(business_id) references businesses(id)
);

create table `schedules`(
	id bigint unsigned not null auto_increment,
    `name` varchar(100) not null,
    start_time time not null,
    end_time time not null,
    constraint primary key(id)
);

create table `procedures`(
	id bigint unsigned not null auto_increment,
    `name` varchar(250) not null,
    area_id bigint unsigned not null,
    constraint primary key(id),
    constraint foreign key(area_id) references areas(id)
);

create table instructions(
	id bigint unsigned not null auto_increment,
    `description` varchar(254) not null,
    constraint primary key(id)
);

create table procedures_instructions(
	id bigint unsigned not null,
    procedure_id bigint unsigned not null,
    instruction_id bigint unsigned not null,
    constraint primary key(id),
    constraint foreign key(procedure_id) references procedures(id),
    constraint foreign key(instruction_id) references instructions(id)
);

create table `statuses`(
	id bigint unsigned not null,
    `description` varchar(150) not null,
    constraint primary key(id)
);

create table studies(
	id bigint unsigned not null auto_increment,
    procedure_id bigint unsigned not null,
    iuid varchar(250),
    finished datetime,
    `status_id` bigint unsigned not null,
    technician_id bigint unsigned not null,
    constraint primary key(id),
    constraint foreign key(procedure_id) references `procedures` (id),
    constraint foreign key(status_id) references `statuses`(id),
    constraint foreign key(technician_id) references technicians(id)
);

create table procedences(
	id bigint unsigned not null,
    `procedence` varchar(150) not null,
    constraint primary key(id)
);

create table procedence_procedures(
	id bigint unsigned not null,
    procedence_id bigint unsigned not null,
    procedure_id bigint unsigned not null,
    price double not null,
    constraint primary key(id), 
    constraint foreign key(procedence_id) references procedences(id),
    constraint foreign key(procedure_id) references procedures(id)
);

create table appointments(
	id bigint unsigned not null auto_increment,
    receptionist_id bigint unsigned not null,
    business_id bigint unsigned not null,
    patient_id bigint unsigned not null,
    procedence_procedure_id bigint unsigned not null,
    study_id bigint unsigned not null,
    `datetime` datetime not null,
    constraint primary key(id),
    constraint foreign key(receptionist_id) references receptionists(id),
    constraint foreign key(business_id) references businesses(id),
    constraint foreign key(patient_id) references patients(id),
    constraint foreign key(procedence_procedure_id) references procedence_procedures(id),
    constraint foreign key(study_id) references studies(id)
);

create table interpretations(
	id bigint unsigned not null,
    status_id bigint unsigned not null,
    doctor_id bigint unsigned not null,
    study_id bigint unsigned not null,
    finish datetime,
    `file` varchar(250),
    constraint primary key(id),
    constraint foreign key(status_id) references statuses(id),
    constraint foreign key(doctor_id) references doctors(id),
    constraint foreign key(study_id) references studies(id)
);

create table payment_methods(
	id bigint unsigned not null,
    `method` varchar(100) not null,
    constraint primary key(id)
);

create table tickets(
	id bigint unsigned not null auto_increment,
    total double not null,
    payment_method_id bigint unsigned not null,
    paid boolean not null,
    date_paid datetime not null,
    constraint primary key(id),
    constraint foreign key (payment_method_id) references payment_methods(id)
);

create table ticket_details(
	id bigint unsigned not null auto_increment,
    ticket_id bigint unsigned not null,
    appointment_id bigint unsigned not null,
    constraint primary key (id),
    constraint foreign key(ticket_id) references tickets(id),
    constraint foreign key(appointment_id) references appointments(id)
);

create table business_areas(
	id bigint unsigned not null auto_increment,
    business_id bigint unsigned not null,
    area_id bigint unsigned not null,
    constraint primary key(id),
    constraint foreign key(business_id) references businesses(id),
    constraint foreign key(area_id) references areas(id)
);

create table business_areas_schedules(
	id bigint unsigned not null,
    business_area_id bigint unsigned not null,
    schedule_id bigint unsigned not null,
    constraint primary key(id),
    constraint foreign key(business_area_id) references business_areas(id),
    constraint foreign key(schedule_id) references schedules(id)
);

create table doctors_specialties(
	id bigint unsigned not null,
    doctor_id bigint unsigned not null,
    specialty_id bigint unsigned not null,
    constraint primary key(id),
    constraint foreign key(doctor_id) references doctors(id),
    constraint foreign key(specialty_id) references specialties(id)
);

