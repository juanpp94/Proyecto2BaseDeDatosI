--PROYECTO 2
-- Juan Diego Porras, 12-10566

--Eliminamos la BD si existe
DROP DATABASE IF EXISTS 12-10566;

--Creamos la BD
CREATE DATABASE 12-10566;

--Nos conectamos a la BD
\c 12-10566

/*Tablas Auxiliares*/
CREATE TABLE IF NOT EXISTS clientes(
	id_clientes SERIAL  PRIMARY KEY,
	nombre VARCHAR(64) NOT NULL,
	apellido VARCHAR(64) NOT NULL,
	usuario VARCHAR(64) UNIQUE NOT NULL,
	clave VARCHAR(64) NOT NULL,
	tiempo_registro TIMESTAMP NOT NULL, --time_inserted
	codigo_confirmacion VARCHAR(255) NOT NULL,
	--tiempo_confirmacion TIMESTAMP,
	--ciudad INT REFERENCES city(id_city),
	direccion VARCHAR(255),
	correo VARCHAR(128) NOT NULL,
	telefono VARCHAR(128),
	ciudad VARCHAR(128) NOT NULL,
	--id_ciudad_entrega INT REFERENCES city(id_city),
	direccion_entrega VARCHAR(255)
); 

CREATE TABLE IF NOT EXISTS ciudad(
	id_ciudad SERIAL PRIMARY KEY,
	nombre VARCHAR(128) NOT NULL,
	codigo_postal VARCHAR(16) NOT NULL
);

CREATE TABLE IF NOT EXISTS objeto(
	id_objeto SERIAL PRIMARY KEY,
	nombre_objeto VARCHAR(255) UNIQUE NOT NULL,
	precio DECIMAL(10,2) NOT NULL,
	foto_objeto TEXT,
	descripcion TEXT
	--id_unidad INT REFERENCES unit(id_unit) NOT NULL
);

CREATE TABLE IF NOT EXISTS empleado(
	id_employees SERIAL PRIMARY KEY,
	nombre_empleado VARCHAR(255) 
);

--Tablas originales de la BD

CREATE TABLE IF NOT EXISTS unit(
		id_unit SERIAL PRIMARY KEY,
		unit_name VARCHAR(64) UNIQUE NOT NULL,
		unit_short VARCHAR(8) UNIQUE
	);

CREATE TABLE IF NOT EXISTS item(
		id_item SERIAL PRIMARY KEY,
		item_name VARCHAR(255) UNIQUE NOT NULL,
		price DECIMAL(10,2) NOT NULL,
		item_photo TEXT,
		description TEXT,
		unit_id INT REFERENCES unit(id_unit) NOT NULL
);

CREATE TABLE IF NOT EXISTS employees(
		id_empleado SERIAL PRIMARY KEY,
		codigo_empleado VARCHAR(32) UNIQUE NOT NULL,
		nombre_empleado 	  VARCHAR(64) NOT NULL,
		apellido_empleado	  VARCHAR(64) NOT NULL

);

--Revisar como colocar que el par (cityname,postal_code) sea unico
CREATE TABLE IF NOT EXISTS city(
	id_city SERIAL PRIMARY KEY,
	city_name VARCHAR(128) NOT NULL,
	postal_code VARCHAR(16) NOT NULL
);

CREATE TABLE IF NOT EXISTS customer(
	id_customer SERIAL PRIMARY KEY,
	first_name VARCHAR(64) NOT NULL,
	last_name VARCHAR(64) NOT NULL,
	user_name VARCHAR(64) UNIQUE NOT NULL,
	password VARCHAR(64) NOT NULL,
	time_inserted TIMESTAMP NOT NULL,
	confirmation_code VARCHAR(255) NOT NULL,
	time_confirmed TIMESTAMP,
	contact_email VARCHAR(128) NOT NULL,
	contact_phone VARCHAR(128),
	city_id INT REFERENCES city(id_city),
	address VARCHAR(255),
	deliver_city_id INT REFERENCES city(id_city),
	deliver_address VARCHAR(255)
	);

CREATE TABLE IF NOT EXISTS place_order(
	id_place_order SERIAL PRIMARY KEY,
	customer_id INT REFERENCES customer(id_customer) NOT NULL,
	time_placed TIMESTAMP NOT NULL,
	details	TEXT,
	delivery_city_id INT  REFERENCES city(id_city) NOT NULL,
	delivery_addres VARCHAR(255) NOT NULL,
	grade_customer INT DEFAULT NULL,
	grade_employee INT DEFAULT NULL

);

CREATE TABLE IF NOT EXISTS order_item(
	id_order_item SERIAL PRIMARY KEY,
	place_order_id INT REFERENCES place_order(id_place_order),
	item_id INT REFERENCES item(id_item),
	quantity DECIMAL(10,3),
	price DECIMAL(10,2)

);

CREATE TABLE IF NOT EXISTS delivery(
	id_delivery SERIAL PRIMARY KEY,
	delivery_time_planned TIMESTAMP NOT NULL,
	delivery_time_actual TIMESTAMP,
	notes TEXT,
	place_order_id INT REFERENCES place_order(id_place_order) NOT NULL,
	employee_id INT REFERENCES employees(id_employees) 

);

CREATE TABLE IF NOT EXISTS box(
	id_box SERIAL PRIMARY KEY,
	box_code VARCHAR(32) UNIQUE NOT NULL,
	delivery_id INT REFERENCES delivery(id_delivery) NOT NULL,
	employee_id INT REFERENCES employees(id_employees) NOT NULL

);

CREATE TABLE IF NOT EXISTS item_in_box(
	id_item_in_box SERIAL PRIMARY KEY,
	box_id INT REFERENCES box(id_box) NOT NULL,
	item_id INT REFERENCES item(id_item) NOT NULL,
	quantity DECIMAL(10,3) NOT NULL,
	is_replacement BOOL NOT NULL
);

CREATE TABLE IF NOT EXISTS status_catalog(
	id_status_catalog SERIAL PRIMARY KEY,
	status_name VARCHAR(128) NOT NULL

);

CREATE TABLE IF NOT EXISTS order_status(
	id_order_status SERIAL PRIMARY KEY,
	status_catalog_id INT REFERENCES status_catalog(id_status_catalog) NOT NULL, 
	place_order_id INT REFERENCES place_order(id_place_order) NOT NULL,
	status_time TIMESTAMP NOT NULL,
	details TEXT
);

--Averiguar como especificar que employee_id y customer_id no sean null a la vez
CREATE TABLE IF NOT EXISTS notes(
	id_notes SERIAL PRIMARY KEY,
	place_order_id INT REFERENCES place_order(id_place_order) NOT NULL,
	employee_id INT REFERENCES employees(id_employees),
	customer_id INT REFERENCES customer(id_customer),
	note_time TIMESTAMP NOT NULL,
	note_text TEXT NOT NULL
);


--Copiamos la data sintetica en las tablas auxiliares
COPY clientes(id_clientes,nombre,apellido,usuario,clave,tiempo_registro,codigo_de_confirmacion,correo,telefono,ciudad,direccion,direccion_entrega) from '/var/tmp/tablaClientesPequena.csv' delimiter ',' csv header;
COPY ciudad(id_ciudad,nombre,codigo_postal) from '/var/tmp/tablaCiudadPequena.csv' delimiter ',' csv header;
COPY objeto(id_objeto,nombre_objeto,precio,foto_objeto,descripcion) from '/var/tmp/tablaItemPequena.csv'
COPY unit(id_unit,unit_name,unit_short) from '/var/tmp/tablaMedidas.csv'
COPY empleado(id_empleado,codigo_empleado,nombre_empleado,apellido_empleado) from '/var/tmp/tablaEmpleadoPequena.csv'


--Insertamos la informacion de las tablas auxiliares en las tablas orignales de la BD
INSERT INTO city(city_name,postal_code)
	SELECT ciudad,codigo_postal 
	FROM ciudad;


INSERT INTO item(item_name,price,item_photo,description,unit_id)
	SELECT nombre_objeto,precio,foto_objeto,descripcion
	FROM objeto;

INSERT INTO employees(codigo_empleado,nombre_empleado,apellido_empleado)
	SELECT codigo_empleado,nombre_empleado,apellido_empleado
	FROM empleado;


INSERT INTO customer(first_name,last_name,user_name,password,time_inserted,confirmation_code,
			time_confirmed,contact_email,contact_phone,city_id,address,deliver_city_id,deliver_address)
	SELECT(nombre,apellido,usuario,clave,tiempo_registro,codigo_de_confirmacion,correo,telefono,ciudad,direccion,direccion_entrega)
	FROM clientes;




##PARA EL TIME_CONFIRMED:
/*INSERT INTO tbl_ItemTransactions 
(TransactionDate, TransactionName)
SELECT x, 'dbrnd' 
FROM generate_series('2008-01-01 00:00:00'::timestamptz, '2018-02-01 00:00:00'::timestamptz,'1 days'::interval) a(x);
*/