LPARAMETERS xorubro

ADDPROPERTY(xorubro, "oxid_ABM_regiones", _sincroaregion)
ADDPROPERTY(xorubro, "oxid_ABM_usuarios", _sincroausuario)
ADDPROPERTY(xorubro, "oxid_ABM_empresas", _sincroaempresa)

ADDPROPERTY(xorubro, "_trigger_engine", _SCREEN.engine)
ADDPROPERTY(xorubro, "_trigger_handle_driver", _SCREEN.handle_driver)
ADDPROPERTY(xorubro, "_trigger_handle_server", _SCREEN.handle_server)
ADDPROPERTY(xorubro, "_trigger_handle_user", _SCREEN.handle_user)
ADDPROPERTY(xorubro, "_trigger_handle_password", _SCREEN.handle_password)
ADDPROPERTY(xorubro, "_trigger_handle_database", _SCREEN.handle_database)
ADDPROPERTY(xorubro, "_trigger_handle_port", _SCREEN.handle_port)
ADDPROPERTY(xorubro, "_path","'"+ALLTRIM(JUSTPATH(FULLPATH("odb_connect_winfx.prg")))+"\'")

SET PATH TO xorubro._path  ADDITIVE

odb_connect_winfx(xorubro._trigger_engine;
	,xorubro._trigger_handle_driver;
	,xorubro._trigger_handle_server;
	,xorubro._trigger_handle_user;
	,xorubro._trigger_handle_password;
	,xorubro._trigger_handle_database;
	,xorubro._trigger_handle_port)

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

cCodigoAuto="SELECT LPAD(IFNULL(MAX(codigo) + 1, 1), 4, '0') AS proximo FROM " + _otablaSQL +;
	" WHERE id_ABM_empresas = " + ALLTRIM(STR(xorubro.oxid_ABM_empresas))

odb.QUERY(cCodigoAuto ,_ocursorSQL ,_otablaSQL)
IF odb.CursorOpen(_ocursorSQL)
	SELECT &_ocursorSQL
	_CodAuto = proximo
ELSE
	_CodAuto = '0001'
ENDIF

cConsulta="Select * from " + _otablaSQL + " where id_ABM_empresas = " + ALLTRIM(STR(xorubro.oxid_ABM_empresas)) + " and id < 0 "

odb.QUERY(cConsulta, _ocursorSQL,  _otablaSQL)

IF odb.CursorOpen(_ocursorSQL)
	IF odb.CursorEdit(_ocursorSQL)
	ELSE
		RETURN
	ENDIF
ELSE
	RETURN
ENDIF

INSERT INTO &_ocursorSQL (codigo;
	,nombre;
	,observaciones;
	,VERSION;
	,datetime;
	,ultimo_cambio;
	,eliminado;
	,id_ABM_empresas;
	,id_ABM_regiones;
	,id_ABM_usuarios;
	,id_ABM_ultimo_usuario;
	,sincronizacion);
	VALUES (_CodAuto;
	,xorubro.rubro;
	,'';
	,1;
	,DATETIME();
	,DATETIME();
	,0;
	,xorubro.oxid_ABM_empresas;
	,xorubro.oxid_ABM_regiones;
	,xorubro.oxid_ABM_usuarios;
	,xorubro.oxid_ABM_usuarios;
	,xorubro.ids)

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
ELSE 
	_saEstado = "No Pudo Actualizar Cursor" 
ENDIF

RELEASE _ocursorSQL
RELEASE otablaq
TRY
	USE IN _otablaSQL
CATCH TO oex
ENDTRY
odb.Disconnect()

RELEASE xorubro
*_SCREEN.winfx.ASYNC.RunAsync(lcScript)
