LPARAMETERS xounidmedida

ADDPROPERTY(xounidmedida, "oxid_ABM_regiones", _sincroaregion)
ADDPROPERTY(xounidmedida, "oxid_ABM_usuarios", _sincroausuario)
ADDPROPERTY(xounidmedida, "oxid_ABM_empresas", _sincroaempresa)

ADDPROPERTY(xounidmedida, "_trigger_engine", _screen.engine)
ADDPROPERTY(xounidmedida, "_trigger_handle_driver", _screen.handle_driver)
ADDPROPERTY(xounidmedida, "_trigger_handle_server", _screen.handle_server)
ADDPROPERTY(xounidmedida, "_trigger_handle_user", _screen.handle_user)
ADDPROPERTY(xounidmedida, "_trigger_handle_password", _screen.handle_password)
ADDPROPERTY(xounidmedida, "_trigger_handle_database", _screen.handle_database)
ADDPROPERTY(xounidmedida, "_trigger_handle_port", _screen.handle_port)
ADDPROPERTY(xounidmedida, "_path","'"+ALLTRIM(JUSTPATH(FULLPATH("odb_connect_winfx.prg")))+"\'")

	SET PATH TO  xounidmedida._path  additive

	odb_connect_winfx( xounidmedida._trigger_engine ;
				, xounidmedida._trigger_handle_driver ;
				, xounidmedida._trigger_handle_server ;
				, xounidmedida._trigger_handle_user ;
				, xounidmedida._trigger_handle_password ;
				, xounidmedida._trigger_handle_database ;
				, xounidmedida._trigger_handle_port )

	SET TABLEPROMPT OFF
	SET CPDIALOG OFF
	SET DELETED OFF

	RELEASE _otablaq
	PUBLIC _otablaq
	_otablaq = 'unidmedida'

	RELEASE _otablaSQL
	PUBLIC _otablaSQL
	_otablaSQL = 'abm_unidades_de_medida'

	RELEASE _ocursorSQL
	PUBLIC _ocursorSQL
	_ocursorSQL = 'SQL_abm_unidades_de_medida'


	cConsulta="Select * from " + _otablaSQL + " where id_ABM_empresas = " + ALLTRIM(STR(xounidmedida.oxid_ABM_empresas)) +;
								 " and sincronizacion = " + ALLTRIM(STR(xounidmedida.ids))

	
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
		,id_ABM_ultimo_usuario =  xounidmedida.oxid_ABM_usuarios ;
		,eliminado = 1;
		,ultimo_cambio = DATETIME();
	WHERE sincronizacion =  xounidmedida.ids 
	
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

	RELEASE _otablaSQL
	PUBLIC _otablaSQL
	_otablaSQL = 'abm_talles'

	RELEASE _ocursorSQL
	PUBLIC _ocursorSQL
	_ocursorSQL = 'SQL_abm_talles'


	cConsulta="Select * from " + _otablaSQL + " where id_ABM_empresas = " + ALLTRIM(STR(xounidmedida.oxid_ABM_empresas)) +;
								 " and sincronizacion = " + ALLTRIM(STR(xounidmedida.ids)+;
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
		,id_ABM_ultimo_usuario =  xounidmedida.oxid_ABM_usuarios ;
		,eliminado =  1;
		,ultimo_cambio = DATETIME();
	WHERE sincronizacion =  xounidmedida.ids 
	
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

RELEASE xounidmedida
*_SCREEN.winfx.ASYNC.RunAsync(lcScript)
