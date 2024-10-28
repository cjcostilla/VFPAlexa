tcTabla = ALIAS()
SCATTER NAME objTablaInsert MEMO
lcJSON = SincroJson(objTablaInsert)
IF USED("auditoria")
	USE IN auditoria
ENDIF 
IF !USED("auditoria")
	USE _rutadato + "auditoria.dbf" SHARED IN 0 
	CURSORSETPROP("Buffering",5,"auditoria")
ENDIF 
INSERT INTO Auditoria (Tabla, operacion, campos) VALUES (tcTabla, "INSERT", lcJSON)
=TABLEUPDATE(1,.T.,"auditoria")
RETURN .T.