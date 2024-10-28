LPARAMETERS xocolores

ADDPROPERTY(xocolores, "oxid_ABM_regiones", _sincroaregion)
ADDPROPERTY(xocolores, "oxid_ABM_usuarios", _sincroausuario)
ADDPROPERTY(xocolores, "oxid_ABM_empresas", _sincroaempresa)

ADDPROPERTY(xocolores, "_trigger_engine", _screen.engine)
ADDPROPERTY(xocolores, "_trigger_handle_driver", _screen.handle_driver)
ADDPROPERTY(xocolores, "_trigger_handle_server", _screen.handle_server)
ADDPROPERTY(xocolores, "_trigger_handle_user", _screen.handle_user)
ADDPROPERTY(xocolores, "_trigger_handle_password", _screen.handle_password)
ADDPROPERTY(xocolores, "_trigger_handle_database", _screen.handle_database)
ADDPROPERTY(xocolores, "_trigger_handle_port", _screen.handle_port)
ADDPROPERTY(xocolores, "_path","'"+ALLTRIM(JUSTPATH(FULLPATH("odb_connect_winfx.prg")))+"\'")

	SET PATH TO  xocolores._path  additive 

	odb_connect_winfx( xocolores._trigger_engine ;
				, xocolores._trigger_handle_driver ;
				, xocolores._trigger_handle_server ;
				, xocolores._trigger_handle_user ;
				, xocolores._trigger_handle_password ;
				, xocolores._trigger_handle_database ;
				, xocolores._trigger_handle_port )

	SET TABLEPROMPT OFF
	SET CPDIALOG OFF
	SET DELETED OFF

	RELEASE _otablaq
	PUBLIC _otablaq
	_otablaq = 'colores'

	RELEASE _otablaSQL
	PUBLIC _otablaSQL
	_otablaSQL = 'abm_colores'

	RELEASE _ocursorSQL
	PUBLIC _ocursorSQL
	_ocursorSQL = 'SQL_abm_colores'


	cConsulta="Select * from " + _otablaSQL + " where id_ABM_empresas = " + ALLTRIM(STR(xocolores.oxid_ABM_empresas)) +;
										 " and sincronizacion = " + ALLTRIM(STR(xocolores.idsql)+;
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
	SET version = version + 1;
		,id_ABM_ultimo_usuario = xocolores.oxid_ABM_usuarios;
		,eliminado = 1;
		,ultimo_cambio = DATETIME();
	WHERE sincronizacion = xocolores.idsql

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

RELEASE xocolores
*_SCREEN.winfx.ASYNC.RunAsync(lcScript)
