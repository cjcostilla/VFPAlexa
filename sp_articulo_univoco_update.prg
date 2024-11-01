LPARAMETERS  xoarticulo_univoco 

CLEAR RESOURCES 
SYS(1104)

ADDPROPERTY(xoarticulo_univoco, "oxid_ABM_regiones", _sincroaregion)
ADDPROPERTY(xoarticulo_univoco, "oxid_ABM_usuarios", _sincroausuario)
ADDPROPERTY(xoarticulo_univoco, "oxid_ABM_empresas", _sincroaempresa)
ADDPROPERTY(xoarticulo_univoco, "oxRutaDato", _sincroarutadato)

ADDPROPERTY(xoarticulo_univoco, "_trigger_engine", _screen.engine)
ADDPROPERTY(xoarticulo_univoco, "_trigger_handle_driver", _screen.handle_driver)
ADDPROPERTY(xoarticulo_univoco, "_trigger_handle_server", _screen.handle_server)
ADDPROPERTY(xoarticulo_univoco, "_trigger_handle_user", _screen.handle_user)
ADDPROPERTY(xoarticulo_univoco, "_trigger_handle_password", _screen.handle_password)
ADDPROPERTY(xoarticulo_univoco, "_trigger_handle_database", _screen.handle_database)
ADDPROPERTY(xoarticulo_univoco, "_trigger_handle_port", _screen.handle_port)
ADDPROPERTY(xoarticulo_univoco, "_path","'"+ALLTRIM(JUSTPATH(FULLPATH("odb_connect_winfx.prg")))+"\'")

	SET PATH TO  xoarticulo_univoco._path  additive
	
	odb_connect_winfx( xoarticulo_univoco._trigger_engine ;
				, xoarticulo_univoco._trigger_handle_driver ;
				, xoarticulo_univoco._trigger_handle_server ;
				, xoarticulo_univoco._trigger_handle_user ;
				, xoarticulo_univoco._trigger_handle_password ;
				, xoarticulo_univoco._trigger_handle_database ;
				, xoarticulo_univoco._trigger_handle_port )

	SET TABLEPROMPT OFF
	SET CPDIALOG OFF
	SET DELETED OFF
	CLEAR RESOURCES 
	SYS(1104)
	PUBLIC _xrutadato
	
	_xrutadato = xoarticulo_univoco.oxRutaDato
	otabla='depůsitos'
	IF !USED(ALLTRIM(otabla))
	    TRY
	        USE (_xrutadato + ALLTRIM(otabla)) SHARED IN 0
	    CATCH TO oex
	        * Manejo del error en caso de que la tabla no se pueda abrir
	    ENDTRY
	ENDIF

	SELECT &otabla
	IF SEEK(xoarticulo_univoco.numdep, otabla, "num")
		
		_idcliente = ALLTRIM(STR(idcliente))
		_articulo_propio = propio

		_sqlTabla = "ABM_Clientes"
		_sqlCursor = "SQL_Clientes"
		cConsultaid = "SELECT ID FROM " + _sqlTabla ;
							+ " WHERE SINCRONIZACION = '" + _idCliente + "'" ;
							+' AND  id_ABM_empresas = ' + ALLTRIM(STR(xoarticulo_univoco.oxid_ABM_empresas))
							
		odb.Query(cConsultaid , _sqlCursor, _sqlTabla)
		IF odb.CursorOpen(_sqlCursor)
			SELECT &_sqlCursor
			IF RECCOUNT() > 0
				_id_ABM_Clientes = id
			ELSE 
				_id_ABM_Clientes = 0 &&NULL
			ENDIF 
		ENDIF
	ELSE
		_id_ABM_Clientes = 0 &&NULL
		_articulo_propio = 0 &&NULL
	ENDIF
	
	_sqlTabla = "ABM_depositos"
	_sqlCursor = "SQL_depositos"

	cConsultaid = "SELECT ID FROM " + _sqlTabla ;
						+ " WHERE SINCRONIZACION = " + ALLTRIM(STR(xoarticulo_univoco.numdep)) ;
						+' AND  id_ABM_empresas = ' + ALLTRIM(STR(xoarticulo_univoco.oxid_ABM_empresas))
						
	odb.Query(cConsultaid , _sqlCursor, _sqlTabla)
	IF odb.CursorOpen(_sqlCursor)
		SELECT &_sqlCursor
		IF RECCOUNT() > 0
			_id_ABM_Depositos = id
		ELSE 
			_id_ABM_Depositos = 0 &&NULL
		ENDIF 
	ENDIF
	
	_sqlTabla = "ABM_depositos"
	_sqlCursor = "SQL_depositos"

	cConsultaid ="SELECT ID FROM " + _sqlTabla ;
						+ " WHERE SINCRONIZACION = " + ALLTRIM(STR(xoarticulo_univoco.numdep_actual)) ;
						+' AND  id_ABM_empresas = ' + ALLTRIM(STR(xoarticulo_univoco.oxid_ABM_empresas))

	odb.Query(cConsultaid , _sqlCursor, _sqlTabla)
	IF odb.CursorOpen(_sqlCursor)
		SELECT &_sqlCursor
		IF RECCOUNT() > 0
			_id_ABM_Depositos_ACTUAL = id
		ELSE 
			_id_ABM_Depositos_ACTUAL = 0 &&NULL
		ENDIF 
	ENDIF
	
	_sqlTabla = "ABM_Articulos"
	_sqlCursor = "SQL_Articulos"

	cConsultaid ="SELECT ID FROM " + _sqlTabla ;
						+ " WHERE SINCRONIZACION = " + ALLTRIM(STR(xoarticulo_univoco.numartic)) ;
						+' AND  id_ABM_empresas = ' + ALLTRIM(STR(xoarticulo_univoco.oxid_ABM_empresas))

	odb.Query(cConsultaid , _sqlCursor, _sqlTabla)
	IF odb.CursorOpen(_sqlCursor)
		SELECT &_sqlCursor
		IF RECCOUNT() > 0
			_id_ABM_Articulos = id
		ELSE 
			_id_ABM_Articulos = 0 &&NULL
		ENDIF 
	ENDIF
	
	_sqlTabla = "ABM_empleados_del_cliente"
	_sqlCursor = "SQL_empleados_del_cliente"

	cConsultaid ="SELECT ID FROM " + _sqlTabla ;
						+ " WHERE SINCRONIZACION = " + ALLTRIM(STR(xoarticulo_univoco.id_usuario)) ;
						+' AND  id_ABM_empresas = ' + ALLTRIM(STR(xoarticulo_univoco.oxid_ABM_empresas))

	odb.Query(cConsultaid , _sqlCursor, _sqlTabla)
	IF odb.CursorOpen(_sqlCursor)
		SELECT &_sqlCursor
		IF RECCOUNT() > 0
			_id_ABM_Empleados_del_cliente = id
		ELSE 
			_id_ABM_Empleados_del_cliente = 0 &&NULL
		ENDIF 
	ENDIF
	
	_sqlTabla = "ABM_Tipos_de_comprobante"
	_sqlCursor = "SQL_Tipos_de_comprobante"

	cConsultaid = "SELECT ID FROM " + _sqlTabla ;
						+ " WHERE ID = " + ALLTRIM(STR(xoarticulo_univoco.Tipo_comprobante_ultimo)) ;
						+' AND  id_ABM_empresas = ' + ALLTRIM(STR(xoarticulo_univoco.oxid_ABM_empresas))

	odb.Query(cConsultaid , _sqlCursor, _sqlTabla)
	IF odb.CursorOpen(_sqlCursor)
		SELECT &_sqlCursor
		IF RECCOUNT() > 0
			_id_Tipo_comprobante_ultimo = id
		ELSE 
			_id_Tipo_comprobante_ultimo = 0 &&NULL
		ENDIF 
	ENDIF
	
	RELEASE _otablaq
	PUBLIC _otablaq
	_otablaq = 'articulo_univoco1'

	RELEASE _otablaSQL
	PUBLIC _otablaSQL
	_otablaSQL = 'abm_articulo_univoco'

	RELEASE _ocursorSQL
	PUBLIC _ocursorSQL
	_ocursorSQL = 'SQL_abm_articulo_univoco'


	cConsulta="Select * from " + _otablaSQL + " where id_ABM_empresas = " + ALLTRIM(STR(xoarticulo_univoco.oxid_ABM_empresas)) +;
										 " and sincronizacion = " + ALLTRIM(STR(xoarticulo_univoco.ids)+;
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
	UPDATE &_ocursorSQL ;
	SET serial =  ALLTRIM(xoarticulo_univoco.serial) ;
		,rfid =  ALLTRIM(xoarticulo_univoco.rfid) ;
		,codbar =  ALLTRIM(xoarticulo_univoco.codbar) ;
		,id_ABM_Depositos = _id_ABM_Depositos;
		,id_ABM_Depositos_ACTUAL = _id_ABM_Depositos_ACTUAL;
		,id_ABM_Articulos = _id_ABM_Articulos;
		,identificados =  xoarticulo_univoco.identificados ;
		,id_ABM_Empleados_del_cliente = _id_ABM_Empleados_del_cliente;
		,id_ABM_Clientes = _id_ABM_Clientes ;
		,articulo_propio = _articulo_propio ;
		,id_ABM_Tipos_de_comprobante_ULTIMO = _id_Tipo_comprobante_ultimo ;
		,numero_comprobante_ultimo =  xoarticulo_univoco.numero_comprobante_ultimo ;
		,ultima_lectura =  xoarticulo_univoco.ultima_lectura ;
		,Sincronizar = 1;
		,observaciones = ALLTRIM(xoarticulo_univoco.observaciones);
		,version = version + 1;
		,ultimo_cambio = DATETIME();
		,id_ABM_empresas =  xoarticulo_univoco.oxid_ABM_empresas ;
		,id_ABM_regiones =  xoarticulo_univoco.oxid_ABM_regiones ;
		,id_ABM_usuarios =  xoarticulo_univoco.oxid_ABM_usuarios ;
		,id_ABM_ultimo_usuario =  xoarticulo_univoco.oxid_ABM_usuarios ;
	WHERE sincronizacion =  xoarticulo_univoco.ids 

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

	
RELEASE xoarticulo_univoco 
*_SCREEN.winfx.ASYNC.RunAsync(lcScript)
