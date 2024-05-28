PowerLogger y PowerLogon

Descripción:

PowerLogger y PowerLogon son scripts escritos en powershell diseñados para ayudarte a monitorear y registrar eventos del sistema en tu computadora. 
Estos scripts aprovechan las capacidades del Visor de eventos de Windows para proporcionarte información sobre eventos importantes como encendido, reinicio, apagado, inicios de sesión exitosos y fallidos, entre otros.

El script es un archivo .bat para evitar las medidas de seguridad predeterminadas de powershell en Windows.

Características:

PowerLogger: Una versión básica del script que se enfoca en registrar eventos de encendido, reinicio y apagado del sistema.

PowerLogon: Una versión ampliada del script que incluye opciones adicionales para monitorear inicios de sesión exitosos y fallidos, así como otros eventos relacionados con la seguridad del sistema.

Cómo usar:

    Clona o descarga el repositorio en tu máquina local.
    Click derecho en el archivo
    Ejecuta el script bat como administrador
    Sigue las instrucciones en pantalla para seleccionar las opciones de monitoreo de eventos.

Requisitos:

    Windows con PowerShell instalado.
    Permisos de administrador para ejecutar el script (especialmente para PowerLogon, que monitorea eventos de seguridad).

Anotaciones:

- Si estas en un ambiente donde las computadoras a auditar pertenecen a un dominio especifico, no vas a poder utilizar las opciones de "Errores en inicios de sesion" o "Cierres sesion" ya que esas se registran directamente al controlador de dominio. (Estos eventos deben ser habilitados para ser registrador por el domain controller mediante una GPO local, ver: https://learn.microsoft.com/en-us/previous-versions/windows/it-pro/windows-10/security/threat-protection/auditing/basic-audit-logon-events)
