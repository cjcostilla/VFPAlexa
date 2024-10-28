LPARAMETERS xoclientes 

ADDPROPERTY(xoclientes, "oxid_ABM_regiones", _sincroaregion)
ADDPROPERTY(xoclientes, "oxid_ABM_usuarios", _sincroausuario)
ADDPROPERTY(xoclientes, "oxid_ABM_empresas", _sincroaempresa)

ADDPROPERTY(xoclientes, "_reparto_lunes", IIF(xoclientes.lunes = .t., 1, 0))
ADDPROPERTY(xoclientes, "_reparto_martes", IIF(xoclientes.martes = .t., 1, 0))
ADDPROPERTY(xoclientes, "_reparto_miercoles", IIF(xoclientes.miercoles = .t., 1, 0))
ADDPROPERTY(xoclientes, "_reparto_jueves", IIF(xoclientes.jueves = .t., 1, 0))
ADDPROPERTY(xoclientes, "_reparto_viernes", IIF(xoclientes.viernes = .t., 1, 0))
ADDPROPERTY(xoclientes, "_reparto_sabado", IIF(xoclientes.sabado = .t., 1, 0))
ADDPROPERTY(xoclientes, "_reparto_domingo", IIF(xoclientes.domingo = .t., 1, 0))

ADDPROPERTY(xoclientes, "_trigger_engine", _screen.engine)
ADDPROPERTY(xoclientes, "_trigger_handle_driver", _screen.handle_driver)
ADDPROPERTY(xoclientes, "_trigger_handle_server", _screen.handle_server)
ADDPROPERTY(xoclientes, "_trigger_handle_user", _screen.handle_user)
ADDPROPERTY(xoclientes, "_trigger_handle_password", _screen.handle_password)
ADDPROPERTY(xoclientes, "_trigger_handle_database", _screen.handle_database)
ADDPROPERTY(xoclientes, "_trigger_handle_port", _screen.handle_port)
ADDPROPERTY(xoclientes, "_path","'"+ALLTRIM(JUSTPATH(FULLPATH("odb_connect_winfx.prg")))+"\'")

	SET PATH TO  xoclientes._path  additive

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

	try
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
							
	odb.Query(cConsultaid , _sqlCursor, _sqlTabla)
	IF odb.CursorOpen(_sqlCursor)
		SELECT &_sqlCursor
		IF RECCOUNT() > 0
			_id_ABM_localidades = id
		ELSE 
			_id_ABM_localidades = 0 &&NULL
		ENDIF
	ENDIF
	
	_sqlTabla = "ABM_provincias"
	_sqlCursor = "SQL_provincias"
	cConsultaid = 'SELECT id FROM ' + _sqlTabla ;
							+ ' WHERE TRIM(UPPER(nombre)) = "'+ ALLTRIM(UPPER(xoclientes.provincia));
							+'" AND  id_ABM_empresas = ' + ALLTRIM(STR(xoclientes.oxid_ABM_empresas))
							
	odb.Query(cConsultaid , _sqlCursor, _sqlTabla)
	IF odb.CursorOpen(_sqlCursor)
		SELECT &_sqlCursor
		IF RECCOUNT() > 0
			_id_ABM_Provincias = id
		ELSE 
			_id_ABM_Provincias = 0 &&NULL
		ENDIF 
	ENDIF
	
	_sqlTabla = "ABM_Ciudades"
	_sqlCursor = "SQL_Ciudades"
	cConsultaid = 'SELECT id FROM ' + _sqlTabla ;
							+ ' WHERE TRIM(UPPER(nombre)) = "'+ ALLTRIM(UPPER(xoclientes.ciudad));
							+'" AND  id_ABM_empresas = ' + ALLTRIM(STR(xoclientes.oxid_ABM_empresas))
							
	odb.Query(cConsultaid , _sqlCursor, _sqlTabla)

	IF odb.CursorOpen(_sqlCursor)
		SELECT &_sqlCursor
		IF RECCOUNT() > 0
			_id_ABM_Ciudades = id
		ELSE 
			_id_ABM_Ciudades = 0 &&NULL
		ENDIF 
	ENDIF
	
	_sqlTabla = "ABM_Municipios"
	_sqlCursor = "SQL_Municipios"
	cConsultaid = 'SELECT id FROM ' + _sqlTabla ;
							+ ' WHERE TRIM(UPPER(nombre)) = "'+ ALLTRIM(UPPER(xoclientes.municipio));
							+'" AND  id_ABM_empresas = ' + ALLTRIM(STR(xoclientes.oxid_ABM_empresas))
							
	odb.Query(cConsultaid , _sqlCursor, _sqlTabla)

	IF odb.CursorOpen(_sqlCursor)
		SELECT &_sqlCursor
		IF RECCOUNT() > 0
			_id_ABM_Municipios = id
		ELSE 
			_id_ABM_Municipios = 0 &&NULL
		ENDIF 
	ENDIF
	
	_sqlTabla = "ABM_Regiones"
	_sqlCursor = "SQL_Regiones"
	cConsultaid = 'SELECT id FROM ' + _sqlTabla ;
							+ ' WHERE TRIM(UPPER(nombre)) = "'+ ALLTRIM(UPPER(xoclientes.pais)) + '"'


	odb.Query(cConsultaid , _sqlCursor, _sqlTabla)

	IF odb.CursorOpen(_sqlCursor)
		SELECT &_sqlCursor
		IF RECCOUNT() > 0
			_id_ABM_Regiones_1 = id
		ELSE 
			_id_ABM_Regiones_1 = 0 &&NULL
		ENDIF 
	ENDIF
	
	_sqlTabla = "ABM_Calificacion_de_Clientes"
	_sqlCursor = "SQL_Calificacion_de_Clientes"
	cConsultaid = 'SELECT id FROM ' + _sqlTabla ;
							+ ' WHERE TRIM(UPPER(nombre)) = "'+ ALLTRIM(UPPER(xoclientes.orden));
							+'" AND  id_ABM_empresas = ' + ALLTRIM(STR(xoclientes.oxid_ABM_empresas))
	 
	odb.Query(cConsultaid , _sqlCursor, _sqlTabla)

	IF odb.CursorOpen(_sqlCursor)
		SELECT &_sqlCursor
		IF RECCOUNT() > 0
			_id_ABM_Calificacion_de_Clientes = id
		ELSE 
			_id_ABM_Calificacion_de_Clientes = 0 &&NULL
		ENDIF 
	ENDIF
	
	_sqlTabla = "ABM_Categorias_impositivas"
	_sqlCursor = "SQL_Categorias_impositivas"
	cConsultaid = 'SELECT id FROM ' + _sqlTabla ;
							+ ' WHERE TRIM(UPPER(nombre)) = "'+ ALLTRIM(UPPER(xoclientes.clas));
							+'" AND  id_ABM_empresas = ' + ALLTRIM(STR(xoclientes.oxid_ABM_empresas))
	 
	odb.Query(cConsultaid , _sqlCursor, _sqlTabla)

	IF odb.CursorOpen(_sqlCursor)
		SELECT &_sqlCursor
		IF RECCOUNT() > 0
			_id_ABM_Categoria_impositiva = id
		ELSE 
			_id_ABM_Categoria_impositiva = 0 &&NULL
		ENDIF 
	ENDIF
	
	_sqlTabla = "ABM_Condiciones_de_venta"
	_sqlCursor = "SQL_Condiciones_de_venta"
	cConsultaid = 'SELECT id FROM ' + _sqlTabla ;
							+ ' WHERE TRIM(UPPER(nombre)) = "'+ ALLTRIM(UPPER(xoclientes.condvta));
							+'" AND  id_ABM_empresas = ' + ALLTRIM(STR(xoclientes.oxid_ABM_empresas))
	 

	odb.Query(cConsultaid , _sqlCursor, _sqlTabla)

	IF odb.CursorOpen(_sqlCursor)
		SELECT &_sqlCursor
		IF RECCOUNT() > 0
			_id_ABM_Condiciones_de_venta = id
		ELSE 
			_id_ABM_Condiciones_de_venta = 0 &&NULL
		ENDIF 
	ENDIF
	
	_sqlTabla = "ABM_Condiciones_de_venta"
	_sqlCursor = "SQL_Condiciones_de_venta"
	cConsultaid = 'SELECT id FROM ' + _sqlTabla ;
							+ ' WHERE TRIM(UPPER(nombre)) = "'+ ALLTRIM(UPPER(xoclientes.condvta));
							+'" AND  id_ABM_empresas = ' + ALLTRIM(STR(xoclientes.oxid_ABM_empresas))
	 
	odb.Query(cConsultaid , _sqlCursor, _sqlTabla)

	IF odb.CursorOpen(_sqlCursor)
		SELECT &_sqlCursor
		IF RECCOUNT() > 0
			_id_ABM_Condiciones_de_venta = id
		ELSE 
			_id_ABM_Condiciones_de_venta = 0 &&NULL
		ENDIF 
	ENDIF
	
	_sqlTabla = "ABM_Cuentas_Contables"
	_sqlCursor = "SQL_Cuentas_Contables"
	cConsultaid = 'SELECT id FROM ' + _sqlTabla ;
							+ ' WHERE TRIM(UPPER(nombre)) = "'+ ALLTRIM(UPPER(xoclientes.cuenta));
							+'" AND  id_ABM_empresas = ' + ALLTRIM(STR(xoclientes.oxid_ABM_empresas))
	 
	odb.Query(cConsultaid , _sqlCursor, _sqlTabla)

	IF odb.CursorOpen(_sqlCursor)
		SELECT &_sqlCursor
		IF RECCOUNT() > 0
			_id_ABM_Cuentas_Contables = id
		ELSE 
			_id_ABM_Cuentas_Contables = 0 &&NULL
		ENDIF 
	ENDIF
	
	_sqlTabla = "ABM_POLITICAS_DE_PRECIOS_DE_SERVICIOS_CABECERA"
	_sqlCursor = "SQL_politicas_de_precios_de_servicios_cabecera"
	cConsultaid = 'SELECT id FROM ' + _sqlTabla ;
							+ ' WHERE TRIM(UPPER(nombre)) = "'+ ALLTRIM(UPPER(xoclientes.polprserv));
							+'" AND  id_ABM_empresas = ' + ALLTRIM(STR(xoclientes.oxid_ABM_empresas))
	 
	odb.Query(cConsultaid , _sqlCursor, _sqlTabla)

	IF odb.CursorOpen(_sqlCursor)
		SELECT &_sqlCursor
		IF RECCOUNT() > 0
			_id_ABM_Politica_de_Precios_Servicios = id
		ELSE 
			_id_ABM_Politica_de_Precios_Servicios = 0 &&NULL
		ENDIF 
	ENDIF
	
	_sqlTabla = "ABM_Zonas"
	_sqlCursor = "SQL_Zonas"
	cConsultaid = 'SELECT id FROM ' + _sqlTabla ;
							+ ' WHERE TRIM(UPPER(nombre)) = "'+ ALLTRIM(UPPER(xoclientes.zona));
							+'" AND  id_ABM_empresas = ' + ALLTRIM(STR(xoclientes.oxid_ABM_empresas))
	 
	odb.Query(cConsultaid , _sqlCursor, _sqlTabla)

	IF odb.CursorOpen(_sqlCursor)
		SELECT &_sqlCursor
		IF RECCOUNT() > 0
			_ID_ABM_Zona = id
		ELSE 
			_ID_ABM_Zona = 0 &&NULL
		ENDIF 
	ENDIF
	
	_sqlTabla = "ABM_Vendedores"
	_sqlCursor = "SQL_Vendedores"
	cConsultaid = 'SELECT id FROM ' + _sqlTabla ;
							+ ' WHERE TRIM(UPPER(nombre)) = "'+ ALLTRIM(UPPER(xoclientes.vendedor));
							+'" AND  id_ABM_empresas = ' + ALLTRIM(STR(xoclientes.oxid_ABM_empresas))
	 
	odb.Query(cConsultaid , _sqlCursor, _sqlTabla)

	IF odb.CursorOpen(_sqlCursor)
		SELECT &_sqlCursor
		IF RECCOUNT() > 0
			_ID_ABM_Vendedor = id
		ELSE 
			_ID_ABM_Vendedor = 0 &&NULL
		ENDIF 
	ENDIF
	
	_sqlTabla = "ABM_CRM_Resultados"
	_sqlCursor = "SQL_CRM_Resultados"
	cConsultaid = 'SELECT id FROM ' + _sqlTabla ;
							+ ' WHERE TRIM(UPPER(nombre)) = "'+ ALLTRIM(UPPER(xoclientes.resultado));
							+'" AND  id_ABM_empresas = ' + ALLTRIM(STR(xoclientes.oxid_ABM_empresas))
	 
	odb.Query(cConsultaid , _sqlCursor, _sqlTabla)

	IF odb.CursorOpen(_sqlCursor)
		SELECT &_sqlCursor
		IF RECCOUNT() > 0
			_id_ABM_CRM_Resultados = id
		ELSE 
			_id_ABM_CRM_Resultados = 0 &&NULL
		ENDIF 
	ENDIF
	
	_sqlTabla = "ABM_Rubros"
	_sqlCursor = "SQL_Rubros"
	cConsultaid = 'SELECT id FROM ' + _sqlTabla ;
							+ ' WHERE TRIM(UPPER(nombre)) = "'+ ALLTRIM(UPPER(xoclientes.rubro));
							+'" AND  id_ABM_empresas = ' + ALLTRIM(STR(xoclientes.oxid_ABM_empresas))
	 
	odb.Query(cConsultaid , _sqlCursor, _sqlTabla)

	IF odb.CursorOpen(_sqlCursor)
		SELECT &_sqlCursor
		IF RECCOUNT() > 0
			_id_ABM_Rubro = id
		ELSE 
			_id_ABM_Rubro = 0 &&NULL
		ENDIF 
	ENDIF
	
	_sqlTabla = "ABM_CRM_Situacion_contacto"
	_sqlCursor = "SQL_CRM_Situacion_contacto"
	cConsultaid = 'SELECT id FROM ' + _sqlTabla ;
							+ ' WHERE TRIM(UPPER(nombre)) = "'+ ALLTRIM(UPPER(xoclientes.situacion));
							+'" AND  id_ABM_empresas = ' + ALLTRIM(STR(xoclientes.oxid_ABM_empresas))
	 
	odb.Query(cConsultaid , _sqlCursor, _sqlTabla)

	IF odb.CursorOpen(_sqlCursor)
		SELECT &_sqlCursor
		IF RECCOUNT() > 0
			_id_ABM_CRM_Situacion_contacto = id
		ELSE 
			_id_ABM_CRM_Situacion_contacto = 0 &&NULL
		ENDIF 
	ENDIF
	
	_sqlTabla = "ABM_CRM_Proximas_acciones"
	_sqlCursor = "SQL_CRM_Proximas_acciones"
	cConsultaid = 'SELECT id FROM ' + _sqlTabla ;
							+ ' WHERE TRIM(UPPER(nombre)) = "'+ ALLTRIM(UPPER(xoclientes.proxima_accion));
							+'" AND  id_ABM_empresas = ' + ALLTRIM(STR(xoclientes.oxid_ABM_empresas))
	 
	odb.Query(cConsultaid , _sqlCursor, _sqlTabla)

	IF odb.CursorOpen(_sqlCursor)
		SELECT &_sqlCursor
		IF RECCOUNT() > 0
			_id_ABM_CRM_Proximas_acciones = id
		ELSE 
			_id_ABM_CRM_Proximas_acciones = 0 &&NULL
		ENDIF 
	ENDIF
	
	_sqlTabla = "ABM_CRM_Bases_de_Datos"
	_sqlCursor = "SQL_CRM_Bases_de_Datos"
	cConsultaid = 'SELECT id FROM ' + _sqlTabla ;
							+ ' WHERE TRIM(UPPER(nombre)) = "'+ ALLTRIM(UPPER(xoclientes.base_de_datos));
							+'" AND  id_ABM_empresas = ' + ALLTRIM(STR(xoclientes.oxid_ABM_empresas))
	 
	odb.Query(cConsultaid , _sqlCursor, _sqlTabla)

	IF odb.CursorOpen(_sqlCursor)
		SELECT &_sqlCursor
		IF RECCOUNT() > 0
			_id_ABM_CRM_Bases_de_Datos = id
		ELSE 
			_id_ABM_CRM_Bases_de_Datos = 0 &&NULL
		ENDIF 
	ENDIF
	
	_sqlTabla = "ABM_CRM_Valoraciones"
	_sqlCursor = "SQL_CRM_Valoraciones"
	cConsultaid = 'SELECT id FROM ' + _sqlTabla ;
							+ ' WHERE TRIM(UPPER(nombre)) = "'+ ALLTRIM(UPPER(xoclientes.valoracion));
							+'" AND  id_ABM_empresas = ' + ALLTRIM(STR(xoclientes.oxid_ABM_empresas))

	odb.Query(cConsultaid , _sqlCursor, _sqlTabla)

	IF odb.CursorOpen(_sqlCursor)
		SELECT &_sqlCursor
		IF RECCOUNT() > 0
			_id_ABM_CRM_Valoraciones = id
		ELSE 
			_id_ABM_CRM_Valoraciones = 0 &&NULL
		ENDIF 
	ENDIF
	
	_sqlTabla = "ABM_CRM_Argumentaciones"
	_sqlCursor = "SQL_CRM_Argumentaciones"
	cConsultaid = 'SELECT id FROM ' + _sqlTabla ;
							+ ' WHERE TRIM(UPPER(nombre)) = "'+ ALLTRIM(UPPER(xoclientes.argumentacion));
							+'" AND  id_ABM_empresas = ' + ALLTRIM(STR(xoclientes.oxid_ABM_empresas))

	 
	odb.Query(cConsultaid , _sqlCursor, _sqlTabla)

	IF odb.CursorOpen(_sqlCursor)
		SELECT &_sqlCursor
		IF RECCOUNT() > 0
			_id_ABM_CRM_Argumentaciones = id
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
	
	cConsulta="Select * from " + _otablaSQL + " where id_ABM_empresas = " + ALLTRIM(STR(xoclientes.oxid_ABM_empresas)) +;
									 " and sincronizacion = " + ALLTRIM(STR(xoclientes.idcliente)+;
									 " and eliminado = 0")

	_saConsulta = cConsulta
 	oDb.Query(cConsulta, _ocursorSQL,  _otablaSQL)

	IF oDb.CursorOpen(_ocursorSQL)
		IF oDb.CursorEdit(_ocursorSQL)
		ELSE
			RETURN
		ENDIF
	ELSE
		RETURN
	ENDIF

SELECT &_ocursorSQL
IF RECCOUNT() > 0
	UPDATE &_ocursorSQL;
	SET	nombre =  ALLTRIM(UPPER(xoclientes.nombre)) ;
		,Nombre_de_Fantasia =  ALLTRIM(UPPER(xoclientes.marca)) ;
		,domicilio =  ALLTRIM(UPPER(xoclientes.dirección)) ;
		,domicilio_de_entrega =  ALLTRIM(UPPER(xoclientes.lugar_entrega)) ;
		,domicilio_de_facturacion =  ALLTRIM(UPPER(xoclientes.dirección)) ;
		,codigo_postal =  ALLTRIM(UPPER(xoclientes.cód_postal)) ;
		,id_ABM_Localidades = _id_ABM_localidades;
		,id_ABM_Provincias = _id_ABM_Provincias;
		,id_ABM_Ciudades = _id_ABM_Ciudades;
		,id_ABM_Municipios = _id_ABM_Municipios;
		,id_ABM_Regiones_1 = _id_ABM_Regiones_1;
		,documento =  ALLTRIM(UPPER(xoclientes.cedula)) ;
		,Fecha_de_nacimiento =  xoclientes.nacim ;
		,clave_impositiva =  ALLTRIM(UPPER(xoclientes.cuit)) ;
		,telefono_1 =  ALLTRIM(UPPER(xoclientes.teléfono)) ;
		,radio =  ALLTRIM(UPPER(xoclientes.num_radio)) ;
		,fax =  ALLTRIM(UPPER(xoclientes.fax)) ;
		,email =  ALLTRIM(UPPER(xoclientes.mail)) ;
		,contacto_1 =  ALLTRIM(UPPER(xoclientes.contacto)) ;
		,cargo_1 =  ALLTRIM(UPPER(xoclientes.cargo_contacto)) ;
		,email_1 =  ALLTRIM(UPPER(xoclientes.mail_2)) ;
		,website =  ALLTRIM(UPPER(xoclientes.website)) ;
		,logo_cliente =  ALLTRIM(UPPER(xoclientes.comentarios)) ;
		,id_ABM_Calificacion_de_Clientes = _id_ABM_Calificacion_de_Clientes;
		,id_ABM_Categoria_impositiva = _id_ABM_Categoria_impositiva;
		,retencion_fuente =  xoclientes.retefuente ;
		,retencion_iva =  xoclientes.reteiva ;
		,retencion_ica =  xoclientes.reteica ;
		,id_ABM_Condiciones_de_venta = _id_ABM_Condiciones_de_venta;
		,id_ABM_Cuentas_Contables = _id_ABM_Cuentas_Contables;
		,id_ABM_Politica_de_Precios_Servicios = _id_ABM_Politica_de_Precios_Servicios;
		,plan_de_fidelizacion_codigo = _plan_de_fidelizacion_codigo;
		,puntos_plan_de_fidelizacion =  xoclientes.maxima ;
		,id_ABM_CRM_Resultados = _id_ABM_CRM_Resultados;
		,tarjeta_de_descuento =  xoclientes.tarjeta_descuento ;
		,tarjeta_de_descuento_cadena =  ALLTRIM(UPPER(xoclientes.tarjeta_descuento_cadena)) ;
		,tarjeta_de_descuento_adquisicion =  xoclientes.tarjeta_descuento_adq ;
		,ID_ABM_Zona = _ID_ABM_Zona;
		,ID_ABM_Vendedor = _ID_ABM_Vendedor;
		,reparto_lunes =  xoclientes._reparto_lunes ;
		,reparto_martes =  xoclientes._reparto_martes ;
		,reparto_miercoles =  xoclientes._reparto_miercoles ;
		,reparto_jueves =  xoclientes._reparto_jueves ;
		,reparto_viernes =  xoclientes._reparto_viernes ;
		,reparto_sabado =  xoclientes._reparto_sabado ;
		,reparto_domingo =  xoclientes._reparto_domingo ;
		,horario_de_reparto_lunes_a_viernes_por_la_manana_desde =  ALLTRIM(UPPER(xoclientes.horario_reparto_desde1)) ;
		,horario_de_reparto_lunes_a_viernes_por_la_manana_hasta =  ALLTRIM(UPPER(xoclientes.horario_reparto_hasta1)) ;
		,horario_de_reparto_lunes_a_viernes_por_la_tarde_desde =  ALLTRIM(UPPER(xoclientes.horario_reparto_desde2)) ;
		,horario_de_reparto_lunes_a_viernes_por_la_tarde_hasta =  ALLTRIM(UPPER(xoclientes.horario_reparto_hasta2)) ;
		,horario_de_reparto_sabados_por_la_manana_desde =  ALLTRIM(UPPER(xoclientes.horario_reparto_sabado_desde1)) ;
		,horario_de_reparto_sabados_por_la_manana_hasta =  ALLTRIM(UPPER(xoclientes.horario_reparto_sabado_hasta1)) ;
		,horario_de_reparto_sabados_por_la_tarde_desde =  ALLTRIM(UPPER(xoclientes.horario_reparto_sabado_desde2)) ;
		,horario_de_reparto_sabados_por_la_tarde_hasta =  ALLTRIM(UPPER(xoclientes.horario_reparto_sabado_hasta2)) ;
		,horario_de_reparto_domingos_y_feriados_por_la_manana_desde =  ALLTRIM(UPPER(xoclientes.horario_reparto_domingo_desde1)) ;
		,horario_de_reparto_domingos_y_feriados_por_la_manana_hasta =  ALLTRIM(UPPER(xoclientes.horario_reparto_domingo_hasta1)) ;
		,horario_de_reparto_domingos_y_feriados_por_la_tarde_desde =  ALLTRIM(UPPER(xoclientes.horario_reparto_domingo_desde2)) ;
		,horario_de_reparto_domingos_y_feriados_por_la_tarde_hasta =  ALLTRIM(UPPER(xoclientes.horario_reparto_domingo_hasta2)) ;
		,numero_de_proveedor_que_nos_asigno =  ALLTRIM(UPPER(xoclientes.num_prov)) ;
		,id_ABM_Rubro = _id_ABM_Rubro ;
		,id_ABM_CRM_Situacion_contacto = _id_ABM_CRM_Situacion_contacto ;
		,cantidad_de_locales =  xoclientes.locales ;
		,id_ABM_CRM_Proximas_acciones = _id_ABM_CRM_Proximas_acciones ;
		,CRM_Proximo_contacto =  xoclientes.proximo_contacto ;
		,id_ABM_CRM_Bases_de_Datos = _id_ABM_CRM_Bases_de_Datos ;
		,id_ABM_CRM_Valoraciones = _id_ABM_CRM_Valoraciones ;
		,id_ABM_CRM_Argumentaciones = _id_ABM_CRM_Argumentaciones;
		,observaciones =  ALLTRIM(UPPER(xoclientes.observac)) ;
		,version =  xoclientes.idcliente  ;
		,ultimo_cambio = DATETIME();
		,id_ABM_empresas =  xoclientes.oxid_ABM_empresas ;
		,id_ABM_regiones =  xoclientes.oxid_ABM_regiones ;
		,id_ABM_usuarios =  xoclientes.oxid_ABM_usuarios ;
		,id_ABM_ultimo_usuario =  xoclientes.oxid_ABM_usuarios ;
	WHERE sincronizacion =  xoclientes.idcliente 

	IF oDb.CursorChanges(_ocursorSQL)
		IF oDb.Update(_ocursorSQL)
			IF oDb.Commit()
				_saEstado = "Proceso con Exito"
			ELSE
				oDb.Rollback()
				RETURN
			ENDIF
		ELSE
			RETURN
		ENDIF
	ENDIF
ELSE 
	_saEstado = "NO Encontro Registro - " + cConsulta
ENDIF 

	RELEASE _ocursorSQL
	RELEASE otablaq
	TRY
		USE IN _otablaSQL
	CATCH TO oex
	ENDTRY
	oDb.Disconnect()

RELEASE xoclientes
*_SCREEN.winfx.ASYNC.RunAsync(lcScript)

