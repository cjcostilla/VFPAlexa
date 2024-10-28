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
	

	cCodigoAuto="SELECT LPAD(IFNULL(MAX(codigo) + 1, 1), 4, '0') AS proximo FROM " + _otablaSQL +;
						" WHERE id_ABM_empresas = " + ALLTRIM(STR(xounidmedida.oxid_ABM_empresas))
	
	odb.QUERY(cCodigoAuto ,_ocursorSQL ,_otablaSQL )
	
	IF odb.CursorOpen(_ocursorSQL)
		SELECT &_ocursorSQL
		_CodAuto = proximo
	ELSE
		_CodAuto = '0001'
	ENDIF

	cConsulta="Select * from " + _otablaSQL + " where id_ABM_empresas = ";
					 + ALLTRIM(STR(xounidmedida.oxid_ABM_empresas)) + " and id < 0 "
	
	oDb.Query(cConsulta, _ocursorSQL,  _otablaSQL)
	
	IF oDb.CursorOpen(_ocursorSQL)
		IF oDb.CursorEdit(_ocursorSQL)
		ELSE
			RETURN
		ENDIF
	ELSE
		RETURN
	ENDIF

	INSERT INTO &_ocursorSQL (codigo;
		,nombre;
		,observaciones;
		,version;
		,sincronizacion;
		,datetime;
		,ultimo_cambio;
		,eliminado;
		,activo;
		,id_ABM_empresas;
		,id_ABM_regiones;
		,id_ABM_usuarios;
		,id_ABM_ultimo_usuario);
	VALUES (_CodAuto;
		, xounidmedida.unidmedida ;
		,'';
		,1;
		, xounidmedida.ids ;
		,DATETIME();
		,DATETIME();
		,0;
		,0;
		, xounidmedida.oxid_ABM_empresas ;
		, xounidmedida.oxid_ABM_regiones ;
		, xounidmedida.oxid_ABM_usuarios ;
		, xounidmedida.oxid_ABM_usuarios )
	
	IF oDb.CursorChanges(_ocursorSQL)
		IF oDb.Update(_ocursorSQL)
			IF oDb.Commit()
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

	RELEASE _otablaSQL
	PUBLIC _otablaSQL
	_otablaSQL = 'abm_talles'

	RELEASE _ocursorSQL
	PUBLIC _ocursorSQL
	_ocursorSQL = 'SQL_abm_talles'
	
	cCodigoAuto="SELECT LPAD(IFNULL(MAX(codigo) + 1, 1), 4, '0') AS proximo FROM " + _otablaSQL +;
			" WHERE id_ABM_empresas = " + ALLTRIM(STR(xounidmedida.oxid_ABM_empresas))
	
	odb.QUERY(cCodigoAuto ,_ocursorSQL ,_otablaSQL )
	
	IF odb.CursorOpen(_ocursorSQL )
		SELECT &_ocursorSQL
		_CodAuto = proximo
	ELSE
		_CodAuto = '0001'
	ENDIF

	cConsulta="Select * from " + _otablaSQL + " where id_ABM_empresas = ";
					 + ALLTRIM(STR(xounidmedida.oxid_ABM_empresas)) + " and id < 0 "
	
	oDb.Query(cConsulta, _ocursorSQL,  _otablaSQL)

	IF oDb.CursorOpen(_ocursorSQL)
		IF oDb.CursorEdit(_ocursorSQL)
		ELSE
			RETURN
		ENDIF
	ELSE
		RETURN
	ENDIF
	
	INSERT INTO &_ocursorSQL (codigo;
		,nombre;
		,observaciones;
		,version;
		,sincronizacion;
		,id_ABM_empresas;
		,id_ABM_regiones;
		,id_ABM_usuarios;
		,id_ABM_ultimo_usuario);
	VALUES (_CodAuto;
		, xounidmedida.unidmedida ;
		,'';
		,1;
		, xounidmedida.ids ;
		, xounidmedida.oxid_ABM_empresas ;
		, xounidmedida.oxid_ABM_regiones ;
		, xounidmedida.oxid_ABM_usuarios ;
		, xounidmedida.oxid_ABM_usuarios )
	
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

RELEASE xounidmedida
*_SCREEN.winfx.ASYNC.RunAsync(lcScript)
