LPARAMETERS xostock1

ADDPROPERTY(xostock1, "oxid_ABM_regiones", _sincroaregion)
ADDPROPERTY(xostock1, "oxid_ABM_usuarios", _sincroausuario)
ADDPROPERTY(xostock1, "oxid_ABM_empresas", _sincroaempresa)

ADDPROPERTY(xostock1, "_trigger_engine", _SCREEN.engine)
ADDPROPERTY(xostock1, "_trigger_handle_driver", _SCREEN.handle_driver)
ADDPROPERTY(xostock1, "_trigger_handle_server", _SCREEN.handle_server)
ADDPROPERTY(xostock1, "_trigger_handle_user", _SCREEN.handle_user)
ADDPROPERTY(xostock1, "_trigger_handle_password", _SCREEN.handle_password)
ADDPROPERTY(xostock1, "_trigger_handle_database", _SCREEN.handle_database)
ADDPROPERTY(xostock1, "_trigger_handle_port", _SCREEN.handle_port)
ADDPROPERTY(xostock1, "_path","'"+ALLTRIM(JUSTPATH(FULLPATH("odb_connect_winfx.prg")))+"\'")

SET PATH TO  xostock1._path  ADDITIVE

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


_Stock_minimo = IIF(ISBLANK(xostock1.stminimo), 0, VAL(ALLTRIM(xostock1.stminimo)) )
_Stock_maximo = IIF(ISBLANK(xostock1.stmaximo), 0, VAL(ALLTRIM(xostock1.stmaximo)) )

_sqlTabla = "ABM_Rubros"
_sqlCursor = "SQL_Rubros"
cConsultaid = 'SELECT id FROM ' + _sqlTabla ;
	+ ' WHERE TRIM(UPPER(nombre)) = "'+ ALLTRIM(UPPER(xostock1.rubro));
	+'" AND  id_ABM_empresas = ' + ALLTRIM(STR(xostock1.oxid_ABM_empresas))

odb.QUERY(cConsultaid , _sqlCursor, _sqlTabla)
IF odb.CursorOpen(_sqlCursor)
	SELECT &_sqlCursor
	IF RECCOUNT() > 0
		_id_ABM_Rubro = ID
	ELSE
		_id_ABM_Rubro = 0 &&NULL
	ENDIF
ENDIF

_sqlTabla = "ABM_SubRubros"
_sqlCursor = "SQL_SubRubros"
cConsultaid = 'SELECT id FROM ' + _sqlTabla ;
	+ ' WHERE TRIM(UPPER(nombre)) = "'+ ALLTRIM(UPPER(xostock1.subrubro));
	+'" AND  id_ABM_empresas = ' + ALLTRIM(STR(xostock1.oxid_ABM_empresas))

odb.QUERY(cConsultaid , _sqlCursor, _sqlTabla)
IF odb.CursorOpen(_sqlCursor)
	SELECT &_sqlCursor
	IF RECCOUNT() > 0
		_id_ABM_Subrubros = ID
	ELSE
		_id_ABM_Subrubros = 0 &&NULL
	ENDIF
ENDIF

_sqlTabla = "ABM_Unidades_de_Medida"
_sqlCursor = "SQL_Unidades_de_Medida"
cConsultaid = 'SELECT id FROM ' + _sqlTabla ;
	+ ' WHERE TRIM(UPPER(nombre)) = "'+ ALLTRIM(UPPER(xostock1.unmedida));
	+'" AND  id_ABM_empresas = ' + ALLTRIM(STR(xostock1.oxid_ABM_empresas))

odb.QUERY(cConsultaid , _sqlCursor, _sqlTabla)
IF odb.CursorOpen(_sqlCursor)
	SELECT &_sqlCursor
	IF RECCOUNT() > 0
		_id_ABM_Unidades_de_Medida = ID
	ELSE
		_id_ABM_Unidades_de_Medida = 0 &&NULL
	ENDIF
ENDIF

_sqlTabla = "ABM_descriptores_cabecera"
_sqlCursor = "SQL_descriptores_cabecera"
cConsultaid = 'SELECT id FROM ' + _sqlTabla ;
	+ ' WHERE TRIM(UPPER(nombre)) = "'+ ALLTRIM(UPPER(xostock1.COLOR));
	+'" AND  id_ABM_empresas = ' + ALLTRIM(STR(xostock1.oxid_ABM_empresas))

odb.QUERY(cConsultaid , _sqlCursor, _sqlTabla)
IF odb.CursorOpen(_sqlCursor)
	SELECT &_sqlCursor
	IF RECCOUNT() > 0
		_id_ABM_Colores = ID
	ELSE
		_id_ABM_Colores = 0 &&NULL
	ENDIF
ENDIF

_sqlTabla = "ABM_talles"
_sqlCursor = "SQL_talles"
cConsultaid = 'SELECT id FROM ' + _sqlTabla ;
	+ ' WHERE TRIM(UPPER(nombre)) = "'+ ALLTRIM(UPPER(xostock1.SIZE));
	+'" AND  id_ABM_empresas = ' + ALLTRIM(STR(xostock1.oxid_ABM_empresas))

odb.QUERY(cConsultaid , _sqlCursor, _sqlTabla)
IF odb.CursorOpen(_sqlCursor)
	SELECT &_sqlCursor
	IF RECCOUNT() > 0
		_id_ABM_Talles = ID
	ELSE
		_id_ABM_Talles = 0 &&NULL
	ENDIF
ENDIF

_sqlTabla = "ABM_cuentas_contables"
_sqlCursor = "SQL_cuentas_contables"
cConsultaid = 'SELECT id FROM ' + _sqlTabla ;
	+ ' WHERE TRIM(UPPER(nombre)) = "'+ ALLTRIM(UPPER(xostock1.ctacompras));
	+'" AND  id_ABM_empresas = ' + ALLTRIM(STR(xostock1.oxid_ABM_empresas))

odb.QUERY(cConsultaid , _sqlCursor, _sqlTabla)
IF odb.CursorOpen(_sqlCursor)
	SELECT &_sqlCursor
	IF RECCOUNT() > 0
		_id_Cuentas_Contables_Compras = ID
	ELSE
		_id_Cuentas_Contables_Compras = 0 &&NULL
	ENDIF
ENDIF

_sqlTabla = "ABM_cuentas_contables"
_sqlCursor = "SQL_cuentas_contables"
cConsultaid = 'SELECT id FROM ' + _sqlTabla ;
	+ ' WHERE TRIM(UPPER(nombre)) = "'+ ALLTRIM(UPPER(xostock1.ctaventas));
	+'" AND  id_ABM_empresas = ' + ALLTRIM(STR(xostock1.oxid_ABM_empresas))

odb.QUERY(cConsultaid , _sqlCursor, _sqlTabla)
IF odb.CursorOpen(_sqlCursor)
	SELECT &_sqlCursor
	IF RECCOUNT() > 0
		_id_Cuentas_Contables_Ventas = ID
	ELSE
		_id_Cuentas_Contables_Ventas = 0 &&NULL
	ENDIF
ENDIF

IF EMPTY(xostock1.ccostocpra)
	_id_Centros_de_Costo_Compras = 0 &&NULL
ELSE
	_sqlTabla = "ABM_Centros_de_Costo"
	_sqlCursor = "SQL_Centros_de_Costo"
	cConsultaid = 'SELECT id FROM ' + _sqlTabla ;
		+ ' WHERE TRIM(UPPER(nombre)) = "'+ ALLTRIM(UPPER(xostock1.ccostocpra));
		+'" AND  id_ABM_empresas = ' + ALLTRIM(STR(xostock1.oxid_ABM_empresas))

	odb.QUERY(cConsultaid , _sqlCursor, _sqlTabla)
	IF odb.CursorOpen(_sqlCursor)
		SELECT &_sqlCursor
		IF RECCOUNT() > 0
			_id_Centros_de_Costo_Compras = ID
		ELSE
			_id_Centros_de_Costo_Compras = 0 &&NULL
		ENDIF
	ENDIF
ENDIF


IF EMPTY(xostock1.ccostovta)
	_id_Centros_de_Costo_Ventas = 0 &&NULL
ELSE
	_sqlTabla = "ABM_Centros_de_Costo"
	_sqlCursor = "SQL_Centros_de_Costo"
	cConsultaid = 'SELECT id FROM ' + _sqlTabla ;
		+ ' WHERE TRIM(UPPER(nombre)) = "'+ ALLTRIM(UPPER(xostock1.ccostovta));
		+'" AND  id_ABM_empresas = ' + ALLTRIM(STR(xostock1.oxid_ABM_empresas))

	odb.QUERY(cConsultaid , _sqlCursor, _sqlTabla)
	IF odb.CursorOpen(_sqlCursor)
		SELECT &_sqlCursor
		IF RECCOUNT() > 0
			_id_Centros_de_Costo_Ventas = ID
		ELSE
			_id_Centros_de_Costo_Ventas = 0 &&NULL
		ENDIF
	ENDIF
ENDIF

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
		SET codigo = ALLTRIM(xostock1.codigo);
		,nombre = ALLTRIM(xostock1.detalle);
		,codigo_de_barras = ALLTRIM(xostock1.ITEM);
		,id_ABM_Rubros = _id_ABM_Rubro ;
		,id_ABM_Subrubros = _id_ABM_Subrubros ;
		,id_ABM_Unidades_de_Medida = _id_ABM_Unidades_de_Medida ;
		,id_ABM_Colores = _id_ABM_Colores ;
		,id_ABM_Talles = _id_ABM_Talles ;
		,precio_de_costo =  xostock1.pcosto ;
		,impuestos_internos =  xostock1.impinter ;
		,stock_minimo = _Stock_minimo ;
		,stock_maximo = _Stock_maximo ;
		,id_Cuentas_Contables_Compras = _id_Cuentas_Contables_Compras ;
		,id_Cuentas_Contables_Ventas = _id_Cuentas_Contables_Ventas ;
		,id_Centros_de_Costo_Compras = _id_Centros_de_Costo_Compras ;
		,id_Centros_de_Costo_Ventas = _id_Centros_de_Costo_Ventas ;
		,criterio_de_rotacion =  EVL(xostock1.rotacion,0) ;
		,peso_seco =  xostock1.peso_seco ;
		,peso_seco_cota_de_error =  xostock1.peso_seco_error ;
		,peso_humedo =  xostock1.peso_humedo ;
		,peso_humedo_cota_de_error =  xostock1.peso_humero_error ;
		,imagen = ALLTRIM(xostock1.imagen);
		,observaciones = ALLTRIM(xostock1.observac);
		,VERSION =  xostock1.num ;
		,ultimo_cambio = DATETIME();
		,id_ABM_empresas =  xostock1.oxid_ABM_empresas ;
		,id_ABM_regiones =  xostock1.oxid_ABM_regiones ;
		,id_ABM_usuarios =  xostock1.oxid_ABM_usuarios ;
		,id_ABM_ultimo_usuario =  xostock1.oxid_ABM_usuarios ;
		WHERE sincronizacion =  xostock1.num


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

RELEASE xostock1
*_SCREEN.winfx.ASYNC.RunAsync(lcScript)
