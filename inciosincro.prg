
* Configurar el entorno de la aplicación
_SCREEN.Visible = .F.  
SET TALK OFF
SET NOTIFY OFF
SET CURSOR OFF
SET EXCLUSIVE OFF
SET DEFAULT TO SYS(5) + CURDIR()
setiniciales()
SET PROCEDURE TO sincro_dbf_sql_automatica.prg ADDITIVE
SET DELETED ON

* Ejecutar el formulario principal
DO FORM sincro_info
READ EVENTS            


