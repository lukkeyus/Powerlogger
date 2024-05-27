@echo off
echo # Verificar si se están ejecutando con privilegios de administrador >> %temp%\Powerlogon.ps1
echo $currentUser = [Security.Principal.WindowsIdentity]::GetCurrent() >> %temp%\Powerlogon.ps1
echo $principal = New-Object Security.Principal.WindowsPrincipal($currentUser) >> %temp%\Powerlogon.ps1
echo $isAdmin = $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator) >> %temp%\Powerlogon.ps1

echo if (-not $isAdmin) { >> %temp%\Powerlogon.ps1
echo     # Reiniciar el script como administrador >> %temp%\Powerlogon.ps1
echo     Start-Process powershell.exe "-File `"$PSCommandPath`"" -Verb RunAs >> %temp%\Powerlogon.ps1
echo     exit >> %temp%\Powerlogon.ps1
echo } >> %temp%\Powerlogon.ps1

echo # Cambiar la política de ejecución de scripts para permitir la ejecución de este script >> %temp%\Powerlogon.ps1
echo Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass >> %temp%\Powerlogon.ps1

echo # Cambiar el estilo de fuente y color de fondo de la ventana de PowerShell >> %temp%\Powerlogon.ps1
echo function Set-ConsoleStyle { >> %temp%\Powerlogon.ps1
echo     $host.UI.RawUI.BackgroundColor = "Black"  # Cambia el color de fondo a negro >> %temp%\Powerlogon.ps1
echo     $host.UI.RawUI.ForegroundColor = "Green" # Cambia el color de texto a verde >> %temp%\Powerlogon.ps1
echo     $host.UI.RawUI.WindowTitle = "Mi ventana de PowerShell"  # Establece el título de la ventana >> %temp%\Powerlogon.ps1

echo     $font = $host.UI.RawUI.Font >> %temp%\Powerlogon.ps1
echo     $fontFamily = "Consolas"  # Cambia la familia de la fuente >> %temp%\Powerlogon.ps1
echo     $fontSize = 16            # Cambia el tamaño de la fuente >> %temp%\Powerlogon.ps1
echo     $fontStyle = "Regular"    # Cambia el estilo de la fuente >> %temp%\Powerlogon.ps1

echo     $font = New-Object System.Drawing.Font($fontFamily, $fontSize, $fontStyle) >> %temp%\Powerlogon.ps1
echo     $host.UI.RawUI.Font = $font >> %temp%\Powerlogon.ps1
echo } >> %temp%\Powerlogon.ps1

echo # Llama a la función para establecer el estilo de la consola >> %temp%\Powerlogon.ps1
echo Set-ConsoleStyle >> %temp%\Powerlogon.ps1

echo # Cambiar el tamaño de la ventana de PowerShell >> %temp%\Powerlogon.ps1
echo mode con: cols=55 lines=20 >> %temp%\Powerlogon.ps1

echo # Funcion para mostrar el menu y obtener la opcion del usuario >> %temp%\Powerlogon.ps1
echo function Show-Menu { >> %temp%\Powerlogon.ps1
echo     Clear-Host >> %temp%\Powerlogon.ps1
echo     Write-Host "Selecciona una opcion:" >> %temp%\Powerlogon.ps1
echo     Write-Host "`n1 - Encendido (ID 1 y 6005)" >> %temp%\Powerlogon.ps1
echo     Write-Host "2 - Reinicio (ID 41 y 1074)" >> %temp%\Powerlogon.ps1
echo     Write-Host "3 - Apagado (ID 42, 6006 y 6008)" >> %temp%\Powerlogon.ps1
echo     Write-Host "4 - Todo (ID 1, 41, 42, 1074, 6005, 6006, 6008)" >> %temp%\Powerlogon.ps1
echo     Write-Host "5 - Inicios de sesion exitosos (ID 4624)" >> %temp%\Powerlogon.ps1
echo     Write-Host "6 - Errores de inicio de sesion (ID 4625)" >> %temp%\Powerlogon.ps1
echo     Write-Host "7 - Otros inicios de sesion (ID 4648 y 4672)" >> %temp%\Powerlogon.ps1
echo     Write-Host "8 - Cierres de sesion (ID 4634)" >> %temp%\Powerlogon.ps1
echo     Write-Host "9 - Abrir archivo de eventos guardado" >> %temp%\Powerlogon.ps1
echo     Write-Host "10 - Salir" >> %temp%\Powerlogon.ps1
echo     $option = Read-Host "`nIntroduce el numero de tu opcion" >> %temp%\Powerlogon.ps1
echo     return $option >> %temp%\Powerlogon.ps1
echo } >> %temp%\Powerlogon.ps1

echo # Bucle para mantener el script en ejecucion >> %temp%\Powerlogon.ps1
echo while ($true) { >> %temp%\Powerlogon.ps1
echo     # Obtener la opcion del usuario >> %temp%\Powerlogon.ps1
echo     $option = Show-Menu >> %temp%\Powerlogon.ps1

echo     # Salir si la opcion es 10 >> %temp%\Powerlogon.ps1
echo     if ($option -eq 10) { >> %temp%\Powerlogon.ps1
echo         Write-Host "Saliendo del script." >> %temp%\Powerlogon.ps1
echo         break >> %temp%\Powerlogon.ps1
echo     } >> %temp%\Powerlogon.ps1

echo     # Definir los IDs de eventos segun la opcion seleccionada >> %temp%\Powerlogon.ps1
echo     switch ($option) { >> %temp%\Powerlogon.ps1
echo         1 { >> %temp%\Powerlogon.ps1
echo             $eventIDs1 = 1 >> %temp%\Powerlogon.ps1
echo             $eventIDs2 = 6005 >> %temp%\Powerlogon.ps1
echo             $filterBySource1 = $true >> %temp%\Powerlogon.ps1
echo             $sourceName1 = "Microsoft-Windows-Power-Troubleshooter" >> %temp%\Powerlogon.ps1
echo         } >> %temp%\Powerlogon.ps1
echo         2 { >> %temp%\Powerlogon.ps1
echo             $eventIDs = 41, 1074 >> %temp%\Powerlogon.ps1
echo             $filterBySource = $false >> %temp%\Powerlogon.ps1
echo         } >> %temp%\Powerlogon.ps1
echo         3 { >> %temp%\Powerlogon.ps1
echo             $eventIDs = 6006, 6008, 42 >> %temp%\Powerlogon.ps1
echo             $filterBySource = $false >> %temp%\Powerlogon.ps1
echo         } >> %temp%\Powerlogon.ps1
echo         4 { >> %temp%\Powerlogon.ps1
echo             $eventIDs1 = 1 >> %temp%\Powerlogon.ps1
echo             $sourceName1 = "Microsoft-Windows-Power-Troubleshooter" >> %temp%\Powerlogon.ps1
echo             $eventIDs2 = 41, 42, 1074, 6005, 6006, 6008 >> %temp%\Powerlogon.ps1
echo             $filterBySource1 = $true >> %temp%\Powerlogon.ps1
echo         } >> %temp%\Powerlogon.ps1
echo         5 { >> %temp%\Powerlogon.ps1
echo             $eventIDs = 4624 >> %temp%\Powerlogon.ps1
echo             $filterBySource = $false >> %temp%\Powerlogon.ps1
echo         } >> %temp%\Powerlogon.ps1
echo         6 { >> %temp%\Powerlogon.ps1
echo             $eventIDs = 4625 >> %temp%\Powerlogon.ps1
echo             $filterBySource = $false >> %temp%\Powerlogon.ps1
echo         } >> %temp%\Powerlogon.ps1
echo         7 { >> %temp%\Powerlogon.ps1
echo             $eventIDs = 4648, 4672 >> %temp%\Powerlogon.ps1
echo             $filterBySource = $false >> %temp%\Powerlogon.ps1
echo         } >> %temp%\Powerlogon.ps1
echo         8 { >> %temp%\Powerlogon.ps1
echo             $eventIDs = 4634 >> %temp%\Powerlogon.ps1
echo             $filterBySource = $false >> %temp%\Powerlogon.ps1
echo         } >> %temp%\Powerlogon.ps1
echo         9 { >> %temp%\Powerlogon.ps1
echo             $tempFolder = [System.IO.Path]::GetTempPath() >> %temp%\Powerlogon.ps1
echo             $outputFile = Join-Path -Path $tempFolder -ChildPath "eventos.txt" >> %temp%\Powerlogon.ps1
echo             if (Test-Path $outputFile) { >> %temp%\Powerlogon.ps1
echo                 Start-Process notepad.exe $outputFile >> %temp%\Powerlogon.ps1
echo                 Write-Host "Archivo de eventos abierto." >> %temp%\Powerlogon.ps1
echo             } else { >> %temp%\Powerlogon.ps1
echo                 Write-Host "No se encontro el archivo de eventos." >> %temp%\Powerlogon.ps1
echo             } >> %temp%\Powerlogon.ps1
echo             continue >> %temp%\Powerlogon.ps1
echo         } >> %temp%\Powerlogon.ps1
echo         default { >> %temp%\Powerlogon.ps1
echo             Write-Host "Opcion no valida. Por favor, selecciona una opcion del 1 al 10." >> %temp%\Powerlogon.ps1
echo             continue >> %temp%\Powerlogon.ps1
echo         } >> %temp%\Powerlogon.ps1
echo     } >> %temp%\Powerlogon.ps1

echo     # Calcular la fecha de hace 30 dias >> %temp%\Powerlogon.ps1
echo     $startDate = (Get-Date).AddDays(-30) >> %temp%\Powerlogon.ps1

echo     # Obtener eventos del Visor de Eventos de los ultimos 30 dias >> %temp%\Powerlogon.ps1
echo     Write-Host "Obteniendo eventos del Visor de Eventos..." >> %temp%\Powerlogon.ps1
echo     if ($option -eq 1) { >> %temp%\Powerlogon.ps1
echo         $events1 = Get-WinEvent -FilterHashtable @{LogName='System'; ID=$eventIDs1; StartTime=$startDate} ^| Where-Object { $_.ProviderName -eq $sourceName1 } >> %temp%\Powerlogon.ps1
echo         $events2 = Get-WinEvent -FilterHashtable @{LogName='System'; ID=$eventIDs2; StartTime=$startDate} >> %temp%\Powerlogon.ps1
echo         $events = $events1 + $events2 >> %temp%\Powerlogon.ps1
echo         Write-Host "Filtrando eventos con origen '$sourceName1' para ID 1 y cualquier origen para ID 6005..." >> %temp%\Powerlogon.ps1
echo     } elseif ($option -eq 4) { >> %temp%\Powerlogon.ps1
echo         $events1 = Get-WinEvent -FilterHashtable @{LogName='System'; ID=$eventIDs1; StartTime=$startDate} ^| Where-Object { $_.ProviderName -eq $sourceName1 } >> %temp%\Powerlogon.ps1
echo         $events2 = Get-WinEvent -FilterHashtable @{LogName='System'; ID=$eventIDs2; StartTime=$startDate} >> %temp%\Powerlogon.ps1
echo         $events = $events1 + $events2 >> %temp%\Powerlogon.ps1
echo     } elseif ($option -eq 5 -or $option -eq 6 -or $option -eq 7) { >> %temp%\Powerlogon.ps1
echo         $events = Get-WinEvent -FilterHashtable @{LogName='Security'; ID=$eventIDs; StartTime=$startDate} >> %temp%\Powerlogon.ps1
echo     } else { >> %temp%\Powerlogon.ps1
echo         $events = Get-WinEvent -FilterHashtable @{LogName='System'; ID=$eventIDs; StartTime=$startDate} >> %temp%\Powerlogon.ps1
echo     } >> %temp%\Powerlogon.ps1
echo     $events = $events ^| Select-Object TimeCreated, Id, Message, ProviderName, LogName >> %temp%\Powerlogon.ps1

echo     # Verificar si se encontraron eventos >> %temp%\Powerlogon.ps1
echo     if ($events.Count -eq 0) { >> %temp%\Powerlogon.ps1
echo         Write-Host "No se encontraron eventos para los criterios especificados." >> %temp%\Powerlogon.ps1
echo         continue >> %temp%\Powerlogon.ps1
echo     } >> %temp%\Powerlogon.ps1

echo     # Obtener la ruta de la carpeta temporal del sistema >> %temp%\Powerlogon.ps1
echo     $tempFolder = [System.IO.Path]::GetTempPath() >> %temp%\Powerlogon.ps1

echo     # Definir la ruta del archivo de salida >> %temp%\Powerlogon.ps1
echo     $outputFile = Join-Path -Path $tempFolder -ChildPath "eventos.txt" >> %temp%\Powerlogon.ps1
echo     # Borrar el contenido anterior del archivo >> %temp%\Powerlogon.ps1
echo     Clear-Content -Path $outputFile -Force >> %temp%\Powerlogon.ps1

echo     # Escribir los eventos en el archivo con la fecha en formato DD/MM/YYYY >> %temp%\Powerlogon.ps1
echo     Write-Host "Escribiendo eventos en el archivo '$outputFile'..." >> %temp%\Powerlogon.ps1
echo     $events ^| ForEach-Object { >> %temp%\Powerlogon.ps1
echo         $formattedDate = $_.TimeCreated.ToString("dd/MM/yyyy HH:mm:ss") >> %temp%\Powerlogon.ps1
echo         $shortMessage = $_.Message.Substring(0, [Math]::Min($_.Message.Length, 200))  # Acorta el mensaje a los primeros 200 caracteres >> %temp%\Powerlogon.ps1
echo         Add-Content -Path $outputFile -Value "Fecha: $formattedDate" >> %temp%\Powerlogon.ps1
echo         Add-Content -Path $outputFile -Value "ID: $($_.Id)" >> %temp%\Powerlogon.ps1
echo         Add-Content -Path $outputFile -Value "Proveedor: $($_.ProviderName)" >> %temp%\Powerlogon.ps1
echo         Add-Content -Path $outputFile -Value "Categoria: $($_.LogName)" >> %temp%\Powerlogon.ps1
echo         Add-Content -Path $outputFile -Value "Descripcion: $shortMessage"  # Usa el mensaje acortado >> %temp%\Powerlogon.ps1
echo         Add-Content -Path $outputFile -Value "------------------------" >> %temp%\Powerlogon.ps1
echo     } >> %temp%\Powerlogon.ps1

echo     # Abrir el archivo con el Bloc de notas solo si la opcion no es 9 o 10 >> %temp%\Powerlogon.ps1
echo     if ($option -ne 9 -and $option -ne 10) { >> %temp%\Powerlogon.ps1
echo         $notepadProcess = Start-Process notepad.exe $outputFile -PassThru >> %temp%\Powerlogon.ps1

echo         # Esperar a que el Bloc de notas se cierre >> %temp%\Powerlogon.ps1
echo         $notepadProcess.WaitForExit() >> %temp%\Powerlogon.ps1

echo         Write-Output "Los eventos han sido guardados en $outputFile, el archivo ha sido abierto con el Bloc de notas." >> %temp%\Powerlogon.ps1
echo     } >> %temp%\Powerlogon.ps1
echo } >> %temp%\Powerlogon.ps1

echo # Restaurar la política de ejecución de scripts a su valor original >> %temp%\Powerlogon.ps1
echo Set-ExecutionPolicy -Scope Process -ExecutionPolicy Restricted >> %temp%\Powerlogon.ps1

echo Write-Output "El script ha finalizado." >> %temp%\Powerlogon.ps1

powershell.exe -ExecutionPolicy Bypass -File "%temp%\Powerlogon.ps1"
del %temp%\Powerlogon_creator.ps1
