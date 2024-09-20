--Script base de datos life & health

-----------------------------------------------------
-----------------------------------------------------
--Creacion de tablespaces

--Tablespace UNDO para la base de datos
CREATE UNDO TABLESPACE ts_undo
DATAFILE 'C:\database_admin\ts_undo.dbf'
SIZE 100M
AUTOEXTEND ON
NEXT 10M
MAXSIZE UNLIMITED;

--Asignando el tablespace undo a la base de datos
ALTER SYSTEM SET UNDO_TABLESPACE = ts_undo;

--Tablespaces permanentes
CREATE TABLESPACE ts_productos_ventas
DATAFILE 'C:\database_admin\tablespaces\ts_productos_ventas.dbf'
SIZE 100M
AUTOEXTEND ON
NEXT 10M
MAXSIZE 500M;

CREATE TABLESPACE ts_empleados
DATAFILE 'C:\database_admin\tablespaces\ts_empleados.dbf'
SIZE 100M
AUTOEXTEND ON
NEXT 10M
MAXSIZE 500M;

CREATE TABLESPACE ts_territorios
DATAFILE 'C:\database_admin\tablespaces\ts_territorios.dbf'
SIZE 100M
AUTOEXTEND ON
NEXT 10M
MAXSIZE 500M;

CREATE TABLESPACE ts_clientes
DATAFILE 'C:\database_admin\tablespaces\ts_clientes.dbf'
SIZE 100M
AUTOEXTEND ON
NEXT 10M
MAXSIZE 500M;

CREATE TABLESPACE ts_sedes
DATAFILE 'C:\database_admin\tablespaces\ts_sedes.dbf'
SIZE 100M
AUTOEXTEND ON
NEXT 10M
MAXSIZE 500M;
-----------------------------------------------------
-----------------------------------------------------

-----------------------------------------------------
-----------------------------------------------------
--ROLES

--programador_backend
CREATE ROLE C##rol_programador_backend;

GRANT CREATE SESSION TO C##rol_programador_backend;
GRANT CREATE TABLE TO C##rol_programador_backend;
GRANT CREATE VIEW TO C##rol_programador_backend;
GRANT CREATE SYNONYM TO C##rol_programador_backend;
GRANT EXECUTE ANY PROCEDURE TO C##rol_programador_backend;
GRANT CREATE TABLESPACE TO C##rol_programador_backend;

GRANT SELECT,INSERT, UPDATE, DELETE, ALTER ON pais TO C##rol_programador_backend;
GRANT SELECT,INSERT, UPDATE, DELETE, ALTER ON estado TO C##rol_programador_backend;
GRANT SELECT,INSERT, UPDATE, DELETE, ALTER ON ciudad TO C##rol_programador_backend;
GRANT SELECT,INSERT, UPDATE, DELETE, ALTER ON sede TO C##rol_programador_backend;
GRANT SELECT,INSERT, UPDATE, DELETE, ALTER ON elemento TO C##rol_programador_backend;
GRANT SELECT,INSERT, UPDATE, DELETE, ALTER ON elementos_sede TO C##rol_programador_backend;
GRANT SELECT,INSERT, UPDATE, DELETE, ALTER ON caracteristica TO C##rol_programador_backend;
GRANT SELECT,INSERT, UPDATE, DELETE, ALTER ON caracteristicas_sede TO C##rol_programador_backend;
GRANT SELECT,INSERT, UPDATE, DELETE, ALTER ON departamento TO C##rol_programador_backend;
GRANT SELECT,INSERT, UPDATE, DELETE, ALTER ON cargo TO C##rol_programador_backend;
GRANT SELECT,INSERT, UPDATE, DELETE, ALTER ON empleado TO C##rol_programador_backend;
GRANT SELECT,INSERT, UPDATE, DELETE, ALTER ON membresia TO C##rol_programador_backend;
GRANT SELECT,INSERT, UPDATE, DELETE, ALTER ON cliente TO C##rol_programador_backend;
GRANT SELECT,INSERT, UPDATE, DELETE, ALTER ON historial_visitas TO C##rol_programador_backend;
GRANT SELECT,INSERT, UPDATE, DELETE, ALTER ON producto TO C##rol_programador_backend;
GRANT SELECT,INSERT, UPDATE, DELETE, ALTER ON productos_sede TO C##rol_programador_backend;
GRANT SELECT,INSERT, UPDATE, DELETE, ALTER ON venta TO C##rol_programador_backend;
GRANT SELECT,INSERT, UPDATE, DELETE, ALTER ON productos_venta TO C##rol_programador_backend;

--adminsitrador
CREATE ROLE C##rol_administrativo;

GRANT CREATE SESSION TO C##rol_administrativo;

GRANT SELECT ON pais TO C##rol_administrativo;
GRANT SELECT ON estado TO C##rol_administrativo;
GRANT SELECT ON ciudad TO C##rol_administrativo;
GRANT SELECT ON sede TO C##rol_administrativo;
GRANT SELECT ON elemento TO C##rol_administrativo;
GRANT SELECT ON elementos_sede TO C##rol_administrativo;
GRANT SELECT ON caracteristica TO C##rol_administrativo;
GRANT SELECT ON caracteristicas_sede TO C##rol_administrativo;
GRANT SELECT ON departamento TO C##rol_administrativo;
GRANT SELECT ON cargo TO C##rol_administrativo;
GRANT SELECT ON empleado TO C##rol_administrativo;
GRANT SELECT ON membresia TO C##rol_administrativo;
GRANT SELECT ON cliente TO C##rol_administrativo;
GRANT SELECT ON historial_visitas TO C##rol_administrativo;
GRANT SELECT ON producto TO C##rol_administrativo;
GRANT SELECT ON productos_sede TO C##rol_administrativo;
GRANT SELECT ON venta TO C##rol_administrativo;
GRANT SELECT ON productos_venta TO C##rol_administrativo;
-----------------------------------------------------
-----------------------------------------------------

-----------------------------------------------------
-----------------------------------------------------
--USUARIOS

CREATE USER C##usuario_backend_1 IDENTIFIED BY "usBCK012024#a1";
GRANT C##rol_programador_backend TO C##usuario_backend;

CREATE USER C##usuario_backend_2 IDENTIFIED BY "usBCK022024#c9";
GRANT C##rol_programador_backend TO C##usuario_backend;

CREATE USER C##usuario_administrativo_1 IDENTIFIED BY "usADM012024#f0";
GRANT C##rol_administrativo TO C##usuario_administrativo_1;

CREATE USER C##usuario_administrativo_1 IDENTIFIED BY "usADM022024#h7";
GRANT C##rol_administrativo TO C##usuario_administrativo_1;
-----------------------------------------------------
-----------------------------------------------------

-----------------------------------------------------
-----------------------------------------------------
--Creacion de las tablas

CREATE TABLE pais (
id NUMBER GENERATED ALWAYS AS IDENTITY,
pais VARCHAR(50) NOT NULL,
CONSTRAINT PK_pais PRIMARY KEY (id)
)TABLESPACE ts_territorios;

CREATE TABLE estado (
id NUMBER GENERATED ALWAYS AS IDENTITY,
estado VARCHAR(50) NOT NULL,
id_pais NUMBER NOT NULL,
CONSTRAINT PK_estado PRIMARY KEY (id),
CONSTRAINT FK_estado_pais FOREIGN KEY (id_pais) REFERENCES pais (id)
)TABLESPACE ts_territorios;

CREATE TABLE ciudad (
id NUMBER GENERATED ALWAYS AS IDENTITY,
ciudad VARCHAR(50) NOT NULL,
id_estado NUMBER NOT NULL,
CONSTRAINT PK_ciudad PRIMARY KEY (id),
CONSTRAINT FK_ciudad_estado FOREIGN KEY (id_estado) REFERENCES estado (id)
)TABLESPACE ts_territorios;

CREATE TABLE sede (
id NUMBER GENERATED ALWAYS AS IDENTITY,
sede VARCHAR(50) NOT NULL,
direccion VARCHAR(70) NOT NULL,
telefono VARCHAR(15) NOT NULL,
id_ciudad NUMBER NOT NULL,
CONSTRAINT PK_sede PRIMARY KEY (id),
CONSTRAINT FK_sede_ciudad FOREIGN KEY (id_ciudad) REFERENCES ciudad (id)
)TABLESPACE ts_sedes;

CREATE TABLE elemento (
id NUMBER GENERATED ALWAYS AS IDENTITY,
elemento VARCHAR(60) NOT NULL,
marca VARCHAR(50) NOT NULL,
CONSTRAINT PK_elemento PRIMARY KEY (id)
)TABLESPACE ts_sedes;

CREATE TABLE elementos_sede (
id NUMBER GENERATED ALWAYS AS IDENTITY,
id_elemento NUMBER NOT NULL,
id_sede NUMBER NOT NULL,
cantidad NUMBER(6) NOT NULL,
CONSTRAINT PK_elementos_sede PRIMARY KEY (id),
CONSTRAINT FK_elementos_sede_elemento FOREIGN KEY (id_elemento) REFERENCES elemento (id),
CONSTRAINT FK_elementos_sede_sede FOREIGN KEY (id_sede) REFERENCES sede (id)
)TABLESPACE ts_sedes;

CREATE TABLE caracteristica (
id NUMBER GENERATED ALWAYS AS IDENTITY,
caracteristica VARCHAR(50) NOT NULL,
CONSTRAINT PK_caracteristica PRIMARY KEY (id)
)TABLESPACE ts_sedes;

CREATE TABLE caracteristicas_sede (
id NUMBER GENERATED ALWAYS AS IDENTITY,
id_sede NUMBER NOT NULL,
id_caracteristica NUMBER NOT NULL,
CONSTRAINT PK_caracteristicas_sede PRIMARY KEY (id),
CONSTRAINT FK_caracteristicas_sede_sede FOREIGN KEY (id_sede) REFERENCES sede (id),
CONSTRAINT FK_caracteristicas_sede_caracteristica FOREIGN KEY (id_caracteristica) REFERENCES caracteristica (id)
)TABLESPACE ts_sedes;

CREATE TABLE departamento (
id NUMBER GENERATED ALWAYS AS IDENTITY,
departamento VARCHAR(50) NOT NULL,
CONSTRAINT PK_departamento PRIMARY KEY (id)
)TABLESPACE ts_empleados;

CREATE TABLE cargo (
id NUMBER GENERATED ALWAYS AS IDENTITY,
cargo VARCHAR(50) NOT NULL,
id_departamento NUMBER NOT NULL,
CONSTRAINT PK_cargo PRIMARY KEY (id),
CONSTRAINT FK_cargo_departamento FOREIGN KEY (id_departamento) REFERENCES departamento (id)
)TABLESPACE ts_empleados;

CREATE TABLE empleado (
id NUMBER GENERATED ALWAYS AS IDENTITY,
nombre VARCHAR(50) NOT NULL,
apellido VARCHAR(50) NOT NULL,
dni VARCHAR(15) NOT NULL,
fecha_nacimiento DATE NOT NULL,
telefono VARCHAR(15) NOT NULL,
email VARCHAR(60) NOT NULL,
estado NUMBER(1) DEFAULT 1,
id_sede NUMBER NOT NULL,
id_cargo NUMBER NOT NULL,
CONSTRAINT PK_empleado PRIMARY KEY (id),
CONSTRAINT FK_empleado_sede FOREIGN KEY (id_sede) REFERENCES sede (id),
CONSTRAINT FK_empleado_cargo FOREIGN KEY (id_cargo) REFERENCES cargo (id),
CONSTRAINT UC_empleado_cedula UNIQUE (dni),
CONSTRAINT UC_empleado_email UNIQUE (email),
CONSTRAINT CHK_empleado CHECK (estado BETWEEN 0 AND 1)
)TABLESPACE ts_empleados;

CREATE TABLE membresia (
id NUMBER GENERATED ALWAYS AS IDENTITY,
membresia VARCHAR(30) NOT NULL,
descripcion VARCHAR(250) DEFAULT 'Descripcion no disponible',
precio_mes NUMBER(9,2) NOT NULL,
precio_anual NUMBER(10,2) NOT NULL,
CONSTRAINT PK_membresia PRIMARY KEY (id)
)TABLESPACE ts_clientes;

CREATE TABLE cliente (
id NUMBER GENERATED ALWAYS AS IDENTITY,
nombre VARCHAR(50) NOT NULL,
apellido VARCHAR(50) NOT NULL,
dni VARCHAR(15) NOT NULL,
fecha_nacimiento DATE NOT NULL,
telefono VARCHAR(15) NOT NULL,
email VARCHAR(60) NOT NULL,
activo_hasta DATE NOT NULL,
id_sede_principal NUMBER NOT NULL,
id_membresia NUMBER NOT NULL,
CONSTRAINT PK_cliente PRIMARY KEY (id),
CONSTRAINT FK_cliente_sede FOREIGN KEY (id_sede_principal) REFERENCES sede (id),
CONSTRAINT FK_cliente_membresia FOREIGN KEY (id_membresia) REFERENCES membresia (id),
CONSTRAINT UC_cliente_cedula UNIQUE (dni),
CONSTRAINT UC_cliente_email UNIQUE (email)
)TABLESPACE ts_clientes;

CREATE TABLE historial_visitas (
id NUMBER GENERATED ALWAYS AS IDENTITY,
fecha_hora DATE DEFAULT SYSDATE,
id_cliente NUMBER NOT NULL,
id_sede NUMBER NOT NULL,
CONSTRAINT PK_historial_visitas PRIMARY KEY (id),
CONSTRAINT FK_historial_visitas_cliente FOREIGN KEY (id_cliente) REFERENCES cliente (id),
CONSTRAINT FK_historial_visitas_sede FOREIGN KEY (id_sede) REFERENCES sede (id)
)TABLESPACE ts_clientes;

CREATE TABLE producto (
id NUMBER GENERATED ALWAYS AS IDENTITY,
producto VARCHAR(50) NOT NULL,
descripcion VARCHAR(100) DEFAULT 'Producto sin descripcion especifica',
CONSTRAINT PK_producto PRIMARY KEY (id)
)TABLESPACE ts_productos_ventas;

CREATE TABLE productos_sede (
id NUMBER GENERATED ALWAYS AS IDENTITY,
id_producto NUMBER NOT NULL,
id_sede NUMBER NOT NULL,
precio NUMBER(10,2) NOT NULL,
stock NUMBER DEFAULT 0,
CONSTRAINT PK_productos_sede PRIMARY KEY (id),
CONSTRAINT FK_productos_sede_producto FOREIGN KEY (id_producto) REFERENCES producto (id),
CONSTRAINT FK_productos_sede_sede FOREIGN KEY (id_sede) REFERENCES sede (id),
CONSTRAINT CHK_productos_sede CHECK (stock >= 0)
)TABLESPACE ts_productos_ventas;

CREATE TABLE venta (
id NUMBER GENERATED ALWAYS AS IDENTITY,
id_cliente NUMBER NOT NULL,
id_empleado NUMBER NOT NULL,
fecha DATE DEFAULT SYSDATE,
total number(11,2) NOT NULL,
CONSTRAINT PK_venta PRIMARY KEY (id),
CONSTRAINT FK_venta_cliente FOREIGN KEY (id_cliente) REFERENCES cliente (id),
CONSTRAINT FK_venta_empleado FOREIGN KEY (id_empleado) REFERENCES empleado (id)
)TABLESPACE ts_productos_ventas;

CREATE TABLE productos_venta (
id NUMBER GENERATED ALWAYS AS IDENTITY,
id_venta NUMBER NOT NULL,
id_producto_sede NUMBER NOT NULL,
cantidad NUMBER DEFAULT 1,
total_producto number(11,2) NOT NULL,
CONSTRAINT PK_productos_venta PRIMARY KEY (id),
CONSTRAINT FK_productos_venta_venta FOREIGN KEY (id_venta) REFERENCES venta (id),
CONSTRAINT FK_productos_venta_producto_sede FOREIGN KEY (id_producto_sede) REFERENCES productos_sede (id),
CONSTRAINT CHK_productos_venta CHECK (cantidad >= 1 AND total_producto > 0)
)TABLESPACE ts_productos_ventas;
-----------------------------------------------------
-----------------------------------------------------

-----------------------------------------------------
-----------------------------------------------------
--INSERCIONES DE DATOS

-----------------------------------------------------
--Paises
INSERT INTO pais (pais) VALUES ('Argentina');
INSERT INTO pais (pais) VALUES ('Chile');
INSERT INTO pais (pais) VALUES ('Colombia');
INSERT INTO pais (pais) VALUES ('Costa Rica');
INSERT INTO pais (pais) VALUES ('Ecuador');
INSERT INTO pais (pais) VALUES ('Mexico');
INSERT INTO pais (pais) VALUES ('Panama');
INSERT INTO pais (pais) VALUES ('Peru');
INSERT INTO pais (pais) VALUES ('España');

-----------------------------------------------------

-----------------------------------------------------
--Estados
INSERT INTO estado (estado, id_pais) VALUES ('Buenos Aires', 1);--1
INSERT INTO estado (estado, id_pais) VALUES ('Region metropolitana', 2);--2
INSERT INTO estado (estado, id_pais) VALUES ('Cundinamarca', 3);--3
INSERT INTO estado (estado, id_pais) VALUES ('Antioquia', 3);--4
INSERT INTO estado (estado, id_pais) VALUES ('Quindio', 3);--5
INSERT INTO estado (estado, id_pais) VALUES ('Pichincha', 5);--6
INSERT INTO estado (estado, id_pais) VALUES ('Guayas', 5);--7
INSERT INTO estado (estado, id_pais) VALUES ('Azuay', 5);--8
INSERT INTO estado (estado, id_pais) VALUES ('Lima', 47);--9
INSERT INTO estado (estado, id_pais) VALUES ('Mexico DF', 6);--10
INSERT INTO estado (estado, id_pais) VALUES ('Jalisco', 6);--11
INSERT INTO estado (estado, id_pais) VALUES ('Panama', 7);--12
INSERT INTO estado (estado, id_pais) VALUES ('Cataluna', 9);--13
INSERT INTO estado (estado, id_pais) VALUES ('Madrid', 9);--14
-----------------------------------------------------

-----------------------------------------------------
--Ciudades
INSERT INTO ciudad (ciudad, id_estado) VALUES ('Bogota', 3);--1
INSERT INTO ciudad (ciudad, id_estado) VALUES ('Soacha', 3);--2
INSERT INTO ciudad (ciudad, id_estado) VALUES ('Medellin', 4);--3
INSERT INTO ciudad (ciudad, id_estado) VALUES ('Envigado', 4);--4
INSERT INTO ciudad (ciudad, id_estado) VALUES ('Armenia', 5);--5
INSERT INTO ciudad (ciudad, id_estado) VALUES ('Quito', 6);--6
INSERT INTO ciudad (ciudad, id_estado) VALUES ('Sangoli', 6); --7
INSERT INTO ciudad (ciudad, id_estado) VALUES ('Guayaquil', 7);--8
INSERT INTO ciudad (ciudad, id_estado) VALUES ('Cuenca', 8);--9
INSERT INTO ciudad (ciudad, id_estado) VALUES ('Lima', 9);--10
INSERT INTO ciudad (ciudad, id_estado) VALUES ('Miraflores', 9);--11
INSERT INTO ciudad (ciudad, id_estado) VALUES ('Buenos Aires', 1);--12
INSERT INTO ciudad (ciudad, id_estado) VALUES ('La Plata', 1);--13
INSERT INTO ciudad (ciudad, id_estado) VALUES ('Santiago', 2);--14
INSERT INTO ciudad (ciudad, id_estado) VALUES ('Ciudad de Mexico', 10);--15
INSERT INTO ciudad (ciudad, id_estado) VALUES ('Iztapalapa', 10);--16
INSERT INTO ciudad (ciudad, id_estado) VALUES ('Guadalajara', 11);--17
INSERT INTO ciudad (ciudad, id_estado) VALUES ('Panama', 12);--18
INSERT INTO ciudad (ciudad, id_estado) VALUES ('Barcelona', 13);--19
INSERT INTO ciudad (ciudad, id_estado) VALUES ('Tarragona', 13);--20
INSERT INTO ciudad (ciudad, id_estado) VALUES ('Madrid', 14);--21
INSERT INTO ciudad (ciudad, id_estado) VALUES ('Getafe', 14);--22
-----------------------------------------------------

-----------------------------------------------------
--Elementos
INSERT INTO elemento (elemento, marca) VALUES ('Cinta de correr', 'NordicTrack');
INSERT INTO elemento (elemento, marca) VALUES ('Bicicleta estática', 'Schwinn');
INSERT INTO elemento (elemento, marca) VALUES ('Elíptica', 'ProForm');
INSERT INTO elemento (elemento, marca) VALUES ('Banco de pesas', 'Body-Solid');
INSERT INTO elemento (elemento, marca) VALUES ('Juego de mancuernas', 'Bowflex');
INSERT INTO elemento (elemento, marca) VALUES ('Máquina de remo', 'Concept2');
INSERT INTO elemento (elemento, marca) VALUES ('Máquina de poleas', 'Valor Fitness');
INSERT INTO elemento (elemento, marca) VALUES ('Estera de yoga', 'Manduka');
INSERT INTO elemento (elemento, marca) VALUES ('Balón medicinal', 'Rogue');
INSERT INTO elemento (elemento, marca) VALUES ('Kettlebell', 'Onnit');
INSERT INTO elemento (elemento, marca) VALUES ('Pesas rusas', 'TRX');
INSERT INTO elemento (elemento, marca) VALUES ('Caja pliométrica', 'Titan Fitness');
INSERT INTO elemento (elemento, marca) VALUES ('Soga de batalla', 'AmazonBasics');
INSERT INTO elemento (elemento, marca) VALUES ('Colchoneta de ejercicios', 'Gaiam');
INSERT INTO elemento (elemento, marca) VALUES ('Cuerda para saltar', 'WOD Nation');
INSERT INTO elemento (elemento, marca) VALUES ('Barra olímpica', 'CAP Barbell');
INSERT INTO elemento (elemento, marca) VALUES ('Banco ajustable', 'Rep Fitness');
INSERT INTO elemento (elemento, marca) VALUES ('Prensa de piernas', 'BodyCraft');
INSERT INTO elemento (elemento, marca) VALUES ('Estación de dominadas', 'Iron Gym');
INSERT INTO elemento (elemento, marca) VALUES ('Estación de fondos', 'Stamina');
INSERT INTO elemento (elemento, marca) VALUES ('Estación de abdominales', 'Perfect Fitness');
INSERT INTO elemento (elemento, marca) VALUES ('Step de aeróbicos', 'Reebok');
INSERT INTO elemento (elemento, marca) VALUES ('Banda de resistencia', 'Fit Simplify');
INSERT INTO elemento (elemento, marca) VALUES ('Rueda abdominal', 'Valeo');
INSERT INTO elemento (elemento, marca) VALUES ('Máquina de esquiador', 'Skierg');
INSERT INTO elemento (elemento, marca) VALUES ('Remo ergómetro', 'Hydrow');
INSERT INTO elemento (elemento, marca) VALUES ('Silla romana', 'Titan Fitness');
INSERT INTO elemento (elemento, marca) VALUES ('Multiestación de entrenamiento', 'Weider');
INSERT INTO elemento (elemento, marca) VALUES ('Pesa rusa ajustable', 'Bowflex');
INSERT INTO elemento (elemento, marca) VALUES ('Sistema de entrenamiento en suspensión', 'TRX');
INSERT INTO elemento (elemento, marca) VALUES ('Rodillo de espuma', 'TriggerPoint');
INSERT INTO elemento (elemento, marca) VALUES ('Chaleco lastrado', 'RUNmax');
INSERT INTO elemento (elemento, marca) VALUES ('Escaladora', 'StairMaster');
INSERT INTO elemento (elemento, marca) VALUES ('Caja de pesas', 'Cap Barbell');
INSERT INTO elemento (elemento, marca) VALUES ('Estación de sentadillas', 'Fitness Reality');
INSERT INTO elemento (elemento, marca) VALUES ('Máquina de press de hombros', 'Valor Fitness');
INSERT INTO elemento (elemento, marca) VALUES ('Máquina de glúteos', 'Body-Solid');
INSERT INTO elemento (elemento, marca) VALUES ('Chaleco de sauna', 'TNT Pro Series');
INSERT INTO elemento (elemento, marca) VALUES ('Barra de dominadas', 'Ultimate Body Press');
INSERT INTO elemento (elemento, marca) VALUES ('Discos de competición', 'Rogue');
INSERT INTO elemento (elemento, marca) VALUES ('Cinta de yoga', 'Manduka');
INSERT INTO elemento (elemento, marca) VALUES ('Cinturón de levantamiento de pesas', 'Harbinger');
INSERT INTO elemento (elemento, marca) VALUES ('Guantes de entrenamiento', 'Nike');
INSERT INTO elemento (elemento, marca) VALUES ('Soporte de discos', 'Body-Solid');
INSERT INTO elemento (elemento, marca) VALUES ('Máquina de pecho', 'Life Fitness');
INSERT INTO elemento (elemento, marca) VALUES ('Estación de barras paralelas', 'Lebert Fitness');
INSERT INTO elemento (elemento, marca) VALUES ('Cuerda de escalada', 'Titan Fitness');
INSERT INTO elemento (elemento, marca) VALUES ('Soporte para mancuernas', 'Body-Solid');
INSERT INTO elemento (elemento, marca) VALUES ('Disco de 5kg', 'Rogue');
INSERT INTO elemento (elemento, marca) VALUES ('Disco de 10kg', 'Rogue');
INSERT INTO elemento (elemento, marca) VALUES ('Disco de 15kg', 'Rogue');
INSERT INTO elemento (elemento, marca) VALUES ('Disco de 20kg', 'Rogue');
INSERT INTO elemento (elemento, marca) VALUES ('Mancuerna de 2kg', 'Bowflex');
INSERT INTO elemento (elemento, marca) VALUES ('Mancuerna de 4kg', 'Bowflex');
INSERT INTO elemento (elemento, marca) VALUES ('Mancuerna de 6kg', 'Bowflex');
INSERT INTO elemento (elemento, marca) VALUES ('Mancuerna de 8kg', 'Bowflex');
INSERT INTO elemento (elemento, marca) VALUES ('Mancuerna de 10kg', 'Bowflex');
INSERT INTO elemento (elemento, marca) VALUES ('Mancuerna de 12kg', 'Bowflex');
INSERT INTO elemento (elemento, marca) VALUES ('Mancuerna de 14kg', 'Bowflex');
INSERT INTO elemento (elemento, marca) VALUES ('Mancuerna de 16kg', 'Bowflex');
INSERT INTO elemento (elemento, marca) VALUES ('Mancuerna de 18kg', 'Bowflex');
INSERT INTO elemento (elemento, marca) VALUES ('Mancuerna de 20kg', 'Bowflex');
INSERT INTO elemento (elemento, marca) VALUES ('Mancuerna de 22kg', 'Bowflex');
INSERT INTO elemento (elemento, marca) VALUES ('Mancuerna de 24kg', 'Bowflex');
INSERT INTO elemento (elemento, marca) VALUES ('Mancuerna de 26kg', 'Bowflex');
INSERT INTO elemento (elemento, marca) VALUES ('Mancuerna de 28kg', 'Bowflex');
INSERT INTO elemento (elemento, marca) VALUES ('Mancuerna de 30kg', 'Bowflex');
INSERT INTO elemento (elemento, marca) VALUES ('Mancuerna de 32kg', 'Bowflex');
INSERT INTO elemento (elemento, marca) VALUES ('Mancuerna de 34kg', 'Bowflex');
INSERT INTO elemento (elemento, marca) VALUES ('Mancuerna de 36kg', 'Bowflex');
INSERT INTO elemento (elemento, marca) VALUES ('Mancuerna de 38kg', 'Bowflex');
INSERT INTO elemento (elemento, marca) VALUES ('Mancuerna de 40kg', 'Bowflex');
INSERT INTO elemento (elemento, marca) VALUES ('Chaleco salvavidas', 'Speedo');
INSERT INTO elemento (elemento, marca) VALUES ('Flotador de entrenamiento', 'AquaJogger');
INSERT INTO elemento (elemento, marca) VALUES ('Red de seguridad para piscina', 'Pool Guard');
INSERT INTO elemento (elemento, marca) VALUES ('Escalera para piscina', 'Intex');
INSERT INTO elemento (elemento, marca) VALUES ('Sistema de filtración de piscina', 'Hayward');
INSERT INTO elemento (elemento, marca) VALUES ('Vitrina de exhibición', 'Ikea');
INSERT INTO elemento (elemento, marca) VALUES ('Mostrador de atención', 'Ikea');
INSERT INTO elemento (elemento, marca) VALUES ('Estantería de almacenamiento', 'AmazonBasics');
INSERT INTO elemento (elemento, marca) VALUES ('Caja registradora', 'Sharp');
INSERT INTO elemento (elemento, marca) VALUES ('Refrigerador para bebidas', 'Frigidaire');
INSERT INTO elemento (elemento, marca) VALUES ('Soporte para folletos', 'Displays2go');
INSERT INTO elemento (elemento, marca) VALUES ('Sistema de punto de venta', 'Square');
INSERT INTO elemento (elemento, marca) VALUES ('Carro de almacenamiento', 'Seville Classics');
INSERT INTO elemento (elemento, marca) VALUES ('Iluminación para vitrinas', 'Philips');
-----------------------------------------------------

-----------------------------------------------------
--Caracteristica
INSERT INTO caracteristica (caracteristica) VALUES ('Gimansio');
INSERT INTO caracteristica (caracteristica) VALUES ('Zona de cardio');
INSERT INTO caracteristica (caracteristica) VALUES ('Zona de funcional');
INSERT INTO caracteristica (caracteristica) VALUES ('area de boxeo y artes marciales');
INSERT INTO caracteristica (caracteristica) VALUES ('Tienda');
INSERT INTO caracteristica (caracteristica) VALUES ('Zona de rehabilitaci�n y fisioterapia');
INSERT INTO caracteristica (caracteristica) VALUES ('Zona para niños');
INSERT INTO caracteristica (caracteristica) VALUES ('Piscina');
INSERT INTO caracteristica (caracteristica) VALUES ('Turco');
-----------------------------------------------------

-----------------------------------------------------
--Departamentos
INSERT INTO departamento (departamento) VALUES ('Entrenamiento');
INSERT INTO departamento (departamento) VALUES ('Fisioterapia');
INSERT INTO departamento (departamento) VALUES ('Ninez');
INSERT INTO departamento (departamento) VALUES ('Mantenimiento');
INSERT INTO departamento (departamento) VALUES ('Atencion al cliente');
INSERT INTO departamento (departamento) VALUES ('Nutricion');
INSERT INTO departamento (departamento) VALUES ('Legal');
INSERT INTO departamento (departamento) VALUES ('Marketing');
INSERT INTO departamento (departamento) VALUES ('Administrativo');
-----------------------------------------------------

-----------------------------------------------------
--Cargos
INSERT INTO cargo (cargo, id_departamento) VALUES ('Entrenador Personal', 1);
INSERT INTO cargo (cargo, id_departamento) VALUES ('Instructor de Clases Grupales', 1);
INSERT INTO cargo (cargo, id_departamento) VALUES ('Coordinador de Entrenamiento', 1);
INSERT INTO cargo (cargo, id_departamento) VALUES ('Fisioterapeuta', 2);
INSERT INTO cargo (cargo, id_departamento) VALUES ('Rehabilitador Deportivo', 2);
INSERT INTO cargo (cargo, id_departamento) VALUES ('Asistente de Fisioterapia', 2);
INSERT INTO cargo (cargo, id_departamento) VALUES ('Instructor de Actividades para Ninos', 3);
INSERT INTO cargo (cargo, id_departamento) VALUES ('Cuidador', 3);
INSERT INTO cargo (cargo, id_departamento) VALUES ('Operario de Mantenimiento', 4);
INSERT INTO cargo (cargo, id_departamento) VALUES ('Jefe de Mantenimiento', 4);
INSERT INTO cargo (cargo, id_departamento) VALUES ('Auxiliar de servicios generales', 4);
INSERT INTO cargo (cargo, id_departamento) VALUES ('Auxiliar de Atencion al Cliente', 5);
INSERT INTO cargo (cargo, id_departamento) VALUES ('Coordinador de Servicio al Cliente', 5);
INSERT INTO cargo (cargo, id_departamento) VALUES ('Nutricionista', 6);
INSERT INTO cargo (cargo, id_departamento) VALUES ('Asesor de Suplementacion', 6);
INSERT INTO cargo (cargo, id_departamento) VALUES ('Abogado Corporativo', 7);
INSERT INTO cargo (cargo, id_departamento) VALUES ('Asistente Legal', 7);
INSERT INTO cargo (cargo, id_departamento) VALUES ('Gerente de Marketing', 8);
INSERT INTO cargo (cargo, id_departamento) VALUES ('Publicista', 8);
INSERT INTO cargo (cargo, id_departamento) VALUES ('Disenador', 8);
INSERT INTO cargo (cargo, id_departamento) VALUES ('Gerente de general', 9);
INSERT INTO cargo (cargo, id_departamento) VALUES ('Gerente de sede', 9);
INSERT INTO cargo (cargo, id_departamento) VALUES ('Contador', 9);
INSERT INTO cargo (cargo, id_departamento) VALUES ('Asistente Administrativo', 9);
-----------------------------------------------------

-----------------------------------------------------
-- Membresías
INSERT INTO membresia (membresia, descripcion, precio_mes, precio_anual) VALUES
('Básica', 'Acceso 4 días a la semana a todas las instalaciones y 4 clases grupales durante un mes.', 30.00, 300.00);

INSERT INTO membresia (membresia, descripcion, precio_mes, precio_anual) VALUES
('Premium', 'Acceso ilimitado a todas las instalaciones y clases grupales ilimitadas.', 50.00, 500.00);

INSERT INTO membresia (membresia, descripcion, precio_mes, precio_anual) VALUES
('VIP', 'Acceso ilimitado a todas las instalaciones, clases grupales ilimitadas y entrenador personal.', 80.00, 800.00);

INSERT INTO membresia (membresia, descripcion, precio_mes, precio_anual) VALUES
('Familiar', 'Membresía para 4 personas, acceso a todas las instalaciones 4 veces a la semana y 4 clases grupales durante un mes para cada uno de los miembros de la familia.', 100.00, 1000.00);

INSERT INTO membresia (membresia, descripcion, precio_mes, precio_anual) VALUES
('Estudiante', 'Descuento para estudiantes, 4 días a la semana a todas las instalaciones y 4 clases grupales durante un mes.', 25.00, 250.00);

INSERT INTO membresia (membresia, descripcion, precio_mes, precio_anual) VALUES
('Corporativa', 'Membresía para empresas, acceso ilimitado a todas las instalaciones y clases grupales ilimitadas.', 200.00, 2000.00);

INSERT INTO membresia (membresia, descripcion, precio_mes, precio_anual) VALUES
('Weekend Warrior', 'Acceso a las instalaciones solo los fines de semana y días festivos.', 15.00, 150.00);

INSERT INTO membresia (membresia, descripcion, precio_mes, precio_anual) VALUES
('Platinum', 'Acceso VIP más nutricionista y 4 fisioterapias al mes.', 120.00, 1200.00);

INSERT INTO membresia (membresia, descripcion, precio_mes, precio_anual) VALUES
('Senior', 'Descuento para personas mayores de 65 años, acceso ilimitado a todas las instalaciones y clases especiales.', 20.00, 200.00);

INSERT INTO membresia (membresia, descripcion, precio_mes, precio_anual) VALUES
('Day Pass', 'Acceso por un día a todas las instalaciones.', 10.00, 100.00);

INSERT INTO membresia (membresia, precio_mes, precio_anual) VALUES
('No miembro', 0, 0);
-----------------------------------------------------

-----------------------------------------------------
-- Productos
INSERT INTO producto (producto, descripcion) VALUES ('Proteína Whey', 'Proteína de suero de leche para aumentar masa muscular.');
INSERT INTO producto (producto, descripcion) VALUES ('Creatina Monohidrato', 'Suplemento para mejorar el rendimiento y la fuerza.');
INSERT INTO producto (producto, descripcion) VALUES ('BCAA', 'Aminoácidos de cadena ramificada para la recuperación muscular.');
INSERT INTO producto (producto, descripcion) VALUES ('Preentreno Explosivo', 'Suplemento preentrenamiento para energía y enfoque.');
INSERT INTO producto (producto, descripcion) VALUES ('Glutamina', 'Aminoácido para la recuperación muscular y la función inmunológica.');
INSERT INTO producto (producto, descripcion) VALUES ('Omega 3', 'Suplemento de ácidos grasos esenciales para la salud cardiovascular.');
INSERT INTO producto (producto, descripcion) VALUES ('Multivitamínico', 'Complejo multivitamínico para apoyo nutricional diario.');
INSERT INTO producto (producto, descripcion) VALUES ('Proteína Vegetal', 'Proteína a base de plantas para dietas veganas y vegetarianas.');
INSERT INTO producto (producto, descripcion) VALUES ('Quemador de Grasa', 'Suplemento para ayudar en la pérdida de peso.');
INSERT INTO producto (producto, descripcion) VALUES ('Barra de Proteína', 'Snack alto en proteínas para después del entrenamiento.');
INSERT INTO producto (producto, descripcion) VALUES ('Gainer', 'Suplemento para ganar masa muscular y peso.');
INSERT INTO producto (producto, descripcion) VALUES ('Aminoácidos Esenciales', 'Aminoácidos esenciales para la recuperación y el crecimiento muscular.');
INSERT INTO producto (producto, descripcion) VALUES ('Caseína', 'Proteína de liberación lenta para la recuperación nocturna.');
INSERT INTO producto (producto, descripcion) VALUES ('Batido de Reemplazo de Comidas', 'Suplemento para reemplazar comidas y mantener el peso.');
INSERT INTO producto (producto, descripcion) VALUES ('L-Carnitina', 'Suplemento para mejorar el metabolismo de las grasas.');
INSERT INTO producto (producto, descripcion) VALUES ('Proteína Hidrolizada', 'Proteína de rápida absorción para la recuperación muscular.');
INSERT INTO producto (producto, descripcion) VALUES ('Suero de Leche Isolado', 'Proteína aislada de suero de leche para mayor pureza.');
INSERT INTO producto (producto, descripcion) VALUES ('ZMA', 'Suplemento de zinc, magnesio y vitamina B6 para mejorar el sueño y la recuperación.');
INSERT INTO producto (producto, descripcion) VALUES ('Ácido Hialurónico', 'Suplemento para la salud de las articulaciones y la piel.');
INSERT INTO producto (producto, descripcion) VALUES ('Beta-Alanina', 'Suplemento para mejorar la resistencia muscular y reducir la fatiga.');
-----------------------------------------------------

-----------------------------------------------------
-- Sedes
-- Bogotá (capital)1-2
INSERT INTO sede (sede, direccion, telefono, id_ciudad) VALUES ('Sede Norte', 'Calle 100 #15-20', '3001234567', 1);
INSERT INTO sede (sede, direccion, telefono, id_ciudad) VALUES ('Sede Centro', 'Carrera 7 #45-10', '3009876543', 1);

-- Soacha 3
INSERT INTO sede (sede, direccion, telefono, id_ciudad) VALUES ('Sede Soacha', 'Carrera 10 #4-15', '3008765432', 2);

-- Medellín (capital) 4-5
INSERT INTO sede (sede, direccion, telefono, id_ciudad) VALUES ('Sede Poblado', 'Calle 10 #43-25', '3001231234', 3);
INSERT INTO sede (sede, direccion, telefono, id_ciudad) VALUES ('Sede Laureles', 'Avenida Nutibara #70-30', '3009876541', 3);

-- Envigado 6
INSERT INTO sede (sede, direccion, telefono, id_ciudad) VALUES ('Sede Envigado', 'Calle 38 Sur #15-20', '3002211445', 4);

-- Armenia (capital) 7
INSERT INTO sede (sede, direccion, telefono, id_ciudad) VALUES ('Sede Armenia', 'Carrera 14 #18-20', '3003344556', 5);

-- Quito (capital) 8
INSERT INTO sede (sede, direccion, telefono, id_ciudad) VALUES ('Sede Norte Quito', 'Avenida Amazonas #35-20', '3005566778', 6);

-- Sangolquí 9
INSERT INTO sede (sede, direccion, telefono, id_ciudad) VALUES ('Sede Sangolquí', 'Avenida General Rumiñahui #5-25', '3007788990', 7);

-- Guayaquil (capital) 10
INSERT INTO sede (sede, direccion, telefono, id_ciudad) VALUES ('Sede Norte Guayaquil', 'Avenida 9 de Octubre #30-15', '3009900112', 8);

-- Cuenca (capital) 11
INSERT INTO sede (sede, direccion, telefono, id_ciudad) VALUES ('Sede Cuenca', 'Calle Bolívar #20-15', '3002233445', 9);

-- Lima (capital) 12
INSERT INTO sede (sede, direccion, telefono, id_ciudad) VALUES ('Sede Lima Sur', 'Avenida Javier Prado #45-20', '3003344556', 10);

-- Miraflores 13
INSERT INTO sede (sede, direccion, telefono, id_ciudad) VALUES ('Sede Miraflores', 'Avenida Pardo #12-30', '3005566778', 11);

-- Buenos Aires (capital) 14-15
INSERT INTO sede (sede, direccion, telefono, id_ciudad) VALUES ('Sede Palermo', 'Avenida Santa Fe #45-30', '3008899001', 12);
INSERT INTO sede (sede, direccion, telefono, id_ciudad) VALUES ('Sede Recoleta', 'Calle Pueyrredón #10-20', '3009900112', 12);

-- La Plata 16
INSERT INTO sede (sede, direccion, telefono, id_ciudad) VALUES ('Sede La Plata', 'Calle 7 #34-25', '3000011223', 13);

-- Santiago (capital) 17-18
INSERT INTO sede (sede, direccion, telefono, id_ciudad) VALUES ('Sede Providencia', 'Avenida Providencia #30-20', '3007788990', 14);
INSERT INTO sede (sede, direccion, telefono, id_ciudad) VALUES ('Sede Las Condes', 'Avenida Apoquindo #45-15', '3008899001', 14);

-- Ciudad de Mexico (capital) 19-20
INSERT INTO sede (sede, direccion, telefono, id_ciudad) VALUES ('Sede Polanco', 'Avenida Presidente Masaryk #45-30', '3004455667', 15);
INSERT INTO sede (sede, direccion, telefono, id_ciudad) VALUES ('Sede Roma', 'Calle Álvaro Obregón #20-15', '3005566778', 15);

-- Iztapalapa 21
INSERT INTO sede (sede, direccion, telefono, id_ciudad) VALUES ('Sede Iztapalapa', 'Avenida Tláhuac #15-20', '3006677889', 16);

-- Guadalajara (capital) 22
INSERT INTO sede (sede, direccion, telefono, id_ciudad) VALUES ('Sede Guadalajara Centro', 'Avenida Juárez #45-10', '3008899001', 17);

-- Panama (capital) 23-24
INSERT INTO sede (sede, direccion, telefono, id_ciudad) VALUES ('Sede Panamá Centro', 'Avenida Balboa #25-10', '3004455667', 18);
INSERT INTO sede (sede, direccion, telefono, id_ciudad) VALUES ('Sede Albrook', 'Calle 72 #15-20', '3005566778', 18);

-- Barcelona (capital) 25-26
INSERT INTO sede (sede, direccion, telefono, id_ciudad) VALUES ('Sede Barcelona Centro', 'Calle Gran Vía #45-30', '3001122334', 19);
INSERT INTO sede (sede, direccion, telefono, id_ciudad) VALUES ('Sede Eixample', 'Avenida Diagonal #10-15', '3002233445', 19);

-- Tarragona 27
INSERT INTO sede (sede, direccion, telefono, id_ciudad) VALUES ('Sede Tarragona', 'Calle Ramón y Cajal #20-25', '3003344556', 20);

-- Madrid (capital) 28-29
INSERT INTO sede (sede, direccion, telefono, id_ciudad) VALUES ('Sede Madrid Centro', 'Gran Vía #20-10', '3005566778', 21);
INSERT INTO sede (sede, direccion, telefono, id_ciudad) VALUES ('Sede Madrid Norte', 'Avenida de América #15-25', '3006677889', 21);

-- Getafe 30
INSERT INTO sede (sede, direccion, telefono, id_ciudad) VALUES ('Sede Getafe', 'Calle Madrid #25-15', '3008899001', 22);
-----------------------------------------------------

-----------------------------------------------------
--caracteristicas_sede
--Sede 1
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (1, 1);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (1, 2);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (1, 3);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (1, 4);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (1, 5);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (1, 6);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (1, 7);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (1, 8);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (1, 9);

--Sede 2
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (2, 1);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (2, 2);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (2, 3);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (2, 4);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (2, 5);

--sede 3
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (3, 1);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (3, 2);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (3, 3);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (3, 4);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (3, 5);

--sede 4
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (4, 1);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (4, 2);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (4, 3);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (4, 4);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (4, 5);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (4, 6);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (4, 7);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (4, 8);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (4, 9);

--sede 5
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (5, 1);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (5, 2);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (5, 3);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (5, 4);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (5, 5);

--sede 6
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (6, 1);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (6, 2);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (6, 3);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (6, 4);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (6, 5);

--sede 7
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (7, 1);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (7, 2);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (7, 3);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (7, 4);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (7, 5);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (7, 6);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (7, 7);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (7, 8);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (7, 9);

--sede 8
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (8, 1);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (8, 2);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (8, 3);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (8, 4);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (8, 5);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (8, 6);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (8, 7);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (8, 8);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (8, 9);

--sede 19
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (9, 1);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (9, 2);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (9, 3);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (9, 4);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (9, 5);

--sede 10
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (10, 1);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (10, 2);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (10, 3);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (10, 4);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (10, 5);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (10, 6);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (10, 7);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (10, 8);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (10, 9);

--sede 11
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (11, 1);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (11, 2);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (11, 3);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (11, 4);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (11, 5);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (11, 6);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (11, 7);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (11, 8);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (11, 9);

--sede 12
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (12, 1);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (12, 2);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (12, 3);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (12, 4);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (12, 5);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (12, 6);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (12, 7);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (12, 8);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (12, 9);

--sede 13
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (13, 1);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (13, 2);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (13, 3);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (13, 4);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (13, 5);

--sede 14
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (14, 1);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (14, 2);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (14, 3);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (14, 4);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (14, 5);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (14, 6);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (14, 7);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (14, 8);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (14, 9);

--sede 15
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (15, 1);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (15, 2);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (15, 3);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (15, 4);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (15, 5);

--sede 16
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (16, 1);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (16, 2);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (16, 3);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (16, 4);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (16, 5);

--sede 17
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (17, 1);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (17, 2);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (17, 3);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (17, 4);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (17, 5);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (17, 6);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (17, 7);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (17, 8);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (17, 9);

--sede 18
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (18, 1);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (18, 2);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (18, 3);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (18, 4);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (18, 5);

--sede 19
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (19, 1);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (19, 2);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (19, 3);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (19, 4);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (19, 5);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (19, 6);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (19, 7);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (19, 8);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (19, 9);

--sede 20
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (20, 1);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (20, 2);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (20, 3);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (20, 4);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (20, 5);

--sede 21
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (21, 1);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (21, 2);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (21, 3);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (21, 4);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (21, 5);

--sede 22
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (22, 1);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (22, 2);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (22, 3);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (22, 4);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (22, 5);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (22, 6);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (22, 7);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (22, 8);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (22, 9);

--sede 23
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (23, 1);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (23, 2);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (23, 3);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (23, 4);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (23, 5);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (23, 6);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (23, 7);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (23, 8);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (23, 9);

--sede 24
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (24, 1);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (24, 2);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (24, 3);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (24, 4);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (24, 5);

--sede 25
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (25, 1);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (25, 2);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (25, 3);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (25, 4);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (25, 5);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (25, 6);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (25, 7);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (25, 8);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (25, 9);

--sede 26
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (26, 1);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (26, 2);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (26, 3);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (26, 4);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (26, 5);

--sede 27
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (27, 1);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (27, 2);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (27, 3);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (27, 4);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (27, 5);

--sede 28
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (28, 1);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (28, 2);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (28, 3);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (28, 4);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (28, 5);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (28, 6);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (28, 7);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (28, 8);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (28, 9);

--sede 29
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (29, 1);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (29, 2);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (29, 3);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (29, 4);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (29, 5);

--sede 30
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (30, 1);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (30, 2);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (30, 3);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (30, 4);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (30, 5);
-----------------------------------------------------

-----------------------------------------------------
--elementos_sede
--Sedes grandes
--sede 1
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (1, 1, 10);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (2, 1, 20);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (3, 1, 10);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (4, 1, 4);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (5, 1, 5);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (6, 1, 10);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (7, 1, 4);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (8, 1, 8);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (9, 1, 7);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (10, 1, 5);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (11, 1, 9);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (12, 1, 6);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (13, 1, 10);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (14, 1, 8);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (15, 1, 5);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (16, 1, 7);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (17, 1, 4);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (18, 1, 9);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (19, 1, 10);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (20, 1, 6);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (21, 1, 7);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (22, 1, 8);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (23, 1, 5);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (24, 1, 10);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (25, 1, 4);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (26, 1, 9);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (27, 1, 8);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (28, 1, 6);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (29, 1, 7);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (30, 1, 10);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (31, 1, 5);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (32, 1, 9);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (33, 1, 8);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (34, 1, 4);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (35, 1, 10);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (36, 1, 7);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (37, 1, 6);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (38, 1, 8);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (39, 1, 5);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (40, 1, 9);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (41, 1, 10);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (42, 1, 4);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (43, 1, 7);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (44, 1, 8);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (45, 1, 6);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (46, 1, 5);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (47, 1, 9);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (48, 1, 10);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (49, 1, 6);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (50, 1, 7);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (51, 1, 4);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (52, 1, 8);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (53, 1, 9);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (54, 1, 5);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (55, 1, 7);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (56, 1, 10);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (57, 1, 8);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (58, 1, 6);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (59, 1, 9);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (60, 1, 7);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (61, 1, 10);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (62, 1, 5);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (63, 1, 8);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (64, 1, 6);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (65, 1, 9);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (66, 1, 7);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (67, 1, 4);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (68, 1, 10);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (69, 1, 5);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (70, 1, 8);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (71, 1, 7);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (72, 1, 9);

INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (73, 1, 10);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (74, 1, 10);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (75, 1, 2);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (76, 1, 2);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (77, 1, 1);

INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (78, 1, 1);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (79, 1, 1);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (80, 1, 1);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (81, 1, 1);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (82, 1, 1);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (83, 1, 1);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (84, 1, 1);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (85, 1, 1);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (86, 1, 1);

--sede 4
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (1, 4, 10);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (2, 4, 20);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (3, 4, 10);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (4, 4, 4);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (5, 4, 5);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (6, 4, 10);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (7, 4, 4);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (8, 4, 8);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (9, 4, 7);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (10, 4, 5);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (11, 4, 9);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (12, 4, 6);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (13, 4, 10);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (14, 4, 8);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (15, 4, 5);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (16, 4, 7);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (17, 4, 4);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (18, 4, 9);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (19, 4, 10);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (20, 4, 6);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (21, 4, 7);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (22, 4, 8);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (23, 4, 5);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (24, 4, 10);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (25, 4, 4);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (26, 4, 9);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (27, 4, 8);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (28, 4, 6);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (29, 4, 7);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (30, 4, 10);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (31, 4, 5);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (32, 4, 9);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (33, 4, 8);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (34, 4, 4);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (35, 4, 10);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (36, 4, 7);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (37, 4, 6);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (38, 4, 8);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (39, 4, 5);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (40, 4, 9);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (41, 4, 10);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (42, 4, 4);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (43, 4, 7);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (44, 4, 8);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (45, 4, 6);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (46, 4, 5);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (47, 4, 9);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (48, 4, 10);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (49, 4, 6);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (50, 4, 7);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (51, 4, 4);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (52, 4, 8);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (53, 4, 9);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (54, 4, 5);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (55, 4, 7);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (56, 4, 10);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (57, 4, 8);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (58, 4, 6);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (59, 4, 9);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (60, 4, 7);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (61, 4, 10);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (62, 4, 5);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (63, 4, 8);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (64, 4, 6);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (65, 4, 9);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (66, 4, 7);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (67, 4, 4);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (68, 4, 10);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (69, 4, 5);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (70, 4, 8);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (71, 4, 7);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (72, 4, 9);

INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (73, 4, 10);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (74, 4, 10);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (75, 4, 2);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (76, 4, 2);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (77, 4, 1);

INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (78, 4, 1);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (79, 4, 1);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (80, 4, 1);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (81, 4, 1);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (82, 4, 1);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (83, 4, 1);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (84, 4, 1);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (85, 4, 1);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (86, 4, 1);

--sede 7
-- Insertar todos los elementos en la sede 7

INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (1, 7, 15);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (2, 7, 25);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (3, 7, 15);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (4, 7, 9);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (5, 7, 10);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (6, 7, 15);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (7, 7, 9);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (8, 7, 13);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (9, 7, 12);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (10, 7, 10);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (11, 7, 14);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (12, 7, 11);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (13, 7, 15);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (14, 7, 13);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (15, 7, 10);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (16, 7, 12);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (17, 7, 9);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (18, 7, 14);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (19, 7, 15);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (20, 7, 11);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (21, 7, 12);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (22, 7, 13);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (23, 7, 10);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (24, 7, 15);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (25, 7, 9);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (26, 7, 14);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (27, 7, 13);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (28, 7, 11);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (29, 7, 12);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (30, 7, 15);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (31, 7, 10);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (32, 7, 14);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (33, 7, 13);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (34, 7, 9);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (35, 7, 15);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (36, 7, 12);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (37, 7, 11);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (38, 7, 13);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (39, 7, 10);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (40, 7, 14);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (41, 7, 15);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (42, 7, 9);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (43, 7, 12);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (44, 7, 13);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (45, 7, 11);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (46, 7, 10);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (47, 7, 14);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (48, 7, 15);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (49, 7, 11);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (50, 7, 12);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (51, 7, 9);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (52, 7, 13);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (53, 7, 14);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (54, 7, 10);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (55, 7, 12);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (56, 7, 15);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (57, 7, 13);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (58, 7, 11);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (59, 7, 14);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (60, 7, 12);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (61, 7, 15);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (62, 7, 10);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (63, 7, 13);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (64, 7, 11);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (65, 7, 14);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (66, 7, 12);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (67, 7, 9);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (68, 7, 15);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (69, 7, 10);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (70, 7, 13);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (71, 7, 12);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (72, 7, 14);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (73, 7, 20);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (74, 7, 25);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (75, 7, 40);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (76, 7, 30);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (77, 7, 7);


INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (78, 7, 1);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (79, 7, 1);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (80, 7, 1);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (81, 7, 1);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (82, 7, 1);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (83, 7, 1);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (84, 7, 1);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (85, 7, 1);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (86, 7, 1);

--sede 8
-- Insertar todos los elementos en la sede 8

INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (1, 8, 15);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (2, 8, 25);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (3, 8, 15);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (4, 8, 9);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (5, 8, 10);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (6, 8, 15);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (7, 8, 9);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (8, 8, 13);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (9, 8, 12);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (10, 8, 10);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (11, 8, 14);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (12, 8, 11);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (13, 8, 15);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (14, 8, 13);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (15, 8, 10);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (16, 8, 12);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (17, 8, 9);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (18, 8, 14);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (19, 8, 15);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (20, 8, 11);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (21, 8, 12);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (22, 8, 13);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (23, 8, 10);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (24, 8, 15);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (25, 8, 9);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (26, 8, 14);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (27, 8, 13);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (28, 8, 11);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (29, 8, 12);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (30, 8, 15);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (31, 8, 10);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (32, 8, 14);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (33, 8, 13);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (34, 8, 9);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (35, 8, 15);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (36, 8, 12);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (37, 8, 11);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (38, 8, 13);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (39, 8, 10);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (40, 8, 14);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (41, 8, 15);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (42, 8, 9);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (43, 8, 12);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (44, 8, 13);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (45, 8, 11);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (46, 8, 10);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (47, 8, 14);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (48, 8, 15);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (49, 8, 11);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (50, 8, 12);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (51, 8, 9);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (52, 8, 13);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (53, 8, 14);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (54, 8, 10);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (55, 8, 12);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (56, 8, 15);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (57, 8, 13);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (58, 8, 11);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (59, 8, 14);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (60, 8, 12);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (61, 8, 15);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (62, 8, 10);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (63, 8, 13);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (64, 8, 11);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (65, 8, 14);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (66, 8, 12);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (67, 8, 9);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (68, 8, 15);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (69, 8, 10);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (70, 8, 13);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (71, 8, 12);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (72, 8, 14);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (73, 8, 21);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (74, 8, 12);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (75, 8, 13);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (76, 8, 14);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (77, 8, 16);

INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (78, 8, 1);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (79, 8, 1);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (80, 8, 1);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (81, 8, 1);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (82, 8, 1);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (83, 8, 1);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (84, 8, 1);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (85, 8, 1);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (86, 8, 1);

--sede 11
-- Insertar todos los elementos en la sede 11

INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (1, 11, 15);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (2, 11, 25);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (3, 11, 15);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (4, 11, 9);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (5, 11, 10);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (6, 11, 15);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (7, 11, 9);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (8, 11, 13);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (9, 11, 12);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (10, 11, 10);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (11, 11, 14);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (12, 11, 11);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (13, 11, 15);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (14, 11, 13);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (15, 11, 10);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (16, 11, 12);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (17, 11, 9);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (18, 11, 14);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (19, 11, 15);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (20, 11, 11);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (21, 11, 12);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (22, 11, 13);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (23, 11, 10);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (24, 11, 15);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (25, 11, 9);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (26, 11, 14);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (27, 11, 13);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (28, 11, 11);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (29, 11, 12);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (30, 11, 15);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (31, 11, 10);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (32, 11, 14);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (33, 11, 13);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (34, 11, 9);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (35, 11, 15);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (36, 11, 12);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (37, 11, 11);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (38, 11, 13);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (39, 11, 10);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (40, 11, 14);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (41, 11, 15);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (42, 11, 9);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (43, 11, 12);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (44, 11, 13);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (45, 11, 11);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (46, 11, 10);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (47, 11, 14);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (48, 11, 15);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (49, 11, 11);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (50, 11, 12);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (51, 11, 9);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (52, 11, 13);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (53, 11, 14);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (54, 11, 10);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (55, 11, 12);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (56, 11, 15);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (57, 11, 13);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (58, 11, 11);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (59, 11, 14);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (60, 11, 12);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (61, 11, 15);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (62, 11, 10);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (63, 11, 13);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (64, 11, 11);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (65, 11, 14);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (66, 11, 12);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (67, 11, 9);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (68, 11, 15);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (69, 11, 10);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (70, 11, 13);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (71, 11, 12);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (72, 11, 14);


INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (78, 11, 1);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (79, 11, 1);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (80, 11, 1);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (81, 11, 1);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (82, 11, 1);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (83, 11, 1);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (84, 11, 1);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (85, 11, 1);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (86, 11, 1);


--sede 12
-- Insertar todos los elementos en la sede 12

INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (1, 12, 14);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (2, 12, 24);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (3, 12, 14);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (4, 12, 8);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (5, 12, 9);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (6, 12, 14);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (7, 12, 8);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (8, 12, 12);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (9, 12, 11);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (10, 12, 9);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (11, 12, 13);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (12, 12, 10);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (13, 12, 14);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (14, 12, 12);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (15, 12, 9);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (16, 12, 11);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (17, 12, 8);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (18, 12, 13);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (19, 12, 14);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (20, 12, 10);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (21, 12, 11);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (22, 12, 12);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (23, 12, 9);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (24, 12, 14);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (25, 12, 8);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (26, 12, 13);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (27, 12, 12);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (28, 12, 10);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (29, 12, 11);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (30, 12, 14);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (31, 12, 9);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (32, 12, 13);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (33, 12, 12);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (34, 12, 8);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (35, 12, 14);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (36, 12, 11);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (37, 12, 10);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (38, 12, 12);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (39, 12, 9);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (40, 12, 13);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (41, 12, 14);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (42, 12, 8);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (43, 12, 11);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (44, 12, 12);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (45, 12, 10);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (46, 12, 9);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (47, 12, 13);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (48, 12, 14);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (49, 12, 10);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (50, 12, 11);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (51, 12, 8);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (52, 12, 12);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (53, 12, 13);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (54, 12, 9);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (55, 12, 14);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (56, 12, 15);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (57, 12, 11);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (58, 12, 13);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (59, 12, 10);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (60, 12, 12);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (61, 12, 14);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (62, 12, 9);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (63, 12, 13);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (64, 12, 10);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (65, 12, 11);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (66, 12, 15);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (67, 12, 8);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (68, 12, 14);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (69, 12, 12);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (70, 12, 9);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (71, 12, 11);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (72, 12, 15);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (73, 12, 15);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (74, 12, 16);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (75, 12, 19);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (76, 12, 10);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (77, 12, 11);


INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (78, 12, 1);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (79, 12, 1);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (80, 12, 1);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (81, 12, 1);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (82, 12, 1);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (83, 12, 1);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (84, 12, 1);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (85, 12, 1);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (86, 12, 1);

--sede 14
-- Insertar todos los elementos en la sede 14

INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (1, 14, 14);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (2, 14, 24);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (3, 14, 14);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (4, 14, 8);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (5, 14, 9);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (6, 14, 14);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (7, 14, 8);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (8, 14, 12);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (9, 14, 11);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (10, 14, 9);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (11, 14, 13);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (12, 14, 10);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (13, 14, 14);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (14, 14, 12);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (15, 14, 9);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (16, 14, 11);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (17, 14, 8);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (18, 14, 13);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (19, 14, 14);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (20, 14, 10);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (21, 14, 11);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (22, 14, 12);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (23, 14, 9);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (24, 14, 14);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (25, 14, 8);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (26, 14, 13);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (27, 14, 12);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (28, 14, 10);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (29, 14, 11);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (30, 14, 14);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (31, 14, 9);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (32, 14, 13);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (33, 14, 12);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (34, 14, 8);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (35, 14, 14);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (36, 14, 11);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (37, 14, 10);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (38, 14, 12);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (39, 14, 9);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (40, 14, 13);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (41, 14, 14);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (42, 14, 8);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (43, 14, 11);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (44, 14, 12);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (45, 14, 10);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (46, 14, 9);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (47, 14, 13);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (48, 14, 14);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (49, 14, 10);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (50, 14, 11);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (51, 14, 8);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (52, 14, 12);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (53, 14, 13);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (54, 14, 9);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (55, 14, 14);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (56, 14, 15);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (57, 14, 11);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (58, 14, 13);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (59, 14, 10);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (60, 14, 12);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (61, 14, 14);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (62, 14, 9);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (63, 14, 13);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (64, 14, 10);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (65, 14, 11);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (66, 14, 15);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (67, 14, 8);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (68, 14, 14);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (69, 14, 12);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (70, 14, 9);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (71, 14, 11);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (72, 14, 15);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (73, 14, 19);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (74, 14, 19);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (75, 14, 81);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (76, 14, 17);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (77, 14, 14);

INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (78, 14, 1);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (79, 14, 1);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (80, 14, 1);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (81, 14, 1);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (82, 14, 1);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (83, 14, 1);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (84, 14, 1);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (85, 14, 1);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (86, 14, 1);

--sede 17
-- Insertar todos los elementos en la sede 17

INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (1, 17, 14);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (2, 17, 24);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (3, 17, 14);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (4, 17, 8);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (5, 17, 9);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (6, 17, 14);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (7, 17, 8);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (8, 17, 12);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (9, 17, 11);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (10, 17, 9);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (11, 17, 13);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (12, 17, 10);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (13, 17, 14);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (14, 17, 12);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (15, 17, 9);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (16, 17, 11);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (17, 17, 8);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (18, 17, 13);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (19, 17, 14);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (20, 17, 10);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (21, 17, 11);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (22, 17, 12);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (23, 17, 9);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (24, 17, 14);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (25, 17, 8);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (26, 17, 13);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (27, 17, 12);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (28, 17, 10);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (29, 17, 11);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (30, 17, 14);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (31, 17, 9);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (32, 17, 13);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (33, 17, 12);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (34, 17, 8);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (35, 17, 14);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (36, 17, 11);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (37, 17, 10);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (38, 17, 12);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (39, 17, 9);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (40, 17, 13);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (41, 17, 14);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (42, 17, 8);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (43, 17, 11);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (44, 17, 12);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (45, 17, 10);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (46, 17, 9);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (47, 17, 13);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (48, 17, 14);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (49, 17, 10);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (50, 17, 11);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (51, 17, 8);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (52, 17, 12);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (53, 17, 13);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (54, 17, 9);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (55, 17, 14);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (56, 17, 15);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (57, 17, 11);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (58, 17, 13);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (59, 17, 10);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (60, 17, 12);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (61, 17, 14);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (62, 17, 9);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (63, 17, 13);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (64, 17, 10);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (65, 17, 11);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (66, 17, 15);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (67, 17, 8);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (68, 17, 14);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (69, 17, 12);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (70, 17, 9);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (71, 17, 11);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (72, 17, 15);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (73, 17, 16);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (74, 17, 15);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (75, 17, 13);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (76, 17, 10);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (77, 17, 12);


INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (78, 17, 1);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (79, 17, 1);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (80, 17, 1);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (81, 17, 1);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (82, 17, 1);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (83, 17, 1);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (84, 17, 1);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (85, 17, 1);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (86, 17, 1);

--sede 19
-- Insertar todos los elementos en la sede 19

INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (1, 19, 14);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (2, 19, 24);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (3, 19, 14);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (4, 19, 8);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (5, 19, 9);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (6, 19, 14);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (7, 19, 8);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (8, 19, 12);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (9, 19, 11);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (10, 19, 9);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (11, 19, 13);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (12, 19, 10);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (13, 19, 14);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (14, 19, 12);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (15, 19, 9);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (16, 19, 11);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (17, 19, 8);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (18, 19, 13);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (19, 19, 14);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (20, 19, 10);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (21, 19, 11);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (22, 19, 12);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (23, 19, 9);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (24, 19, 14);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (25, 19, 8);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (26, 19, 13);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (27, 19, 12);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (28, 19, 10);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (29, 19, 11);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (30, 19, 14);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (31, 19, 9);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (32, 19, 13);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (33, 19, 12);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (34, 19, 8);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (35, 19, 14);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (36, 19, 11);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (37, 19, 10);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (38, 19, 12);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (39, 19, 9);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (40, 19, 13);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (41, 19, 14);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (42, 19, 8);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (43, 19, 11);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (44, 19, 12);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (45, 19, 10);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (46, 19, 9);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (47, 19, 13);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (48, 19, 14);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (49, 19, 10);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (50, 19, 11);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (51, 19, 8);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (52, 19, 12);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (53, 19, 13);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (54, 19, 9);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (55, 19, 14);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (56, 19, 15);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (57, 19, 11);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (58, 19, 13);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (59, 19, 10);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (60, 19, 12);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (61, 19, 14);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (62, 19, 9);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (63, 19, 13);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (64, 19, 10);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (65, 19, 11);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (66, 19, 15);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (67, 19, 8);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (68, 19, 14);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (69, 19, 12);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (70, 19, 9);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (71, 19, 11);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (72, 19, 15);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (73, 19, 1);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (74, 19, 1);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (75, 19, 1);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (76, 19, 1);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (77, 19, 1);


INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (78, 19, 1);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (79, 19, 1);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (80, 19, 1);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (81, 19, 1);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (82, 19, 1);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (83, 19, 1);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (84, 19, 1);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (85, 19, 1);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (86, 19, 1);

--sede 22
-- Insertar todos los elementos en la sede 22

INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (1, 22, 14);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (2, 22, 24);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (3, 22, 14);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (4, 22, 8);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (5, 22, 9);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (6, 22, 14);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (7, 22, 8);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (8, 22, 12);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (9, 22, 11);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (10, 22, 9);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (11, 22, 13);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (12, 22, 10);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (13, 22, 14);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (14, 22, 12);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (15, 22, 9);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (16, 22, 11);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (17, 22, 8);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (18, 22, 13);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (19, 22, 14);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (20, 22, 10);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (21, 22, 11);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (22, 22, 12);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (23, 22, 9);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (24, 22, 14);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (25, 22, 8);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (26, 22, 13);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (27, 22, 12);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (28, 22, 10);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (29, 22, 11);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (30, 22, 14);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (31, 22, 9);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (32, 22, 13);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (33, 22, 12);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (34, 22, 8);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (35, 22, 14);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (36, 22, 11);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (37, 22, 10);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (38, 22, 12);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (39, 22, 9);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (40, 22, 13);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (41, 22, 14);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (42, 22, 8);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (43, 22, 11);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (44, 22, 12);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (45, 22, 10);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (46, 22, 9);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (47, 22, 13);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (48, 22, 14);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (49, 22, 10);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (50, 22, 11);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (51, 22, 8);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (52, 22, 12);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (53, 22, 13);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (54, 22, 9);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (55, 22, 14);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (56, 22, 15);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (57, 22, 11);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (58, 22, 13);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (59, 22, 10);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (60, 22, 12);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (61, 22, 14);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (62, 22, 9);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (63, 22, 13);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (64, 22, 10);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (65, 22, 11);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (66, 22, 15);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (67, 22, 8);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (68, 22, 14);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (69, 22, 12);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (70, 22, 9);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (71, 22, 11);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (72, 22, 15);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (73, 22, 31);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (74, 22, 51);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (75, 22, 71);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (76, 22, 81);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (77, 22, 11);


INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (78, 22, 1);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (79, 22, 1);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (80, 22, 1);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (81, 22, 1);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (82, 22, 1);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (83, 22, 1);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (84, 22, 1);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (85, 22, 1);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (86, 22, 1);

--sede 23
-- Insertar todos los elementos en la sede 23

INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (1, 23, 14);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (2, 23, 24);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (3, 23, 14);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (4, 23, 8);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (5, 23, 9);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (6, 23, 14);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (7, 23, 8);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (8, 23, 12);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (9, 23, 11);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (10, 23, 9);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (11, 23, 13);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (12, 23, 10);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (13, 23, 14);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (14, 23, 12);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (15, 23, 9);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (16, 23, 11);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (17, 23, 8);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (18, 23, 13);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (19, 23, 14);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (20, 23, 10);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (21, 23, 11);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (22, 23, 12);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (23, 23, 9);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (24, 23, 14);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (25, 23, 8);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (26, 23, 13);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (27, 23, 12);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (28, 23, 10);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (29, 23, 11);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (30, 23, 14);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (31, 23, 9);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (32, 23, 13);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (33, 23, 12);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (34, 23, 8);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (35, 23, 14);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (36, 23, 11);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (37, 23, 10);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (38, 23, 12);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (39, 23, 9);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (40, 23, 13);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (41, 23, 14);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (42, 23, 8);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (43, 23, 11);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (44, 23, 12);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (45, 23, 10);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (46, 23, 9);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (47, 23, 13);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (48, 23, 14);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (49, 23, 10);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (50, 23, 11);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (51, 23, 8);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (52, 23, 12);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (53, 23, 13);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (54, 23, 9);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (55, 23, 14);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (56, 23, 15);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (57, 23, 11);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (58, 23, 13);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (59, 23, 10);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (60, 23, 12);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (61, 23, 14);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (62, 23, 9);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (63, 23, 13);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (64, 23, 10);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (65, 23, 11);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (66, 23, 15);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (67, 23, 8);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (68, 23, 14);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (69, 23, 12);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (70, 23, 9);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (71, 23, 11);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (72, 23, 15);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (73, 23, 23);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (74, 23, 6);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (75, 23, 15);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (76, 23, 4);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (77, 23, 3);


INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (78, 23, 1);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (79, 23, 1);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (80, 23, 1);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (81, 23, 1);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (82, 23, 1);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (83, 23, 1);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (84, 23, 1);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (85, 23, 1);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (86, 23, 1);

--sede 25
-- Insertar todos los elementos en la sede 25

INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (1, 25, 14);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (2, 25, 24);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (3, 25, 14);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (4, 25, 8);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (5, 25, 9);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (6, 25, 14);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (7, 25, 8);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (8, 25, 12);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (9, 25, 11);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (10, 25, 9);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (11, 25, 13);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (12, 25, 10);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (13, 25, 14);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (14, 25, 12);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (15, 25, 9);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (16, 25, 11);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (17, 25, 8);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (18, 25, 13);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (19, 25, 14);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (20, 25, 10);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (21, 25, 11);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (22, 25, 12);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (23, 25, 9);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (24, 25, 14);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (25, 25, 8);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (26, 25, 13);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (27, 25, 12);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (28, 25, 10);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (29, 25, 11);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (30, 25, 14);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (31, 25, 9);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (32, 25, 13);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (33, 25, 12);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (34, 25, 8);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (35, 25, 14);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (36, 25, 11);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (37, 25, 10);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (38, 25, 12);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (39, 25, 9);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (40, 25, 13);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (41, 25, 14);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (42, 25, 8);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (43, 25, 11);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (44, 25, 12);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (45, 25, 10);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (46, 25, 9);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (47, 25, 13);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (48, 25, 14);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (49, 25, 10);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (50, 25, 11);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (51, 25, 8);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (52, 25, 12);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (53, 25, 13);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (54, 25, 9);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (55, 25, 14);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (56, 25, 15);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (57, 25, 11);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (58, 25, 13);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (59, 25, 10);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (60, 25, 12);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (61, 25, 14);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (62, 25, 9);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (63, 25, 13);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (64, 25, 10);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (65, 25, 11);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (66, 25, 15);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (67, 25, 8);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (68, 25, 14);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (69, 25, 12);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (70, 25, 9);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (71, 25, 11);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (72, 25, 15);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (73, 25, 69);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (74, 25, 16);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (75, 25, 17);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (76, 25, 18);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (77, 25, 19);


INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (78, 25, 1);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (79, 25, 1);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (80, 25, 1);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (81, 25, 1);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (82, 25, 1);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (83, 25, 1);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (84, 25, 1);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (85, 25, 1);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (86, 25, 1);

--sede 28
-- Insertar todos los elementos en la sede 28

INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (1, 28, 14);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (2, 28, 24);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (3, 28, 14);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (4, 28, 8);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (5, 28, 9);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (6, 28, 14);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (7, 28, 8);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (8, 28, 12);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (9, 28, 11);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (10, 28, 9);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (11, 28, 13);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (12, 28, 10);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (13, 28, 14);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (14, 28, 12);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (15, 28, 9);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (16, 28, 11);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (17, 28, 8);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (18, 28, 13);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (19, 28, 14);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (20, 28, 10);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (21, 28, 11);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (22, 28, 12);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (23, 28, 9);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (24, 28, 14);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (25, 28, 8);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (26, 28, 13);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (27, 28, 12);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (28, 28, 10);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (29, 28, 11);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (30, 28, 14);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (31, 28, 9);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (32, 28, 13);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (33, 28, 12);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (34, 28, 8);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (35, 28, 14);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (36, 28, 11);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (37, 28, 10);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (38, 28, 12);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (39, 28, 9);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (40, 28, 13);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (41, 28, 14);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (42, 28, 8);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (43, 28, 11);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (44, 28, 12);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (45, 28, 10);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (46, 28, 9);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (47, 28, 13);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (48, 28, 14);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (49, 28, 10);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (50, 28, 11);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (51, 28, 8);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (52, 28, 12);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (53, 28, 13);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (54, 28, 9);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (55, 28, 14);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (56, 28, 15);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (57, 28, 11);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (58, 28, 13);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (59, 28, 10);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (60, 28, 12);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (61, 28, 14);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (62, 28, 9);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (63, 28, 13);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (64, 28, 10);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (65, 28, 11);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (66, 28, 15);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (67, 28, 8);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (68, 28, 14);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (69, 28, 12);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (70, 28, 9);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (71, 28, 11);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (72, 28, 15);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (73, 28, 23);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (74, 28, 1);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (75, 28, 12);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (76, 28, 43);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (77, 28, 67);


INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (78, 28, 1);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (79, 28, 1);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (80, 28, 1);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (81, 28, 1);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (82, 28, 1);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (83, 28, 1);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (84, 28, 1);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (85, 28, 1);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (86, 28, 1);



--Sedes pequeñas
--sede 2
--sede 3
--sede 5
--sede 6
--sede 9
--sede 13
--sede 15
--sede 16
--sede 18
--sede 20
--sede 21
--sede 24
--sede 26
--sede 27


-----------------------------------------------------

-----------------------------------------------------
--empleados
--sede 1
-- Entrenadores y Personal de Entrenamiento
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Ana', 'Gómez', '0000000000', TO_DATE('1985-04-15', 'YYYY-MM-DD'), '3001112233', 'ana.gomez@ejemplo.com', 1, 1, 1); -- Entrenador Personal
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Rogelio', 'Gómez', '0000000001', TO_DATE('1986-04-16', 'YYYY-MM-DD'), '3101112233', 'roge.gomez@ejemplo.com', 1, 1, 1); -- Entrenador Personal
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Eustaquio', 'Pérez', '0000000002', TO_DATE('1980-02-16', 'YYYY-MM-DD'), '3201112233', 'eus.gomez@ejemplo.com', 1, 1, 1); -- Entrenador Personal
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Luis', 'Pérez', '0000000003', TO_DATE('1983-08-22', 'YYYY-MM-DD'), '3001112234', 'luis.perez@ejemplo.com', 1, 1, 2); -- Instructor de Clases Grupales
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Carlos', 'Morales', '0000000004', TO_DATE('1987-11-30', 'YYYY-MM-DD'), '3001112235', 'carlos.morales@ejemplo.com', 1, 1, 3); -- Coordinador de Entrenamiento

-- Fisioterapeutas y Asistentes
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Sofía', 'Vásquez', '0000000005', TO_DATE('1986-02-14', 'YYYY-MM-DD'), '3001112236', 'sofia.vasquez@ejemplo.com', 1, 1, 4); -- Fisioterapeuta
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Julio', 'Ramírez', '0000000006', TO_DATE('1990-06-25', 'YYYY-MM-DD'), '3001112237', 'julio.ramirez@ejemplo.com', 1, 1, 5); -- Rehabilitador Deportivo
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Laura', 'García', '0000000007', TO_DATE('1989-03-17', 'YYYY-MM-DD'), '3001112238', 'laura.garcia@ejemplo.com', 1, 1, 6); -- Asistente de Fisioterapia

-- Instructores para Niños
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Miguel', 'Hernández', '0000000008', TO_DATE('1992-07-08', 'YYYY-MM-DD'), '3001112239', 'miguel.hernandez@ejemplo.com', 1, 1, 7); -- Instructor de Actividades para Niños
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Claudia', 'Martínez', '0000000009', TO_DATE('1984-12-05', 'YYYY-MM-DD'), '3001112240', 'claudia.martinez@ejemplo.com', 1, 1, 8); -- Cuidador

-- Mantenimiento y Atención al Cliente
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Andrés', 'Pineda', '0000000010', TO_DATE('1981-01-12', 'YYYY-MM-DD'), '3001112241', 'andres.pineda@ejemplo.com', 1, 1, 9); -- Operario de Mantenimiento
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Andrea', 'Pineda', '0000000011', TO_DATE('1981-01-12', 'YYYY-MM-DD'), '3001112241', 'andrea.pineda@ejemplo.com', 1, 1, 9); -- Operario de Mantenimiento
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Ruperto', 'Pineda', '0000000012', TO_DATE('1981-01-13', 'YYYY-MM-DD'), '3011112241', 'ruperto.pineda@ejemplo.com', 1, 1, 11); -- Auxiliar de Servicios Generales
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Carmen', 'Hernández', '0000000013', TO_DATE('1982-01-15', 'YYYY-MM-DD'), '3021112241', 'carme.hdz@ejemplo.com', 1, 1, 11); -- Auxiliar de Servicios Generales
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Juan', 'Sánchez', '0000000014', TO_DATE('1990-05-19', 'YYYY-MM-DD'), '3001112243', 'juan.sanchez@ejemplo.com', 1, 1, 11); -- Auxiliar de Servicios Generales
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Isabel', 'Díaz', '0000000015', TO_DATE('1995-09-23', 'YYYY-MM-DD'), '3001112242', 'isabel.diaz@ejemplo.com', 1, 1, 10); -- Jefe de Mantenimiento

-- Atención al Cliente y Nutrición
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Valeria', 'Moreno', '0000000016', TO_DATE('1988-11-11', 'YYYY-MM-DD'), '3001112244', 'valeria.moreno@ejemplo.com', 1, 1, 12); -- Auxiliar de Atención al Cliente
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Camilo', 'Gómez', '0000000017', TO_DATE('1987-04-20', 'YYYY-MM-DD'), '3001112245', 'camilo.gomez@ejemplo.com', 1, 1, 13); -- Coordinador de Servicio al Cliente
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Gabriela', 'Ríos', '0000000018', TO_DATE('1991-10-29', 'YYYY-MM-DD'), '3001112246', 'gabriela.rios@ejemplo.com', 1, 1, 14); -- Nutricionista
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Felipe', 'Cruz', '0000000019', TO_DATE('1994-03-12', 'YYYY-MM-DD'), '3001112247', 'felipe.cruz@ejemplo.com', 1, 1, 15); -- Asesor de Suplementación

-- Otros roles
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Daniel', 'Pardo', '0000000020', TO_DATE('1982-07-07', 'YYYY-MM-DD'), '3001112248', 'daniel.pardo@ejemplo.com', 1, 1, 16); -- Abogado Corporativo
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Samantha', 'Vega', '0000000021', TO_DATE('1993-12-01', 'YYYY-MM-DD'), '3001112249', 'samantha.vega@ejemplo.com', 1, 1, 17); -- Asistente Legal
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Martín', 'Núñez', '0000000022', TO_DATE('1986-06-28', 'YYYY-MM-DD'), '3001112250', 'martin.nunez@ejemplo.com', 1, 1, 18); -- Gerente de Marketing
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Paola', 'Castro', '0000000023', TO_DATE('1990-10-15', 'YYYY-MM-DD'), '3001112251', 'paola.castro@ejemplo.com', 1, 1, 19); -- Publicista
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Esteban', 'Ardila', '0000000024', TO_DATE('1985-08-11', 'YYYY-MM-DD'), '3001112252', 'esteban.ardila@ejemplo.com', 1, 1, 20); -- Diseñador
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Mariana', 'Ardila', '0000000025', TO_DATE('1989-08-12', 'YYYY-MM-DD'), '3001782252', 'mariana.ardila@ejemplo.com', 1, 1, 20); -- Diseñador

-- Gerentes y Contador
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Rafael', 'Córdoba', '0000000026', TO_DATE('1983-09-10', 'YYYY-MM-DD'), '3001112253', 'rafael.cordoba@ejemplo.com', 1, 1, 21); -- Gerente General
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Daniela', 'Salazar', '0000000027', TO_DATE('1988-01-29', 'YYYY-MM-DD'), '3001112254', 'daniela.salazar@ejemplo.com', 1, 1, 22); -- Gerente de Sede
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Alejandro', 'Valencia', '0000000028', TO_DATE('1986-04-20', 'YYYY-MM-DD'), '3001112255', 'alejandro.valencia@ejemplo.com', 1, 1, 23); -- Contador
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Natalia', 'Paniagua', '0000000029', TO_DATE('1992-11-05', 'YYYY-MM-DD'), '3001112256', 'natalia.paniagua@ejemplo.com', 1, 1, 24); -- Asistente Administrativo
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Natalia', 'Paniagua', '0000000030', TO_DATE('1992-11-05', 'YYYY-MM-DD'), '3001112256', 'natalia.paniagua@ejemplo.com', 1, 1, 24); -- Asistente Administrativo

-- sede 2
-- Entrenadores y Personal de Entrenamiento
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Ana', 'Gómez', '0000000031', TO_DATE('1985-04-15', 'YYYY-MM-DD'), '5701112233', 'ana.gomez@ejemploo.com', 1, 2, 1); -- Entrenador Personal
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Rogelio', 'Gómez', '0000000032', TO_DATE('1986-04-16', 'YYYY-MM-DD'), '5801112233', 'roge.gomez@ejemploo.com', 1, 2, 1); -- Entrenador Personal
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Eustaquio', 'Pérez', '0000000033', TO_DATE('1980-02-16', 'YYYY-MM-DD'), '5901112233', 'eus.gomez@ejemploo.com', 1, 2, 1); -- Entrenador Personal
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Luis', 'Pérez', '0000000034', TO_DATE('1983-08-22', 'YYYY-MM-DD'), '6001112234', 'luis.perez@ejemploo.com', 1, 2, 2); -- Instructor de Clases Grupales
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Carlos', 'Morales', '0000000035', TO_DATE('1987-11-30', 'YYYY-MM-DD'), '6101112235', 'carlos.morales@ejemploo.com', 1, 2, 3); -- Coordinador de Entrenamiento

-- Mantenimiento y Atención al Cliente
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Andrés', 'Pineda', '0000000036', TO_DATE('1981-01-12', 'YYYY-MM-DD'), '6201112241', 'andres.pineda@ejemploo.com', 1, 2, 9); -- Operario de Mantenimiento
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Andrea', 'Pineda', '0000000037', TO_DATE('1981-01-12', 'YYYY-MM-DD'), '6301112241', 'andrea.pineda@ejemploo.com', 1, 2, 9); -- Operario de Mantenimiento
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Ruperto', 'Pineda', '0000000038', TO_DATE('1981-01-13', 'YYYY-MM-DD'), '6411112241', 'ruperto.pineda@ejemploo.com', 1, 2, 11); -- Auxiliar de Servicios Generales
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Carmen', 'Hernández', '0000000039', TO_DATE('1982-01-15', 'YYYY-MM-DD'), '6521112241', 'carme.hdz@ejemploo.com', 1, 2, 11); -- Auxiliar de Servicios Generales
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Juan', 'Sánchez', '0000000040', TO_DATE('1990-05-19', 'YYYY-MM-DD'), '6601112243', 'juan.sanchez@ejemploo.com', 1, 2, 11); -- Auxiliar de Servicios Generales
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Isabel', 'Díaz', '0000000041', TO_DATE('1995-09-23', 'YYYY-MM-DD'), '6701112242', 'isabel.diaz@ejemploo.com', 1, 2, 10); -- Jefe de Mantenimiento

-- sede 3
-- Entrenadores y Coordinador de Entrenamiento
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Ana', 'Gómez', '0000000042', TO_DATE('1985-04-15', 'YYYY-MM-DD'), '5701112233', 'ana.gomez@ejemplo.com.co', 1, 3, 1); -- Entrenador Personal
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Rogelio', 'Gómez', '0000000043', TO_DATE('1986-04-16', 'YYYY-MM-DD'), '5801112233', 'roge.gomez@ejemplo.com.co', 1, 3, 1); -- Entrenador Personal
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Eustaquio', 'Pérez', '0000000044', TO_DATE('1980-02-16', 'YYYY-MM-DD'), '5901112233', 'eus.perez@ejemplo.com.co', 1, 3, 1); -- Entrenador Personal
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Luis', 'Pérez', '0000000045', TO_DATE('1983-08-22', 'YYYY-MM-DD'), '6001112234', 'luis.perez@ejemplo.com.co', 1, 3, 2); -- Instructor de Clases Grupales
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Carlos', 'Morales', '0000000046', TO_DATE('1987-11-30', 'YYYY-MM-DD'), '6101112235', 'carlos.morales@ejemplo.com.co', 1, 3, 3); -- Coordinador de Entrenamiento

-- Mantenimiento y Atención al Cliente
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Andrés', 'Pineda', '0000000047', TO_DATE('1981-01-12', 'YYYY-MM-DD'), '6201112241', 'andres.pineda@ejemplo.com.co', 1, 3, 9); -- Operario de Mantenimiento
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Andrea', 'Pineda', '0000000048', TO_DATE('1981-01-12', 'YYYY-MM-DD'), '6301112241', 'andrea.pineda@ejemplo.com.co', 1, 3, 9); -- Operario de Mantenimiento
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Ruperto', 'Pineda', '0000000049', TO_DATE('1981-01-13', 'YYYY-MM-DD'), '6411112241', 'ruperto.pineda@ejemplo.com.co', 1, 3, 11); -- Auxiliar de Servicios Generales
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Carmen', 'Hernández', '0000000050', TO_DATE('1982-01-15', 'YYYY-MM-DD'), '6521112241', 'carmen.hernandez@ejemplo.com.co', 1, 3, 11); -- Auxiliar de Servicios Generales
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Juan', 'Sánchez', '0000000051', TO_DATE('1990-05-19', 'YYYY-MM-DD'), '6601112243', 'juan.sanchez@ejemplo.com.co', 1, 3, 11); -- Auxiliar de Servicios Generales
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Isabel', 'Díaz', '0000000052', TO_DATE('1995-09-23', 'YYYY-MM-DD'), '6701112242', 'isabel.diaz@ejemplo.com.co', 1, 3, 10); -- Jefe de Mantenimiento
-----------------------------------------------------

-----------------------------------------------------
-- Clientes para Sede Norte (Bogotá)
INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES 
('Carlos', 'Gómez', '0000000053', TO_DATE('1985-05-20', 'YYYY-MM-DD'), '3101234567', 'carlos.gomez1@yipmail.com', TO_DATE('2024-09-30', 'YYYY-MM-DD'), 1, 1);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES 
('Laura', 'Martínez', '0000000054', TO_DATE('1990-07-12', 'YYYY-MM-DD'), '3102345678', 'laura.martinez1@yipmail.com', TO_DATE('2024-10-15', 'YYYY-MM-DD'), 1, 2);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES 
('Andrés', 'Hernández', '0000000055', TO_DATE('1982-11-30', 'YYYY-MM-DD'), '3103456789', 'andres.hernandez1@yipmail.com', TO_DATE('2024-11-20', 'YYYY-MM-DD'), 1, 3);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES 
('Sofia', 'Jiménez', '0000000056', TO_DATE('1987-02-25', 'YYYY-MM-DD'), '3104567890', 'sofia.jimenez1@yipmail.com', TO_DATE('2024-12-05', 'YYYY-MM-DD'), 1, 4);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES 
('Juan', 'Pérez', '0000000057', TO_DATE('1995-09-14', 'YYYY-MM-DD'), '3105678901', 'juan.perez1@yipmail.com', TO_DATE('2025-01-10', 'YYYY-MM-DD'), 1, 5);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES 
('Ana', 'Torres', '0000000058', TO_DATE('1992-04-21', 'YYYY-MM-DD'), '3106789012', 'ana.torres1@yipmail.com', TO_DATE('2025-02-28', 'YYYY-MM-DD'), 1, 6);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES 
('Luis', 'Fernández', '0000000059', TO_DATE('1988-08-15', 'YYYY-MM-DD'), '3107890123', 'luis.fernandez1@yipmail.com', TO_DATE('2025-03-22', 'YYYY-MM-DD'), 1, 7);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES 
('Valeria', 'Castro', '0000000060', TO_DATE('1991-12-03', 'YYYY-MM-DD'), '3108901234', 'valeria.castro1@yipmail.com', TO_DATE('2025-04-10', 'YYYY-MM-DD'), 1, 8);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES 
('Felipe', 'Moreno', '0000000061', TO_DATE('1994-06-17', 'YYYY-MM-DD'), '3109012345', 'felipe.moreno1@yipmail.com', TO_DATE('2025-05-18', 'YYYY-MM-DD'), 1, 9);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES 
('Camila', 'Ramos', '0000000062', TO_DATE('1986-10-10', 'YYYY-MM-DD'), '3100123456', 'camila.ramos1@yipmail.com', TO_DATE('2025-06-25', 'YYYY-MM-DD'), 1, 10);

-- Clientes para Sede Centro (Bogotá)
INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES 
('Carlos', 'Gómez', '0000000063', TO_DATE('1985-05-20', 'YYYY-MM-DD'), '3101234567', 'carlos.gomez2@yipmail.com', TO_DATE('2024-09-30', 'YYYY-MM-DD'), 2, 1);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES 
('Laura', 'Martínez', '0000000064', TO_DATE('1990-07-12', 'YYYY-MM-DD'), '3102345678', 'laura.martinez2@yipmail.com', TO_DATE('2024-10-15', 'YYYY-MM-DD'), 2, 2);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES 
('Andrés', 'Hernández', '0000000065', TO_DATE('1982-11-30', 'YYYY-MM-DD'), '3103456789', 'andres.hernandez2@yipmail.com', TO_DATE('2024-11-20', 'YYYY-MM-DD'), 2, 3);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES 
('Sofia', 'Jiménez', '0000000066', TO_DATE('1987-02-25', 'YYYY-MM-DD'), '3104567890', 'sofia.jimenez2@yipmail.com', TO_DATE('2024-12-05', 'YYYY-MM-DD'), 2, 4);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES 
('Juan', 'Pérez', '0000000067', TO_DATE('1995-09-14', 'YYYY-MM-DD'), '3105678901', 'juan.perez2@yipmail.com', TO_DATE('2025-01-10', 'YYYY-MM-DD'), 2, 5);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES 
('Ana', 'Torres', '0000000068', TO_DATE('1992-04-21', 'YYYY-MM-DD'), '3106789012', 'ana.torres2@yipmail.com', TO_DATE('2025-02-28', 'YYYY-MM-DD'), 2, 6);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES 
('Luis', 'Fernández', '0000000069', TO_DATE('1988-08-15', 'YYYY-MM-DD'), '3107890123', 'luis.fernandez2@yipmail.com', TO_DATE('2025-03-22', 'YYYY-MM-DD'), 2, 7);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES 
('Valeria', 'Castro', '0000000070', TO_DATE('1991-12-03', 'YYYY-MM-DD'), '3108901234', 'valeria.castro2@yipmail.com', TO_DATE('2025-04-10', 'YYYY-MM-DD'), 2, 8);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES 
('Felipe', 'Moreno', '0000000071', TO_DATE('1994-06-17', 'YYYY-MM-DD'), '3109012345', 'felipe.moreno2@yipmail.com', TO_DATE('2025-05-18', 'YYYY-MM-DD'), 2, 9);

-- Clientes para Sede Occidente (Bogotá)
INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES 
('Carlos', 'Gómez', '0000000072', TO_DATE('1985-05-20', 'YYYY-MM-DD'), '3101234567', 'carlos.gomez3@yipmail.com', TO_DATE('2024-09-30', 'YYYY-MM-DD'), 3, 1);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES 
('Laura', 'Martínez', '0000000073', TO_DATE('1990-07-12', 'YYYY-MM-DD'), '3102345678', 'laura.martinez3@yipmail.com', TO_DATE('2024-10-15', 'YYYY-MM-DD'), 3, 2);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES 
('Andrés', 'Hernández', '0000000074', TO_DATE('1982-11-30', 'YYYY-MM-DD'), '3103456789', 'andres.hernandez3@yipmail.com', TO_DATE('2024-11-20', 'YYYY-MM-DD'), 3, 3);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES 
('Sofia', 'Jiménez', '0000000075', TO_DATE('1987-02-25', 'YYYY-MM-DD'), '3104567890', 'sofia.jimenez3@yipmail.com', TO_DATE('2024-12-05', 'YYYY-MM-DD'), 3, 4);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES 
('Juan', 'Pérez', '0000000076', TO_DATE('1995-09-14', 'YYYY-MM-DD'), '3105678901', 'juan.perez3@yipmail.com', TO_DATE('2025-01-10', 'YYYY-MM-DD'), 3, 5);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES 
('Ana', 'Torres', '0000000077', TO_DATE('1992-04-21', 'YYYY-MM-DD'), '3106789012', 'ana.torres3@yipmail.com', TO_DATE('2025-02-28', 'YYYY-MM-DD'), 3, 6);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES 
('Luis', 'Fernández', '0000000078', TO_DATE('1988-08-15', 'YYYY-MM-DD'), '3107890123', 'luis.fernandez3@yipmail.com', TO_DATE('2025-03-22', 'YYYY-MM-DD'), 3, 7);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES 
('Valeria', 'Castro', '0000000079', TO_DATE('1991-12-03', 'YYYY-MM-DD'), '3108901234', 'valeria.castro3@yipmail.com', TO_DATE('2025-04-10', 'YYYY-MM-DD'), 3, 8);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES 
('Felipe', 'Moreno', '0000000080', TO_DATE('1994-06-17', 'YYYY-MM-DD'), '3109012345', 'felipe.moreno3@yipmail.com', TO_DATE('2025-05-18', 'YYYY-MM-DD'), 3, 9);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES 
('Camila', 'Ramos', '0000000081', TO_DATE('1986-10-10', 'YYYY-MM-DD'), '3100123456', 'camila.ramos3@yipmail.com', TO_DATE('2025-06-25', 'YYYY-MM-DD'), 3, 10);
-----------------------------------------------------

-----------------------------------------------------
--productos_sede
-- sede 1
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (1, 1, 50.00, 30);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (2, 1, 40.00, 25);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (3, 1, 35.00, 20);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (4, 1, 60.00, 15);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (5, 1, 45.00, 10);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (6, 1, 55.00, 18);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (7, 1, 70.00, 22);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (8, 1, 65.00, 12);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (9, 1, 30.00, 40);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (10, 1, 25.00, 1);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (11, 1, 80.00, 5);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (12, 1, 85.00, 8);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (13, 1, 70.00, 10);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (14, 1, 90.00, 7);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (15, 1, 75.00, 0);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (16, 1, 95.00, 6);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (17, 1, 100.00, 8);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (18, 1, 65.00, 1);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (19, 1, 50.00, 20);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (20, 1, 55.00, 25);
-----------------------------------------------------

--historial de visitas

--venta

--productos venta


--Eliminacion de tablas
--DROP TABLE pais CASCADE CONSTRAINTS;
--DROP TABLE estado CASCADE CONSTRAINTS;
--DROP TABLE ciudad CASCADE CONSTRAINTS;
--DROP TABLE sede CASCADE CONSTRAINTS;
--DROP TABLE elemento CASCADE CONSTRAINTS;
--DROP TABLE elementos_sede CASCADE CONSTRAINTS;
--DROP TABLE caracteristica CASCADE CONSTRAINTS;
--DROP TABLE caracteristicas_sede CASCADE CONSTRAINTS;
--DROP TABLE departamento CASCADE CONSTRAINTS;
--DROP TABLE cargo CASCADE CONSTRAINTS;
--DROP TABLE empleado CASCADE CONSTRAINTS;
--DROP TABLE membresia CASCADE CONSTRAINTS;
--DROP TABLE cliente CASCADE CONSTRAINTS;
--DROP TABLE historial_visitas CASCADE CONSTRAINTS;
--DROP TABLE producto CASCADE CONSTRAINTS;
--DROP TABLE productos_sede CASCADE CONSTRAINTS;
--DROP TABLE venta CASCADE CONSTRAINTS;
--DROP TABLE productos_venta CASCADE CONSTRAINTS;

--Eliminacion de tablespaces
--DROP TABLESPACE ts_undo INCLUDING CONTENTS AND DATAFILES;
--DROP TABLESPACE ts_productos_ventas INCLUDING CONTENTS AND DATAFILES;
--DROP TABLESPACE ts_empleados INCLUDING CONTENTS AND DATAFILES;
--DROP TABLESPACE ts_territorios INCLUDING CONTENTS AND DATAFILES;
--DROP TABLESPACE ts_clientes INCLUDING CONTENTS AND DATAFILES;
--DROP TABLESPACE ts_sedes INCLUDING CONTENTS AND DATAFILES;
--DROP TABLESPACE tts_gerente INCLUDING CONTENTS AND DATAFILES;
--DROP TABLESPACE ts_default_users INCLUDING CONTENTS AND DATAFILES;

--Eliminacion de usuarios y roles
--DROP USER C##gerente CASCADE;
--DROP ROLE C##rol_administrativo;