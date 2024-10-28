LPARAMETERS xorubro 

ADDPROPERTY(xorubro, "oxid_ABM_regiones", _sincroaregion)
ADDPROPERTY(xorubro, "oxid_ABM_usuarios", _sincroausuario)
ADDPROPERTY(xorubro, "oxid_ABM_empresas", _sincroaempresa)

ADDPROPERTY(xorubro, "_trigger_engine", _screen.engine)
ADDPROPERTY(xorubro, "_trigger_handle_driver", _screen.handle_driver)
ADDPROPERTY(xorubro, "_trigger_handle_server", _screen.handle_server)
ADDPROPERTY(xorubro, "_trigger_handle_user", _screen.handle_user)
ADDPROPERTY(xorubro, "_trigger_handle_password", _screen.handle_password)
ADDPROPERTY(xorubro, "_trigger_handle_database", _screen.handle_database)
ADDPROPERTY(xorubro, "_trigger_handle_port", _screen.handle_port)
ADDPROPERTY(xorubro, "_path","'"+ALLTRIM(JUSTPATH(FULLPATH("odb_connect_winfx.prg")))+"\'")

	SET PATH TO  xorubro._path  additive

	odb_connect_winfx( xorubro._trigger_engine ;
				, xorubro._trigger_handle_driver ;
				, xorubro._trigger_handle_server ;
				, xorubro._trigger_handle_user ;
				, xorubro._trigger_handle_password ;
				, xorubro._trigger_handle_database ;
				, xorubro._trigger_handle_port )
	
	SET TABLEPROMPT OFF
	SET CPDIALOG OFF
	SET DELETED OFF

	RELEASE _otablaq
	PUBLIC _otablaq
	_otablaq = 'rubro'

	RELEASE _otablaSQL
	PUBLIC _otablaSQL
	_otablaSQL = 'abm_rubros'

	RELEASE _ocursorSQL
	PUBLIC _ocursorSQL
	_ocursorSQL = 'SQL_abm_rubros'
		
	cConsulta="Select * from " + _otablaSQL + " where id_ABM_empresas = " + ALLTRIM(STR(xorubro.oxid_ABM_empresas)) +;
									 " and sincronizacion = " + ALLTRIM(STR(xorubro.ids)+;
									 " and eliminado = 0") 
	
	_saConsulta = cConsulta
	odb.Query(cConsulta, _ocursorSQL,  _otablaSQL)

	IF odb.CursorOpen(_ocursorSQL)
		IF odb.CursorEdit(_ocursorSQL)
		ELSE
			RETURN
		ENDIF
	ELSE
		RETURN
	ENDIF

SELECT &_ocursorSQL
IF RECCOUNT() > 0
	UPDATE &_ocursorSQL;
	SET nombre = xorubro.rubro ;
		,observaciones = '' ;
		,version = version + 1 ;
		,ultimo_cambio = DATETIME() ;
		,id_ABM_empresas =  xorubro.oxid_ABM_empresas ;
		,id_ABM_regiones =  xorubro.oxid_ABM_regiones ;
		,id_ABM_usuarios =  xorubro.oxid_ABM_usuarios ;
		,id_ABM_ultimo_usuario =  xorubro.oxid_ABM_usuarios ;
	WHERE sincronizacion =  xorubro.ids 

	IF odb.CursorChanges(_ocursorSQL)
		IF odb.Update(_ocursorSQL)
			IF odb.Commit()
				_saEstado = "Proceso con Exito"
			ELSE
				odb.Rollback()
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

release xorubro
*_SCREEN.winfx.ASYNC.RunAsync(lcScript)
