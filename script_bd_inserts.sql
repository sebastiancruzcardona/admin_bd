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
GRANT C##rol_programador_backend TO C##usuario_backend_1;

CREATE USER C##usuario_backend_2 IDENTIFIED BY "usBCK022024#c9";
GRANT C##rol_programador_backend TO C##usuario_backend_2;

CREATE USER C##usuario_administrativo_1 IDENTIFIED BY "usADM012024#f0";
GRANT C##rol_administrativo TO C##usuario_administrativo_1;

CREATE USER C##usuario_administrativo_1 IDENTIFIED BY "usADM022024#h7";
GRANT C##rol_administrativo TO C##usuario_administrativo_1;
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
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Ana', 'Gómez', '0000000328', TO_DATE('1985-04-15', 'YYYY-MM-DD'), '3000000328', 'ana.gomez@efg.com', 1, 25, 1); -- Entrenador Personal
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Rogelio', 'Gómez', '0000000329', TO_DATE('1986-04-16', 'YYYY-MM-DD'), '3000000329', 'roge.gomez@efg.com', 1, 25, 1); -- Entrenador Personal
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Eustaquio', 'Pérez', '0000000330', TO_DATE('1980-02-16', 'YYYY-MM-DD'), '3000000330', 'eus.gomez@efg.com', 1, 25, 1); -- Entrenador Personal
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Luis', 'Pérez', '0000000331', TO_DATE('1983-08-22', 'YYYY-MM-DD'), '3000000331', 'luis.perez@efg.com', 1, 25, 2); -- Instructor de Clases Grupales
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Carlos', 'Morales', '0000000332', TO_DATE('1987-11-30', 'YYYY-MM-DD'), '3000000332', 'carlos.morales@efg.com', 1, 25, 3); -- Coordinador de Entrenamiento
-- Fisioterapeutas y Asistentes
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Sofía', 'Vásquez', '0000000333', TO_DATE('1986-02-14', 'YYYY-MM-DD'), '3000000333', 'sofia.vasquez@efg.com', 1, 25, 4); -- Fisioterapeuta
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Julio', 'Ramírez', '0000000334', TO_DATE('1990-06-25', 'YYYY-MM-DD'), '3000000334', 'julio.ramirez@efg.com', 1, 25, 5); -- Rehabilitador Deportivo
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Laura', 'García', '0000000335', TO_DATE('1989-03-17', 'YYYY-MM-DD'), '3000000335', 'laura.garcia@efg.com', 1, 25, 6); -- Asistente de Fisioterapia
-- Instructores para Niños
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Miguel', 'Hernández', '0000000336', TO_DATE('1992-07-08', 'YYYY-MM-DD'), '3000000336', 'miguel.hernandez@efg.com', 1, 25, 7); -- Instructor de Actividades para Niños
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Claudia', 'Martínez', '0000000337', TO_DATE('1984-12-05', 'YYYY-MM-DD'), '3000000337', 'claudia.martinez@efg.com', 1, 25, 8); -- Cuidador
-- Mantenimiento y Atención al Cliente
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Andrés', 'Pineda', '0000000338', TO_DATE('1981-01-12', 'YYYY-MM-DD'), '3000000338', 'andres.pineda@efg.com', 1, 25, 9); -- Operario de Mantenimiento
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Andrea', 'Pineda', '0000000339', TO_DATE('1981-01-12', 'YYYY-MM-DD'), '3000000339', 'andrea.pineda@efg.com', 1, 25, 9); -- Operario de Mantenimiento
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Ruperto', 'Pineda', '0000000340', TO_DATE('1981-01-13', 'YYYY-MM-DD'), '3000000340', 'ruperto.pineda@efg.com', 1, 25, 11); -- Auxiliar de Servicios Generales
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Carmen', 'Hernández', '0000000341', TO_DATE('1982-01-15', 'YYYY-MM-DD'), '3000000341', 'carme.hdz@efg.com', 1, 25, 11); -- Auxiliar de Servicios Generales
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Juan', 'Sánchez', '0000000342', TO_DATE('1990-05-19', 'YYYY-MM-DD'), '3000000342', 'juan.sanchez@efg.com', 1, 25, 11); -- Auxiliar de Servicios Generales
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Isabel', 'Díaz', '0000000343', TO_DATE('1995-09-23', 'YYYY-MM-DD'), '3000000343', 'isabel.diaz@efg.com', 1, 25, 10); -- Jefe de Mantenimiento
-- Atención al Cliente y Nutrición
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Valeria', 'Moreno', '0000000344', TO_DATE('1988-11-11', 'YYYY-MM-DD'), '3000000344', 'valeria.moreno@efg.com', 1, 25, 12); -- Auxiliar de Atención al Cliente
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Camilo', 'Gómez', '0000000345', TO_DATE('1987-04-20', 'YYYY-MM-DD'), '3000000345', 'camilo.gomez@efg.com', 1, 25, 13); -- Coordinador de Servicio al Cliente
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Gabriela', 'Ríos', '0000000346', TO_DATE('1991-10-29', 'YYYY-MM-DD'), '3000000346', 'gabriela.rios@efg.com', 1, 25, 14); -- Nutricionista
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Felipe', 'Cruz', '0000000347', TO_DATE('1994-03-12', 'YYYY-MM-DD'), '3000000347', 'felipe.cruz@efg.com', 1, 25, 15); -- Asesor de Suplementación
-- Otros roles
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Martín', 'Núñez', '0000000348', TO_DATE('1986-06-28', 'YYYY-MM-DD'), '3000000348', 'martin.nunez@efg.com', 1, 25, 18); -- Gerente de Marketing
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Paola', 'Castro', '0000000349', TO_DATE('1990-10-15', 'YYYY-MM-DD'), '3000000349', 'paola.castro@efg.com', 1, 25, 19); -- Publicista
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Esteban', 'Ardila', '0000000350', TO_DATE('1985-08-11', 'YYYY-MM-DD'), '3000000350', 'esteban.ardila@efg.com', 1, 25, 20); -- Diseñador
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Mariana', 'Ardila', '0000000351', TO_DATE('1989-08-12', 'YYYY-MM-DD'), '3000000351', 'mariana.ardila@efg.com', 1, 25, 20); -- Diseñador
-- Gerentes y Contador
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Daniela', 'Salazar', '0000000352', TO_DATE('1988-01-29', 'YYYY-MM-DD'), '3000000352', 'daniela.salazar@efg.com', 1, 25, 22); -- Gerente de Sede
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Alejandro', 'Valencia', '0000000353', TO_DATE('1986-04-20', 'YYYY-MM-DD'), '3000000353', 'alejandro.valencia@efg.com', 1, 25, 23); -- Contador
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Natalia', 'Paniagua', '0000000354', TO_DATE('1992-11-05', 'YYYY-MM-DD'), '3000000354', 'natalia.paniagua@efg.com', 1, 25, 24); -- Asistente Administrativo

--sede 28

-- Entrenadores y Personal de Entrenamiento
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Ana', 'Gómez', '0000000355', TO_DATE('1985-04-15', 'YYYY-MM-DD'), '3000000355', 'ana.gomez@fgh.com', 1, 28, 1); -- Entrenador Personal
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Rogelio', 'Gómez', '0000000356', TO_DATE('1986-04-16', 'YYYY-MM-DD'), '3000000356', 'roge.gomez@fgh.com', 1, 28, 1); -- Entrenador Personal
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Eustaquio', 'Pérez', '0000000357', TO_DATE('1980-02-16', 'YYYY-MM-DD'), '3000000357', 'eus.gomez@fgh.com', 1, 28, 1); -- Entrenador Personal
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Luis', 'Pérez', '0000000358', TO_DATE('1983-08-22', 'YYYY-MM-DD'), '3000000358', 'luis.perez@fgh.com', 1, 28, 2); -- Instructor de Clases Grupales
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Carlos', 'Morales', '0000000359', TO_DATE('1987-11-30', 'YYYY-MM-DD'), '3000000359', 'carlos.morales@fgh.com', 1, 28, 3); -- Coordinador de Entrenamiento
-- Fisioterapeutas y Asistentes
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Sofía', 'Vásquez', '0000000360', TO_DATE('1986-02-14', 'YYYY-MM-DD'), '3000000360', 'sofia.vasquez@fgh.com', 1, 28, 4); -- Fisioterapeuta
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Julio', 'Ramírez', '0000000361', TO_DATE('1990-06-25', 'YYYY-MM-DD'), '3000000361', 'julio.ramirez@fgh.com', 1, 28, 5); -- Rehabilitador Deportivo
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Laura', 'García', '0000000362', TO_DATE('1989-03-17', 'YYYY-MM-DD'), '3000000362', 'laura.garcia@fgh.com', 1, 28, 6); -- Asistente de Fisioterapia
-- Instructores para Niños
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Miguel', 'Hernández', '0000000363', TO_DATE('1992-07-08', 'YYYY-MM-DD'), '3000000363', 'miguel.hernandez@fgh.com', 1, 28, 7); -- Instructor de Actividades para Niños
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Claudia', 'Martínez', '0000000364', TO_DATE('1984-12-05', 'YYYY-MM-DD'), '3000000364', 'claudia.martinez@fgh.com', 1, 28, 8); -- Cuidador
-- Mantenimiento y Atención al Cliente
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Andrés', 'Pineda', '0000000365', TO_DATE('1981-01-12', 'YYYY-MM-DD'), '3000000365', 'andres.pineda@fgh.com', 1, 28, 9); -- Operario de Mantenimiento
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Andrea', 'Pineda', '0000000366', TO_DATE('1981-01-12', 'YYYY-MM-DD'), '3000000366', 'andrea.pineda@fgh.com', 1, 28, 9); -- Operario de Mantenimiento
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Ruperto', 'Pineda', '0000000367', TO_DATE('1981-01-13', 'YYYY-MM-DD'), '3000000367', 'ruperto.pineda@fgh.com', 1, 28, 11); -- Auxiliar de Servicios Generales
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Carmen', 'Hernández', '0000000368', TO_DATE('1982-01-15', 'YYYY-MM-DD'), '3000000368', 'carme.hdz@fgh.com', 1, 28, 11); -- Auxiliar de Servicios Generales
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Juan', 'Sánchez', '0000000369', TO_DATE('1990-05-19', 'YYYY-MM-DD'), '3000000369', 'juan.sanchez@fgh.com', 1, 28, 11); -- Auxiliar de Servicios Generales
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Isabel', 'Díaz', '0000000370', TO_DATE('1995-09-23', 'YYYY-MM-DD'), '3000000370', 'isabel.diaz@fgh.com', 1, 28, 10); -- Jefe de Mantenimiento
-- Atención al Cliente y Nutrición
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Valeria', 'Moreno', '0000000371', TO_DATE('1988-11-11', 'YYYY-MM-DD'), '3000000371', 'valeria.moreno@fgh.com', 1, 28, 12); -- Auxiliar de Atención al Cliente
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Camilo', 'Gómez', '0000000372', TO_DATE('1987-04-20', 'YYYY-MM-DD'), '3000000372', 'camilo.gomez@fgh.com', 1, 28, 13); -- Coordinador de Servicio al Cliente
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Gabriela', 'Ríos', '0000000373', TO_DATE('1991-10-29', 'YYYY-MM-DD'), '3000000373', 'gabriela.rios@fgh.com', 1, 28, 14); -- Nutricionista
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Felipe', 'Cruz', '0000000374', TO_DATE('1994-03-12', 'YYYY-MM-DD'), '3000000374', 'felipe.cruz@fgh.com', 1, 28, 15); -- Asesor de Suplementación
-- Otros roles
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Martín', 'Núñez', '0000000375', TO_DATE('1986-06-28', 'YYYY-MM-DD'), '3000000375', 'martin.nunez@fgh.com', 1, 28, 18); -- Gerente de Marketing
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Paola', 'Castro', '0000000376', TO_DATE('1990-10-15', 'YYYY-MM-DD'), '3000000376', 'paola.castro@fgh.com', 1, 28, 19); -- Publicista
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Esteban', 'Ardila', '0000000377', TO_DATE('1985-08-11', 'YYYY-MM-DD'), '3000000377', 'esteban.ardila@fgh.com', 1, 28, 20); -- Diseñador
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Mariana', 'Ardila', '0000000378', TO_DATE('1989-08-12', 'YYYY-MM-DD'), '3000000378', 'mariana.ardila@fgh.com', 1, 28, 20); -- Diseñador
-- Gerentes y Contador
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Daniela', 'Salazar', '0000000379', TO_DATE('1988-01-29', 'YYYY-MM-DD'), '3000000379', 'daniela.salazar@fgh.com', 1, 28, 22); -- Gerente de Sede
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Alejandro', 'Valencia', '0000000380', TO_DATE('1986-04-20', 'YYYY-MM-DD'), '3000000380', 'alejandro.valencia@fgh.com', 1, 28, 23); -- Contador
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Natalia', 'Paniagua', '0000000381', TO_DATE('1992-11-05', 'YYYY-MM-DD'), '3000000381', 'natalia.paniagua@fgh.com', 1, 28, 24); -- Asistente Administrativo


--Sedes pequeñas
--sede 2

-- Entrenadores y Personal de Entrenamiento
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Ana', 'Gómez', '0000000382', TO_DATE('1985-04-15', 'YYYY-MM-DD'), '3000000382', 'ana.gomez@ghi.com', 1, 2, 1); -- Entrenador Personal
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Rogelio', 'Gómez', '0000000383', TO_DATE('1986-04-16', 'YYYY-MM-DD'), '3000000383', 'roge.gomez@ghi.com', 1, 2, 1); -- Entrenador Personal
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Luis', 'Pérez', '0000000384', TO_DATE('1983-08-22', 'YYYY-MM-DD'), '3000000384', 'luis.perez@ghi.com', 1, 2, 2); -- Instructor de Clases Grupales
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Carlos', 'Morales', '0000000385', TO_DATE('1987-11-30', 'YYYY-MM-DD'), '3000000385', 'carlos.morales@ghi.com', 1, 2, 3); -- Coordinador de Entrenamiento
-- Mantenimiento y Atención al Cliente
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Andrés', 'Pineda', '0000000386', TO_DATE('1981-01-12', 'YYYY-MM-DD'), '3000000386', 'andres.pineda@ghi.com', 1, 2, 9); -- Operario de Mantenimiento
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Ruperto', 'Pineda', '0000000387', TO_DATE('1981-01-13', 'YYYY-MM-DD'), '3000000387', 'ruperto.pineda@ghi.com', 1, 2, 11); -- Auxiliar de Servicios Generales
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Juan', 'Sánchez', '0000000388', TO_DATE('1990-05-19', 'YYYY-MM-DD'), '3000000388', 'juan.sanchez@ghi.com', 1, 2, 11); -- Auxiliar de Servicios Generales
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Isabel', 'Díaz', '0000000389', TO_DATE('1995-09-23', 'YYYY-MM-DD'), '3000000389', 'isabel.diaz@ghi.com', 1, 2, 10); -- Jefe de Mantenimiento
-- Atención al Cliente y Nutrición
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Valeria', 'Moreno', '0000000390', TO_DATE('1988-11-11', 'YYYY-MM-DD'), '3000000390', 'valeria.moreno@ghi.com', 1, 2, 12); -- Auxiliar de Atención al Cliente
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Camilo', 'Gómez', '0000000391', TO_DATE('1987-04-20', 'YYYY-MM-DD'), '3000000391', 'camilo.gomez@ghi.com', 1, 2, 13); -- Coordinador de Servicio al Cliente
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Gabriela', 'Ríos', '0000000392', TO_DATE('1991-10-29', 'YYYY-MM-DD'), '3000000392', 'gabriela.rios@ghi.com', 1, 2, 14); -- Nutricionista
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Felipe', 'Cruz', '0000000393', TO_DATE('1994-03-12', 'YYYY-MM-DD'), '3000000393', 'felipe.cruz@ghi.com', 1, 2, 15); -- Asesor de Suplementación
-- Gerentes y Contador
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Daniela', 'Salazar', '0000000394', TO_DATE('1988-01-29', 'YYYY-MM-DD'), '3000000394', 'daniela.salazar@ghi.com', 1, 2, 22); -- Gerente de Sede
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Alejandro', 'Valencia', '0000000395', TO_DATE('1986-04-20', 'YYYY-MM-DD'), '3000000395', 'alejandro.valencia@ghi.com', 1, 2, 23); -- Contador
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Natalia', 'Paniagua', '0000000396', TO_DATE('1992-11-05', 'YYYY-MM-DD'), '3000000396', 'natalia.paniagua@ghi.com', 1, 2, 24); -- Asistente Administrativo

--sede 3

-- Entrenadores y Personal de Entrenamiento
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Ana', 'Gómez', '0000000397', TO_DATE('1985-04-15', 'YYYY-MM-DD'), '3000000397', 'ana.gomez@hij.com', 1, 3, 1); -- Entrenador Personal
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Rogelio', 'Gómez', '0000000398', TO_DATE('1986-04-16', 'YYYY-MM-DD'), '3000000398', 'roge.gomez@hij.com', 1, 3, 1); -- Entrenador Personal
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Luis', 'Pérez', '0000000399', TO_DATE('1983-08-22', 'YYYY-MM-DD'), '3000000399', 'luis.perez@hij.com', 1, 3, 2); -- Instructor de Clases Grupales
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Carlos', 'Morales', '0000000400', TO_DATE('1987-11-30', 'YYYY-MM-DD'), '3000000400', 'carlos.morales@hij.com', 1, 3, 3); -- Coordinador de Entrenamiento
-- Mantenimiento y Atención al Cliente
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Andrés', 'Pineda', '0000000401', TO_DATE('1981-01-12', 'YYYY-MM-DD'), '3000000401', 'andres.pineda@hij.com', 1, 3, 9); -- Operario de Mantenimiento
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Ruperto', 'Pineda', '0000000402', TO_DATE('1981-01-13', 'YYYY-MM-DD'), '3000000402', 'ruperto.pineda@hij.com', 1, 3, 11); -- Auxiliar de Servicios Generales
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Juan', 'Sánchez', '0000000403', TO_DATE('1990-05-19', 'YYYY-MM-DD'), '3000000403', 'juan.sanchez@hij.com', 1, 3, 11); -- Auxiliar de Servicios Generales
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Isabel', 'Díaz', '0000000404', TO_DATE('1995-09-23', 'YYYY-MM-DD'), '3000000404', 'isabel.diaz@hij.com', 1, 3, 10); -- Jefe de Mantenimiento
-- Atención al Cliente y Nutrición
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Valeria', 'Moreno', '0000000405', TO_DATE('1988-11-11', 'YYYY-MM-DD'), '3000000405', 'valeria.moreno@hij.com', 1, 3, 12); -- Auxiliar de Atención al Cliente
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Camilo', 'Gómez', '0000000406', TO_DATE('1987-04-20', 'YYYY-MM-DD'), '3000000406', 'camilo.gomez@hij.com', 1, 3, 13); -- Coordinador de Servicio al Cliente
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Gabriela', 'Ríos', '0000000407', TO_DATE('1991-10-29', 'YYYY-MM-DD'), '3000000407', 'gabriela.rios@hij.com', 1, 3, 14); -- Nutricionista
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Felipe', 'Cruz', '0000000408', TO_DATE('1994-03-12', 'YYYY-MM-DD'), '3000000408', 'felipe.cruz@hij.com', 1, 3, 15); -- Asesor de Suplementación
-- Gerentes y Contador
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Daniela', 'Salazar', '0000000409', TO_DATE('1988-01-29', 'YYYY-MM-DD'), '3000000409', 'daniela.salazar@hij.com', 1, 3, 22); -- Gerente de Sede
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Alejandro', 'Valencia', '0000000410', TO_DATE('1986-04-20', 'YYYY-MM-DD'), '3000000410', 'alejandro.valencia@hij.com', 1, 3, 23); -- Contador
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Natalia', 'Paniagua', '0000000411', TO_DATE('1992-11-05', 'YYYY-MM-DD'), '3000000411', 'natalia.paniagua@hij.com', 1, 3, 24); -- Asistente Administrativo

--sede 5

-- Entrenadores y Personal de Entrenamiento
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Ana', 'Gómez', '0000000412', TO_DATE('1985-04-15', 'YYYY-MM-DD'), '3000000412', 'ana.gomez@hij.com', 1, 5, 1); -- Entrenador Personal
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Rogelio', 'Gómez', '0000000413', TO_DATE('1986-04-16', 'YYYY-MM-DD'), '3000000413', 'roge.gomez@hij.com', 1, 5, 1); -- Entrenador Personal
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Luis', 'Pérez', '0000000414', TO_DATE('1983-08-22', 'YYYY-MM-DD'), '3000000414', 'luis.perez@hij.com', 1, 5, 2); -- Instructor de Clases Grupales
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Carlos', 'Morales', '0000000415', TO_DATE('1987-11-30', 'YYYY-MM-DD'), '3000000415', 'carlos.morales@hij.com', 1, 5, 3); -- Coordinador de Entrenamiento
-- Mantenimiento y Atención al Cliente
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Andrés', 'Pineda', '0000000416', TO_DATE('1981-01-12', 'YYYY-MM-DD'), '3000000416', 'andres.pineda@hij.com', 1, 5, 9); -- Operario de Mantenimiento
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Ruperto', 'Pineda', '0000000417', TO_DATE('1981-01-13', 'YYYY-MM-DD'), '3000000417', 'ruperto.pineda@hij.com', 1, 5, 11); -- Auxiliar de Servicios Generales
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Juan', 'Sánchez', '0000000418', TO_DATE('1990-05-19', 'YYYY-MM-DD'), '3000000418', 'juan.sanchez@hij.com', 1, 5, 11); -- Auxiliar de Servicios Generales
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Isabel', 'Díaz', '0000000419', TO_DATE('1995-09-23', 'YYYY-MM-DD'), '3000000419', 'isabel.diaz@hij.com', 1, 5, 10); -- Jefe de Mantenimiento
-- Atención al Cliente y Nutrición
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Valeria', 'Moreno', '0000000420', TO_DATE('1988-11-11', 'YYYY-MM-DD'), '3000000420', 'valeria.moreno@hij.com', 1, 5, 12); -- Auxiliar de Atención al Cliente
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Camilo', 'Gómez', '0000000421', TO_DATE('1987-04-20', 'YYYY-MM-DD'), '3000000421', 'camilo.gomez@hij.com', 1, 5, 13); -- Coordinador de Servicio al Cliente
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Gabriela', 'Ríos', '0000000422', TO_DATE('1991-10-29', 'YYYY-MM-DD'), '3000000422', 'gabriela.rios@hij.com', 1, 5, 14); -- Nutricionista
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Felipe', 'Cruz', '0000000423', TO_DATE('1994-03-12', 'YYYY-MM-DD'), '3000000423', 'felipe.cruz@hij.com', 1, 5, 15); -- Asesor de Suplementación
-- Gerentes y Contador
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Daniela', 'Salazar', '0000000424', TO_DATE('1988-01-29', 'YYYY-MM-DD'), '3000000424', 'daniela.salazar@hij.com', 1, 5, 22); -- Gerente de Sede
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Alejandro', 'Valencia', '0000000425', TO_DATE('1986-04-20', 'YYYY-MM-DD'), '3000000425', 'alejandro.valencia@hij.com', 1, 5, 23); -- Contador
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Natalia', 'Paniagua', '0000000426', TO_DATE('1992-11-05', 'YYYY-MM-DD'), '3000000426', 'natalia.paniagua@hij.com', 1, 5, 24); -- Asistente Administrativo

--sede 6

-- Entrenadores y Personal de Entrenamiento
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Ana', 'Gómez', '0000000427', TO_DATE('1985-04-15', 'YYYY-MM-DD'), '3000000427', 'ana.gomez@ijk.com', 1, 6, 1); -- Entrenador Personal
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Rogelio', 'Gómez', '0000000428', TO_DATE('1986-04-16', 'YYYY-MM-DD'), '3000000428', 'roge.gomez@ijk.com', 1, 6, 1); -- Entrenador Personal
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Luis', 'Pérez', '0000000429', TO_DATE('1983-08-22', 'YYYY-MM-DD'), '3000000429', 'luis.perez@ijk.com', 1, 6, 2); -- Instructor de Clases Grupales
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Carlos', 'Morales', '0000000430', TO_DATE('1987-11-30', 'YYYY-MM-DD'), '3000000430', 'carlos.morales@ijk.com', 1, 6, 3); -- Coordinador de Entrenamiento
-- Mantenimiento y Atención al Cliente
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Andrés', 'Pineda', '0000000431', TO_DATE('1981-01-12', 'YYYY-MM-DD'), '3000000431', 'andres.pineda@ijk.com', 1, 6, 9); -- Operario de Mantenimiento
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Ruperto', 'Pineda', '0000000432', TO_DATE('1981-01-13', 'YYYY-MM-DD'), '3000000432', 'ruperto.pineda@ijk.com', 1, 6, 11); -- Auxiliar de Servicios Generales
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Juan', 'Sánchez', '0000000433', TO_DATE('1990-05-19', 'YYYY-MM-DD'), '3000000433', 'juan.sanchez@ijk.com', 1, 6, 11); -- Auxiliar de Servicios Generales
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Isabel', 'Díaz', '0000000434', TO_DATE('1995-09-23', 'YYYY-MM-DD'), '3000000434', 'isabel.diaz@ijk.com', 1, 6, 10); -- Jefe de Mantenimiento
-- Atención al Cliente y Nutrición
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Valeria', 'Moreno', '0000000435', TO_DATE('1988-11-11', 'YYYY-MM-DD'), '3000000435', 'valeria.moreno@ijk.com', 1, 6, 12); -- Auxiliar de Atención al Cliente
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Camilo', 'Gómez', '0000000436', TO_DATE('1987-04-20', 'YYYY-MM-DD'), '3000000436', 'camilo.gomez@ijk.com', 1, 6, 13); -- Coordinador de Servicio al Cliente
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Gabriela', 'Ríos', '0000000437', TO_DATE('1991-10-29', 'YYYY-MM-DD'), '3000000437', 'gabriela.rios@ijk.com', 1, 6, 14); -- Nutricionista
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Felipe', 'Cruz', '0000000438', TO_DATE('1994-03-12', 'YYYY-MM-DD'), '3000000438', 'felipe.cruz@ijk.com', 1, 6, 15); -- Asesor de Suplementación
-- Gerentes y Contador
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Daniela', 'Salazar', '0000000439', TO_DATE('1988-01-29', 'YYYY-MM-DD'), '3000000439', 'daniela.salazar@ijk.com', 1, 6, 22); -- Gerente de Sede
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Alejandro', 'Valencia', '0000000440', TO_DATE('1986-04-20', 'YYYY-MM-DD'), '3000000440', 'alejandro.valencia@ijk.com', 1, 6, 23); -- Contador
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Natalia', 'Paniagua', '0000000441', TO_DATE('1992-11-05', 'YYYY-MM-DD'), '3000000441', 'natalia.paniagua@ijk.com', 1, 6, 24); -- Asistente Administrativo

--sede 9

-- Entrenadores y Personal de Entrenamiento
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Ana', 'Gómez', '0000000442', TO_DATE('1985-04-15', 'YYYY-MM-DD'), '3000000442', 'ana.gomez@jkl.com', 1, 9, 1); -- Entrenador Personal
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Rogelio', 'Gómez', '0000000443', TO_DATE('1986-04-16', 'YYYY-MM-DD'), '3000000443', 'roge.gomez@jkl.com', 1, 9, 1); -- Entrenador Personal
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Luis', 'Pérez', '0000000444', TO_DATE('1983-08-22', 'YYYY-MM-DD'), '3000000444', 'luis.perez@jkl.com', 1, 9, 2); -- Instructor de Clases Grupales
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Carlos', 'Morales', '0000000445', TO_DATE('1987-11-30', 'YYYY-MM-DD'), '3000000445', 'carlos.morales@jkl.com', 1, 9, 3); -- Coordinador de Entrenamiento
-- Mantenimiento y Atención al Cliente
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Andrés', 'Pineda', '0000000446', TO_DATE('1981-01-12', 'YYYY-MM-DD'), '3000000446', 'andres.pineda@jkl.com', 1, 9, 9); -- Operario de Mantenimiento
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Ruperto', 'Pineda', '0000000447', TO_DATE('1981-01-13', 'YYYY-MM-DD'), '3000000447', 'ruperto.pineda@jkl.com', 1, 9, 11); -- Auxiliar de Servicios Generales
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Juan', 'Sánchez', '0000000448', TO_DATE('1990-05-19', 'YYYY-MM-DD'), '3000000448', 'juan.sanchez@jkl.com', 1, 9, 11); -- Auxiliar de Servicios Generales
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Isabel', 'Díaz', '0000000449', TO_DATE('1995-09-23', 'YYYY-MM-DD'), '3000000449', 'isabel.diaz@jkl.com', 1, 9, 10); -- Jefe de Mantenimiento
-- Atención al Cliente y Nutrición
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Valeria', 'Moreno', '0000000450', TO_DATE('1988-11-11', 'YYYY-MM-DD'), '3000000450', 'valeria.moreno@jkl.com', 1, 9, 12); -- Auxiliar de Atención al Cliente
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Camilo', 'Gómez', '0000000451', TO_DATE('1987-04-20', 'YYYY-MM-DD'), '3000000451', 'camilo.gomez@jkl.com', 1, 9, 13); -- Coordinador de Servicio al Cliente
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Gabriela', 'Ríos', '0000000452', TO_DATE('1991-10-29', 'YYYY-MM-DD'), '3000000452', 'gabriela.rios@jkl.com', 1, 9, 14); -- Nutricionista
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Felipe', 'Cruz', '0000000453', TO_DATE('1994-03-12', 'YYYY-MM-DD'), '3000000453', 'felipe.cruz@jkl.com', 1, 9, 15); -- Asesor de Suplementación
-- Gerentes y Contador
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Daniela', 'Salazar', '0000000454', TO_DATE('1988-01-29', 'YYYY-MM-DD'), '3000000454', 'daniela.salazar@jkl.com', 1, 9, 22); -- Gerente de Sede
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Alejandro', 'Valencia', '0000000455', TO_DATE('1986-04-20', 'YYYY-MM-DD'), '3000000455', 'alejandro.valencia@jkl.com', 1, 9, 23); -- Contador
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Natalia', 'Paniagua', '0000000456', TO_DATE('1992-11-05', 'YYYY-MM-DD'), '3000000456', 'natalia.paniagua@jkl.com', 1, 9, 24); -- Asistente Administrativo

--sede 13

-- Entrenadores y Personal de Entrenamiento
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Ana', 'Gómez', '0000000457', TO_DATE('1985-04-15', 'YYYY-MM-DD'), '3000000457', 'ana.gomez@klm.com', 1, 13, 1); -- Entrenador Personal
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Rogelio', 'Gómez', '0000000458', TO_DATE('1986-04-16', 'YYYY-MM-DD'), '3000000458', 'roge.gomez@klm.com', 1, 13, 1); -- Entrenador Personal
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Luis', 'Pérez', '0000000459', TO_DATE('1983-08-22', 'YYYY-MM-DD'), '3000000459', 'luis.perez@klm.com', 1, 13, 2); -- Instructor de Clases Grupales
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Carlos', 'Morales', '0000000460', TO_DATE('1987-11-30', 'YYYY-MM-DD'), '3000000460', 'carlos.morales@klm.com', 1, 13, 3); -- Coordinador de Entrenamiento
-- Mantenimiento y Atención al Cliente
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Andrés', 'Pineda', '0000000461', TO_DATE('1981-01-12', 'YYYY-MM-DD'), '3000000461', 'andres.pineda@klm.com', 1, 13, 9); -- Operario de Mantenimiento
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Ruperto', 'Pineda', '0000000462', TO_DATE('1981-01-13', 'YYYY-MM-DD'), '3000000462', 'ruperto.pineda@klm.com', 1, 13, 11); -- Auxiliar de Servicios Generales
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Juan', 'Sánchez', '0000000463', TO_DATE('1990-05-19', 'YYYY-MM-DD'), '3000000463', 'juan.sanchez@klm.com', 1, 13, 11); -- Auxiliar de Servicios Generales
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Isabel', 'Díaz', '0000000464', TO_DATE('1995-09-23', 'YYYY-MM-DD'), '3000000464', 'isabel.diaz@klm.com', 1, 13, 10); -- Jefe de Mantenimiento
-- Atención al Cliente y Nutrición
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Valeria', 'Moreno', '0000000465', TO_DATE('1988-11-11', 'YYYY-MM-DD'), '3000000465', 'valeria.moreno@klm.com', 1, 13, 12); -- Auxiliar de Atención al Cliente
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Camilo', 'Gómez', '0000000466', TO_DATE('1987-04-20', 'YYYY-MM-DD'), '3000000466', 'camilo.gomez@klm.com', 1, 13, 13); -- Coordinador de Servicio al Cliente
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Gabriela', 'Ríos', '0000000467', TO_DATE('1991-10-29', 'YYYY-MM-DD'), '3000000467', 'gabriela.rios@klm.com', 1, 13, 14); -- Nutricionista
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Felipe', 'Cruz', '0000000468', TO_DATE('1994-03-12', 'YYYY-MM-DD'), '3000000468', 'felipe.cruz@klm.com', 1, 13, 15); -- Asesor de Suplementación
-- Gerentes y Contador
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Daniela', 'Salazar', '0000000469', TO_DATE('1988-01-29', 'YYYY-MM-DD'), '3000000469', 'daniela.salazar@klm.com', 1, 13, 22); -- Gerente de Sede
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Alejandro', 'Valencia', '0000000470', TO_DATE('1986-04-20', 'YYYY-MM-DD'), '3000000470', 'alejandro.valencia@klm.com', 1, 13, 23); -- Contador
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Natalia', 'Paniagua', '0000000471', TO_DATE('1992-11-05', 'YYYY-MM-DD'), '3000000471', 'natalia.paniagua@klm.com', 1, 13, 24); -- Asistente Administrativo

--sede 15

-- Entrenadores y Personal de Entrenamiento
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Ana', 'Gómez', '0000000472', TO_DATE('1985-04-15', 'YYYY-MM-DD'), '3000000472', 'ana.gomez@lmn.com', 1, 15, 1); -- Entrenador Personal
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Rogelio', 'Gómez', '0000000473', TO_DATE('1986-04-16', 'YYYY-MM-DD'), '3000000473', 'roge.gomez@lmn.com', 1, 15, 1); -- Entrenador Personal
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Luis', 'Pérez', '0000000474', TO_DATE('1983-08-22', 'YYYY-MM-DD'), '3000000474', 'luis.perez@lmn.com', 1, 15, 2); -- Instructor de Clases Grupales
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Carlos', 'Morales', '0000000475', TO_DATE('1987-11-30', 'YYYY-MM-DD'), '3000000475', 'carlos.morales@lmn.com', 1, 15, 3); -- Coordinador de Entrenamiento
-- Mantenimiento y Atención al Cliente
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Andrés', 'Pineda', '0000000476', TO_DATE('1981-01-12', 'YYYY-MM-DD'), '3000000476', 'andres.pineda@lmn.com', 1, 15, 9); -- Operario de Mantenimiento
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Ruperto', 'Pineda', '0000000477', TO_DATE('1981-01-13', 'YYYY-MM-DD'), '3000000477', 'ruperto.pineda@lmn.com', 1, 15, 11); -- Auxiliar de Servicios Generales
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Juan', 'Sánchez', '0000000478', TO_DATE('1990-05-19', 'YYYY-MM-DD'), '3000000478', 'juan.sanchez@lmn.com', 1, 15, 11); -- Auxiliar de Servicios Generales
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Isabel', 'Díaz', '0000000479', TO_DATE('1995-09-23', 'YYYY-MM-DD'), '3000000479', 'isabel.diaz@lmn.com', 1, 15, 10); -- Jefe de Mantenimiento
-- Atención al Cliente y Nutrición
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Valeria', 'Moreno', '0000000480', TO_DATE('1988-11-11', 'YYYY-MM-DD'), '3000000480', 'valeria.moreno@lmn.com', 1, 15, 12); -- Auxiliar de Atención al Cliente
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Camilo', 'Gómez', '0000000481', TO_DATE('1987-04-20', 'YYYY-MM-DD'), '3000000481', 'camilo.gomez@lmn.com', 1, 15, 13); -- Coordinador de Servicio al Cliente
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Gabriela', 'Ríos', '0000000482', TO_DATE('1991-10-29', 'YYYY-MM-DD'), '3000000482', 'gabriela.rios@lmn.com', 1, 15, 14); -- Nutricionista
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Felipe', 'Cruz', '0000000483', TO_DATE('1994-03-12', 'YYYY-MM-DD'), '3000000483', 'felipe.cruz@lmn.com', 1, 15, 15); -- Asesor de Suplementación
-- Gerentes y Contador
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Daniela', 'Salazar', '0000000484', TO_DATE('1988-01-29', 'YYYY-MM-DD'), '3000000484', 'daniela.salazar@lmn.com', 1, 15, 22); -- Gerente de Sede
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Alejandro', 'Valencia', '0000000485', TO_DATE('1986-04-20', 'YYYY-MM-DD'), '3000000485', 'alejandro.valencia@lmn.com', 1, 15, 23); -- Contador
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Natalia', 'Paniagua', '0000000486', TO_DATE('1992-11-05', 'YYYY-MM-DD'), '3000000486', 'natalia.paniagua@lmn.com', 1, 15, 24); -- Asistente Administrativo

--sede 16

-- Entrenadores y Personal de Entrenamiento
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Ana', 'Gómez', '0000000487', TO_DATE('1985-04-15', 'YYYY-MM-DD'), '3000000487', 'ana.gomez@mno.com', 1, 16, 1); -- Entrenador Personal
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Rogelio', 'Gómez', '0000000488', TO_DATE('1986-04-16', 'YYYY-MM-DD'), '3000000488', 'roge.gomez@mno.com', 1, 16, 1); -- Entrenador Personal
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Luis', 'Pérez', '0000000489', TO_DATE('1983-08-22', 'YYYY-MM-DD'), '3000000489', 'luis.perez@mno.com', 1, 16, 2); -- Instructor de Clases Grupales
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Carlos', 'Morales', '0000000490', TO_DATE('1987-11-30', 'YYYY-MM-DD'), '3000000490', 'carlos.morales@mno.com', 1, 16, 3); -- Coordinador de Entrenamiento
-- Mantenimiento y Atención al Cliente
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Andrés', 'Pineda', '0000000491', TO_DATE('1981-01-12', 'YYYY-MM-DD'), '3000000491', 'andres.pineda@mno.com', 1, 16, 9); -- Operario de Mantenimiento
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Ruperto', 'Pineda', '0000000492', TO_DATE('1981-01-13', 'YYYY-MM-DD'), '3000000492', 'ruperto.pineda@mno.com', 1, 16, 11); -- Auxiliar de Servicios Generales
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Juan', 'Sánchez', '0000000493', TO_DATE('1990-05-19', 'YYYY-MM-DD'), '3000000493', 'juan.sanchez@mno.com', 1, 16, 11); -- Auxiliar de Servicios Generales
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Isabel', 'Díaz', '0000000494', TO_DATE('1995-09-23', 'YYYY-MM-DD'), '3000000494', 'isabel.diaz@mno.com', 1, 16, 10); -- Jefe de Mantenimiento
-- Atención al Cliente y Nutrición
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Valeria', 'Moreno', '0000000495', TO_DATE('1988-11-11', 'YYYY-MM-DD'), '3000000495', 'valeria.moreno@mno.com', 1, 16, 12); -- Auxiliar de Atención al Cliente
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Camilo', 'Gómez', '0000000496', TO_DATE('1987-04-20', 'YYYY-MM-DD'), '3000000496', 'camilo.gomez@mno.com', 1, 16, 13); -- Coordinador de Servicio al Cliente
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Gabriela', 'Ríos', '0000000497', TO_DATE('1991-10-29', 'YYYY-MM-DD'), '3000000497', 'gabriela.rios@mno.com', 1, 16, 14); -- Nutricionista
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Felipe', 'Cruz', '0000000498', TO_DATE('1994-03-12', 'YYYY-MM-DD'), '3000000498', 'felipe.cruz@mno.com', 1, 16, 15); -- Asesor de Suplementación
-- Gerentes y Contador
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Daniela', 'Salazar', '0000000499', TO_DATE('1988-01-29', 'YYYY-MM-DD'), '3000000499', 'daniela.salazar@mno.com', 1, 16, 22); -- Gerente de Sede
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Alejandro', 'Valencia', '0000000500', TO_DATE('1986-04-20', 'YYYY-MM-DD'), '3000000500', 'alejandro.valencia@mno.com', 1, 16, 23); -- Contador
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Natalia', 'Paniagua', '0000000501', TO_DATE('1992-11-05', 'YYYY-MM-DD'), '3000000501', 'natalia.paniagua@mno.com', 1, 16, 24); -- Asistente Administrativo

--sede 18

-- Entrenadores y Personal de Entrenamiento
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Ana', 'Gómez', '0000000502', TO_DATE('1985-04-15', 'YYYY-MM-DD'), '3000000502', 'ana.gomez@nop.com', 1, 18, 1); -- Entrenador Personal
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Rogelio', 'Gómez', '0000000503', TO_DATE('1986-04-16', 'YYYY-MM-DD'), '3000000503', 'roge.gomez@nop.com', 1, 18, 1); -- Entrenador Personal
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Luis', 'Pérez', '0000000504', TO_DATE('1983-08-22', 'YYYY-MM-DD'), '3000000504', 'luis.perez@nop.com', 1, 18, 2); -- Instructor de Clases Grupales
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Carlos', 'Morales', '0000000505', TO_DATE('1987-11-30', 'YYYY-MM-DD'), '3000000505', 'carlos.morales@nop.com', 1, 18, 3); -- Coordinador de Entrenamiento
-- Mantenimiento y Atención al Cliente
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Andrés', 'Pineda', '0000000506', TO_DATE('1981-01-12', 'YYYY-MM-DD'), '3000000506', 'andres.pineda@nop.com', 1, 18, 9); -- Operario de Mantenimiento
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Ruperto', 'Pineda', '0000000507', TO_DATE('1981-01-13', 'YYYY-MM-DD'), '3000000507', 'ruperto.pineda@nop.com', 1, 18, 11); -- Auxiliar de Servicios Generales
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Juan', 'Sánchez', '0000000508', TO_DATE('1990-05-19', 'YYYY-MM-DD'), '3000000508', 'juan.sanchez@nop.com', 1, 18, 11); -- Auxiliar de Servicios Generales
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Isabel', 'Díaz', '0000000509', TO_DATE('1995-09-23', 'YYYY-MM-DD'), '3000000509', 'isabel.diaz@nop.com', 1, 18, 10); -- Jefe de Mantenimiento
-- Atención al Cliente y Nutrición
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Valeria', 'Moreno', '0000000510', TO_DATE('1988-11-11', 'YYYY-MM-DD'), '3000000510', 'valeria.moreno@nop.com', 1, 18, 12); -- Auxiliar de Atención al Cliente
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Camilo', 'Gómez', '0000000511', TO_DATE('1987-04-20', 'YYYY-MM-DD'), '3000000511', 'camilo.gomez@nop.com', 1, 18, 13); -- Coordinador de Servicio al Cliente
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Gabriela', 'Ríos', '0000000512', TO_DATE('1991-10-29', 'YYYY-MM-DD'), '3000000512', 'gabriela.rios@nop.com', 1, 18, 14); -- Nutricionista
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Felipe', 'Cruz', '0000000513', TO_DATE('1994-03-12', 'YYYY-MM-DD'), '3000000513', 'felipe.cruz@nop.com', 1, 18, 15); -- Asesor de Suplementación
-- Gerentes y Contador
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Daniela', 'Salazar', '0000000514', TO_DATE('1988-01-29', 'YYYY-MM-DD'), '3000000514', 'daniela.salazar@nop.com', 1, 18, 22); -- Gerente de Sede
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Alejandro', 'Valencia', '0000000515', TO_DATE('1986-04-20', 'YYYY-MM-DD'), '3000000515', 'alejandro.valencia@nop.com', 1, 18, 23); -- Contador
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Natalia', 'Paniagua', '0000000516', TO_DATE('1992-11-05', 'YYYY-MM-DD'), '3000000516', 'natalia.paniagua@nop.com', 1, 18, 24); -- Asistente Administrativo

--sede 20

-- Entrenadores y Personal de Entrenamiento
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Ana', 'Gómez', '0000000517', TO_DATE('1985-04-15', 'YYYY-MM-DD'), '3000000517', 'ana.gomez@opq.com', 1, 20, 1); -- Entrenador Personal
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Rogelio', 'Gómez', '0000000518', TO_DATE('1986-04-16', 'YYYY-MM-DD'), '3000000518', 'roge.gomez@opq.com', 1, 20, 1); -- Entrenador Personal
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Luis', 'Pérez', '0000000519', TO_DATE('1983-08-22', 'YYYY-MM-DD'), '3000000519', 'luis.perez@opq.com', 1, 20, 2); -- Instructor de Clases Grupales
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Carlos', 'Morales', '0000000520', TO_DATE('1987-11-30', 'YYYY-MM-DD'), '3000000520', 'carlos.morales@opq.com', 1, 20, 3); -- Coordinador de Entrenamiento
-- Mantenimiento y Atención al Cliente
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Andrés', 'Pineda', '0000000521', TO_DATE('1981-01-12', 'YYYY-MM-DD'), '3000000521', 'andres.pineda@opq.com', 1, 20, 9); -- Operario de Mantenimiento
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Ruperto', 'Pineda', '0000000522', TO_DATE('1981-01-13', 'YYYY-MM-DD'), '3000000522', 'ruperto.pineda@opq.com', 1, 20, 11); -- Auxiliar de Servicios Generales
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Juan', 'Sánchez', '0000000523', TO_DATE('1990-05-19', 'YYYY-MM-DD'), '3000000523', 'juan.sanchez@opq.com', 1, 20, 11); -- Auxiliar de Servicios Generales
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Isabel', 'Díaz', '0000000524', TO_DATE('1995-09-23', 'YYYY-MM-DD'), '3000000524', 'isabel.diaz@opq.com', 1, 20, 10); -- Jefe de Mantenimiento
-- Atención al Cliente y Nutrición
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Valeria', 'Moreno', '0000000525', TO_DATE('1988-11-11', 'YYYY-MM-DD'), '3000000525', 'valeria.moreno@opq.com', 1, 20, 12); -- Auxiliar de Atención al Cliente
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Camilo', 'Gómez', '0000000526', TO_DATE('1987-04-20', 'YYYY-MM-DD'), '3000000526', 'camilo.gomez@opq.com', 1, 20, 13); -- Coordinador de Servicio al Cliente
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Gabriela', 'Ríos', '0000000527', TO_DATE('1991-10-29', 'YYYY-MM-DD'), '3000000527', 'gabriela.rios@opq.com', 1, 20, 14); -- Nutricionista
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Felipe', 'Cruz', '0000000528', TO_DATE('1994-03-12', 'YYYY-MM-DD'), '3000000528', 'felipe.cruz@opq.com', 1, 20, 15); -- Asesor de Suplementación
-- Gerentes y Contador
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Daniela', 'Salazar', '0000000529', TO_DATE('1988-01-29', 'YYYY-MM-DD'), '3000000529', 'daniela.salazar@opq.com', 1, 20, 22); -- Gerente de Sede
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Alejandro', 'Valencia', '0000000530', TO_DATE('1986-04-20', 'YYYY-MM-DD'), '3000000530', 'alejandro.valencia@opq.com', 1, 20, 23); -- Contador
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Natalia', 'Paniagua', '0000000531', TO_DATE('1992-11-05', 'YYYY-MM-DD'), '3000000531', 'natalia.paniagua@opq.com', 1, 20, 24); -- Asistente Administrativo

--sede 21

-- Entrenadores y Personal de Entrenamiento
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Ana', 'Gómez', '0000000532', TO_DATE('1985-04-15', 'YYYY-MM-DD'), '3000000532', 'ana.gomez@pqr.com', 1, 21, 1); -- Entrenador Personal
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Rogelio', 'Gómez', '0000000533', TO_DATE('1986-04-16', 'YYYY-MM-DD'), '3000000533', 'roge.gomez@pqr.com', 1, 21, 1); -- Entrenador Personal
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Luis', 'Pérez', '0000000534', TO_DATE('1983-08-22', 'YYYY-MM-DD'), '3000000534', 'luis.perez@pqr.com', 1, 21, 2); -- Instructor de Clases Grupales
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Carlos', 'Morales', '0000000535', TO_DATE('1987-11-30', 'YYYY-MM-DD'), '3000000535', 'carlos.morales@pqr.com', 1, 21, 3); -- Coordinador de Entrenamiento
-- Mantenimiento y Atención al Cliente
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Andrés', 'Pineda', '0000000536', TO_DATE('1981-01-12', 'YYYY-MM-DD'), '3000000536', 'andres.pineda@pqr.com', 1, 21, 9); -- Operario de Mantenimiento
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Ruperto', 'Pineda', '0000000537', TO_DATE('1981-01-13', 'YYYY-MM-DD'), '3000000537', 'ruperto.pineda@pqr.com', 1, 21, 11); -- Auxiliar de Servicios Generales
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Juan', 'Sánchez', '0000000538', TO_DATE('1990-05-19', 'YYYY-MM-DD'), '3000000538', 'juan.sanchez@pqr.com', 1, 21, 11); -- Auxiliar de Servicios Generales
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Isabel', 'Díaz', '0000000539', TO_DATE('1995-09-23', 'YYYY-MM-DD'), '3000000539', 'isabel.diaz@pqr.com', 1, 21, 10); -- Jefe de Mantenimiento
-- Atención al Cliente y Nutrición
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Valeria', 'Moreno', '0000000540', TO_DATE('1988-11-11', 'YYYY-MM-DD'), '3000000540', 'valeria.moreno@pqr.com', 1, 21, 12); -- Auxiliar de Atención al Cliente
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Camilo', 'Gómez', '0000000541', TO_DATE('1987-04-20', 'YYYY-MM-DD'), '3000000541', 'camilo.gomez@pqr.com', 1, 21, 13); -- Coordinador de Servicio al Cliente
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Gabriela', 'Ríos', '0000000542', TO_DATE('1991-10-29', 'YYYY-MM-DD'), '3000000542', 'gabriela.rios@pqr.com', 1, 21, 14); -- Nutricionista
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Felipe', 'Cruz', '0000000543', TO_DATE('1994-03-12', 'YYYY-MM-DD'), '3000000543', 'felipe.cruz@pqr.com', 1, 21, 15); -- Asesor de Suplementación
-- Gerentes y Contador
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Daniela', 'Salazar', '0000000544', TO_DATE('1988-01-29', 'YYYY-MM-DD'), '3000000544', 'daniela.salazar@pqr.com', 1, 21, 22); -- Gerente de Sede
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Alejandro', 'Valencia', '0000000545', TO_DATE('1986-04-20', 'YYYY-MM-DD'), '3000000545', 'alejandro.valencia@pqr.com', 1, 21, 23); -- Contador
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Natalia', 'Paniagua', '0000000546', TO_DATE('1992-11-05', 'YYYY-MM-DD'), '3000000546', 'natalia.paniagua@pqr.com', 1, 21, 24); -- Asistente Administrativo

--sede 24

-- Entrenadores y Personal de Entrenamiento
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Ana', 'Gómez', '0000000547', TO_DATE('1985-04-15', 'YYYY-MM-DD'), '3000000547', 'ana.gomez@qrs.com', 1, 24, 1); -- Entrenador Personal
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Rogelio', 'Gómez', '0000000548', TO_DATE('1986-04-16', 'YYYY-MM-DD'), '3000000548', 'roge.gomez@qrs.com', 1, 24, 1); -- Entrenador Personal
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Luis', 'Pérez', '0000000549', TO_DATE('1983-08-22', 'YYYY-MM-DD'), '3000000549', 'luis.perez@qrs.com', 1, 24, 2); -- Instructor de Clases Grupales
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Carlos', 'Morales', '0000000550', TO_DATE('1987-11-30', 'YYYY-MM-DD'), '3000000550', 'carlos.morales@qrs.com', 1, 24, 3); -- Coordinador de Entrenamiento
-- Mantenimiento y Atención al Cliente
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Andrés', 'Pineda', '0000000551', TO_DATE('1981-01-12', 'YYYY-MM-DD'), '3000000551', 'andres.pineda@qrs.com', 1, 24, 9); -- Operario de Mantenimiento
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Ruperto', 'Pineda', '0000000552', TO_DATE('1981-01-13', 'YYYY-MM-DD'), '3000000552', 'ruperto.pineda@qrs.com', 1, 24, 11); -- Auxiliar de Servicios Generales
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Juan', 'Sánchez', '0000000553', TO_DATE('1990-05-19', 'YYYY-MM-DD'), '3000000553', 'juan.sanchez@qrs.com', 1, 24, 11); -- Auxiliar de Servicios Generales
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Isabel', 'Díaz', '0000000554', TO_DATE('1995-09-23', 'YYYY-MM-DD'), '3000000554', 'isabel.diaz@qrs.com', 1, 24, 10); -- Jefe de Mantenimiento
-- Atención al Cliente y Nutrición
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Valeria', 'Moreno', '0000000555', TO_DATE('1988-11-11', 'YYYY-MM-DD'), '3000000555', 'valeria.moreno@qrs.com', 1, 24, 12); -- Auxiliar de Atención al Cliente
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Camilo', 'Gómez', '0000000556', TO_DATE('1987-04-20', 'YYYY-MM-DD'), '3000000556', 'camilo.gomez@qrs.com', 1, 24, 13); -- Coordinador de Servicio al Cliente
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Gabriela', 'Ríos', '0000000557', TO_DATE('1991-10-29', 'YYYY-MM-DD'), '3000000557', 'gabriela.rios@qrs.com', 1, 24, 14); -- Nutricionista
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Felipe', 'Cruz', '0000000558', TO_DATE('1994-03-12', 'YYYY-MM-DD'), '3000000558', 'felipe.cruz@qrs.com', 1, 24, 15); -- Asesor de Suplementación
-- Gerentes y Contador
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Daniela', 'Salazar', '0000000559', TO_DATE('1988-01-29', 'YYYY-MM-DD'), '3000000559', 'daniela.salazar@qrs.com', 1, 24, 22); -- Gerente de Sede
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Alejandro', 'Valencia', '0000000560', TO_DATE('1986-04-20', 'YYYY-MM-DD'), '3000000560', 'alejandro.valencia@qrs.com', 1, 24, 23); -- Contador
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Natalia', 'Paniagua', '0000000561', TO_DATE('1992-11-05', 'YYYY-MM-DD'), '3000000561', 'natalia.paniagua@qrs.com', 1, 24, 24); -- Asistente Administrativo

--sede 26

-- Entrenadores y Personal de Entrenamiento
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Ana', 'Gómez', '0000000562', TO_DATE('1985-04-15', 'YYYY-MM-DD'), '3000000562', 'ana.gomez@rst.com', 1, 26, 1); -- Entrenador Personal
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Rogelio', 'Gómez', '0000000563', TO_DATE('1986-04-16', 'YYYY-MM-DD'), '3000000563', 'roge.gomez@rst.com', 1, 26, 1); -- Entrenador Personal
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Luis', 'Pérez', '0000000564', TO_DATE('1983-08-22', 'YYYY-MM-DD'), '3000000564', 'luis.perez@rst.com', 1, 26, 2); -- Instructor de Clases Grupales
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Carlos', 'Morales', '0000000565', TO_DATE('1987-11-30', 'YYYY-MM-DD'), '3000000565', 'carlos.morales@rst.com', 1, 26, 3); -- Coordinador de Entrenamiento
-- Mantenimiento y Atención al Cliente
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Andrés', 'Pineda', '0000000566', TO_DATE('1981-01-12', 'YYYY-MM-DD'), '3000000566', 'andres.pineda@rst.com', 1, 26, 9); -- Operario de Mantenimiento
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Ruperto', 'Pineda', '0000000567', TO_DATE('1981-01-13', 'YYYY-MM-DD'), '3000000567', 'ruperto.pineda@rst.com', 1, 26, 11); -- Auxiliar de Servicios Generales
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Juan', 'Sánchez', '0000000568', TO_DATE('1990-05-19', 'YYYY-MM-DD'), '3000000568', 'juan.sanchez@rst.com', 1, 26, 11); -- Auxiliar de Servicios Generales
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Isabel', 'Díaz', '0000000569', TO_DATE('1995-09-23', 'YYYY-MM-DD'), '3000000569', 'isabel.diaz@rst.com', 1, 26, 10); -- Jefe de Mantenimiento
-- Atención al Cliente y Nutrición
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Valeria', 'Moreno', '0000000570', TO_DATE('1988-11-11', 'YYYY-MM-DD'), '3000000570', 'valeria.moreno@rst.com', 1, 26, 12); -- Auxiliar de Atención al Cliente
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Camilo', 'Gómez', '0000000571', TO_DATE('1987-04-20', 'YYYY-MM-DD'), '3000000571', 'camilo.gomez@rst.com', 1, 26, 13); -- Coordinador de Servicio al Cliente
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Gabriela', 'Ríos', '0000000572', TO_DATE('1991-10-29', 'YYYY-MM-DD'), '3000000572', 'gabriela.rios@rst.com', 1, 26, 14); -- Nutricionista
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Felipe', 'Cruz', '0000000573', TO_DATE('1994-03-12', 'YYYY-MM-DD'), '3000000573', 'felipe.cruz@rst.com', 1, 26, 15); -- Asesor de Suplementación
-- Gerentes y Contador
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Daniela', 'Salazar', '0000000574', TO_DATE('1988-01-29', 'YYYY-MM-DD'), '3000000574', 'daniela.salazar@rst.com', 1, 26, 22); -- Gerente de Sede
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Alejandro', 'Valencia', '0000000575', TO_DATE('1986-04-20', 'YYYY-MM-DD'), '3000000575', 'alejandro.valencia@rst.com', 1, 26, 23); -- Contador
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Natalia', 'Paniagua', '0000000576', TO_DATE('1992-11-05', 'YYYY-MM-DD'), '3000000576', 'natalia.paniagua@rst.com', 1, 26, 24); -- Asistente Administrativo

--sede 27

-- Entrenadores y Personal de Entrenamiento
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Ana', 'Gómez', '0000000577', TO_DATE('1985-04-15', 'YYYY-MM-DD'), '3000000577', 'ana.gomez@stu.com', 1, 27, 1); -- Entrenador Personal
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Rogelio', 'Gómez', '0000000578', TO_DATE('1986-04-16', 'YYYY-MM-DD'), '3000000578', 'roge.gomez@stu.com', 1, 27, 1); -- Entrenador Personal
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Luis', 'Pérez', '0000000579', TO_DATE('1983-08-22', 'YYYY-MM-DD'), '3000000579', 'luis.perez@stu.com', 1, 27, 2); -- Instructor de Clases Grupales
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Carlos', 'Morales', '0000000580', TO_DATE('1987-11-30', 'YYYY-MM-DD'), '3000000580', 'carlos.morales@stu.com', 1, 27, 3); -- Coordinador de Entrenamiento
-- Mantenimiento y Atención al Cliente
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Andrés', 'Pineda', '0000000581', TO_DATE('1981-01-12', 'YYYY-MM-DD'), '3000000581', 'andres.pineda@stu.com', 1, 27, 9); -- Operario de Mantenimiento
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Ruperto', 'Pineda', '0000000582', TO_DATE('1981-01-13', 'YYYY-MM-DD'), '300000082', 'ruperto.pineda@stu.com', 1, 27, 11); -- Auxiliar de Servicios Generales
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Juan', 'Sánchez', '0000000583', TO_DATE('1990-05-19', 'YYYY-MM-DD'), '3000000583', 'juan.sanchez@stu.com', 1, 27, 11); -- Auxiliar de Servicios Generales
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Isabel', 'Díaz', '0000000584', TO_DATE('1995-09-23', 'YYYY-MM-DD'), '3000000584', 'isabel.diaz@stu.com', 1, 27, 10); -- Jefe de Mantenimiento
-- Atención al Cliente y Nutrición
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Valeria', 'Moreno', '0000000585', TO_DATE('1988-11-11', 'YYYY-MM-DD'), '3000000585', 'valeria.moreno@stu.com', 1, 27, 12); -- Auxiliar de Atención al Cliente
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Camilo', 'Gómez', '0000000586', TO_DATE('1987-04-20', 'YYYY-MM-DD'), '3000000586', 'camilo.gomez@stu.com', 1, 27, 13); -- Coordinador de Servicio al Cliente
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Gabriela', 'Ríos', '0000000587', TO_DATE('1991-10-29', 'YYYY-MM-DD'), '3000000587', 'gabriela.rios@stu.com', 1, 27, 14); -- Nutricionista
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Felipe', 'Cruz', '0000000588', TO_DATE('1994-03-12', 'YYYY-MM-DD'), '3000000588', 'felipe.cruz@stu.com', 1, 27, 15); -- Asesor de Suplementación
-- Gerentes y Contador
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Daniela', 'Salazar', '0000000589', TO_DATE('1988-01-29', 'YYYY-MM-DD'), '3000000589', 'daniela.salazar@stu.com', 1, 27, 22); -- Gerente de Sede
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Alejandro', 'Valencia', '0000000590', TO_DATE('1986-04-20', 'YYYY-MM-DD'), '3000000590', 'alejandro.valencia@stu.com', 1, 27, 23); -- Contador
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Natalia', 'Paniagua', '0000000591', TO_DATE('1992-11-05', 'YYYY-MM-DD'), '3000000591', 'natalia.paniagua@stu.com', 1, 27, 24); -- Asistente Administrativo

--sede 29

-- Entrenadores y Personal de Entrenamiento
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Ana', 'Gómez', '0000000592', TO_DATE('1985-04-15', 'YYYY-MM-DD'), '3000000592', 'ana.gomez@tuv.com', 1, 29, 1); -- Entrenador Personal
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Rogelio', 'Gómez', '0000000593', TO_DATE('1986-04-16', 'YYYY-MM-DD'), '3000000593', 'roge.gomez@tuv.com', 1, 29, 1); -- Entrenador Personal
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Luis', 'Pérez', '0000000594', TO_DATE('1983-08-22', 'YYYY-MM-DD'), '3000000594', 'luis.perez@tuv.com', 1, 29, 2); -- Instructor de Clases Grupales
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Carlos', 'Morales', '0000000595', TO_DATE('1987-11-30', 'YYYY-MM-DD'), '3000000595', 'carlos.morales@tuv.com', 1, 29, 3); -- Coordinador de Entrenamiento
-- Mantenimiento y Atención al Cliente
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Andrés', 'Pineda', '0000000596', TO_DATE('1981-01-12', 'YYYY-MM-DD'), '3000000596', 'andres.pineda@tuv.com', 1, 29, 9); -- Operario de Mantenimiento
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Ruperto', 'Pineda', '0000000597', TO_DATE('1981-01-13', 'YYYY-MM-DD'), '3000000597', 'ruperto.pineda@tuv.com', 1, 29, 11); -- Auxiliar de Servicios Generales
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Juan', 'Sánchez', '0000000598', TO_DATE('1990-05-19', 'YYYY-MM-DD'), '3000000598', 'juan.sanchez@tuv.com', 1, 29, 11); -- Auxiliar de Servicios Generales
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Isabel', 'Díaz', '0000000599', TO_DATE('1995-09-23', 'YYYY-MM-DD'), '3000000599', 'isabel.diaz@tuv.com', 1, 29, 10); -- Jefe de Mantenimiento
-- Atención al Cliente y Nutrición
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Valeria', 'Moreno', '0000000600', TO_DATE('1988-11-11', 'YYYY-MM-DD'), '3000000600', 'valeria.moreno@tuv.com', 1, 29, 12); -- Auxiliar de Atención al Cliente
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Camilo', 'Gómez', '0000000601', TO_DATE('1987-04-20', 'YYYY-MM-DD'), '3000000601', 'camilo.gomez@tuv.com', 1, 29, 13); -- Coordinador de Servicio al Cliente
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Gabriela', 'Ríos', '0000000602', TO_DATE('1991-10-29', 'YYYY-MM-DD'), '3000000602', 'gabriela.rios@tuv.com', 1, 29, 14); -- Nutricionista
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Felipe', 'Cruz', '0000000603', TO_DATE('1994-03-12', 'YYYY-MM-DD'), '3000000603', 'felipe.cruz@tuv.com', 1, 29, 15); -- Asesor de Suplementación
-- Gerentes y Contador
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Daniela', 'Salazar', '0000000604', TO_DATE('1988-01-29', 'YYYY-MM-DD'), '3000000604', 'daniela.salazar@tuv.com', 1, 29, 22); -- Gerente de Sede
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Alejandro', 'Valencia', '0000000605', TO_DATE('1986-04-20', 'YYYY-MM-DD'), '3000000605', 'alejandro.valencia@tuv.com', 1, 29, 23); -- Contador
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Natalia', 'Paniagua', '0000000606', TO_DATE('1992-11-05', 'YYYY-MM-DD'), '3000000606', 'natalia.paniagua@tuv.com', 1, 29, 24); -- Asistente Administrativo

--sede 30

-- Entrenadores y Personal de Entrenamiento
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Ana', 'Gómez', '0000000607', TO_DATE('1985-04-15', 'YYYY-MM-DD'), '3000000607', 'ana.gomez@tuv.com', 1, 30, 1); -- Entrenador Personal
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Rogelio', 'Gómez', '0000000608', TO_DATE('1986-04-16', 'YYYY-MM-DD'), '3000000608', 'roge.gomez@tuv.com', 1, 30, 1); -- Entrenador Personal
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Luis', 'Pérez', '0000000609', TO_DATE('1983-08-22', 'YYYY-MM-DD'), '3000000609', 'luis.perez@tuv.com', 1, 30, 2); -- Instructor de Clases Grupales
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Carlos', 'Morales', '0000000610', TO_DATE('1987-11-30', 'YYYY-MM-DD'), '3000000610', 'carlos.morales@tuv.com', 1, 30, 3); -- Coordinador de Entrenamiento
-- Mantenimiento y Atención al Cliente
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Andrés', 'Pineda', '0000000611', TO_DATE('1981-01-12', 'YYYY-MM-DD'), '3000000611', 'andres.pineda@tuv.com', 1, 30, 9); -- Operario de Mantenimiento
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Ruperto', 'Pineda', '0000000612', TO_DATE('1981-01-13', 'YYYY-MM-DD'), '3000000612', 'ruperto.pineda@tuv.com', 1, 30, 11); -- Auxiliar de Servicios Generales
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Juan', 'Sánchez', '0000000613', TO_DATE('1990-05-19', 'YYYY-MM-DD'), '3000000613', 'juan.sanchez@tuv.com', 1, 30, 11); -- Auxiliar de Servicios Generales
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Isabel', 'Díaz', '0000000614', TO_DATE('1995-09-23', 'YYYY-MM-DD'), '3000000614', 'isabel.diaz@tuv.com', 1, 30, 10); -- Jefe de Mantenimiento
-- Atención al Cliente y Nutrición
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Valeria', 'Moreno', '0000000615', TO_DATE('1988-11-11', 'YYYY-MM-DD'), '3000000615', 'valeria.moreno@tuv.com', 1, 30, 12); -- Auxiliar de Atención al Cliente
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Camilo', 'Gómez', '0000000616', TO_DATE('1987-04-20', 'YYYY-MM-DD'), '3000000616', 'camilo.gomez@tuv.com', 1, 30, 13); -- Coordinador de Servicio al Cliente
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Gabriela', 'Ríos', '0000000617', TO_DATE('1991-10-29', 'YYYY-MM-DD'), '3000000617', 'gabriela.rios@tuv.com', 1, 30, 14); -- Nutricionista
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Felipe', 'Cruz', '0000000618', TO_DATE('1994-03-12', 'YYYY-MM-DD'), '3000000618', 'felipe.cruz@tuv.com', 1, 30, 15); -- Asesor de Suplementación
-- Gerentes y Contador
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Daniela', 'Salazar', '0000000619', TO_DATE('1988-01-29', 'YYYY-MM-DD'), '3000000619', 'daniela.salazar@tuv.com', 1, 30, 22); -- Gerente de Sede
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Alejandro', 'Valencia', '0000000620', TO_DATE('1986-04-20', 'YYYY-MM-DD'), '3000000620', 'alejandro.valencia@tuv.com', 1, 30, 23); -- Contador
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Natalia', 'Paniagua', '0000000621', TO_DATE('1992-11-05', 'YYYY-MM-DD'), '3000000621', 'natalia.paniagua@tuv.com', 1, 30, 24); -- Asistente Administrativo


-----------------------------------------------------

-----------------------------------------------------
--Clientes

--Seguir incrementando número de dni en el orden que va
--Seguir incrementando telefono en el orden que va
--los dominios de los correos van así: @az.com, @bz.com, @cz.com -> continuar el patrón
--Hacer los clientes para las 30 sedes

-- Clientes sede 1

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES 
('Carlos', 'Gómez', '0000000622', TO_DATE('1985-05-20', 'YYYY-MM-DD'), '3000000622', 'carlos.gomez1@az.com', TO_DATE('2024-09-30', 'YYYY-MM-DD'), 1, 1);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES 
('Laura', 'Martínez', '0000000623', TO_DATE('1990-07-12', 'YYYY-MM-DD'), '3000000623', 'laura.martinez1@az.com', TO_DATE('2024-10-15', 'YYYY-MM-DD'), 1, 2);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES 
('Andrés', 'Hernández', '0000000624', TO_DATE('1982-11-30', 'YYYY-MM-DD'), '3000000624', 'andres.hernandez1@az.com', TO_DATE('2024-11-20', 'YYYY-MM-DD'), 1, 3);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES 
('Sofia', 'Jiménez', '0000000625', TO_DATE('1987-02-25', 'YYYY-MM-DD'), '3000000625', 'sofia.jimenez1@az.com', TO_DATE('2024-12-05', 'YYYY-MM-DD'), 1, 4);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES 
('Juan', 'Pérez', '0000000626', TO_DATE('1995-09-14', 'YYYY-MM-DD'), '3000000626', 'juan.perez1@az.com', TO_DATE('2025-01-10', 'YYYY-MM-DD'), 1, 5);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES 
('Ana', 'Torres', '0000000627', TO_DATE('1992-04-21', 'YYYY-MM-DD'), '3000000627', 'ana.torres1@az.com', TO_DATE('2025-02-28', 'YYYY-MM-DD'), 1, 6);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES 
('Luis', 'Fernández', '0000000628', TO_DATE('1988-08-15', 'YYYY-MM-DD'), '3000000628', 'luis.fernandez1@az.com', TO_DATE('2025-03-22', 'YYYY-MM-DD'), 1, 7);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES 
('Valeria', 'Castro', '0000000629', TO_DATE('1991-12-03', 'YYYY-MM-DD'), '3000000629', 'valeria.castro1@az.com', TO_DATE('2025-04-10', 'YYYY-MM-DD'), 1, 8);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES 
('Felipe', 'Moreno', '0000000630', TO_DATE('1994-06-17', 'YYYY-MM-DD'), '3000000630', 'felipe.moreno1@az.com', TO_DATE('2025-05-18', 'YYYY-MM-DD'), 1, 9);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES 
('Camila', 'Ramos', '0000000631', TO_DATE('1986-10-10', 'YYYY-MM-DD'), '3000000631', 'camila.ramos1@az.com', TO_DATE('2025-06-25', 'YYYY-MM-DD'), 1, 10);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES
('Jose', 'Martinez', '0000000650', TO_DATE('1997-08-07', 'YYYY-MM-DD'), '3000000650', 'jose.martinez0650@service.com', TO_DATE('2025-12-22', 'YYYY-MM-DD'), 1, 2);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES
('Felipe', 'Rodriguez', '0000000651', TO_DATE('2002-12-05', 'YYYY-MM-DD'), '3000000651', 'felipe.rodriguez0651@mail.com', TO_DATE('2025-07-03', 'YYYY-MM-DD'), 1, 8);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES
('Daniela', 'Gomez', '0000000652', TO_DATE('1996-03-28', 'YYYY-MM-DD'), '3000000652', 'daniela.gomez0652@service.com', TO_DATE('2025-11-03', 'YYYY-MM-DD'), 1, 8);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES
('Camila', 'Fernandez', '0000000653', TO_DATE('2003-04-21', 'YYYY-MM-DD'), '3000000653', 'camila.fernandez0653@bz.com', TO_DATE('2026-09-27', 'YYYY-MM-DD'), 1, 8);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES
('Felipe', 'Moreno', '0000000654', TO_DATE('2003-09-09', 'YYYY-MM-DD'), '3000000654', 'felipe.moreno0654@webmail.com', TO_DATE('2026-07-26', 'YYYY-MM-DD'), 1, 10);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES
('Felipe', 'Garcia', '0000000655', TO_DATE('1997-03-09', 'YYYY-MM-DD'), '3000000655', 'felipe.garcia0655@webmail.com', TO_DATE('2026-08-04', 'YYYY-MM-DD'), 1, 2);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES
('Juan', 'Gomez', '0000000656', TO_DATE('1997-09-07', 'YYYY-MM-DD'), '3000000656', 'juan.gomez0656@service.com', TO_DATE('2025-05-22', 'YYYY-MM-DD'), 1, 8);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES
('Felipe', 'Sanchez', '0000000657', TO_DATE('2004-01-03', 'YYYY-MM-DD'), '3000000657', 'felipe.sanchez0657@webmail.com', TO_DATE('2025-10-09', 'YYYY-MM-DD'), 1, 10);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES
('Camila', 'Fernandez', '0000000658', TO_DATE('1997-03-01', 'YYYY-MM-DD'), '3000000658', 'camila.fernandez0658@bz.com', TO_DATE('2026-05-27', 'YYYY-MM-DD'), 1, 2);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES
('Camila', 'Fernandez', '0000000659', TO_DATE('1995-07-30', 'YYYY-MM-DD'), '3000000659', 'camila.fernandez0659@mail.com', TO_DATE('2026-09-18', 'YYYY-MM-DD'), 1, 8);


-- Clientes sede 2

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES 
('Carlos', 'Gómez', '0000000632', TO_DATE('1985-05-20', 'YYYY-MM-DD'), '3000000632', 'carlos.gomez2@bz.com', TO_DATE('2024-09-30', 'YYYY-MM-DD'), 2, 1);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES 
('Laura', 'Martínez', '0000000633', TO_DATE('1990-07-12', 'YYYY-MM-DD'), '3000000633', 'laura.martinez2@bz.com', TO_DATE('2024-10-15', 'YYYY-MM-DD'), 2, 2);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES 
('Andrés', 'Hernández', '0000000634', TO_DATE('1982-11-30', 'YYYY-MM-DD'), '3000000634', 'andres.hernandez2@bz.com', TO_DATE('2024-11-20', 'YYYY-MM-DD'), 2, 3);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES 
('Sofia', 'Jiménez', '0000000635', TO_DATE('1987-02-25', 'YYYY-MM-DD'), '3000000635', 'sofia.jimenez2@bz.com', TO_DATE('2024-12-05', 'YYYY-MM-DD'), 2, 4);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES 
('Juan', 'Pérez', '0000000636', TO_DATE('1995-09-14', 'YYYY-MM-DD'), '3000000636', 'juan.perez2@bz.com', TO_DATE('2025-01-10', 'YYYY-MM-DD'), 2, 5);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES 
('Ana', 'Torres', '0000000637', TO_DATE('1992-04-21', 'YYYY-MM-DD'), '3000000637', 'ana.torres2@bz.com', TO_DATE('2025-02-28', 'YYYY-MM-DD'), 2, 6);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES 
('Luis', 'Fernández', '0000000638', TO_DATE('1988-08-15', 'YYYY-MM-DD'), '3000000638', 'luis.fernandez2@bz.com', TO_DATE('2025-03-22', 'YYYY-MM-DD'), 2, 7);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES 
('Valeria', 'Castro', '0000000639', TO_DATE('1991-12-03', 'YYYY-MM-DD'), '3000000639', 'valeria.castro2@bz.com', TO_DATE('2025-04-10', 'YYYY-MM-DD'), 2, 8);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES 
('Felipe', 'Moreno', '0000000640', TO_DATE('1994-06-17', 'YYYY-MM-DD'), '3000000640', 'felipe.moreno2@bz.com', TO_DATE('2025-05-18', 'YYYY-MM-DD'), 2, 9);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES
('Laura', 'Pérez', '0000000660', TO_DATE('1999-10-02', 'YYYY-MM-DD'), '3000000660', 'laura.pérez0660@mail.com', TO_DATE('2025-08-07', 'YYYY-MM-DD'), 2, 6);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES
('Felipe', 'Torres', '0000000661', TO_DATE('1999-09-01', 'YYYY-MM-DD'), '3000000661', 'felipe.torres0661@bz.com', TO_DATE('2026-10-24', 'YYYY-MM-DD'), 2, 2);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES
('Daniela', 'Martinez', '0000000662', TO_DATE('1994-09-24', 'YYYY-MM-DD'), '3000000662', 'daniela.martinez0662@service.com', TO_DATE('2026-08-03', 'YYYY-MM-DD'), 2, 3);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES
('Juan', 'Rodriguez', '0000000663', TO_DATE('2002-03-01', 'YYYY-MM-DD'), '3000000663', 'juan.rodriguez0663@mail.com', TO_DATE('2026-03-18', 'YYYY-MM-DD'), 2, 7);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES
('Sofia', 'Gomez', '0000000664', TO_DATE('2002-11-02', 'YYYY-MM-DD'), '3000000664', 'sofia.gomez0664@webmail.com', TO_DATE('2025-10-04', 'YYYY-MM-DD'), 2, 5);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES
('Mariana', 'Martinez', '0000000665', TO_DATE('1994-09-02', 'YYYY-MM-DD'), '3000000665', 'mariana.martinez0665@service.com', TO_DATE('2026-03-22', 'YYYY-MM-DD'), 2, 10);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES
('Sofia', 'Garcia', '0000000666', TO_DATE('1995-11-21', 'YYYY-MM-DD'), '3000000666', 'sofia.garcia0666@webmail.com', TO_DATE('2026-07-30', 'YYYY-MM-DD'), 2, 9);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES
('Camila', 'Pérez', '0000000667', TO_DATE('1998-03-19', 'YYYY-MM-DD'), '3000000667', 'camila.pérez0667@webmail.com', TO_DATE('2026-03-18', 'YYYY-MM-DD'), 2, 4);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES
('Felipe', 'Martinez', '0000000668', TO_DATE('1997-06-17', 'YYYY-MM-DD'), '3000000668', 'felipe.martinez0668@service.com', TO_DATE('2025-09-11', 'YYYY-MM-DD'), 2, 8);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES
('Daniela', 'Martinez', '0000000669', TO_DATE('1994-09-19', 'YYYY-MM-DD'), '3000000669', 'daniela.martinez0669@bz.com', TO_DATE('2025-12-14', 'YYYY-MM-DD'), 2, 2);

-- Clientes sede 3

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES 
('Carlos', 'Gómez', '0000000641', TO_DATE('1985-05-20', 'YYYY-MM-DD'), '3000000641', 'carlos.gomez3@cz.com', TO_DATE('2024-09-30', 'YYYY-MM-DD'), 3, 1);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES 
('Laura', 'Martínez', '0000000642', TO_DATE('1990-07-12', 'YYYY-MM-DD'), '3000000642', 'laura.martinez3@cz.com', TO_DATE('2024-10-15', 'YYYY-MM-DD'), 3, 2);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES 
('Andrés', 'Hernández', '0000000643', TO_DATE('1982-11-30', 'YYYY-MM-DD'), '3000000643', 'andres.hernandez3@cz.com', TO_DATE('2024-11-20', 'YYYY-MM-DD'), 3, 3);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES 
('Sofia', 'Jiménez', '0000000644', TO_DATE('1987-02-25', 'YYYY-MM-DD'), '3000000644', 'sofia.jimenez3@cz.com', TO_DATE('2024-12-05', 'YYYY-MM-DD'), 3, 4);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES 
('Juan', 'Pérez', '0000000645', TO_DATE('1995-09-14', 'YYYY-MM-DD'), '3000000645', 'juan.perez3@cz.com', TO_DATE('2025-01-10', 'YYYY-MM-DD'), 3, 5);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES 
('Ana', 'Torres', '0000000646', TO_DATE('1992-04-21', 'YYYY-MM-DD'), '3000000646', 'ana.torres3@cz.com', TO_DATE('2025-02-28', 'YYYY-MM-DD'), 3, 6);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES 
('Luis', 'Fernández', '0000000647', TO_DATE('1988-08-15', 'YYYY-MM-DD'), '3000000647', 'luis.fernandez3@cz.com', TO_DATE('2025-03-22', 'YYYY-MM-DD'), 3, 7);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES 
('Valeria', 'Castro', '0000000648', TO_DATE('1991-12-03', 'YYYY-MM-DD'), '3000000648', 'valeria.castro3@cz.com', TO_DATE('2025-04-10', 'YYYY-MM-DD'), 3, 8);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES 
('Felipe', 'Moreno', '0000000649', TO_DATE('1994-06-17', 'YYYY-MM-DD'), '3000000649', 'felipe.moreno3@cz.com', TO_DATE('2025-05-18', 'YYYY-MM-DD'), 3, 9);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES 
('Camila', 'Ramos', '0000000650', TO_DATE('1986-10-10', 'YYYY-MM-DD'), '3000000650', 'camila.ramos3@cz.com', TO_DATE('2025-06-25', 'YYYY-MM-DD'), 3, 10);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES
('Sofia', 'Lopez', '0000000670', TO_DATE('2000-03-05', 'YYYY-MM-DD'), '3000000670', 'sofia.lopez0670@mail.com', TO_DATE('2026-12-13', 'YYYY-MM-DD'), 3, 2);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES
('Sofia', 'Rodriguez', '0000000671', TO_DATE('1994-12-17', 'YYYY-MM-DD'), '3000000671', 'sofia.rodriguez0671@bz.com', TO_DATE('2025-06-15', 'YYYY-MM-DD'), 3, 8);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES
('Camila', 'Moreno', '0000000672', TO_DATE('1995-10-11', 'YYYY-MM-DD'), '3000000672', 'camila.moreno0672@service.com', TO_DATE('2026-02-18', 'YYYY-MM-DD'), 3, 9);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES
('Felipe', 'Fernandez', '0000000673', TO_DATE('2005-06-30', 'YYYY-MM-DD'), '3000000673', 'felipe.fernandez0673@bz.com', TO_DATE('2025-10-01', 'YYYY-MM-DD'), 3, 6);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES
('Laura', 'Gomez', '0000000674', TO_DATE('2003-07-02', 'YYYY-MM-DD'), '3000000674', 'laura.gomez0674@mail.com', TO_DATE('2026-02-07', 'YYYY-MM-DD'), 3, 5);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES
('Juan', 'Garcia', '0000000675', TO_DATE('1997-02-19', 'YYYY-MM-DD'), '3000000675', 'juan.garcia0675@bz.com', TO_DATE('2026-12-27', 'YYYY-MM-DD'), 3, 4);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES
('Juan', 'Sanchez', '0000000676', TO_DATE('1999-09-03', 'YYYY-MM-DD'), '3000000676', 'juan.sanchez0676@webmail.com', TO_DATE('2025-07-11', 'YYYY-MM-DD'), 3, 5);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES
('Camila', 'Martinez', '0000000677', TO_DATE('2000-01-20', 'YYYY-MM-DD'), '3000000677', 'camila.martinez0677@webmail.com', TO_DATE('2026-01-14', 'YYYY-MM-DD'), 3, 3);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES
('Sofia', 'Torres', '0000000678', TO_DATE('1995-07-23', 'YYYY-MM-DD'), '3000000678', 'sofia.torres0678@webmail.com', TO_DATE('2026-08-15', 'YYYY-MM-DD'), 3, 3);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES
('Daniela', 'Pérez', '0000000679', TO_DATE('2000-12-08', 'YYYY-MM-DD'), '3000000679', 'daniela.pérez0679@webmail.com', TO_DATE('2026-12-06', 'YYYY-MM-DD'), 3, 7);

-- Cliente sede 4
INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES
('Jose', 'Pérez', '0000000680', TO_DATE('1996-04-18', 'YYYY-MM-DD'), '3000000680', 'jose.pérez0680@mail.com', TO_DATE('2026-11-28', 'YYYY-MM-DD'), 4, 7);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES
('Laura', 'Sanchez', '0000000681', TO_DATE('2000-12-10', 'YYYY-MM-DD'), '3000000681', 'laura.sanchez0681@mail.com', TO_DATE('2025-12-19', 'YYYY-MM-DD'), 4, 9);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES
('Juan', 'Garcia', '0000000682', TO_DATE('1999-09-29', 'YYYY-MM-DD'), '3000000682', 'juan.garcia0682@service.com', TO_DATE('2026-10-09', 'YYYY-MM-DD'), 4, 3);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES
('Carlos', 'Garcia', '0000000683', TO_DATE('1995-07-28', 'YYYY-MM-DD'), '3000000683', 'carlos.garcia0683@mail.com', TO_DATE('2026-10-02', 'YYYY-MM-DD'), 4, 8);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES
('Juan', 'Garcia', '0000000684', TO_DATE('1998-03-13', 'YYYY-MM-DD'), '3000000684', 'juan.garcia0684@webmail.com', TO_DATE('2026-12-03', 'YYYY-MM-DD'), 4, 10);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES
('Andres', 'Lopez', '0000000685', TO_DATE('1996-10-11', 'YYYY-MM-DD'), '3000000685', 'andres.lopez0685@mail.com', TO_DATE('2026-10-25', 'YYYY-MM-DD'), 4, 4);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES
('Jose', 'Rodriguez', '0000000686', TO_DATE('2002-03-17', 'YYYY-MM-DD'), '3000000686', 'jose.rodriguez0686@bz.com', TO_DATE('2025-11-17', 'YYYY-MM-DD'), 4, 3);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES
('Felipe', 'Torres', '0000000687', TO_DATE('1998-05-22', 'YYYY-MM-DD'), '3000000687', 'felipe.torres0687@bz.com', TO_DATE('2025-10-12', 'YYYY-MM-DD'), 4, 3);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES
('Felipe', 'Sanchez', '0000000688', TO_DATE('2003-05-29', 'YYYY-MM-DD'), '3000000688', 'felipe.sanchez0688@bz.com', TO_DATE('2026-03-09', 'YYYY-MM-DD'), 4, 9);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES
('Laura', 'Garcia', '0000000689', TO_DATE('2000-03-24', 'YYYY-MM-DD'), '3000000689', 'laura.garcia0689@webmail.com', TO_DATE('2026-12-10', 'YYYY-MM-DD'), 4, 8);

-- Cliente sede 5
INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES
('Jose', 'Garcia', '0000000690', TO_DATE('2001-09-29', 'YYYY-MM-DD'), '3000000690', 'jose.garcia0690@bz.com', TO_DATE('2026-08-06', 'YYYY-MM-DD'), 5, 10);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES
('Sofia', 'Martinez', '0000000691', TO_DATE('2003-09-14', 'YYYY-MM-DD'), '3000000691', 'sofia.martinez0691@service.com', TO_DATE('2026-12-24', 'YYYY-MM-DD'), 5, 8);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES
('Daniela', 'Pérez', '0000000692', TO_DATE('2001-02-11', 'YYYY-MM-DD'), '3000000692', 'daniela.pérez0692@webmail.com', TO_DATE('2025-09-02', 'YYYY-MM-DD'), 5, 7);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES
('Felipe', 'Gomez', '0000000693', TO_DATE('2004-10-25', 'YYYY-MM-DD'), '3000000693', 'felipe.gomez0693@mail.com', TO_DATE('2025-06-11', 'YYYY-MM-DD'), 5, 4);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES
('Juan', 'Gomez', '0000000694', TO_DATE('1996-02-22', 'YYYY-MM-DD'), '3000000694', 'juan.gomez0694@webmail.com', TO_DATE('2026-10-11', 'YYYY-MM-DD'), 5, 8);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES
('Andres', 'Martinez', '0000000695', TO_DATE('1998-04-16', 'YYYY-MM-DD'), '3000000695', 'andres.martinez0695@bz.com', TO_DATE('2026-05-17', 'YYYY-MM-DD'), 5, 7);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES
('Sofia', 'Fernandez', '0000000696', TO_DATE('1999-11-27', 'YYYY-MM-DD'), '3000000696', 'sofia.fernandez0696@service.com', TO_DATE('2026-02-03', 'YYYY-MM-DD'), 5, 2);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES
('Carlos', 'Rodriguez', '0000000697', TO_DATE('2005-10-28', 'YYYY-MM-DD'), '3000000697', 'carlos.rodriguez0697@service.com', TO_DATE('2026-08-12', 'YYYY-MM-DD'), 5, 9);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES
('Camila', 'Martinez', '0000000698', TO_DATE('2002-02-20', 'YYYY-MM-DD'), '3000000698', 'camila.martinez0698@service.com', TO_DATE('2026-04-16', 'YYYY-MM-DD'), 5, 7);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES
('Sofia', 'Torres', '0000000699', TO_DATE('2000-11-28', 'YYYY-MM-DD'), '3000000699', 'sofia.torres0699@webmail.com', TO_DATE('2025-10-20', 'YYYY-MM-DD'), 5, 7);

-- Cliente sede 6
INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES
('Jose', 'Fernandez', '0000000700', TO_DATE('2004-12-12', 'YYYY-MM-DD'), '3000000700', 'jose.fernandez0700@webmail.com', TO_DATE('2025-11-28', 'YYYY-MM-DD'), 6, 7);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES
('Sofia', 'Gomez', '0000000701', TO_DATE('2003-04-18', 'YYYY-MM-DD'), '3000000701', 'sofia.gomez0701@webmail.com', TO_DATE('2026-04-21', 'YYYY-MM-DD'), 6, 1);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES
('Laura', 'Rodriguez', '0000000702', TO_DATE('2005-05-12', 'YYYY-MM-DD'), '3000000702', 'laura.rodriguez0702@bz.com', TO_DATE('2025-07-14', 'YYYY-MM-DD'), 6, 2);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES
('Camila', 'Moreno', '0000000703', TO_DATE('1996-11-09', 'YYYY-MM-DD'), '3000000703', 'camila.moreno0703@mail.com', TO_DATE('2025-09-30', 'YYYY-MM-DD'), 6, 3);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES
('Carlos', 'Torres', '0000000704', TO_DATE('2000-07-24', 'YYYY-MM-DD'), '3000000704', 'carlos.torres0704@bz.com', TO_DATE('2026-11-02', 'YYYY-MM-DD'), 6, 10);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES
('Felipe', 'Torres', '0000000705', TO_DATE('2001-09-17', 'YYYY-MM-DD'), '3000000705', 'felipe.torres0705@bz.com', TO_DATE('2026-07-09', 'YYYY-MM-DD'), 6, 7);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES
('Andres', 'Pérez', '0000000706', TO_DATE('2000-10-22', 'YYYY-MM-DD'), '3000000706', 'andres.pérez0706@service.com', TO_DATE('2025-12-07', 'YYYY-MM-DD'), 6, 3);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES
('Sofia', 'Pérez', '0000000707', TO_DATE('2000-06-09', 'YYYY-MM-DD'), '3000000707', 'sofia.pérez0707@bz.com', TO_DATE('2026-05-15', 'YYYY-MM-DD'), 6, 2);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES
('Mariana', 'Fernandez', '0000000708', TO_DATE('2005-08-19', 'YYYY-MM-DD'), '3000000708', 'mariana.fernandez0708@webmail.com', TO_DATE('2026-11-13', 'YYYY-MM-DD'), 6, 1);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES
('Juan', 'Martinez', '0000000709', TO_DATE('1998-01-04', 'YYYY-MM-DD'), '3000000709', 'juan.martinez0709@service.com', TO_DATE('2026-09-13', 'YYYY-MM-DD'), 6, 9);

-- Cliente sede 7
INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES
('Camila', 'Martinez', '0000000710', TO_DATE('1998-12-15', 'YYYY-MM-DD'), '3000000710', 'camila.martinez0710@mail.com', TO_DATE('2025-11-26', 'YYYY-MM-DD'), 7, 8);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES
('Juan', 'Sanchez', '0000000711', TO_DATE('2003-11-15', 'YYYY-MM-DD'), '3000000711', 'juan.sanchez0711@service.com', TO_DATE('2026-09-14', 'YYYY-MM-DD'), 7, 4);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES
('Felipe', 'Rodriguez', '0000000712', TO_DATE('2005-12-19', 'YYYY-MM-DD'), '3000000712', 'felipe.rodriguez0712@webmail.com', TO_DATE('2026-05-10', 'YYYY-MM-DD'), 7, 4);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES
('Mariana', 'Rodriguez', '0000000713', TO_DATE('1995-01-12', 'YYYY-MM-DD'), '3000000713', 'mariana.rodriguez0713@bz.com', TO_DATE('2026-10-18', 'YYYY-MM-DD'), 7, 2);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES
('Juan', 'Garcia', '0000000714', TO_DATE('2004-01-14', 'YYYY-MM-DD'), '3000000714', 'juan.garcia0714@webmail.com', TO_DATE('2026-08-27', 'YYYY-MM-DD'), 7, 6);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES
('Camila', 'Lopez', '0000000715', TO_DATE('2001-02-09', 'YYYY-MM-DD'), '3000000715', 'camila.lopez0715@webmail.com', TO_DATE('2025-10-16', 'YYYY-MM-DD'), 7, 10);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES
('Laura', 'Lopez', '0000000716', TO_DATE('1994-09-10', 'YYYY-MM-DD'), '3000000716', 'laura.lopez0716@bz.com', TO_DATE('2026-06-04', 'YYYY-MM-DD'), 7, 5);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES
('Laura', 'Gomez', '0000000717', TO_DATE('1995-11-04', 'YYYY-MM-DD'), '3000000717', 'laura.gomez0717@service.com', TO_DATE('2026-10-09', 'YYYY-MM-DD'), 7, 1);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES
('Camila', 'Fernandez', '0000000718', TO_DATE('1998-04-14', 'YYYY-MM-DD'), '3000000718', 'camila.fernandez0718@webmail.com', TO_DATE('2025-11-09', 'YYYY-MM-DD'), 7, 3);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES
('Sofia', 'Fernandez', '0000000719', TO_DATE('2005-06-09', 'YYYY-MM-DD'), '3000000719', 'sofia.fernandez0719@webmail.com', TO_DATE('2025-12-06', 'YYYY-MM-DD'), 7, 10);

-- Cliente sede 8
INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES
('Andres', 'Fernandez', '0000000720', TO_DATE('2005-04-05', 'YYYY-MM-DD'), '3000000720', 'andres.fernandez0720@webmail.com', TO_DATE('2026-11-25', 'YYYY-MM-DD'), 8, 6);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES
('Sofia', 'Garcia', '0000000721', TO_DATE('1999-05-31', 'YYYY-MM-DD'), '3000000721', 'sofia.garcia0721@webmail.com', TO_DATE('2025-10-18', 'YYYY-MM-DD'), 8, 9);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES
('Mariana', 'Moreno', '0000000722', TO_DATE('1998-04-20', 'YYYY-MM-DD'), '3000000722', 'mariana.moreno0722@service.com', TO_DATE('2025-06-29', 'YYYY-MM-DD'), 8, 7);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES
('Mariana', 'Torres', '0000000723', TO_DATE('2001-03-28', 'YYYY-MM-DD'), '3000000723', 'mariana.torres0723@mail.com', TO_DATE('2026-01-18', 'YYYY-MM-DD'), 8, 4);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES
('Juan', 'Pérez', '0000000724', TO_DATE('2005-06-05', 'YYYY-MM-DD'), '3000000724', 'juan.pérez0724@mail.com', TO_DATE('2026-08-21', 'YYYY-MM-DD'), 8, 2);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES
('Camila', 'Rodriguez', '0000000725', TO_DATE('1997-08-15', 'YYYY-MM-DD'), '3000000725', 'camila.rodriguez0725@mail.com', TO_DATE('2026-06-26', 'YYYY-MM-DD'), 8, 8);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES
('Andres', 'Gomez', '0000000726', TO_DATE('1998-11-04', 'YYYY-MM-DD'), '3000000726', 'andres.gomez0726@mail.com', TO_DATE('2026-05-26', 'YYYY-MM-DD'), 8, 4);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES
('Sofia', 'Martinez', '0000000727', TO_DATE('1998-05-06', 'YYYY-MM-DD'), '3000000727', 'sofia.martinez0727@mail.com', TO_DATE('2025-10-09', 'YYYY-MM-DD'), 8, 7);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES
('Camila', 'Lopez', '0000000728', TO_DATE('1995-02-09', 'YYYY-MM-DD'), '3000000728', 'camila.lopez0728@service.com', TO_DATE('2026-06-28', 'YYYY-MM-DD'), 8, 2);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES
('Felipe', 'Torres', '0000000729', TO_DATE('1997-06-30', 'YYYY-MM-DD'), '3000000729', 'felipe.torres0729@service.com', TO_DATE('2026-09-23', 'YYYY-MM-DD'), 8, 1);

-- Cliente sede 9
INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES
('Laura', 'Lopez', '0000000730', TO_DATE('2000-10-19', 'YYYY-MM-DD'), '3000000730', 'laura.lopez0730@service.com', TO_DATE('2026-12-07', 'YYYY-MM-DD'), 9, 2);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES
('Sofia', 'Torres', '0000000731', TO_DATE('1995-11-03', 'YYYY-MM-DD'), '3000000731', 'sofia.torres0731@mail.com', TO_DATE('2026-04-06', 'YYYY-MM-DD'), 9, 10);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES
('Mariana', 'Fernandez', '0000000732', TO_DATE('1999-06-25', 'YYYY-MM-DD'), '3000000732', 'mariana.fernandez0732@bz.com', TO_DATE('2026-09-19', 'YYYY-MM-DD'), 9, 3);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES
('Mariana', 'Sanchez', '0000000733', TO_DATE('1994-08-17', 'YYYY-MM-DD'), '3000000733', 'mariana.sanchez0733@bz.com', TO_DATE('2026-05-14', 'YYYY-MM-DD'), 9, 1);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES
('Carlos', 'Rodriguez', '0000000734', TO_DATE('2004-01-01', 'YYYY-MM-DD'), '3000000734', 'carlos.rodriguez0734@mail.com', TO_DATE('2025-07-06', 'YYYY-MM-DD'), 9, 10);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES
('Sofia', 'Garcia', '0000000735', TO_DATE('2001-10-15', 'YYYY-MM-DD'), '3000000735', 'sofia.garcia0735@service.com', TO_DATE('2026-12-10', 'YYYY-MM-DD'), 9, 8);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES
('Camila', 'Moreno', '0000000736', TO_DATE('1998-03-21', 'YYYY-MM-DD'), '3000000736', 'camila.moreno0736@mail.com', TO_DATE('2026-07-18', 'YYYY-MM-DD'), 9, 6);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES
('Felipe', 'Martinez', '0000000737', TO_DATE('1996-12-12', 'YYYY-MM-DD'), '3000000737', 'felipe.martinez0737@mail.com', TO_DATE('2026-06-04', 'YYYY-MM-DD'), 9, 6);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES
('Camila', 'Pérez', '0000000738', TO_DATE('2003-10-13', 'YYYY-MM-DD'), '3000000738', 'camila.pérez0738@bz.com', TO_DATE('2025-12-07', 'YYYY-MM-DD'), 9, 8);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES
('Jose', 'Pérez', '0000000739', TO_DATE('1994-09-10', 'YYYY-MM-DD'), '3000000739', 'jose.pérez0739@webmail.com', TO_DATE('2025-10-26', 'YYYY-MM-DD'), 9, 9);

-- Cliente sede 10
INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES
('Jose', 'Sanchez', '0000000740', TO_DATE('2003-02-11', 'YYYY-MM-DD'), '3000000740', 'jose.sanchez0740@webmail.com', TO_DATE('2026-10-07', 'YYYY-MM-DD'), 10, 4);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES
('Daniela', 'Moreno', '0000000741', TO_DATE('1999-08-13', 'YYYY-MM-DD'), '3000000741', 'daniela.moreno0741@webmail.com', TO_DATE('2026-10-12', 'YYYY-MM-DD'), 10, 4);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES
('Carlos', 'Moreno', '0000000742', TO_DATE('1997-09-09', 'YYYY-MM-DD'), '3000000742', 'carlos.moreno0742@bz.com', TO_DATE('2025-09-27', 'YYYY-MM-DD'), 10, 6);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES
('Juan', 'Pérez', '0000000743', TO_DATE('2003-08-26', 'YYYY-MM-DD'), '3000000743', 'juan.pérez0743@webmail.com', TO_DATE('2026-11-09', 'YYYY-MM-DD'), 10, 1);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES
('Laura', 'Pérez', '0000000744', TO_DATE('2000-04-16', 'YYYY-MM-DD'), '3000000744', 'laura.pérez0744@webmail.com', TO_DATE('2026-07-18', 'YYYY-MM-DD'), 10, 4);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES
('Felipe', 'Garcia', '0000000745', TO_DATE('1994-07-06', 'YYYY-MM-DD'), '3000000745', 'felipe.garcia0745@service.com', TO_DATE('2026-03-04', 'YYYY-MM-DD'), 10, 8);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES
('Daniela', 'Sanchez', '0000000746', TO_DATE('2000-02-01', 'YYYY-MM-DD'), '3000000746', 'daniela.sanchez0746@mail.com', TO_DATE('2025-07-13', 'YYYY-MM-DD'), 10, 6);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES
('Andres', 'Martinez', '0000000747', TO_DATE('2005-09-22', 'YYYY-MM-DD'), '3000000747', 'andres.martinez0747@webmail.com', TO_DATE('2025-08-29', 'YYYY-MM-DD'), 10, 2);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES
('Camila', 'Garcia', '0000000748', TO_DATE('1997-08-18', 'YYYY-MM-DD'), '3000000748', 'camila.garcia0748@webmail.com', TO_DATE('2026-05-26', 'YYYY-MM-DD'), 10, 4);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES
('Carlos', 'Lopez', '0000000749', TO_DATE('1997-07-01', 'YYYY-MM-DD'), '3000000749', 'carlos.lopez0749@webmail.com', TO_DATE('2026-08-27', 'YYYY-MM-DD'), 10, 10);

-- Cliente sede 11
INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES
('Camila', 'Torres', '0000000750', TO_DATE('2005-02-05', 'YYYY-MM-DD'), '3000000750', 'camila.torres0750@mail.com', TO_DATE('2025-05-28', 'YYYY-MM-DD'), 11, 10);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES
('Andres', 'Rodriguez', '0000000751', TO_DATE('1994-11-25', 'YYYY-MM-DD'), '3000000751', 'andres.rodriguez0751@mail.com', TO_DATE('2025-08-06', 'YYYY-MM-DD'), 11, 7);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES
('Andres', 'Martinez', '0000000752', TO_DATE('1998-09-23', 'YYYY-MM-DD'), '3000000752', 'andres.martinez0752@service.com', TO_DATE('2025-10-13', 'YYYY-MM-DD'), 11, 5);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES
('Daniela', 'Garcia', '0000000753', TO_DATE('2003-09-29', 'YYYY-MM-DD'), '3000000753', 'daniela.garcia0753@service.com', TO_DATE('2025-08-26', 'YYYY-MM-DD'), 11, 6);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES
('Daniela', 'Moreno', '0000000754', TO_DATE('2000-05-26', 'YYYY-MM-DD'), '3000000754', 'daniela.moreno0754@service.com', TO_DATE('2026-04-23', 'YYYY-MM-DD'), 11, 6);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES
('Sofia', 'Sanchez', '0000000755', TO_DATE('1996-04-20', 'YYYY-MM-DD'), '3000000755', 'sofia.sanchez0755@service.com', TO_DATE('2025-06-01', 'YYYY-MM-DD'), 11, 2);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES
('Mariana', 'Torres', '0000000756', TO_DATE('2002-12-19', 'YYYY-MM-DD'), '3000000756', 'mariana.torres0756@mail.com', TO_DATE('2025-09-19', 'YYYY-MM-DD'), 11, 6);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES
('Sofia', 'Rodriguez', '0000000757', TO_DATE('2001-05-20', 'YYYY-MM-DD'), '3000000757', 'sofia.rodriguez0757@service.com', TO_DATE('2026-02-10', 'YYYY-MM-DD'), 11, 1);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES
('Mariana', 'Rodriguez', '0000000758', TO_DATE('2005-03-21', 'YYYY-MM-DD'), '3000000758', 'mariana.rodriguez0758@webmail.com', TO_DATE('2025-05-19', 'YYYY-MM-DD'), 11, 7);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES
('Camila', 'Garcia', '0000000759', TO_DATE('2002-11-14', 'YYYY-MM-DD'), '3000000759', 'camila.garcia0759@service.com', TO_DATE('2025-11-15', 'YYYY-MM-DD'), 11, 10);

-- Cliente sede 12
INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES
('Daniela', 'Pérez', '0000000760', TO_DATE('1996-05-12', 'YYYY-MM-DD'), '3000000760', 'daniela.pérez0760@service.com', TO_DATE('2026-07-24', 'YYYY-MM-DD'), 12, 10);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES
('Laura', 'Torres', '0000000761', TO_DATE('1995-02-26', 'YYYY-MM-DD'), '3000000761', 'laura.torres0761@service.com', TO_DATE('2026-05-21', 'YYYY-MM-DD'), 12, 8);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES
('Daniela', 'Sanchez', '0000000762', TO_DATE('2000-11-03', 'YYYY-MM-DD'), '3000000762', 'daniela.sanchez0762@webmail.com', TO_DATE('2026-02-19', 'YYYY-MM-DD'), 12, 4);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES
('Carlos', 'Lopez', '0000000763', TO_DATE('2000-08-10', 'YYYY-MM-DD'), '3000000763', 'carlos.lopez0763@mail.com', TO_DATE('2025-09-14', 'YYYY-MM-DD'), 12, 10);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES
('Laura', 'Pérez', '0000000764', TO_DATE('1998-06-02', 'YYYY-MM-DD'), '3000000764', 'laura.pérez0764@bz.com', TO_DATE('2025-07-31', 'YYYY-MM-DD'), 12, 7);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES
('Andres', 'Pérez', '0000000765', TO_DATE('2004-02-22', 'YYYY-MM-DD'), '3000000765', 'andres.pérez0765@service.com', TO_DATE('2025-07-27', 'YYYY-MM-DD'), 12, 7);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES
('Sofia', 'Martinez', '0000000766', TO_DATE('2005-03-26', 'YYYY-MM-DD'), '3000000766', 'sofia.martinez0766@bz.com', TO_DATE('2025-10-29', 'YYYY-MM-DD'), 12, 7);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES
('Mariana', 'Sanchez', '0000000767', TO_DATE('2005-07-31', 'YYYY-MM-DD'), '3000000767', 'mariana.sanchez0767@bz.com', TO_DATE('2026-09-03', 'YYYY-MM-DD'), 12, 9);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES
('Mariana', 'Rodriguez', '0000000768', TO_DATE('2003-04-24', 'YYYY-MM-DD'), '3000000768', 'mariana.rodriguez0768@webmail.com', TO_DATE('2026-02-19', 'YYYY-MM-DD'), 12, 5);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES
('Carlos', 'Torres', '0000000769', TO_DATE('2002-08-30', 'YYYY-MM-DD'), '3000000769', 'carlos.torres0769@mail.com', TO_DATE('2025-08-23', 'YYYY-MM-DD'), 12, 4);

-- Cliente sede 13
INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES
('Daniela', 'Torres', '0000000770', TO_DATE('2002-07-05', 'YYYY-MM-DD'), '3000000770', 'daniela.torres0770@webmail.com', TO_DATE('2026-08-20', 'YYYY-MM-DD'), 13, 8);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES
('Camila', 'Fernandez', '0000000771', TO_DATE('1999-06-12', 'YYYY-MM-DD'), '3000000771', 'camila.fernandez0771@bz.com', TO_DATE('2026-11-14', 'YYYY-MM-DD'), 13, 8);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES
('Mariana', 'Fernandez', '0000000772', TO_DATE('1997-10-20', 'YYYY-MM-DD'), '3000000772', 'mariana.fernandez0772@mail.com', TO_DATE('2026-10-30', 'YYYY-MM-DD'), 13, 8);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES
('Carlos', 'Sanchez', '0000000773', TO_DATE('2004-06-19', 'YYYY-MM-DD'), '3000000773', 'carlos.sanchez0773@service.com', TO_DATE('2025-10-21', 'YYYY-MM-DD'), 13, 5);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES
('Juan', 'Martinez', '0000000774', TO_DATE('2003-04-05', 'YYYY-MM-DD'), '3000000774', 'juan.martinez0774@service.com', TO_DATE('2026-01-22', 'YYYY-MM-DD'), 13, 8);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES
('Andres', 'Moreno', '0000000775', TO_DATE('2004-01-06', 'YYYY-MM-DD'), '3000000775', 'andres.moreno0775@mail.com', TO_DATE('2026-09-15', 'YYYY-MM-DD'), 13, 7);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES
('Sofia', 'Garcia', '0000000776', TO_DATE('2000-12-07', 'YYYY-MM-DD'), '3000000776', 'sofia.garcia0776@service.com', TO_DATE('2026-05-25', 'YYYY-MM-DD'), 13, 4);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES
('Juan', 'Sanchez', '0000000777', TO_DATE('2001-11-21', 'YYYY-MM-DD'), '3000000777', 'juan.sanchez0777@service.com', TO_DATE('2026-03-29', 'YYYY-MM-DD'), 13, 6);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES
('Andres', 'Moreno', '0000000778', TO_DATE('2005-02-19', 'YYYY-MM-DD'), '3000000778', 'andres.moreno0778@webmail.com', TO_DATE('2026-02-24', 'YYYY-MM-DD'), 13, 8);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES
('Mariana', 'Martinez', '0000000779', TO_DATE('2001-12-26', 'YYYY-MM-DD'), '3000000779', 'mariana.martinez0779@bz.com', TO_DATE('2026-05-30', 'YYYY-MM-DD'), 13, 10);

-- Cliente sede 14
INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES
('Laura', 'Lopez', '0000000780', TO_DATE('1995-03-11', 'YYYY-MM-DD'), '3000000780', 'laura.lopez0780@service.com', TO_DATE('2025-11-18', 'YYYY-MM-DD'), 14, 10);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES
('Mariana', 'Garcia', '0000000781', TO_DATE('1997-12-16', 'YYYY-MM-DD'), '3000000781', 'mariana.garcia0781@service.com', TO_DATE('2026-05-11', 'YYYY-MM-DD'), 14, 2);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES
('Carlos', 'Lopez', '0000000782', TO_DATE('2000-09-16', 'YYYY-MM-DD'), '3000000782', 'carlos.lopez0782@bz.com', TO_DATE('2025-12-12', 'YYYY-MM-DD'), 14, 3);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES
('Andres', 'Martinez', '0000000783', TO_DATE('2001-12-20', 'YYYY-MM-DD'), '3000000783', 'andres.martinez0783@mail.com', TO_DATE('2026-08-06', 'YYYY-MM-DD'), 14, 8);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES
('Juan', 'Garcia', '0000000784', TO_DATE('1998-07-03', 'YYYY-MM-DD'), '3000000784', 'juan.garcia0784@webmail.com', TO_DATE('2025-10-01', 'YYYY-MM-DD'), 14, 1);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES
('Camila', 'Torres', '0000000785', TO_DATE('1994-10-25', 'YYYY-MM-DD'), '3000000785', 'camila.torres0785@webmail.com', TO_DATE('2025-08-30', 'YYYY-MM-DD'), 14, 7);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES
('Jose', 'Torres', '0000000786', TO_DATE('2005-11-10', 'YYYY-MM-DD'), '3000000786', 'jose.torres0786@service.com', TO_DATE('2025-11-07', 'YYYY-MM-DD'), 14, 1);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES
('Andres', 'Martinez', '0000000787', TO_DATE('2001-08-18', 'YYYY-MM-DD'), '3000000787', 'andres.martinez0787@webmail.com', TO_DATE('2026-03-15', 'YYYY-MM-DD'), 14, 8);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES
('Sofia', 'Fernandez', '0000000788', TO_DATE('1995-09-06', 'YYYY-MM-DD'), '3000000788', 'sofia.fernandez0788@bz.com', TO_DATE('2025-10-23', 'YYYY-MM-DD'), 14, 9);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES
('Camila', 'Fernandez', '0000000789', TO_DATE('1996-04-04', 'YYYY-MM-DD'), '3000000789', 'camila.fernandez0789@webmail.com', TO_DATE('2026-08-13', 'YYYY-MM-DD'), 14, 7);

-- Cliente sede 15
INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES
('Sofia', 'Gomez', '0000000790', TO_DATE('2001-12-02', 'YYYY-MM-DD'), '3000000790', 'sofia.gomez0790@bz.com', TO_DATE('2026-09-17', 'YYYY-MM-DD'), 15, 7);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES
('Laura', 'Torres', '0000000791', TO_DATE('2002-01-19', 'YYYY-MM-DD'), '3000000791', 'laura.torres0791@mail.com', TO_DATE('2025-06-10', 'YYYY-MM-DD'), 15, 10);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES
('Felipe', 'Garcia', '0000000792', TO_DATE('1998-03-27', 'YYYY-MM-DD'), '3000000792', 'felipe.garcia0792@webmail.com', TO_DATE('2025-07-23', 'YYYY-MM-DD'), 15, 6);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES
('Camila', 'Pérez', '0000000793', TO_DATE('2005-09-29', 'YYYY-MM-DD'), '3000000793', 'camila.pérez0793@service.com', TO_DATE('2025-05-26', 'YYYY-MM-DD'), 15, 2);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES
('Andres', 'Garcia', '0000000794', TO_DATE('2003-04-05', 'YYYY-MM-DD'), '3000000794', 'andres.garcia0794@mail.com', TO_DATE('2026-07-30', 'YYYY-MM-DD'), 15, 4);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES
('Juan', 'Martinez', '0000000795', TO_DATE('2005-07-22', 'YYYY-MM-DD'), '3000000795', 'juan.martinez0795@service.com', TO_DATE('2025-06-04', 'YYYY-MM-DD'), 15, 2);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES
('Jose', 'Gomez', '0000000796', TO_DATE('2003-10-15', 'YYYY-MM-DD'), '3000000796', 'jose.gomez0796@bz.com', TO_DATE('2026-09-26', 'YYYY-MM-DD'), 15, 6);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES
('Juan', 'Sanchez', '0000000797', TO_DATE('2002-07-25', 'YYYY-MM-DD'), '3000000797', 'juan.sanchez0797@bz.com', TO_DATE('2026-11-26', 'YYYY-MM-DD'), 15, 8);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES
('Felipe', 'Fernandez', '0000000798', TO_DATE('1994-11-23', 'YYYY-MM-DD'), '3000000798', 'felipe.fernandez0798@bz.com', TO_DATE('2026-01-08', 'YYYY-MM-DD'), 15, 5);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES
('Juan', 'Pérez', '0000000799', TO_DATE('2000-03-30', 'YYYY-MM-DD'), '3000000799', 'juan.pérez0799@bz.com', TO_DATE('2026-01-13', 'YYYY-MM-DD'), 15, 5);

-- Cliente sede 16
INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES
('Felipe', 'Rodriguez', '0000000800', TO_DATE('1994-07-02', 'YYYY-MM-DD'), '3000000800', 'felipe.rodriguez0800@service.com', TO_DATE('2026-11-19', 'YYYY-MM-DD'), 16, 4);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES
('Andres', 'Fernandez', '0000000801', TO_DATE('2001-11-14', 'YYYY-MM-DD'), '3000000801', 'andres.fernandez0801@bz.com', TO_DATE('2025-08-05', 'YYYY-MM-DD'), 16, 10);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES
('Felipe', 'Lopez', '0000000802', TO_DATE('2005-09-16', 'YYYY-MM-DD'), '3000000802', 'felipe.lopez0802@bz.com', TO_DATE('2026-06-02', 'YYYY-MM-DD'), 16, 5);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES
('Daniela', 'Sanchez', '0000000803', TO_DATE('2000-10-11', 'YYYY-MM-DD'), '3000000803', 'daniela.sanchez0803@mail.com', TO_DATE('2026-10-16', 'YYYY-MM-DD'), 16, 1);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES
('Jose', 'Moreno', '0000000804', TO_DATE('2005-10-17', 'YYYY-MM-DD'), '3000000804', 'jose.moreno0804@bz.com', TO_DATE('2025-11-11', 'YYYY-MM-DD'), 16, 2);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES
('Juan', 'Sanchez', '0000000805', TO_DATE('2003-04-24', 'YYYY-MM-DD'), '3000000805', 'juan.sanchez0805@mail.com', TO_DATE('2026-05-14', 'YYYY-MM-DD'), 16, 6);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES
('Andres', 'Pérez', '0000000806', TO_DATE('1996-04-18', 'YYYY-MM-DD'), '3000000806', 'andres.pérez0806@webmail.com', TO_DATE('2026-01-02', 'YYYY-MM-DD'), 16, 8);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES
('Camila', 'Gomez', '0000000807', TO_DATE('1996-09-15', 'YYYY-MM-DD'), '3000000807', 'camila.gomez0807@service.com', TO_DATE('2026-10-16', 'YYYY-MM-DD'), 16, 9);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES
('Andres', 'Lopez', '0000000808', TO_DATE('2000-10-07', 'YYYY-MM-DD'), '3000000808', 'andres.lopez0808@service.com', TO_DATE('2025-07-22', 'YYYY-MM-DD'), 16, 2);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES
('Camila', 'Pérez', '0000000809', TO_DATE('1996-06-11', 'YYYY-MM-DD'), '3000000809', 'camila.pérez0809@service.com', TO_DATE('2026-12-03', 'YYYY-MM-DD'), 16, 8);

-- Cliente sede 17
INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES
('Sofia', 'Moreno', '0000000810', TO_DATE('1999-01-06', 'YYYY-MM-DD'), '3000000810', 'sofia.moreno0810@bz.com', TO_DATE('2026-09-23', 'YYYY-MM-DD'), 17, 8);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES
('Juan', 'Torres', '0000000811', TO_DATE('1996-06-21', 'YYYY-MM-DD'), '3000000811', 'juan.torres0811@bz.com', TO_DATE('2026-12-04', 'YYYY-MM-DD'), 17, 5);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES
('Carlos', 'Garcia', '0000000812', TO_DATE('2003-01-12', 'YYYY-MM-DD'), '3000000812', 'carlos.garcia0812@service.com', TO_DATE('2025-12-12', 'YYYY-MM-DD'), 17, 9);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES
('Camila', 'Torres', '0000000813', TO_DATE('2004-02-25', 'YYYY-MM-DD'), '3000000813', 'camila.torres0813@bz.com', TO_DATE('2025-11-23', 'YYYY-MM-DD'), 17, 10);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES
('Andres', 'Martinez', '0000000814', TO_DATE('2003-03-24', 'YYYY-MM-DD'), '3000000814', 'andres.martinez0814@service.com', TO_DATE('2025-08-24', 'YYYY-MM-DD'), 17, 5);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES
('Camila', 'Moreno', '0000000815', TO_DATE('1996-01-01', 'YYYY-MM-DD'), '3000000815', 'camila.moreno0815@bz.com', TO_DATE('2025-11-06', 'YYYY-MM-DD'), 17, 8);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES
('Camila', 'Pérez', '0000000816', TO_DATE('2005-12-12', 'YYYY-MM-DD'), '3000000816', 'camila.pérez0816@mail.com', TO_DATE('2026-12-21', 'YYYY-MM-DD'), 17, 7);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES
('Sofia', 'Martinez', '0000000817', TO_DATE('1996-05-19', 'YYYY-MM-DD'), '3000000817', 'sofia.martinez0817@bz.com', TO_DATE('2026-03-08', 'YYYY-MM-DD'), 17, 7);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES
('Andres', 'Rodriguez', '0000000818', TO_DATE('1994-12-13', 'YYYY-MM-DD'), '3000000818', 'andres.rodriguez0818@mail.com', TO_DATE('2026-05-30', 'YYYY-MM-DD'), 17, 9);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES
('Carlos', 'Moreno', '0000000819', TO_DATE('2004-05-23', 'YYYY-MM-DD'), '3000000819', 'carlos.moreno0819@service.com', TO_DATE('2026-06-13', 'YYYY-MM-DD'), 17, 2);

-- Cliente sede 18
INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES
('Camila', 'Rodriguez', '0000000820', TO_DATE('2002-12-02', 'YYYY-MM-DD'), '3000000820', 'camila.rodriguez0820@webmail.com', TO_DATE('2025-10-19', 'YYYY-MM-DD'), 18, 8);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES
('Camila', 'Sanchez', '0000000821', TO_DATE('1995-11-23', 'YYYY-MM-DD'), '3000000821', 'camila.sanchez0821@webmail.com', TO_DATE('2025-11-18', 'YYYY-MM-DD'), 18, 1);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES
('Felipe', 'Torres', '0000000822', TO_DATE('1999-09-05', 'YYYY-MM-DD'), '3000000822', 'felipe.torres0822@bz.com', TO_DATE('2026-12-29', 'YYYY-MM-DD'), 18, 2);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES
('Mariana', 'Pérez', '0000000823', TO_DATE('1998-08-10', 'YYYY-MM-DD'), '3000000823', 'mariana.pérez0823@bz.com', TO_DATE('2025-11-21', 'YYYY-MM-DD'), 18, 5);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES
('Felipe', 'Garcia', '0000000824', TO_DATE('2002-10-19', 'YYYY-MM-DD'), '3000000824', 'felipe.garcia0824@service.com', TO_DATE('2026-11-29', 'YYYY-MM-DD'), 18, 2);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES
('Laura', 'Torres', '0000000825', TO_DATE('1998-08-17', 'YYYY-MM-DD'), '3000000825', 'laura.torres0825@service.com', TO_DATE('2026-12-05', 'YYYY-MM-DD'), 18, 10);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES
('Daniela', 'Lopez', '0000000826', TO_DATE('2003-11-07', 'YYYY-MM-DD'), '3000000826', 'daniela.lopez0826@bz.com', TO_DATE('2025-08-20', 'YYYY-MM-DD'), 18, 1);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES
('Daniela', 'Lopez', '0000000827', TO_DATE('1995-04-25', 'YYYY-MM-DD'), '3000000827', 'daniela.lopez0827@bz.com', TO_DATE('2026-02-12', 'YYYY-MM-DD'), 18, 3);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES
('Daniela', 'Martinez', '0000000828', TO_DATE('2001-03-07', 'YYYY-MM-DD'), '3000000828', 'daniela.martinez0828@bz.com', TO_DATE('2026-01-09', 'YYYY-MM-DD'), 18, 6);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES
('Mariana', 'Garcia', '0000000829', TO_DATE('1999-04-20', 'YYYY-MM-DD'), '3000000829', 'mariana.garcia0829@mail.com', TO_DATE('2026-03-17', 'YYYY-MM-DD'), 18, 1);

-- Cliente sede 19
INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES
('Carlos', 'Garcia', '0000000830', TO_DATE('1999-04-27', 'YYYY-MM-DD'), '3000000830', 'carlos.garcia0830@bz.com', TO_DATE('2025-11-25', 'YYYY-MM-DD'), 19, 4);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES
('Camila', 'Gomez', '0000000831', TO_DATE('1995-04-08', 'YYYY-MM-DD'), '3000000831', 'camila.gomez0831@mail.com', TO_DATE('2026-12-26', 'YYYY-MM-DD'), 19, 10);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES
('Mariana', 'Lopez', '0000000832', TO_DATE('1996-07-14', 'YYYY-MM-DD'), '3000000832', 'mariana.lopez0832@service.com', TO_DATE('2026-09-16', 'YYYY-MM-DD'), 19, 9);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES
('Daniela', 'Torres', '0000000833', TO_DATE('1998-10-20', 'YYYY-MM-DD'), '3000000833', 'daniela.torres0833@webmail.com', TO_DATE('2026-04-15', 'YYYY-MM-DD'), 19, 6);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES
('Camila', 'Garcia', '0000000834', TO_DATE('2001-10-31', 'YYYY-MM-DD'), '3000000834', 'camila.garcia0834@service.com', TO_DATE('2025-09-25', 'YYYY-MM-DD'), 19, 8);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES
('Laura', 'Garcia', '0000000835', TO_DATE('1998-08-09', 'YYYY-MM-DD'), '3000000835', 'laura.garcia0835@service.com', TO_DATE('2026-11-07', 'YYYY-MM-DD'), 19, 1);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES
('Camila', 'Sanchez', '0000000836', TO_DATE('2001-09-14', 'YYYY-MM-DD'), '3000000836', 'camila.sanchez0836@webmail.com', TO_DATE('2026-06-28', 'YYYY-MM-DD'), 19, 5);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES
('Juan', 'Sanchez', '0000000837', TO_DATE('2001-03-23', 'YYYY-MM-DD'), '3000000837', 'juan.sanchez0837@webmail.com', TO_DATE('2026-03-13', 'YYYY-MM-DD'), 19, 2);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES
('Carlos', 'Pérez', '0000000838', TO_DATE('1998-02-10', 'YYYY-MM-DD'), '3000000838', 'carlos.pérez0838@webmail.com', TO_DATE('2025-06-14', 'YYYY-MM-DD'), 19, 1);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES
('Mariana', 'Torres', '0000000839', TO_DATE('1997-05-18', 'YYYY-MM-DD'), '3000000839', 'mariana.torres0839@mail.com', TO_DATE('2026-10-30', 'YYYY-MM-DD'), 19, 3);

-- Cliente sede 20
INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES
('Mariana', 'Martinez', '0000000840', TO_DATE('2004-03-31', 'YYYY-MM-DD'), '3000000840', 'mariana.martinez0840@webmail.com', TO_DATE('2026-02-13', 'YYYY-MM-DD'), 20, 3);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES
('Sofia', 'Torres', '0000000841', TO_DATE('1997-04-11', 'YYYY-MM-DD'), '3000000841', 'sofia.torres0841@mail.com', TO_DATE('2025-10-09', 'YYYY-MM-DD'), 20, 6);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES
('Laura', 'Fernandez', '0000000842', TO_DATE('1997-03-22', 'YYYY-MM-DD'), '3000000842', 'laura.fernandez0842@service.com', TO_DATE('2025-09-14', 'YYYY-MM-DD'), 20, 10);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES
('Daniela', 'Garcia', '0000000843', TO_DATE('1995-06-20', 'YYYY-MM-DD'), '3000000843', 'daniela.garcia0843@webmail.com', TO_DATE('2026-02-09', 'YYYY-MM-DD'), 20, 9);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES
('Juan', 'Gomez', '0000000844', TO_DATE('2002-02-22', 'YYYY-MM-DD'), '3000000844', 'juan.gomez0844@bz.com', TO_DATE('2026-03-25', 'YYYY-MM-DD'), 20, 3);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES
('Felipe', 'Gomez', '0000000845', TO_DATE('1998-04-03', 'YYYY-MM-DD'), '3000000845', 'felipe.gomez0845@bz.com', TO_DATE('2026-01-06', 'YYYY-MM-DD'), 20, 7);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES
('Juan', 'Lopez', '0000000846', TO_DATE('1999-10-08', 'YYYY-MM-DD'), '3000000846', 'juan.lopez0846@bz.com', TO_DATE('2025-07-20', 'YYYY-MM-DD'), 20, 5);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES
('Laura', 'Martinez', '0000000847', TO_DATE('1998-08-27', 'YYYY-MM-DD'), '3000000847', 'laura.martinez0847@service.com', TO_DATE('2025-08-03', 'YYYY-MM-DD'), 20, 4);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES
('Carlos', 'Lopez', '0000000848', TO_DATE('2000-11-08', 'YYYY-MM-DD'), '3000000848', 'carlos.lopez0848@bz.com', TO_DATE('2025-07-12', 'YYYY-MM-DD'), 20, 9);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES
('Mariana', 'Garcia', '0000000849', TO_DATE('1998-04-20', 'YYYY-MM-DD'), '3000000849', 'mariana.garcia0849@mail.com', TO_DATE('2026-04-04', 'YYYY-MM-DD'), 20, 2);

-- Cliente sede 21
INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES
('Felipe', 'Garcia', '0000000850', TO_DATE('1997-12-27', 'YYYY-MM-DD'), '3000000850', 'felipe.garcia0850@mail.com', TO_DATE('2026-08-02', 'YYYY-MM-DD'), 21, 7);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES
('Felipe', 'Gomez', '0000000851', TO_DATE('1997-04-24', 'YYYY-MM-DD'), '3000000851', 'felipe.gomez0851@bz.com', TO_DATE('2025-06-11', 'YYYY-MM-DD'), 21, 2);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES
('Mariana', 'Lopez', '0000000852', TO_DATE('1996-05-07', 'YYYY-MM-DD'), '3000000852', 'mariana.lopez0852@webmail.com', TO_DATE('2025-12-05', 'YYYY-MM-DD'), 21, 4);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES
('Daniela', 'Pérez', '0000000853', TO_DATE('1999-03-26', 'YYYY-MM-DD'), '3000000853', 'daniela.pérez0853@bz.com', TO_DATE('2025-07-27', 'YYYY-MM-DD'), 21, 10);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES
('Jose', 'Moreno', '0000000854', TO_DATE('1998-08-19', 'YYYY-MM-DD'), '3000000854', 'jose.moreno0854@bz.com', TO_DATE('2025-10-28', 'YYYY-MM-DD'), 21, 9);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES
('Jose', 'Moreno', '0000000855', TO_DATE('2003-02-25', 'YYYY-MM-DD'), '3000000855', 'jose.moreno0855@bz.com', TO_DATE('2026-06-02', 'YYYY-MM-DD'), 21, 1);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES
('Carlos', 'Fernandez', '0000000856', TO_DATE('2002-09-11', 'YYYY-MM-DD'), '3000000856', 'carlos.fernandez0856@webmail.com', TO_DATE('2025-06-06', 'YYYY-MM-DD'), 21, 9);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES
('Juan', 'Torres', '0000000857', TO_DATE('1999-09-04', 'YYYY-MM-DD'), '3000000857', 'juan.torres0857@service.com', TO_DATE('2026-08-26', 'YYYY-MM-DD'), 21, 6);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES
('Felipe', 'Torres', '0000000858', TO_DATE('1994-07-22', 'YYYY-MM-DD'), '3000000858', 'felipe.torres0858@webmail.com', TO_DATE('2026-11-14', 'YYYY-MM-DD'), 21, 9);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES
('Andres', 'Pérez', '0000000859', TO_DATE('2004-10-06', 'YYYY-MM-DD'), '3000000859', 'andres.pérez0859@bz.com', TO_DATE('2026-11-01', 'YYYY-MM-DD'), 21, 6);

-- Cliente sede 22
INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES
('Laura', 'Torres', '0000000860', TO_DATE('2003-05-13', 'YYYY-MM-DD'), '3000000860', 'laura.torres0860@mail.com', TO_DATE('2025-06-05', 'YYYY-MM-DD'), 22, 2);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES
('Juan', 'Gomez', '0000000861', TO_DATE('1998-07-31', 'YYYY-MM-DD'), '3000000861', 'juan.gomez0861@service.com', TO_DATE('2026-10-09', 'YYYY-MM-DD'), 22, 7);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES
('Camila', 'Rodriguez', '0000000862', TO_DATE('1997-02-16', 'YYYY-MM-DD'), '3000000862', 'camila.rodriguez0862@webmail.com', TO_DATE('2026-05-20', 'YYYY-MM-DD'), 22, 2);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES
('Daniela', 'Gomez', '0000000863', TO_DATE('2001-10-09', 'YYYY-MM-DD'), '3000000863', 'daniela.gomez0863@bz.com', TO_DATE('2026-02-27', 'YYYY-MM-DD'), 22, 1);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES
('Mariana', 'Lopez', '0000000864', TO_DATE('1995-02-06', 'YYYY-MM-DD'), '3000000864', 'mariana.lopez0864@bz.com', TO_DATE('2026-07-02', 'YYYY-MM-DD'), 22, 5);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES
('Juan', 'Torres', '0000000865', TO_DATE('2002-02-06', 'YYYY-MM-DD'), '3000000865', 'juan.torres0865@webmail.com', TO_DATE('2026-01-26', 'YYYY-MM-DD'), 22, 4);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES
('Camila', 'Pérez', '0000000866', TO_DATE('1999-12-07', 'YYYY-MM-DD'), '3000000866', 'camila.pérez0866@bz.com', TO_DATE('2025-12-24', 'YYYY-MM-DD'), 22, 6);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES
('Daniela', 'Gomez', '0000000867', TO_DATE('1994-10-13', 'YYYY-MM-DD'), '3000000867', 'daniela.gomez0867@mail.com', TO_DATE('2025-10-21', 'YYYY-MM-DD'), 22, 7);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES
('Felipe', 'Pérez', '0000000868', TO_DATE('2001-10-27', 'YYYY-MM-DD'), '3000000868', 'felipe.pérez0868@mail.com', TO_DATE('2025-06-28', 'YYYY-MM-DD'), 22, 2);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES
('Felipe', 'Lopez', '0000000869', TO_DATE('1996-11-14', 'YYYY-MM-DD'), '3000000869', 'felipe.lopez0869@service.com', TO_DATE('2025-11-22', 'YYYY-MM-DD'), 22, 4);

-- Cliente sede 23
INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES
('Laura', 'Garcia', '0000000870', TO_DATE('2000-08-25', 'YYYY-MM-DD'), '3000000870', 'laura.garcia0870@webmail.com', TO_DATE('2026-05-19', 'YYYY-MM-DD'), 23, 3);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES
('Camila', 'Martinez', '0000000871', TO_DATE('1995-05-03', 'YYYY-MM-DD'), '3000000871', 'camila.martinez0871@bz.com', TO_DATE('2025-10-23', 'YYYY-MM-DD'), 23, 4);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES
('Juan', 'Lopez', '0000000872', TO_DATE('1995-07-13', 'YYYY-MM-DD'), '3000000872', 'juan.lopez0872@service.com', TO_DATE('2025-08-11', 'YYYY-MM-DD'), 23, 1);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES
('Camila', 'Rodriguez', '0000000873', TO_DATE('1998-05-20', 'YYYY-MM-DD'), '3000000873', 'camila.rodriguez0873@webmail.com', TO_DATE('2025-05-30', 'YYYY-MM-DD'), 23, 2);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES
('Daniela', 'Sanchez', '0000000874', TO_DATE('1996-11-13', 'YYYY-MM-DD'), '3000000874', 'daniela.sanchez0874@service.com', TO_DATE('2026-03-31', 'YYYY-MM-DD'), 23, 7);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES
('Camila', 'Rodriguez', '0000000875', TO_DATE('1998-05-26', 'YYYY-MM-DD'), '3000000875', 'camila.rodriguez0875@mail.com', TO_DATE('2025-10-24', 'YYYY-MM-DD'), 23, 2);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES
('Jose', 'Moreno', '0000000876', TO_DATE('1998-05-24', 'YYYY-MM-DD'), '3000000876', 'jose.moreno0876@mail.com', TO_DATE('2026-05-14', 'YYYY-MM-DD'), 23, 1);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES
('Carlos', 'Moreno', '0000000877', TO_DATE('1994-07-05', 'YYYY-MM-DD'), '3000000877', 'carlos.moreno0877@bz.com', TO_DATE('2025-06-11', 'YYYY-MM-DD'), 23, 2);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES
('Daniela', 'Torres', '0000000878', TO_DATE('1996-07-28', 'YYYY-MM-DD'), '3000000878', 'daniela.torres0878@webmail.com', TO_DATE('2026-01-14', 'YYYY-MM-DD'), 23, 8);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES
('Camila', 'Pérez', '0000000879', TO_DATE('2001-05-11', 'YYYY-MM-DD'), '3000000879', 'camila.pérez0879@webmail.com', TO_DATE('2025-08-22', 'YYYY-MM-DD'), 23, 4);

-- Cliente sede 24
INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES
('Laura', 'Martinez', '0000000880', TO_DATE('1996-08-22', 'YYYY-MM-DD'), '3000000880', 'laura.martinez0880@bz.com', TO_DATE('2026-02-11', 'YYYY-MM-DD'), 24, 5);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES
('Andres', 'Gomez', '0000000881', TO_DATE('2003-07-12', 'YYYY-MM-DD'), '3000000881', 'andres.gomez0881@service.com', TO_DATE('2026-08-11', 'YYYY-MM-DD'), 24, 10);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES
('Jose', 'Lopez', '0000000882', TO_DATE('1999-05-23', 'YYYY-MM-DD'), '3000000882', 'jose.lopez0882@bz.com', TO_DATE('2025-09-18', 'YYYY-MM-DD'), 24, 10);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES
('Andres', 'Martinez', '0000000883', TO_DATE('1994-09-05', 'YYYY-MM-DD'), '3000000883', 'andres.martinez0883@service.com', TO_DATE('2025-11-16', 'YYYY-MM-DD'), 24, 5);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES
('Sofia', 'Lopez', '0000000884', TO_DATE('2005-02-08', 'YYYY-MM-DD'), '3000000884', 'sofia.lopez0884@bz.com', TO_DATE('2025-08-04', 'YYYY-MM-DD'), 24, 8);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES
('Carlos', 'Gomez', '0000000885', TO_DATE('2003-06-30', 'YYYY-MM-DD'), '3000000885', 'carlos.gomez0885@service.com', TO_DATE('2026-03-24', 'YYYY-MM-DD'), 24, 4);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES
('Daniela', 'Moreno', '0000000886', TO_DATE('2002-06-11', 'YYYY-MM-DD'), '3000000886', 'daniela.moreno0886@webmail.com', TO_DATE('2026-06-27', 'YYYY-MM-DD'), 24, 3);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES
('Felipe', 'Lopez', '0000000887', TO_DATE('2004-05-04', 'YYYY-MM-DD'), '3000000887', 'felipe.lopez0887@webmail.com', TO_DATE('2026-02-04', 'YYYY-MM-DD'), 24, 6);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES
('Mariana', 'Gomez', '0000000888', TO_DATE('1995-12-20', 'YYYY-MM-DD'), '3000000888', 'mariana.gomez0888@bz.com', TO_DATE('2025-09-03', 'YYYY-MM-DD'), 24, 3);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES
('Carlos', 'Moreno', '0000000889', TO_DATE('2002-06-17', 'YYYY-MM-DD'), '3000000889', 'carlos.moreno0889@bz.com', TO_DATE('2026-07-04', 'YYYY-MM-DD'), 24, 7);

-- Cliente sede 25
INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES
('Sofia', 'Rodriguez', '0000000890', TO_DATE('2001-01-15', 'YYYY-MM-DD'), '3000000890', 'sofia.rodriguez0890@webmail.com', TO_DATE('2026-01-23', 'YYYY-MM-DD'), 25, 5);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES
('Daniela', 'Sanchez', '0000000891', TO_DATE('2005-01-16', 'YYYY-MM-DD'), '3000000891', 'daniela.sanchez0891@service.com', TO_DATE('2026-10-27', 'YYYY-MM-DD'), 25, 7);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES
('Juan', 'Fernandez', '0000000892', TO_DATE('2003-05-05', 'YYYY-MM-DD'), '3000000892', 'juan.fernandez0892@bz.com', TO_DATE('2026-06-17', 'YYYY-MM-DD'), 25, 4);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES
('Daniela', 'Garcia', '0000000893', TO_DATE('2005-03-07', 'YYYY-MM-DD'), '3000000893', 'daniela.garcia0893@service.com', TO_DATE('2025-11-14', 'YYYY-MM-DD'), 25, 9);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES
('Andres', 'Lopez', '0000000894', TO_DATE('2003-08-27', 'YYYY-MM-DD'), '3000000894', 'andres.lopez0894@service.com', TO_DATE('2026-03-14', 'YYYY-MM-DD'), 25, 3);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES
('Camila', 'Lopez', '0000000895', TO_DATE('2001-06-21', 'YYYY-MM-DD'), '3000000895', 'camila.lopez0895@mail.com', TO_DATE('2025-10-21', 'YYYY-MM-DD'), 25, 8);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES
('Mariana', 'Gomez', '0000000896', TO_DATE('1996-05-22', 'YYYY-MM-DD'), '3000000896', 'mariana.gomez0896@webmail.com', TO_DATE('2026-10-15', 'YYYY-MM-DD'), 25, 3);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES
('Camila', 'Martinez', '0000000897', TO_DATE('1997-04-01', 'YYYY-MM-DD'), '3000000897', 'camila.martinez0897@bz.com', TO_DATE('2026-10-27', 'YYYY-MM-DD'), 25, 8);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES
('Jose', 'Rodriguez', '0000000898', TO_DATE('2001-06-08', 'YYYY-MM-DD'), '3000000898', 'jose.rodriguez0898@bz.com', TO_DATE('2026-08-24', 'YYYY-MM-DD'), 25, 6);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES
('Daniela', 'Lopez', '0000000899', TO_DATE('2002-11-05', 'YYYY-MM-DD'), '3000000899', 'daniela.lopez0899@webmail.com', TO_DATE('2026-12-08', 'YYYY-MM-DD'), 25, 3);

-- Cliente sede 26
INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES
('Sofia', 'Torres', '0000000900', TO_DATE('2001-02-04', 'YYYY-MM-DD'), '3000000900', 'sofia.torres0900@mail.com', TO_DATE('2025-05-20', 'YYYY-MM-DD'), 26, 10);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES
('Laura', 'Pérez', '0000000901', TO_DATE('2002-04-15', 'YYYY-MM-DD'), '3000000901', 'laura.pérez0901@webmail.com', TO_DATE('2026-11-23', 'YYYY-MM-DD'), 26, 4);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES
('Jose', 'Sanchez', '0000000902', TO_DATE('2004-08-25', 'YYYY-MM-DD'), '3000000902', 'jose.sanchez0902@bz.com', TO_DATE('2026-08-04', 'YYYY-MM-DD'), 26, 10);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES
('Carlos', 'Moreno', '0000000903', TO_DATE('1997-12-06', 'YYYY-MM-DD'), '3000000903', 'carlos.moreno0903@bz.com', TO_DATE('2025-08-31', 'YYYY-MM-DD'), 26, 10);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES
('Sofia', 'Fernandez', '0000000904', TO_DATE('1997-07-27', 'YYYY-MM-DD'), '3000000904', 'sofia.fernandez0904@webmail.com', TO_DATE('2025-05-18', 'YYYY-MM-DD'), 26, 5);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES
('Carlos', 'Garcia', '0000000905', TO_DATE('1996-04-12', 'YYYY-MM-DD'), '3000000905', 'carlos.garcia0905@service.com', TO_DATE('2026-09-30', 'YYYY-MM-DD'), 26, 8);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES
('Carlos', 'Rodriguez', '0000000906', TO_DATE('2001-12-30', 'YYYY-MM-DD'), '3000000906', 'carlos.rodriguez0906@webmail.com', TO_DATE('2025-08-14', 'YYYY-MM-DD'), 26, 9);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES
('Mariana', 'Pérez', '0000000907', TO_DATE('2000-04-07', 'YYYY-MM-DD'), '3000000907', 'mariana.pérez0907@webmail.com', TO_DATE('2025-05-25', 'YYYY-MM-DD'), 26, 10);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES
('Laura', 'Garcia', '0000000908', TO_DATE('2000-09-11', 'YYYY-MM-DD'), '3000000908', 'laura.garcia0908@bz.com', TO_DATE('2026-09-15', 'YYYY-MM-DD'), 26, 9);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES
('Laura', 'Torres', '0000000909', TO_DATE('1997-11-28', 'YYYY-MM-DD'), '3000000909', 'laura.torres0909@mail.com', TO_DATE('2025-12-27', 'YYYY-MM-DD'), 26, 1);

-- Cliente sede 27
INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES
('Daniela', 'Pérez', '0000000910', TO_DATE('1999-10-26', 'YYYY-MM-DD'), '3000000910', 'daniela.pérez0910@webmail.com', TO_DATE('2026-03-30', 'YYYY-MM-DD'), 27, 1);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES
('Felipe', 'Fernandez', '0000000911', TO_DATE('2002-06-17', 'YYYY-MM-DD'), '3000000911', 'felipe.fernandez0911@mail.com', TO_DATE('2025-10-26', 'YYYY-MM-DD'), 27, 6);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES
('Camila', 'Moreno', '0000000912', TO_DATE('2005-01-20', 'YYYY-MM-DD'), '3000000912', 'camila.moreno0912@bz.com', TO_DATE('2025-08-13', 'YYYY-MM-DD'), 27, 9);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES
('Laura', 'Torres', '0000000913', TO_DATE('1998-04-09', 'YYYY-MM-DD'), '3000000913', 'laura.torres0913@bz.com', TO_DATE('2025-07-01', 'YYYY-MM-DD'), 27, 3);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES
('Camila', 'Sanchez', '0000000914', TO_DATE('2001-01-27', 'YYYY-MM-DD'), '3000000914', 'camila.sanchez0914@mail.com', TO_DATE('2026-11-01', 'YYYY-MM-DD'), 27, 4);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES
('Daniela', 'Lopez', '0000000915', TO_DATE('1996-10-05', 'YYYY-MM-DD'), '3000000915', 'daniela.lopez0915@service.com', TO_DATE('2025-09-02', 'YYYY-MM-DD'), 27, 3);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES
('Andres', 'Garcia', '0000000916', TO_DATE('1994-09-25', 'YYYY-MM-DD'), '3000000916', 'andres.garcia0916@service.com', TO_DATE('2026-03-16', 'YYYY-MM-DD'), 27, 7);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES
('Mariana', 'Gomez', '0000000917', TO_DATE('2002-06-27', 'YYYY-MM-DD'), '3000000917', 'mariana.gomez0917@mail.com', TO_DATE('2026-01-31', 'YYYY-MM-DD'), 27, 1);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES
('Laura', 'Lopez', '0000000918', TO_DATE('2002-06-07', 'YYYY-MM-DD'), '3000000918', 'laura.lopez0918@bz.com', TO_DATE('2025-10-03', 'YYYY-MM-DD'), 27, 5);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES
('Laura', 'Pérez', '0000000919', TO_DATE('1998-05-06', 'YYYY-MM-DD'), '3000000919', 'laura.pérez0919@mail.com', TO_DATE('2026-01-05', 'YYYY-MM-DD'), 27, 10);

-- Cliente sede 28
INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES
('Sofia', 'Pérez', '0000000920', TO_DATE('2005-07-08', 'YYYY-MM-DD'), '3000000920', 'sofia.pérez0920@webmail.com', TO_DATE('2026-01-23', 'YYYY-MM-DD'), 28, 10);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES
('Camila', 'Pérez', '0000000921', TO_DATE('1998-01-31', 'YYYY-MM-DD'), '3000000921', 'camila.pérez0921@webmail.com', TO_DATE('2026-09-30', 'YYYY-MM-DD'), 28, 10);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES
('Sofia', 'Moreno', '0000000922', TO_DATE('1999-11-30', 'YYYY-MM-DD'), '3000000922', 'sofia.moreno0922@mail.com', TO_DATE('2026-08-28', 'YYYY-MM-DD'), 28, 4);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES
('Juan', 'Torres', '0000000923', TO_DATE('2003-06-11', 'YYYY-MM-DD'), '3000000923', 'juan.torres0923@mail.com', TO_DATE('2026-07-29', 'YYYY-MM-DD'), 28, 3);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES
('Daniela', 'Fernandez', '0000000924', TO_DATE('1996-04-23', 'YYYY-MM-DD'), '3000000924', 'daniela.fernandez0924@bz.com', TO_DATE('2025-09-14', 'YYYY-MM-DD'), 28, 5);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES
('Daniela', 'Torres', '0000000925', TO_DATE('1998-03-20', 'YYYY-MM-DD'), '3000000925', 'daniela.torres0925@service.com', TO_DATE('2025-11-23', 'YYYY-MM-DD'), 28, 5);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES
('Laura', 'Pérez', '0000000926', TO_DATE('1999-12-15', 'YYYY-MM-DD'), '3000000926', 'laura.pérez0926@service.com', TO_DATE('2026-09-16', 'YYYY-MM-DD'), 28, 6);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES
('Carlos', 'Gomez', '0000000927', TO_DATE('1997-04-19', 'YYYY-MM-DD'), '3000000927', 'carlos.gomez0927@bz.com', TO_DATE('2025-11-06', 'YYYY-MM-DD'), 28, 9);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES
('Sofia', 'Moreno', '0000000928', TO_DATE('1994-12-08', 'YYYY-MM-DD'), '3000000928', 'sofia.moreno0928@bz.com', TO_DATE('2026-03-04', 'YYYY-MM-DD'), 28, 2);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES
('Juan', 'Sanchez', '0000000929', TO_DATE('2002-06-03', 'YYYY-MM-DD'), '3000000929', 'juan.sanchez0929@mail.com', TO_DATE('2025-10-16', 'YYYY-MM-DD'), 28, 2);

-- Cliente sede 29
INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES
('Daniela', 'Torres', '0000000930', TO_DATE('2005-03-30', 'YYYY-MM-DD'), '3000000930', 'daniela.torres0930@bz.com', TO_DATE('2026-12-15', 'YYYY-MM-DD'), 29, 8);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES
('Mariana', 'Sanchez', '0000000931', TO_DATE('2002-02-03', 'YYYY-MM-DD'), '3000000931', 'mariana.sanchez0931@service.com', TO_DATE('2026-07-08', 'YYYY-MM-DD'), 29, 3);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES
('Sofia', 'Fernandez', '0000000932', TO_DATE('1994-12-31', 'YYYY-MM-DD'), '3000000932', 'sofia.fernandez0932@mail.com', TO_DATE('2025-06-03', 'YYYY-MM-DD'), 29, 7);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES
('Camila', 'Moreno', '0000000933', TO_DATE('2002-04-19', 'YYYY-MM-DD'), '3000000933', 'camila.moreno0933@service.com', TO_DATE('2026-09-11', 'YYYY-MM-DD'), 29, 4);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES
('Andres', 'Lopez', '0000000934', TO_DATE('2005-12-07', 'YYYY-MM-DD'), '3000000934', 'andres.lopez0934@webmail.com', TO_DATE('2025-10-25', 'YYYY-MM-DD'), 29, 1);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES
('Mariana', 'Lopez', '0000000935', TO_DATE('1998-07-31', 'YYYY-MM-DD'), '3000000935', 'mariana.lopez0935@webmail.com', TO_DATE('2025-11-23', 'YYYY-MM-DD'), 29, 10);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES
('Laura', 'Martinez', '0000000936', TO_DATE('1999-09-05', 'YYYY-MM-DD'), '3000000936', 'laura.martinez0936@webmail.com', TO_DATE('2025-10-30', 'YYYY-MM-DD'), 29, 3);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES
('Sofia', 'Martinez', '0000000937', TO_DATE('2003-07-31', 'YYYY-MM-DD'), '3000000937', 'sofia.martinez0937@mail.com', TO_DATE('2026-11-08', 'YYYY-MM-DD'), 29, 5);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES
('Sofia', 'Pérez', '0000000938', TO_DATE('1998-02-06', 'YYYY-MM-DD'), '3000000938', 'sofia.pérez0938@bz.com', TO_DATE('2025-10-28', 'YYYY-MM-DD'), 29, 7);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES
('Laura', 'Sanchez', '0000000939', TO_DATE('1999-05-27', 'YYYY-MM-DD'), '3000000939', 'laura.sanchez0939@bz.com', TO_DATE('2026-12-01', 'YYYY-MM-DD'), 29, 4);

-- Cliente sede 30
INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES
('Juan', 'Torres', '0000000940', TO_DATE('1995-05-30', 'YYYY-MM-DD'), '3000000940', 'juan.torres0940@webmail.com', TO_DATE('2025-10-28', 'YYYY-MM-DD'), 30, 1);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES
('Laura', 'Lopez', '0000000941', TO_DATE('1997-03-07', 'YYYY-MM-DD'), '3000000941', 'laura.lopez0941@service.com', TO_DATE('2025-08-08', 'YYYY-MM-DD'), 30, 3);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES
('Andres', 'Pérez', '0000000942', TO_DATE('2005-02-22', 'YYYY-MM-DD'), '3000000942', 'andres.pérez0942@bz.com', TO_DATE('2026-06-03', 'YYYY-MM-DD'), 30, 10);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES
('Felipe', 'Lopez', '0000000943', TO_DATE('1998-08-11', 'YYYY-MM-DD'), '3000000943', 'felipe.lopez0943@mail.com', TO_DATE('2026-04-01', 'YYYY-MM-DD'), 30, 1);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES
('Daniela', 'Sanchez', '0000000944', TO_DATE('2005-10-21', 'YYYY-MM-DD'), '3000000944', 'daniela.sanchez0944@mail.com', TO_DATE('2025-09-30', 'YYYY-MM-DD'), 30, 7);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES
('Carlos', 'Rodriguez', '0000000945', TO_DATE('2002-12-17', 'YYYY-MM-DD'), '3000000945', 'carlos.rodriguez0945@webmail.com', TO_DATE('2026-05-15', 'YYYY-MM-DD'), 30, 1);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES
('Juan', 'Gomez', '0000000946', TO_DATE('2002-11-09', 'YYYY-MM-DD'), '3000000946', 'juan.gomez0946@mail.com', TO_DATE('2026-05-20', 'YYYY-MM-DD'), 30, 3);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES
('Laura', 'Moreno', '0000000947', TO_DATE('2001-08-19', 'YYYY-MM-DD'), '3000000947', 'laura.moreno0947@mail.com', TO_DATE('2026-12-15', 'YYYY-MM-DD'), 30, 1);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES
('Felipe', 'Garcia', '0000000948', TO_DATE('2003-01-02', 'YYYY-MM-DD'), '3000000948', 'felipe.garcia0948@service.com', TO_DATE('2026-09-10', 'YYYY-MM-DD'), 30, 3);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES
('Laura', 'Pérez', '0000000949', TO_DATE('1998-01-10', 'YYYY-MM-DD'), '3000000949', 'laura.pérez0949@bz.com', TO_DATE('2026-01-06', 'YYYY-MM-DD'), 30, 7);


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

-- sede 2
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (1, 2, 50.00, 30);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (2, 2, 40.00, 25);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (3, 2, 35.00, 20);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (4, 2, 60.00, 15);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (5, 2, 45.00, 10);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (6, 2, 55.00, 18);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (7, 2, 70.00, 22);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (8, 2, 65.00, 12);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (9, 2, 30.00, 40);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (10, 2, 25.00, 1);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (11, 2, 80.00, 5);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (12, 2, 85.00, 8);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (13, 2, 70.00, 10);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (14, 2, 90.00, 7);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (15, 2, 75.00, 0);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (16, 2, 95.00, 6);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (17, 2, 100.00, 8);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (18, 2, 65.00, 1);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (19, 2, 50.00, 20);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (20, 2, 55.00, 25);

-- sede 3
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (1, 3, 50.00, 30);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (2, 3, 40.00, 25);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (3, 3, 35.00, 20);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (4, 3, 60.00, 15);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (5, 3, 45.00, 10);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (6, 3, 55.00, 18);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (7, 3, 70.00, 22);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (8, 3, 65.00, 12);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (9, 3, 30.00, 40);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (10, 3, 25.00, 1);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (11, 3, 80.00, 5);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (12, 3, 85.00, 8);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (13, 3, 70.00, 10);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (14, 3, 90.00, 7);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (15, 3, 75.00, 0);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (16, 3, 95.00, 6);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (17, 3, 100.00, 8);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (18, 3, 65.00, 1);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (19, 3, 50.00, 20);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (20, 3, 55.00, 25);

-- sede 4
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (1, 4, 50.00, 30);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (2, 4, 40.00, 25);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (3, 4, 35.00, 20);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (4, 4, 60.00, 15);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (5, 4, 45.00, 10);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (6, 4, 55.00, 18);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (7, 4, 70.00, 22);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (8, 4, 65.00, 12);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (9, 4, 30.00, 40);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (10, 4, 25.00, 1);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (11, 4, 80.00, 5);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (12, 4, 85.00, 8);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (13, 4, 70.00, 10);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (14, 4, 90.00, 7);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (15, 4, 75.00, 0);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (16, 4, 95.00, 6);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (17, 4, 100.00, 8);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (18, 4, 65.00, 1);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (19, 4, 50.00, 20);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (20, 4, 55.00, 25);

-- sede 5
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (1, 5, 50.00, 30);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (2, 5, 40.00, 25);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (3, 5, 35.00, 20);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (4, 5, 60.00, 15);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (5, 5, 45.00, 10);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (6, 5, 55.00, 18);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (7, 5, 70.00, 22);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (8, 5, 65.00, 12);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (9, 5, 30.00, 40);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (10, 5, 25.00, 1);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (11, 5, 80.00, 5);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (12, 5, 85.00, 8);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (13, 5, 70.00, 10);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (14, 5, 90.00, 7);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (15, 5, 75.00, 0);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (16, 5, 95.00, 6);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (17, 5, 100.00, 8);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (18, 5, 65.00, 1);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (19, 5, 50.00, 20);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (20, 5, 55.00, 25);

-- sede 6
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (1, 6, 50.00, 30);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (2, 6, 40.00, 25);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (3, 6, 35.00, 20);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (4, 6, 60.00, 15);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (5, 6, 45.00, 10);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (6, 6, 55.00, 18);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (7, 6, 70.00, 22);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (8, 6, 65.00, 12);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (9, 6, 30.00, 40);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (10, 6, 25.00, 1);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (11, 6, 80.00, 5);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (12, 6, 85.00, 8);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (13, 6, 70.00, 10);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (14, 6, 90.00, 7);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (15, 6, 75.00, 0);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (16, 6, 95.00, 6);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (17, 6, 100.00, 8);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (18, 6, 65.00, 1);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (19, 6, 50.00, 20);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (20, 6, 55.00, 25);

-- sede 7
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (1, 7, 50.00, 30);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (2, 7, 40.00, 25);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (3, 7, 35.00, 20);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (4, 7, 60.00, 15);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (5, 7, 45.00, 10);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (6, 7, 55.00, 18);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (7, 7, 70.00, 22);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (8, 7, 65.00, 12);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (9, 7, 30.00, 40);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (10, 7, 25.00, 1);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (11, 7, 80.00, 5);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (12, 7, 85.00, 8);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (13, 7, 70.00, 10);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (14, 7, 90.00, 7);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (15, 7, 75.00, 0);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (16, 7, 95.00, 6);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (17, 7, 100.00, 8);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (18, 7, 65.00, 1);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (19, 7, 50.00, 20);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (20, 7, 55.00, 25);

-- sede 8
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (1, 8, 50.00, 30);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (2, 8, 40.00, 25);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (3, 8, 35.00, 20);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (4, 8, 60.00, 15);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (5, 8, 45.00, 10);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (6, 8, 55.00, 18);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (7, 8, 70.00, 22);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (8, 8, 65.00, 12);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (9, 8, 30.00, 40);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (10, 8, 25.00, 1);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (11, 8, 80.00, 5);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (12, 8, 85.00, 8);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (13, 8, 70.00, 10);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (14, 8, 90.00, 7);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (15, 8, 75.00, 0);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (16, 8, 95.00, 6);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (17, 8, 100.00, 8);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (18, 8, 65.00, 1);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (19, 8, 50.00, 20);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (20, 8, 55.00, 25);

-- sede 9
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (1, 9, 50.00, 20);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (2, 9, 40.00, 15);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (3, 9, 35.00, 20);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (4, 9, 60.00, 15);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (5, 9, 45.00, 8);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (6, 9, 55.00, 1);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (7, 9, 70.00, 21);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (8, 9, 65.00, 10);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (9, 9, 30.00, 30);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (10, 9, 25.00, 2);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (11, 9, 80.00, 5);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (12, 9, 85.00, 8);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (13, 9, 70.00, 2);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (14, 9, 90.00, 25);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (15, 9, 75.00, 0);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (16, 9, 95.00, 6);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (17, 9, 100.00, 8);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (18, 9, 65.00, 1);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (19, 9, 50.00, 20);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (20, 9, 55.00, 25);

-- sede 10
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (1, 10, 50.00, 20);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (2, 10, 40.00, 15);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (3, 10, 35.00, 20);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (4, 10, 60.00, 15);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (5, 10, 45.00, 8);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (6, 10, 55.00, 1);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (7, 10, 70.00, 21);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (8, 10, 65.00, 10);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (9, 10, 30.00, 30);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (10, 10, 25.00, 2);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (11, 10, 80.00, 5);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (12, 10, 85.00, 8);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (13, 10, 70.00, 2);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (14, 10, 90.00, 25);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (15, 10, 75.00, 0);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (16, 10, 95.00, 6);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (17, 10, 100.00, 8);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (18, 10, 65.00, 1);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (19, 10, 50.00, 20);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (20, 10, 55.00, 25);

-- sede 11
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (1, 11, 50.00, 20);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (2, 11, 40.00, 15);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (3, 11, 35.00, 20);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (4, 11, 60.00, 15);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (5, 11, 45.00, 8);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (6, 11, 55.00, 1);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (7, 11, 70.00, 21);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (8, 11, 65.00, 10);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (9, 11, 30.00, 30);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (10, 11, 25.00, 2);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (11, 11, 80.00, 5);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (12, 11, 85.00, 8);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (13, 11, 70.00, 2);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (14, 11, 90.00, 25);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (15, 11, 75.00, 0);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (16, 11, 95.00, 6);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (17, 11, 100.00, 8);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (18, 11, 65.00, 1);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (19, 11, 50.00, 20);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (20, 11, 55.00, 25);

-- sede 12
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (1, 12, 50.00, 20);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (2, 12, 40.00, 15);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (3, 12, 35.00, 20);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (4, 12, 60.00, 15);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (5, 12, 45.00, 8);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (6, 12, 55.00, 1);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (7, 12, 70.00, 21);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (8, 12, 65.00, 10);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (9, 12, 30.00, 30);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (10, 12, 25.00, 2);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (11, 12, 80.00, 5);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (12, 12, 85.00, 8);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (13, 12, 70.00, 2);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (14, 12, 90.00, 25);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (15, 12, 75.00, 0);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (16, 12, 95.00, 6);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (17, 12, 100.00, 8);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (18, 12, 65.00, 1);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (19, 12, 50.00, 20);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (20, 12, 55.00, 25);

-- sede 13
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (1, 13, 50.00, 20);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (2, 13, 40.00, 15);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (3, 13, 35.00, 20);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (4, 13, 60.00, 15);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (5, 13, 45.00, 8);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (6, 13, 55.00, 1);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (7, 13, 70.00, 21);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (8, 13, 65.00, 10);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (9, 13, 30.00, 30);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (10, 13, 25.00, 2);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (11, 13, 80.00, 5);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (12, 13, 85.00, 8);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (13, 13, 70.00, 2);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (14, 13, 90.00, 25);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (15, 13, 75.00, 0);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (16, 13, 95.00, 6);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (17, 13, 100.00, 8);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (18, 13, 65.00, 1);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (19, 13, 50.00, 20);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (20, 13, 55.00, 25);

-- sede 14
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (1, 14, 50.00, 20);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (2, 14, 40.00, 15);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (3, 14, 35.00, 20);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (4, 14, 60.00, 15);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (5, 14, 45.00, 8);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (6, 14, 55.00, 1);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (7, 14, 70.00, 21);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (8, 14, 65.00, 10);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (9, 14, 30.00, 30);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (10, 14, 25.00, 2);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (11, 14, 80.00, 5);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (12, 14, 85.00, 8);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (13, 14, 70.00, 2);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (14, 14, 90.00, 25);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (15, 14, 75.00, 0);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (16, 14, 95.00, 6);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (17, 14, 100.00, 8);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (18, 14, 65.00, 1);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (19, 14, 50.00, 20);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (20, 14, 55.00, 25);

-- sede 15
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (1, 15, 50.00, 20);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (2, 15, 40.00, 15);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (3, 15, 35.00, 20);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (4, 15, 60.00, 15);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (5, 15, 45.00, 8);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (6, 15, 55.00, 1);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (7, 15, 70.00, 21);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (8, 15, 65.00, 10);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (9, 15, 30.00, 30);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (10, 15, 25.00, 2);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (11, 15, 80.00, 5);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (12, 15, 85.00, 8);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (13, 15, 70.00, 2);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (14, 15, 90.00, 25);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (15, 15, 75.00, 0);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (16, 15, 95.00, 6);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (17, 15, 100.00, 8);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (18, 15, 65.00, 1);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (19, 15, 50.00, 20);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (20, 15, 55.00, 25);

-- sede 16
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (1, 16, 50.00, 0);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (2, 16, 40.00, 24);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (3, 16, 35.00, 20);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (4, 16, 60.00, 15);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (5, 16, 45.00, 8);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (6, 16, 55.00, 1);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (7, 16, 70.00, 5);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (8, 16, 65.00, 10);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (9, 16, 30.00, 30);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (10, 16, 25.00, 2);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (11, 16, 80.00, 30);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (12, 16, 85.00, 8);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (13, 16, 70.00, 2);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (14, 16, 90.00, 25);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (15, 16, 75.00, 0);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (16, 16, 95.00, 6);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (17, 16, 100.00, 8);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (18, 16, 65.00, 7);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (19, 16, 50.00, 9);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (20, 16, 55.00, 12);

-- sede 17
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (1, 17, 50.00, 0);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (2, 17, 40.00, 24);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (3, 17, 35.00, 20);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (4, 17, 60.00, 15);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (5, 17, 45.00, 8);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (6, 17, 55.00, 1);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (7, 17, 70.00, 5);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (8, 17, 65.00, 10);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (9, 17, 30.00, 30);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (10, 17, 25.00, 2);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (11, 17, 80.00, 30);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (12, 17, 85.00, 8);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (13, 17, 70.00, 2);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (14, 17, 90.00, 25);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (15, 17, 75.00, 0);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (16, 17, 95.00, 6);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (17, 17, 100.00, 8);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (18, 17, 65.00, 7);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (19, 17, 50.00, 9);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (20, 17, 55.00, 12);

-- sede 18
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (1, 18, 50.00, 0);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (2, 18, 40.00, 24);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (3, 18, 35.00, 20);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (4, 18, 60.00, 15);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (5, 18, 45.00, 8);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (6, 18, 55.00, 1);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (7, 18, 70.00, 5);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (8, 18, 65.00, 10);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (9, 18, 30.00, 30);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (10, 18, 25.00, 2);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (11, 18, 80.00, 30);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (12, 18, 85.00, 8);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (13, 18, 70.00, 2);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (14, 18, 90.00, 25);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (15, 18, 75.00, 0);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (16, 18, 95.00, 6);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (17, 18, 100.00, 8);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (18, 18, 65.00, 7);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (19, 18, 50.00, 9);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (20, 18, 55.00, 12);

-- sede 19
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (1, 19, 50.00, 0);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (2, 19, 40.00, 24);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (3, 19, 35.00, 20);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (4, 19, 60.00, 15);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (5, 19, 45.00, 8);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (6, 19, 55.00, 1);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (7, 19, 70.00, 5);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (8, 19, 65.00, 10);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (9, 19, 30.00, 30);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (10, 19, 25.00, 2);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (11, 19, 80.00, 30);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (12, 19, 85.00, 8);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (13, 19, 70.00, 2);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (14, 19, 90.00, 25);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (15, 19, 75.00, 0);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (16, 19, 95.00, 6);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (17, 19, 100.00, 8);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (18, 19, 65.00, 7);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (19, 19, 50.00, 9);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (20, 19, 55.00, 12);

-- sede 20
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (1, 20, 50.00, 0);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (2, 20, 40.00, 24);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (3, 20, 35.00, 20);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (4, 20, 60.00, 15);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (5, 20, 45.00, 8);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (6, 20, 55.00, 1);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (7, 20, 70.00, 5);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (8, 20, 65.00, 10);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (9, 20, 30.00, 30);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (10, 20, 25.00, 2);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (11, 20, 80.00, 30);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (12, 20, 85.00, 8);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (13, 20, 70.00, 2);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (14, 20, 90.00, 25);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (15, 20, 75.00, 0);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (16, 20, 95.00, 6);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (17, 20, 100.00, 8);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (18, 20, 65.00, 7);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (19, 20, 50.00, 9);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (20, 20, 55.00, 12);

-- sede 21
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (1, 21, 50.00, 0);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (2, 21, 40.00, 24);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (3, 21, 35.00, 20);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (4, 21, 60.00, 15);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (5, 21, 45.00, 8);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (6, 21, 55.00, 1);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (7, 21, 70.00, 5);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (8, 21, 65.00, 10);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (9, 21, 30.00, 30);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (10, 21, 25.00, 2);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (11, 21, 80.00, 30);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (12, 21, 85.00, 8);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (13, 21, 70.00, 2);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (14, 21, 90.00, 25);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (15, 21, 75.00, 0);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (16, 21, 95.00, 6);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (17, 21, 100.00, 8);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (18, 21, 65.00, 7);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (19, 21, 50.00, 9);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (20, 21, 55.00, 12);

-- sede 22
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (1, 22, 50.00, 0);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (2, 22, 40.00, 24);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (3, 22, 35.00, 20);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (4, 22, 60.00, 15);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (5, 22, 45.00, 8);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (6, 22, 55.00, 1);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (7, 22, 70.00, 5);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (8, 22, 65.00, 10);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (9, 22, 30.00, 30);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (10, 22, 25.00, 2);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (11, 22, 80.00, 30);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (12, 22, 85.00, 8);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (13, 22, 70.00, 2);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (14, 22, 90.00, 25);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (15, 22, 75.00, 0);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (16, 22, 95.00, 6);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (17, 22, 100.00, 8);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (18, 22, 65.00, 7);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (19, 22, 50.00, 9);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (20, 22, 55.00, 12);

-- sede 23
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (1, 23, 50.00, 0);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (2, 23, 40.00, 24);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (3, 23, 35.00, 20);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (4, 23, 60.00, 15);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (5, 23, 45.00, 8);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (6, 23, 55.00, 1);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (7, 23, 70.00, 5);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (8, 23, 65.00, 10);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (9, 23, 30.00, 30);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (10, 23, 25.00, 2);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (11, 23, 80.00, 30);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (12, 23, 85.00, 8);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (13, 23, 70.00, 2);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (14, 23, 90.00, 25);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (15, 23, 75.00, 0);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (16, 23, 95.00, 6);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (17, 23, 100.00, 8);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (18, 23, 65.00, 7);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (19, 23, 50.00, 9);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (20, 23, 55.00, 12);

-- sede 24
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (1, 24, 50.00, 0);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (2, 24, 40.00, 24);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (3, 24, 35.00, 20);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (4, 24, 60.00, 15);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (5, 24, 45.00, 8);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (6, 24, 55.00, 1);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (7, 24, 70.00, 5);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (8, 24, 65.00, 10);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (9, 24, 30.00, 30);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (10, 24, 25.00, 2);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (11, 24, 80.00, 30);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (12, 24, 85.00, 8);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (13, 24, 70.00, 2);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (14, 24, 90.00, 25);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (15, 24, 75.00, 0);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (16, 24, 95.00, 6);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (17, 24, 100.00, 8);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (18, 24, 65.00, 7);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (19, 24, 50.00, 9);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (20, 24, 55.00, 12);

-- sede 25
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (1, 25, 50.00, 0);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (2, 25, 40.00, 24);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (3, 25, 35.00, 20);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (4, 25, 60.00, 15);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (5, 25, 45.00, 8);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (6, 25, 55.00, 1);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (7, 25, 70.00, 5);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (8, 25, 65.00, 10);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (9, 25, 30.00, 30);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (10, 25, 25.00, 2);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (11, 25, 80.00, 30);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (12, 25, 85.00, 8);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (13, 25, 70.00, 2);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (14, 25, 90.00, 25);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (15, 25, 75.00, 0);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (16, 25, 95.00, 6);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (17, 25, 100.00, 8);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (18, 25, 65.00, 7);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (19, 25, 50.00, 9);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (20, 25, 55.00, 12);

-- sede 26
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (1, 26, 50.00, 30);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (2, 26, 40.00, 25);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (3, 26, 35.00, 20);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (4, 26, 60.00, 15);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (5, 26, 45.00, 10);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (6, 26, 55.00, 18);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (7, 26, 70.00, 22);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (8, 26, 65.00, 12);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (9, 26, 30.00, 40);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (10, 26, 25.00, 1);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (11, 26, 80.00, 5);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (12, 26, 85.00, 8);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (13, 26, 70.00, 10);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (14, 26, 90.00, 7);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (15, 26, 75.00, 0);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (16, 26, 95.00, 6);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (17, 26, 100.00, 8);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (18, 26, 65.00, 1);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (19, 26, 50.00, 20);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (20, 26, 55.00, 25);

-- sede 27
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (1, 27, 50.00, 30);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (2, 27, 40.00, 25);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (3, 27, 35.00, 20);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (4, 27, 60.00, 15);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (5, 27, 45.00, 10);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (6, 27, 55.00, 18);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (7, 27, 70.00, 22);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (8, 27, 65.00, 12);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (9, 27, 30.00, 40);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (10, 27, 25.00, 1);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (11, 27, 80.00, 5);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (12, 27, 85.00, 8);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (13, 27, 70.00, 10);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (14, 27, 90.00, 7);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (15, 27, 75.00, 0);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (16, 27, 95.00, 6);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (17, 27, 100.00, 8);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (18, 27, 65.00, 1);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (19, 27, 50.00, 20);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (20, 27, 55.00, 25);

-- sede 28
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (1, 28, 50.00, 30);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (2, 28, 40.00, 25);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (3, 28, 35.00, 20);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (4, 28, 60.00, 15);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (5, 28, 45.00, 10);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (6, 28, 55.00, 18);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (7, 28, 70.00, 22);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (8, 28, 65.00, 12);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (9, 28, 30.00, 40);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (10, 28, 25.00, 1);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (11, 28, 80.00, 5);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (12, 28, 85.00, 8);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (13, 28, 70.00, 10);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (14, 28, 90.00, 7);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (15, 28, 75.00, 0);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (16, 28, 95.00, 6);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (17, 28, 100.00, 8);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (18, 28, 65.00, 1);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (19, 28, 50.00, 20);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (20, 28, 55.00, 25);

-- sede 29
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (1, 29, 50.00, 30);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (2, 29, 40.00, 25);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (3, 29, 35.00, 20);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (4, 29, 60.00, 15);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (5, 29, 45.00, 10);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (6, 29, 55.00, 18);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (7, 29, 70.00, 22);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (8, 29, 65.00, 12);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (9, 29, 30.00, 40);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (10, 29, 25.00, 1);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (11, 29, 80.00, 5);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (12, 29, 85.00, 8);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (13, 29, 70.00, 10);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (14, 29, 90.00, 7);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (15, 29, 75.00, 0);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (16, 29, 95.00, 6);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (17, 29, 100.00, 8);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (18, 29, 65.00, 1);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (19, 29, 50.00, 20);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (20, 29, 55.00, 25);

-- sede 30
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (1, 30, 50.00, 30);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (2, 30, 40.00, 25);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (3, 30, 35.00, 20);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (4, 30, 60.00, 15);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (5, 30, 45.00, 10);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (6, 30, 55.00, 18);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (7, 30, 70.00, 22);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (8, 30, 65.00, 12);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (9, 30, 30.00, 40);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (10, 30, 25.00, 1);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (11, 30, 80.00, 5);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (12, 30, 85.00, 8);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (13, 30, 70.00, 10);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (14, 30, 90.00, 7);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (15, 30, 75.00, 0);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (16, 30, 95.00, 6);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (17, 30, 100.00, 8);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (18, 30, 65.00, 1);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (19, 30, 50.00, 20);
INSERT INTO productos_sede (id_producto, id_sede, precio, stock) VALUES (20, 30, 55.00, 25);
-----------------------------------------------------
-----------------------------------------------------


-----------------------------------------------------
-----------------------------------------------------
--historial de visitas

--clientes sede 1 que también puden vivistar otras sedes
--cliente 1
INSERT INTO historial_visitas (id_cliente, id_sede, fecha_hora) 
VALUES (1, 1, TO_DATE('2024-09-01 10:30:00', 'YYYY-MM-DD HH24:MI:SS'));

INSERT INTO historial_visitas (id_cliente, id_sede, fecha_hora) 
VALUES (1, 1, TO_DATE('2024-09-02 10:30:00', 'YYYY-MM-DD HH24:MI:SS'));

INSERT INTO historial_visitas (id_cliente, id_sede, fecha_hora) 
VALUES (1, 1, TO_DATE('2024-09-03 10:30:00', 'YYYY-MM-DD HH24:MI:SS'));

INSERT INTO historial_visitas (id_cliente, id_sede, fecha_hora) 
VALUES (1, 1, TO_DATE('2024-09-04 10:30:00', 'YYYY-MM-DD HH24:MI:SS'));

INSERT INTO historial_visitas (id_cliente, id_sede, fecha_hora) 
VALUES (1, 1, TO_DATE('2024-09-05 10:30:00', 'YYYY-MM-DD HH24:MI:SS'));

INSERT INTO historial_visitas (id_cliente, id_sede, fecha_hora) 
VALUES (1, 1, TO_DATE('2024-09-06 11:30:00', 'YYYY-MM-DD HH24:MI:SS'));

INSERT INTO historial_visitas (id_cliente, id_sede, fecha_hora) 
VALUES (1, 2, TO_DATE('2024-09-07 09:30:00', 'YYYY-MM-DD HH24:MI:SS'));

--cliente 2
INSERT INTO historial_visitas (id_cliente, id_sede, fecha_hora) 
VALUES (2, 1, TO_DATE('2024-09-01 10:30:00', 'YYYY-MM-DD HH24:MI:SS'));

INSERT INTO historial_visitas (id_cliente, id_sede, fecha_hora) 
VALUES (2, 1, TO_DATE('2024-09-02 10:30:00', 'YYYY-MM-DD HH24:MI:SS'));

INSERT INTO historial_visitas (id_cliente, id_sede, fecha_hora) 
VALUES (2, 1, TO_DATE('2024-09-03 10:30:00', 'YYYY-MM-DD HH24:MI:SS'));

INSERT INTO historial_visitas (id_cliente, id_sede, fecha_hora) 
VALUES (2, 1, TO_DATE('2024-09-04 10:30:00', 'YYYY-MM-DD HH24:MI:SS'));

INSERT INTO historial_visitas (id_cliente, id_sede, fecha_hora) 
VALUES (2, 1, TO_DATE('2024-09-05 10:30:00', 'YYYY-MM-DD HH24:MI:SS'));

INSERT INTO historial_visitas (id_cliente, id_sede, fecha_hora) 
VALUES (2, 1, TO_DATE('2024-09-06 11:30:00', 'YYYY-MM-DD HH24:MI:SS'));

INSERT INTO historial_visitas (id_cliente, id_sede, fecha_hora) 
VALUES (2, 2, TO_DATE('2024-09-07 09:30:00', 'YYYY-MM-DD HH24:MI:SS'));

-- cliente 3
INSERT INTO historial_visitas (id_cliente, id_sede, fecha_hora) 
VALUES (3, 1, TO_DATE('2024-09-01 10:30:00', 'YYYY-MM-DD HH24:MI:SS'));

INSERT INTO historial_visitas (id_cliente, id_sede, fecha_hora) 
VALUES (3, 1, TO_DATE('2024-09-02 10:30:00', 'YYYY-MM-DD HH24:MI:SS'));

INSERT INTO historial_visitas (id_cliente, id_sede, fecha_hora) 
VALUES (3, 1, TO_DATE('2024-09-03 10:30:00', 'YYYY-MM-DD HH24:MI:SS'));

INSERT INTO historial_visitas (id_cliente, id_sede, fecha_hora) 
VALUES (3, 1, TO_DATE('2024-09-04 10:30:00', 'YYYY-MM-DD HH24:MI:SS'));

INSERT INTO historial_visitas (id_cliente, id_sede, fecha_hora) 
VALUES (3, 1, TO_DATE('2024-09-05 10:30:00', 'YYYY-MM-DD HH24:MI:SS'));

INSERT INTO historial_visitas (id_cliente, id_sede, fecha_hora) 
VALUES (3, 2, TO_DATE('2024-09-07 09:30:00', 'YYYY-MM-DD HH24:MI:SS'));

--cliente 4
INSERT INTO historial_visitas (id_cliente, id_sede, fecha_hora) 
VALUES (4, 1, TO_DATE('2024-09-01 10:30:00', 'YYYY-MM-DD HH24:MI:SS'));

INSERT INTO historial_visitas (id_cliente, id_sede, fecha_hora) 
VALUES (4, 1, TO_DATE('2024-09-02 10:30:00', 'YYYY-MM-DD HH24:MI:SS'));

INSERT INTO historial_visitas (id_cliente, id_sede, fecha_hora) 
VALUES (4, 1, TO_DATE('2024-09-03 10:30:00', 'YYYY-MM-DD HH24:MI:SS'));

INSERT INTO historial_visitas (id_cliente, id_sede, fecha_hora) 
VALUES (4, 1, TO_DATE('2024-09-04 10:30:00', 'YYYY-MM-DD HH24:MI:SS'));

INSERT INTO historial_visitas (id_cliente, id_sede, fecha_hora) 
VALUES (4, 1, TO_DATE('2024-09-05 10:30:00', 'YYYY-MM-DD HH24:MI:SS'));

INSERT INTO historial_visitas (id_cliente, id_sede, fecha_hora) 
VALUES (4, 2, TO_DATE('2024-09-07 09:30:00', 'YYYY-MM-DD HH24:MI:SS'));

INSERT INTO historial_visitas (id_cliente, id_sede, fecha_hora) 
VALUES (4, 2, TO_DATE('2024-09-08 09:30:00', 'YYYY-MM-DD HH24:MI:SS'));

--cleinte 5
INSERT INTO historial_visitas (id_cliente, id_sede, fecha_hora) 
VALUES (5, 1, TO_DATE('2024-09-01 10:30:00', 'YYYY-MM-DD HH24:MI:SS'));

INSERT INTO historial_visitas (id_cliente, id_sede, fecha_hora) 
VALUES (5, 1, TO_DATE('2024-09-02 10:30:00', 'YYYY-MM-DD HH24:MI:SS'));

INSERT INTO historial_visitas (id_cliente, id_sede, fecha_hora) 
VALUES (5, 1, TO_DATE('2024-09-03 10:30:00', 'YYYY-MM-DD HH24:MI:SS'));

INSERT INTO historial_visitas (id_cliente, id_sede, fecha_hora) 
VALUES (5, 1, TO_DATE('2024-09-04 10:30:00', 'YYYY-MM-DD HH24:MI:SS'));

INSERT INTO historial_visitas (id_cliente, id_sede, fecha_hora) 
VALUES (5, 1, TO_DATE('2024-09-05 10:30:00', 'YYYY-MM-DD HH24:MI:SS'));

INSERT INTO historial_visitas (id_cliente, id_sede, fecha_hora) 
VALUES (5, 2, TO_DATE('2024-09-07 09:30:00', 'YYYY-MM-DD HH24:MI:SS'));

INSERT INTO historial_visitas (id_cliente, id_sede, fecha_hora) 
VALUES (5, 2, TO_DATE('2024-09-08 09:30:00', 'YYYY-MM-DD HH24:MI:SS'));

--cleinte 6
INSERT INTO historial_visitas (id_cliente, id_sede, fecha_hora) 
VALUES (6, 1, TO_DATE('2024-09-01 10:30:00', 'YYYY-MM-DD HH24:MI:SS'));

INSERT INTO historial_visitas (id_cliente, id_sede, fecha_hora) 
VALUES (6, 1, TO_DATE('2024-09-02 10:30:00', 'YYYY-MM-DD HH24:MI:SS'));

INSERT INTO historial_visitas (id_cliente, id_sede, fecha_hora) 
VALUES (6, 1, TO_DATE('2024-09-03 10:30:00', 'YYYY-MM-DD HH24:MI:SS'));

INSERT INTO historial_visitas (id_cliente, id_sede, fecha_hora) 
VALUES (6, 1, TO_DATE('2024-09-04 10:30:00', 'YYYY-MM-DD HH24:MI:SS'));

INSERT INTO historial_visitas (id_cliente, id_sede, fecha_hora) 
VALUES (6, 1, TO_DATE('2024-09-05 10:30:00', 'YYYY-MM-DD HH24:MI:SS'));

INSERT INTO historial_visitas (id_cliente, id_sede, fecha_hora) 
VALUES (6, 2, TO_DATE('2024-09-07 09:30:00', 'YYYY-MM-DD HH24:MI:SS'));

INSERT INTO historial_visitas (id_cliente, id_sede, fecha_hora) 
VALUES (6, 2, TO_DATE('2024-09-08 09:30:00', 'YYYY-MM-DD HH24:MI:SS'));


--cleinte 6
INSERT INTO historial_visitas (id_cliente, id_sede, fecha_hora) 
VALUES (6, 1, TO_DATE('2024-09-01 10:30:00', 'YYYY-MM-DD HH24:MI:SS'));

INSERT INTO historial_visitas (id_cliente, id_sede, fecha_hora) 
VALUES (6, 1, TO_DATE('2024-09-02 10:30:00', 'YYYY-MM-DD HH24:MI:SS'));

INSERT INTO historial_visitas (id_cliente, id_sede, fecha_hora) 
VALUES (6, 1, TO_DATE('2024-09-03 10:30:00', 'YYYY-MM-DD HH24:MI:SS'));

INSERT INTO historial_visitas (id_cliente, id_sede, fecha_hora) 
VALUES (6, 1, TO_DATE('2024-09-04 10:30:00', 'YYYY-MM-DD HH24:MI:SS'));

INSERT INTO historial_visitas (id_cliente, id_sede, fecha_hora) 
VALUES (6, 1, TO_DATE('2024-09-05 10:30:00', 'YYYY-MM-DD HH24:MI:SS'));

INSERT INTO historial_visitas (id_cliente, id_sede, fecha_hora) 
VALUES (6, 2, TO_DATE('2024-09-07 09:30:00', 'YYYY-MM-DD HH24:MI:SS'));

INSERT INTO historial_visitas (id_cliente, id_sede, fecha_hora) 
VALUES (6, 2, TO_DATE('2024-09-08 09:30:00', 'YYYY-MM-DD HH24:MI:SS'));

--cleinte 7
INSERT INTO historial_visitas (id_cliente, id_sede, fecha_hora) 
VALUES (7, 1, TO_DATE('2024-09-01 11:30:00', 'YYYY-MM-DD HH24:MI:SS'));

INSERT INTO historial_visitas (id_cliente, id_sede, fecha_hora) 
VALUES (7, 1, TO_DATE('2024-09-02 11:30:00', 'YYYY-MM-DD HH24:MI:SS'));

INSERT INTO historial_visitas (id_cliente, id_sede, fecha_hora) 
VALUES (7, 1, TO_DATE('2024-09-03 12:30:00', 'YYYY-MM-DD HH24:MI:SS'));

INSERT INTO historial_visitas (id_cliente, id_sede, fecha_hora) 
VALUES (7, 1, TO_DATE('2024-09-04 12:30:00', 'YYYY-MM-DD HH24:MI:SS'));

INSERT INTO historial_visitas (id_cliente, id_sede, fecha_hora) 
VALUES (7, 2, TO_DATE('2024-09-08 13:30:00', 'YYYY-MM-DD HH24:MI:SS'));

--cleinte 8
INSERT INTO historial_visitas (id_cliente, id_sede, fecha_hora) 
VALUES (8, 1, TO_DATE('2024-09-01 11:30:00', 'YYYY-MM-DD HH24:MI:SS'));

INSERT INTO historial_visitas (id_cliente, id_sede, fecha_hora) 
VALUES (8, 1, TO_DATE('2024-09-02 11:30:00', 'YYYY-MM-DD HH24:MI:SS'));

INSERT INTO historial_visitas (id_cliente, id_sede, fecha_hora) 
VALUES (8, 1, TO_DATE('2024-09-03 12:30:00', 'YYYY-MM-DD HH24:MI:SS'));

INSERT INTO historial_visitas (id_cliente, id_sede, fecha_hora) 
VALUES (8, 1, TO_DATE('2024-09-04 12:30:00', 'YYYY-MM-DD HH24:MI:SS'));

INSERT INTO historial_visitas (id_cliente, id_sede, fecha_hora) 
VALUES (8, 2, TO_DATE('2024-09-08 13:30:00', 'YYYY-MM-DD HH24:MI:SS'));

--cleinte 9
INSERT INTO historial_visitas (id_cliente, id_sede, fecha_hora) 
VALUES (9, 1, TO_DATE('2024-09-01 11:30:00', 'YYYY-MM-DD HH24:MI:SS'));

INSERT INTO historial_visitas (id_cliente, id_sede, fecha_hora) 
VALUES (9, 1, TO_DATE('2024-09-02 11:30:00', 'YYYY-MM-DD HH24:MI:SS'));

INSERT INTO historial_visitas (id_cliente, id_sede, fecha_hora) 
VALUES (9, 1, TO_DATE('2024-09-03 12:30:00', 'YYYY-MM-DD HH24:MI:SS'));

INSERT INTO historial_visitas (id_cliente, id_sede, fecha_hora) 
VALUES (9, 1, TO_DATE('2024-09-04 12:30:00', 'YYYY-MM-DD HH24:MI:SS'));

INSERT INTO historial_visitas (id_cliente, id_sede, fecha_hora) 
VALUES (9, 2, TO_DATE('2024-09-08 13:30:00', 'YYYY-MM-DD HH24:MI:SS'));

--cleinte 10
INSERT INTO historial_visitas (id_cliente, id_sede, fecha_hora) 
VALUES (10, 1, TO_DATE('2024-09-01 12:00:00', 'YYYY-MM-DD HH24:MI:SS'));

INSERT INTO historial_visitas (id_cliente, id_sede, fecha_hora) 
VALUES (10, 1, TO_DATE('2024-09-02 12:00:00', 'YYYY-MM-DD HH24:MI:SS'));

INSERT INTO historial_visitas (id_cliente, id_sede, fecha_hora) 
VALUES (10, 1, TO_DATE('2024-09-03 12:00:00', 'YYYY-MM-DD HH24:MI:SS'));

INSERT INTO historial_visitas (id_cliente, id_sede, fecha_hora) 
VALUES (10, 1, TO_DATE('2024-09-04 12:3}00:00', 'YYYY-MM-DD HH24:MI:SS'));

INSERT INTO historial_visitas (id_cliente, id_sede, fecha_hora) 
VALUES (10, 2, TO_DATE('2024-09-08 12:00:00', 'YYYY-MM-DD HH24:MI:SS'));

INSERT INTO historial_visitas (id_cliente, id_sede, fecha_hora) 
VALUES (10, 3, TO_DATE('2024-09-09 12:00:00', 'YYYY-MM-DD HH24:MI:SS'));

--clientes sede 2 que también puden vivistar otras sedes (clientes 11 al 19)
--cliente 11
INSERT INTO historial_visitas (id_cliente, id_sede, fecha_hora) 
VALUES (11, 2, TO_DATE('2024-09-01 10:30:00', 'YYYY-MM-DD HH24:MI:SS'));

INSERT INTO historial_visitas (id_cliente, id_sede, fecha_hora) 
VALUES (11, 2, TO_DATE('2024-09-02 10:30:00', 'YYYY-MM-DD HH24:MI:SS'));

INSERT INTO historial_visitas (id_cliente, id_sede, fecha_hora) 
VALUES (11, 2, TO_DATE('2024-09-03 10:30:00', 'YYYY-MM-DD HH24:MI:SS'));

INSERT INTO historial_visitas (id_cliente, id_sede, fecha_hora) 
VALUES (11, 2, TO_DATE('2024-09-04 10:30:00', 'YYYY-MM-DD HH24:MI:SS'));

INSERT INTO historial_visitas (id_cliente, id_sede, fecha_hora) 
VALUES (11, 1, TO_DATE('2024-09-05 10:30:00', 'YYYY-MM-DD HH24:MI:SS'));

INSERT INTO historial_visitas (id_cliente, id_sede, fecha_hora) 
VALUES (11, 1, TO_DATE('2024-09-06 11:30:00', 'YYYY-MM-DD HH24:MI:SS'));

INSERT INTO historial_visitas (id_cliente, id_sede, fecha_hora) 
VALUES (11, 3, TO_DATE('2024-09-07 09:30:00', 'YYYY-MM-DD HH24:MI:SS'));

--cliente 12
--cliente 13

-----------------------------------------------------
-----------------------------------------------------


-----------------------------------------------------
-----------------------------------------------------
--venta
INSERT INTO venta (id_cliente, id_empleado, total) VALUES (1, 1, 250.00);
INSERT INTO venta (id_cliente, id_empleado, total) VALUES (2, 2, 300.50);
INSERT INTO venta (id_cliente, id_empleado, total) VALUES (3, 3, 450.75);
INSERT INTO venta (id_cliente, id_empleado, total) VALUES (4, 1, 150.25);
INSERT INTO venta (id_cliente, id_empleado, total) VALUES (5, 2, 350.00);
INSERT INTO venta (id_cliente, id_empleado, total) VALUES (6, 3, 600.40);
INSERT INTO venta (id_cliente, id_empleado, total) VALUES (7, 1, 200.60);
INSERT INTO venta (id_cliente, id_empleado, total) VALUES (8, 2, 100.90);
INSERT INTO venta (id_cliente, id_empleado, total) VALUES (9, 3, 120.30);
INSERT INTO venta (id_cliente, id_empleado, total) VALUES (10, 1, 330.20);
INSERT INTO venta (id_cliente, id_empleado, total) VALUES (11, 2, 400.80);
INSERT INTO venta (id_cliente, id_empleado, total) VALUES (12, 3, 175.00);
INSERT INTO venta (id_cliente, id_empleado, total) VALUES (13, 1, 280.45);
INSERT INTO venta (id_cliente, id_empleado, total) VALUES (14, 2, 90.50);
INSERT INTO venta (id_cliente, id_empleado, total) VALUES (15, 3, 220.00);
INSERT INTO venta (id_cliente, id_empleado, total) VALUES (16, 1, 110.20);
INSERT INTO venta (id_cliente, id_empleado, total) VALUES (17, 2, 130.75);
INSERT INTO venta (id_cliente, id_empleado, total) VALUES (18, 3, 145.60);
INSERT INTO venta (id_cliente, id_empleado, total) VALUES (19, 1, 260.30);
INSERT INTO venta (id_cliente, id_empleado, total) VALUES (20, 2, 320.90);
INSERT INTO venta (id_cliente, id_empleado, total) VALUES (21, 3, 280.00);
INSERT INTO venta (id_cliente, id_empleado, total) VALUES (22, 1, 300.25);
INSERT INTO venta (id_cliente, id_empleado, total) VALUES (23, 2, 150.50);
INSERT INTO venta (id_cliente, id_empleado, total) VALUES (24, 3, 400.60);
INSERT INTO venta (id_cliente, id_empleado, total) VALUES (25, 1, 190.75);
INSERT INTO venta (id_cliente, id_empleado, total) VALUES (26, 2, 120.10);
INSERT INTO venta (id_cliente, id_empleado, total) VALUES (27, 3, 170.45);
INSERT INTO venta (id_cliente, id_empleado, total) VALUES (28, 1, 350.00);
INSERT INTO venta (id_cliente, id_empleado, total) VALUES (29, 2, 375.50);
INSERT INTO venta (id_cliente, id_empleado, total) VALUES (30, 3, 215.90);
INSERT INTO venta (id_cliente, id_empleado, total) VALUES (31, 1, 190.00);
INSERT INTO venta (id_cliente, id_empleado, total) VALUES (32, 2, 300.60);
INSERT INTO venta (id_cliente, id_empleado, total) VALUES (33, 3, 240.30);
INSERT INTO venta (id_cliente, id_empleado, total) VALUES (34, 1, 145.20);
INSERT INTO venta (id_cliente, id_empleado, total) VALUES (35, 2, 205.60);
INSERT INTO venta (id_cliente, id_empleado, total) VALUES (36, 3, 180.80);
INSERT INTO venta (id_cliente, id_empleado, total) VALUES (37, 1, 315.00);
INSERT INTO venta (id_cliente, id_empleado, total) VALUES (38, 2, 230.90);
INSERT INTO venta (id_cliente, id_empleado, total) VALUES (39, 3, 160.50);
INSERT INTO venta (id_cliente, id_empleado, total) VALUES (40, 1, 350.75);
INSERT INTO venta (id_cliente, id_empleado, total) VALUES (41, 2, 140.00);
INSERT INTO venta (id_cliente, id_empleado, total) VALUES (42, 3, 130.50);
INSERT INTO venta (id_cliente, id_empleado, total) VALUES (43, 1, 175.00);
INSERT INTO venta (id_cliente, id_empleado, total) VALUES (44, 2, 190.40);
INSERT INTO venta (id_cliente, id_empleado, total) VALUES (45, 3, 225.10);
INSERT INTO venta (id_cliente, id_empleado, total) VALUES (46, 1, 200.30);
INSERT INTO venta (id_cliente, id_empleado, total) VALUES (47, 2, 340.60);
INSERT INTO venta (id_cliente, id_empleado, total) VALUES (48, 3, 210.80);
INSERT INTO venta (id_cliente, id_empleado, total) VALUES (49, 1, 150.90);
INSERT INTO venta (id_cliente, id_empleado, total) VALUES (50, 2, 300.25);
INSERT INTO venta (id_cliente, id_empleado, total) VALUES (51, 3, 280.40);
INSERT INTO venta (id_cliente, id_empleado, total) VALUES (52, 1, 175.50);
INSERT INTO venta (id_cliente, id_empleado, total) VALUES (53, 2, 220.30);
INSERT INTO venta (id_cliente, id_empleado, total) VALUES (54, 3, 195.75);
INSERT INTO venta (id_cliente, id_empleado, total) VALUES (55, 1, 260.60);
INSERT INTO venta (id_cliente, id_empleado, total) VALUES (56, 2, 310.00);
INSERT INTO venta (id_cliente, id_empleado, total) VALUES (57, 3, 290.50);
INSERT INTO venta (id_cliente, id_empleado, total) VALUES (58, 1, 180.20);
INSERT INTO venta (id_cliente, id_empleado, total) VALUES (59, 2, 340.50);
INSERT INTO venta (id_cliente, id_empleado, total) VALUES (60, 3, 360.30);
INSERT INTO venta (id_cliente, id_empleado, total) VALUES (61, 1, 140.40);
INSERT INTO venta (id_cliente, id_empleado, total) VALUES (62, 2, 120.50);
INSERT INTO venta (id_cliente, id_empleado, total) VALUES (63, 3, 200.80);
INSERT INTO venta (id_cliente, id_empleado, total) VALUES (64, 1, 320.20);
INSERT INTO venta (id_cliente, id_empleado, total) VALUES (65, 2, 190.50);
INSERT INTO venta (id_cliente, id_empleado, total) VALUES (66, 3, 260.90);
INSERT INTO venta (id_cliente, id_empleado, total) VALUES (67, 1, 230.80);
INSERT INTO venta (id_cliente, id_empleado, total) VALUES (68, 2, 310.30);
INSERT INTO venta (id_cliente, id_empleado, total) VALUES (69, 3, 250.00);
INSERT INTO venta (id_cliente, id_empleado, total) VALUES (70, 1, 205.60);
INSERT INTO venta (id_cliente, id_empleado, total) VALUES (71, 2, 215.50);
INSERT INTO venta (id_cliente, id_empleado, total) VALUES (72, 3, 190.70);
INSERT INTO venta (id_cliente, id_empleado, total) VALUES (73, 1, 290.00);
INSERT INTO venta (id_cliente, id_empleado, total) VALUES (74, 2, 310.80);
INSERT INTO venta (id_cliente, id_empleado, total) VALUES (75, 3, 315.00);
INSERT INTO venta (id_cliente, id_empleado, total) VALUES (76, 1, 400.25);
INSERT INTO venta (id_cliente, id_empleado, total) VALUES (77, 2, 225.10);
INSERT INTO venta (id_cliente, id_empleado, total) VALUES (78, 3, 350.60);
INSERT INTO venta (id_cliente, id_empleado, total) VALUES (79, 1, 475.80);
INSERT INTO venta (id_cliente, id_empleado, total) VALUES (80, 2, 490.25);
INSERT INTO venta (id_cliente, id_empleado, total) VALUES (81, 3, 510.50);
INSERT INTO venta (id_cliente, id_empleado, total) VALUES (82, 1, 600.00);
INSERT INTO venta (id_cliente, id_empleado, total) VALUES (83, 2, 630.75);
INSERT INTO venta (id_cliente, id_empleado, total) VALUES (84, 3, 650.40);
INSERT INTO venta (id_cliente, id_empleado, total) VALUES (85, 1, 700.20);
INSERT INTO venta (id_cliente, id_empleado, total) VALUES (86, 2, 750.90);
INSERT INTO venta (id_cliente, id_empleado, total) VALUES (87, 7, 340.50);  
INSERT INTO venta (id_cliente, id_empleado, total) VALUES (88, 8, 250.75); 
INSERT INTO venta (id_cliente, id_empleado, total) VALUES (89, 9, 310.20);  
INSERT INTO venta (id_cliente, id_empleado, total) VALUES (90, 10, 400.00)
INSERT INTO venta (id_cliente, id_empleado, total) VALUES (91, 11, 150.80); 
INSERT INTO venta (id_cliente, id_empleado, total) VALUES (92, 12, 285.10);  
INSERT INTO venta (id_cliente, id_empleado, total) VALUES (93, 13, 370.30);  
INSERT INTO venta (id_cliente, id_empleado, total) VALUES (94, 14, 490.00); 
INSERT INTO venta (id_cliente, id_empleado, total) VALUES (95, 15, 540.50); 
INSERT INTO venta (id_cliente, id_empleado, total) VALUES (96, 16, 660.20); 
INSERT INTO venta (id_cliente, id_empleado, total) VALUES (97, 17, 320.75); 
INSERT INTO venta (id_cliente, id_empleado, total) VALUES (98, 18, 275.40); 
INSERT INTO venta (id_cliente, id_empleado, total) VALUES (99, 19, 450.80); 
INSERT INTO venta (id_cliente, id_empleado, total) VALUES (100, 20, 580.00); --
INSERT INTO venta (id_cliente, id_empleado, total) VALUES (101, 21, 290.30); -- id 100
INSERT INTO venta (id_cliente, id_empleado, total) VALUES (102, 22, 230.20); -- id 101
INSERT INTO venta (id_cliente, id_empleado, total) VALUES (103, 23, 300.00); -- id 102
INSERT INTO venta (id_cliente, id_empleado, total) VALUES (104, 24, 220.40); -- id 103
INSERT INTO venta (id_cliente, id_empleado, total) VALUES (105, 25, 310.90); -- id 104
INSERT INTO venta (id_cliente, id_empleado, total) VALUES (106, 26, 450.00); -- id 105
INSERT INTO venta (id_cliente, id_empleado, total) VALUES (107, 27, 380.10); -- id 106
INSERT INTO venta (id_cliente, id_empleado, total) VALUES (108, 28, 490.60); -- id 107
INSERT INTO venta (id_cliente, id_empleado, total) VALUES (109, 29, 520.70); -- id 108
INSERT INTO venta (id_cliente, id_empleado, total) VALUES (110, 30, 610.80); -- id 109
INSERT INTO venta (id_cliente, id_empleado, total) VALUES (111, 31, 725.90); -- id 110
INSERT INTO venta (id_cliente, id_empleado, total) VALUES (112, 32, 150.00);

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