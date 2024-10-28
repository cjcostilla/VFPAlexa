LPARAMETERS xodepositos

ADDPROPERTY(xodepositos, "oxid_ABM_regiones", _sincroaregion)
ADDPROPERTY(xodepositos, "oxid_ABM_usuarios", _sincroausuario)
ADDPROPERTY(xodepositos, "oxid_ABM_empresas", _sincroaempresa)

ADDPROPERTY(xodepositos, "_predet1", IIF(xodepositos.predet1 = .T., 1, 0))
ADDPROPERTY(xodepositos, "_ultimo_usado", IIF(xodepositos.ultimo_usado = .T., 1, 0))

ADDPROPERTY(xodepositos, "_trigger_engine", _SCREEN.engine)
ADDPROPERTY(xodepositos, "_trigger_handle_driver", _SCREEN.handle_driver)
ADDPROPERTY(xodepositos, "_trigger_handle_server", _SCREEN.handle_server)
ADDPROPERTY(xodepositos, "_trigger_handle_user", _SCREEN.handle_user)
ADDPROPERTY(xodepositos, "_trigger_handle_password", _SCREEN.handle_password)
ADDPROPERTY(xodepositos, "_trigger_handle_database", _SCREEN.handle_database)
ADDPROPERTY(xodepositos, "_trigger_handle_port", _SCREEN.handle_port)
ADDPROPERTY(xodepositos, "_path","'"+ALLTRIM(JUSTPATH(FULLPATH("odb_connect_winfx.prg")))+"\'")

SET PATH TO  xodepositos._path  ADDITIVE

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


_id_ABM_tipos_de_deposito= 0 &&NULL
_id_ABM_Tipos_de_Propietario = xodepositos.propio

_sqlTabla = "ABM_clientes"
_sqlCursor = "SQL_clientes"

cConsultaid = "SELECT ID FROM " + _sqlTabla ;
	+ " WHERE SINCRONIZACION = " + ALLTRIM(STR(xodepositos.idcliente)) ;
	+' AND  id_ABM_empresas = ' + ALLTRIM(STR(xodepositos.oxid_ABM_empresas))

odb.QUERY(cConsultaid , _sqlCursor, _sqlTabla)
IF odb.CursorOpen(_sqlCursor)
	SELECT &_sqlCursor
	IF RECCOUNT() > 0
		_id_ABM_clientes= ID
	ELSE
		_id_ABM_clientes= 0 &&NULL
	ENDIF
ENDIF

_sqlTabla = "ABM_empleados_del_cliente"
_sqlCursor = "SQL_empleados_del_cliente"

cConsultaid = "SELECT ID FROM " + _sqlTabla ;
	+ " WHERE SINCRONIZACION = " + ALLTRIM(STR(xodepositos.idgeneral)) ;
	+' AND  id_ABM_empresas = ' + ALLTRIM(STR(xodepositos.oxid_ABM_empresas))

odb.QUERY(cConsultaid , _sqlCursor, _sqlTabla)
IF odb.CursorOpen(_sqlCursor)
	SELECT &_sqlCursor
	IF RECCOUNT() > 0
		_id_ABM_empleados_del_cliente= ID
	ELSE
		_id_ABM_empleados_del_cliente= 0 &&NULL
	ENDIF
ENDIF

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
	" and sincronizacion = " + ALLTRIM(STR(xodepositos.num))+;
	" and eliminado = 0"


_saConsulta = cConsulta

odb.QUERY(cConsulta, _ocursorSQL,  _otablaSQL)
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
		SET nombre = ALLTRIM(UPPER(xodepositos.nombre));
		,observaciones = '';
		,descripcion = '';
		,domicilio =  ALLTRIM(UPPER(xodepositos.direccion));
		,id_ABM_tipos_de_deposito = _id_ABM_tipos_de_deposito ;
		,predeterminado =  xodepositos._predet1 ;
		,id_ABM_Tipos_de_Propietario = _id_ABM_Tipos_de_Propietario ;
		,id_ABM_clientes = _id_ABM_clientes ;
		,ultimo_usado =  xodepositos._ultimo_usado ;
		,clasificacion =  xodepositos.clasificacion ;
		,VERSION =  xodepositos.num ;
		,ultimo_cambio = DATETIME() ;
		,id_ABM_empresas =  xodepositos.oxid_ABM_empresas ;
		,id_ABM_regiones =  xodepositos.oxid_ABM_regiones ;
		,id_ABM_usuarios =  xodepositos.oxid_ABM_usuarios ;
		,id_ABM_ultimo_usuario =  xodepositos.oxid_ABM_usuarios ;
		,id_ABM_empleados_del_cliente = _id_ABM_empleados_del_cliente ;
		WHERE sincronizacion =  xodepositos.num

	IF odb.CursorChanges(_ocursorSQL)
		IF odb.UPDATE(_ocursorSQL)
			IF odb.Commit()
				_saEstado = "Proceso con Exito"
			ELSE
				odb.ROLLBACK()
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
odb.Disconnect()

RELEASE xodepositos
*_SCREEN.winfx.ASYNC.RunAsync(lcScript)
