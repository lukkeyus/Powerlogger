@echo off
echo # Verificar si se están ejecutando con privilegios de administrador >> %temp%\Powerlogger.ps1
echo $currentUser = [Security.Principal.WindowsIdentity]::GetCurrent() >> %temp%\Powerlogger.ps1
echo $principal = New-Object Security.Principal.WindowsPrincipal($currentUser) >> %temp%\Powerlogger.ps1
echo $isAdmin = $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator) >> %temp%\Powerlogger.ps1
echo. >> %temp%\Powerlogger.ps1
echo if (-not $isAdmin) { >> %temp%\Powerlogger.ps1
echo     # Reiniciar el script como administrador >> %temp%\Powerlogger.ps1
echo     Start-Process powershell.exe "-File `"$PSCommandPath`"" -Verb RunAs >> %temp%\Powerlogger.ps1
echo     exit >> %temp%\Powerlogger.ps1
echo } >> %temp%\Powerlogger.ps1
echo. >> %temp%\Powerlogger.ps1
echo # Cambiar la política de ejecución de scripts para permitir la ejecución de este script >> %temp%\Powerlogger.ps1
echo Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass >> %temp%\Powerlogger.ps1
echo. >> %temp%\Powerlogger.ps1
echo # Cambiar el estilo de fuente y color de fondo de la ventana de PowerShell >> %temp%\Powerlogger.ps1
echo function Set-ConsoleStyle { >> %temp%\Powerlogger.ps1
echo     $host.UI.RawUI.BackgroundColor = "Black"  # Cambia el color de fondo a negro >> %temp%\Powerlogger.ps1
echo     $host.UI.RawUI.ForegroundColor = "Green" # Cambia el color de texto a verde >> %temp%\Powerlogger.ps1
echo     $host.UI.RawUI.WindowTitle = "Mi ventana de PowerShell"  # Establece el título de la ventana >> %temp%\Powerlogger.ps1
echo. >> %temp%\Powerlogger.ps1
echo     $font = $host.UI.RawUI.Font >> %temp%\Powerlogger.ps1
echo     $fontFamily = "Consolas"  # Cambia la familia de la fuente >> %temp%\Powerlogger.ps1
echo     $fontSize = 16            # Cambia el tamaño de la fuente >> %temp%\Powerlogger.ps1
echo     $fontStyle = "Regular"    # Cambia el estilo de la fuente >> %temp%\Powerlogger.ps1
echo. >> %temp%\Powerlogger.ps1
echo     $font = New-Object System.Drawing.Font($fontFamily, $fontSize, $fontStyle) >> %temp%\Powerlogger.ps1
echo     $host.UI.RawUI.Font = $font >> %temp%\Powerlogger.ps1
echo } >> %temp%\Powerlogger.ps1
echo. >> %temp%\Powerlogger.ps1
echo # Llama a la función para establecer el estilo de la consola >> %temp%\Powerlogger.ps1
echo Set-ConsoleStyle >> %temp%\Powerlogger.ps1
echo. >> %temp%\Powerlogger.ps1
echo # Cambiar el tamaño de la ventana de PowerShell >> %temp%\Powerlogger.ps1
echo mode con: cols=55 lines=15 >> %temp%\Powerlogger.ps1
echo. >> %temp%\Powerlogger.ps1
echo # Funcion para mostrar el menu y obtener la opcion del usuario >> %temp%\Powerlogger.ps1
echo function Show-Menu { >> %temp%\Powerlogger.ps1
echo     Clear-Host >> %temp%\Powerlogger.ps1
echo     Write-Host "Selecciona una opcion:" >> %temp%\Powerlogger.ps1
echo     Write-Host "`n1 - Encendido (ID 1 y 6005)" >> %temp%\Powerlogger.ps1
echo     Write-Host "2 - Reinicio (ID 41 y 1074)" >> %temp%\Powerlogger.ps1
echo     Write-Host "3 - Apagado (ID 42, 6006 y 6008)" >> %temp%\Powerlogger.ps1
echo     Write-Host "4 - Todo (ID 1, 41, 42, 1074, 6005, 6006, 6008)" >> %temp%\Powerlogger.ps1
echo     Write-Host "5 - Abrir archivo de eventos guardado" >> %temp%\Powerlogger.ps1
echo     Write-Host "6 - Salir" >> %temp%\Powerlogger.ps1
echo     $option = Read-Host "`nIntroduce el numero de tu opcion" >> %temp%\Powerlogger.ps1
echo     return $option >> %temp%\Powerlogger.ps1
echo } >> %temp%\Powerlogger.ps1
echo. >> %temp%\Powerlogger.ps1
echo # Bucle para mantener el script en ejecucion >> %temp%\Powerlogger.ps1
echo while ($true) { >> %temp%\Powerlogger.ps1
echo     # Obtener la opcion del usuario >> %temp%\Powerlogger.ps1
echo     $option = Show-Menu >> %temp%\Powerlogger.ps1
echo. >> %temp%\Powerlogger.ps1
echo     # Salir si la opcion es 6 >> %temp%\Powerlogger.ps1
echo     if ($option -eq 6) { >> %temp%\Powerlogger.ps1
echo         Write-Host "Saliendo del script." >> %temp%\Powerlogger.ps1
echo         break >> %temp%\Powerlogger.ps1
echo     } >> %temp%\Powerlogger.ps1
echo. >> %temp%\Powerlogger.ps1
echo     # Definir los IDs de eventos segun la opcion seleccionada >> %temp%\Powerlogger.ps1
echo     switch ($option) { >> %temp%\Powerlogger.ps1
echo         1 { >> %temp%\Powerlogger.ps1
echo             $eventIDs1 = 1 >> %temp%\Powerlogger.ps1
echo             $eventIDs2 = 6005 >> %temp%\Powerlogger.ps1
echo             $filterBySource1 = $true >> %temp%\Powerlogger.ps1
echo             $sourceName1 = "Microsoft-Windows-Power-Troubleshooter" >> %temp%\Powerlogger.ps1
echo         } >> %temp%\Powerlogger.ps1
echo         2 { >> %temp%\Powerlogger.ps1
echo             $eventIDs = 41, 1074 >> %temp%\Powerlogger.ps1
echo             $filterBySource = $false >> %temp%\Powerlogger.ps1
echo         } >> %temp%\Powerlogger.ps1
echo         3 { >> %temp%\Powerlogger.ps1
echo             $eventIDs = 6006, 6008, 42 >> %temp%\Powerlogger.ps1
echo             $filterBySource = $false >> %temp%\Powerlogger.ps1
echo         } >> %temp%\Powerlogger.ps1
echo         4 { >> %temp%\Powerlogger.ps1
echo             $eventIDs1 = 1 >> %temp%\Powerlogger.ps1
echo             $sourceName1 = "Microsoft-Windows-Power-Troubleshooter" >> %temp%\Powerlogger.ps1
echo             $eventIDs2 = 41, 42, 1074, 6005, 6006, 6008 >> %temp%\Powerlogger.ps1
echo             $filterBySource1 = $true >> %temp%\Powerlogger.ps1
echo         } >> %temp%\Powerlogger.ps1
echo         5 { >> %temp%\Powerlogger.ps1
echo             $tempFolder = [System.IO.Path]::GetTempPath() >> %temp%\Powerlogger.ps1
echo             $outputFile = Join-Path -Path $tempFolder -ChildPath "eventos.txt" >> %temp%\Powerlogger.ps1
echo             if (Test-Path $outputFile) { >> %temp%\Powerlogger.ps1
echo                 Start-Process notepad.exe $outputFile >> %temp%\Powerlogger.ps1
echo                 Write-Host "Archivo de eventos abierto." >> %temp%\Powerlogger.ps1
echo             } else { >> %temp%\Powerlogger.ps1
echo                 Write-Host "No se encontro el archivo de eventos." >> %temp%\Powerlogger.ps1
echo             } >> %temp%\Powerlogger.ps1
echo             continue >> %temp%\Powerlogger.ps1
echo         } >> %temp%\Powerlogger.ps1
echo         default { >> %temp%\Powerlogger.ps1
echo             Write-Host "Opcion no valida. Por favor, selecciona una opcion del 1 al 6." >> %temp%\Powerlogger.ps1
echo             continue >> %temp%\Powerlogger.ps1
echo         } >> %temp%\Powerlogger.ps1
echo     } >> %temp%\Powerlogger.ps1
echo. >> %temp%\Powerlogger.ps1
echo     # Calcular la fecha de hace 30 dias >> %temp%\Powerlogger.ps1
echo     $startDate = (Get-Date).AddDays(-30) >> %temp%\Powerlogger.ps1
echo. >> %temp%\Powerlogger.ps1
echo     # Obtener eventos del Visor de Eventos de los ultimos 30 dias >> %temp%\Powerlogger.ps1
echo     Write-Host "Obteniendo eventos del Visor de Eventos..." >> %temp%\Powerlogger.ps1
echo     if ($option -eq 1) { >> %temp%\Powerlogger.ps1
echo         $events1 = Get-WinEvent -FilterHashtable @{LogName='System'; ID=$eventIDs1; StartTime=$startDate} ^| Where-Object { $_.ProviderName -eq $sourceName1 } >> %temp%\Powerlogger.ps1
echo         $events2 = Get-WinEvent -FilterHashtable @{LogName='System'; ID=$eventIDs2; StartTime=$startDate} >> %temp%\Powerlogger.ps1
echo         $events = $events1 + $events2 >> %temp%\Powerlogger.ps1
echo         Write-Host "Filtrando eventos con origen '$sourceName1' para ID 1 y cualquier origen para ID 6005..." >> %temp%\Powerlogger.ps1
echo     } elseif ($option -eq 4) { >> %temp%\Powerlogger.ps1
echo         $events1 = Get-WinEvent -FilterHashtable @{LogName='System'; ID=$eventIDs1; StartTime=$startDate} ^| Where-Object { $_.ProviderName -eq $sourceName1 } >> %temp%\Powerlogger.ps1
echo         $events2 = Get-WinEvent -FilterHashtable @{LogName='System'; ID=$eventIDs2; StartTime=$startDate} >> %temp%\Powerlogger.ps1
echo         $events = $events1 + $events2 >> %temp%\Powerlogger.ps1
echo     } else { >> %temp%\Powerlogger.ps1
echo         $events = Get-WinEvent -FilterHashtable @{LogName='System'; ID=$eventIDs; StartTime=$startDate} >> %temp%\Powerlogger.ps1
echo     } >> %temp%\Powerlogger.ps1
echo     $events = $events ^| Select-Object TimeCreated, Id, Message, ProviderName, LogName >> %temp%\Powerlogger.ps1
echo. >> %temp%\Powerlogger.ps1
echo     # Verificar si se encontraron eventos >> %temp%\Powerlogger.ps1
echo     if ($events.Count -eq 0) { >> %temp%\Powerlogger.ps1
echo         Write-Host "No se encontraron eventos para los criterios especificados." >> %temp%\Powerlogger.ps1
echo         continue >> %temp%\Powerlogger.ps1
echo     } >> %temp%\Powerlogger.ps1
echo. >> %temp%\Powerlogger.ps1
echo     # Obtener la ruta de la carpeta temporal del sistema >> %temp%\Powerlogger.ps1
echo     $tempFolder = [System.IO.Path]::GetTempPath() >> %temp%\Powerlogger.ps1
echo. >> %temp%\Powerlogger.ps1
echo     # Definir la ruta del archivo de salida en la carpeta temporal >> %temp%\Powerlogger.ps1
echo     $outputFile = Join-Path -Path $tempFolder -ChildPath "eventos.txt" >> %temp%\Powerlogger.ps1
echo. >> %temp%\Powerlogger.ps1
echo     # Borrar el contenido anterior del archivo >> %temp%\Powerlogger.ps1
echo     Clear-Content -Path $outputFile -Force >> %temp%\Powerlogger.ps1
echo. >> %temp%\Powerlogger.ps1
echo     # Escribir los eventos en el archivo con la fecha en formato DD/MM/YYYY >> %temp%\Powerlogger.ps1
echo     Write-Host "Escribiendo eventos en el archivo '$outputFile'..." >> %temp%\Powerlogger.ps1
echo     $events ^| ForEach-Object { >> %temp%\Powerlogger.ps1
echo         $formattedDate = $_.TimeCreated.ToString("dd/MM/yyyy HH:mm:ss") >> %temp%\Powerlogger.ps1
echo         Add-Content -Path $outputFile -Value "Fecha: $formattedDate" >> %temp%\Powerlogger.ps1
echo         Add-Content -Path $outputFile -Value "ID: $($_.Id)" >> %temp%\Powerlogger.ps1
echo         Add-Content -Path $outputFile -Value "Proveedor: $($_.ProviderName)" >> %temp%\Powerlogger.ps1
echo         Add-Content -Path $outputFile -Value "Categoria: $($_.LogName)" >> %temp%\Powerlogger.ps1
echo         Add-Content -Path $outputFile -Value "Descripcion: $($_.Message)" >> %temp%\Powerlogger.ps1
echo         Add-Content -Path $outputFile -Value "------------------------" >> %temp%\Powerlogger.ps1
echo     } >> %temp%\Powerlogger.ps1
echo. >> %temp%\Powerlogger.ps1
echo     # Abrir el archivo con el Bloc de notas solo si la opcion no es 5 o 6 >> %temp%\Powerlogger.ps1
echo     if ($option -ne 5 -and $option -ne 6) { >> %temp%\Powerlogger.ps1
echo         $notepadProcess = Start-Process notepad.exe $outputFile -PassThru >> %temp%\Powerlogger.ps1
echo. >> %temp%\Powerlogger.ps1
echo         # Esperar a que el Bloc de notas se cierre >> %temp%\Powerlogger.ps1
echo         $notepadProcess.WaitForExit() >> %temp%\Powerlogger.ps1
echo. >> %temp%\Powerlogger.ps1
echo         Write-Output "Los eventos han sido guardados en $outputFile, el archivo ha sido abierto con el Bloc de notas." >> %temp%\Powerlogger.ps1
echo     } >> %temp%\Powerlogger.ps1
echo } >> %temp%\Powerlogger.ps1
echo. >> %temp%\Powerlogger.ps1
echo # Restaurar la política de ejecución de scripts a su valor original >> %temp%\Powerlogger.ps1
echo Set-ExecutionPolicy -Scope Process -ExecutionPolicy Restricted >> %temp%\Powerlogger.ps1
echo. >> %temp%\Powerlogger.ps1
echo Write-Output "El script ha finalizado." >> %temp%\Powerlogger.ps1

:: Ejecutar el script PowerShell
powershell.exe -ExecutionPolicy Bypass -File "%temp%\Powerlogger.ps1"

:: Esperar a que el script PowerShell termine y luego eliminarlo
del "%temp%\Powerlogger.ps1"