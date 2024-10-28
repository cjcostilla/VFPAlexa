LPARAMETERS xodepositos

ADDPROPERTY(xodepositos, "oxid_ABM_regiones", _sincroaregion)
ADDPROPERTY(xodepositos, "oxid_ABM_usuarios", _sincroausuario)
ADDPROPERTY(xodepositos, "oxid_ABM_empresas", _sincroaempresa)

ADDPROPERTY(xodepositos, "_trigger_engine", _screen.engine)
ADDPROPERTY(xodepositos, "_trigger_handle_driver", _screen.handle_driver)
ADDPROPERTY(xodepositos, "_trigger_handle_server", _screen.handle_server)
ADDPROPERTY(xodepositos, "_trigger_handle_user", _screen.handle_user)
ADDPROPERTY(xodepositos, "_trigger_handle_password", _screen.handle_password)
ADDPROPERTY(xodepositos, "_trigger_handle_database", _screen.handle_database)
ADDPROPERTY(xodepositos, "_trigger_handle_port", _screen.handle_port)
ADDPROPERTY(xodepositos, "_path","'"+ALLTRIM(JUSTPATH(FULLPATH("odb_connect_winfx.prg")))+"\'")

	SET PATH TO  xodepositos._path  additive 

	odb_connect_winfx( xodepositos._trigger_engine ;
				, xodepositos._trigger_handle_driver ;
				, xodepositos._trigger_handle_server ;
				, xodepositos._trigger_handle_user ;
				, xodepositos._trigger_handle_password ;
				, xodepositos._trigger_handle_database ;
				, xodepositos._trigger_handle_port )

	SET TABLEPROMPT OFF
	SET CPDIALOG OFF
	SET DELETED OFF

	RELEASE _otablaq
	PUBLIC _otablaq
	_otablaq = 'depósitos'

	RELEASE _otablaSQL
	PUBLIC _otablaSQL
	_otablaSQL = 'abm_depositos'

	RELEASE _ocursorSQL
	PUBLIC _ocursorSQL
	_ocursorSQL = 'SQL_abm_depositos'
	
	cConsulta="Select * from " + _otablaSQL + " where id_ABM_empresas = " + ALLTRIM(STR(xodepositos.oxid_ABM_empresas)) +;
										 " and sincronizacion = " + ALLTRIM(STR(xodepositos.num)+;
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
	SET id_ABM_ultimo_usuario =  xodepositos.oxid_ABM_usuarios ;
		,eliminado = 1;
		,ultimo_cambio = DATETIME();
	WHERE sincronizacion =  xodepositos.num
	
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

RELEASE xodepositos

*_SCREEN.winfx.ASYNC.RunAsync(lcScript)
