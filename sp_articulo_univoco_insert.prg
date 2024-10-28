LPARAMETERS xoarticulo_univoco
CLEAR RESOURCES
SYS(1104)

ADDPROPERTY(xoarticulo_univoco, "oxid_ABM_regiones", _sincroaregion)
ADDPROPERTY(xoarticulo_univoco, "oxid_ABM_usuarios", _sincroausuario)
ADDPROPERTY(xoarticulo_univoco, "oxid_ABM_empresas", _sincroaempresa)
ADDPROPERTY(xoarticulo_univoco, "oxRutaDato", _sincroarutadato)

ADDPROPERTY(xoarticulo_univoco, "_trigger_engine", _SCREEN.engine)
ADDPROPERTY(xoarticulo_univoco, "_trigger_handle_driver", _SCREEN.handle_driver)
ADDPROPERTY(xoarticulo_univoco, "_trigger_handle_server", _SCREEN.handle_server)
ADDPROPERTY(xoarticulo_univoco, "_trigger_handle_user", _SCREEN.handle_user)
ADDPROPERTY(xoarticulo_univoco, "_trigger_handle_password", _SCREEN.handle_password)
ADDPROPERTY(xoarticulo_univoco, "_trigger_handle_database", _SCREEN.handle_database)
ADDPROPERTY(xoarticulo_univoco, "_trigger_handle_port", _SCREEN.handle_port)
ADDPROPERTY(xoarticulo_univoco, "_path","'"+ALLTRIM(JUSTPATH(FULLPATH("odb_connect_winfx.prg")))+"\'")

SET PATH TO  xoarticulo_univoco._path  ADDITIVE

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

PUBLIC _xrutadato

_xrutadato = ALLTRIM(xoarticulo_univoco.oxRutaDato)

otabla='depósitos'

IF !USED(ALLTRIM(otabla))
    TRY
        USE (_xrutadato + ALLTRIM(otabla)) SHARED IN 0
    CATCH TO oex
        * Manejo del error en caso de que la tabla no se pueda abrir
    ENDTRY
ENDIF


SELECT &otabla
IF SEEK(xoarticulo_univoco.numdep, otabla, "num")

	_idcliente = ALLTRIM(STR(idcliente))
	_articulo_propio = propio

	_sqlTabla = "ABM_Clientes"
	_sqlCursor = "SQL_Clientes"
	cConsultaid = "SELECT ID FROM " + _sqlTabla ;
		+ " WHERE SINCRONIZACION = '" + _idcliente + "'" ;
		+' AND  id_ABM_empresas = ' + ALLTRIM(STR(_sincroaempresa))

	odb.QUERY(cConsultaid , _sqlCursor, _sqlTabla)
	IF odb.CursorOpen(_sqlCursor)
		SELECT &_sqlCursor
		IF RECCOUNT() > 0
			_id_ABM_Clientes = ID
		ELSE
			_id_ABM_Clientes = 0 &&NULL
		ENDIF
	ENDIF
	RELEASE _sqlTabla
	USE IN &_sqlCursor

ELSE
	_id_ABM_Clientes = 0 &&NULL
	_articulo_propio = 0 &&NULL
ENDIF


_sqlTabla = "ABM_depositos"
_sqlCursor = "SQL_depositos"

cConsultaid = "SELECT ID FROM " + _sqlTabla ;
	+ " WHERE SINCRONIZACION = " + ALLTRIM(STR(xoarticulo_univoco.numdep)) ;
	+' AND  id_ABM_empresas = ' + ALLTRIM(STR(_sincroaempresa))

odb.QUERY(cConsultaid , _sqlCursor, _sqlTabla)
IF odb.CursorOpen(_sqlCursor)
	SELECT &_sqlCursor
	IF RECCOUNT() > 0
		_id_ABM_Depositos = ID
	ELSE
		_id_ABM_Depositos = 0 &&NULL
	ENDIF
ENDIF
RELEASE _sqlTabla
USE IN &_sqlCursor


_sqlTabla = "ABM_depositos"
_sqlCursor = "SQL_depositos"

cConsultaid ="SELECT ID FROM " + _sqlTabla ;
	+ " WHERE SINCRONIZACION = " + ALLTRIM(STR(xoarticulo_univoco.numdep_actual)) ;
	+' AND  id_ABM_empresas = ' + ALLTRIM(STR(_sincroaempresa))
odb.QUERY(cConsultaid , _sqlCursor, _sqlTabla)
IF odb.CursorOpen(_sqlCursor)
	SELECT &_sqlCursor
	IF RECCOUNT() > 0
		_id_ABM_Depositos_ACTUAL = ID
	ELSE
		_id_ABM_Depositos_ACTUAL = 0 &&NULL
	ENDIF
ENDIF
RELEASE _sqlTabla
USE IN &_sqlCursor


_sqlTabla = "ABM_Articulos"
_sqlCursor = "SQL_Articulos"

cConsultaid ="SELECT ID FROM " + _sqlTabla ;
	+ " WHERE SINCRONIZACION = " + ALLTRIM(STR(xoarticulo_univoco.numartic)) ;
	+' AND  id_ABM_empresas = ' + ALLTRIM(STR(_sincroaempresa))
odb.QUERY(cConsultaid , _sqlCursor, _sqlTabla)
IF odb.CursorOpen(_sqlCursor)
	SELECT &_sqlCursor
	IF RECCOUNT() > 0
		_id_ABM_Articulos = ID
	ELSE
		_id_ABM_Articulos = 0 &&NULL
	ENDIF
ENDIF
RELEASE _sqlTabla
USE IN &_sqlCursor

_sqlTabla = "ABM_empleados_del_cliente"
_sqlCursor = "SQL_empleados_del_cliente"

cConsultaid ="SELECT ID FROM " + _sqlTabla ;
	+ " WHERE SINCRONIZACION = " + ALLTRIM(STR(xoarticulo_univoco.id_usuario)) ;
	+' AND  id_ABM_empresas = ' + ALLTRIM(STR(_sincroaempresa))
odb.QUERY(cConsultaid , _sqlCursor, _sqlTabla)
IF odb.CursorOpen(_sqlCursor)
	SELECT &_sqlCursor
	IF RECCOUNT() > 0
		_id_ABM_Empleados_del_cliente = ID
	ELSE
		_id_ABM_Empleados_del_cliente = 0 &&NULL
	ENDIF
ENDIF
RELEASE _sqlTabla
USE IN &_sqlCursor

_sqlTabla = "ABM_Tipos_de_comprobante"
_sqlCursor = "SQL_Tipos_de_comprobante"

cConsultaid = "SELECT ID FROM " + _sqlTabla ;
	+ " WHERE ID = " + ALLTRIM(STR(xoarticulo_univoco.Tipo_comprobante_ultimo)) ;
	+' AND  id_ABM_empresas = ' + ALLTRIM(STR(_sincroaempresa))
odb.QUERY(cConsultaid , _sqlCursor, _sqlTabla)
IF odb.CursorOpen(_sqlCursor)
	SELECT &_sqlCursor
	IF RECCOUNT() > 0
		_id_Tipo_comprobante_ultimo = ID
	ELSE
		_id_Tipo_comprobante_ultimo = 0 &&NULL
	ENDIF
ENDIF
RELEASE _sqlTabla
USE IN &_sqlCursor


RELEASE _otablaq
PUBLIC _otablaq
_otablaq = 'articulo_univoco1'

RELEASE _otablaSQL
PUBLIC _otablaSQL
_otablaSQL = 'abm_articulo_univoco'

RELEASE _ocursorSQL
PUBLIC _ocursorSQL
_ocursorSQL = 'SQL_abm_articulo_univoco'

cConsulta="Select * from " + _otablaSQL + " where id_ABM_empresas = " ;
	+ ALLTRIM(STR(_sincroaempresa)) + " and id < 0 "

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

INSERT INTO &_ocursorSQL (serial;
	,rfid;
	,codbar;
	,id_ABM_Depositos;
	,id_ABM_Depositos_ACTUAL;
	,id_ABM_Articulos;
	,identificados;
	,id_ABM_Empleados_del_cliente;
	,id_ABM_Clientes;
	,articulo_propio;
	,id_ABM_Tipos_de_comprobante_ULTIMO;
	,numero_comprobante_ultimo;
	,Sincronizar;
	,observaciones;
	,sincronizacion;
	,VERSION;
	,ultima_lectura;
	,datetime;
	,ultimo_cambio;
	,eliminado;
	,activo;
	,id_ABM_empresas;
	,id_ABM_regiones;
	,id_ABM_usuarios;
	,id_ABM_ultimo_usuario);
	VALUES ( ALLTRIM(xoarticulo_univoco.serial) ;
	, ALLTRIM(xoarticulo_univoco.rfid) ;
	, ALLTRIM(xoarticulo_univoco.codbar) ;
	,_id_ABM_Depositos;
	,_id_ABM_Depositos_ACTUAL;
	,_id_ABM_Articulos;
	, xoarticulo_univoco.identificados ;
	,_id_ABM_Empleados_del_cliente;
	,_id_ABM_Clientes;
	,_articulo_propio;
	,_id_Tipo_comprobante_ultimo;
	, xoarticulo_univoco.numero_comprobante_ultimo ;
	,1;
	,ALLTRIM(xoarticulo_univoco.observaciones);
	, xoarticulo_univoco.ids ;
	,1;
	, xoarticulo_univoco.ultima_lectura ;
	,DATETIME();
	,DATETIME();
	,0;
	,0;
	, xoarticulo_univoco.oxid_ABM_empresas ;
	, xoarticulo_univoco.oxid_ABM_regiones ;
	, xoarticulo_univoco.oxid_ABM_usuarios ;
	, xoarticulo_univoco.oxid_ABM_usuarios )

IF odb.CursorChanges(_ocursorSQL)
	IF odb.UPDATE(_ocursorSQL,.T.)
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
RELEASE _otablaq
TRY
	USE IN &_otablaSQL
CATCH TO oex
ENDTRY
odb.Disconnect()

RELEASE xoarticulo_univoco
*_SCREEN.winfx.ASYNC.RunAsync(lcScript)

