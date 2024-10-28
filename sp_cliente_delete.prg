LPARAMETERS xoclientes

ADDPROPERTY(xoclientes, "oxid_ABM_regiones", _sincroaregion)
ADDPROPERTY(xoclientes, "oxid_ABM_usuarios", _sincroausuario)
ADDPROPERTY(xoclientes, "oxid_ABM_empresas", _sincroaempresa)

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
	SET version =  xoclientes.idcliente ;
		,id_ABM_ultimo_usuario =  xoclientes.oxid_ABM_usuarios ;
		,eliminado = 1;
		,ultimo_cambio = DATETIME();
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
