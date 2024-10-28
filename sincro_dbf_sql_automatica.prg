LPARAMETERS _xDirectorio
LOCAL objTabla AS OBJECT
LOCAL _idPrcesado
PUBLIC _saTablaOperacion, _saConsulta, _saEstado
_saTablaOperacion = ''
_saConsulta = '' 
_saEstado = ''

***
lCenturyOriginal = SET("CENTURY")  && Guarda el valor actual de SET CENTURY
cDateFormatOriginal = SET("DATE")  && Guarda el formato actual de SET DATE
lcOldHours = SET("HOURS") && Guardar la configuración actual de horas
SET HOURS TO 12
SET CENTURY ON
SET DATE AMERICAN
***

lcRuta = ALLTRIM(_xDirectorio) + "auditoria"

IF FILE(lcRuta+'.dbf') OR FILE(UPPER(lcRuta+'.dbf'))
	IF USED("auditoria")
		USE IN auditoria
	ENDIF

	IF !USED("auditoria")
		USE (lcRuta) SHARED IN 0
		CURSORSETPROP("Buffering",5,"auditoria")
	ENDIF

	lcSQL = "SELECT * FROM '" + lcRuta + "' WHERE procesado = .F. INTO CURSOR curAuditoria"
	&lcSQL

ELSE
	RETURN .F.
ENDIF

SELECT curAuditoria
IF RECCOUNT() = 0
	USE IN curAuditoria
	RETURN .F.
ENDIF 

SELECT curAuditoria
SCAN
	_idProcesado = curAuditoria.id
	objTabla = ObtenerObjetoTabla(curAuditoria.campos)
	_saTablaOperacion = ALLTRIM(UPPER(curAuditoria.Tabla)) + " - " + ALLTRIM(UPPER(curAuditoria.Operacion))

	DO CASE
		CASE ALLTRIM(UPPER(curAuditoria.Tabla)) = "ARTICULO_UNIVOCO1"
			DO CASE
				CASE ALLTRIM(UPPER(curAuditoria.Operacion)) = "INSERT"
					lcComand = 'DO '+ALLTRIM(_SCREEN._rutavieja)+ 'oDbsql\sp_articulo_univoco_insert.prg with objTabla'
					&lcComand
				CASE ALLTRIM(UPPER(curAuditoria.Operacion)) = "UPDATE"
					lcComand = 'DO '+ALLTRIM(_SCREEN._rutavieja)+ 'oDbsql\sp_articulo_univoco_update.prg with objTabla'
					&lcComand
				CASE ALLTRIM(UPPER(curAuditoria.Operacion)) = "DELETE"
					lcComand = 'DO '+ALLTRIM(_SCREEN._rutavieja)+ 'oDbsql\sp_articulo_univoco_delete.prg with objTabla'
					&lcComand
				OTHERWISE
			ENDCASE

		CASE ALLTRIM(UPPER(curAuditoria.Tabla)) = "DEPÓSITOS"
			DO CASE
				CASE ALLTRIM(UPPER(curAuditoria.Operacion)) = "INSERT"
					lcComand = 'DO '+ALLTRIM(_SCREEN._rutavieja)+ 'oDbsql\sp_depositos_insert.prg with objTabla'
					&lcComand
				CASE ALLTRIM(UPPER(curAuditoria.Operacion)) = "UPDATE"
					lcComand = 'DO '+ALLTRIM(_SCREEN._rutavieja)+ 'oDbsql\sp_depositos_update.prg with objTabla'
					&lcComand
				CASE ALLTRIM(UPPER(curAuditoria.Operacion)) = "DELETE"
					lcComand = 'DO '+ALLTRIM(_SCREEN._rutavieja)+ 'oDbsql\sp_depositos_delete.prg with objTabla'
					&lcComand
				OTHERWISE
			ENDCASE

		CASE ALLTRIM(UPPER(curAuditoria.Tabla)) = "EMPLEADOS_CLIENTE"
			DO CASE
				CASE ALLTRIM(UPPER(curAuditoria.Operacion)) = "INSERT"
					lcComand = 'DO '+ALLTRIM(_SCREEN._rutavieja)+ 'oDbsql\sp_empleados_cliente_insert.prg with objTabla'
					&lcComand
				CASE ALLTRIM(UPPER(curAuditoria.Operacion)) = "UPDATE"
					lcComand = 'DO '+ALLTRIM(_SCREEN._rutavieja)+ 'oDbsql\sp_empleados_cliente_update.prg with objTabla'
					&lcComand
				CASE ALLTRIM(UPPER(curAuditoria.Operacion)) = "DELETE"
					lcComand = 'DO '+ALLTRIM(_SCREEN._rutavieja)+ 'oDbsql\sp_empleados_cliente_delete.prg with objTabla'
					&lcComand
				OTHERWISE
			ENDCASE

		CASE ALLTRIM(UPPER(curAuditoria.Tabla)) = "CLIENTES"
			DO CASE
				CASE ALLTRIM(UPPER(curAuditoria.Operacion)) = "INSERT"
					lcComand = 'DO '+ALLTRIM(_SCREEN._rutavieja)+ 'oDbsql\sp_cliente_insert.prg with objTabla'
					&lcComand
				CASE ALLTRIM(UPPER(curAuditoria.Operacion)) = "UPDATE"
					lcComand = 'DO '+ALLTRIM(_SCREEN._rutavieja)+ 'oDbsql\sp_cliente_update.prg with objTabla'
					&lcComand
				CASE ALLTRIM(UPPER(curAuditoria.Operacion)) = "DELETE"
					lcComand = 'DO '+ALLTRIM(_SCREEN._rutavieja)+ 'oDbsql\sp_cliente_delete.prg with objTabla'
					&lcComand
				OTHERWISE
			ENDCASE

		CASE ALLTRIM(UPPER(curAuditoria.Tabla)) = "UNIDMEDIDA"
			DO CASE
				CASE ALLTRIM(UPPER(curAuditoria.Operacion)) = "INSERT"
					lcComand = 'DO '+ALLTRIM(_SCREEN._rutavieja)+ 'oDbsql\sp_unidmedida_insert.prg with objTabla'
					&lcComand
				CASE ALLTRIM(UPPER(curAuditoria.Operacion)) = "UPDATE"
					lcComand = 'DO '+ALLTRIM(_SCREEN._rutavieja)+ 'oDbsql\sp_unidmedida_update.prg with objTabla'
					&lcComand
				CASE ALLTRIM(UPPER(curAuditoria.Operacion)) = "DELETE"
					lcComand = 'DO '+ALLTRIM(_SCREEN._rutavieja)+ 'oDbsql\sp_unidmedida_delete.prg with objTabla'
					&lcComand
				OTHERWISE
			ENDCASE

		CASE ALLTRIM(UPPER(curAuditoria.Tabla)) = "RUBRO"
			DO CASE
				CASE ALLTRIM(UPPER(curAuditoria.Operacion)) = "INSERT"
					lcComand = 'DO '+ALLTRIM(_SCREEN._rutavieja)+ 'oDbsql\sp_rubro_insert.prg with objTabla'
					&lcComand
				CASE ALLTRIM(UPPER(curAuditoria.Operacion)) = "UPDATE"
					lcComand = 'DO '+ALLTRIM(_SCREEN._rutavieja)+ 'oDbsql\sp_rubro_update.prg with objTabla'
					&lcComand
				CASE ALLTRIM(UPPER(curAuditoria.Operacion)) = "DELETE"
					lcComand = 'DO '+ALLTRIM(_SCREEN._rutavieja)+ 'oDbsql\sp_rubro_delete.prg with objTabla'
					&lcComand
				OTHERWISE
			ENDCASE

		CASE ALLTRIM(UPPER(curAuditoria.Tabla)) = "SUBRUBRO"
			DO CASE
				CASE ALLTRIM(UPPER(curAuditoria.Operacion)) = "INSERT"
					lcComand = 'DO '+ALLTRIM(_SCREEN._rutavieja)+ 'oDbsql\sp_subrubro_insert.prg with objTabla'
					&lcComand
				CASE ALLTRIM(UPPER(curAuditoria.Operacion)) = "UPDATE"
					lcComand = 'DO '+ALLTRIM(_SCREEN._rutavieja)+ 'oDbsql\sp_subrubro_update.prg with objTabla'
					&lcComand
				CASE ALLTRIM(UPPER(curAuditoria.Operacion)) = "DELETE"
					lcComand = 'DO '+ALLTRIM(_SCREEN._rutavieja)+ 'oDbsql\sp_subrubro_delete.prg with objTabla'
					&lcComand
				OTHERWISE
			ENDCASE

		CASE ALLTRIM(UPPER(curAuditoria.Tabla)) = "COLORES"
			DO CASE
				CASE ALLTRIM(UPPER(curAuditoria.Operacion)) = "INSERT"
					lcComand = 'DO '+ALLTRIM(_SCREEN._rutavieja)+ 'oDbsql\sp_colores_insert.prg with objTabla'
					&lcComand
				CASE ALLTRIM(UPPER(curAuditoria.Operacion)) = "UPDATE"
					lcComand = 'DO '+ALLTRIM(_SCREEN._rutavieja)+ 'oDbsql\sp_colores_update.prg with objTabla'
					&lcComand
				CASE ALLTRIM(UPPER(curAuditoria.Operacion)) = "DELETE"
					lcComand = 'DO '+ALLTRIM(_SCREEN._rutavieja)+ 'oDbsql\sp_colores_delete.prg with objTabla'
					&lcComand
				OTHERWISE
			ENDCASE

		CASE ALLTRIM(UPPER(curAuditoria.Tabla)) = "STOCK1"
			DO CASE
				CASE ALLTRIM(UPPER(curAuditoria.Operacion)) = "INSERT"
					lcComand = 'DO '+ALLTRIM(_SCREEN._rutavieja)+ 'oDbsql\sp_stock1_insert.prg with objTabla'
					&lcComand
				CASE ALLTRIM(UPPER(curAuditoria.Operacion)) = "UPDATE"
					lcComand = 'DO '+ALLTRIM(_SCREEN._rutavieja)+ 'oDbsql\sp_stock1_update.prg with objTabla'
					&lcComand
				CASE ALLTRIM(UPPER(curAuditoria.Operacion)) = "DELETE"
					lcComand = 'DO '+ALLTRIM(_SCREEN._rutavieja)+ 'oDbsql\sp_stock1_delete.prg with objTabla'
					&lcComand
				OTHERWISE
			ENDCASE
		OTHERWISE
	ENDCASE
	INSERT INTO Detalle_Sincro(fecha_hora,operacion,detalle,empresa);
	VALUES (DATETIME(),_saTablaOperacion,_saEstado, ALLTRIM(UPPER(csrEmpresas.nombre)))
	RELEASE objTabla
	=MarcarProcesado(_xDirectorio, _idProcesado)
	SELECT curAuditoria
ENDSCAN

USE IN curAuditoria
* Restaurar las configuraciones originales
IF lCenturyOriginal == "ON"
    SET CENTURY ON
ELSE
    SET CENTURY OFF
ENDIF
* Restaura el formato original de SET DATE
SET DATE &cDateFormatOriginal  
* Restaurar la configuración original de horas
SET HOURS TO &lcOldHours

RETURN .f.


FUNCTION MarcarProcesado(cDirectorio,nAuditoria)
	IF USED("auditoria")
		CURSORSETPROP("Buffering",5,"auditoria")
	ENDIF
	IF !USED("auditoria")
		USE "'" + ALLTRIM(cDirectorio) + "auditoria.dbf'" SHARED IN 0
		CURSORSETPROP("Buffering",5,"auditoria")
	ENDIF
	_cmd = "UPDATE '" + ALLTRIM(cDirectorio) + "auditoria.dbf' SET procesado = .T. WHERE ID =" + ALLTRIM(STR(nAuditoria))
	&_cmd
	=TABLEUPDATE(1,.T.,"auditoria")
	RETURN .T.
ENDFUNC

FUNCTION ObtenerObjetoTabla(cJson)
	LOCAL oTabla, aCampos, lcCampo, cValor, tValor

	* Crear un objeto vacío
	oTabla = CREATEOBJECT("Empty")

	* Inicializar el array aCampos
	DIMENSION aCampos(1)

	* Parsear el JSON manualmente (suponiendo que está bien formateado)
	cJson = SUBSTR(cJson, 2, LEN(cJson) - 2)  && Eliminar llaves {}
	cCampos = STRTRAN(cJson, '","', '","')  && Separar pares clave-valor

	* Llenar el array aCampos con los pares clave-valor del JSON
	ALINES(aCampos, cCampos, 1, ',')
	FOR i = 1 TO ALEN(aCampos)
		tvalor=null
		lcCampo = ALLTRIM(GETWORDNUM(aCampos[i], 1, ":"))  && Extraer el nombre del campo
		lcCampo = STRTRAN(lcCampo, '"', '')  && Eliminar las dobles comillas del nombre del campo
		cValor = SUBSTR(aCampos[i], AT(":", aCampos[i]) + 1)  && Extraer el valor

		* Verificar si el valor parece una fecha o una fecha y hora
		DO CASE
			CASE MyIsDate(cValor)
				* Si es solo una fecha
				tValor = StringToDate(cValor)
				*tValor = cValor
			CASE MyIsDateTime(cValor)
				* Si es fecha y hora
				tValor = StringToDateTime(cValor)
				*tValor = cValor
			CASE ISDIGIT(cValor)
				* Otro tipo de datos (números, cadenas, etc.)
				tValor = VAL(cValor)
			CASE cValor == "  /  /       :  :   AM" OR cValor == "  /  /       :  :"
				tValor = NULL
			CASE cValor == ".T."
				tValor=.T.
			CASE cValor == ".F."
				tValor=.F.
			OTHERWISE
				IF LEFT(cValor, 1) == '"' AND RIGHT(cValor, 1) == '"'
					tValor = SUBSTR(cValor, 2, LEN(cValor) - 2)
				ENDIF
		ENDCASE

		* Añadir la propiedad al objeto
		ADDPROPERTY(oTabla, lcCampo, tValor)
	NEXT
	* Ahora oTabla contiene los valores decodificados correctamente
	RETURN oTabla
ENDFUNC

* Función para validar fechas y horas (formato MM/DD/YY hh:mm:ss AM/PM)
FUNCTION MyIsDateTime(cValue)
	LOCAL dDate, cTime, cAMPM

	IF EMPTY(cValue)
		RETURN .F.
	ENDIF

	cTime = SUBSTR(cValue, 12, 8)  && Extraer la parte de la hora y minutos
	cAMPM = UPPER(SUBSTR(cValue, 21, 2))  && Extraer AM/PM

	TRY
		dDate = CTOD(SUBSTR(cValue, 1, 10))  && Intentar convertir la parte de la fecha
		IF DTOC(dDate)=='  /  /    '
		ELSE
			cTime1 = TTOC(CTOT(cValue),2) &&SUBSTR(cValue, 12, 8)  && Extraer la parte de la hora y minutos
			cTime = LEFT(ctime1,8)
			cAMPM = UPPER(SUBSTR(cTime1, 10, 2))  && Extraer AM/PM
		ENDIF 
	CATCH
		RETURN .F.  && Si falla la conversión de fecha, retornar falso
	ENDTRY

	IF LEN(cTime) <> 8 OR cAMPM # "AM" AND cAMPM # "PM"
		RETURN .F.  && Si no tiene el formato esperado de hora o AM/PM, retornar falso
	ENDIF

	RETURN .T.  && Si pasa todas las validaciones, retornar verdadero
ENDFUNC

FUNCTION MyIsDate(cValue)
	LOCAL lIsDate
	lIsDate = .F.

	* Verificar si tiene formato de fecha (MM/DD/YY o MM/DD/YYYY)
	IF LEN(cValue) == 8 OR LEN(cValue) == 10
		lIsDate = BETWEEN(SUBSTR(cValue, 1, 2), "01", "12") AND ;
			BETWEEN(SUBSTR(cValue, 4, 2), "01", "31") AND ;
			(LEN(SUBSTR(cValue, 7)) == 2 OR LEN(SUBSTR(cValue, 7)) == 4)
	ENDIF
	IF LEN(cValue) == 6
		lIsDate = IIF(cValue == "  /  /",.T.,.F.)
	ENDIF 

	RETURN lIsDate
ENDFUNC

FUNCTION ObtenerEmpresa()
	PUBLIC _sincroaempresa, _sincroaregion, _sincroausuario, _sincroarutadato
	PUBLIC _sincroaui, _sincromoneda, _sincrocadenamoneda
	SELECT csrEmpresas
	_sincroaempresa = IIF(EMPTY(csrEmpresas.num1),csrEmpresas.ids,VAL(csrEmpresas.num1))
	_sincroarutadato = ALLTRIM(csrEmpresas.DIRECTORIO)
	_sincroausuario = 1
	_sincromoneda = 0
	_sincrocadenamoneda = ''
	DO CASE
		CASE ALLTRIM(csrEmpresas.NUM3) = "ARGENTINA"
			_sincroaregion = 1
			_sincromoneda = 1
			_sincrocadenamoneda = 'PESO'
		CASE ALLTRIM(csrEmpresas.NUM3) = "MÉXICO"
			_sincroaregion = 2
			_sincromoneda = 10
			_sincrocadenamoneda = 'PESO MEXICANO'
		CASE ALLTRIM(csrEmpresas.NUM3) = "COLOMBIA"
			_sincroaregion = 3
			_sincromoneda = 12
			_sincrocadenamoneda = 'PESO COLOMBIANO'
		CASE ALLTRIM(csrEmpresas.NUM3) = "VENEZUELA"
			_sincroaregion = 4
			_sincromoneda = 4
			_sincrocadenamoneda = 'BOLIVAR'
		CASE ALLTRIM(csrEmpresas.NUM3) = "E.E.U.U."
			_sincroaregion = 5
			_sincromoneda = 2
			_sincrocadenamoneda = 'DOLAR'
		CASE ALLTRIM(csrEmpresas.NUM3) = "CHILE"
			_sincroaregion = 6
			_sincromoneda = 11
			_sincrocadenamoneda = 'PESO'
		CASE ALLTRIM(csrEmpresas.NUM3) = "BRASIL"
			_sincroaregion = 7
			_sincromoneda = 3
			_sincrocadenamoneda = 'REAL'
		CASE ALLTRIM(csrEmpresas.NUM3) = "COSTA RICA"
			_sincroaregion = 8
			_sincromoneda = 5
			_sincrocadenamoneda = 'COLON'
		CASE ALLTRIM(csrEmpresas.NUM3) = "PARAGUAY"
			_sincroaregion = 9
			_sincromoneda = 6
			_sincrocadenamoneda = 'GUARANI'
		CASE ALLTRIM(csrEmpresas.NUM3) = "PERU"
			_sincroaregion = 10
			_sincromoneda = 7
			_sincrocadenamoneda = 'SOL'
		CASE ALLTRIM(csrEmpresas.NUM3) = "PANAMÁ"
			_sincroaregion = 11
			_sincromoneda = 8
			_sincrocadenamoneda = 'BALBOA'
		CASE ALLTRIM(csrEmpresas.NUM3) = "URUGUAY"
			_sincroaregion = 12
			_sincromoneda = 9
			_sincrocadenamoneda = 'PESO'
		CASE ALLTRIM(csrEmpresas.NUM3) = "BOLIVIA"
			_sincroaregion = 13
			_sincromoneda = 13
			_sincrocadenamoneda = 'BOLIVIANO'
		CASE ALLTRIM(csrEmpresas.NUM3) = "PUERTO RICO"
			_sincroaregion = 14
			_sincromoneda = 2
			_sincrocadenamoneda = 'DOLAR'
		CASE ALLTRIM(csrEmpresas.NUM3) = "HONDURAS"
			_sincroaregion = 15
			_sincromoneda = 14
			_sincrocadenamoneda = 'LEMPIRA'
		CASE ALLTRIM(csrEmpresas.NUM3) = "NICARAGUA"
			_sincroaregion = 16
			_sincromoneda = 15
			_sincrocadenamoneda = 'CORDOBA'
		CASE ALLTRIM(csrEmpresas.NUM3) = "ECUADOR"
			_sincroaregion = 17
			_sincromoneda = 2
			_sincrocadenamoneda = 'DOLAR'
		CASE ALLTRIM(csrEmpresas.NUM3) = "GUATEMALA"
			_sincroaregion = 18
			_sincromoneda = 16
			_sincrocadenamoneda = 'QUETZAL'
		CASE ALLTRIM(csrEmpresas.NUM3) = "ESPAÑA"
			_sincroaregion = 19
			_sincromoneda = 17
			_sincrocadenamoneda = 'EURO'
		CASE ALLTRIM(csrEmpresas.NUM3) = "REPUBLICA DOMINICANA"
			_sincroaregion = 20
			_sincromoneda = 18
			_sincrocadenamoneda = 'PESO DOMINICANO'
		CASE ALLTRIM(csrEmpresas.NUM3) = "BAHAMAS"
			_sincroaregion = 21
			_sincromoneda = 19
			_sincrocadenamoneda = 'DOLAR BAHAMEÑO'
		CASE ALLTRIM(csrEmpresas.NUM3) = "EL SALVADOR"
			_sincroaregion = 22
			_sincromoneda = 2
			_sincrocadenamoneda = 'DOLAR'
		CASE ALLTRIM(csrEmpresas.NUM3) = "JAMAICA"
			_sincroaregion = 23
			_sincromoneda = 20
			_sincrocadenamoneda = 'DOLAR JAMAIQUINO'
		CASE ALLTRIM(csrEmpresas.NUM3) = "CANADA"
			_sincroaregion = 24
			_sincromoneda = 21
			_sincrocadenamoneda = 'DOLAR CANADIENSE'
		CASE ALLTRIM(csrEmpresas.NUM3) = "TRINIDAD Y TOBAGO"
			_sincroaregion = 25
			_sincromoneda = 22
			_sincrocadenamoneda = 'DOLAR TRINITENSE'
		CASE ALLTRIM(csrEmpresas.NUM3) = "BELICE"
			_sincroaregion = 26
			_xmoneda = 23
			_sincrocadenamoneda = 'DOLAR BELICEÑO'
		CASE ALLTRIM(csrEmpresas.NUM3) = "GUYANA"
			_sincroaregion = 27
			_sincromoneda = 24
			_sincrocadenamoneda = 'DOLAR GUYANES'
		CASE ALLTRIM(csrEmpresas.NUM3) = "SURINAM"
			_sincroaregion = 28
			_sincromoneda = 25
			_sincrocadenamoneda = 'DOLAR SURINAMES'
		CASE ALLTRIM(csrEmpresas.NUM3) = "HAITI"
			_sincroaregion = 29
			_sincromoneda = 26
			_sincrocadenamoneda = 'GOURDE'
		OTHERWISE
			_sincroaregion = 99
			_sincromoneda = 1
			_sincrocadenamoneda = 'PESO'
	ENDCASE

	DO CASE
		CASE ALLTRIM(csrEmpresas.OTROSIMP3) = "PUNTO DE VENTA"
			_xrubro = 0
		CASE ALLTRIM(csrEmpresas.OTROSIMP3) = "SEDE ADMINISTRATIVA"
			_xrubro = 1
		OTHERWISE
			_xrubro = 99
	ENDCASE
	RETURN .T.
ENDFUNC

FUNCTION StringToDateTime(cDateTime)
	LOCAL cDate, cTime, nHour, nMinute, nSecond, cAMPM, dtValue
	* Separar la parte de la fecha y la hora
	cDate = SUBSTR(cDateTime, 1, 10)   && Ejemplo: "10/16/24"
*	cTime = SUBSTR(cDateTime, 12, 8)  && Ejemplo: "03:55:00"
*	cAMPM = SUBSTR(cDateTime, 21, 2)  && AM o PM
		cTime1 = TTOC(CTOT(cDateTime),2) &&SUBSTR(cValue, 12, 8)  && Extraer la parte de la hora y minutos
		cTime = LEFT(ctime1,8)
		cAMPM = UPPER(SUBSTR(cTime1, 10, 2))  && Extraer AM/PM

	* Convertir la hora, minuto, segundo a valores numéricos
	nHour = VAL(SUBSTR(cTime, 1, 2))
	nMinute = VAL(SUBSTR(cTime, 4, 2))
	nSecond = VAL(SUBSTR(cTime, 7, 2))

	* Ajustar la hora según AM/PM
	IF UPPER(cAMPM) = "PM" AND nHour < 12
		nHour = nHour + 12
	ELSE
		IF UPPER(cAMPM) = "AM" AND nHour = 12
			nHour = 0
		ENDIF
	ENDIF

	IF (VAL(SUBSTR(cDate, 7, 4)) > 0 AND VAL(SUBSTR(cDate, 1, 2)) > 0 AND VAL(SUBSTR(cDate, 4, 2)) > 0)
		* Convertir la fecha a DateTime usando la función DATETIME()
		dtValue = DATETIME(VAL(SUBSTR(cDate, 7, 4)), ;
			VAL(SUBSTR(cDate, 1, 2)), ;
			VAL(SUBSTR(cDate, 4, 2)), ;
			nHour, nMinute, nSecond)
	ELSE 
		dtValue = NULL
	ENDIF 
	RETURN dtValue
ENDFUNC

FUNCTION StringToDate(cFecha)
	* Verifica si la cadena tiene el formato esperado
	IF !EMPTY(cFecha) AND (LEN(cFecha) == 8 OR LEN(cFecha) == 10)
		* Extrae mes, día y año de la cadena
		nMes = VAL(SUBSTR(cFecha, 1, 2))  && Mes
		nDia = VAL(SUBSTR(cFecha, 4, 2))  && Día
		nAnio = VAL(SUBSTR(cFecha, 9, 2))  && Año en formato de dos dígitos

		* Si el año es menor o igual a 49, asumimos que es 2000+, si es mayor, es 1900+
		IF nAnio <= 49
			nAnio = 2000 + nAnio
		ELSE
			nAnio = 1900 + nAnio
		ENDIF

		* Crear el valor de tipo Date con DATE(anio, mes, dia)
		RETURN DATE(nAnio, nMes, nDia)
	ELSE
		RETURN .NULL.  && Si no cumple con el formato esperado, devuelve .NULL.
	ENDIF
ENDFUNC
