LPARAMETERS xoarticulo_univoco

CLEAR RESOURCES 
SYS(1104)

ADDPROPERTY(xoarticulo_univoco, "oxid_ABM_regiones", _sincroaregion)
ADDPROPERTY(xoarticulo_univoco, "oxid_ABM_usuarios", _sincroausuario)
ADDPROPERTY(xoarticulo_univoco, "oxid_ABM_empresas", _sincroaempresa)

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
	
	oDb.QUERY(cConsulta, _ocursorSQL,  _otablaSQL)
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
		,eliminado = 1;
		,ultimo_cambio = DATETIME();
		,id_ABM_ultimo_usuario =  xoarticulo_univoco.oxid_ABM_usuarios ;
	WHERE sincronizacion =  xoarticulo_univoco.ids 

	IF oDb.CursorChanges(_ocursorSQL)
		IF oDb.UPDATE(_ocursorSQL)
			IF oDb.Commit()
				_saEstado = "Proceso Con Exito"
			ELSE
				oDb.ROLLBACK()
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
