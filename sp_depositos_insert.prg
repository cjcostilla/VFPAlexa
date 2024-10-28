LPARAMETERS xodepositos  

ADDPROPERTY(xodepositos, "oxid_ABM_regiones", _sincroaregion)
ADDPROPERTY(xodepositos, "oxid_ABM_usuarios", _sincroausuario)
ADDPROPERTY(xodepositos, "oxid_ABM_empresas", _sincroaempresa)

ADDPROPERTY(xodepositos, "_predet1", IIF(xodepositos.predet1 = .T., 1, 0))
ADDPROPERTY(xodepositos, "_ultimo_usado", IIF(xodepositos.ultimo_usado = .T., 1, 0))

ADDPROPERTY(xodepositos, "_trigger_engine", _screen.engine)
ADDPROPERTY(xodepositos, "_trigger_handle_driver", _screen.handle_driver)
ADDPROPERTY(xodepositos, "_trigger_handle_server", _screen.handle_server)
ADDPROPERTY(xodepositos, "_trigger_handle_user", _screen.handle_user)
ADDPROPERTY(xodepositos, "_trigger_handle_password", _screen.handle_password)
ADDPROPERTY(xodepositos, "_trigger_handle_database", _screen.handle_database)
ADDPROPERTY(xodepositos, "_trigger_handle_port", _screen.handle_port)
ADDPROPERTY(xodepositos, "_path","'"+ALLTRIM(JUSTPATH(FULLPATH("odb_connect_winfx.prg")))+"\'")


	 SET PATH TO  xodepositos._path  additive

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

	odb.Query(cConsultaid , _sqlCursor, _sqlTabla)
	IF odb.CursorOpen(_sqlCursor)
		SELECT &_sqlCursor
		IF RECCOUNT() > 0
			_id_ABM_clientes= id
		ELSE 
			_id_ABM_clientes= 0 &&NULL
		ENDIF 
	ENDIF
	
	_sqlTabla = "ABM_empleados_del_cliente"
	_sqlCursor = "SQL_empleados_del_cliente"

	cConsultaid = "SELECT ID FROM " + _sqlTabla ;
						+ " WHERE SINCRONIZACION = " + ALLTRIM(STR(xodepositos.idgeneral)) ;
						+' AND  id_ABM_empresas = ' + ALLTRIM(STR(xodepositos.oxid_ABM_empresas))
						
	odb.Query(cConsultaid , _sqlCursor, _sqlTabla)
	IF odb.CursorOpen(_sqlCursor)
		SELECT &_sqlCursor
		IF RECCOUNT() > 0
			_id_ABM_empleados_del_cliente= id
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

	cCodigoAuto="SELECT LPAD(IFNULL(MAX(codigo) + 1, 1), 4, '0') AS proximo FROM " + _otablaSQL +;
					" WHERE id_ABM_empresas = " + ALLTRIM(STR(xodepositos.oxid_ABM_empresas))
			
	odb.Query(cCodigoAuto ,_ocursorSQL ,_otablaSQL)
	
	IF odb.CursorOpen(_ocursorSQL)
		SELECT &_ocursorSQL
		_CodAuto = proximo
	ELSE 
		_CodAuto = '0001'
	ENDIF
	
	cConsulta="Select * from " + _otablaSQL + " where id_ABM_empresas = " + ALLTRIM(STR(xodepositos.oxid_ABM_empresas));
											 + " and id < 0 "

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
		,descripcion;   
		,domicilio;                          
		,id_ABM_tipos_de_deposito;           
		,predeterminado;                     
		,id_ABM_Tipos_de_Propietario;        
		,id_ABM_clientes; 
		,ultimo_usado;
		,clasificacion;                      
		,version;   
		,datetime;
		,ultimo_cambio;
		,eliminado;
		,activo;
		,id_ABM_empresas;                    
		,id_ABM_regiones;                    
		,id_ABM_usuarios;                    
		,id_ABM_ultimo_usuario;              
		,id_ABM_empleados_del_cliente;      
		,sincronizacion);                     
	VALUES (_CodAuto;	
		,ALLTRIM(UPPER(xodepositos.nombre));
		,'';	
		,'';	
		, ALLTRIM(UPPER(xodepositos.direccion)) ;
		,_id_ABM_tipos_de_deposito;
		, xodepositos._predet1 ;
		,_id_ABM_Tipos_de_Propietario ;
		,_id_ABM_clientes ;
		, xodepositos._ultimo_usado ;
		, xodepositos.clasificacion ;	
		, xodepositos.num ;	
		,DATETIME();
		,DATETIME();
		,0;
		,0;
		, xodepositos.oxid_ABM_empresas ;	
		, xodepositos.oxid_ABM_regiones ;	
		, xodepositos.oxid_ABM_usuarios ;	
		, xodepositos.oxid_ABM_usuarios ;	
		,_id_ABM_empleados_del_cliente ;
		, xodepositos.num )
	
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

RELEASE xodepositos  
*_SCREEN.winfx.ASYNC.RunAsync(lcScript)
