LPARAMETERS xostock1

ADDPROPERTY(xostock1, "oxid_ABM_regiones", _sincroaregion)
ADDPROPERTY(xostock1, "oxid_ABM_usuarios", _sincroausuario)
ADDPROPERTY(xostock1, "oxid_ABM_empresas", _sincroaempresa)

ADDPROPERTY(xostock1, "_trigger_engine", _screen.engine)
ADDPROPERTY(xostock1, "_trigger_handle_driver", _screen.handle_driver)
ADDPROPERTY(xostock1, "_trigger_handle_server", _screen.handle_server)
ADDPROPERTY(xostock1, "_trigger_handle_user", _screen.handle_user)
ADDPROPERTY(xostock1, "_trigger_handle_password", _screen.handle_password)
ADDPROPERTY(xostock1, "_trigger_handle_database", _screen.handle_database)
ADDPROPERTY(xostock1, "_trigger_handle_port", _screen.handle_port)
ADDPROPERTY(xostock1, "_path","'"+ALLTRIM(JUSTPATH(FULLPATH("odb_connect_winfx.prg")))+"\'")

	SET PATH TO  xostock1._path  additive 

	odb_connect_winfx( xostock1._trigger_engine ;
				, xostock1._trigger_handle_driver ;
				, xostock1._trigger_handle_server ;
				, xostock1._trigger_handle_user ;
				, xostock1._trigger_handle_password ;
				, xostock1._trigger_handle_database ;
				, xostock1._trigger_handle_port )

	SET TABLEPROMPT OFF
	SET CPDIALOG OFF
	SET DELETED OFF

	RELEASE _otablaq
	PUBLIC _otablaq
	_otablaq = 'stock1'

	RELEASE _otablaSQL
	PUBLIC _otablaSQL
	_otablaSQL = 'abm_articulos'

	RELEASE _ocursorSQL
	PUBLIC _ocursorSQL
	_ocursorSQL = 'SQL_abm_articulos'
	
	cConsulta="Select * from " + _otablaSQL + " where id_ABM_empresas = " + ALLTRIM(STR(xostock1.oxid_ABM_empresas)) +;
										 " and sincronizacion = " + ALLTRIM(STR(xostock1.num)+;
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
	SET eliminado = 1;
		,version =  xostock1.num ;
		,ultimo_cambio = DATETIME();
		,id_ABM_ultimo_usuario =  xostock1.oxid_ABM_usuarios ;
	WHERE sincronizacion =  xostock1.num ;
	
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

RELEASE xostock1
*_SCREEN.winfx.ASYNC.RunAsync(lcScript)

