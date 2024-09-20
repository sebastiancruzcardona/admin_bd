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
INSERT INTO elemento (elemento, marca) VALUES ('Cinta de correr', 'NordicTrack'); --1
INSERT INTO elemento (elemento, marca) VALUES ('Bicicleta estática', 'Schwinn'); --2
INSERT INTO elemento (elemento, marca) VALUES ('Elíptica', 'ProForm'); --3
INSERT INTO elemento (elemento, marca) VALUES ('Banco de pesas', 'Body-Solid'); --4
INSERT INTO elemento (elemento, marca) VALUES ('Juego de mancuernas', 'Bowflex'); --5
INSERT INTO elemento (elemento, marca) VALUES ('Máquina de remo', 'Concept2'); --6
INSERT INTO elemento (elemento, marca) VALUES ('Máquina de poleas', 'Valor Fitness'); --7
INSERT INTO elemento (elemento, marca) VALUES ('Estera de yoga', 'Manduka'); --8
INSERT INTO elemento (elemento, marca) VALUES ('Balón medicinal', 'Rogue'); --9
INSERT INTO elemento (elemento, marca) VALUES ('Kettlebell', 'Onnit'); --10
INSERT INTO elemento (elemento, marca) VALUES ('Pesas rusas', 'TRX'); --11
INSERT INTO elemento (elemento, marca) VALUES ('Caja pliométrica', 'Titan Fitness'); --12
INSERT INTO elemento (elemento, marca) VALUES ('Soga de batalla', 'AmazonBasics'); --13
INSERT INTO elemento (elemento, marca) VALUES ('Colchoneta de ejercicios', 'Gaiam'); --14
INSERT INTO elemento (elemento, marca) VALUES ('Cuerda para saltar', 'WOD Nation'); --15
INSERT INTO elemento (elemento, marca) VALUES ('Barra olímpica', 'CAP Barbell'); --16
INSERT INTO elemento (elemento, marca) VALUES ('Banco ajustable', 'Rep Fitness'); --17
INSERT INTO elemento (elemento, marca) VALUES ('Prensa de piernas', 'BodyCraft'); --18
INSERT INTO elemento (elemento, marca) VALUES ('Estación de dominadas', 'Iron Gym'); --19 
INSERT INTO elemento (elemento, marca) VALUES ('Estación de fondos', 'Stamina'); --20
INSERT INTO elemento (elemento, marca) VALUES ('Estación de abdominales', 'Perfect Fitness'); --21
INSERT INTO elemento (elemento, marca) VALUES ('Step de aeróbicos', 'Reebok'); --22
INSERT INTO elemento (elemento, marca) VALUES ('Banda de resistencia', 'Fit Simplify'); --23
INSERT INTO elemento (elemento, marca) VALUES ('Rueda abdominal', 'Valeo'); --24
INSERT INTO elemento (elemento, marca) VALUES ('Máquina de esquiador', 'Skierg'); --25
INSERT INTO elemento (elemento, marca) VALUES ('Remo ergómetro', 'Hydrow'); --26
INSERT INTO elemento (elemento, marca) VALUES ('Silla romana', 'Titan Fitness'); --27
INSERT INTO elemento (elemento, marca) VALUES ('Multiestación de entrenamiento', 'Weider'); --28
INSERT INTO elemento (elemento, marca) VALUES ('Pesa rusa ajustable', 'Bowflex'); --29
INSERT INTO elemento (elemento, marca) VALUES ('Sistema de entrenamiento en suspensión', 'TRX'); --30
INSERT INTO elemento (elemento, marca) VALUES ('Rodillo de espuma', 'TriggerPoint'); --31
INSERT INTO elemento (elemento, marca) VALUES ('Chaleco lastrado', 'RUNmax'); --32
INSERT INTO elemento (elemento, marca) VALUES ('Escaladora', 'StairMaster'); --33
INSERT INTO elemento (elemento, marca) VALUES ('Caja de pesas', 'Cap Barbell'); --34
INSERT INTO elemento (elemento, marca) VALUES ('Estación de sentadillas', 'Fitness Reality'); --35
INSERT INTO elemento (elemento, marca) VALUES ('Máquina de press de hombros', 'Valor Fitness'); --36
INSERT INTO elemento (elemento, marca) VALUES ('Máquina de glúteos', 'Body-Solid'); --37
INSERT INTO elemento (elemento, marca) VALUES ('Chaleco de sauna', 'TNT Pro Series'); --38
INSERT INTO elemento (elemento, marca) VALUES ('Barra de dominadas', 'Ultimate Body Press'); --39
INSERT INTO elemento (elemento, marca) VALUES ('Discos de competición', 'Rogue'); --40
INSERT INTO elemento (elemento, marca) VALUES ('Cinta de yoga', 'Manduka'); --41
INSERT INTO elemento (elemento, marca) VALUES ('Cinturón de levantamiento de pesas', 'Harbinger'); --42
INSERT INTO elemento (elemento, marca) VALUES ('Guantes de entrenamiento', 'Nike'); --43
INSERT INTO elemento (elemento, marca) VALUES ('Soporte de discos', 'Body-Solid'); --44
INSERT INTO elemento (elemento, marca) VALUES ('Máquina de pecho', 'Life Fitness'); --45
INSERT INTO elemento (elemento, marca) VALUES ('Estación de barras paralelas', 'Lebert Fitness'); --46
INSERT INTO elemento (elemento, marca) VALUES ('Cuerda de escalada', 'Titan Fitness'); --47
INSERT INTO elemento (elemento, marca) VALUES ('Soporte para mancuernas', 'Body-Solid'); --48
INSERT INTO elemento (elemento, marca) VALUES ('Disco de 5kg', 'Rogue'); --49
INSERT INTO elemento (elemento, marca) VALUES ('Disco de 10kg', 'Rogue'); --50
INSERT INTO elemento (elemento, marca) VALUES ('Disco de 15kg', 'Rogue'); --51
INSERT INTO elemento (elemento, marca) VALUES ('Disco de 20kg', 'Rogue'); --52
INSERT INTO elemento (elemento, marca) VALUES ('Mancuerna de 2kg', 'Bowflex'); --53
INSERT INTO elemento (elemento, marca) VALUES ('Mancuerna de 4kg', 'Bowflex'); --54
INSERT INTO elemento (elemento, marca) VALUES ('Mancuerna de 6kg', 'Bowflex'); --55
INSERT INTO elemento (elemento, marca) VALUES ('Mancuerna de 8kg', 'Bowflex'); --56
INSERT INTO elemento (elemento, marca) VALUES ('Mancuerna de 10kg', 'Bowflex'); --57
INSERT INTO elemento (elemento, marca) VALUES ('Mancuerna de 12kg', 'Bowflex'); --58
INSERT INTO elemento (elemento, marca) VALUES ('Mancuerna de 14kg', 'Bowflex'); --59
INSERT INTO elemento (elemento, marca) VALUES ('Mancuerna de 16kg', 'Bowflex'); --60
INSERT INTO elemento (elemento, marca) VALUES ('Mancuerna de 18kg', 'Bowflex'); --61
INSERT INTO elemento (elemento, marca) VALUES ('Mancuerna de 20kg', 'Bowflex'); --62
INSERT INTO elemento (elemento, marca) VALUES ('Mancuerna de 22kg', 'Bowflex'); --63
INSERT INTO elemento (elemento, marca) VALUES ('Mancuerna de 24kg', 'Bowflex'); --64
INSERT INTO elemento (elemento, marca) VALUES ('Mancuerna de 26kg', 'Bowflex'); --65
INSERT INTO elemento (elemento, marca) VALUES ('Mancuerna de 28kg', 'Bowflex'); --66
INSERT INTO elemento (elemento, marca) VALUES ('Mancuerna de 30kg', 'Bowflex'); --67
INSERT INTO elemento (elemento, marca) VALUES ('Mancuerna de 32kg', 'Bowflex'); --68
INSERT INTO elemento (elemento, marca) VALUES ('Mancuerna de 34kg', 'Bowflex'); --69
INSERT INTO elemento (elemento, marca) VALUES ('Mancuerna de 36kg', 'Bowflex'); --70
INSERT INTO elemento (elemento, marca) VALUES ('Mancuerna de 38kg', 'Bowflex'); --71
INSERT INTO elemento (elemento, marca) VALUES ('Mancuerna de 40kg', 'Bowflex'); --72
INSERT INTO elemento (elemento, marca) VALUES ('Chaleco salvavidas', 'Speedo'); --73 piscina
INSERT INTO elemento (elemento, marca) VALUES ('Flotador de entrenamiento', 'AquaJogger'); --74 piscina
INSERT INTO elemento (elemento, marca) VALUES ('Red de seguridad para piscina', 'Pool Guard'); --75 piscina
INSERT INTO elemento (elemento, marca) VALUES ('Escalera para piscina', 'Intex'); --76 piscina
INSERT INTO elemento (elemento, marca) VALUES ('Sistema de filtración de piscina', 'Hayward'); --77 piscina
INSERT INTO elemento (elemento, marca) VALUES ('Vitrina de exhibición', 'Ikea'); --78
INSERT INTO elemento (elemento, marca) VALUES ('Mostrador de atención', 'Ikea'); --79
INSERT INTO elemento (elemento, marca) VALUES ('Estantería de almacenamiento', 'AmazonBasics'); --80
INSERT INTO elemento (elemento, marca) VALUES ('Caja registradora', 'Sharp'); --81
INSERT INTO elemento (elemento, marca) VALUES ('Refrigerador para bebidas', 'Frigidaire'); --82
INSERT INTO elemento (elemento, marca) VALUES ('Soporte para folletos', 'Displays2go'); --83
INSERT INTO elemento (elemento, marca) VALUES ('Sistema de punto de venta', 'Square'); --84
INSERT INTO elemento (elemento, marca) VALUES ('Carro de almacenamiento', 'Seville Classics'); --85
INSERT INTO elemento (elemento, marca) VALUES ('Iluminación para vitrinas', 'Philips'); --86
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
INSERT INTO cargo (cargo, id_departamento) VALUES ('Entrenador Personal', 1); --1
INSERT INTO cargo (cargo, id_departamento) VALUES ('Instructor de Clases Grupales', 1); --2
INSERT INTO cargo (cargo, id_departamento) VALUES ('Coordinador de Entrenamiento', 1); --3
INSERT INTO cargo (cargo, id_departamento) VALUES ('Fisioterapeuta', 2); --4
INSERT INTO cargo (cargo, id_departamento) VALUES ('Rehabilitador Deportivo', 2); --5
INSERT INTO cargo (cargo, id_departamento) VALUES ('Asistente de Fisioterapia', 2); --6
INSERT INTO cargo (cargo, id_departamento) VALUES ('Instructor de Actividades para Ninos', 3); --7
INSERT INTO cargo (cargo, id_departamento) VALUES ('Cuidador', 3); --8
INSERT INTO cargo (cargo, id_departamento) VALUES ('Operario de Mantenimiento', 4); --9
INSERT INTO cargo (cargo, id_departamento) VALUES ('Jefe de Mantenimiento', 4); --10
INSERT INTO cargo (cargo, id_departamento) VALUES ('Auxiliar de servicios generales', 4); --11
INSERT INTO cargo (cargo, id_departamento) VALUES ('Auxiliar de Atencion al Cliente', 5); --12
INSERT INTO cargo (cargo, id_departamento) VALUES ('Coordinador de Servicio al Cliente', 5); --13
INSERT INTO cargo (cargo, id_departamento) VALUES ('Nutricionista', 6); --14
INSERT INTO cargo (cargo, id_departamento) VALUES ('Asesor de Suplementacion', 6); --15
INSERT INTO cargo (cargo, id_departamento) VALUES ('Abogado Corporativo', 7); --16
INSERT INTO cargo (cargo, id_departamento) VALUES ('Asistente Legal', 7); --17
INSERT INTO cargo (cargo, id_departamento) VALUES ('Gerente de Marketing', 8); --18
INSERT INTO cargo (cargo, id_departamento) VALUES ('Publicista', 8); --19
INSERT INTO cargo (cargo, id_departamento) VALUES ('Disenador', 8); --20
INSERT INTO cargo (cargo, id_departamento) VALUES ('Gerente de general', 9); --21
INSERT INTO cargo (cargo, id_departamento) VALUES ('Gerente de sede', 9); --22
INSERT INTO cargo (cargo, id_departamento) VALUES ('Contador', 9); --23
INSERT INTO cargo (cargo, id_departamento) VALUES ('Asistente Administrativo', 9);--24
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
--sede 8
--sede 10
--sede 11
--sede 12
--sede 14
--sede 17
--sede 19
--sede 22
--sede 23
--sede 25
--sede 28


--Sedes pequeñas
--sede 2
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (1, 2, 6);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (2, 2, 10);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (3, 2, 8);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (4, 2, 2);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (5, 2, 3);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (6, 2, 8);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (7, 2, 2);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (8, 2, 6);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (9, 2, 5);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (10, 2, 3);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (11, 2, 7);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (12, 2, 4);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (13, 2, 8);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (14, 2, 6);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (15, 2, 3);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (16, 2, 5);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (17, 2, 2);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (18, 2, 7);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (19, 2, 8);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (20, 2, 4);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (21, 2, 5);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (22, 2, 6);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (23, 2, 3);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (24, 2, 8);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (25, 2, 2);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (26, 2, 7);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (27, 2, 6);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (28, 2, 4);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (29, 2, 5);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (30, 2, 8);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (31, 2, 3);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (32, 2, 7);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (33, 2, 6);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (34, 2, 2);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (35, 2, 8);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (36, 2, 5);
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
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (64, 2, 4);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (65, 2, 7);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (66, 2, 5);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (67, 2, 2);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (68, 2, 8);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (69, 2, 3);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (70, 2, 6);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (71, 2, 5);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (72, 2, 7);

INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (78, 2, 1);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (79, 2, 1);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (80, 2, 1);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (81, 2, 1);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (82, 2, 1);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (83, 2, 1);

--sede 3
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (1, 3, 6);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (2, 3, 10);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (3, 3, 8);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (4, 3, 2);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (5, 3, 3);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (6, 3, 8);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (7, 3, 2);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (8, 3, 6);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (9, 3, 5);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (10, 3, 3);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (11, 3, 7);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (12, 3, 4);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (13, 3, 8);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (14, 3, 6);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (15, 3, 3);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (16, 3, 5);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (17, 3, 2);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (18, 3, 7);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (19, 3, 8);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (20, 3, 4);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (21, 3, 5);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (22, 3, 6);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (23, 3, 3);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (24, 3, 8);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (25, 3, 2);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (26, 3, 7);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (27, 3, 6);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (28, 3, 4);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (29, 3, 5);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (30, 3, 8);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (31, 3, 3);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (32, 3, 7);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (33, 3, 6);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (34, 3, 2);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (35, 3, 8);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (36, 3, 5);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (37, 3, 4);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (38, 3, 6);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (39, 3, 3);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (40, 3, 7);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (41, 3, 8);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (42, 3, 2);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (43, 3, 5);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (44, 3, 6);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (45, 3, 4);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (46, 3, 3);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (47, 3, 7);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (48, 3, 8);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (49, 3, 4);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (50, 3, 5);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (51, 3, 2);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (52, 3, 6);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (53, 3, 7);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (54, 3, 3);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (55, 3, 5);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (56, 3, 8);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (57, 3, 6);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (58, 3, 4);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (59, 3, 7);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (60, 3, 5);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (61, 3, 8);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (62, 3, 3);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (63, 3, 6);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (64, 3, 4);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (65, 3, 7);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (66, 3, 5);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (67, 3, 2);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (68, 3, 8);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (69, 3, 3);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (70, 3, 6);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (71, 3, 5);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (72, 3, 7);

INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (78, 3, 1);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (79, 3, 1);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (80, 3, 1);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (81, 3, 1);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (82, 3, 1);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (83, 3, 1);

--sede 5
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (1, 5, 6);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (2, 5, 10);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (3, 5, 8);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (4, 5, 2);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (5, 5, 3);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (6, 5, 8);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (7, 5, 2);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (8, 5, 6);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (9, 5, 5);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (10, 5, 3);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (11, 5, 7);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (12, 5, 4);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (13, 5, 8);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (14, 5, 6);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (15, 5, 3);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (16, 5, 5);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (17, 5, 2);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (18, 5, 7);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (19, 5, 8);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (20, 5, 4);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (21, 5, 5);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (22, 5, 6);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (23, 5, 3);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (24, 5, 8);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (25, 5, 2);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (26, 5, 7);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (27, 5, 6);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (28, 5, 4);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (29, 5, 5);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (30, 5, 8);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (31, 5, 3);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (32, 5, 7);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (33, 5, 6);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (34, 5, 2);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (35, 5, 8);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (36, 5, 5);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (37, 5, 4);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (38, 5, 6);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (39, 5, 3);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (40, 5, 7);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (41, 5, 8);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (42, 5, 2);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (43, 5, 5);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (44, 5, 6);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (45, 5, 4);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (46, 5, 3);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (47, 5, 7);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (48, 5, 8);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (49, 5, 4);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (50, 5, 5);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (51, 5, 2);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (52, 5, 6);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (53, 5, 7);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (54, 5, 3);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (55, 5, 5);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (56, 5, 8);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (57, 5, 6);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (58, 5, 4);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (59, 5, 7);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (60, 5, 5);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (61, 5, 8);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (62, 5, 3);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (63, 5, 6);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (64, 5, 4);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (65, 5, 7);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (66, 5, 5);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (67, 5, 2);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (68, 5, 8);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (69, 5, 3);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (70, 5, 6);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (71, 5, 5);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (72, 5, 7);

INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (78, 5, 1);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (79, 5, 1);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (80, 5, 1);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (81, 5, 1);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (82, 5, 1);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (83, 5, 1);

--sede 6
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (1, 6, 7);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (2, 6, 9);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (3, 6, 8);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (4, 6, 2);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (5, 6, 4);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (6, 6, 7);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (7, 6, 3);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (8, 6, 7);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (9, 6, 6);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (10, 6, 3);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (11, 6, 6);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (12, 6, 5);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (13, 6, 8);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (14, 6, 5);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (15, 6, 4);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (16, 6, 6);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (17, 6, 3);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (18, 6, 8);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (19, 6, 9);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (20, 6, 3);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (21, 6, 6);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (22, 6, 7);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (23, 6, 4);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (24, 6, 7);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (25, 6, 3);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (26, 6, 6);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (27, 6, 7);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (28, 6, 5);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (29, 6, 4);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (30, 6, 8);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (31, 6, 4);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (32, 6, 6);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (33, 6, 7);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (34, 6, 3);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (35, 6, 9);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (36, 6, 4);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (37, 6, 5);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (38, 6, 6);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (39, 6, 2);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (40, 6, 6);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (41, 6, 9);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (42, 6, 3);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (43, 6, 6);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (44, 6, 7);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (45, 6, 5);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (46, 6, 2);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (47, 6, 6);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (48, 6, 7);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (49, 6, 5);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (50, 6, 4);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (51, 6, 3);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (52, 6, 5);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (53, 6, 6);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (54, 6, 4);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (55, 6, 5);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (56, 6, 9);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (57, 6, 7);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (58, 6, 3);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (59, 6, 6);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (60, 6, 5);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (61, 6, 9);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (62, 6, 4);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (63, 6, 7);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (64, 6, 5);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (65, 6, 6);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (66, 6, 4);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (67, 6, 2);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (68, 6, 7);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (69, 6, 3);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (70, 6, 5);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (71, 6, 6);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (72, 6, 7);

INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (78, 6, 1);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (79, 6, 1);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (80, 6, 1);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (81, 6, 1);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (82, 6, 1);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (83, 6, 1);

--sede 9
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (1, 9, 7);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (2, 9, 9);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (3, 9, 8);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (4, 9, 2);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (5, 9, 4);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (6, 9, 7);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (7, 9, 3);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (8, 9, 7);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (9, 9, 6);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (10, 9, 3);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (11, 9, 6);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (12, 9, 5);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (13, 9, 8);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (14, 9, 5);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (15, 9, 4);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (16, 9, 6);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (17, 9, 3);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (18, 9, 8);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (19, 9, 9);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (20, 9, 3);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (21, 9, 6);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (22, 9, 7);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (23, 9, 4);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (24, 9, 7);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (25, 9, 3);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (26, 9, 6);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (27, 9, 7);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (28, 9, 5);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (29, 9, 4);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (30, 9, 8);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (31, 9, 4);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (32, 9, 6);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (33, 9, 7);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (34, 9, 3);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (35, 9, 9);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (36, 9, 4);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (37, 9, 5);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (38, 9, 6);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (39, 9, 2);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (40, 9, 6);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (41, 9, 9);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (42, 9, 3);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (43, 9, 6);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (44, 9, 7);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (45, 9, 5);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (46, 9, 2);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (47, 9, 6);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (48, 9, 7);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (49, 9, 5);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (50, 9, 4);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (51, 9, 3);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (52, 9, 5);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (53, 9, 6);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (54, 9, 4);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (55, 9, 5);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (56, 9, 9);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (57, 9, 7);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (58, 9, 3);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (59, 9, 6);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (60, 9, 5);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (61, 9, 9);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (62, 9, 4);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (63, 9, 7);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (64, 9, 5);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (65, 9, 6);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (66, 9, 4);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (67, 9, 2);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (68, 9, 7);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (69, 9, 3);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (70, 9, 5);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (71, 9, 6);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (72, 9, 7);

INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (78, 9, 1);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (79, 9, 1);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (80, 9, 1);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (81, 9, 1);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (82, 9, 1);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (83, 9, 1);

--sede 13
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (1, 13, 7);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (2, 13, 9);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (3, 13, 8);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (4, 13, 2);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (5, 13, 4);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (6, 13, 7);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (7, 13, 3);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (8, 13, 7);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (9, 13, 6);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (10, 13, 3);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (11, 13, 6);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (12, 13, 5);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (13, 13, 8);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (14, 13, 5);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (15, 13, 4);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (16, 13, 6);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (17, 13, 3);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (18, 13, 8);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (19, 13, 9);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (20, 13, 3);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (21, 13, 6);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (22, 13, 7);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (23, 13, 4);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (24, 13, 7);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (25, 13, 3);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (26, 13, 6);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (27, 13, 7);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (28, 13, 5);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (29, 13, 4);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (30, 13, 8);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (31, 13, 4);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (32, 13, 6);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (33, 13, 7);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (34, 13, 3);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (35, 13, 9);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (36, 13, 4);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (37, 13, 5);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (38, 13, 6);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (39, 13, 2);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (40, 13, 6);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (41, 13, 9);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (42, 13, 3);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (43, 13, 6);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (44, 13, 7);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (45, 13, 5);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (46, 13, 2);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (47, 13, 6);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (48, 13, 7);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (49, 13, 5);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (50, 13, 4);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (51, 13, 3);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (52, 13, 5);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (53, 13, 6);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (54, 13, 4);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (55, 13, 5);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (56, 13, 9);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (57, 13, 7);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (58, 13, 3);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (59, 13, 6);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (60, 13, 5);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (61, 13, 9);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (62, 13, 4);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (63, 13, 7);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (64, 13, 5);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (65, 13, 6);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (66, 13, 4);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (67, 13, 2);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (68, 13, 7);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (69, 13, 3);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (70, 13, 5);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (71, 13, 6);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (72, 13, 7);

--sede 15
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (1, 15, 7);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (2, 15, 9);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (3, 15, 8);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (4, 15, 2);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (5, 15, 4);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (6, 15, 7);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (7, 15, 3);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (8, 15, 7);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (9, 15, 6);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (10, 15, 3);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (11, 15, 6);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (12, 15, 5);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (13, 15, 8);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (14, 15, 5);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (15, 15, 4);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (16, 15, 6);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (17, 15, 3);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (18, 15, 8);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (19, 15, 9);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (20, 15, 3);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (21, 15, 6);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (22, 15, 7);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (23, 15, 4);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (24, 15, 7);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (25, 15, 3);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (26, 15, 6);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (27, 15, 7);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (28, 15, 5);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (29, 15, 4);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (30, 15, 8);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (31, 15, 4);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (32, 15, 6);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (33, 15, 7);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (34, 15, 3);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (35, 15, 9);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (36, 15, 4);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (37, 15, 5);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (38, 15, 6);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (39, 15, 2);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (40, 15, 6);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (41, 15, 9);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (42, 15, 3);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (43, 15, 6);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (44, 15, 7);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (45, 15, 5);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (46, 15, 2);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (47, 15, 6);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (48, 15, 7);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (49, 15, 5);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (50, 15, 4);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (51, 15, 3);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (52, 15, 5);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (53, 15, 6);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (54, 15, 4);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (55, 15, 5);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (56, 15, 9);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (57, 15, 7);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (58, 15, 3);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (59, 15, 6);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (60, 15, 5);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (61, 15, 9);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (62, 15, 4);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (63, 15, 7);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (64, 15, 5);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (65, 15, 6);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (66, 15, 4);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (67, 15, 2);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (68, 15, 7);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (69, 15, 3);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (70, 15, 5);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (71, 15, 6);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (72, 15, 7);

INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (78, 15, 1);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (79, 15, 1);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (80, 15, 1);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (81, 15, 1);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (82, 15, 1);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (83, 15, 1);

--sede 16
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (1, 16, 9);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (2, 16, 11);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (3, 16, 10);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (4, 16, 4);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (5, 16, 6);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (6, 16, 9);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (7, 16, 5);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (8, 16, 9);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (9, 16, 8);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (10, 16, 5);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (11, 16, 8);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (12, 16, 6);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (13, 16, 10);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (14, 16, 7);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (15, 16, 6);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (16, 16, 8);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (17, 16, 5);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (18, 16, 10);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (19, 16, 11);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (20, 16, 5);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (21, 16, 8);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (22, 16, 9);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (23, 16, 6);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (24, 16, 9);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (25, 16, 5);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (26, 16, 8);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (27, 16, 9);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (28, 16, 7);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (29, 16, 6);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (30, 16, 10);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (31, 16, 6);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (32, 16, 8);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (33, 16, 9);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (34, 16, 5);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (35, 16, 11);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (36, 16, 6);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (37, 16, 7);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (38, 16, 8);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (39, 16, 4);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (40, 16, 8);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (41, 16, 11);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (42, 16, 5);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (43, 16, 8);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (44, 16, 9);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (45, 16, 7);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (46, 16, 4);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (47, 16, 8);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (48, 16, 9);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (49, 16, 7);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (50, 16, 6);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (51, 16, 5);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (52, 16, 7);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (53, 16, 8);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (54, 16, 6);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (55, 16, 7);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (56, 16, 11);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (57, 16, 9);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (58, 16, 5);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (59, 16, 8);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (60, 16, 7);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (61, 16, 10);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (62, 16, 6);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (63, 16, 9);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (64, 16, 7);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (65, 16, 8);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (66, 16, 6);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (67, 16, 4);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (68, 16, 9);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (69, 16, 5);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (70, 16, 7);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (71, 16, 8);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (72, 16, 9);

INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (78, 16, 1);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (79, 16, 1);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (80, 16, 1);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (81, 16, 1);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (82, 16, 1);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (83, 16, 1);

--sede 18
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (1, 18, 9);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (2, 18, 11);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (3, 18, 10);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (4, 18, 4);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (5, 18, 6);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (6, 18, 9);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (7, 18, 5);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (8, 18, 9);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (9, 18, 8);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (10, 18, 5);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (11, 18, 8);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (12, 18, 6);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (13, 18, 10);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (14, 18, 7);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (15, 18, 6);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (16, 18, 8);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (17, 18, 5);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (18, 18, 10);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (19, 18, 11);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (20, 18, 5);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (21, 18, 8);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (22, 18, 9);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (23, 18, 6);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (24, 18, 9);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (25, 18, 5);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (26, 18, 8);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (27, 18, 9);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (28, 18, 7);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (29, 18, 6);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (30, 18, 10);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (31, 18, 6);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (32, 18, 8);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (33, 18, 9);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (34, 18, 5);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (35, 18, 11);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (36, 18, 6);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (37, 18, 7);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (38, 18, 8);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (39, 18, 4);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (40, 18, 8);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (41, 18, 11);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (42, 18, 5);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (43, 18, 8);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (44, 18, 9);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (45, 18, 7);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (46, 18, 4);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (47, 18, 8);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (48, 18, 9);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (49, 18, 7);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (50, 18, 6);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (51, 18, 5);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (52, 18, 7);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (53, 18, 8);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (54, 18, 6);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (55, 18, 7);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (56, 18, 11);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (57, 18, 9);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (58, 18, 5);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (59, 18, 8);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (60, 18, 7);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (61, 18, 10);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (62, 18, 6);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (63, 18, 9);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (64, 18, 7);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (65, 18, 8);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (66, 18, 6);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (67, 18, 4);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (68, 18, 9);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (69, 18, 5);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (70, 18, 7);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (71, 18, 8);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (72, 18, 9);

INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (78, 18, 1);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (79, 18, 1);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (80, 18, 1);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (81, 18, 1);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (82, 18, 1);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (83, 18, 1);

--sede 20
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (1, 20, 7);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (2, 20, 9);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (3, 20, 8);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (4, 20, 2);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (5, 20, 4);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (6, 20, 7);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (7, 20, 3);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (8, 20, 7);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (9, 20, 6);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (10, 20, 3);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (11, 20, 6);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (12, 20, 5);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (13, 20, 8);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (14, 20, 5);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (15, 20, 4);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (16, 20, 6);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (17, 20, 3);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (18, 20, 8);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (19, 20, 9);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (20, 20, 3);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (21, 20, 6);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (22, 20, 7);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (23, 20, 4);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (24, 20, 7);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (25, 20, 3);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (26, 20, 6);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (27, 20, 7);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (28, 20, 5);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (29, 20, 4);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (30, 20, 8);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (31, 20, 4);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (32, 20, 6);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (33, 20, 7);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (34, 20, 3);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (35, 20, 9);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (36, 20, 4);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (37, 20, 5);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (38, 20, 6);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (39, 20, 2);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (40, 20, 6);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (41, 20, 9);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (42, 20, 3);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (43, 20, 6);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (44, 20, 7);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (45, 20, 5);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (46, 20, 2);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (47, 20, 6);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (48, 20, 7);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (49, 20, 5);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (50, 20, 4);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (51, 20, 3);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (52, 20, 5);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (53, 20, 6);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (54, 20, 4);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (55, 20, 5);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (56, 20, 9);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (57, 20, 7);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (58, 20, 3);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (59, 20, 6);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (60, 20, 5);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (61, 20, 9);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (62, 20, 4);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (63, 20, 7);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (64, 20, 5);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (65, 20, 6);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (66, 20, 4);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (67, 20, 2);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (68, 20, 7);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (69, 20, 3);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (70, 20, 5);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (71, 20, 6);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (72, 20, 7);

INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (78, 20, 1);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (79, 20, 1);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (80, 20, 1);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (81, 20, 1);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (82, 20, 1);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (83, 20, 1);

--sede 21
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (1, 21, 7);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (2, 21, 9);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (3, 21, 8);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (4, 21, 4);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (5, 21, 4);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (6, 21, 7);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (7, 21, 4);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (8, 21, 7);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (9, 21, 6);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (10, 21, 4); 
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (11, 21, 6);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (12, 21, 5);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (13, 21, 8);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (14, 21, 5);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (15, 21, 4);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (16, 21, 6);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (17, 21, 4); 
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (18, 21, 8);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (19, 21, 9);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (20, 21, 4); 
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (21, 21, 6);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (22, 21, 7);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (23, 21, 4);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (24, 21, 7);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (25, 21, 4); 
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (26, 21, 6);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (27, 21, 7);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (28, 21, 5);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (29, 21, 4);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (30, 21, 8);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (31, 21, 4);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (32, 21, 6);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (33, 21, 7);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (34, 21, 4); 
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (35, 21, 9);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (36, 21, 4);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (37, 21, 5);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (38, 21, 6);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (39, 21, 4); 
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (40, 21, 6);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (41, 21, 9);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (42, 21, 4); 
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (43, 21, 6);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (44, 21, 7);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (45, 21, 5);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (46, 21, 4);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (47, 21, 6);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (48, 21, 7);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (49, 21, 5);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (50, 21, 4);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (51, 21, 4);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (52, 21, 5);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (53, 21, 6);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (54, 21, 4);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (55, 21, 5);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (56, 21, 9);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (57, 21, 7);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (58, 21, 4); 
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (59, 21, 6);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (60, 21, 5);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (61, 21, 9);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (62, 21, 4);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (63, 21, 7);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (64, 21, 5);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (65, 21, 6);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (66, 21, 4);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (67, 21, 4);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (68, 21, 7);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (69, 21, 4); 
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (70, 21, 5);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (71, 21, 6);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (72, 21, 7);


INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (78, 21, 1);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (79, 21, 1);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (80, 21, 1);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (81, 21, 1);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (82, 21, 1);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (83, 21, 1);

--sede 24
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (1, 24, 7);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (2, 24, 9);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (3, 24, 8);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (4, 24, 2);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (5, 24, 4);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (6, 24, 7);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (7, 24, 3);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (8, 24, 7);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (9, 24, 6);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (10, 24, 3);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (11, 24, 6);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (12, 24, 5);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (13, 24, 8);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (14, 24, 5);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (15, 24, 4);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (16, 24, 6);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (17, 24, 3);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (18, 24, 8);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (19, 24, 9);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (20, 24, 3);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (21, 24, 6);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (22, 24, 7);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (23, 24, 4);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (24, 24, 7);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (25, 24, 3);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (26, 24, 6);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (27, 24, 7);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (28, 24, 5);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (29, 24, 4);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (30, 24, 8);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (31, 24, 4);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (32, 24, 6);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (33, 24, 7);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (34, 24, 3);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (35, 24, 9);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (36, 24, 4);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (37, 24, 5);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (38, 24, 6);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (39, 24, 2);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (40, 24, 6);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (41, 24, 9);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (42, 24, 3);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (43, 24, 6);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (44, 24, 7);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (45, 24, 5);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (46, 24, 2);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (47, 24, 6);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (48, 24, 7);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (49, 24, 5);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (50, 24, 4);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (51, 24, 3);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (52, 24, 5);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (53, 24, 6);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (54, 24, 4);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (55, 24, 5);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (56, 24, 9);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (57, 24, 7);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (58, 24, 3);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (59, 24, 6);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (60, 24, 5);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (61, 24, 9);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (62, 24, 4);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (63, 24, 7);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (64, 24, 5);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (65, 24, 6);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (66, 24, 4);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (67, 24, 2);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (68, 24, 7);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (69, 24, 3);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (70, 24, 5);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (71, 24, 6);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (72, 24, 7);

INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (78, 24, 1);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (79, 24, 1);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (80, 24, 1);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (81, 24, 1);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (82, 24, 1);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (83, 24, 1);

--sede 26
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (1, 26, 7);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (2, 26, 9);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (3, 26, 8);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (4, 26, 2);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (5, 26, 4);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (6, 26, 7);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (7, 26, 3);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (8, 26, 7);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (9, 26, 6);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (10, 26, 3);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (11, 26, 6);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (12, 26, 5);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (13, 26, 8);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (14, 26, 5);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (15, 26, 4);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (16, 26, 6);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (17, 26, 3);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (18, 26, 8);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (19, 26, 9);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (20, 26, 3);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (21, 26, 6);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (22, 26, 7);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (23, 26, 4);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (24, 26, 7);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (25, 26, 3);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (26, 26, 6);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (27, 26, 7);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (28, 26, 5);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (29, 26, 4);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (30, 26, 8);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (31, 26, 4);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (32, 26, 6);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (33, 26, 7);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (34, 26, 3);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (35, 26, 9);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (36, 26, 4);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (37, 26, 5);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (38, 26, 6);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (39, 26, 2);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (40, 26, 6);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (41, 26, 9);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (42, 26, 3);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (43, 26, 6);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (44, 26, 7);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (45, 26, 5);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (46, 26, 2);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (47, 26, 6);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (48, 26, 7);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (49, 26, 5);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (50, 26, 4);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (51, 26, 3);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (52, 26, 5);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (53, 26, 6);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (54, 26, 4);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (55, 26, 5);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (56, 26, 9);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (57, 26, 7);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (58, 26, 3);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (59, 26, 6);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (60, 26, 5);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (61, 26, 9);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (62, 26, 4);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (63, 26, 7);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (64, 26, 5);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (65, 26, 6);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (66, 26, 4);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (67, 26, 2);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (68, 26, 7);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (69, 26, 3);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (70, 26, 5);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (71, 26, 6);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (72, 26, 7);

INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (78, 26, 1);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (79, 26, 1);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (80, 26, 1);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (81, 26, 1);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (82, 26, 1);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (83, 26, 1);

--sede 27
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (1, 27, 6);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (2, 27, 10);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (3, 27, 8);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (4, 27, 2);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (5, 27, 3);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (6, 27, 8);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (7, 27, 2);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (8, 27, 6);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (9, 27, 5);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (10, 27, 3);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (11, 27, 7);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (12, 27, 4);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (13, 27, 8);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (14, 27, 6);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (15, 27, 3);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (16, 27, 5);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (17, 27, 2);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (18, 27, 7);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (19, 27, 8);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (20, 27, 4);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (21, 27, 5);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (22, 27, 6);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (23, 27, 3);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (24, 27, 8);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (25, 27, 2);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (26, 27, 7);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (27, 27, 6);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (28, 27, 4);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (29, 27, 5);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (30, 27, 8);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (31, 27, 3);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (32, 27, 7);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (33, 27, 6);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (34, 27, 2);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (35, 27, 8);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (36, 27, 5);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (37, 27, 4);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (38, 27, 6);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (39, 27, 3);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (40, 27, 7);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (41, 27, 8);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (42, 27, 2);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (43, 27, 5);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (44, 27, 6);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (45, 27, 4);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (46, 27, 3);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (47, 27, 7);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (48, 27, 8);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (49, 27, 4);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (50, 27, 5);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (51, 27, 2);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (52, 27, 6);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (53, 27, 7);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (54, 27, 3);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (55, 27, 5);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (56, 27, 8);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (57, 27, 6);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (58, 27, 4);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (59, 27, 7);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (60, 27, 5);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (61, 27, 8);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (62, 27, 3);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (63, 27, 6);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (64, 27, 4);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (65, 27, 7);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (66, 27, 5);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (67, 27, 2);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (68, 27, 8);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (69, 27, 3);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (70, 27, 6);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (71, 27, 5);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (72, 27, 7);

INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (78, 27, 1);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (79, 27, 1);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (80, 27, 1);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (81, 27, 1);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (82, 27, 1);
INSERT INTO elementos_sede (id_elemento, id_sede, cantidad) VALUES (83, 27, 1);
-----------------------------------------------------

-----------------------------------------------------
--empleados
--Sedes grandes
--sede 1

-- Entrenadores y Personal de Entrenamiento
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Ana', 'Gómez', '0000000000', TO_DATE('1985-04-15', 'YYYY-MM-DD'), '3000000000', 'ana.gomez@ejemplo.com', 1, 1, 1); -- Entrenador Personal
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Rogelio', 'Gómez', '0000000001', TO_DATE('1986-04-16', 'YYYY-MM-DD'), '3000000001', 'roge.gomez@ejemplo.com', 1, 1, 1); -- Entrenador Personal
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Eustaquio', 'Pérez', '0000000002', TO_DATE('1980-02-16', 'YYYY-MM-DD'), '3000000002', 'eus.gomez@ejemplo.com', 1, 1, 1); -- Entrenador Personal
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Luis', 'Pérez', '0000000003', TO_DATE('1983-08-22', 'YYYY-MM-DD'), '3000000003', 'luis.perez@ejemplo.com', 1, 1, 2); -- Instructor de Clases Grupales
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Carlos', 'Morales', '0000000004', TO_DATE('1987-11-30', 'YYYY-MM-DD'), '3000000004', 'carlos.morales@ejemplo.com', 1, 1, 3); -- Coordinador de Entrenamiento
-- Fisioterapeutas y Asistentes
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Sofía', 'Vásquez', '0000000005', TO_DATE('1986-02-14', 'YYYY-MM-DD'), '3000000005', 'sofia.vasquez@ejemplo.com', 1, 1, 4); -- Fisioterapeuta
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Julio', 'Ramírez', '0000000006', TO_DATE('1990-06-25', 'YYYY-MM-DD'), '3000000006', 'julio.ramirez@ejemplo.com', 1, 1, 5); -- Rehabilitador Deportivo
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Laura', 'García', '0000000007', TO_DATE('1989-03-17', 'YYYY-MM-DD'), '3000000007', 'laura.garcia@ejemplo.com', 1, 1, 6); -- Asistente de Fisioterapia
-- Instructores para Niños
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Miguel', 'Hernández', '0000000008', TO_DATE('1992-07-08', 'YYYY-MM-DD'), '3000000008', 'miguel.hernandez@ejemplo.com', 1, 1, 7); -- Instructor de Actividades para Niños
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Claudia', 'Martínez', '0000000009', TO_DATE('1984-12-05', 'YYYY-MM-DD'), '3000000009', 'claudia.martinez@ejemplo.com', 1, 1, 8); -- Cuidador
-- Mantenimiento y Atención al Cliente
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Andrés', 'Pineda', '0000000010', TO_DATE('1981-01-12', 'YYYY-MM-DD'), '3000000010', 'andres.pineda@ejemplo.com', 1, 1, 9); -- Operario de Mantenimiento
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Andrea', 'Pineda', '0000000011', TO_DATE('1981-01-12', 'YYYY-MM-DD'), '3000000011', 'andrea.pineda@ejemplo.com', 1, 1, 9); -- Operario de Mantenimiento
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Ruperto', 'Pineda', '0000000012', TO_DATE('1981-01-13', 'YYYY-MM-DD'), '3000000012', 'ruperto.pineda@ejemplo.com', 1, 1, 11); -- Auxiliar de Servicios Generales
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Carmen', 'Hernández', '0000000013', TO_DATE('1982-01-15', 'YYYY-MM-DD'), '3000000013', 'carme.hdz@ejemplo.com', 1, 1, 11); -- Auxiliar de Servicios Generales
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Juan', 'Sánchez', '0000000014', TO_DATE('1990-05-19', 'YYYY-MM-DD'), '3000000014', 'juan.sanchez@ejemplo.com', 1, 1, 11); -- Auxiliar de Servicios Generales
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Isabel', 'Díaz', '0000000015', TO_DATE('1995-09-23', 'YYYY-MM-DD'), '3000000015', 'isabel.diaz@ejemplo.com', 1, 1, 10); -- Jefe de Mantenimiento
-- Atención al Cliente y Nutrición
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Valeria', 'Moreno', '0000000016', TO_DATE('1988-11-11', 'YYYY-MM-DD'), '3000000016', 'valeria.moreno@ejemplo.com', 1, 1, 12); -- Auxiliar de Atención al Cliente
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Camilo', 'Gómez', '0000000017', TO_DATE('1987-04-20', 'YYYY-MM-DD'), '3000000017', 'camilo.gomez@ejemplo.com', 1, 1, 13); -- Coordinador de Servicio al Cliente
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Gabriela', 'Ríos', '0000000018', TO_DATE('1991-10-29', 'YYYY-MM-DD'), '3000000018', 'gabriela.rios@ejemplo.com', 1, 1, 14); -- Nutricionista
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Felipe', 'Cruz', '0000000019', TO_DATE('1994-03-12', 'YYYY-MM-DD'), '3000000019', 'felipe.cruz@ejemplo.com', 1, 1, 15); -- Asesor de Suplementación
-- Otros roles
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Daniel', 'Pardo', '0000000020', TO_DATE('1982-07-07', 'YYYY-MM-DD'), '3000000020', 'daniel.pardo@ejemplo.com', 1, 1, 16); -- Abogado Corporativo
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Samantha', 'Vega', '0000000021', TO_DATE('1993-12-01', 'YYYY-MM-DD'), '3000000021', 'samantha.vega@ejemplo.com', 1, 1, 17); -- Asistente Legal
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Martín', 'Núñez', '0000000022', TO_DATE('1986-06-28', 'YYYY-MM-DD'), '3000000022', 'martin.nunez@ejemplo.com', 1, 1, 18); -- Gerente de Marketing
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Paola', 'Castro', '0000000023', TO_DATE('1990-10-15', 'YYYY-MM-DD'), '3000000023', 'paola.castro@ejemplo.com', 1, 1, 19); -- Publicista
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Esteban', 'Ardila', '0000000024', TO_DATE('1985-08-11', 'YYYY-MM-DD'), '3000000024', 'esteban.ardila@ejemplo.com', 1, 1, 20); -- Diseñador
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Mariana', 'Ardila', '0000000025', TO_DATE('1989-08-12', 'YYYY-MM-DD'), '3000000025', 'mariana.ardila@ejemplo.com', 1, 1, 20); -- Diseñador
-- Gerentes y Contador
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Rafael', 'Córdoba', '0000000026', TO_DATE('1983-09-10', 'YYYY-MM-DD'), '3000000026', 'rafael.cordoba@ejemplo.com', 1, 1, 21); -- Gerente General
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Daniela', 'Salazar', '0000000027', TO_DATE('1988-01-29', 'YYYY-MM-DD'), '3000000027', 'daniela.salazar@ejemplo.com', 1, 1, 22); -- Gerente de Sede
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Alejandro', 'Valencia', '0000000028', TO_DATE('1986-04-20', 'YYYY-MM-DD'), '3000000028', 'alejandro.valencia@ejemplo.com', 1, 1, 23); -- Contador
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Natalia', 'Paniagua', '0000000029', TO_DATE('1992-11-05', 'YYYY-MM-DD'), '3000000029', 'natalia.paniagua@ejemplo.com', 1, 1, 24); -- Asistente Administrativo
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Natalia', 'Paniagua', '0000000030', TO_DATE('1992-11-05', 'YYYY-MM-DD'), '3000000030', 'natalia.paniagua@ejemplo.com', 1, 1, 24); -- Asistente Administrativo

--sede 4

-- Entrenadores y Personal de Entrenamiento
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Ana', 'Gómez', '0000000031', TO_DATE('1985-04-15', 'YYYY-MM-DD'), '3000000031', 'ana.gomez@example.com', 1, 4, 1); -- Entrenador Personal
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Rogelio', 'Gómez', '0000000032', TO_DATE('1986-04-16', 'YYYY-MM-DD'), '3000000032', 'roge.gomez@example.com', 1, 4, 1); -- Entrenador Personal
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Eustaquio', 'Pérez', '0000000033', TO_DATE('1980-02-16', 'YYYY-MM-DD'), '3000000033', 'eus.gomez@example.com', 1, 4, 1); -- Entrenador Personal
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Luis', 'Pérez', '0000000034', TO_DATE('1983-08-22', 'YYYY-MM-DD'), '3000000034', 'luis.perez@example.com', 1, 4, 2); -- Instructor de Clases Grupales
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Carlos', 'Morales', '0000000035', TO_DATE('1987-11-30', 'YYYY-MM-DD'), '3000000035', 'carlos.morales@example.com', 1, 4, 3); -- Coordinador de Entrenamiento
-- Fisioterapeutas y Asistentes
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Sofía', 'Vásquez', '0000000036', TO_DATE('1986-02-14', 'YYYY-MM-DD'), '3000000036', 'sofia.vasquez@example.com', 1, 4, 4); -- Fisioterapeuta
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Julio', 'Ramírez', '0000000037', TO_DATE('1990-06-25', 'YYYY-MM-DD'), '3000000037', 'julio.ramirez@example.com', 1, 4, 5); -- Rehabilitador Deportivo
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Laura', 'García', '0000000038', TO_DATE('1989-03-17', 'YYYY-MM-DD'), '3000000038', 'laura.garcia@example.com', 1, 4, 6); -- Asistente de Fisioterapia
-- Instructores para Niños
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Miguel', 'Hernández', '0000000039', TO_DATE('1992-07-08', 'YYYY-MM-DD'), '3000000039', 'miguel.hernandez@example.com', 1, 4, 7); -- Instructor de Actividades para Niños
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Claudia', 'Martínez', '0000000040', TO_DATE('1984-12-05', 'YYYY-MM-DD'), '3000000040', 'claudia.martinez@example.com', 1, 4, 8); -- Cuidador
-- Mantenimiento y Atención al Cliente
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Andrés', 'Pineda', '0000000041', TO_DATE('1981-01-12', 'YYYY-MM-DD'), '3000000041', 'andres.pineda@example.com', 1, 4, 9); -- Operario de Mantenimiento
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Andrea', 'Pineda', '0000000042', TO_DATE('1981-01-12', 'YYYY-MM-DD'), '3000000042', 'andrea.pineda@example.com', 1, 4, 9); -- Operario de Mantenimiento
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Ruperto', 'Pineda', '0000000043', TO_DATE('1981-01-13', 'YYYY-MM-DD'), '3000000043', 'ruperto.pineda@example.com', 1, 4, 11); -- Auxiliar de Servicios Generales
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Carmen', 'Hernández', '0000000044', TO_DATE('1982-01-15', 'YYYY-MM-DD'), '3000000044', 'carme.hdz@example.com', 1, 4, 11); -- Auxiliar de Servicios Generales
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Juan', 'Sánchez', '0000000045', TO_DATE('1990-05-19', 'YYYY-MM-DD'), '3000000045', 'juan.sanchez@example.com', 1, 4, 11); -- Auxiliar de Servicios Generales
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Isabel', 'Díaz', '0000000046', TO_DATE('1995-09-23', 'YYYY-MM-DD'), '3000000046', 'isabel.diaz@example.com', 1, 4, 10); -- Jefe de Mantenimiento
-- Atención al Cliente y Nutrición
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Valeria', 'Moreno', '0000000047', TO_DATE('1988-11-11', 'YYYY-MM-DD'), '3000000047', 'valeria.moreno@example.com', 1, 4, 12); -- Auxiliar de Atención al Cliente
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Camilo', 'Gómez', '0000000048', TO_DATE('1987-04-20', 'YYYY-MM-DD'), '3000000048', 'camilo.gomez@example.com', 1, 4, 13); -- Coordinador de Servicio al Cliente
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Gabriela', 'Ríos', '0000000049', TO_DATE('1991-10-29', 'YYYY-MM-DD'), '3000000049', 'gabriela.rios@example.com', 1, 4, 14); -- Nutricionista
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Felipe', 'Cruz', '0000000050', TO_DATE('1994-03-12', 'YYYY-MM-DD'), '3000000050', 'felipe.cruz@example.com', 1, 4, 15); -- Asesor de Suplementación
-- Otros roles
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Martín', 'Núñez', '0000000051', TO_DATE('1986-06-28', 'YYYY-MM-DD'), '3000000051', 'martin.nunez@example.com', 1, 4, 18); -- Gerente de Marketing
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Paola', 'Castro', '0000000052', TO_DATE('1990-10-15', 'YYYY-MM-DD'), '3000000052', 'paola.castro@example.com', 1, 4, 19); -- Publicista
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Esteban', 'Ardila', '0000000053', TO_DATE('1985-08-11', 'YYYY-MM-DD'), '3000000053', 'esteban.ardila@example.com', 1, 4, 20); -- Diseñador
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Mariana', 'Ardila', '0000000054', TO_DATE('1989-08-12', 'YYYY-MM-DD'), '3000000054', 'mariana.ardila@example.com', 1, 4, 20); -- Diseñador
-- Gerentes y Contador
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Daniela', 'Salazar', '0000000055', TO_DATE('1988-01-29', 'YYYY-MM-DD'), '3000000055', 'daniela.salazar@example.com', 1, 4, 22); -- Gerente de Sede
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Alejandro', 'Valencia', '0000000056', TO_DATE('1986-04-20', 'YYYY-MM-DD'), '3000000056', 'alejandro.valencia@example.com', 1, 4, 23); -- Contador
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Natalia', 'Paniagua', '0000000057', TO_DATE('1992-11-05', 'YYYY-MM-DD'), '3000000057', 'natalia.paniagua@example.com', 1, 4, 24); -- Asistente Administrativo

--sede 7

-- Entrenadores y Personal de Entrenamiento
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Ana', 'Gómez', '0000000058', TO_DATE('1985-04-15', 'YYYY-MM-DD'), '3000000058', 'ana.gomez@yahoo.com', 1, 7, 1); -- Entrenador Personal
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Rogelio', 'Gómez', '0000000059', TO_DATE('1986-04-16', 'YYYY-MM-DD'), '3000000059', 'roge.gomez@yahoo.com', 1, 7, 1); -- Entrenador Personal
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Eustaquio', 'Pérez', '0000000060', TO_DATE('1980-02-16', 'YYYY-MM-DD'), '3000000060', 'eus.gomez@yahoo.com', 1, 7, 1); -- Entrenador Personal
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Luis', 'Pérez', '0000000061', TO_DATE('1983-08-22', 'YYYY-MM-DD'), '3000000061', 'luis.perez@yahoo.com', 1, 7, 2); -- Instructor de Clases Grupales
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Carlos', 'Morales', '0000000062', TO_DATE('1987-11-30', 'YYYY-MM-DD'), '3000000062', 'carlos.morales@yahoo.com', 1, 7, 3); -- Coordinador de Entrenamiento
-- Fisioterapeutas y Asistentes
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Sofía', 'Vásquez', '0000000063', TO_DATE('1986-02-14', 'YYYY-MM-DD'), '3000000063', 'sofia.vasquez@yahoo.com', 1, 7, 4); -- Fisioterapeuta
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Julio', 'Ramírez', '0000000064', TO_DATE('1990-06-25', 'YYYY-MM-DD'), '3000000064', 'julio.ramirez@yahoo.com', 1, 7, 5); -- Rehabilitador Deportivo
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Laura', 'García', '0000000065', TO_DATE('1989-03-17', 'YYYY-MM-DD'), '3000000065', 'laura.garcia@yahoo.com', 1, 7, 6); -- Asistente de Fisioterapia
-- Instructores para Niños
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Miguel', 'Hernández', '0000000066', TO_DATE('1992-07-08', 'YYYY-MM-DD'), '3000000066', 'miguel.hernandez@yahoo.com', 1, 7, 7); -- Instructor de Actividades para Niños
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Claudia', 'Martínez', '0000000067', TO_DATE('1984-12-05', 'YYYY-MM-DD'), '3000000067', 'claudia.martinez@yahoo.com', 1, 7, 8); -- Cuidador
-- Mantenimiento y Atención al Cliente
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Andrés', 'Pineda', '0000000068', TO_DATE('1981-01-12', 'YYYY-MM-DD'), '3000000068', 'andres.pineda@yahoo.com', 1, 7, 9); -- Operario de Mantenimiento
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Andrea', 'Pineda', '0000000069', TO_DATE('1981-01-12', 'YYYY-MM-DD'), '3000000069', 'andrea.pineda@yahoo.com', 1, 7, 9); -- Operario de Mantenimiento
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Ruperto', 'Pineda', '0000000070', TO_DATE('1981-01-13', 'YYYY-MM-DD'), '3000000070', 'ruperto.pineda@yahoo.com', 1, 7, 11); -- Auxiliar de Servicios Generales
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Carmen', 'Hernández', '0000000071', TO_DATE('1982-01-15', 'YYYY-MM-DD'), '3000000071', 'carme.hdz@yahoo.com', 1, 7, 11); -- Auxiliar de Servicios Generales
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Juan', 'Sánchez', '0000000072', TO_DATE('1990-05-19', 'YYYY-MM-DD'), '3000000072', 'juan.sanchez@yahoo.com', 1, 7, 11); -- Auxiliar de Servicios Generales
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Isabel', 'Díaz', '0000000073', TO_DATE('1995-09-23', 'YYYY-MM-DD'), '3000000073', 'isabel.diaz@yahoo.com', 1, 7, 10); -- Jefe de Mantenimiento
-- Atención al Cliente y Nutrición
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Valeria', 'Moreno', '0000000074', TO_DATE('1988-11-11', 'YYYY-MM-DD'), '3000000074', 'valeria.moreno@yahoo.com', 1, 7, 12); -- Auxiliar de Atención al Cliente
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Camilo', 'Gómez', '0000000075', TO_DATE('1987-04-20', 'YYYY-MM-DD'), '3000000075', 'camilo.gomez@yahoo.com', 1, 7, 13); -- Coordinador de Servicio al Cliente
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Gabriela', 'Ríos', '0000000076', TO_DATE('1991-10-29', 'YYYY-MM-DD'), '3000000076', 'gabriela.rios@yahoo.com', 1, 7, 14); -- Nutricionista
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Felipe', 'Cruz', '0000000077', TO_DATE('1994-03-12', 'YYYY-MM-DD'), '3000000077', 'felipe.cruz@yahoo.com', 1, 7, 15); -- Asesor de Suplementación
-- Otros roles
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Martín', 'Núñez', '0000000078', TO_DATE('1986-06-28', 'YYYY-MM-DD'), '3000000078', 'martin.nunez@yahoo.com', 1, 7, 18); -- Gerente de Marketing
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Paola', 'Castro', '0000000079', TO_DATE('1990-10-15', 'YYYY-MM-DD'), '3000000079', 'paola.castro@yahoo.com', 1, 7, 19); -- Publicista
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Esteban', 'Ardila', '0000000080', TO_DATE('1985-08-11', 'YYYY-MM-DD'), '3000000080', 'esteban.ardila@yahoo.com', 1, 7, 20); -- Diseñador
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Mariana', 'Ardila', '0000000081', TO_DATE('1989-08-12', 'YYYY-MM-DD'), '3000000081', 'mariana.ardila@yahoo.com', 1, 7, 20); -- Diseñador
-- Gerentes y Contador
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Daniela', 'Salazar', '0000000082', TO_DATE('1988-01-29', 'YYYY-MM-DD'), '3000000082', 'daniela.salazar@yahoo.com', 1, 7, 22); -- Gerente de Sede
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Alejandro', 'Valencia', '0000000083', TO_DATE('1986-04-20', 'YYYY-MM-DD'), '3000000083', 'alejandro.valencia@yahoo.com', 1, 7, 23); -- Contador
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Natalia', 'Paniagua', '0000000084', TO_DATE('1992-11-05', 'YYYY-MM-DD'), '3000000084', 'natalia.paniagua@yahoo.com', 1, 7, 24); -- Asistente Administrativo

--sede 8

-- Entrenadores y Personal de Entrenamiento
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Ana', 'Gómez', '0000000085', TO_DATE('1985-04-15', 'YYYY-MM-DD'), '3000000085', 'ana.gomez@email.com', 1, 8, 1); -- Entrenador Personal
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Rogelio', 'Gómez', '0000000086', TO_DATE('1986-04-16', 'YYYY-MM-DD'), '3000000086', 'roge.gomez@email.com', 1, 8, 1); -- Entrenador Personal
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Eustaquio', 'Pérez', '0000000087', TO_DATE('1980-02-16', 'YYYY-MM-DD'), '3000000087', 'eus.gomez@email.com', 1, 8, 1); -- Entrenador Personal
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Luis', 'Pérez', '0000000088', TO_DATE('1983-08-22', 'YYYY-MM-DD'), '3000000088', 'luis.perez@email.com', 1, 8, 2); -- Instructor de Clases Grupales
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Carlos', 'Morales', '0000000089', TO_DATE('1987-11-30', 'YYYY-MM-DD'), '3000000089', 'carlos.morales@email.com', 1, 8, 3); -- Coordinador de Entrenamiento
-- Fisioterapeutas y Asistentes
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Sofía', 'Vásquez', '0000000090', TO_DATE('1986-02-14', 'YYYY-MM-DD'), '3000000090', 'sofia.vasquez@email.com', 1, 8, 4); -- Fisioterapeuta
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Julio', 'Ramírez', '0000000091', TO_DATE('1990-06-25', 'YYYY-MM-DD'), '3000000091', 'julio.ramirez@email.com', 1, 8, 5); -- Rehabilitador Deportivo
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Laura', 'García', '0000000092', TO_DATE('1989-03-17', 'YYYY-MM-DD'), '3000000092', 'laura.garcia@email.com', 1, 8, 6); -- Asistente de Fisioterapia
-- Instructores para Niños
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Miguel', 'Hernández', '0000000093', TO_DATE('1992-07-08', 'YYYY-MM-DD'), '3000000093', 'miguel.hernandez@email.com', 1, 8, 7); -- Instructor de Actividades para Niños
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Claudia', 'Martínez', '0000000094', TO_DATE('1984-12-05', 'YYYY-MM-DD'), '3000000094', 'claudia.martinez@email.com', 1, 8, 8); -- Cuidador
-- Mantenimiento y Atención al Cliente
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Andrés', 'Pineda', '0000000095', TO_DATE('1981-01-12', 'YYYY-MM-DD'), '3000000095', 'andres.pineda@email.com', 1, 8, 9); -- Operario de Mantenimiento
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Andrea', 'Pineda', '0000000096', TO_DATE('1981-01-12', 'YYYY-MM-DD'), '3000000096', 'andrea.pineda@email.com', 1, 8, 9); -- Operario de Mantenimiento
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Ruperto', 'Pineda', '0000000097', TO_DATE('1981-01-13', 'YYYY-MM-DD'), '3000000097', 'ruperto.pineda@email.com', 1, 8, 11); -- Auxiliar de Servicios Generales
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Carmen', 'Hernández', '0000000098', TO_DATE('1982-01-15', 'YYYY-MM-DD'), '3000000098', 'carme.hdz@email.com', 1, 8, 11); -- Auxiliar de Servicios Generales
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Juan', 'Sánchez', '0000000099', TO_DATE('1990-05-19', 'YYYY-MM-DD'), '3000000099', 'juan.sanchez@email.com', 1, 8, 11); -- Auxiliar de Servicios Generales
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Isabel', 'Díaz', '0000000100', TO_DATE('1995-09-23', 'YYYY-MM-DD'), '3000000100', 'isabel.diaz@email.com', 1, 8, 10); -- Jefe de Mantenimiento
-- Atención al Cliente y Nutrición
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Valeria', 'Moreno', '0000000101', TO_DATE('1988-11-11', 'YYYY-MM-DD'), '3000000101', 'valeria.moreno@email.com', 1, 8, 12); -- Auxiliar de Atención al Cliente
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Camilo', 'Gómez', '0000000102', TO_DATE('1987-04-20', 'YYYY-MM-DD'), '3000000102', 'camilo.gomez@email.com', 1, 8, 13); -- Coordinador de Servicio al Cliente
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Gabriela', 'Ríos', '0000000103', TO_DATE('1991-10-29', 'YYYY-MM-DD'), '3000000103', 'gabriela.rios@email.com', 1, 8, 14); -- Nutricionista
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Felipe', 'Cruz', '0000000104', TO_DATE('1994-03-12', 'YYYY-MM-DD'), '3000000104', 'felipe.cruz@email.com', 1, 8, 15); -- Asesor de Suplementación
-- Otros roles
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Martín', 'Núñez', '0000000105', TO_DATE('1986-06-28', 'YYYY-MM-DD'), '3000000105', 'martin.nunez@email.com', 1, 8, 18); -- Gerente de Marketing
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Paola', 'Castro', '0000000106', TO_DATE('1990-10-15', 'YYYY-MM-DD'), '3000000106', 'paola.castro@email.com', 1, 8, 19); -- Publicista
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Esteban', 'Ardila', '0000000107', TO_DATE('1985-08-11', 'YYYY-MM-DD'), '3000000107', 'esteban.ardila@email.com', 1, 8, 20); -- Diseñador
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Mariana', 'Ardila', '0000000108', TO_DATE('1989-08-12', 'YYYY-MM-DD'), '3000000108', 'mariana.ardila@email.com', 1, 8, 20); -- Diseñador
-- Gerentes y Contador
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Daniela', 'Salazar', '0000000109', TO_DATE('1988-01-29', 'YYYY-MM-DD'), '3000000109', 'daniela.salazar@email.com', 1, 8, 22); -- Gerente de Sede
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Alejandro', 'Valencia', '0000000110', TO_DATE('1986-04-20', 'YYYY-MM-DD'), '3000000110', 'alejandro.valencia@email.com', 1, 8, 23); -- Contador
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Natalia', 'Paniagua', '0000000111', TO_DATE('1992-11-05', 'YYYY-MM-DD'), '3000000111', 'natalia.paniagua@email.com', 1, 8, 24); -- Asistente Administrativo

--sede 10

-- Entrenadores y Personal de Entrenamiento
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Ana', 'Gómez', '0000000112', TO_DATE('1985-04-15', 'YYYY-MM-DD'), '3000000112', 'ana.gomez@mail.com', 1, 10, 1); -- Entrenador Personal
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Rogelio', 'Gómez', '0000000113', TO_DATE('1986-04-16', 'YYYY-MM-DD'), '3000000113', 'roge.gomez@mail.com', 1, 10, 1); -- Entrenador Personal
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Eustaquio', 'Pérez', '0000000114', TO_DATE('1980-02-16', 'YYYY-MM-DD'), '3000000114', 'eus.gomez@mail.com', 1, 10, 1); -- Entrenador Personal
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Luis', 'Pérez', '0000000115', TO_DATE('1983-08-22', 'YYYY-MM-DD'), '3000000115', 'luis.perez@mail.com', 1, 10, 2); -- Instructor de Clases Grupales
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Carlos', 'Morales', '0000000116', TO_DATE('1987-11-30', 'YYYY-MM-DD'), '3000000116', 'carlos.morales@mail.com', 1, 10, 3); -- Coordinador de Entrenamiento
-- Fisioterapeutas y Asistentes
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Sofía', 'Vásquez', '0000000117', TO_DATE('1986-02-14', 'YYYY-MM-DD'), '3000000117', 'sofia.vasquez@mail.com', 1, 10, 4); -- Fisioterapeuta
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Julio', 'Ramírez', '0000000118', TO_DATE('1990-06-25', 'YYYY-MM-DD'), '3000000118', 'julio.ramirez@mail.com', 1, 10, 5); -- Rehabilitador Deportivo
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Laura', 'García', '0000000119', TO_DATE('1989-03-17', 'YYYY-MM-DD'), '3000000119', 'laura.garcia@mail.com', 1, 10, 6); -- Asistente de Fisioterapia
-- Instructores para Niños
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Miguel', 'Hernández', '0000000120', TO_DATE('1992-07-08', 'YYYY-MM-DD'), '3000000120', 'miguel.hernandez@mail.com', 1, 10, 7); -- Instructor de Actividades para Niños
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Claudia', 'Martínez', '0000000121', TO_DATE('1984-12-05', 'YYYY-MM-DD'), '3000000121', 'claudia.martinez@mail.com', 1, 10, 8); -- Cuidador
-- Mantenimiento y Atención al Cliente
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Andrés', 'Pineda', '0000000122', TO_DATE('1981-01-12', 'YYYY-MM-DD'), '3000000122', 'andres.pineda@mail.com', 1, 10, 9); -- Operario de Mantenimiento
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Andrea', 'Pineda', '0000000123', TO_DATE('1981-01-12', 'YYYY-MM-DD'), '3000000123', 'andrea.pineda@mail.com', 1, 10, 9); -- Operario de Mantenimiento
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Ruperto', 'Pineda', '0000000124', TO_DATE('1981-01-13', 'YYYY-MM-DD'), '3000000124', 'ruperto.pineda@mail.com', 1, 10, 11); -- Auxiliar de Servicios Generales
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Carmen', 'Hernández', '0000000125', TO_DATE('1982-01-15', 'YYYY-MM-DD'), '3000000125', 'carme.hdz@mail.com', 1, 10, 11); -- Auxiliar de Servicios Generales
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Juan', 'Sánchez', '0000000126', TO_DATE('1990-05-19', 'YYYY-MM-DD'), '3000000126', 'juan.sanchez@mail.com', 1, 10, 11); -- Auxiliar de Servicios Generales
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Isabel', 'Díaz', '0000000127', TO_DATE('1995-09-23', 'YYYY-MM-DD'), '3000000127', 'isabel.diaz@mail.com', 1, 10, 10); -- Jefe de Mantenimiento
-- Atención al Cliente y Nutrición
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Valeria', 'Moreno', '0000000128', TO_DATE('1988-11-11', 'YYYY-MM-DD'), '3000000128', 'valeria.moreno@mail.com', 1, 10, 12); -- Auxiliar de Atención al Cliente
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Camilo', 'Gómez', '0000000129', TO_DATE('1987-04-20', 'YYYY-MM-DD'), '3000000129', 'camilo.gomez@mail.com', 1, 10, 13); -- Coordinador de Servicio al Cliente
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Gabriela', 'Ríos', '0000000130', TO_DATE('1991-10-29', 'YYYY-MM-DD'), '3000000130', 'gabriela.rios@mail.com', 1, 10, 14); -- Nutricionista
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Felipe', 'Cruz', '0000000131', TO_DATE('1994-03-12', 'YYYY-MM-DD'), '3000000131', 'felipe.cruz@mail.com', 1, 10, 15); -- Asesor de Suplementación
-- Otros roles
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Martín', 'Núñez', '0000000132', TO_DATE('1986-06-28', 'YYYY-MM-DD'), '3000000132', 'martin.nunez@mail.com', 1, 10, 18); -- Gerente de Marketing
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Paola', 'Castro', '0000000133', TO_DATE('1990-10-15', 'YYYY-MM-DD'), '3000000133', 'paola.castro@mail.com', 1, 10, 19); -- Publicista
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Esteban', 'Ardila', '0000000134', TO_DATE('1985-08-11', 'YYYY-MM-DD'), '3000000134', 'esteban.ardila@mail.com', 1, 10, 20); -- Diseñador
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Mariana', 'Ardila', '0000000135', TO_DATE('1989-08-12', 'YYYY-MM-DD'), '3000000135', 'mariana.ardila@mail.com', 1, 10, 20); -- Diseñador
-- Gerentes y Contador
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Daniela', 'Salazar', '0000000136', TO_DATE('1988-01-29', 'YYYY-MM-DD'), '3000000136', 'daniela.salazar@mail.com', 1, 10, 22); -- Gerente de Sede
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Alejandro', 'Valencia', '0000000137', TO_DATE('1986-04-20', 'YYYY-MM-DD'), '3000000137', 'alejandro.valencia@mail.com', 1, 10, 23); -- Contador
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Natalia', 'Paniagua', '0000000138', TO_DATE('1992-11-05', 'YYYY-MM-DD'), '3000000138', 'natalia.paniagua@mail.com', 1, 10, 24); -- Asistente Administrativo

--sede 11

-- Entrenadores y Personal de Entrenamiento
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Ana', 'Gómez', '0000000139', TO_DATE('1985-04-15', 'YYYY-MM-DD'), '3000000139', 'ana.gomez@yahi.com', 1, 11, 1); -- Entrenador Personal
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Rogelio', 'Gómez', '0000000140', TO_DATE('1986-04-16', 'YYYY-MM-DD'), '3000000140', 'roge.gomez@yahi.com', 1, 11, 1); -- Entrenador Personal
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Eustaquio', 'Pérez', '0000000141', TO_DATE('1980-02-16', 'YYYY-MM-DD'), '3000000141', 'eus.gomez@yahi.com', 1, 11, 1); -- Entrenador Personal
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Luis', 'Pérez', '0000000142', TO_DATE('1983-08-22', 'YYYY-MM-DD'), '3000000142', 'luis.perez@yahi.com', 1, 11, 2); -- Instructor de Clases Grupales
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Carlos', 'Morales', '0000000143', TO_DATE('1987-11-30', 'YYYY-MM-DD'), '3000000143', 'carlos.morales@yahi.com', 1, 11, 3); -- Coordinador de Entrenamiento
-- Fisioterapeutas y Asistentes
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Sofía', 'Vásquez', '0000000144', TO_DATE('1986-02-14', 'YYYY-MM-DD'), '3000000144', 'sofia.vasquez@yahi.com', 1, 11, 4); -- Fisioterapeuta
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Julio', 'Ramírez', '0000000145', TO_DATE('1990-06-25', 'YYYY-MM-DD'), '3000000145', 'julio.ramirez@yahi.com', 1, 11, 5); -- Rehabilitador Deportivo
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Laura', 'García', '0000000146', TO_DATE('1989-03-17', 'YYYY-MM-DD'), '3000000146', 'laura.garcia@yahi.com', 1, 11, 6); -- Asistente de Fisioterapia
-- Instructores para Niños
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Miguel', 'Hernández', '0000000147', TO_DATE('1992-07-08', 'YYYY-MM-DD'), '3000000147', 'miguel.hernandez@yahi.com', 1, 11, 7); -- Instructor de Actividades para Niños
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Claudia', 'Martínez', '0000000148', TO_DATE('1984-12-05', 'YYYY-MM-DD'), '3000000148', 'claudia.martinez@yahi.com', 1, 11, 8); -- Cuidador
-- Mantenimiento y Atención al Cliente
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Andrés', 'Pineda', '0000000149', TO_DATE('1981-01-12', 'YYYY-MM-DD'), '3000000149', 'andres.pineda@yahi.com', 1, 11, 9); -- Operario de Mantenimiento
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Andrea', 'Pineda', '0000000150', TO_DATE('1981-01-12', 'YYYY-MM-DD'), '3000000150', 'andrea.pineda@yahi.com', 1, 11, 9); -- Operario de Mantenimiento
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Ruperto', 'Pineda', '0000000151', TO_DATE('1981-01-13', 'YYYY-MM-DD'), '3000000151', 'ruperto.pineda@yahi.com', 1, 11, 11); -- Auxiliar de Servicios Generales
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Carmen', 'Hernández', '0000000152', TO_DATE('1982-01-15', 'YYYY-MM-DD'), '3000000152', 'carme.hdz@yahi.com', 1, 11, 11); -- Auxiliar de Servicios Generales
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Juan', 'Sánchez', '0000000153', TO_DATE('1990-05-19', 'YYYY-MM-DD'), '3000000153', 'juan.sanchez@yahi.com', 1, 11, 11); -- Auxiliar de Servicios Generales
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Isabel', 'Díaz', '0000000154', TO_DATE('1995-09-23', 'YYYY-MM-DD'), '3000000154', 'isabel.diaz@yahi.com', 1, 11, 10); -- Jefe de Mantenimiento
-- Atención al Cliente y Nutrición
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Valeria', 'Moreno', '0000000155', TO_DATE('1988-11-11', 'YYYY-MM-DD'), '3000000155', 'valeria.moreno@yahi.com', 1, 11, 12); -- Auxiliar de Atención al Cliente
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Camilo', 'Gómez', '0000000156', TO_DATE('1987-04-20', 'YYYY-MM-DD'), '3000000156', 'camilo.gomez@yahi.com', 1, 11, 13); -- Coordinador de Servicio al Cliente
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Gabriela', 'Ríos', '0000000157', TO_DATE('1991-10-29', 'YYYY-MM-DD'), '3000000157', 'gabriela.rios@yahi.com', 1, 11, 14); -- Nutricionista
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Felipe', 'Cruz', '0000000158', TO_DATE('1994-03-12', 'YYYY-MM-DD'), '3000000158', 'felipe.cruz@yahi.com', 1, 11, 15); -- Asesor de Suplementación
-- Otros roles
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Martín', 'Núñez', '0000000159', TO_DATE('1986-06-28', 'YYYY-MM-DD'), '3000000159', 'martin.nunez@yahi.com', 1, 11, 18); -- Gerente de Marketing
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Paola', 'Castro', '0000000160', TO_DATE('1990-10-15', 'YYYY-MM-DD'), '3000000160', 'paola.castro@yahi.com', 1, 11, 19); -- Publicista
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Esteban', 'Ardila', '0000000161', TO_DATE('1985-08-11', 'YYYY-MM-DD'), '3000000161', 'esteban.ardila@yahi.com', 1, 11, 20); -- Diseñador
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Mariana', 'Ardila', '0000000162', TO_DATE('1989-08-12', 'YYYY-MM-DD'), '3000000162', 'mariana.ardila@yahi.com', 1, 11, 20); -- Diseñador
-- Gerentes y Contador
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Daniela', 'Salazar', '0000000163', TO_DATE('1988-01-29', 'YYYY-MM-DD'), '3000000163', 'daniela.salazar@yahi.com', 1, 11, 22); -- Gerente de Sede
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Alejandro', 'Valencia', '0000000164', TO_DATE('1986-04-20', 'YYYY-MM-DD'), '3000000164', 'alejandro.valencia@yahi.com', 1, 11, 23); -- Contador
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Natalia', 'Paniagua', '0000000165', TO_DATE('1992-11-05', 'YYYY-MM-DD'), '3000000165', 'natalia.paniagua@yahi.com', 1, 11, 24); -- Asistente Administrativo

--sede 12

-- Entrenadores y Personal de Entrenamiento
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Ana', 'Gómez', '0000000166', TO_DATE('1985-04-15', 'YYYY-MM-DD'), '3000000166', 'ana.gomez@yupi.com', 1, 12, 1); -- Entrenador Personal
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Rogelio', 'Gómez', '0000000167', TO_DATE('1986-04-16', 'YYYY-MM-DD'), '3000000167', 'roge.gomez@yupi.com', 1, 12, 1); -- Entrenador Personal
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Eustaquio', 'Pérez', '0000000168', TO_DATE('1980-02-16', 'YYYY-MM-DD'), '3000000168', 'eus.gomez@yupi.com', 1, 12, 1); -- Entrenador Personal
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Luis', 'Pérez', '0000000169', TO_DATE('1983-08-22', 'YYYY-MM-DD'), '3000000169', 'luis.perez@yupi.com', 1, 12, 2); -- Instructor de Clases Grupales
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Carlos', 'Morales', '0000000170', TO_DATE('1987-11-30', 'YYYY-MM-DD'), '3000000170', 'carlos.morales@yupi.com', 1, 12, 3); -- Coordinador de Entrenamiento
-- Fisioterapeutas y Asistentes
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Sofía', 'Vásquez', '0000000171', TO_DATE('1986-02-14', 'YYYY-MM-DD'), '3000000171', 'sofia.vasquez@yupi.com', 1, 12, 4); -- Fisioterapeuta
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Julio', 'Ramírez', '0000000172', TO_DATE('1990-06-25', 'YYYY-MM-DD'), '3000000172', 'julio.ramirez@yupi.com', 1, 12, 5); -- Rehabilitador Deportivo
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Laura', 'García', '0000000173', TO_DATE('1989-03-17', 'YYYY-MM-DD'), '3000000173', 'laura.garcia@yupi.com', 1, 12, 6); -- Asistente de Fisioterapia
-- Instructores para Niños
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Miguel', 'Hernández', '0000000174', TO_DATE('1992-07-08', 'YYYY-MM-DD'), '3000000174', 'miguel.hernandez@yupi.com', 1, 12, 7); -- Instructor de Actividades para Niños
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Claudia', 'Martínez', '0000000175', TO_DATE('1984-12-05', 'YYYY-MM-DD'), '3000000175', 'claudia.martinez@yupi.com', 1, 12, 8); -- Cuidador
-- Mantenimiento y Atención al Cliente
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Andrés', 'Pineda', '0000000176', TO_DATE('1981-01-12', 'YYYY-MM-DD'), '3000000176', 'andres.pineda@yupi.com', 1, 12, 9); -- Operario de Mantenimiento
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Andrea', 'Pineda', '0000000177', TO_DATE('1981-01-12', 'YYYY-MM-DD'), '3000000177', 'andrea.pineda@yupi.com', 1, 12, 9); -- Operario de Mantenimiento
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Ruperto', 'Pineda', '0000000178', TO_DATE('1981-01-13', 'YYYY-MM-DD'), '3000000178', 'ruperto.pineda@yupi.com', 1, 12, 11); -- Auxiliar de Servicios Generales
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Carmen', 'Hernández', '0000000179', TO_DATE('1982-01-15', 'YYYY-MM-DD'), '3000000179', 'carme.hdz@yupi.com', 1, 12, 11); -- Auxiliar de Servicios Generales
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Juan', 'Sánchez', '0000000180', TO_DATE('1990-05-19', 'YYYY-MM-DD'), '3000000180', 'juan.sanchez@yupi.com', 1, 12, 11); -- Auxiliar de Servicios Generales
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Isabel', 'Díaz', '0000000181', TO_DATE('1995-09-23', 'YYYY-MM-DD'), '3000000181', 'isabel.diaz@yupi.com', 1, 12, 10); -- Jefe de Mantenimiento
-- Atención al Cliente y Nutrición
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Valeria', 'Moreno', '0000000182', TO_DATE('1988-11-11', 'YYYY-MM-DD'), '3000000182', 'valeria.moreno@yupi.com', 1, 12, 12); -- Auxiliar de Atención al Cliente
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Camilo', 'Gómez', '0000000183', TO_DATE('1987-04-20', 'YYYY-MM-DD'), '3000000183', 'camilo.gomez@yupi.com', 1, 12, 13); -- Coordinador de Servicio al Cliente
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Gabriela', 'Ríos', '0000000184', TO_DATE('1991-10-29', 'YYYY-MM-DD'), '3000000184', 'gabriela.rios@yupi.com', 1, 12, 14); -- Nutricionista
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Felipe', 'Cruz', '0000000185', TO_DATE('1994-03-12', 'YYYY-MM-DD'), '3000000185', 'felipe.cruz@yupi.com', 1, 12, 15); -- Asesor de Suplementación
-- Otros roles
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Martín', 'Núñez', '0000000186', TO_DATE('1986-06-28', 'YYYY-MM-DD'), '3000000186', 'martin.nunez@yupi.com', 1, 12, 18); -- Gerente de Marketing
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Paola', 'Castro', '0000000187', TO_DATE('1990-10-15', 'YYYY-MM-DD'), '3000000187', 'paola.castro@yupi.com', 1, 12, 19); -- Publicista
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Esteban', 'Ardila', '0000000188', TO_DATE('1985-08-11', 'YYYY-MM-DD'), '3000000188', 'esteban.ardila@yupi.com', 1, 12, 20); -- Diseñador
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Mariana', 'Ardila', '0000000189', TO_DATE('1989-08-12', 'YYYY-MM-DD'), '3000000189', 'mariana.ardila@yupi.com', 1, 12, 20); -- Diseñador
-- Gerentes y Contador
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Daniela', 'Salazar', '0000000190', TO_DATE('1988-01-29', 'YYYY-MM-DD'), '3000000190', 'daniela.salazar@yupi.com', 1, 12, 22); -- Gerente de Sede
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Alejandro', 'Valencia', '0000000191', TO_DATE('1986-04-20', 'YYYY-MM-DD'), '3000000191', 'alejandro.valencia@yupi.com', 1, 12, 23); -- Contador
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Natalia', 'Paniagua', '0000000192', TO_DATE('1992-11-05', 'YYYY-MM-DD'), '3000000192', 'natalia.paniagua@yupi.com', 1, 12, 24); -- Asistente Administrativo

--sede 14

-- Entrenadores y Personal de Entrenamiento
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Ana', 'Gómez', '0000000193', TO_DATE('1985-04-15', 'YYYY-MM-DD'), '3000000193', 'ana.gomez@corre.com', 1, 14, 1); -- Entrenador Personal
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Rogelio', 'Gómez', '0000000194', TO_DATE('1986-04-16', 'YYYY-MM-DD'), '3000000194', 'roge.gomez@corre.com', 1, 14, 1); -- Entrenador Personal
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Eustaquio', 'Pérez', '0000000195', TO_DATE('1980-02-16', 'YYYY-MM-DD'), '3000000195', 'eus.gomez@corre.com', 1, 14, 1); -- Entrenador Personal
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Luis', 'Pérez', '0000000196', TO_DATE('1983-08-22', 'YYYY-MM-DD'), '3000000196', 'luis.perez@corre.com', 1, 14, 2); -- Instructor de Clases Grupales
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Carlos', 'Morales', '0000000197', TO_DATE('1987-11-30', 'YYYY-MM-DD'), '3000000197', 'carlos.morales@corre.com', 1, 14, 3); -- Coordinador de Entrenamiento
-- Fisioterapeutas y Asistentes
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Sofía', 'Vásquez', '0000000198', TO_DATE('1986-02-14', 'YYYY-MM-DD'), '3000000198', 'sofia.vasquez@corre.com', 1, 14, 4); -- Fisioterapeuta
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Julio', 'Ramírez', '0000000199', TO_DATE('1990-06-25', 'YYYY-MM-DD'), '3000000199', 'julio.ramirez@corre.com', 1, 14, 5); -- Rehabilitador Deportivo
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Laura', 'García', '0000000200', TO_DATE('1989-03-17', 'YYYY-MM-DD'), '3000000200', 'laura.garcia@corre.com', 1, 14, 6); -- Asistente de Fisioterapia
-- Instructores para Niños
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Miguel', 'Hernández', '0000000201', TO_DATE('1992-07-08', 'YYYY-MM-DD'), '3000000201', 'miguel.hernandez@corre.com', 1, 14, 7); -- Instructor de Actividades para Niños
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Claudia', 'Martínez', '0000000202', TO_DATE('1984-12-05', 'YYYY-MM-DD'), '3000000202', 'claudia.martinez@corre.com', 1, 14, 8); -- Cuidador
-- Mantenimiento y Atención al Cliente
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Andrés', 'Pineda', '0000000203', TO_DATE('1981-01-12', 'YYYY-MM-DD'), '3000000203', 'andres.pineda@corre.com', 1, 14, 9); -- Operario de Mantenimiento
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Andrea', 'Pineda', '0000000204', TO_DATE('1981-01-12', 'YYYY-MM-DD'), '3000000204', 'andrea.pineda@corre.com', 1, 14, 9); -- Operario de Mantenimiento
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Ruperto', 'Pineda', '0000000205', TO_DATE('1981-01-13', 'YYYY-MM-DD'), '3000000205', 'ruperto.pineda@corre.com', 1, 14, 11); -- Auxiliar de Servicios Generales
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Carmen', 'Hernández', '0000000206', TO_DATE('1982-01-15', 'YYYY-MM-DD'), '3000000206', 'carme.hdz@corre.com', 1, 14, 11); -- Auxiliar de Servicios Generales
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Juan', 'Sánchez', '0000000207', TO_DATE('1990-05-19', 'YYYY-MM-DD'), '3000000207', 'juan.sanchez@corre.com', 1, 14, 11); -- Auxiliar de Servicios Generales
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Isabel', 'Díaz', '0000000208', TO_DATE('1995-09-23', 'YYYY-MM-DD'), '3000000208', 'isabel.diaz@corre.com', 1, 14, 10); -- Jefe de Mantenimiento
-- Atención al Cliente y Nutrición
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Valeria', 'Moreno', '0000000209', TO_DATE('1988-11-11', 'YYYY-MM-DD'), '3000000209', 'valeria.moreno@corre.com', 1, 14, 12); -- Auxiliar de Atención al Cliente
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Camilo', 'Gómez', '0000000210', TO_DATE('1987-04-20', 'YYYY-MM-DD'), '3000000210', 'camilo.gomez@corre.com', 1, 14, 13); -- Coordinador de Servicio al Cliente
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Gabriela', 'Ríos', '0000000211', TO_DATE('1991-10-29', 'YYYY-MM-DD'), '3000000211', 'gabriela.rios@corre.com', 1, 14, 14); -- Nutricionista
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Felipe', 'Cruz', '0000000212', TO_DATE('1994-03-12', 'YYYY-MM-DD'), '3000000212', 'felipe.cruz@corre.com', 1, 14, 15); -- Asesor de Suplementación
-- Otros roles
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Martín', 'Núñez', '0000000213', TO_DATE('1986-06-28', 'YYYY-MM-DD'), '3000000213', 'martin.nunez@corre.com', 1, 14, 18); -- Gerente de Marketing
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Paola', 'Castro', '0000000214', TO_DATE('1990-10-15', 'YYYY-MM-DD'), '3000000214', 'paola.castro@corre.com', 1, 14, 19); -- Publicista
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Esteban', 'Ardila', '0000000215', TO_DATE('1985-08-11', 'YYYY-MM-DD'), '3000000215', 'esteban.ardila@corre.com', 1, 14, 20); -- Diseñador
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Mariana', 'Ardila', '0000000216', TO_DATE('1989-08-12', 'YYYY-MM-DD'), '3000000216', 'mariana.ardila@corre.com', 1, 14, 20); -- Diseñador
-- Gerentes y Contador
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Daniela', 'Salazar', '0000000217', TO_DATE('1988-01-29', 'YYYY-MM-DD'), '3000000217', 'daniela.salazar@corre.com', 1, 14, 22); -- Gerente de Sede
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Alejandro', 'Valencia', '0000000218', TO_DATE('1986-04-20', 'YYYY-MM-DD'), '3000000218', 'alejandro.valencia@corre.com', 1, 14, 23); -- Contador
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Natalia', 'Paniagua', '0000000219', TO_DATE('1992-11-05', 'YYYY-MM-DD'), '3000000219', 'natalia.paniagua@corre.com', 1, 14, 24); -- Asistente Administrativo

--sede 17

-- Entrenadores y Personal de Entrenamiento
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Ana', 'Gómez', '0000000220', TO_DATE('1985-04-15', 'YYYY-MM-DD'), '3000000220', 'ana.gomez@abc.com', 1, 17, 1); -- Entrenador Personal
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Rogelio', 'Gómez', '0000000221', TO_DATE('1986-04-16', 'YYYY-MM-DD'), '3000000221', 'roge.gomez@abc.com', 1, 17, 1); -- Entrenador Personal
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Eustaquio', 'Pérez', '0000000222', TO_DATE('1980-02-16', 'YYYY-MM-DD'), '3000000222', 'eus.gomez@abc.com', 1, 17, 1); -- Entrenador Personal
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Luis', 'Pérez', '0000000223', TO_DATE('1983-08-22', 'YYYY-MM-DD'), '3000000223', 'luis.perez@abc.com', 1, 17, 2); -- Instructor de Clases Grupales
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Carlos', 'Morales', '0000000224', TO_DATE('1987-11-30', 'YYYY-MM-DD'), '3000000224', 'carlos.morales@abc.com', 1, 17, 3); -- Coordinador de Entrenamiento
-- Fisioterapeutas y Asistentes
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Sofía', 'Vásquez', '0000000225', TO_DATE('1986-02-14', 'YYYY-MM-DD'), '3000000225', 'sofia.vasquez@abc.com', 1, 17, 4); -- Fisioterapeuta
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Julio', 'Ramírez', '0000000226', TO_DATE('1990-06-25', 'YYYY-MM-DD'), '3000000226', 'julio.ramirez@abc.com', 1, 17, 5); -- Rehabilitador Deportivo
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Laura', 'García', '0000000227', TO_DATE('1989-03-17', 'YYYY-MM-DD'), '3000000227', 'laura.garcia@abc.com', 1, 17, 6); -- Asistente de Fisioterapia
-- Instructores para Niños
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Miguel', 'Hernández', '0000000228', TO_DATE('1992-07-08', 'YYYY-MM-DD'), '3000000228', 'miguel.hernandez@abc.com', 1, 17, 7); -- Instructor de Actividades para Niños
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Claudia', 'Martínez', '0000000229', TO_DATE('1984-12-05', 'YYYY-MM-DD'), '3000000229', 'claudia.martinez@abc.com', 1, 17, 8); -- Cuidador
-- Mantenimiento y Atención al Cliente
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Andrés', 'Pineda', '0000000230', TO_DATE('1981-01-12', 'YYYY-MM-DD'), '3000000230', 'andres.pineda@abc.com', 1, 17, 9); -- Operario de Mantenimiento
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Andrea', 'Pineda', '0000000231', TO_DATE('1981-01-12', 'YYYY-MM-DD'), '3000000231', 'andrea.pineda@abc.com', 1, 17, 9); -- Operario de Mantenimiento
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Ruperto', 'Pineda', '0000000232', TO_DATE('1981-01-13', 'YYYY-MM-DD'), '3000000232', 'ruperto.pineda@abc.com', 1, 17, 11); -- Auxiliar de Servicios Generales
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Carmen', 'Hernández', '0000000233', TO_DATE('1982-01-15', 'YYYY-MM-DD'), '3000000233', 'carme.hdz@abc.com', 1, 17, 11); -- Auxiliar de Servicios Generales
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Juan', 'Sánchez', '0000000234', TO_DATE('1990-05-19', 'YYYY-MM-DD'), '3000000234', 'juan.sanchez@abc.com', 1, 17, 11); -- Auxiliar de Servicios Generales
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Isabel', 'Díaz', '0000000235', TO_DATE('1995-09-23', 'YYYY-MM-DD'), '3000000235', 'isabel.diaz@abc.com', 1, 17, 10); -- Jefe de Mantenimiento
-- Atención al Cliente y Nutrición
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Valeria', 'Moreno', '0000000236', TO_DATE('1988-11-11', 'YYYY-MM-DD'), '3000000236', 'valeria.moreno@abc.com', 1, 17, 12); -- Auxiliar de Atención al Cliente
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Camilo', 'Gómez', '0000000237', TO_DATE('1987-04-20', 'YYYY-MM-DD'), '3000000237', 'camilo.gomez@abc.com', 1, 17, 13); -- Coordinador de Servicio al Cliente
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Gabriela', 'Ríos', '0000000238', TO_DATE('1991-10-29', 'YYYY-MM-DD'), '3000000238', 'gabriela.rios@abc.com', 1, 17, 14); -- Nutricionista
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Felipe', 'Cruz', '0000000239', TO_DATE('1994-03-12', 'YYYY-MM-DD'), '3000000239', 'felipe.cruz@abc.com', 1, 17, 15); -- Asesor de Suplementación
-- Otros roles
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Martín', 'Núñez', '0000000240', TO_DATE('1986-06-28', 'YYYY-MM-DD'), '3000000240', 'martin.nunez@abc.com', 1, 17, 18); -- Gerente de Marketing
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Paola', 'Castro', '0000000241', TO_DATE('1990-10-15', 'YYYY-MM-DD'), '3000000241', 'paola.castro@abc.com', 1, 17, 19); -- Publicista
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Esteban', 'Ardila', '0000000242', TO_DATE('1985-08-11', 'YYYY-MM-DD'), '3000000242', 'esteban.ardila@abc.com', 1, 17, 20); -- Diseñador
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Mariana', 'Ardila', '0000000243', TO_DATE('1989-08-12', 'YYYY-MM-DD'), '3000000243', 'mariana.ardila@abc.com', 1, 17, 20); -- Diseñador
-- Gerentes y Contador
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Daniela', 'Salazar', '0000000244', TO_DATE('1988-01-29', 'YYYY-MM-DD'), '3000000244', 'daniela.salazar@abc.com', 1, 17, 22); -- Gerente de Sede
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Alejandro', 'Valencia', '0000000245', TO_DATE('1986-04-20', 'YYYY-MM-DD'), '3000000245', 'alejandro.valencia@abc.com', 1, 17, 23); -- Contador
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Natalia', 'Paniagua', '0000000246', TO_DATE('1992-11-05', 'YYYY-MM-DD'), '3000000246', 'natalia.paniagua@abc.com', 1, 17, 24); -- Asistente Administrativo

--sede 19

-- Entrenadores y Personal de Entrenamiento
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Ana', 'Gómez', '0000000247', TO_DATE('1985-04-15', 'YYYY-MM-DD'), '3000000247', 'ana.gomez@bcd.com', 1, 19, 1); -- Entrenador Personal
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Rogelio', 'Gómez', '0000000248', TO_DATE('1986-04-16', 'YYYY-MM-DD'), '3000000248', 'roge.gomez@bcd.com', 1, 19, 1); -- Entrenador Personal
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Eustaquio', 'Pérez', '0000000249', TO_DATE('1980-02-16', 'YYYY-MM-DD'), '3000000249', 'eus.gomez@bcd.com', 1, 19, 1); -- Entrenador Personal
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Luis', 'Pérez', '0000000250', TO_DATE('1983-08-22', 'YYYY-MM-DD'), '3000000250', 'luis.perez@bcd.com', 1, 19, 2); -- Instructor de Clases Grupales
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Carlos', 'Morales', '0000000251', TO_DATE('1987-11-30', 'YYYY-MM-DD'), '3000000251', 'carlos.morales@bcd.com', 1, 19, 3); -- Coordinador de Entrenamiento
-- Fisioterapeutas y Asistentes
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Sofía', 'Vásquez', '0000000252', TO_DATE('1986-02-14', 'YYYY-MM-DD'), '3000000252', 'sofia.vasquez@bcd.com', 1, 19, 4); -- Fisioterapeuta
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Julio', 'Ramírez', '0000000253', TO_DATE('1990-06-25', 'YYYY-MM-DD'), '3000000253', 'julio.ramirez@bcd.com', 1, 19, 5); -- Rehabilitador Deportivo
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Laura', 'García', '0000000254', TO_DATE('1989-03-17', 'YYYY-MM-DD'), '3000000254', 'laura.garcia@bcd.com', 1, 19, 6); -- Asistente de Fisioterapia
-- Instructores para Niños
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Miguel', 'Hernández', '0000000255', TO_DATE('1992-07-08', 'YYYY-MM-DD'), '3000000255', 'miguel.hernandez@bcd.com', 1, 19, 7); -- Instructor de Actividades para Niños
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Claudia', 'Martínez', '0000000256', TO_DATE('1984-12-05', 'YYYY-MM-DD'), '3000000256', 'claudia.martinez@bcd.com', 1, 19, 8); -- Cuidador
-- Mantenimiento y Atención al Cliente
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Andrés', 'Pineda', '0000000257', TO_DATE('1981-01-12', 'YYYY-MM-DD'), '3000000257', 'andres.pineda@bcd.com', 1, 19, 9); -- Operario de Mantenimiento
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Andrea', 'Pineda', '0000000258', TO_DATE('1981-01-12', 'YYYY-MM-DD'), '3000000258', 'andrea.pineda@bcd.com', 1, 19, 9); -- Operario de Mantenimiento
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Ruperto', 'Pineda', '0000000259', TO_DATE('1981-01-13', 'YYYY-MM-DD'), '3000000259', 'ruperto.pineda@bcd.com', 1, 19, 11); -- Auxiliar de Servicios Generales
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Carmen', 'Hernández', '0000000260', TO_DATE('1982-01-15', 'YYYY-MM-DD'), '3000000260', 'carme.hdz@bcd.com', 1, 19, 11); -- Auxiliar de Servicios Generales
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Juan', 'Sánchez', '0000000261', TO_DATE('1990-05-19', 'YYYY-MM-DD'), '3000000261', 'juan.sanchez@bcd.com', 1, 19, 11); -- Auxiliar de Servicios Generales
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Isabel', 'Díaz', '0000000262', TO_DATE('1995-09-23', 'YYYY-MM-DD'), '3000000262', 'isabel.diaz@bcd.com', 1, 19, 10); -- Jefe de Mantenimiento
-- Atención al Cliente y Nutrición
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Valeria', 'Moreno', '0000000263', TO_DATE('1988-11-11', 'YYYY-MM-DD'), '3000000263', 'valeria.moreno@bcd.com', 1, 19, 12); -- Auxiliar de Atención al Cliente
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Camilo', 'Gómez', '0000000264', TO_DATE('1987-04-20', 'YYYY-MM-DD'), '3000000264', 'camilo.gomez@bcd.com', 1, 19, 13); -- Coordinador de Servicio al Cliente
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Gabriela', 'Ríos', '0000000265', TO_DATE('1991-10-29', 'YYYY-MM-DD'), '3000000265', 'gabriela.rios@bcd.com', 1, 19, 14); -- Nutricionista
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Felipe', 'Cruz', '0000000266', TO_DATE('1994-03-12', 'YYYY-MM-DD'), '3000000266', 'felipe.cruz@bcd.com', 1, 19, 15); -- Asesor de Suplementación
-- Otros roles
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Martín', 'Núñez', '0000000267', TO_DATE('1986-06-28', 'YYYY-MM-DD'), '3000000267', 'martin.nunez@bcd.com', 1, 19, 18); -- Gerente de Marketing
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Paola', 'Castro', '0000000268', TO_DATE('1990-10-15', 'YYYY-MM-DD'), '3000000268', 'paola.castro@bcd.com', 1, 19, 19); -- Publicista
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Esteban', 'Ardila', '0000000269', TO_DATE('1985-08-11', 'YYYY-MM-DD'), '3000000269', 'esteban.ardila@bcd.com', 1, 19, 20); -- Diseñador
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Mariana', 'Ardila', '0000000270', TO_DATE('1989-08-12', 'YYYY-MM-DD'), '3000000270', 'mariana.ardila@bcd.com', 1, 19, 20); -- Diseñador
-- Gerentes y Contador
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Daniela', 'Salazar', '0000000271', TO_DATE('1988-01-29', 'YYYY-MM-DD'), '3000000271', 'daniela.salazar@bcd.com', 1, 19, 22); -- Gerente de Sede
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Alejandro', 'Valencia', '0000000272', TO_DATE('1986-04-20', 'YYYY-MM-DD'), '3000000272', 'alejandro.valencia@bcd.com', 1, 19, 23); -- Contador
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Natalia', 'Paniagua', '0000000273', TO_DATE('1992-11-05', 'YYYY-MM-DD'), '3000000273', 'natalia.paniagua@bcd.com', 1, 19, 24); -- Asistente Administrativo

--sede 22

-- Entrenadores y Personal de Entrenamiento
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Ana', 'Gómez', '0000000274', TO_DATE('1985-04-15', 'YYYY-MM-DD'), '3000000274', 'ana.gomez@cde.com', 1, 22, 1); -- Entrenador Personal
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Rogelio', 'Gómez', '0000000275', TO_DATE('1986-04-16', 'YYYY-MM-DD'), '3000000275', 'roge.gomez@cde.com', 1, 22, 1); -- Entrenador Personal
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Eustaquio', 'Pérez', '0000000276', TO_DATE('1980-02-16', 'YYYY-MM-DD'), '3000000276', 'eus.gomez@cde.com', 1, 22, 1); -- Entrenador Personal
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Luis', 'Pérez', '0000000277', TO_DATE('1983-08-22', 'YYYY-MM-DD'), '3000000277', 'luis.perez@cde.com', 1, 22, 2); -- Instructor de Clases Grupales
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Carlos', 'Morales', '0000000278', TO_DATE('1987-11-30', 'YYYY-MM-DD'), '3000000278', 'carlos.morales@cde.com', 1, 22, 3); -- Coordinador de Entrenamiento
-- Fisioterapeutas y Asistentes
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Sofía', 'Vásquez', '0000000279', TO_DATE('1986-02-14', 'YYYY-MM-DD'), '3000000279', 'sofia.vasquez@cde.com', 1, 22, 4); -- Fisioterapeuta
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Julio', 'Ramírez', '0000000280', TO_DATE('1990-06-25', 'YYYY-MM-DD'), '3000000280', 'julio.ramirez@cde.com', 1, 22, 5); -- Rehabilitador Deportivo
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Laura', 'García', '0000000281', TO_DATE('1989-03-17', 'YYYY-MM-DD'), '3000000281', 'laura.garcia@cde.com', 1, 22, 6); -- Asistente de Fisioterapia
-- Instructores para Niños
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Miguel', 'Hernández', '0000000282', TO_DATE('1992-07-08', 'YYYY-MM-DD'), '3000000282', 'miguel.hernandez@cde.com', 1, 22, 7); -- Instructor de Actividades para Niños
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Claudia', 'Martínez', '0000000283', TO_DATE('1984-12-05', 'YYYY-MM-DD'), '3000000283', 'claudia.martinez@cde.com', 1, 22, 8); -- Cuidador
-- Mantenimiento y Atención al Cliente
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Andrés', 'Pineda', '0000000284', TO_DATE('1981-01-12', 'YYYY-MM-DD'), '3000000284', 'andres.pineda@cde.com', 1, 22, 9); -- Operario de Mantenimiento
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Andrea', 'Pineda', '0000000285', TO_DATE('1981-01-12', 'YYYY-MM-DD'), '3000000285', 'andrea.pineda@cde.com', 1, 22, 9); -- Operario de Mantenimiento
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Ruperto', 'Pineda', '0000000286', TO_DATE('1981-01-13', 'YYYY-MM-DD'), '3000000286', 'ruperto.pineda@cde.com', 1, 22, 11); -- Auxiliar de Servicios Generales
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Carmen', 'Hernández', '0000000287', TO_DATE('1982-01-15', 'YYYY-MM-DD'), '3000000287', 'carme.hdz@cde.com', 1, 22, 11); -- Auxiliar de Servicios Generales
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Juan', 'Sánchez', '0000000288', TO_DATE('1990-05-19', 'YYYY-MM-DD'), '3000000288', 'juan.sanchez@cde.com', 1, 22, 11); -- Auxiliar de Servicios Generales
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Isabel', 'Díaz', '0000000289', TO_DATE('1995-09-23', 'YYYY-MM-DD'), '3000000289', 'isabel.diaz@cde.com', 1, 22, 10); -- Jefe de Mantenimiento
-- Atención al Cliente y Nutrición
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Valeria', 'Moreno', '0000000290', TO_DATE('1988-11-11', 'YYYY-MM-DD'), '3000000290', 'valeria.moreno@cde.com', 1, 22, 12); -- Auxiliar de Atención al Cliente
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Camilo', 'Gómez', '0000000291', TO_DATE('1987-04-20', 'YYYY-MM-DD'), '3000000291', 'camilo.gomez@cde.com', 1, 22, 13); -- Coordinador de Servicio al Cliente
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Gabriela', 'Ríos', '0000000292', TO_DATE('1991-10-29', 'YYYY-MM-DD'), '3000000292', 'gabriela.rios@cde.com', 1, 22, 14); -- Nutricionista
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Felipe', 'Cruz', '0000000293', TO_DATE('1994-03-12', 'YYYY-MM-DD'), '3000000293', 'felipe.cruz@cde.com', 1, 22, 15); -- Asesor de Suplementación
-- Otros roles
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Martín', 'Núñez', '0000000294', TO_DATE('1986-06-28', 'YYYY-MM-DD'), '3000000294', 'martin.nunez@cde.com', 1, 22, 18); -- Gerente de Marketing
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Paola', 'Castro', '0000000295', TO_DATE('1990-10-15', 'YYYY-MM-DD'), '3000000295', 'paola.castro@cde.com', 1, 22, 19); -- Publicista
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Esteban', 'Ardila', '0000000296', TO_DATE('1985-08-11', 'YYYY-MM-DD'), '3000000296', 'esteban.ardila@cde.com', 1, 22, 20); -- Diseñador
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Mariana', 'Ardila', '0000000297', TO_DATE('1989-08-12', 'YYYY-MM-DD'), '3000000297', 'mariana.ardila@cde.com', 1, 22, 20); -- Diseñador
-- Gerentes y Contador
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Daniela', 'Salazar', '0000000298', TO_DATE('1988-01-29', 'YYYY-MM-DD'), '3000000298', 'daniela.salazar@cde.com', 1, 22, 22); -- Gerente de Sede
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Alejandro', 'Valencia', '0000000299', TO_DATE('1986-04-20', 'YYYY-MM-DD'), '3000000299', 'alejandro.valencia@cde.com', 1, 22, 23); -- Contador
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Natalia', 'Paniagua', '0000000300', TO_DATE('1992-11-05', 'YYYY-MM-DD'), '3000000300', 'natalia.paniagua@cde.com', 1, 22, 24); -- Asistente Administrativo

--sede 23

-- Entrenadores y Personal de Entrenamiento
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Ana', 'Gómez', '0000000301', TO_DATE('1985-04-15', 'YYYY-MM-DD'), '3000000301', 'ana.gomez@def.com', 1, 23, 1); -- Entrenador Personal
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Rogelio', 'Gómez', '0000000302', TO_DATE('1986-04-16', 'YYYY-MM-DD'), '3000000302', 'roge.gomez@def.com', 1, 23, 1); -- Entrenador Personal
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Eustaquio', 'Pérez', '0000000303', TO_DATE('1980-02-16', 'YYYY-MM-DD'), '3000000303', 'eus.gomez@def.com', 1, 23, 1); -- Entrenador Personal
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Luis', 'Pérez', '0000000304', TO_DATE('1983-08-22', 'YYYY-MM-DD'), '3000000304', 'luis.perez@def.com', 1, 23, 2); -- Instructor de Clases Grupales
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Carlos', 'Morales', '0000000305', TO_DATE('1987-11-30', 'YYYY-MM-DD'), '3000000305', 'carlos.morales@def.com', 1, 23, 3); -- Coordinador de Entrenamiento
-- Fisioterapeutas y Asistentes
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Sofía', 'Vásquez', '0000000306', TO_DATE('1986-02-14', 'YYYY-MM-DD'), '3000000306', 'sofia.vasquez@def.com', 1, 23, 4); -- Fisioterapeuta
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Julio', 'Ramírez', '0000000307', TO_DATE('1990-06-25', 'YYYY-MM-DD'), '3000000307', 'julio.ramirez@def.com', 1, 23, 5); -- Rehabilitador Deportivo
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Laura', 'García', '0000000308', TO_DATE('1989-03-17', 'YYYY-MM-DD'), '3000000308', 'laura.garcia@def.com', 1, 23, 6); -- Asistente de Fisioterapia
-- Instructores para Niños
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Miguel', 'Hernández', '0000000309', TO_DATE('1992-07-08', 'YYYY-MM-DD'), '3000000309', 'miguel.hernandez@def.com', 1, 23, 7); -- Instructor de Actividades para Niños
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Claudia', 'Martínez', '0000000310', TO_DATE('1984-12-05', 'YYYY-MM-DD'), '3000000310', 'claudia.martinez@def.com', 1, 23, 8); -- Cuidador
-- Mantenimiento y Atención al Cliente
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Andrés', 'Pineda', '0000000311', TO_DATE('1981-01-12', 'YYYY-MM-DD'), '3000000311', 'andres.pineda@def.com', 1, 23, 9); -- Operario de Mantenimiento
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Andrea', 'Pineda', '0000000312', TO_DATE('1981-01-12', 'YYYY-MM-DD'), '3000000312', 'andrea.pineda@def.com', 1, 23, 9); -- Operario de Mantenimiento
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Ruperto', 'Pineda', '0000000313', TO_DATE('1981-01-13', 'YYYY-MM-DD'), '3000000313', 'ruperto.pineda@def.com', 1, 23, 11); -- Auxiliar de Servicios Generales
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Carmen', 'Hernández', '0000000314', TO_DATE('1982-01-15', 'YYYY-MM-DD'), '3000000314', 'carme.hdz@def.com', 1, 23, 11); -- Auxiliar de Servicios Generales
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Juan', 'Sánchez', '0000000315', TO_DATE('1990-05-19', 'YYYY-MM-DD'), '3000000315', 'juan.sanchez@def.com', 1, 23, 11); -- Auxiliar de Servicios Generales
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Isabel', 'Díaz', '0000000316', TO_DATE('1995-09-23', 'YYYY-MM-DD'), '3000000316', 'isabel.diaz@def.com', 1, 23, 10); -- Jefe de Mantenimiento
-- Atención al Cliente y Nutrición
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Valeria', 'Moreno', '0000000317', TO_DATE('1988-11-11', 'YYYY-MM-DD'), '3000000317', 'valeria.moreno@def.com', 1, 23, 12); -- Auxiliar de Atención al Cliente
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Camilo', 'Gómez', '0000000318', TO_DATE('1987-04-20', 'YYYY-MM-DD'), '3000000318', 'camilo.gomez@def.com', 1, 23, 13); -- Coordinador de Servicio al Cliente
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Gabriela', 'Ríos', '0000000319', TO_DATE('1991-10-29', 'YYYY-MM-DD'), '3000000319', 'gabriela.rios@def.com', 1, 23, 14); -- Nutricionista
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Felipe', 'Cruz', '0000000320', TO_DATE('1994-03-12', 'YYYY-MM-DD'), '3000000320', 'felipe.cruz@def.com', 1, 23, 15); -- Asesor de Suplementación
-- Otros roles
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Martín', 'Núñez', '0000000321', TO_DATE('1986-06-28', 'YYYY-MM-DD'), '3000000321', 'martin.nunez@def.com', 1, 23, 18); -- Gerente de Marketing
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Paola', 'Castro', '0000000322', TO_DATE('1990-10-15', 'YYYY-MM-DD'), '3000000322', 'paola.castro@def.com', 1, 23, 19); -- Publicista
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Esteban', 'Ardila', '0000000323', TO_DATE('1985-08-11', 'YYYY-MM-DD'), '3000000323', 'esteban.ardila@def.com', 1, 23, 20); -- Diseñador
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Mariana', 'Ardila', '0000000324', TO_DATE('1989-08-12', 'YYYY-MM-DD'), '3000000324', 'mariana.ardila@def.com', 1, 23, 20); -- Diseñador
-- Gerentes y Contador
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Daniela', 'Salazar', '0000000325', TO_DATE('1988-01-29', 'YYYY-MM-DD'), '3000000325', 'daniela.salazar@def.com', 1, 23, 22); -- Gerente de Sede
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Alejandro', 'Valencia', '0000000326', TO_DATE('1986-04-20', 'YYYY-MM-DD'), '3000000326', 'alejandro.valencia@def.com', 1, 23, 23); -- Contador
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Natalia', 'Paniagua', '0000000327', TO_DATE('1992-11-05', 'YYYY-MM-DD'), '3000000327', 'natalia.paniagua@def.com', 1, 23, 24); -- Asistente Administrativo

--sede 25

-- Entrenadores y Personal de Entrenamiento
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Ana', 'Gómez', '0000000301', TO_DATE('1985-04-15', 'YYYY-MM-DD'), '3000000301', 'ana.gomez@def.com', 1, 23, 1); -- Entrenador Personal
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Rogelio', 'Gómez', '0000000302', TO_DATE('1986-04-16', 'YYYY-MM-DD'), '3000000302', 'roge.gomez@def.com', 1, 23, 1); -- Entrenador Personal
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Eustaquio', 'Pérez', '0000000303', TO_DATE('1980-02-16', 'YYYY-MM-DD'), '3000000303', 'eus.gomez@def.com', 1, 23, 1); -- Entrenador Personal
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Luis', 'Pérez', '0000000304', TO_DATE('1983-08-22', 'YYYY-MM-DD'), '3000000304', 'luis.perez@def.com', 1, 23, 2); -- Instructor de Clases Grupales
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Carlos', 'Morales', '0000000305', TO_DATE('1987-11-30', 'YYYY-MM-DD'), '3000000305', 'carlos.morales@def.com', 1, 23, 3); -- Coordinador de Entrenamiento
-- Fisioterapeutas y Asistentes
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Sofía', 'Vásquez', '0000000306', TO_DATE('1986-02-14', 'YYYY-MM-DD'), '3000000306', 'sofia.vasquez@def.com', 1, 23, 4); -- Fisioterapeuta
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Julio', 'Ramírez', '0000000307', TO_DATE('1990-06-25', 'YYYY-MM-DD'), '3000000307', 'julio.ramirez@def.com', 1, 23, 5); -- Rehabilitador Deportivo
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Laura', 'García', '0000000308', TO_DATE('1989-03-17', 'YYYY-MM-DD'), '3000000308', 'laura.garcia@def.com', 1, 23, 6); -- Asistente de Fisioterapia
-- Instructores para Niños
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Miguel', 'Hernández', '0000000309', TO_DATE('1992-07-08', 'YYYY-MM-DD'), '3000000309', 'miguel.hernandez@def.com', 1, 23, 7); -- Instructor de Actividades para Niños
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Claudia', 'Martínez', '0000000310', TO_DATE('1984-12-05', 'YYYY-MM-DD'), '3000000310', 'claudia.martinez@def.com', 1, 23, 8); -- Cuidador
-- Mantenimiento y Atención al Cliente
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Andrés', 'Pineda', '0000000311', TO_DATE('1981-01-12', 'YYYY-MM-DD'), '3000000311', 'andres.pineda@def.com', 1, 23, 9); -- Operario de Mantenimiento
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Andrea', 'Pineda', '0000000312', TO_DATE('1981-01-12', 'YYYY-MM-DD'), '3000000312', 'andrea.pineda@def.com', 1, 23, 9); -- Operario de Mantenimiento
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Ruperto', 'Pineda', '0000000313', TO_DATE('1981-01-13', 'YYYY-MM-DD'), '3000000313', 'ruperto.pineda@def.com', 1, 23, 11); -- Auxiliar de Servicios Generales
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Carmen', 'Hernández', '0000000314', TO_DATE('1982-01-15', 'YYYY-MM-DD'), '3000000314', 'carme.hdz@def.com', 1, 23, 11); -- Auxiliar de Servicios Generales
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Juan', 'Sánchez', '0000000315', TO_DATE('1990-05-19', 'YYYY-MM-DD'), '3000000315', 'juan.sanchez@def.com', 1, 23, 11); -- Auxiliar de Servicios Generales
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Isabel', 'Díaz', '0000000316', TO_DATE('1995-09-23', 'YYYY-MM-DD'), '3000000316', 'isabel.diaz@def.com', 1, 23, 10); -- Jefe de Mantenimiento
-- Atención al Cliente y Nutrición
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Valeria', 'Moreno', '0000000317', TO_DATE('1988-11-11', 'YYYY-MM-DD'), '3000000317', 'valeria.moreno@def.com', 1, 23, 12); -- Auxiliar de Atención al Cliente
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Camilo', 'Gómez', '0000000318', TO_DATE('1987-04-20', 'YYYY-MM-DD'), '3000000318', 'camilo.gomez@def.com', 1, 23, 13); -- Coordinador de Servicio al Cliente
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Gabriela', 'Ríos', '0000000319', TO_DATE('1991-10-29', 'YYYY-MM-DD'), '3000000319', 'gabriela.rios@def.com', 1, 23, 14); -- Nutricionista
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Felipe', 'Cruz', '0000000320', TO_DATE('1994-03-12', 'YYYY-MM-DD'), '3000000320', 'felipe.cruz@def.com', 1, 23, 15); -- Asesor de Suplementación
-- Otros roles
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Martín', 'Núñez', '0000000321', TO_DATE('1986-06-28', 'YYYY-MM-DD'), '3000000321', 'martin.nunez@def.com', 1, 23, 18); -- Gerente de Marketing
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Paola', 'Castro', '0000000322', TO_DATE('1990-10-15', 'YYYY-MM-DD'), '3000000322', 'paola.castro@def.com', 1, 23, 19); -- Publicista
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Esteban', 'Ardila', '0000000323', TO_DATE('1985-08-11', 'YYYY-MM-DD'), '3000000323', 'esteban.ardila@def.com', 1, 23, 20); -- Diseñador
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Mariana', 'Ardila', '0000000324', TO_DATE('1989-08-12', 'YYYY-MM-DD'), '3000000324', 'mariana.ardila@def.com', 1, 23, 20); -- Diseñador
-- Gerentes y Contador
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Daniela', 'Salazar', '0000000325', TO_DATE('1988-01-29', 'YYYY-MM-DD'), '3000000325', 'daniela.salazar@def.com', 1, 23, 22); -- Gerente de Sede
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Alejandro', 'Valencia', '0000000326', TO_DATE('1986-04-20', 'YYYY-MM-DD'), '3000000326', 'alejandro.valencia@def.com', 1, 23, 23); -- Contador
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Natalia', 'Paniagua', '0000000327', TO_DATE('1992-11-05', 'YYYY-MM-DD'), '3000000327', 'natalia.paniagua@def.com', 1, 23, 24); -- Asistente Administrativo

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