LPARAMETERS xosubrubro 

ADDPROPERTY(xosubrubro, "oxid_ABM_regiones", _sincroaregion)
ADDPROPERTY(xosubrubro, "oxid_ABM_usuarios", _sincroausuario)
ADDPROPERTY(xosubrubro, "oxid_ABM_empresas", _sincroaempresa)

ADDPROPERTY(xosubrubro, "_trigger_engine", _screen.engine)
ADDPROPERTY(xosubrubro, "_trigger_handle_driver", _screen.handle_driver)
ADDPROPERTY(xosubrubro, "_trigger_handle_server", _screen.handle_server)
ADDPROPERTY(xosubrubro, "_trigger_handle_user", _screen.handle_user)
ADDPROPERTY(xosubrubro, "_trigger_handle_password", _screen.handle_password)
ADDPROPERTY(xosubrubro, "_trigger_handle_database", _screen.handle_database)
ADDPROPERTY(xosubrubro, "_trigger_handle_port", _screen.handle_port)
ADDPROPERTY(xosubrubro, "_path","'"+ALLTRIM(JUSTPATH(FULLPATH("odb_connect_winfx.prg")))+"\'")


	SET PATH TO  xosubrubro._path  additive
	
	odb_connect_winfx( xosubrubro._trigger_engine ;
				, xosubrubro._trigger_handle_driver ;
				, xosubrubro._trigger_handle_server ;
				, xosubrubro._trigger_handle_user ;
				, xosubrubro._trigger_handle_password ;
				, xosubrubro._trigger_handle_database ;
				, xosubrubro._trigger_handle_port )

	SET TABLEPROMPT OFF
	SET CPDIALOG OFF
	SET DELETED OFF

	RELEASE _otablaq
	PUBLIC _otablaq
	_otablaq = 'subrubro'

	RELEASE _otablaSQL
	PUBLIC _otablaSQL
	_otablaSQL = 'abm_subrubros'

	RELEASE _ocursorSQL
	PUBLIC _ocursorSQL
	_ocursorSQL = 'SQL_abm_subrubros'

	cCodigoAuto="SELECT LPAD(IFNULL(MAX(codigo) + 1, 1), 4, '0') AS proximo FROM " + _otablaSQL +;
						" WHERE id_ABM_empresas = " + ALLTRIM(STR(xosubrubro.oxid_ABM_empresas))
	
	odb.QUERY(cCodigoAuto ,_ocursorSQL ,_otablaSQL )
	IF odb.CursorOpen(_ocursorSQL )
		SELECT &_ocursorSQL
		_CodAuto = proximo
	ELSE
		_CodAuto = '0001'
	ENDIF
		
	cConsulta="Select * from " + _otablaSQL + " where id_ABM_empresas = " ;
				+ ALLTRIM(STR(xosubrubro.oxid_ABM_empresas)) + " and id < 0 "
	
	
	oDb.Query(cConsulta, _ocursorSQL,  _otablaSQL)
	
	IF oDb.CursorOpen(_ocursorSQL)
		IF oDb.CursorEdit(_ocursorSQL)
		ELSE
			RETURN
		ENDIF
	ELSE
		RETURN
	ENDIF


	INSERT INTO &_ocursorSQL(codigo;
		,nombre;
		,observaciones;
		,version;
		,datetime;
		,ultimo_cambio;
		,eliminado;
		,id_ABM_empresas;
		,id_ABM_regiones;
		,id_ABM_usuarios;
		,id_ABM_ultimo_usuario;
		,sincronizacion);
	VALUES (_CodAuto;
		,xosubrubro.subrubro;
		,'';
		,1;
		,DATETIME();
		,DATETIME();
		,0;
		, xosubrubro.oxid_ABM_empresas ;
		, xosubrubro.oxid_ABM_regiones ;
		, xosubrubro.oxid_ABM_usuarios ;
		, xosubrubro.oxid_ABM_usuarios ;
		, xosubrubro.ids )

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
	ELSE 
		_saEstado = "No Pudo Actualizar Cursor" 
	ENDIF

	RELEASE _ocursorSQL
	RELEASE otablaq
	TRY
		USE IN _otablaSQL
	CATCH TO oex
	ENDTRY
	oDb.Disconnect()

RELEASE xosubrubro 
*_SCREEN.winfx.ASYNC.RunAsync(lcScript)

