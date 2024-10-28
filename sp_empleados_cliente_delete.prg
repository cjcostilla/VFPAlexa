LPARAMETERS xoempleados_cliente

ADDPROPERTY(xoempleados_cliente, "oxid_ABM_regiones", _sincroaregion)
ADDPROPERTY(xoempleados_cliente, "oxid_ABM_usuarios", _sincroausuario)
ADDPROPERTY(xoempleados_cliente, "oxid_ABM_empresas", _sincroaempresa)

ADDPROPERTY(xoempleados_cliente, "_trigger_engine", _screen.engine)
ADDPROPERTY(xoempleados_cliente, "_trigger_handle_driver", _screen.handle_driver)
ADDPROPERTY(xoempleados_cliente, "_trigger_handle_server", _screen.handle_server)
ADDPROPERTY(xoempleados_cliente, "_trigger_handle_user", _screen.handle_user)
ADDPROPERTY(xoempleados_cliente, "_trigger_handle_password", _screen.handle_password)
ADDPROPERTY(xoempleados_cliente, "_trigger_handle_database", _screen.handle_database)
ADDPROPERTY(xoempleados_cliente, "_trigger_handle_port", _screen.handle_port)
ADDPROPERTY(xoempleados_cliente, "_path","'"+ALLTRIM(JUSTPATH(FULLPATH("odb_connect_winfx.prg")))+"\'")


	SET PATH TO  xoempleados_cliente._path  additive 

	odb_connect_winfx( xoempleados_cliente._trigger_engine ;
				, xoempleados_cliente._trigger_handle_driver ;
				, xoempleados_cliente._trigger_handle_server ;
				, xoempleados_cliente._trigger_handle_user ;
				, xoempleados_cliente._trigger_handle_password ;
				, xoempleados_cliente._trigger_handle_database ;
				, xoempleados_cliente._trigger_handle_port )

	  SET TABLEPROMPT OFF
	  SET CPDIALOG OFF
	  SET DELETED OFF

	RELEASE _otablaq
	PUBLIC _otablaq
	_otablaq = 'empleados_cliente'

	RELEASE _otablaSQL
	PUBLIC _otablaSQL
	_otablaSQL = 'abm_empleados_del_cliente'

	RELEASE _ocursorSQL
	PUBLIC _ocursorSQL
	_ocursorSQL = 'SQL_abm_empleados_del_cliente'
	

	cConsulta="Select * from " + _otablaSQL + " where id_ABM_empresas = " + ALLTRIM(STR(xoempleados_cliente.oxid_ABM_empresas)) +;
										 " and sincronizacion = " + ALLTRIM(STR(xoempleados_cliente.id)+;
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
		,version = version + 1;
		,ultimo_cambio = DATETIME();
		,id_ABM_ultimo_usuario =  xoempleados_cliente.oxid_ABM_usuarios ;
	WHERE sincronizacion =  xoempleados_cliente.id 
	
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

RELEASE xoempleados_cliente
*_SCREEN.winfx.ASYNC.RunAsync(lcScript)
