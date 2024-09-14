--Script base de datos life & health

--Creacion de tablespaces HOLA GIT

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

--Creaci�n de las tablas
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
descripcion VARCHAR(250) DEFAULT 'Descripci�n no disponible',
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
descripcion VARCHAR(100) DEFAULT 'Producto sin descripci�n espec�fica',
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

--INSERCIONES DE DATOS

--Pa�ses
INSERT INTO pais (pais) VALUES ('Argentina');
INSERT INTO pais (pais) VALUES ('Australia');
INSERT INTO pais (pais) VALUES ('Austria');
INSERT INTO pais (pais) VALUES ('Bahamas');
INSERT INTO pais (pais) VALUES ('Barbados');
INSERT INTO pais (pais) VALUES ('B�lgica');
INSERT INTO pais (pais) VALUES ('Belice');
INSERT INTO pais (pais) VALUES ('Bolivia');
INSERT INTO pais (pais) VALUES ('Brasil');
INSERT INTO pais (pais) VALUES ('Canad�');
INSERT INTO pais (pais) VALUES ('Chile');
INSERT INTO pais (pais) VALUES ('Colombia');
INSERT INTO pais (pais) VALUES ('Costa Rica');
INSERT INTO pais (pais) VALUES ('Croacia');
INSERT INTO pais (pais) VALUES ('Cuba');
INSERT INTO pais (pais) VALUES ('Dinamarca');
INSERT INTO pais (pais) VALUES ('Dominica');
INSERT INTO pais (pais) VALUES ('Ecuador');
INSERT INTO pais (pais) VALUES ('El Salvador');
INSERT INTO pais (pais) VALUES ('Espa�a');
INSERT INTO pais (pais) VALUES ('Estados Unidos');
INSERT INTO pais (pais) VALUES ('Estonia');
INSERT INTO pais (pais) VALUES ('Fiyi');
INSERT INTO pais (pais) VALUES ('Finlandia');
INSERT INTO pais (pais) VALUES ('Francia');
INSERT INTO pais (pais) VALUES ('Granada');
INSERT INTO pais (pais) VALUES ('Grecia');
INSERT INTO pais (pais) VALUES ('Guatemala');
INSERT INTO pais (pais) VALUES ('Guyana');
INSERT INTO pais (pais) VALUES ('Honduras');
INSERT INTO pais (pais) VALUES ('Irlanda');
INSERT INTO pais (pais) VALUES ('Islandia');
INSERT INTO pais (pais) VALUES ('Italia');
INSERT INTO pais (pais) VALUES ('Jamaica');
INSERT INTO pais (pais) VALUES ('Letonia');
INSERT INTO pais (pais) VALUES ('Lituania');
INSERT INTO pais (pais) VALUES ('Luxemburgo');
INSERT INTO pais (pais) VALUES ('Malta');
INSERT INTO pais (pais) VALUES ('M�xico');
INSERT INTO pais (pais) VALUES ('M�naco');
INSERT INTO pais (pais) VALUES ('Nauru');
INSERT INTO pais (pais) VALUES ('Nueva Zelanda');
INSERT INTO pais (pais) VALUES ('Noruega');
INSERT INTO pais (pais) VALUES ('Pa�ses Bajos');
INSERT INTO pais (pais) VALUES ('Panam�');
INSERT INTO pais (pais) VALUES ('Paraguay');
INSERT INTO pais (pais) VALUES ('Per�');
INSERT INTO pais (pais) VALUES ('Polonia');
INSERT INTO pais (pais) VALUES ('Portugal');
INSERT INTO pais (pais) VALUES ('Reino Unido');
INSERT INTO pais (pais) VALUES ('Rep�blica Checa');
INSERT INTO pais (pais) VALUES ('Rep�blica Dominicana');
INSERT INTO pais (pais) VALUES ('Rumania');
INSERT INTO pais (pais) VALUES ('San Crist�bal y Nieves');
INSERT INTO pais (pais) VALUES ('San Vicente y las Granadinas');
INSERT INTO pais (pais) VALUES ('Santa Luc�a');
INSERT INTO pais (pais) VALUES ('Serbia');
INSERT INTO pais (pais) VALUES ('Suecia');
INSERT INTO pais (pais) VALUES ('Suiza');
INSERT INTO pais (pais) VALUES ('Surinam');
INSERT INTO pais (pais) VALUES ('Trinidad y Tobago');
INSERT INTO pais (pais) VALUES ('Uruguay');
INSERT INTO pais (pais) VALUES ('Vanuatu');
INSERT INTO pais (pais) VALUES ('Venezuela');
INSERT INTO pais (pais) VALUES ('Alemania');
INSERT INTO pais (pais) VALUES ('Andorra');
INSERT INTO pais (pais) VALUES ('Antigua y Barbuda');
INSERT INTO pais (pais) VALUES ('Armenia');
INSERT INTO pais (pais) VALUES ('Bosnia y Herzegovina');
INSERT INTO pais (pais) VALUES ('Bulgaria');
INSERT INTO pais (pais) VALUES ('Eslovaquia');
INSERT INTO pais (pais) VALUES ('Eslovenia');
INSERT INTO pais (pais) VALUES ('Hungr�a');
INSERT INTO pais (pais) VALUES ('Liechtenstein');
INSERT INTO pais (pais) VALUES ('Macedonia del Norte');
INSERT INTO pais (pais) VALUES ('Moldavia');
INSERT INTO pais (pais) VALUES ('Montenegro');
INSERT INTO pais (pais) VALUES ('San Marino');
INSERT INTO pais (pais) VALUES ('Ucrania');
INSERT INTO pais (pais) VALUES ('Georgia');
INSERT INTO pais (pais) VALUES ('Pap�a Nueva Guinea');
INSERT INTO pais (pais) VALUES ('Samoa');

--Estados
INSERT INTO estado (estado, id_pais) VALUES ('Cundinamarca', 12);
INSERT INTO estado (estado, id_pais) VALUES ('Antioquia', 12);
INSERT INTO estado (estado, id_pais) VALUES ('Quind�o', 12);
INSERT INTO estado (estado, id_pais) VALUES ('Pichincha', 18);
INSERT INTO estado (estado, id_pais) VALUES ('Guayas', 18);
INSERT INTO estado (estado, id_pais) VALUES ('Azuay', 18);
INSERT INTO estado (estado, id_pais) VALUES ('Lima', 47);
INSERT INTO estado (estado, id_pais) VALUES ('Arequipa', 47);
INSERT INTO estado (estado, id_pais) VALUES ('Ayacucho', 47);
INSERT INTO estado (estado, id_pais) VALUES ('Buenos Aires', 1);
INSERT INTO estado (estado, id_pais) VALUES ('Cordoba', 1);
INSERT INTO estado (estado, id_pais) VALUES ('Tucum�n', 1);
INSERT INTO estado (estado, id_pais) VALUES ('Regi�n metropolitana', 11);
INSERT INTO estado (estado, id_pais) VALUES ('Regi�n de Valpara�so', 11);
INSERT INTO estado (estado, id_pais) VALUES ('Regi�n de Biobb�o', 11);
INSERT INTO estado (estado, id_pais) VALUES ('M�xico DF', 39);
INSERT INTO estado (estado, id_pais) VALUES ('Jalisco', 39);
INSERT INTO estado (estado, id_pais) VALUES ('Puebla de Zaragoza', 39);
INSERT INTO estado (estado, id_pais) VALUES ('San Jos�', 13); 
INSERT INTO estado (estado, id_pais) VALUES ('Lim�n', 13);
INSERT INTO estado (estado, id_pais) VALUES ('Guanacaste', 13);
INSERT INTO estado (estado, id_pais) VALUES ('Panam�', 45);
INSERT INTO estado (estado, id_pais) VALUES ('Veraguas', 45);
INSERT INTO estado (estado, id_pais) VALUES ('Los Santos', 45);
INSERT INTO estado (estado, id_pais) VALUES ('Catalu�a', 20);
INSERT INTO estado (estado, id_pais) VALUES ('Madrid', 20);

--Ciudades
INSERT INTO ciudad (ciudad, id_estado) VALUES ('Bogot�', 1);
INSERT INTO ciudad (ciudad, id_estado) VALUES ('Facatativ�', 1);
INSERT INTO ciudad (ciudad, id_estado) VALUES ('Soacha', 1);
INSERT INTO ciudad (ciudad, id_estado) VALUES ('Medell�n', 2);
INSERT INTO ciudad (ciudad, id_estado) VALUES ('Bello', 2);
INSERT INTO ciudad (ciudad, id_estado) VALUES ('Envigado', 2);
INSERT INTO ciudad (ciudad, id_estado) VALUES ('Armenia', 3);
INSERT INTO ciudad (ciudad, id_estado) VALUES ('Calarc�', 3);
INSERT INTO ciudad (ciudad, id_estado) VALUES ('Quito', 4);
INSERT INTO ciudad (ciudad, id_estado) VALUES ('Sangolqu�', 4);
INSERT INTO ciudad (ciudad, id_estado) VALUES ('Cayambe', 4);
INSERT INTO ciudad (ciudad, id_estado) VALUES ('Guayaquil', 5);
INSERT INTO ciudad (ciudad, id_estado) VALUES ('Daule', 5);
INSERT INTO ciudad (ciudad, id_estado) VALUES ('Cuenca', 6);
INSERT INTO ciudad (ciudad, id_estado) VALUES ('Lima', 7);
INSERT INTO ciudad (ciudad, id_estado) VALUES ('Miraflores', 7);
INSERT INTO ciudad (ciudad, id_estado) VALUES ('Arequipa', 8);
INSERT INTO ciudad (ciudad, id_estado) VALUES ('Ayacucho', 9);
INSERT INTO ciudad (ciudad, id_estado) VALUES ('Buenos Aires', 10);
INSERT INTO ciudad (ciudad, id_estado) VALUES ('La Plata', 10);
INSERT INTO ciudad (ciudad, id_estado) VALUES ('Avellaneda', 10);
INSERT INTO ciudad (ciudad, id_estado) VALUES ('C�rdoba', 11);
INSERT INTO ciudad (ciudad, id_estado) VALUES ('Villa Carlos Paz', 11);
INSERT INTO ciudad (ciudad, id_estado) VALUES ('R�o Cuarto', 11);
INSERT INTO ciudad (ciudad, id_estado) VALUES ('San Miguel de Tucum�n', 12);
INSERT INTO ciudad (ciudad, id_estado) VALUES ('Santiago', 13);
INSERT INTO ciudad (ciudad, id_estado) VALUES ('Puente Alto', 13);
INSERT INTO ciudad (ciudad, id_estado) VALUES ('Maip�', 13);
INSERT INTO ciudad (ciudad, id_estado) VALUES ('Valpara�so', 14);
INSERT INTO ciudad (ciudad, id_estado) VALUES ('Vi�a del Mar', 14);
INSERT INTO ciudad (ciudad, id_estado) VALUES ('Concepci�n', 15);
INSERT INTO ciudad (ciudad, id_estado) VALUES ('Ciudad de M�xico', 16);
INSERT INTO ciudad (ciudad, id_estado) VALUES ('Iztapalapa', 16);
INSERT INTO ciudad (ciudad, id_estado) VALUES ('Coyoac�n', 16);
INSERT INTO ciudad (ciudad, id_estado) VALUES ('Guadalajara', 17);
INSERT INTO ciudad (ciudad, id_estado) VALUES ('Zapopan', 17);
INSERT INTO ciudad (ciudad, id_estado) VALUES ('Puebla', 18);
INSERT INTO ciudad (ciudad, id_estado) VALUES ('Cholula', 18);
INSERT INTO ciudad (ciudad, id_estado) VALUES ('Tehuac�n', 18);
INSERT INTO ciudad (ciudad, id_estado) VALUES ('San Jos�', 19);
INSERT INTO ciudad (ciudad, id_estado) VALUES ('Desamparados', 19);
INSERT INTO ciudad (ciudad, id_estado) VALUES ('Alajuela', 19);
INSERT INTO ciudad (ciudad, id_estado) VALUES ('Lim�n', 20);
INSERT INTO ciudad (ciudad, id_estado) VALUES ('Gu�piles', 20);
INSERT INTO ciudad (ciudad, id_estado) VALUES ('Liberia', 21);
INSERT INTO ciudad (ciudad, id_estado) VALUES ('Nicoya', 21);
INSERT INTO ciudad (ciudad, id_estado) VALUES ('Santa Cruz', 21);
INSERT INTO ciudad (ciudad, id_estado) VALUES ('Panam�', 22);
INSERT INTO ciudad (ciudad, id_estado) VALUES ('San Miguelito', 22);
INSERT INTO ciudad (ciudad, id_estado) VALUES ('Santiago de Veraguas', 23);
INSERT INTO ciudad (ciudad, id_estado) VALUES ('Las Tablas', 24);
INSERT INTO ciudad (ciudad, id_estado) VALUES ('Guarar�', 24);
INSERT INTO ciudad (ciudad, id_estado) VALUES ('La Villa de Los Santos', 24);
INSERT INTO ciudad (ciudad, id_estado) VALUES ('Barcelona', 25);
INSERT INTO ciudad (ciudad, id_estado) VALUES ('Tarragona', 25);
INSERT INTO ciudad (ciudad, id_estado) VALUES ('Lleida', 25);
INSERT INTO ciudad (ciudad, id_estado) VALUES ('Madrid', 26);
INSERT INTO ciudad (ciudad, id_estado) VALUES ('Alcal� de Henares', 26);
INSERT INTO ciudad (ciudad, id_estado) VALUES ('Getafe', 26);

--Elementos
INSERT INTO elemento (elemento, marca) VALUES ('Cinta de correr', 'NordicTrack');
INSERT INTO elemento (elemento, marca) VALUES ('Bicicleta est�tica', 'Schwinn');
INSERT INTO elemento (elemento, marca) VALUES ('El�ptica', 'ProForm');
INSERT INTO elemento (elemento, marca) VALUES ('Banco de pesas', 'Body-Solid');
INSERT INTO elemento (elemento, marca) VALUES ('Juego de mancuernas', 'Bowflex');
INSERT INTO elemento (elemento, marca) VALUES ('M�quina de remo', 'Concept2');
INSERT INTO elemento (elemento, marca) VALUES ('M�quina de poleas', 'Valor Fitness');
INSERT INTO elemento (elemento, marca) VALUES ('Estera de yoga', 'Manduka');
INSERT INTO elemento (elemento, marca) VALUES ('Bal�n medicinal', 'Rogue');
INSERT INTO elemento (elemento, marca) VALUES ('Kettlebell', 'Onnit');
INSERT INTO elemento (elemento, marca) VALUES ('Pesas rusas', 'TRX');
INSERT INTO elemento (elemento, marca) VALUES ('Caja pliom�trica', 'Titan Fitness');
INSERT INTO elemento (elemento, marca) VALUES ('Soga de batalla', 'AmazonBasics');
INSERT INTO elemento (elemento, marca) VALUES ('Colchoneta de ejercicios', 'Gaiam');
INSERT INTO elemento (elemento, marca) VALUES ('Cuerda para saltar', 'WOD Nation');
INSERT INTO elemento (elemento, marca) VALUES ('Barra ol�mpica', 'CAP Barbell');
INSERT INTO elemento (elemento, marca) VALUES ('Banco ajustable', 'Rep Fitness');
INSERT INTO elemento (elemento, marca) VALUES ('Prensa de piernas', 'BodyCraft');
INSERT INTO elemento (elemento, marca) VALUES ('Estaci�n de dominadas', 'Iron Gym');
INSERT INTO elemento (elemento, marca) VALUES ('Estaci�n de fondos', 'Stamina');
INSERT INTO elemento (elemento, marca) VALUES ('Estaci�n de abdominales', 'Perfect Fitness');
INSERT INTO elemento (elemento, marca) VALUES ('Step de aer�bicos', 'Reebok');
INSERT INTO elemento (elemento, marca) VALUES ('Banda de resistencia', 'Fit Simplify');
INSERT INTO elemento (elemento, marca) VALUES ('Rueda abdominal', 'Valeo');
INSERT INTO elemento (elemento, marca) VALUES ('M�quina de esquiador', 'Skierg');
INSERT INTO elemento (elemento, marca) VALUES ('Remo erg�metro', 'Hydrow');
INSERT INTO elemento (elemento, marca) VALUES ('Silla romana', 'Titan Fitness');
INSERT INTO elemento (elemento, marca) VALUES ('Multicesti�n de entrenamiento', 'Weider');
INSERT INTO elemento (elemento, marca) VALUES ('Pesa rusa ajustable', 'Bowflex');
INSERT INTO elemento (elemento, marca) VALUES ('Sistema de entrenamiento en suspensi�n', 'TRX');
INSERT INTO elemento (elemento, marca) VALUES ('Rodillo de espuma', 'TriggerPoint');
INSERT INTO elemento (elemento, marca) VALUES ('Chaleco lastrado', 'RUNmax');
INSERT INTO elemento (elemento, marca) VALUES ('Escaladora', 'StairMaster');
INSERT INTO elemento (elemento, marca) VALUES ('Caja de pesas', 'Cap Barbell');
INSERT INTO elemento (elemento, marca) VALUES ('Estaci�n de sentadillas', 'Fitness Reality');
INSERT INTO elemento (elemento, marca) VALUES ('M�quina de press de hombros', 'Valor Fitness');
INSERT INTO elemento (elemento, marca) VALUES ('M�quina de gl�teos', 'Body-Solid');
INSERT INTO elemento (elemento, marca) VALUES ('Chaleco de sauna', 'TNT Pro Series');
INSERT INTO elemento (elemento, marca) VALUES ('Barra de dominadas', 'Ultimate Body Press');
INSERT INTO elemento (elemento, marca) VALUES ('Discos de competici�n', 'Rogue');
INSERT INTO elemento (elemento, marca) VALUES ('Cinta de yoga', 'Manduka');
INSERT INTO elemento (elemento, marca) VALUES ('Cintur�n de levantamiento de pesas', 'Harbinger');
INSERT INTO elemento (elemento, marca) VALUES ('Guantes de entrenamiento', 'Nike');
INSERT INTO elemento (elemento, marca) VALUES ('Soporte de discos', 'Body-Solid');
INSERT INTO elemento (elemento, marca) VALUES ('M�quina de pecho', 'Life Fitness');
INSERT INTO elemento (elemento, marca) VALUES ('Estaci�n de barras paralelas', 'Lebert Fitness');
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
INSERT INTO elemento (elemento, marca) VALUES ('Sistema de filtraci�n de piscina', 'Hayward');
INSERT INTO elemento (elemento, marca) VALUES ('Vitrina de exhibici�n', 'Ikea');
INSERT INTO elemento (elemento, marca) VALUES ('Mostrador de atenci�n', 'Ikea');
INSERT INTO elemento (elemento, marca) VALUES ('Estanter�a de almacenamiento', 'AmazonBasics');
INSERT INTO elemento (elemento, marca) VALUES ('Caja registradora', 'Sharp');
INSERT INTO elemento (elemento, marca) VALUES ('Refrigerador para bebidas', 'Frigidaire');
INSERT INTO elemento (elemento, marca) VALUES ('Soporte para folletos', 'Displays2go');
INSERT INTO elemento (elemento, marca) VALUES ('Sistema de punto de venta', 'Square');
INSERT INTO elemento (elemento, marca) VALUES ('Carro de almacenamiento', 'Seville Classics');
INSERT INTO elemento (elemento, marca) VALUES ('Iluminaci�n para vitrinas', 'Philips');

--Caracter�stica
INSERT INTO caracteristica (caracteristica) VALUES ('Gimansio');
INSERT INTO caracteristica (caracteristica) VALUES ('Zona de cardio');
INSERT INTO caracteristica (caracteristica) VALUES ('Zona de funcional');
INSERT INTO caracteristica (caracteristica) VALUES ('�rea de boxeo y artes marciales');
INSERT INTO caracteristica (caracteristica) VALUES ('Zona de rehabilitaci�n y fisioterapia');
INSERT INTO caracteristica (caracteristica) VALUES ('Zona para ni�os');
INSERT INTO caracteristica (caracteristica) VALUES ('Piscina');
INSERT INTO caracteristica (caracteristica) VALUES ('Turco');
INSERT INTO caracteristica (caracteristica) VALUES ('Tienda');

--Departamentos
INSERT INTO departamento (departamento) VALUES ('Entrenamiento');
INSERT INTO departamento (departamento) VALUES ('Fisioterapia');
INSERT INTO departamento (departamento) VALUES ('Ni�ez');
INSERT INTO departamento (departamento) VALUES ('Mantenimiento');
INSERT INTO departamento (departamento) VALUES ('Atenci�n al cliente');
INSERT INTO departamento (departamento) VALUES ('Nutrici�n');
INSERT INTO departamento (departamento) VALUES ('Legal');
INSERT INTO departamento (departamento) VALUES ('Marketing');
INSERT INTO departamento (departamento) VALUES ('Administrativo');

--Cargos
INSERT INTO cargo (cargo, id_departamento) VALUES ('Entrenador Personal', 1);
INSERT INTO cargo (cargo, id_departamento) VALUES ('Instructor de Clases Grupales', 1);
INSERT INTO cargo (cargo, id_departamento) VALUES ('Coordinador de Entrenamiento', 1);
INSERT INTO cargo (cargo, id_departamento) VALUES ('Fisioterapeuta', 2);
INSERT INTO cargo (cargo, id_departamento) VALUES ('Rehabilitador Deportivo', 2);
INSERT INTO cargo (cargo, id_departamento) VALUES ('Asistente de Fisioterapia', 2);
INSERT INTO cargo (cargo, id_departamento) VALUES ('Instructor de Actividades para Ni�os', 3);
INSERT INTO cargo (cargo, id_departamento) VALUES ('Cuidador', 3);
INSERT INTO cargo (cargo, id_departamento) VALUES ('Operario de Mantenimiento', 4);
INSERT INTO cargo (cargo, id_departamento) VALUES ('Jefe de Mantenimiento', 4);
INSERT INTO cargo (cargo, id_departamento) VALUES ('Auxiliar de servicios generales', 4);
INSERT INTO cargo (cargo, id_departamento) VALUES ('Auxiliar de Atenci�n al Cliente', 5);
INSERT INTO cargo (cargo, id_departamento) VALUES ('Coordinador de Servicio al Cliente', 5);
INSERT INTO cargo (cargo, id_departamento) VALUES ('Nutricionista', 6);
INSERT INTO cargo (cargo, id_departamento) VALUES ('Asesor de Suplementaci�n', 6);
INSERT INTO cargo (cargo, id_departamento) VALUES ('Abogado Corporativo', 7);
INSERT INTO cargo (cargo, id_departamento) VALUES ('Asistente Legal', 7);
INSERT INTO cargo (cargo, id_departamento) VALUES ('Gerente de Marketing', 8);
INSERT INTO cargo (cargo, id_departamento) VALUES ('Publicista', 8);
INSERT INTO cargo (cargo, id_departamento) VALUES ('Dise�ador', 8);
INSERT INTO cargo (cargo, id_departamento) VALUES ('Gerente de general', 9);
INSERT INTO cargo (cargo, id_departamento) VALUES ('Gerente de sede', 9);
INSERT INTO cargo (cargo, id_departamento) VALUES ('Contador', 9);
INSERT INTO cargo (cargo, id_departamento) VALUES ('Asistente Administrativo', 9);

--Membresias
INSERT INTO membresia (membresia, descripcion, precio_mes, precio_anual) VALUES
('B�sica', 'Acceso 4 d�as a la semana a todas las instalaciones y 4 clases grupales durante un mes.', 30.00, 300.00);

INSERT INTO membresia (membresia, descripcion, precio_mes, precio_anual) VALUES
('Premium', 'Acceso ilimitado a todas las instalaciones y clases grupales ilimitadas.', 50.00, 500.00);

INSERT INTO membresia (membresia, descripcion, precio_mes, precio_anual) VALUES
('VIP', 'Acceso ilimitado a todas las instalaciones, clases grupales ilimitadas y entrenador personal.', 80.00, 800.00);

INSERT INTO membresia (membresia, descripcion, precio_mes, precio_anual) VALUES
('Familiar', 'Membres�a para 4 personas, acceso a todas las instalaciones 4 veces a la semana y 4 clases grupales durante un mes para cada uno de los miembros de la familia.', 100.00, 1000.00);

INSERT INTO membresia (membresia, descripcion, precio_mes, precio_anual) VALUES
('Estudiante', 'Descuento para estudiantes, 4 d�as a la semana a todas las instalaciones y 4 clases grupales durante un mes.', 25.00, 250.00);

INSERT INTO membresia (membresia, descripcion, precio_mes, precio_anual) VALUES
('Corporativa', 'Membres�a para empresas, Acceso ilimitado a todas las instalaciones y clases grupales ilimitadas.', 200.00, 2000.00);

INSERT INTO membresia (membresia, descripcion, precio_mes, precio_anual) VALUES
('Weekend Warrior', 'Acceso a las instalaciones solo los fines de semana y d�as festivos', 15.00, 150.00);

INSERT INTO membresia (membresia, descripcion, precio_mes, precio_anual) VALUES
('Platinum', 'Acceso VIP m�s nutricionista y 4 fisioterapias al mes.', 120.00, 1200.00);

INSERT INTO membresia (membresia, descripcion, precio_mes, precio_anual) VALUES
('Senior', 'Descuento para personas mayores de 65 a�os, ilimitado a todas las instalaciones y clases especiales.', 20.00, 200.00);

INSERT INTO membresia (membresia, descripcion, precio_mes, precio_anual) VALUES
('Day Pass', 'Acceso por un d�a a todas las instalaciones.', 10.00, 100.00);

INSERT INTO membresia (membresia, precio_mes, precio_anual) VALUES
('No miembro', 0, 0);

--Productos
INSERT INTO producto (producto, descripcion) VALUES ('Prote�na Whey', 'Prote�na de suero de leche para aumentar masa muscular.');
INSERT INTO producto (producto, descripcion) VALUES ('Creatina Monohidrato', 'Suplemento para mejorar el rendimiento y la fuerza.');
INSERT INTO producto (producto, descripcion) VALUES ('BCAA', 'Amino�cidos de cadena ramificada para la recuperaci�n muscular.');
INSERT INTO producto (producto, descripcion) VALUES ('Preentreno Explosivo', 'Suplemento preentrenamiento para energ�a y enfoque.');
INSERT INTO producto (producto, descripcion) VALUES ('Glutamina', 'Amino�cido para la recuperaci�n muscular y la funci�n inmunol�gica.');
INSERT INTO producto (producto, descripcion) VALUES ('Omega 3', 'Suplemento de �cidos grasos esenciales para la salud cardiovascular.');
INSERT INTO producto (producto, descripcion) VALUES ('Multivitam�nico', 'Complejo multivitam�nico para apoyo nutricional diario.');
INSERT INTO producto (producto, descripcion) VALUES ('Prote�na Vegetal', 'Prote�na a base de plantas para dietas veganas y vegetarianas.');
INSERT INTO producto (producto, descripcion) VALUES ('Quemador de Grasa', 'Suplemento para ayudar en la p�rdida de peso.');
INSERT INTO producto (producto, descripcion) VALUES ('Barra de Prote�na', 'Snack alto en prote�nas para despu�s del entrenamiento.');
INSERT INTO producto (producto, descripcion) VALUES ('Gainer', 'Suplemento para ganar masa muscular y peso.');
INSERT INTO producto (producto, descripcion) VALUES ('Amino�cidos Esenciales', 'Amino�cidos esenciales para la recuperaci�n y el crecimiento muscular.');
INSERT INTO producto (producto, descripcion) VALUES ('Case�na', 'Prote�na de liberaci�n lenta para la recuperaci�n nocturna.');
INSERT INTO producto (producto, descripcion) VALUES ('Batido de Reemplazo de Comidas', 'Suplemento para reemplazar comidas y mantener el peso.');
INSERT INTO producto (producto, descripcion) VALUES ('L-Carnitina', 'Suplemento para mejorar el metabolismo de las grasas.');
INSERT INTO producto (producto, descripcion) VALUES ('Prote�na Hidrolizada', 'Prote�na de r�pida absorci�n para la recuperaci�n muscular.');
INSERT INTO producto (producto, descripcion) VALUES ('Suero de Leche Isolado', 'Prote�na aislada de suero de leche para mayor pureza.');
INSERT INTO producto (producto, descripcion) VALUES ('ZMA', 'Suplemento de zinc, magnesio y vitamina B6 para mejorar el sue�o y la recuperaci�n.');
INSERT INTO producto (producto, descripcion) VALUES ('�cido Hialur�nico', 'Suplemento para la salud de las articulaciones y la piel.');
INSERT INTO producto (producto, descripcion) VALUES ('Beta-Alanina', 'Suplemento para mejorar la resistencia muscular y reducir la fatiga.');

--Sedes
-- Bogot� (capital)
INSERT INTO sede (sede, direccion, telefono, id_ciudad) VALUES ('Sede Norte', 'Calle 100 #15-20', '3001234567', 1);
INSERT INTO sede (sede, direccion, telefono, id_ciudad) VALUES ('Sede Centro', 'Carrera 7 #45-10', '3009876543', 1);
INSERT INTO sede (sede, direccion, telefono, id_ciudad) VALUES ('Sede Occidente', 'Av. Am�ricas #70-30', '3001928374', 1);

-- Facatativ�
INSERT INTO sede (sede, direccion, telefono, id_ciudad) VALUES ('Sede Facatativ�', 'Calle 15 #3-20', '3001234578', 2);

-- Soacha
INSERT INTO sede (sede, direccion, telefono, id_ciudad) VALUES ('Sede Soacha', 'Carrera 10 #4-15', '3008765432', 3);

-- Medell�n (capital)
INSERT INTO sede (sede, direccion, telefono, id_ciudad) VALUES ('Sede Poblado', 'Calle 10 #43-25', '3001231234', 4);
INSERT INTO sede (sede, direccion, telefono, id_ciudad) VALUES ('Sede Laureles', 'Avenida Nutibara #70-30', '3009876541', 4);

-- Bello
INSERT INTO sede (sede, direccion, telefono, id_ciudad) VALUES ('Sede Bello', 'Carrera 50 #30-25', '3001122334', 5);

-- Envigado
INSERT INTO sede (sede, direccion, telefono, id_ciudad) VALUES ('Sede Envigado', 'Calle 38 Sur #15-20', '3002211445', 6);

-- Armenia (capital)
INSERT INTO sede (sede, direccion, telefono, id_ciudad) VALUES ('Sede Armenia', 'Carrera 14 #18-20', '3003344556', 7);

-- Calarc�
INSERT INTO sede (sede, direccion, telefono, id_ciudad) VALUES ('Sede Calarc�', 'Calle 27 #15-12', '3004455667', 8);

-- Quito (capital)
INSERT INTO sede (sede, direccion, telefono, id_ciudad) VALUES ('Sede Norte Quito', 'Avenida Amazonas #35-20', '3005566778', 9);
INSERT INTO sede (sede, direccion, telefono, id_ciudad) VALUES ('Sede Centro Quito', 'Calle Garc�a Moreno #10-30', '3006677889', 9);

-- Sangolqu�
INSERT INTO sede (sede, direccion, telefono, id_ciudad) VALUES ('Sede Sangolqu�', 'Avenida General Rumi�ahui #5-25', '3007788990', 10);

-- Cayambe
INSERT INTO sede (sede, direccion, telefono, id_ciudad) VALUES ('Sede Cayambe', 'Calle Sucre #12-34', '3008899001', 11);

-- Guayaquil (capital)
INSERT INTO sede (sede, direccion, telefono, id_ciudad) VALUES ('Sede Norte Guayaquil', 'Avenida 9 de Octubre #30-15', '3009900112', 12);
INSERT INTO sede (sede, direccion, telefono, id_ciudad) VALUES ('Sede Centro Guayaquil', 'Calle Panam� #7-20', '3000011223', 12);

-- Daule
INSERT INTO sede (sede, direccion, telefono, id_ciudad) VALUES ('Sede Daule', 'Avenida Le�n Febres Cordero #15-30', '3001122334', 13);

-- Cuenca (capital)
INSERT INTO sede (sede, direccion, telefono, id_ciudad) VALUES ('Sede Cuenca', 'Calle Bol�var #20-15', '3002233445', 14);

-- Lima (capital)
INSERT INTO sede (sede, direccion, telefono, id_ciudad) VALUES ('Sede Lima Sur', 'Avenida Javier Prado #45-20', '3003344556', 15);
INSERT INTO sede (sede, direccion, telefono, id_ciudad) VALUES ('Sede Lima Norte', 'Calle Lampa #30-20', '3004455667', 15);

-- Miraflores
INSERT INTO sede (sede, direccion, telefono, id_ciudad) VALUES ('Sede Miraflores', 'Avenida Pardo #12-30', '3005566778', 16);

-- Arequipa (capital)
INSERT INTO sede (sede, direccion, telefono, id_ciudad) VALUES ('Sede Arequipa', 'Calle Mercaderes #15-25', '3006677889', 17);

-- Ayacucho
INSERT INTO sede (sede, direccion, telefono, id_ciudad) VALUES ('Sede Ayacucho', 'Avenida Cusco #5-20', '3007788990', 18);

-- Buenos Aires (capital)
INSERT INTO sede (sede, direccion, telefono, id_ciudad) VALUES ('Sede Palermo', 'Avenida Santa Fe #45-30', '3008899001', 19);
INSERT INTO sede (sede, direccion, telefono, id_ciudad) VALUES ('Sede Recoleta', 'Calle Pueyrred�n #10-20', '3009900112', 19);

-- La Plata
INSERT INTO sede (sede, direccion, telefono, id_ciudad) VALUES ('Sede La Plata', 'Calle 7 #34-25', '3000011223', 20);

-- Avellaneda
INSERT INTO sede (sede, direccion, telefono, id_ciudad) VALUES ('Sede Avellaneda', 'Avenida Mitre #15-30', '3001122334', 21);

-- C�rdoba (capital)
INSERT INTO sede (sede, direccion, telefono, id_ciudad) VALUES ('Sede Nueva C�rdoba', 'Avenida Hip�lito Yrigoyen #20-30', '3002233445', 22);
INSERT INTO sede (sede, direccion, telefono, id_ciudad) VALUES ('Sede Centro C�rdoba', 'Calle Independencia #45-10', '3003344556', 22);

-- Villa Carlos Paz
INSERT INTO sede (sede, direccion, telefono, id_ciudad) VALUES ('Sede Villa Carlos Paz', 'Calle Alem #5-15', '3004455667', 23);

-- R�o Cuarto
INSERT INTO sede (sede, direccion, telefono, id_ciudad) VALUES ('Sede R�o Cuarto', 'Avenida Espa�a #12-30', '3005566778', 24);

-- San Miguel de Tucum�n (capital)
INSERT INTO sede (sede, direccion, telefono, id_ciudad) VALUES ('Sede Tucum�n', 'Calle 25 de Mayo #10-20', '3006677889', 25);

-- Santiago (capital)
INSERT INTO sede (sede, direccion, telefono, id_ciudad) VALUES ('Sede Providencia', 'Avenida Providencia #30-20', '3007788990', 26);
INSERT INTO sede (sede, direccion, telefono, id_ciudad) VALUES ('Sede Las Condes', 'Avenida Apoquindo #45-15', '3008899001', 26);

-- Puente Alto
INSERT INTO sede (sede, direccion, telefono, id_ciudad) VALUES ('Sede Puente Alto', 'Calle Concha y Toro #10-25', '3009900112', 27);

-- Maip�
INSERT INTO sede (sede, direccion, telefono, id_ciudad) VALUES ('Sede Maip�', 'Avenida Pajaritos #15-10', '3000011223', 28);

-- Valpara�so (capital)
INSERT INTO sede (sede, direccion, telefono, id_ciudad) VALUES ('Sede Valpara�so', 'Calle Esmeralda #20-30', '3001122334', 29);

-- Vi�a del Mar
INSERT INTO sede (sede, direccion, telefono, id_ciudad) VALUES ('Sede Vi�a del Mar', 'Avenida Libertad #45-20', '3002233445', 30);

-- Concepci�n
INSERT INTO sede (sede, direccion, telefono, id_ciudad) VALUES ('Sede Concepci�n', 'Calle Caupolic�n #12-15', '3003344556', 31);

-- Ciudad de M�xico (capital)
INSERT INTO sede (sede, direccion, telefono, id_ciudad) VALUES ('Sede Polanco', 'Avenida Presidente Masaryk #45-30', '3004455667', 32);
INSERT INTO sede (sede, direccion, telefono, id_ciudad) VALUES ('Sede Roma', 'Calle �lvaro Obreg�n #20-15', '3005566778', 32);

-- Iztapalapa
INSERT INTO sede (sede, direccion, telefono, id_ciudad) VALUES ('Sede Iztapalapa', 'Avenida Tl�huac #15-20', '3006677889', 33);

-- Coyoac�n
INSERT INTO sede (sede, direccion, telefono, id_ciudad) VALUES ('Sede Coyoac�n', 'Avenida Coyo #15-20', '3006677889', 34);

-- Guadalajara (capital)
INSERT INTO sede (sede, direccion, telefono, id_ciudad) VALUES ('Sede Guadalajara Centro', 'Avenida Ju�rez #45-10', '3008899001', 35);
INSERT INTO sede (sede, direccion, telefono, id_ciudad) VALUES ('Sede Guadalajara Sur', 'Calle L�pez Cotilla #20-30', '3009900112', 35);

-- Zapopan
INSERT INTO sede (sede, direccion, telefono, id_ciudad) VALUES ('Sede Zapopan Centro', 'Avenida Vallarta #55-15', '3000011223', 36);

-- Puebla (capital)
INSERT INTO sede (sede, direccion, telefono, id_ciudad) VALUES ('Sede Puebla Centro', 'Calle 5 de Febrero #25-10', '3001122334', 37);
INSERT INTO sede (sede, direccion, telefono, id_ciudad) VALUES ('Sede Angel�polis', 'Boulevard Atlixco #15-20', '3002233445', 37);

-- Cholula
INSERT INTO sede (sede, direccion, telefono, id_ciudad) VALUES ('Sede Cholula', 'Calle 2 Norte #10-15', '3003344556', 38);

-- Tehuac�n
INSERT INTO sede (sede, direccion, telefono, id_ciudad) VALUES ('Sede Tehuac�n', 'Avenida 5 de Mayo #30-25', '3004455667', 39);

-- San Jos� (capital)
INSERT INTO sede (sede, direccion, telefono, id_ciudad) VALUES ('Sede San Jos� Centro', 'Avenida Central #15-20', '3005566778', 40);
INSERT INTO sede (sede, direccion, telefono, id_ciudad) VALUES ('Sede Escaz�', 'Calle San Rafael #20-10', '3006677889', 40);

-- Desamparados
INSERT INTO sede (sede, direccion, telefono, id_ciudad) VALUES ('Sede Desamparados', 'Calle 3 #10-20', '3007788990', 41);

-- Alajuela
INSERT INTO sede (sede, direccion, telefono, id_ciudad) VALUES ('Sede Alajuela', 'Avenida 7 #15-25', '3008899001', 42);

-- Lim�n
INSERT INTO sede (sede, direccion, telefono, id_ciudad) VALUES ('Sede Lim�n', 'Calle 3 #20-30', '3009900112', 43);

-- Gu�piles
INSERT INTO sede (sede, direccion, telefono, id_ciudad) VALUES ('Sede Gu�piles', 'Avenida 4 #10-25', '3000011223', 44);

-- Liberia
INSERT INTO sede (sede, direccion, telefono, id_ciudad) VALUES ('Sede Liberia', 'Calle 2 #15-20', '3001122334', 45);

-- Nicoya
INSERT INTO sede (sede, direccion, telefono, id_ciudad) VALUES ('Sede Nicoya', 'Avenida 5 #20-15', '3002233445', 46);

-- Santa Cruz
INSERT INTO sede (sede, direccion, telefono, id_ciudad) VALUES ('Sede Santa Cruz', 'Calle 1 #10-30', '3003344556', 47);

-- Panam� (capital)
INSERT INTO sede (sede, direccion, telefono, id_ciudad) VALUES ('Sede Panam� Centro', 'Avenida Balboa #25-10', '3004455667', 48);
INSERT INTO sede (sede, direccion, telefono, id_ciudad) VALUES ('Sede Albrook', 'Calle 72 #15-20', '3005566778', 48);

-- San Miguelito
INSERT INTO sede (sede, direccion, telefono, id_ciudad) VALUES ('Sede San Miguelito', 'Avenida Domingo D�az #10-25', '3006677889', 49);

-- Santiago de Veraguas
INSERT INTO sede (sede, direccion, telefono, id_ciudad) VALUES ('Sede Santiago de Veraguas', 'Calle 4 #20-30', '3007788990', 50);

-- Las Tablas
INSERT INTO sede (sede, direccion, telefono, id_ciudad) VALUES ('Sede Las Tablas', 'Calle 6 #15-25', '3008899001', 51);

-- Guarar�
INSERT INTO sede (sede, direccion, telefono, id_ciudad) VALUES ('Sede Guarar�', 'Avenida 7 #10-20', '3009900112', 52);

-- La Villa de Los Santos
INSERT INTO sede (sede, direccion, telefono, id_ciudad) VALUES ('Sede La Villa de Los Santos', 'Calle 5 #15-20', '3000011223', 53);

-- Barcelona (capital)
INSERT INTO sede (sede, direccion, telefono, id_ciudad) VALUES ('Sede Barcelona Centro', 'Calle Gran V�a #45-30', '3001122334', 54);
INSERT INTO sede (sede, direccion, telefono, id_ciudad) VALUES ('Sede Eixample', 'Avenida Diagonal #10-15', '3002233445', 54);

-- Tarragona
INSERT INTO sede (sede, direccion, telefono, id_ciudad) VALUES ('Sede Tarragona', 'Calle Ram�n y Cajal #20-25', '3003344556', 55);

-- Lleida
INSERT INTO sede (sede, direccion, telefono, id_ciudad) VALUES ('Sede Lleida', 'Avenida Catalu�a #15-30', '3004455667', 56);

-- Madrid (capital)
INSERT INTO sede (sede, direccion, telefono, id_ciudad) VALUES ('Sede Madrid Centro', 'Gran V�a #20-10', '3005566778', 57);
INSERT INTO sede (sede, direccion, telefono, id_ciudad) VALUES ('Sede Madrid Norte', 'Avenida de Am�rica #15-25', '3006677889', 57);

-- Alcal� de Henares
INSERT INTO sede (sede, direccion, telefono, id_ciudad) VALUES ('Sede Alcal� de Henares', 'Calle Mayor #10-20', '3007788990', 58);

-- Getafe
INSERT INTO sede (sede, direccion, telefono, id_ciudad) VALUES ('Sede Getafe', 'Calle Madrid #25-15', '3008899001', 59);

--caracteristicas_sede
-- Bogot� (capital)
-- Sede Norte (todas las caracter�sticas)
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (1, 1);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (1, 2);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (1, 3);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (1, 4);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (1, 5);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (1, 6);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (1, 7);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (1, 8);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (1, 9);

-- Sede Centro (algunas caracter�sticas)
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (2, 1);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (2, 4);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (2, 7);

-- Sede Occidente (algunas caracter�sticas)
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (3, 1);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (3, 2);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (3, 6);

-- Facatativ�
-- Sede Facatativ� (algunas caracter�sticas)
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (4, 1);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (4, 5);

-- Soacha
-- Sede Soacha (algunas caracter�sticas)
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (5, 1);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (5, 3);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (5, 7);

-- Medell�n (capital)
-- Sede Poblado (todas las caracter�sticas)
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (6, 1);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (6, 2);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (6, 3);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (6, 4);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (6, 5);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (6, 6);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (6, 7);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (6, 8);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (6, 9);

-- Sede Laureles (algunas caracter�sticas)
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (7, 1);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (7, 2);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (7, 6);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (7, 9);

-- Bello
-- Sede Bello (algunas caracter�sticas)
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (8, 1);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (8, 5);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (8, 7);

-- Envigado
-- Sede Envigado (algunas caracter�sticas)
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (9, 1);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (9, 3);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (9, 8);

-- Armenia (capital)
-- Sede Armenia (todas las caracter�sticas)
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (10, 1);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (10, 2);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (10, 3);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (10, 4);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (10, 5);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (10, 6);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (10, 7);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (10, 8);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (10, 9);

-- Calarc�
-- Sede Calarc� (algunas caracter�sticas)
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (11, 1);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (11, 2);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (11, 7);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (11, 8);

-- Quito (capital)
-- Sede Norte Quito (todas las caracter�sticas)
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (12, 1);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (12, 2);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (12, 3);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (12, 4);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (12, 5);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (12, 6);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (12, 7);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (12, 8);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (12, 9);

-- Sede Centro Quito (algunas caracter�sticas)
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (13, 1);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (13, 3);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (13, 6);

-- Sangolqu�
-- Sede Sangolqu� (algunas caracter�sticas)
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (14, 1);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (14, 5);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (14, 9);

-- Cayambe
-- Sede Cayambe (algunas caracter�sticas)
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (15, 1);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (15, 4);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (15, 7);

-- Guayaquil (capital)
-- Sede Norte Guayaquil (debe tener todas las caracter�sticas)
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (12, 1);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (12, 2);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (12, 3);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (12, 4);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (12, 5);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (12, 6);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (12, 7);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (12, 8);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (12, 9);

-- Sede Centro Guayaquil (no puede tener todas las caracter�sticas)
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (13, 1);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (13, 2);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (13, 3);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (13, 4);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (13, 6);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (13, 7);

-- Cuenca (capital)
-- Sede Cuenca (debe tener todas las caracter�sticas)
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (14, 1);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (14, 2);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (14, 3);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (14, 4);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (14, 5);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (14, 6);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (14, 7);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (14, 8);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (14, 9);

-- Miraflores (no puede tener todas las caracter�sticas)
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (15, 1);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (15, 2);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (15, 4);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (15, 5);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (15, 6);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (15, 7);

-- Arequipa (capital)
-- Sede Arequipa (debe tener todas las caracter�sticas)
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (16, 1);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (16, 2);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (16, 3);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (16, 4);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (16, 5);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (16, 6);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (16, 7);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (16, 8);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (16, 9);

-- Ayacucho (no puede tener todas las caracter�sticas)
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (17, 1);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (17, 2);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (17, 3);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (17, 4);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (17, 5);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (17, 6);

-- Buenos Aires (capital)
-- Sede Palermo (debe tener todas las caracter�sticas)
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (18, 1);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (18, 2);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (18, 3);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (18, 4);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (18, 5);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (18, 6);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (18, 7);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (18, 8);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (18, 9);

-- Sede Recoleta (debe tener todas las caracter�sticas)
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (19, 1);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (19, 2);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (19, 3);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (19, 4);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (19, 5);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (19, 8);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (19, 9);

-- La Plata (no puede tener todas las caracter�sticas)
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (20, 1);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (20, 2);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (20, 3);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (20, 4);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (20, 5);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (20, 6);

-- Avellaneda (no puede tener todas las caracter�sticas)
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (21, 1);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (21, 2);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (21, 3);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (21, 4);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (21, 6);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (21, 7);

-- C�rdoba (capital)
-- Sede Nueva C�rdoba (debe tener todas las caracter�sticas)
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (22, 1);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (22, 2);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (22, 3);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (22, 4);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (22, 5);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (22, 6);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (22, 7);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (22, 8);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (22, 9);

-- Sede Centro C�rdoba (no puede tener todas las caracter�sticas)
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (23, 1);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (23, 2);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (23, 4);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (23, 5);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (23, 6);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (23, 7);

-- Sede Villa Carlos Paz (no puede tener todas las caracter�sticas)
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (23, 1);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (23, 2);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (23, 3);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (23, 4);

-- Sede R�o Cuarto (no puede tener todas las caracter�sticas)
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (24, 1);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (24, 2);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (24, 3);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (24, 4);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (24, 5);

-- San Miguel de Tucum�n (capital)
-- Sede Tucum�n (debe tener todas las caracter�sticas)
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (25, 1);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (25, 2);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (25, 3);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (25, 4);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (25, 5);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (25, 6);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (25, 7);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (25, 8);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (25, 9);

-- Santiago (capital)
-- Sede Providencia (no puede tener todas las caracter�sticas)
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (26, 1);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (26, 2);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (26, 3);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (26, 4);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (26, 5);

-- Sede Las Condes (debe tener todas las caracter�sticas)
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (27, 1);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (27, 2);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (27, 3);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (27, 4);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (27, 5);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (27, 6);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (27, 7);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (27, 8);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (27, 9);

-- Puente Alto (no puede tener todas las caracter�sticas)
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (28, 1);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (28, 2);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (28, 3);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (28, 4);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (28, 5);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (28, 6);

-- Maip� (no puede tener todas las caracter�sticas)
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (29, 1);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (29, 2);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (29, 3);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (29, 4);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (29, 5);

-- Valpara�so (capital)
-- Sede Valpara�so (debe tener todas las caracter�sticas)
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (30, 1);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (30, 2);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (30, 3);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (30, 4);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (30, 5);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (30, 6);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (30, 7);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (30, 8);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (30, 9);

-- Vi�a del Mar (no puede tener todas las caracter�sticas)
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (31, 1);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (31, 2);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (31, 3);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (31, 4);

-- Concepci�n (no puede tener todas las caracter�sticas)
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (32, 1);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (32, 2);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (32, 3);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (32, 4);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (32, 5);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (32, 8);

-- Ciudad de M�xico (capital)
-- Sede Polanco (no puede tener todas las caracter�sticas)
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (33, 1);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (33, 2);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (33, 3);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (33, 4);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (33, 7);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (33, 9);

-- Sede Roma (debe tener todas las caracter�sticas)
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (34, 1);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (34, 2);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (34, 3);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (34, 4);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (34, 5);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (34, 6);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (34, 7);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (34, 8);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (34, 9);

-- Guadalajara (capital)
-- Sede Guadalajara Centro (debe tener todas las caracter�sticas)
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (35, 1);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (35, 2);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (35, 3);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (35, 4);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (35, 5);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (35, 6);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (35, 7);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (35, 8);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (35, 9);

-- Sede Guadalajara Sur (no puede tener todas las caracter�sticas)
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (36, 1);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (36, 2);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (36, 3);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (36, 4);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (36, 5);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (36, 6);

-- Sede Guadalajara Norte (no puede tener todas las caracter�sticas)
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (37, 1);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (37, 2);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (37, 3);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (37, 4);

-- Sede Guadalajara Poniente (no puede tener todas las caracter�sticas)
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (38, 1);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (38, 2);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (38, 3);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (38, 8);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (38, 9);

-- Monterrey (capital)
-- Sede Monterrey Centro (debe tener todas las caracter�sticas)
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (39, 1);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (39, 2);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (39, 3);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (39, 4);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (39, 5);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (39, 6);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (39, 7);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (39, 8);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (39, 9);

-- Sede Monterrey Sur (no puede tener todas las caracter�sticas)
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (40, 1);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (40, 2);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (40, 3);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (40, 4);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (40, 5);

-- Sede Monterrey Norte (no puede tener todas las caracter�sticas)
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (41, 1);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (41, 2);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (41, 4);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (41, 5);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (41, 6);

-- San Luis Potos� (capital)
-- Sede San Luis Potos� Centro (debe tener todas las caracter�sticas)
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (42, 1);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (42, 2);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (42, 3);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (42, 4);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (42, 5);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (42, 6);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (42, 7);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (42, 8);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (42, 9);

-- Sede San Luis Potos� Norte (no puede tener todas las caracter�sticas)
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (43, 1);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (43, 2);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (43, 3);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (43, 4);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (43, 5);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (43, 7);

-- Quer�taro (capital)
-- Sede Quer�taro Centro (debe tener todas las caracter�sticas)
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (44, 1);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (44, 2);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (44, 3);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (44, 4);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (44, 5);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (44, 6);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (44, 7);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (44, 8);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (44, 9);

-- Sede Quer�taro Norte (no puede tener todas las caracter�sticas)
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (45, 1);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (45, 2);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (45, 3);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (45, 4);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (45, 5);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (45, 6);

-- Puebla (capital)
-- Sede Puebla Centro (debe tener todas las caracter�sticas)
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (46, 1);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (46, 2);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (46, 3);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (46, 4);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (46, 5);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (46, 6);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (46, 7);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (46, 8);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (46, 9);

-- Sede Puebla Sur (no puede tener todas las caracter�sticas)
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (47, 1);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (47, 2);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (47, 3);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (47, 4);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (47, 5);

-- Santa Cruz (capital)
-- Sede Santa Cruz Centro (debe tener todas las caracter�sticas)
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (48, 1);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (48, 2);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (48, 3);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (48, 4);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (48, 5);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (48, 6);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (48, 7);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (48, 8);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (48, 9);

-- Panam� (capital)
-- Sede Panam� Centro (debe tener todas las caracter�sticas)
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (61, 1);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (61, 2);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (61, 3);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (61, 4);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (61, 5);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (61, 6);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (61, 7);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (61, 8);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (61, 9);

-- Sede Albrook (no puede tener todas las caracter�sticas)
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (62, 1);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (62, 2);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (62, 3);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (62, 4);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (62, 5);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (62, 6);

-- San Miguelito
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (63, 1);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (63, 2);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (63, 3);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (63, 4);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (63, 7);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (63, 8);

-- Santiago de Veraguas
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (64, 1);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (64, 2);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (64, 3);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (64, 4);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (64, 5);

-- Las Tablas
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (65, 1);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (65, 2);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (65, 3);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (65, 4);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (65, 7);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (65, 9);

-- Guarar�
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (66, 1);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (66, 2);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (66, 3);

-- La Villa de Los Santos
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (67, 1);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (67, 2);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (67, 3);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (67, 4);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (67, 5);

-- Barcelona (capital)
-- Sede Barcelona Centro (debe tener todas las caracter�sticas)
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (68, 1);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (68, 2);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (68, 3);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (68, 4);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (68, 5);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (68, 6);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (68, 7);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (68, 8);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (68, 9);

-- Sede Eixample (no puede tener todas las caracter�sticas)
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (69, 1);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (69, 2);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (69, 3);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (69, 4);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (69, 5);

-- Tarragona
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (70, 1);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (70, 2);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (70, 3);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (70, 4);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (70, 5);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (70, 9);

-- Lleida
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (71, 1);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (71, 2);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (71, 3);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (71, 4);

-- Madrid (capital)
-- Sede Madrid Centro (debe tener todas las caracter�sticas)
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (72, 1);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (72, 2);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (72, 3);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (72, 4);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (72, 5);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (72, 6);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (72, 7);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (72, 8);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (72, 9);

-- Sede Madrid Norte (no puede tener todas las caracter�sticas)
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (73, 1);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (73, 2);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (73, 3);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (73, 4);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (73, 8);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (73, 9);

-- Alcal� de Henares
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (74, 1);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (74, 2);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (74, 3);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (74, 4);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (74, 5);

-- Getafe
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (75, 1);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (75, 2);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (75, 3);
INSERT INTO caracteristicas_sede (id_sede, id_caracteristica) VALUES (75, 4);

CREATE TABLE elementos_sede (
id NUMBER GENERATED ALWAYS AS IDENTITY,
id_elemento NUMBER NOT NULL,
id_sede NUMBER NOT NULL,
cantidad NUMBER(6) NOT NULL,
CONSTRAINT PK_elementos_sede PRIMARY KEY (id),
CONSTRAINT FK_elementos_sede_elemento FOREIGN KEY (id_elemento) REFERENCES elemento (id),
CONSTRAINT FK_elementos_sede_sede FOREIGN KEY (id_sede) REFERENCES sede (id)
)TABLESPACE ts_sedes;

--elementos_sede

-- Bogot� (capital)
-- Sede Norte (todas las caracter�sticas)
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

--Medell�n
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

--empleados
--sede 1
-- Entrenadores y Personal de Entrenamiento
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Ana', 'G�mez', '0000000000', TO_DATE('1985-04-15', 'YYYY-MM-DD'), '3001112233', 'ana.gomez@ejemplo.com', 1, 1, 1); -- Entrenador Personal
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Rogelio', 'G�mez', '0000000001', TO_DATE('1986-04-16', 'YYYY-MM-DD'), '3101112233', 'roge.gomez@ejemplo.com', 1, 1, 1); -- Entrenador Personal
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Eustaquio', 'P�rez', '0000000002', TO_DATE('1980-02-16', 'YYYY-MM-DD'), '3201112233', 'eus.gomez@ejemplo.com', 1, 1, 1); -- Entrenador Personal
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Luis', 'P�rez', '0000000003', TO_DATE('1983-08-22', 'YYYY-MM-DD'), '3001112234', 'luis.perez@ejemplo.com', 1, 1, 2); -- Instructor de Clases Grupales
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Carlos', 'Morales', '0000000004', TO_DATE('1987-11-30', 'YYYY-MM-DD'), '3001112235', 'carlos.morales@ejemplo.com', 1, 1, 3); -- Coordinador de Entrenamiento

-- Fisioterapeutas y Asistentes
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Sof�a', 'V�squez', '0000000005', TO_DATE('1986-02-14', 'YYYY-MM-DD'), '3001112236', 'sofia.vasquez@ejemplo.com', 1, 1, 4); -- Fisioterapeuta
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Julio', 'Ram�rez', '0000000006', TO_DATE('1990-06-25', 'YYYY-MM-DD'), '3001112237', 'julio.ramirez@ejemplo.com', 1, 1, 5); -- Rehabilitador Deportivo
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Laura', 'Garc�a', '0000000007', TO_DATE('1989-03-17', 'YYYY-MM-DD'), '3001112238', 'laura.garcia@ejemplo.com', 1, 1, 6); -- Asistente de Fisioterapia

-- Instructores para Ni�os
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Miguel', 'Hern�ndez', '0000000008', TO_DATE('1992-07-08', 'YYYY-MM-DD'), '3001112239', 'miguel.hernandez@ejemplo.com', 1, 1, 7); -- Instructor de Actividades para Ni�os
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Claudia', 'Mart�nez', '0000000009', TO_DATE('1984-12-05', 'YYYY-MM-DD'), '3001112240', 'claudia.martinez@ejemplo.com', 1, 1, 8); -- Cuidador

-- Mantenimiento y Atenci�n al Cliente
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Andr�s', 'Pineda', '0000000010', TO_DATE('1981-01-12', 'YYYY-MM-DD'), '3001112241', 'andres.pineda@ejemplo.com', 1, 1, 9); -- Operario de Mantenimiento
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Andrea', 'Pineda', '0000000011', TO_DATE('1981-01-12', 'YYYY-MM-DD'), '3001112241', 'andrea.pineda@ejemplo.com', 1, 1, 9); -- operario de Mantenimiento
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Ruperto', 'Pineda', '0000000012', TO_DATE('1981-01-13', 'YYYY-MM-DD'), '3011112241', 'ruperto.pineda@ejemplo.com', 1, 1, 11);
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Carmen', 'Hern�ndez', '0000000013', TO_DATE('1982-01-15', 'YYYY-MM-DD'), '3021112241', 'carme.hdz@ejemplo.com', 1, 1, 11);
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Juan', 'S�nchez', '0000000014', TO_DATE('1990-05-19', 'YYYY-MM-DD'), '3001112243', 'juan.sanchez@ejemplo.com', 1, 1, 11); -- Auxiliar de servicios generales
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Isabel', 'D�az', '0000000015', TO_DATE('1995-09-23', 'YYYY-MM-DD'), '3001112242', 'isabel.diaz@ejemplo.com', 1, 1, 10); -- Jefe de Mantenimiento

-- Atenci�n al Cliente y Nutrici�n
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Valeria', 'Moreno', '0000000016', TO_DATE('1988-11-11', 'YYYY-MM-DD'), '3001112244', 'valeria.moreno@ejemplo.com', 1, 1, 12); -- Auxiliar de Atenci�n al Cliente
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Camilo', 'G�mez', '0000000017', TO_DATE('1987-04-20', 'YYYY-MM-DD'), '3001112245', 'camilo.gomez@ejemplo.com', 1, 1, 13); -- Coordinador de Servicio al Cliente
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Gabriela', 'R�os', '0000000018', TO_DATE('1991-10-29', 'YYYY-MM-DD'), '3001112246', 'gabriela.rios@ejemplo.com', 1, 1, 14); -- Nutricionista
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Felipe', 'Cruz', '0000000019', TO_DATE('1994-03-12', 'YYYY-MM-DD'), '3001112247', 'felipe.cruz@ejemplo.com', 1, 1, 15); -- Asesor de Suplementaci�n

-- Otros roles
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Daniel', 'Pardo', '0000000020', TO_DATE('1982-07-07', 'YYYY-MM-DD'), '3001112248', 'daniel.pardo@ejemplo.com', 1, 1, 16); -- Abogado Corporativo
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Samantha', 'Vega', '0000000021', TO_DATE('1993-12-01', 'YYYY-MM-DD'), '3001112249', 'samantha.vega@ejemplo.com', 1, 1, 17); -- Asistente Legal
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Mart�n', 'N��ez', '0000000022', TO_DATE('1986-06-28', 'YYYY-MM-DD'), '3001112250', 'martin.nunez@ejemplo.com', 1, 1, 18); -- Gerente de Marketing
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Paola', 'Castro', '0000000023', TO_DATE('1990-10-15', 'YYYY-MM-DD'), '3001112251', 'paola.castro@ejemplo.com', 1, 1, 19); -- Publicista
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Esteban', 'Ardila', '0000000024', TO_DATE('1985-08-11', 'YYYY-MM-DD'), '3001112252', 'esteban.ardila@ejemplo.com', 1, 1, 20); -- Dise�ador
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Mariana', 'Ardila', '0000000025', TO_DATE('1989-08-12', 'YYYY-MM-DD'), '3001782252', 'mariana.ardila@ejemplo.com', 1, 1, 20); -- Dise�ador

-- Gerentes y Contador
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Rafael', 'C�rdoba', '0000000026', TO_DATE('1983-09-10', 'YYYY-MM-DD'), '3001112253', 'rafael.cordoba@ejemplo.com', 1, 1, 21); -- Gerente de general
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Daniela', 'Salazar', '0000000027', TO_DATE('1988-01-29', 'YYYY-MM-DD'), '3001112254', 'daniela.salazar@ejemplo.com', 1, 1, 22); -- Gerente de sede
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Alejandro', 'Valencia', '0000000028', TO_DATE('1986-04-20', 'YYYY-MM-DD'), '3001112255', 'alejandro.valencia@ejemplo.com', 1, 1, 23); -- Contador
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Natalia', 'Paniagua', '0000000029', TO_DATE('1992-11-05', 'YYYY-MM-DD'), '3001112256', 'natalia.paniagua@ejemplo.com', 1, 1, 24); -- Asistente Administrativo
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Natalia', 'Paniagua', '0000000030', TO_DATE('1992-11-05', 'YYYY-MM-DD'), '3001112256', 'natalia.paniagua@ejemplo.com', 1, 1, 24); -- Asistente Administrativo

--sede 2
-- Entrenadores y Personal de Entrenamiento
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Ana', 'G�mez', '0000000031', TO_DATE('1985-04-15', 'YYYY-MM-DD'), '5701112233', 'ana.gomez@ejemploo.com', 1, 2, 1); -- Entrenador Personal
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Rogelio', 'G�mez', '0000000032', TO_DATE('1986-04-16', 'YYYY-MM-DD'), '5801112233', 'roge.gomez@ejemploo.com', 1, 2, 1); -- Entrenador Personal
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Eustaquio', 'P�rez', '0000000033', TO_DATE('1980-02-16', 'YYYY-MM-DD'), '5901112233', 'eus.gomez@ejemploo.com', 1, 2, 1); -- Entrenador Personal
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Luis', 'P�rez', '0000000034', TO_DATE('1983-08-22', 'YYYY-MM-DD'), '6001112234', 'luis.perez@ejemploo.com', 1, 2, 2); -- Instructor de Clases Grupales
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Carlos', 'Morales', '0000000035', TO_DATE('1987-11-30', 'YYYY-MM-DD'), '6101112235', 'carlos.morales@ejemploo.com', 1, 2, 3); -- Coordinador de Entrenamiento

-- Mantenimiento y Atenci�n al Cliente
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Andr�s', 'Pineda', '0000000036', TO_DATE('1981-01-12', 'YYYY-MM-DD'), '6201112241', 'andres.pineda@ejemploo.com', 1, 2, 9); -- Operario de Mantenimiento
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Andrea', 'Pineda', '0000000037', TO_DATE('1981-01-12', 'YYYY-MM-DD'), '6301112241', 'andrea.pineda@ejemploo.com', 1, 2, 9); -- Operario de Mantenimiento
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Ruperto', 'Pineda', '0000000038', TO_DATE('1981-01-13', 'YYYY-MM-DD'), '6411112241', 'ruperto.pineda@ejemploo.com', 1, 2, 11); -- Auxiliar de servicios generales
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Carmen', 'Hern�ndez', '0000000039', TO_DATE('1982-01-15', 'YYYY-MM-DD'), '6521112241', 'carme.hdz@ejemploo.com', 1, 2, 11); -- Auxiliar de servicios generales
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Juan', 'S�nchez', '0000000040', TO_DATE('1990-05-19', 'YYYY-MM-DD'), '6601112243', 'juan.sanchez@ejemploo.com', 1, 2, 11); -- Auxiliar de servicios generales
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Isabel', 'D�az', '0000000041', TO_DATE('1995-09-23', 'YYYY-MM-DD'), '6701112242', 'isabel.diaz@ejemploo.com', 1, 2, 10); -- Jefe de Mantenimiento

--sede 3
-- Entrenadores y Coordinador de Entrenamiento
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Ana', 'G�mez', '0000000042', TO_DATE('1985-04-15', 'YYYY-MM-DD'), '5701112233', 'ana.gomez@ejemplo.com.co', 1, 3, 1); -- Entrenador Personal
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Rogelio', 'G�mez', '0000000043', TO_DATE('1986-04-16', 'YYYY-MM-DD'), '5801112233', 'roge.gomez@ejemplo.com.co', 1, 3, 1); -- Entrenador Personal
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Eustaquio', 'P�rez', '0000000044', TO_DATE('1980-02-16', 'YYYY-MM-DD'), '5901112233', 'eus.perez@ejemplo.com.co', 1, 3, 1); -- Entrenador Personal
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Luis', 'P�rez', '0000000045', TO_DATE('1983-08-22', 'YYYY-MM-DD'), '6001112234', 'luis.perez@ejemplo.com.co', 1, 3, 2); -- Instructor de Clases Grupales
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Carlos', 'Morales', '0000000046', TO_DATE('1987-11-30', 'YYYY-MM-DD'), '6101112235', 'carlos.morales@ejemplo.com.co', 1, 3, 3); -- Coordinador de Entrenamiento
-- Mantenimiento y Atenci�n al Cliente
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Andr�s', 'Pineda', '0000000047', TO_DATE('1981-01-12', 'YYYY-MM-DD'), '6201112241', 'andres.pineda@ejemplo.com.co', 1, 3, 9); -- Operario de Mantenimiento
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Andrea', 'Pineda', '0000000048', TO_DATE('1981-01-12', 'YYYY-MM-DD'), '6301112241', 'andrea.pineda@ejemplo.com.co', 1, 3, 9); -- Operario de Mantenimiento
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Ruperto', 'Pineda', '0000000049', TO_DATE('1981-01-13', 'YYYY-MM-DD'), '6411112241', 'ruperto.pineda@ejemplo.com.co', 1, 3, 11); -- Auxiliar de Servicios Generales
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Carmen', 'Hern�ndez', '0000000050', TO_DATE('1982-01-15', 'YYYY-MM-DD'), '6521112241', 'carmen.hernandez@ejemplo.com.co', 1, 3, 11); -- Auxiliar de Servicios Generales
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Juan', 'S�nchez', '0000000051', TO_DATE('1990-05-19', 'YYYY-MM-DD'), '6601112243', 'juan.sanchez@ejemplo.com.co', 1, 3, 11); -- Auxiliar de Servicios Generales
INSERT INTO empleado (nombre, apellido, dni, fecha_nacimiento, telefono, email, estado, id_sede, id_cargo) VALUES ('Isabel', 'D�az', '0000000052', TO_DATE('1995-09-23', 'YYYY-MM-DD'), '6701112242', 'isabel.diaz@ejemplo.com.co', 1, 3, 10); -- Jefe de Mantenimiento

--Clientes
-- Clientes para Sede Norte (Bogot�)
INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES 
('Carlos', 'G�mez', '0000000053', TO_DATE('1985-05-20', 'YYYY-MM-DD'), '3101234567', 'carlos.gomez1@yipmail.com', TO_DATE('2024-09-30', 'YYYY-MM-DD'), 1, 1);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES 
('Laura', 'Mart�nez', '0000000054', TO_DATE('1990-07-12', 'YYYY-MM-DD'), '3102345678', 'laura.martinez1@yipmail.com', TO_DATE('2024-10-15', 'YYYY-MM-DD'), 1, 2);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES 
('Andr�s', 'Hern�ndez', '0000000055', TO_DATE('1982-11-30', 'YYYY-MM-DD'), '3103456789', 'andres.hernandez1@yipmail.com', TO_DATE('2024-11-20', 'YYYY-MM-DD'), 1, 3);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES 
('Sofia', 'Jim�nez', '0000000056', TO_DATE('1987-02-25', 'YYYY-MM-DD'), '3104567890', 'sofia.jimenez1@yipmail.com', TO_DATE('2024-12-05', 'YYYY-MM-DD'), 1, 4);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES 
('Juan', 'P�rez', '0000000057', TO_DATE('1995-09-14', 'YYYY-MM-DD'), '3105678901', 'juan.perez1@yipmail.com', TO_DATE('2025-01-10', 'YYYY-MM-DD'), 1, 5);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES 
('Ana', 'Torres', '0000000058', TO_DATE('1992-04-21', 'YYYY-MM-DD'), '3106789012', 'ana.torres1@yipmail.com', TO_DATE('2025-02-28', 'YYYY-MM-DD'), 1, 6);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES 
('Luis', 'Fern�ndez', '0000000059', TO_DATE('1988-08-15', 'YYYY-MM-DD'), '3107890123', 'luis.fernandez1@yipmail.com', TO_DATE('2025-03-22', 'YYYY-MM-DD'), 1, 7);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES 
('Valeria', 'Castro', '0000000060', TO_DATE('1991-12-03', 'YYYY-MM-DD'), '3108901234', 'valeria.castro1@yipmail.com', TO_DATE('2025-04-10', 'YYYY-MM-DD'), 1, 8);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES 
('Felipe', 'Moreno', '0000000061', TO_DATE('1994-06-17', 'YYYY-MM-DD'), '3109012345', 'felipe.moreno1@yipmail.com', TO_DATE('2025-05-18', 'YYYY-MM-DD'), 1, 9);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES 
('Camila', 'Ramos', '0000000062', TO_DATE('1986-10-10', 'YYYY-MM-DD'), '3100123456', 'camila.ramos1@yipmail.com', TO_DATE('2025-06-25', 'YYYY-MM-DD'), 1, 10);

-- Clientes para Sede Centro (Bogot�)
INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES 
('Carlos', 'G�mez', '0000000063', TO_DATE('1985-05-20', 'YYYY-MM-DD'), '3101234567', 'carlos.gomez2@yipmail.com', TO_DATE('2024-09-30', 'YYYY-MM-DD'), 2, 1);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES 
('Laura', 'Mart�nez', '0000000064', TO_DATE('1990-07-12', 'YYYY-MM-DD'), '3102345678', 'laura.martinez2@yipmail.com', TO_DATE('2024-10-15', 'YYYY-MM-DD'), 2, 2);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES 
('Andr�s', 'Hern�ndez', '0000000065', TO_DATE('1982-11-30', 'YYYY-MM-DD'), '3103456789', 'andres.hernandez2@yipmail.com', TO_DATE('2024-11-20', 'YYYY-MM-DD'), 2, 3);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES 
('Sofia', 'Jim�nez', '0000000066', TO_DATE('1987-02-25', 'YYYY-MM-DD'), '3104567890', 'sofia.jimenez2@yipmail.com', TO_DATE('2024-12-05', 'YYYY-MM-DD'), 2, 4);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES 
('Juan', 'P�rez', '0000000067', TO_DATE('1995-09-14', 'YYYY-MM-DD'), '3105678901', 'juan.perez2@yipmail.com', TO_DATE('2025-01-10', 'YYYY-MM-DD'), 2, 5);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES 
('Ana', 'Torres', '0000000068', TO_DATE('1992-04-21', 'YYYY-MM-DD'), '3106789012', 'ana.torres2@yipmail.com', TO_DATE('2025-02-28', 'YYYY-MM-DD'), 2, 6);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES 
('Luis', 'Fern�ndez', '0000000069', TO_DATE('1988-08-15', 'YYYY-MM-DD'), '3107890123', 'luis.fernandez2@yipmail.com', TO_DATE('2025-03-22', 'YYYY-MM-DD'), 2, 7);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES 
('Valeria', 'Castro', '0000000070', TO_DATE('1991-12-03', 'YYYY-MM-DD'), '3108901234', 'valeria.castro2@yipmail.com', TO_DATE('2025-04-10', 'YYYY-MM-DD'), 2, 8);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES 
('Felipe', 'Moreno', '0000000071', TO_DATE('1994-06-17', 'YYYY-MM-DD'), '3109012345', 'felipe.moreno2@yipmail.com', TO_DATE('2025-05-18', 'YYYY-MM-DD'), 2, 9);

-- Clientes para Sede Occidente (Bogot�)
INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES 
('Carlos', 'G�mez', '0000000072', TO_DATE('1985-05-20', 'YYYY-MM-DD'), '3101234567', 'carlos.gomez3@yipmail.com', TO_DATE('2024-09-30', 'YYYY-MM-DD'), 3, 1);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES 
('Laura', 'Mart�nez', '0000000073', TO_DATE('1990-07-12', 'YYYY-MM-DD'), '3102345678', 'laura.martinez3@yipmail.com', TO_DATE('2024-10-15', 'YYYY-MM-DD'), 3, 2);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES 
('Andr�s', 'Hern�ndez', '0000000074', TO_DATE('1982-11-30', 'YYYY-MM-DD'), '3103456789', 'andres.hernandez3@yipmail.com', TO_DATE('2024-11-20', 'YYYY-MM-DD'), 3, 3);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES 
('Sofia', 'Jim�nez', '0000000075', TO_DATE('1987-02-25', 'YYYY-MM-DD'), '3104567890', 'sofia.jimenez3@yipmail.com', TO_DATE('2024-12-05', 'YYYY-MM-DD'), 3, 4);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES 
('Juan', 'P�rez', '0000000076', TO_DATE('1995-09-14', 'YYYY-MM-DD'), '3105678901', 'juan.perez3@yipmail.com', TO_DATE('2025-01-10', 'YYYY-MM-DD'), 3, 5);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES 
('Ana', 'Torres', '0000000077', TO_DATE('1992-04-21', 'YYYY-MM-DD'), '3106789012', 'ana.torres3@yipmail.com', TO_DATE('2025-02-28', 'YYYY-MM-DD'), 3, 6);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES 
('Luis', 'Fern�ndez', '0000000078', TO_DATE('1988-08-15', 'YYYY-MM-DD'), '3107890123', 'luis.fernandez3@yipmail.com', TO_DATE('2025-03-22', 'YYYY-MM-DD'), 3, 7);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES 
('Valeria', 'Castro', '0000000079', TO_DATE('1991-12-03', 'YYYY-MM-DD'), '3108901234', 'valeria.castro3@yipmail.com', TO_DATE('2025-04-10', 'YYYY-MM-DD'), 3, 8);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES 
('Felipe', 'Moreno', '0000000080', TO_DATE('1994-06-17', 'YYYY-MM-DD'), '3109012345', 'felipe.moreno3@yipmail.com', TO_DATE('2025-05-18', 'YYYY-MM-DD'), 3, 9);

INSERT INTO cliente (nombre, apellido, dni, fecha_nacimiento, telefono, email, activo_hasta, id_sede_principal, id_membresia) VALUES 
('Camila', 'Ramos', '0000000081', TO_DATE('1986-10-10', 'YYYY-MM-DD'), '3100123456', 'camila.ramos3@yipmail.com', TO_DATE('2025-06-25', 'YYYY-MM-DD'), 3, 10);


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

--historial de visitas

--venta

--productos venta

--Creaci�n de roles
CREATE ROLE C##rol_administrativo;
GRANT SELECT ON pais TO C##rol_administrativo;
GRANT SELECT ON estado TO C##rol_administrativo;
GRANT SELECT ON ciudad TO C##rol_administrativo;
GRANT SELECT ON sede TO C##rol_administrativo;
GRANT SELECT ON elemento TO C##rol_administrativo;
GRANT SELECT ON elementos_sede TO C##rol_administrativo;
GRANT SELECT ON caracteristica TO C##rol_administrativo;
GRANT SELECT ON caracteristicas_sede TO C##rol_administrativo;
GRANT SELECT ON cliente TO C##rol_administrativo;
GRANT SELECT ON membresia TO C##rol_administrativo;
GRANT SELECT ON historial_visitas TO C##rol_administrativo;
GRANT SELECT ON departamento TO C##rol_administrativo;
GRANT SELECT ON cargo TO C##rol_administrativo;
GRANT SELECT ON empleado TO C##rol_administrativo;
GRANT SELECT ON producto TO C##rol_administrativo;
GRANT SELECT ON productos_sede TO C##rol_administrativo;
GRANT SELECT ON venta TO C##rol_administrativo;
GRANT SELECT ON productos_venta TO C##rol_administrativo;
GRANT CREATE SESSION TO C##rol_administrativo;
GRANT CREATE SYNONYM TO C##rol_administrativo;


--tablespace temporal para un usuario
CREATE TEMPORARY TABLESPACE tts_gerente
TEMPFILE 'C:\database_admin\tts_gerente.dbf'
SIZE 10M
AUTOEXTEND ON
NEXT 5M
MAXSIZE 100M;

CREATE TABLESPACE ts_default_users
DATAFILE 'C:\database_admin\ts_default_users.dbf'
SIZE 5M;

CREATE USER C##gerente
IDENTIFIED BY "g1$2024E&";

GRANT C##rol_administrativo TO C##gerente;

DROP USER C##gerente CASCADE;
ALTER USER C##gerente TEMPORARY TABLESPACE tts_gerente;

select name from SYSTEM_PRIVILEGE_MAP where name like '%SYNONYM%';

select TABLESPACE_NAME name from DBA_TABLESPACES;

select * from USER_TABLESPACES;

--Eliminaci�n de tablas
DROP TABLE pais CASCADE CONSTRAINTS;
DROP TABLE estado CASCADE CONSTRAINTS;
DROP TABLE ciudad CASCADE CONSTRAINTS;
DROP TABLE sede CASCADE CONSTRAINTS;
DROP TABLE elemento CASCADE CONSTRAINTS;
DROP TABLE elementos_sede CASCADE CONSTRAINTS;
DROP TABLE caracteristica CASCADE CONSTRAINTS;
DROP TABLE caracteristicas_sede CASCADE CONSTRAINTS;
DROP TABLE departamento CASCADE CONSTRAINTS;
DROP TABLE cargo CASCADE CONSTRAINTS;
DROP TABLE empleado CASCADE CONSTRAINTS;
DROP TABLE membresia CASCADE CONSTRAINTS;
DROP TABLE cliente CASCADE CONSTRAINTS;
DROP TABLE historial_visitas CASCADE CONSTRAINTS;
DROP TABLE producto CASCADE CONSTRAINTS;
DROP TABLE productos_sede CASCADE CONSTRAINTS;
DROP TABLE venta CASCADE CONSTRAINTS;
DROP TABLE productos_venta CASCADE CONSTRAINTS;

--Eliminaci�n de tablespaces
DROP TABLESPACE ts_undo INCLUDING CONTENTS AND DATAFILES;
DROP TABLESPACE ts_productos_ventas INCLUDING CONTENTS AND DATAFILES;
DROP TABLESPACE ts_empleados INCLUDING CONTENTS AND DATAFILES;
DROP TABLESPACE ts_territorios INCLUDING CONTENTS AND DATAFILES;
DROP TABLESPACE ts_clientes INCLUDING CONTENTS AND DATAFILES;
DROP TABLESPACE ts_sedes INCLUDING CONTENTS AND DATAFILES;
DROP TABLESPACE tts_gerente INCLUDING CONTENTS AND DATAFILES;
DROP TABLESPACE ts_default_users INCLUDING CONTENTS AND DATAFILES;

--Eliminaci�n de usuarios y roles
DROP USER C##gerente CASCADE;
DROP ROLE C##rol_administrativo;