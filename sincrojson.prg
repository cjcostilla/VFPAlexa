LPARAMETERS oTabla
LOCAL cJSON, lcCampo, aCampos, cValor

lCenturyOriginal = SET("CENTURY")  && Guarda el valor actual de SET CENTURY
cDateFormatOriginal = SET("DATE")  && Guarda el formato actual de SET DATE
SET CENTURY ON
SET DATE AMERICAN  && O el formato de fecha que prefieras

* Obtener los nombres de los campos en un array
DIMENSION aCampos(1)
AMEMBERS(aCampos, oTabla, 1)  && Obtener los campos como propiedades del objeto

* Crear el JSON manualmente
cJSON = "{"
FOR x = 1 TO ALEN(aCampos)/2
	lcCampo = aCampos[x,1]  && Obtener el nombre del campo
	cValor = TRANSFORM(EVALUATE("oTabla." + lcCampo))  && Obtener el valor del campo

	* Si el campo es de tipo cadena, lo colocamos entre comillas
	IF TYPE("oTabla." + lcCampo) == "C"
		cValor = '"' + ALLTRIM(cValor) + '"'
	ENDIF
	* Añadir el campo y valor al JSON
	cJSON = cJSON + '"' + lcCampo + '":' + cValor + ","
NEXT
cJSON = LEFT(cJSON, LEN(cJSON) - 1)  && Quitar la última coma
cJSON = cJSON + "}"

* Restaurar las configuraciones originales
IF lCenturyOriginal == "ON"
    SET CENTURY ON
ELSE
    SET CENTURY OFF
ENDIF

SET DATE &cDateFormatOriginal  && Restaura el formato original de SET DATE

RETURN cJSON


