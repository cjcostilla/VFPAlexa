LPARAMETERS xoclientes

ADDPROPERTY(xoclientes, "oxid_ABM_regiones", _sincroaregion)
ADDPROPERTY(xoclientes, "oxid_ABM_usuarios", _sincroausuario)
ADDPROPERTY(xoclientes, "oxid_ABM_empresas", _sincroaempresa)

ADDPROPERTY(xoclientes, "_reparto_lunes", IIF(xoclientes.lunes = .T., 1, 0))
ADDPROPERTY(xoclientes, "_reparto_martes", IIF(xoclientes.martes = .T., 1, 0))
ADDPROPERTY(xoclientes, "_reparto_miercoles", IIF(xoclientes.miercoles = .T., 1, 0))
ADDPROPERTY(xoclientes, "_reparto_jueves", IIF(xoclientes.jueves = .T., 1, 0))
ADDPROPERTY(xoclientes, "_reparto_viernes", IIF(xoclientes.viernes = .T., 1, 0))
ADDPROPERTY(xoclientes, "_reparto_sabado", IIF(xoclientes.sabado = .T., 1, 0))
ADDPROPERTY(xoclientes, "_reparto_domingo", IIF(xoclientes.domingo = .T., 1, 0))

ADDPROPERTY(xoclientes, "_trigger_engine", _SCREEN.engine)
ADDPROPERTY(xoclientes, "_trigger_handle_driver", _SCREEN.handle_driver)
ADDPROPERTY(xoclientes, "_trigger_handle_server", _SCREEN.handle_server)
ADDPROPERTY(xoclientes, "_trigger_handle_user", _SCREEN.handle_user)
ADDPROPERTY(xoclientes, "_trigger_handle_password", _SCREEN.handle_password)
ADDPROPERTY(xoclientes, "_trigger_handle_database", _SCREEN.handle_database)
ADDPROPERTY(xoclientes, "_trigger_handle_port", _SCREEN.handle_port)
ADDPROPERTY(xoclientes, "_path","'"+ALLTRIM(JUSTPATH(FULLPATH("odb_connect_winfx.prg")))+"\'")

SET PATH TO  xoclientes._path  ADDITIVE

odb_connect_winfx( xoclientes._trigger_engine ;
	, xoclientes._trigger_handle_driver ;
	, xoclientes._trigger_handle_server ;
	, xoclientes._trigger_handle_user ;
	, xoclientes._trigger_handle_password ;
	, xoclientes._trigger_handle_database ;
	, xoclientes._trigger_handle_port )

SET TABLEPROMPT OFF
SET CPDIALOG OFF
SET DELETED OFF

TRY
	_plan_de_fidelizacion_codigo = ALLTRIM(UPPER(STR(xoclientes.codigo_maxima)))
CATCH TO oex
	_plan_de_fidelizacion_codigo = ""
FINALLY
ENDTRY

_sqlTabla = "ABM_localidades"
_sqlCursor = "SQL_localidad"
cConsultaid = 'SELECT id FROM ' + _sqlTabla ;
	+ ' WHERE TRIM(UPPER(nombre)) = "'+ ALLTRIM(UPPER(xoclientes.localidad));
	+'" AND  id_ABM_empresas = ' + ALLTRIM(STR(xoclientes.oxid_ABM_empresas))

odb.QUERY(cConsultaid , _sqlCursor, _sqlTabla)
IF odb.CursorOpen(_sqlCursor)
	SELECT &_sqlCursor
	IF RECCOUNT() > 0
		_id_ABM_localidades = ID
	ELSE
		_id_ABM_localidades = 0 &&NULL
	ENDIF
ENDIF

_sqlTabla = "ABM_provincias"
_sqlCursor = "SQL_provincias"
cConsultaid = 'SELECT id FROM ' + _sqlTabla ;
	+ ' WHERE TRIM(UPPER(nombre)) = "'+ ALLTRIM(UPPER(xoclientes.provincia));
	+'" AND  id_ABM_empresas = ' + ALLTRIM(STR(xoclientes.oxid_ABM_empresas))


odb.QUERY(cConsultaid , _sqlCursor, _sqlTabla)
IF odb.CursorOpen(_sqlCursor)
	SELECT &_sqlCursor
	IF RECCOUNT() > 0
		_id_ABM_Provincias = ID
	ELSE
		_id_ABM_Provincias = 0 &&NULL
	ENDIF
ENDIF

_sqlTabla = "ABM_Ciudades"
_sqlCursor = "SQL_Ciudades"
cConsultaid = 'SELECT id FROM ' + _sqlTabla ;
	+ ' WHERE TRIM(UPPER(nombre)) = "'+ ALLTRIM(UPPER(xoclientes.ciudad));
	+'" AND  id_ABM_empresas = ' + ALLTRIM(STR(xoclientes.oxid_ABM_empresas))


odb.QUERY(cConsultaid , _sqlCursor, _sqlTabla)
IF odb.CursorOpen(_sqlCursor)
	SELECT &_sqlCursor
	IF RECCOUNT() > 0
		_id_ABM_Ciudades = ID
	ELSE
		_id_ABM_Ciudades = 0 &&NULL
	ENDIF
ENDIF

_sqlTabla = "ABM_Municipios"
_sqlCursor = "SQL_Municipios"
cConsultaid = 'SELECT id FROM ' + _sqlTabla ;
	+ ' WHERE TRIM(UPPER(nombre)) = "'+ ALLTRIM(UPPER(xoclientes.municipio));
	+'" AND  id_ABM_empresas = ' + ALLTRIM(STR(xoclientes.oxid_ABM_empresas))


odb.QUERY(cConsultaid , _sqlCursor, _sqlTabla)
IF odb.CursorOpen(_sqlCursor)
	SELECT &_sqlCursor
	IF RECCOUNT() > 0
		_id_ABM_Municipios = ID
	ELSE
		_id_ABM_Municipios = 0 &&NULL
	ENDIF
ENDIF


_sqlTabla = "ABM_Regiones"
_sqlCursor = "SQL_Regiones"
cConsultaid = 'SELECT id FROM ' + _sqlTabla ;
	+ ' WHERE TRIM(UPPER(nombre)) = "'+ ALLTRIM(UPPER(xoclientes.pais)) + '"'

odb.QUERY(cConsultaid , _sqlCursor, _sqlTabla)
IF odb.CursorOpen(_sqlCursor)
	SELECT &_sqlCursor
	IF RECCOUNT() > 0
		_id_ABM_Regiones_1 = ID
	ELSE
		_id_ABM_Regiones_1 = 0 &&NULL
	ENDIF
ENDIF

_sqlTabla = "ABM_Calificacion_de_Clientes"
_sqlCursor = "SQL_Calificacion_de_Clientes"
cConsultaid = 'SELECT id FROM ' + _sqlTabla ;
	+ ' WHERE TRIM(UPPER(nombre)) = "'+ ALLTRIM(UPPER(xoclientes.orden));
	+'" AND  id_ABM_empresas = ' + ALLTRIM(STR(xoclientes.oxid_ABM_empresas))

odb.QUERY(cConsultaid , _sqlCursor, _sqlTabla)
IF odb.CursorOpen(_sqlCursor)
	SELECT &_sqlCursor
	IF RECCOUNT() > 0
		_id_ABM_Calificacion_de_Clientes = ID
	ELSE
		_id_ABM_Calificacion_de_Clientes = 0 &&NULL
	ENDIF
ENDIF

_sqlTabla = "ABM_Categorias_impositivas"
_sqlCursor = "SQL_Categorias_impositivas"
cConsultaid = 'SELECT id FROM ' + _sqlTabla ;
	+ ' WHERE TRIM(UPPER(nombre)) = "'+ ALLTRIM(UPPER(xoclientes.CLAS));
	+'" AND  id_ABM_empresas = ' + ALLTRIM(STR(xoclientes.oxid_ABM_empresas))

odb.QUERY(cConsultaid , _sqlCursor, _sqlTabla)
IF odb.CursorOpen(_sqlCursor)
	SELECT &_sqlCursor
	IF RECCOUNT() > 0
		_id_ABM_Categoria_impositiva = ID
	ELSE
		_id_ABM_Categoria_impositiva = 0 &&NULL
	ENDIF
ENDIF

_sqlTabla = "ABM_Condiciones_de_venta"
_sqlCursor = "SQL_Condiciones_de_venta"
cConsultaid = 'SELECT id FROM ' + _sqlTabla ;
	+ ' WHERE TRIM(UPPER(nombre)) = "'+ ALLTRIM(UPPER(xoclientes.condvta));
	+'" AND  id_ABM_empresas = ' + ALLTRIM(STR(xoclientes.oxid_ABM_empresas))

odb.QUERY(cConsultaid , _sqlCursor, _sqlTabla)
IF odb.CursorOpen(_sqlCursor)
	SELECT &_sqlCursor
	IF RECCOUNT() > 0
		_id_ABM_Condiciones_de_venta = ID
	ELSE
		_id_ABM_Condiciones_de_venta = 0 &&NULL
	ENDIF
ENDIF

_sqlTabla = "ABM_Condiciones_de_venta"
_sqlCursor = "SQL_Condiciones_de_venta"
cConsultaid = 'SELECT id FROM ' + _sqlTabla ;
	+ ' WHERE TRIM(UPPER(nombre)) = "'+ ALLTRIM(UPPER(xoclientes.condvta));
	+'" AND  id_ABM_empresas = ' + ALLTRIM(STR(xoclientes.oxid_ABM_empresas))

odb.QUERY(cConsultaid , _sqlCursor, _sqlTabla)
IF odb.CursorOpen(_sqlCursor)
	SELECT &_sqlCursor
	IF RECCOUNT() > 0
		_id_ABM_Condiciones_de_venta = ID
	ELSE
		_id_ABM_Condiciones_de_venta = 0 &&NULL
	ENDIF
ENDIF

_sqlTabla = "ABM_Cuentas_Contables"
_sqlCursor = "SQL_Cuentas_Contables"
cConsultaid = 'SELECT id FROM ' + _sqlTabla ;
	+ ' WHERE TRIM(UPPER(nombre)) = "'+ ALLTRIM(UPPER(xoclientes.cuenta));
	+'" AND  id_ABM_empresas = ' + ALLTRIM(STR(xoclientes.oxid_ABM_empresas))

odb.QUERY(cConsultaid , _sqlCursor, _sqlTabla)
IF odb.CursorOpen(_sqlCursor)
	SELECT &_sqlCursor
	IF RECCOUNT() > 0
		_id_ABM_Cuentas_Contables = ID
	ELSE
		_id_ABM_Cuentas_Contables = 0 &&NULL
	ENDIF
ENDIF

_sqlTabla = "ABM_POLITICAS_DE_PRECIOS_DE_SERVICIOS_CABECERA"
_sqlCursor = "SQL_politicas_de_precios_de_servicios_cabecera"
cConsultaid = 'SELECT id FROM ' + _sqlTabla ;
	+ ' WHERE TRIM(UPPER(nombre)) = "'+ ALLTRIM(UPPER(xoclientes.polprserv));
	+'" AND  id_ABM_empresas = ' + ALLTRIM(STR(xoclientes.oxid_ABM_empresas))

odb.QUERY(cConsultaid , _sqlCursor, _sqlTabla)
IF odb.CursorOpen(_sqlCursor)
	SELECT &_sqlCursor
	IF RECCOUNT() > 0
		_id_ABM_Politica_de_Precios_Servicios = ID
	ELSE
		_id_ABM_Politica_de_Precios_Servicios = 0 &&NULL
	ENDIF
ENDIF

_sqlTabla = "ABM_Zonas"
_sqlCursor = "SQL_Zonas"
cConsultaid = 'SELECT id FROM ' + _sqlTabla ;
	+ ' WHERE TRIM(UPPER(nombre)) = "'+ ALLTRIM(UPPER(xoclientes.zona));
	+'" AND  id_ABM_empresas = ' + ALLTRIM(STR(xoclientes.oxid_ABM_empresas))

odb.QUERY(cConsultaid , _sqlCursor, _sqlTabla)
IF odb.CursorOpen(_sqlCursor)
	SELECT &_sqlCursor
	IF RECCOUNT() > 0
		_ID_ABM_Zona = ID
	ELSE
		_ID_ABM_Zona = 0 &&NULL
	ENDIF
ENDIF

_sqlTabla = "ABM_Vendedores"
_sqlCursor = "SQL_Vendedores"
cConsultaid = 'SELECT id FROM ' + _sqlTabla ;
	+ ' WHERE TRIM(UPPER(nombre)) = "'+ ALLTRIM(UPPER(xoclientes.vendedor));
	+'" AND  id_ABM_empresas = ' + ALLTRIM(STR(xoclientes.oxid_ABM_empresas))

odb.QUERY(cConsultaid , _sqlCursor, _sqlTabla)
IF odb.CursorOpen(_sqlCursor)
	SELECT &_sqlCursor
	IF RECCOUNT() > 0
		_ID_ABM_Vendedor = ID
	ELSE
		_ID_ABM_Vendedor = 0 &&NULL
	ENDIF
ENDIF

_sqlTabla = "ABM_CRM_Resultados"
_sqlCursor = "SQL_CRM_Resultados"
cConsultaid = 'SELECT id FROM ' + _sqlTabla ;
	+ ' WHERE TRIM(UPPER(nombre)) = "'+ ALLTRIM(UPPER(xoclientes.resultado));
	+'" AND  id_ABM_empresas = ' + ALLTRIM(STR(xoclientes.oxid_ABM_empresas))

odb.QUERY(cConsultaid , _sqlCursor, _sqlTabla)
IF odb.CursorOpen(_sqlCursor)
	SELECT &_sqlCursor
	IF RECCOUNT() > 0
		_id_ABM_CRM_Resultados = ID
	ELSE
		_id_ABM_CRM_Resultados = 0 &&NULL
	ENDIF
ENDIF

_sqlTabla = "ABM_Rubros"
_sqlCursor = "SQL_Rubros"
cConsultaid = 'SELECT id FROM ' + _sqlTabla ;
	+ ' WHERE TRIM(UPPER(nombre)) = "'+ ALLTRIM(UPPER(xoclientes.rubro));
	+'" AND  id_ABM_empresas = ' + ALLTRIM(STR(xoclientes.oxid_ABM_empresas))

odb.QUERY(cConsultaid , _sqlCursor, _sqlTabla)
IF odb.CursorOpen(_sqlCursor)
	SELECT &_sqlCursor
	IF RECCOUNT() > 0
		_id_ABM_Rubro = ID
	ELSE
		_id_ABM_Rubro = 0 &&NULL
	ENDIF
ENDIF

_sqlTabla = "ABM_CRM_Situacion_contacto"
_sqlCursor = "SQL_CRM_Situacion_contacto"
cConsultaid = 'SELECT id FROM ' + _sqlTabla ;
	+ ' WHERE TRIM(UPPER(nombre)) = "'+ ALLTRIM(UPPER(xoclientes.situacion));
	+'" AND  id_ABM_empresas = ' + ALLTRIM(STR(xoclientes.oxid_ABM_empresas))

odb.QUERY(cConsultaid , _sqlCursor, _sqlTabla)
IF odb.CursorOpen(_sqlCursor)
	SELECT &_sqlCursor
	IF RECCOUNT() > 0
		_id_ABM_CRM_Situacion_contacto = ID
	ELSE
		_id_ABM_CRM_Situacion_contacto = 0 &&NULL
	ENDIF
ENDIF

_sqlTabla = "ABM_CRM_Proximas_acciones"
_sqlCursor = "SQL_CRM_Proximas_acciones"
cConsultaid = 'SELECT id FROM ' + _sqlTabla ;
	+ ' WHERE TRIM(UPPER(nombre)) = "'+ ALLTRIM(UPPER(xoclientes.proxima_accion));
	+'" AND  id_ABM_empresas = ' + ALLTRIM(STR(xoclientes.oxid_ABM_empresas))

odb.QUERY(cConsultaid , _sqlCursor, _sqlTabla)
IF odb.CursorOpen(_sqlCursor)
	SELECT &_sqlCursor
	IF RECCOUNT() > 0
		_id_ABM_CRM_Proximas_acciones = ID
	ELSE
		_id_ABM_CRM_Proximas_acciones = 0 &&NULL
	ENDIF
ENDIF

_sqlTabla = "ABM_CRM_Bases_de_Datos"
_sqlCursor = "SQL_CRM_Bases_de_Datos"
cConsultaid = 'SELECT id FROM ' + _sqlTabla ;
	+ ' WHERE TRIM(UPPER(nombre)) = "'+ ALLTRIM(UPPER(xoclientes.base_de_datos));
	+'" AND  id_ABM_empresas = ' + ALLTRIM(STR(xoclientes.oxid_ABM_empresas))

odb.QUERY(cConsultaid , _sqlCursor, _sqlTabla)
IF odb.CursorOpen(_sqlCursor)
	SELECT &_sqlCursor
	IF RECCOUNT() > 0
		_id_ABM_CRM_Bases_de_Datos = ID
	ELSE
		_id_ABM_CRM_Bases_de_Datos = 0 &&NULL
	ENDIF
ENDIF

_sqlTabla = "ABM_CRM_Valoraciones"
_sqlCursor = "SQL_CRM_Valoraciones"
cConsultaid = 'SELECT id FROM ' + _sqlTabla ;
	+ ' WHERE TRIM(UPPER(nombre)) = "'+ ALLTRIM(UPPER(xoclientes.valoracion));
	+'" AND  id_ABM_empresas = ' + ALLTRIM(STR(xoclientes.oxid_ABM_empresas))


odb.QUERY(cConsultaid , _sqlCursor, _sqlTabla)
IF odb.CursorOpen(_sqlCursor)
	SELECT &_sqlCursor
	IF RECCOUNT() > 0
		_id_ABM_CRM_Valoraciones = ID
	ELSE
		_id_ABM_CRM_Valoraciones = 0 &&NULL
	ENDIF
ENDIF

_sqlTabla = "ABM_CRM_Argumentaciones"
_sqlCursor = "SQL_CRM_Argumentaciones"
cConsultaid = 'SELECT id FROM ' + _sqlTabla ;
	+ ' WHERE TRIM(UPPER(nombre)) = "'+ ALLTRIM(UPPER(xoclientes.argumentacion));
	+'" AND  id_ABM_empresas = ' + ALLTRIM(STR(xoclientes.oxid_ABM_empresas))


odb.QUERY(cConsultaid , _sqlCursor, _sqlTabla)
IF odb.CursorOpen(_sqlCursor)
	SELECT &_sqlCursor
	IF RECCOUNT() > 0
		_id_ABM_CRM_Argumentaciones = ID
	ELSE
		_id_ABM_CRM_Argumentaciones = 0 &&NULL
	ENDIF
ENDIF


RELEASE _otablaq
PUBLIC _otablaq
_otablaq = 'clientes'

RELEASE _otablaSQL
PUBLIC _otablaSQL
_otablaSQL = 'abm_clientes'

RELEASE _ocursorSQL
PUBLIC _ocursorSQL
_ocursorSQL = 'SQL_abm_clientes'

cCodigoAuto="SELECT LPAD(IFNULL(MAX(codigo) + 1, 1), 4, '0') AS proximo FROM " + _otablaSQL +;
	" WHERE id_ABM_empresas = " + ALLTRIM(STR(xoclientes.oxid_ABM_empresas))


odb.QUERY(cCodigoAuto ,_ocursorSQL ,_otablaSQL)
IF odb.CursorOpen(_ocursorSQL)
	SELECT &_ocursorSQL
	_CodAuto = proximo
ELSE
	_CodAuto = '0001'
ENDIF

cConsulta="Select * from " + _otablaSQL + " where id_ABM_empresas = " + ALLTRIM(STR(xoclientes.oxid_ABM_empresas));
	+ " and id < 0 "


odb.QUERY(cConsulta, _ocursorSQL,  _otablaSQL)

IF odb.CursorOpen(_ocursorSQL)
	IF odb.CursorEdit(_ocursorSQL)
	ELSE
		RETURN
	ENDIF
ELSE
	RETURN
ENDIF

INSERT INTO &_ocursorSQL (codigo;
	,nombre;
	,Nombre_de_Fantasia;
	,domicilio;
	,domicilio_de_entrega;
	,domicilio_de_facturacion;
	,codigo_postal;
	,id_ABM_Localidades;
	,id_ABM_Provincias;
	,id_ABM_Ciudades;
	,id_ABM_Municipios;
	,id_ABM_Regiones_1;
	,documento;
	,Fecha_de_nacimiento;
	,clave_impositiva;
	,telefono_1;
	,radio;
	,fax;
	,email;
	,contacto_1;
	,cargo_1;
	,email_1;
	,website;
	,logo_cliente;
	,id_ABM_Calificacion_de_Clientes;
	,id_ABM_Categoria_impositiva;
	,retencion_fuente;
	,retencion_iva;
	,retencion_ica;
	,id_ABM_Condiciones_de_venta;
	,id_ABM_Cuentas_Contables;
	,id_ABM_Politica_de_Precios_Servicios;
	,plan_de_fidelizacion_codigo;
	,puntos_plan_de_fidelizacion;
	,id_ABM_CRM_Resultados;
	,tarjeta_de_descuento;
	,tarjeta_de_descuento_cadena;
	,tarjeta_de_descuento_adquisicion;
	,ID_ABM_Zona;
	,ID_ABM_Vendedor;
	,reparto_lunes;
	,reparto_martes;
	,reparto_miercoles;
	,reparto_jueves;
	,reparto_viernes;
	,reparto_sabado;
	,reparto_domingo;
	,horario_de_reparto_lunes_a_viernes_por_la_manana_desde;
	,horario_de_reparto_lunes_a_viernes_por_la_manana_hasta;
	,horario_de_reparto_lunes_a_viernes_por_la_tarde_desde;
	,horario_de_reparto_lunes_a_viernes_por_la_tarde_hasta;
	,horario_de_reparto_sabados_por_la_manana_desde;
	,horario_de_reparto_sabados_por_la_manana_hasta;
	,horario_de_reparto_sabados_por_la_tarde_desde;
	,horario_de_reparto_sabados_por_la_tarde_hasta;
	,horario_de_reparto_domingos_y_feriados_por_la_manana_desde;
	,horario_de_reparto_domingos_y_feriados_por_la_manana_hasta;
	,horario_de_reparto_domingos_y_feriados_por_la_tarde_desde;
	,horario_de_reparto_domingos_y_feriados_por_la_tarde_hasta;
	,numero_de_proveedor_que_nos_asigno;
	,id_ABM_Rubro;
	,id_ABM_CRM_Situacion_contacto;
	,cantidad_de_locales;
	,id_ABM_CRM_Proximas_acciones;
	,CRM_Proximo_contacto;
	,id_ABM_CRM_Bases_de_Datos;
	,id_ABM_CRM_Valoraciones;
	,id_ABM_CRM_Argumentaciones;
	,observaciones;
	,VERSION;
	,datetime;
	,ultimo_cambio;
	,eliminado;
	,activo;
	,id_ABM_empresas;
	,id_ABM_regiones;
	,id_ABM_usuarios;
	,id_ABM_ultimo_usuario;
	,sincronizacion);
	VALUES (_CodAuto;
	, ALLTRIM(UPPER(xoclientes.nombre)) ;
	, ALLTRIM(UPPER(xoclientes.marca)) ;
	, ALLTRIM(UPPER(xoclientes.dirección)) ;
	, ALLTRIM(UPPER(xoclientes.lugar_entrega)) ;
	, ALLTRIM(UPPER(xoclientes.dirección)) ;
	, ALLTRIM(UPPER(xoclientes.cód_postal)) ;
	,_id_ABM_localidades;
	,_id_ABM_Provincias;
	,_id_ABM_Ciudades;
	,_id_ABM_Municipios;
	,_id_ABM_Regiones_1;
	, ALLTRIM(UPPER(xoclientes.cedula)) ;
	, xoclientes.nacim ;
	, ALLTRIM(UPPER(xoclientes.cuit)) ;
	, ALLTRIM(UPPER(xoclientes.teléfono)) ;
	, ALLTRIM(UPPER(xoclientes.num_radio)) ;
	, ALLTRIM(UPPER(xoclientes.fax)) ;
	, ALLTRIM(UPPER(xoclientes.MAIL)) ;
	, ALLTRIM(UPPER(xoclientes.contacto)) ;
	, ALLTRIM(UPPER(xoclientes.cargo_contacto)) ;
	, ALLTRIM(UPPER(xoclientes.mail_2)) ;
	, ALLTRIM(UPPER(xoclientes.website)) ;
	, ALLTRIM(UPPER(xoclientes.comentarios)) ;
	,_id_ABM_Calificacion_de_Clientes;
	,_id_ABM_Categoria_impositiva;
	, xoclientes.retefuente ;
	, xoclientes.reteiva ;
	, xoclientes.reteica ;
	,_id_ABM_Condiciones_de_venta;
	,_id_ABM_Cuentas_Contables;
	,_id_ABM_Politica_de_Precios_Servicios;
	,_plan_de_fidelizacion_codigo;
	, xoclientes.maxima;
	,_id_ABM_CRM_Resultados;
	, xoclientes.tarjeta_descuento ;
	, ALLTRIM(UPPER(xoclientes.tarjeta_descuento_cadena)) ;
	, xoclientes.tarjeta_descuento_adq ;
	,_ID_ABM_Zona;
	,_ID_ABM_Vendedor;
	, xoclientes._reparto_lunes ;
	, xoclientes._reparto_martes ;
	, xoclientes._reparto_miercoles ;
	, xoclientes._reparto_jueves ;
	, xoclientes._reparto_viernes ;
	, xoclientes._reparto_sabado ;
	, xoclientes._reparto_domingo ;
	, ALLTRIM(UPPER(xoclientes.horario_reparto_desde1)) ;
	, ALLTRIM(UPPER(xoclientes.horario_reparto_hasta1)) ;
	, ALLTRIM(UPPER(xoclientes.horario_reparto_desde2)) ;
	, ALLTRIM(UPPER(xoclientes.horario_reparto_hasta2)) ;
	, ALLTRIM(UPPER(xoclientes.horario_reparto_sabado_desde1)) ;
	, ALLTRIM(UPPER(xoclientes.horario_reparto_sabado_hasta1)) ;
	, ALLTRIM(UPPER(xoclientes.horario_reparto_sabado_desde2)) ;
	, ALLTRIM(UPPER(xoclientes.horario_reparto_sabado_hasta2)) ;
	, ALLTRIM(UPPER(xoclientes.horario_reparto_domingo_desde1)) ;
	, ALLTRIM(UPPER(xoclientes.horario_reparto_domingo_hasta1)) ;
	, ALLTRIM(UPPER(xoclientes.horario_reparto_domingo_desde2)) ;
	, ALLTRIM(UPPER(xoclientes.horario_reparto_domingo_hasta2)) ;
	, ALLTRIM(UPPER(xoclientes.num_prov)) ;
	,_id_ABM_Rubro;
	,_id_ABM_CRM_Situacion_contacto;
	, xoclientes.locales ;
	,_id_ABM_CRM_Proximas_acciones;
	, xoclientes.proximo_contacto ;
	,_id_ABM_CRM_Bases_de_Datos;
	,_id_ABM_CRM_Valoraciones;
	,_id_ABM_CRM_Argumentaciones;
	, ALLTRIM(UPPER(xoclientes.observac)) ;
	, xoclientes.idcliente ;
	,DATETIME();
	,DATETIME();
	,0;
	,0;
	, xoclientes.oxid_ABM_empresas ;
	, xoclientes.oxid_ABM_regiones ;
	, xoclientes.oxid_ABM_usuarios ;
	, xoclientes.oxid_ABM_usuarios ;
	, xoclientes.idcliente )

IF odb.CursorChanges(_ocursorSQL)
	IF odb.UPDATE(_ocursorSQL)
		IF odb.Commit()
				_saEstado = "Proceso con Exito"
		ELSE
			odb.ROLLBACK()
			RETURN
		ENDIF
	ELSE
		RETURN
	ENDIF
ELSE 
	_saEstado = "No Pudo Actualizar Cursor" 
ENDIF

RELEASE _ocursorSQL
RELEASE otablaq
TRY
	USE IN _otablaSQL
CATCH TO oex
ENDTRY
odb.Disconnect()

RELEASE xoclientes
*_SCREEN.winfx.ASYNC.RunAsync(lcScript)
