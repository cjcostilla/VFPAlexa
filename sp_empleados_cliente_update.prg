LPARAMETERS xoempleados_cliente

ADDPROPERTY(xoempleados_cliente, "oxid_ABM_regiones", _sincroaregion)
ADDPROPERTY(xoempleados_cliente, "oxid_ABM_usuarios", _sincroausuario)
ADDPROPERTY(xoempleados_cliente, "oxid_ABM_empresas", _sincroaempresa)

ADDPROPERTY(xoempleados_cliente, "_trigger_engine", _SCREEN.engine)
ADDPROPERTY(xoempleados_cliente, "_trigger_handle_driver", _SCREEN.handle_driver)
ADDPROPERTY(xoempleados_cliente, "_trigger_handle_server", _SCREEN.handle_server)
ADDPROPERTY(xoempleados_cliente, "_trigger_handle_user", _SCREEN.handle_user)
ADDPROPERTY(xoempleados_cliente, "_trigger_handle_password", _SCREEN.handle_password)
ADDPROPERTY(xoempleados_cliente, "_trigger_handle_database", _SCREEN.handle_database)
ADDPROPERTY(xoempleados_cliente, "_trigger_handle_port", _SCREEN.handle_port)
ADDPROPERTY(xoempleados_cliente, "_path","'"+ALLTRIM(JUSTPATH(FULLPATH("odb_connect_winfx.prg")))+"\'")


SET PATH TO  xoempleados_cliente._path  ADDITIVE

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


_sqlTabla = "ABM_clientes"
_sqlCursor = "SQL_clientes"

cConsultaid = "SELECT ID FROM " + _sqlTabla ;
	+ " WHERE SINCRONIZACION = " + ALLTRIM(STR(xoempleados_cliente.idcliente)) ;
	+' AND  id_ABM_empresas = ' + ALLTRIM(STR(xoempleados_cliente.oxid_ABM_empresas))



odb.QUERY(cConsultaid , _sqlCursor, _sqlTabla)
IF odb.CursorOpen(_sqlCursor)
	SELECT &_sqlCursor
	IF RECCOUNT() > 0
		_id_ABM_clientes= ID
	ELSE
		_id_ABM_clientes= 0 &&NULL
	ENDIF
ENDIF

_sqlTabla = "ABM_set_de_prendas_cabecera"
_sqlCursor = "SQL_set_de_prendas_cabecera"

cConsultaid = "SELECT ID FROM " + _sqlTabla ;
	+ ' WHERE TRIM(UPPER(nombre)) = "'+ ALLTRIM(UPPER(xoempleados_cliente.set_de_prendas));
	+'" AND  id_ABM_empresas = ' + ALLTRIM(STR(xoempleados_cliente.oxid_ABM_empresas))

odb.QUERY(cConsultaid , _sqlCursor, _sqlTabla)
IF odb.CursorOpen(_sqlCursor)
	SELECT &_sqlCursor
	IF RECCOUNT() > 0
		_id_ABM_Set_de_prendas= ID
	ELSE
		_id_ABM_Set_de_prendas= 0 &&NULL
	ENDIF
ENDIF

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
	" and sincronizacion = " + ALLTRIM(STR(xoempleados_cliente.ID)+;
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
		SET	legajo =  ALLTRIM(UPPER(xoempleados_cliente.legajo)) ;
		,nombre =  ALLTRIM(UPPER(xoempleados_cliente.nombre)) ;
		,domicilio = 'SIN DECLARAR';
		,id_ABM_clientes = _id_ABM_clientes ;
		,fecha_de_ingreso =  xoempleados_cliente.fecha_ingreso ;
		,fecha_de_chipeo =  xoempleados_cliente.fecha_chip ;
		,cargo =  ALLTRIM(UPPER(xoempleados_cliente.cargo)) ;
		,cantidad_de_prendas_asignadas =  xoempleados_cliente.prendas_asigandas ;
		,imagen =  ALLTRIM(UPPER(xoempleados_cliente.imagen)) ;
		,huella_dactilar = 'NO REGISTRADA';
		,codigo_saco_1 =  ALLTRIM(UPPER(xoempleados_cliente.codigo_saco1)) ;
		,codigo_saco_2 =  ALLTRIM(UPPER(xoempleados_cliente.codigo_saco2)) ;
		,numero_casillero =  ALLTRIM(UPPER(xoempleados_cliente.numero_casillero)) ;
		,talla =  ALLTRIM(UPPER(xoempleados_cliente.talla)) ;
		,sexo =  xoempleados_cliente.sexo ;
		,color_uniforme =  ALLTRIM(UPPER(xoempleados_cliente.color_uniforme)) ;
		,deja_ropa =  xoempleados_cliente.deja_ropa ;
		,articulo1 =  ALLTRIM(UPPER(xoempleados_cliente.articulo1)) ;
		,cantidad1 =  xoempleados_cliente.cantidad1 ;
		,estado1 =  ALLTRIM(UPPER(xoempleados_cliente.estado1)) ;
		,articulo2 =  ALLTRIM(UPPER(xoempleados_cliente.articulo2)) ;
		,cantidad2 =  xoempleados_cliente.cantidad2 ;
		,estado2 =  ALLTRIM(UPPER(xoempleados_cliente.estado2)) ;
		,articulo3 =  ALLTRIM(UPPER(xoempleados_cliente.articulo3)) ;
		,cantidad3 =  xoempleados_cliente.cantidad3 ;
		,estado3 =  ALLTRIM(UPPER(xoempleados_cliente.estado3)) ;
		,articulo4 =  ALLTRIM(UPPER(xoempleados_cliente.articulo4)) ;
		,cantidad4 =  xoempleados_cliente.cantidad4 ;
		,estado4 =  ALLTRIM(UPPER(xoempleados_cliente.estado4)) ;
		,articulo5 =  ALLTRIM(UPPER(xoempleados_cliente.articulo5)) ;
		,cantidad5 =  xoempleados_cliente.cantidad5 ;
		,estado5 =  ALLTRIM(UPPER(xoempleados_cliente.estado5)) ;
		,codigo_electronico =  ALLTRIM(UPPER(xoempleados_cliente.codigo_electronico)) ;
		,id_ABM_Set_de_prendas = _id_ABM_Set_de_prendas ;
		,ultimo_cambio = DATETIME();
		,id_ABM_empresas =  xoempleados_cliente.oxid_ABM_empresas ;
		,id_ABM_regiones =  xoempleados_cliente.oxid_ABM_regiones ;
		,id_ABM_usuarios =  xoempleados_cliente.oxid_ABM_usuarios ;
		,id_ABM_ultimo_usuario =  xoempleados_cliente.oxid_ABM_usuarios ;
		WHERE sincronizacion =  xoempleados_cliente.num

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

RELEASE xoempleados_cliente
*_SCREEN.winfx.ASYNC.RunAsync(lcScript)
