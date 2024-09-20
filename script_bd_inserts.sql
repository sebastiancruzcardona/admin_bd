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
INSERT INTO estado (estado, id_pais) VALUES ('Cordoba', 1);--2
INSERT INTO estado (estado, id_pais) VALUES ('Tucuman', 1);--3
INSERT INTO estado (estado, id_pais) VALUES ('Region metropolitana', 2);--4
INSERT INTO estado (estado, id_pais) VALUES ('Region de Valparaiso', 2);--5
INSERT INTO estado (estado, id_pais) VALUES ('Region de Biobbio', 2);--6
INSERT INTO estado (estado, id_pais) VALUES ('Cundinamarca', 3); --7
INSERT INTO estado (estado, id_pais) VALUES ('Antioquia', 3);--8
INSERT INTO estado (estado, id_pais) VALUES ('Quindio', 3);--9
INSERT INTO estado (estado, id_pais) VALUES ('San Jose', 4); --10
INSERT INTO estado (estado, id_pais) VALUES ('Limon', 4);--11
INSERT INTO estado (estado, id_pais) VALUES ('Guanacaste', 4);--12
INSERT INTO estado (estado, id_pais) VALUES ('Pichincha', 5);--13
INSERT INTO estado (estado, id_pais) VALUES ('Guayas', 5);--14
INSERT INTO estado (estado, id_pais) VALUES ('Azuay', 5);--15
INSERT INTO estado (estado, id_pais) VALUES ('Lima', 47);--16
INSERT INTO estado (estado, id_pais) VALUES ('Mexico DF', 6);--17
INSERT INTO estado (estado, id_pais) VALUES ('Jalisco', 6);--18
INSERT INTO estado (estado, id_pais) VALUES ('Puebla de Zaragoza', 6);--19
INSERT INTO estado (estado, id_pais) VALUES ('Panama', 7);--20
INSERT INTO estado (estado, id_pais) VALUES ('Veraguas', 7);--21
INSERT INTO estado (estado, id_pais) VALUES ('Los Santos', 7);--22
INSERT INTO estado (estado, id_pais) VALUES ('Arequipa', 8);--23
INSERT INTO estado (estado, id_pais) VALUES ('Ayacucho', 8);--24
INSERT INTO estado (estado, id_pais) VALUES ('Cataluna', 9);--25
INSERT INTO estado (estado, id_pais) VALUES ('Madrid', 9);--26
-----------------------------------------------------

-----------------------------------------------------
--Ciudades
INSERT INTO ciudad (ciudad, id_estado) VALUES ('Bogota', 7);
INSERT INTO ciudad (ciudad, id_estado) VALUES ('Facatativa', 7);
INSERT INTO ciudad (ciudad, id_estado) VALUES ('Soacha', 7);
INSERT INTO ciudad (ciudad, id_estado) VALUES ('Medellin', 8);
INSERT INTO ciudad (ciudad, id_estado) VALUES ('Bello', 8);
INSERT INTO ciudad (ciudad, id_estado) VALUES ('Envigado', 8);
INSERT INTO ciudad (ciudad, id_estado) VALUES ('Armenia', 9);
INSERT INTO ciudad (ciudad, id_estado) VALUES ('Calarca', 9);
INSERT INTO ciudad (ciudad, id_estado) VALUES ('Quito', 13);
INSERT INTO ciudad (ciudad, id_estado) VALUES ('Sangolque', 13);
INSERT INTO ciudad (ciudad, id_estado) VALUES ('Cayambe', 13);
INSERT INTO ciudad (ciudad, id_estado) VALUES ('Guayaquil', 14);
INSERT INTO ciudad (ciudad, id_estado) VALUES ('Daule', 14);
INSERT INTO ciudad (ciudad, id_estado) VALUES ('Cuenca', 15);
INSERT INTO ciudad (ciudad, id_estado) VALUES ('Lima', 16);
INSERT INTO ciudad (ciudad, id_estado) VALUES ('Miraflores', 16);
INSERT INTO ciudad (ciudad, id_estado) VALUES ('Arequipa', 23);
INSERT INTO ciudad (ciudad, id_estado) VALUES ('Ayacucho', 24);
INSERT INTO ciudad (ciudad, id_estado) VALUES ('Buenos Aires', 1);
INSERT INTO ciudad (ciudad, id_estado) VALUES ('La Plata', 1);
INSERT INTO ciudad (ciudad, id_estado) VALUES ('Avellaneda', 1);
INSERT INTO ciudad (ciudad, id_estado) VALUES ('Cordoba', 2);
INSERT INTO ciudad (ciudad, id_estado) VALUES ('Villa Carlos Paz', 2);
INSERT INTO ciudad (ciudad, id_estado) VALUES ('Rio Cuarto', 2);
INSERT INTO ciudad (ciudad, id_estado) VALUES ('San Miguel de Tucuman', 3);
INSERT INTO ciudad (ciudad, id_estado) VALUES ('Santiago', 4);
INSERT INTO ciudad (ciudad, id_estado) VALUES ('Puente Alto', 4);
INSERT INTO ciudad (ciudad, id_estado) VALUES ('Maipo', 4);
INSERT INTO ciudad (ciudad, id_estado) VALUES ('Valparaiso', 5);
INSERT INTO ciudad (ciudad, id_estado) VALUES ('Vida del Mar', 5);
INSERT INTO ciudad (ciudad, id_estado) VALUES ('Concepcion', 6);
INSERT INTO ciudad (ciudad, id_estado) VALUES ('Ciudad de Mexico', 17);
INSERT INTO ciudad (ciudad, id_estado) VALUES ('Iztapalapa', 17);
INSERT INTO ciudad (ciudad, id_estado) VALUES ('Coyoacan', 17);
INSERT INTO ciudad (ciudad, id_estado) VALUES ('Guadalajara', 18);
INSERT INTO ciudad (ciudad, id_estado) VALUES ('Zapopan', 18);
INSERT INTO ciudad (ciudad, id_estado) VALUES ('Puebla', 19);
INSERT INTO ciudad (ciudad, id_estado) VALUES ('Cholula', 19);
INSERT INTO ciudad (ciudad, id_estado) VALUES ('Tehuacan', 19);
INSERT INTO ciudad (ciudad, id_estado) VALUES ('San Jose', 10);
INSERT INTO ciudad (ciudad, id_estado) VALUES ('Desamparados', 10);
INSERT INTO ciudad (ciudad, id_estado) VALUES ('Alajuela', 10);
INSERT INTO ciudad (ciudad, id_estado) VALUES ('Limon', 11);
INSERT INTO ciudad (ciudad, id_estado) VALUES ('Guapiles', 11);
INSERT INTO ciudad (ciudad, id_estado) VALUES ('Liberia', 12);
INSERT INTO ciudad (ciudad, id_estado) VALUES ('Nicoya', 12);
INSERT INTO ciudad (ciudad, id_estado) VALUES ('Santa Cruz', 12);
INSERT INTO ciudad (ciudad, id_estado) VALUES ('Panama', 20);
INSERT INTO ciudad (ciudad, id_estado) VALUES ('San Miguelito', 20);
INSERT INTO ciudad (ciudad, id_estado) VALUES ('Santiago de Veraguas', 21);
INSERT INTO ciudad (ciudad, id_estado) VALUES ('Las Tablas', 22);
INSERT INTO ciudad (ciudad, id_estado) VALUES ('Guarara', 22);
INSERT INTO ciudad (ciudad, id_estado) VALUES ('La Villa de Los Santos', 22);
INSERT INTO ciudad (ciudad, id_estado) VALUES ('Barcelona', 25);
INSERT INTO ciudad (ciudad, id_estado) VALUES ('Tarragona', 25);
INSERT INTO ciudad (ciudad, id_estado) VALUES ('Lleida', 25);
INSERT INTO ciudad (ciudad, id_estado) VALUES ('Madrid', 26);
INSERT INTO ciudad (ciudad, id_estado) VALUES ('Alcala de Henares', 26);
INSERT INTO ciudad (ciudad, id_estado) VALUES ('Getafe', 26);
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
INSERT INTO sede (sede, direccion, telefono, id_ciudad) VALUES ('Sede Soacha', 'Carrera 10 #4-15', '3008765432', 3);

-- Medellín (capital) 4-5
INSERT INTO sede (sede, direccion, telefono, id_ciudad) VALUES ('Sede Poblado', 'Calle 10 #43-25', '3001231234', 4);
INSERT INTO sede (sede, direccion, telefono, id_ciudad) VALUES ('Sede Laureles', 'Avenida Nutibara #70-30', '3009876541', 4);

-- Envigado 6
INSERT INTO sede (sede, direccion, telefono, id_ciudad) VALUES ('Sede Envigado', 'Calle 38 Sur #15-20', '3002211445', 6);

-- Armenia (capital) 7
INSERT INTO sede (sede, direccion, telefono, id_ciudad) VALUES ('Sede Armenia', 'Carrera 14 #18-20', '3003344556', 7);

-- Quito (capital) 8
INSERT INTO sede (sede, direccion, telefono, id_ciudad) VALUES ('Sede Norte Quito', 'Avenida Amazonas #35-20', '3005566778', 9);

-- Sangolquí 9
INSERT INTO sede (sede, direccion, telefono, id_ciudad) VALUES ('Sede Sangolquí', 'Avenida General Rumiñahui #5-25', '3007788990', 10);

-- Guayaquil (capital) 10
INSERT INTO sede (sede, direccion, telefono, id_ciudad) VALUES ('Sede Norte Guayaquil', 'Avenida 9 de Octubre #30-15', '3009900112', 12);

-- Cuenca (capital) 11
INSERT INTO sede (sede, direccion, telefono, id_ciudad) VALUES ('Sede Cuenca', 'Calle Bolívar #20-15', '3002233445', 14);

-- Lima (capital) 12
INSERT INTO sede (sede, direccion, telefono, id_ciudad) VALUES ('Sede Lima Sur', 'Avenida Javier Prado #45-20', '3003344556', 15);

-- Miraflores 13
INSERT INTO sede (sede, direccion, telefono, id_ciudad) VALUES ('Sede Miraflores', 'Avenida Pardo #12-30', '3005566778', 16);

-- Buenos Aires (capital) 14-15
INSERT INTO sede (sede, direccion, telefono, id_ciudad) VALUES ('Sede Palermo', 'Avenida Santa Fe #45-30', '3008899001', 19);
INSERT INTO sede (sede, direccion, telefono, id_ciudad) VALUES ('Sede Recoleta', 'Calle Pueyrredón #10-20', '3009900112', 19);

-- La Plata 16
INSERT INTO sede (sede, direccion, telefono, id_ciudad) VALUES ('Sede La Plata', 'Calle 7 #34-25', '3000011223', 20);

-- Santiago (capital) 17-18
INSERT INTO sede (sede, direccion, telefono, id_ciudad) VALUES ('Sede Providencia', 'Avenida Providencia #30-20', '3007788990', 26);
INSERT INTO sede (sede, direccion, telefono, id_ciudad) VALUES ('Sede Las Condes', 'Avenida Apoquindo #45-15', '3008899001', 26);

-- Ciudad de México (capital) 19-20
INSERT INTO sede (sede, direccion, telefono, id_ciudad) VALUES ('Sede Polanco', 'Avenida Presidente Masaryk #45-30', '3004455667', 32);
INSERT INTO sede (sede, direccion, telefono, id_ciudad) VALUES ('Sede Roma', 'Calle Álvaro Obregón #20-15', '3005566778', 32);

-- Iztapalapa 21
INSERT INTO sede (sede, direccion, telefono, id_ciudad) VALUES ('Sede Iztapalapa', 'Avenida Tláhuac #15-20', '3006677889', 33);

-- Guadalajara (capital) 22
INSERT INTO sede (sede, direccion, telefono, id_ciudad) VALUES ('Sede Guadalajara Centro', 'Avenida Juárez #45-10', '3008899001', 35);

-- Panamá (capital) 23-24
INSERT INTO sede (sede, direccion, telefono, id_ciudad) VALUES ('Sede Panamá Centro', 'Avenida Balboa #25-10', '3004455667', 48);
INSERT INTO sede (sede, direccion, telefono, id_ciudad) VALUES ('Sede Albrook', 'Calle 72 #15-20', '3005566778', 48);

-- Barcelona (capital) 25-26
INSERT INTO sede (sede, direccion, telefono, id_ciudad) VALUES ('Sede Barcelona Centro', 'Calle Gran Vía #45-30', '3001122334', 54);
INSERT INTO sede (sede, direccion, telefono, id_ciudad) VALUES ('Sede Eixample', 'Avenida Diagonal #10-15', '3002233445', 54);

-- Tarragona 27
INSERT INTO sede (sede, direccion, telefono, id_ciudad) VALUES ('Sede Tarragona', 'Calle Ramón y Cajal #20-25', '3003344556', 55);

-- Madrid (capital) 28-29
INSERT INTO sede (sede, direccion, telefono, id_ciudad) VALUES ('Sede Madrid Centro', 'Gran Vía #20-10', '3005566778', 57);
INSERT INTO sede (sede, direccion, telefono, id_ciudad) VALUES ('Sede Madrid Norte', 'Avenida de América #15-25', '3006677889', 57);

-- Getafe 30
INSERT INTO sede (sede, direccion, telefono, id_ciudad) VALUES ('Sede Getafe', 'Calle Madrid #25-15', '3008899001', 59);
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

--sede 6
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (1, 6, 10);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (2, 6, 20);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (3, 6, 10);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (4, 6, 4);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (5, 6, 5);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (6, 6, 10);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (7, 6, 4);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (8, 6, 8);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (9, 6, 7);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (10, 6, 5);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (11, 6, 9);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (12, 6, 6);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (13, 6, 10);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (14, 6, 8);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (15, 6, 5);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (16, 6, 7);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (17, 6, 4);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (18, 6, 9);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (19, 6, 10);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (20, 6, 6);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (21, 6, 7);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (22, 6, 8);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (23, 6, 5);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (24, 6, 10);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (25, 6, 4);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (26, 6, 9);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (27, 6, 8);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (28, 6, 6);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (29, 6, 7);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (30, 6, 10);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (31, 6, 5);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (32, 6, 9);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (33, 6, 8);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (34, 6, 4);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (35, 6, 10);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (36, 6, 7);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (37, 6, 6);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (38, 6, 8);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (39, 6, 5);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (40, 6, 9);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (41, 6, 10);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (42, 6, 4);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (43, 6, 7);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (44, 6, 8);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (45, 6, 6);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (46, 6, 5);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (47, 6, 9);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (48, 6, 10);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (49, 6, 6);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (50, 6, 7);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (51, 6, 4);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (52, 6, 8);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (53, 6, 9);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (54, 6, 5);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (55, 6, 7);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (56, 6, 10);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (57, 6, 8);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (58, 6, 6);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (59, 6, 9);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (60, 6, 7);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (61, 6, 10);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (62, 6, 5);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (63, 6, 8);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (64, 6, 6);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (65, 6, 9);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (66, 6, 7);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (67, 6, 4);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (68, 6, 10);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (69, 6, 5);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (70, 6, 8);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (71, 6, 7);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (72, 6, 9);

INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (73, 6, 10);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (74, 6, 10);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (75, 6, 2);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (76, 6, 2);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (77, 6, 1);

INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (78, 6, 1);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (79, 6, 1);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (80, 6, 1);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (81, 6, 1);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (82, 6, 1);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (83, 6, 1);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (84, 6, 1);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (85, 6, 1);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (86, 6, 1);




--sede 2
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (1, 2, 8);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (2, 2, 16);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (3, 2, 8);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (4, 2, 4);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (5, 2, 5);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (6, 2, 8);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (7, 2, 3);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (8, 2, 6);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (9, 2, 5);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (10, 2, 3);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (11, 2, 7);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (12, 2, 4);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (13, 2, 8);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (14, 2, 6);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (15, 2, 4);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (16, 2, 5);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (17, 2, 2);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (18, 2, 7);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (19, 2, 8);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (20, 2, 5);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (21, 2, 6);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (22, 2, 7);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (23, 2, 4);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (24, 2, 8);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (25, 2, 2);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (26, 2, 7);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (27, 2, 6);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (28, 2, 5);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (29, 2, 6);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (30, 2, 8);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (31, 2, 4);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (32, 2, 7);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (33, 2, 5);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (34, 2, 2);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (35, 2, 8);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (36, 2, 6);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (37, 2, 4);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (38, 2, 6);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (39, 2, 3);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (40, 2, 7);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (41, 2, 8);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (42, 2, 2);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (43, 2, 5);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (44, 2, 6);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (45, 2, 4);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (46, 2, 3);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (47, 2, 7);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (48, 2, 8);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (49, 2, 4);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (50, 2, 5);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (51, 2, 2);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (52, 2, 6);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (53, 2, 7);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (54, 2, 3);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (55, 2, 5);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (56, 2, 8);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (57, 2, 6);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (58, 2, 4);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (59, 2, 7);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (60, 2, 5);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (61, 2, 8);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (62, 2, 3);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (63, 2, 6);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (64, 2, 5);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (65, 2, 7);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (66, 2, 5);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (67, 2, 2);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (68, 2, 8);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (69, 2, 3);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (70, 2, 6);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (71, 2, 5);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (72, 2, 7);

INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (73, 2, 9);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (74, 2, 8);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (75, 2, 2);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (76, 2, 2);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (77, 2, 1);

--sede 3
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (1, 3, 9);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (2, 3, 10);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (3, 3, 8);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (5, 3, 4);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (7, 3, 5);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (8, 3, 6);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (10, 3, 7);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (12, 3, 5);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (13, 3, 6);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (14, 3, 7);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (15, 3, 4);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (17, 3, 6);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (19, 3, 7);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (21, 3, 5);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (22, 3, 6);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (24, 3, 4);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (25, 3, 7);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (27, 3, 6);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (29, 3, 5);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (30, 3, 7);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (32, 3, 6);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (34, 3, 5);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (36, 3, 7);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (37, 3, 4);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (39, 3, 6);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (41, 3, 5);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (43, 3, 6);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (45, 3, 4);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (47, 3, 7);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (48, 3, 6);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (50, 3, 5);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (52, 3, 7);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (54, 3, 6);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (56, 3, 4);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (58, 3, 7);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (59, 3, 5);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (61, 3, 6);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (63, 3, 7);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (65, 3, 4);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (67, 3, 5);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (68, 3, 7);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (70, 3, 6);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (72, 3, 4);

--sede 4
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (1, 4, 7);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (2, 4, 6);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (3, 4, 5);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (5, 4, 4);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (7, 4, 6);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (8, 4, 5);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (10, 4, 4);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (12, 4, 7);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (13, 4, 6);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (14, 4, 5);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (16, 4, 4);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (17, 4, 6);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (19, 4, 7);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (21, 4, 5);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (22, 4, 6);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (24, 4, 4);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (25, 4, 7);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (27, 4, 5);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (29, 4, 6);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (30, 4, 7);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (32, 4, 5);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (34, 4, 6);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (36, 4, 7);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (39, 4, 4);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (41, 4, 6);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (43, 4, 5);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (45, 4, 4);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (47, 4, 6);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (48, 4, 5);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (50, 4, 7);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (52, 4, 6);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (54, 4, 4);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (56, 4, 7);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (58, 4, 5);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (60, 4, 6);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (61, 4, 7);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (63, 4, 5);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (65, 4, 6);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (67, 4, 4);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (68, 4, 7);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (70, 4, 5);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (72, 4, 6);

--sede 5
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (1, 5, 10);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (2, 5, 10);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (3, 5, 8);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (5, 5, 4);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (7, 5, 6);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (8, 5, 5);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (10, 5, 4);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (12, 5, 7);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (13, 5, 6);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (14, 5, 5);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (16, 5, 4);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (17, 5, 6);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (19, 5, 7);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (21, 5, 5);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (22, 5, 6);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (24, 5, 4);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (25, 5, 7);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (27, 5, 5);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (29, 5, 6);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (30, 5, 7);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (32, 5, 5);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (34, 5, 6);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (36, 5, 7);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (39, 5, 4);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (41, 5, 6);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (43, 5, 5);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (45, 5, 4);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (47, 5, 6);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (48, 5, 5);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (50, 5, 7);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (52, 5, 6);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (54, 5, 4);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (56, 5, 7);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (58, 5, 5);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (60, 5, 6);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (61, 5, 7);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (63, 5, 5);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (65, 5, 6);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (67, 5, 4);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (68, 5, 7);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (70, 5, 5);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (72, 5, 6);

INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (73, 5, 7);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (74, 5, 7);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (75, 5, 2);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (76, 5, 2);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (77, 5, 1);

--Medellin
--sede 6
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (1, 6, 10);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (2, 6, 20);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (3, 6, 10);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (4, 6, 4);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (5, 6, 4);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (6, 6, 10);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (7, 6, 4);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (8, 6, 8);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (9, 6, 6);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (10, 6, 4);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (11, 6, 9);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (12, 6, 5);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (13, 6, 10);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (14, 6, 8);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (15, 6, 5);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (16, 6, 7);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (17, 6, 4);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (18, 6, 9);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (19, 6, 10);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (20, 6, 6);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (21, 6, 6);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (22, 6, 7);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (23, 6, 5);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (24, 6, 9);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (25, 6, 4);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (26, 6, 8);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (27, 6, 8);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (28, 6, 6);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (29, 6, 6);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (30, 6, 9);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (31, 6, 4);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (32, 6, 8);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (33, 6, 8);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (34, 6, 4);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (35, 6, 9);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (36, 6, 7);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (37, 6, 5);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (38, 6, 7);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (39, 6, 4);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (40, 6, 8);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (41, 6, 9);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (42, 6, 3);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (43, 6, 6);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (44, 6, 7);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (45, 6, 5);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (46, 6, 4);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (47, 6, 8);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (48, 6, 9);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (49, 6, 6);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (50, 6, 6);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (51, 6, 4);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (52, 6, 7);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (53, 6, 8);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (54, 6, 4);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (55, 6, 6);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (56, 6, 9);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (57, 6, 7);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (58, 6, 6);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (59, 6, 8);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (60, 6, 6);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (61, 6, 9);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (62, 6, 4);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (63, 6, 7);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (64, 6, 5);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (65, 6, 8);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (66, 6, 6);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (67, 6, 3);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (68, 6, 10);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (69, 6, 5);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (70, 6, 7);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (71, 6, 6);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (72, 6, 9);

INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (73, 6, 9);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (74, 6, 9);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (75, 6, 1);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (76, 6, 2);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (77, 6, 1);

INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (78, 6, 1);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (79, 6, 1);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (80, 6, 1);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (81, 6, 1);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (82, 6, 1);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (83, 6, 1);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (84, 6, 1);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (85, 6, 1);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (86, 6, 1);

--sede 7
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (1, 7, 9);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (2, 7, 15);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (3, 7, 7);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (4, 7, 5);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (5, 7, 6);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (6, 7, 7);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (7, 7, 4);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (8, 7, 5);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (9, 7, 6);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (10, 7, 4);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (11, 7, 6);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (12, 7, 5);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (13, 7, 9);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (14, 7, 7);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (15, 7, 5);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (16, 7, 6);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (19, 7, 7);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (20, 7, 6);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (21, 7, 5);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (22, 7, 6);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (23, 7, 5);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (24, 7, 7);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (25, 7, 3);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (26, 7, 8);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (27, 7, 7);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (28, 7, 6);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (29, 7, 5);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (30, 7, 9);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (31, 7, 5);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (32, 7, 8);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (33, 7, 6);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (34, 7, 3);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (35, 7, 7);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (36, 7, 5);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (37, 7, 5);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (38, 7, 7);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (40, 7, 6);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (41, 7, 7);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (42, 7, 3);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (43, 7, 6);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (44, 7, 5);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (45, 7, 5);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (46, 7, 2);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (47, 7, 6);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (48, 7, 7);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (49, 7, 5);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (50, 7, 6);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (53, 7, 6);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (54, 7, 2);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (55, 7, 6);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (56, 7, 9);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (57, 7, 5);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (58, 7, 5);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (59, 7, 8);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (60, 7, 6);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (61, 7, 9);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (62, 7, 2);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (63, 7, 5);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (64, 7, 6);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (67, 7, 3);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (68, 7, 7);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (69, 7, 2);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (70, 7, 7);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (71, 7, 4);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (72, 7, 8);

INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (78, 7, 1);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (79, 7, 1);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (81, 7, 1);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (82, 7, 1);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (84, 7, 1);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (85, 7, 1);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (86, 7, 1);

--sede 8
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (1, 8, 10);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (2, 8, 12);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (3, 8, 7);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (5, 8, 3);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (7, 8, 5);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (8, 8, 6);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (10, 8, 5);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (12, 8, 8);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (13, 8, 7);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (14, 8, 6);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (16, 8, 5);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (17, 8, 7);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (19, 8, 6);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (21, 8, 4);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (22, 8, 7);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (24, 8, 3);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (25, 8, 8);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (27, 8, 6);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (29, 8, 7);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (30, 8, 6);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (32, 8, 6);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (34, 8, 7);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (36, 8, 6);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (39, 8, 5);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (41, 8, 5);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (43, 8, 6);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (45, 8, 5);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (47, 8, 7);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (48, 8, 6);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (50, 8, 6);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (52, 8, 7);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (54, 8, 5);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (56, 8, 8);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (58, 8, 6);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (60, 8, 7);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (61, 8, 8);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (63, 8, 6);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (65, 8, 7);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (67, 8, 5);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (68, 8, 8);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (70, 8, 6);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (72, 8, 7);

INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (73, 8, 7);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (74, 8, 7);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (75, 8, 2);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (76, 8, 2);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (77, 8, 1);

--sede 9
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (1, 9, 9);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (2, 9, 18);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (3, 9, 9);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (4, 9, 3);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (5, 9, 3);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (6, 9, 9);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (7, 9, 3);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (9, 9, 5);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (11, 9, 8);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (12, 9, 4);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (13, 9, 9);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (14, 9, 7);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (15, 9, 4);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (16, 9, 6);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (17, 9, 3);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (18, 9, 8);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (19, 9, 9);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (20, 9, 5);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (21, 9, 5);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (22, 9, 6);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (23, 9, 4);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (24, 9, 8);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (25, 9, 3);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (28, 9, 5);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (29, 9, 5);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (30, 9, 8);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (31, 9, 3);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (32, 9, 7);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (33, 9, 7);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (34, 9, 3);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (35, 9, 8);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (36, 9, 6);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (37, 9, 4);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (38, 9, 6);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (39, 9, 3);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (40, 9, 7);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (41, 9, 8);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (42, 9, 2);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (43, 9, 5);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (44, 9, 6);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (45, 9, 4);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (46, 9, 3);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (47, 9, 7);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (48, 9, 8);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (49, 9, 5);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (50, 9, 5);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (51, 9, 3);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (52, 9, 6);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (53, 9, 7);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (54, 9, 3);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (55, 9, 5);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (56, 9, 8);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (59, 9, 7);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (60, 9, 5);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (61, 9, 8);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (62, 9, 3);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (63, 9, 6);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (64, 9, 4);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (65, 9, 7);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (66, 9, 5);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (67, 9, 2);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (68, 9, 9);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (69, 9, 4);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (71, 9, 5);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (72, 9, 8);

--sede 10
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (1, 10, 9);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (2, 10, 18);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (3, 10, 9);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (4, 10, 4);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (5, 10, 5);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (6, 10, 9);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (7, 10, 3);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (8, 10, 7);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (9, 10, 5);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (10, 10, 4);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (11, 10, 8);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (12, 10, 5);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (13, 10, 8);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (14, 10, 7);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (15, 10, 5);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (16, 10, 6);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (17, 10, 3);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (18, 10, 8);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (19, 10, 9);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (20, 10, 5);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (21, 10, 6);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (22, 10, 6);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (23, 10, 4);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (24, 10, 9);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (25, 10, 3);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (26, 10, 8);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (27, 10, 7);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (28, 10, 6);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (29, 10, 6);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (30, 10, 8);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (31, 10, 4);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (32, 10, 7);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (33, 10, 7);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (34, 10, 5);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (35, 10, 8);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (36, 10, 6);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (37, 10, 5);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (38, 10, 6);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (39, 10, 4);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (40, 10, 8);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (41, 10, 9);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (42, 10, 2);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (43, 10, 5);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (44, 10, 6);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (45, 10, 5);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (46, 10, 4);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (47, 10, 7);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (48, 10, 8);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (49, 10, 5);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (50, 10, 6);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (51, 10, 3);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (52, 10, 7);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (53, 10, 8);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (54, 10, 4);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (55, 10, 6);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (56, 10, 8);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (57, 10, 7);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (58, 10, 5);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (59, 10, 8);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (60, 10, 6);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (61, 10, 8);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (62, 10, 4);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (63, 10, 7);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (64, 10, 5);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (65, 10, 8);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (66, 10, 6);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (67, 10, 3);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (68, 10, 9);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (69, 10, 4);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (70, 10, 6);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (71, 10, 5);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (72, 10, 8);

INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (73, 10, 9);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (74, 10, 8);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (75, 10, 2);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (76, 10, 1);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (77, 10, 1);

INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (78, 10, 1);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (79, 10, 1);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (80, 10, 1);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (82, 10, 1);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (83, 10, 1);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (84, 10, 1);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (86, 10, 1);
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