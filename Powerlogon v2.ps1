# Verificar si se están ejecutando con privilegios de administrador
$currentUser = [Security.Principal.WindowsIdentity]::GetCurrent()
$principal = New-Object Security.Principal.WindowsPrincipal($currentUser)
$isAdmin = $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

if (-not $isAdmin) {
    # Reiniciar el script como administrador
    Start-Process powershell.exe "-File `"$PSCommandPath`"" -Verb RunAs
    exit
}

# Cambiar el estilo de fuente y color de fondo de la ventana de PowerShell
function Set-ConsoleStyle {
    $host.UI.RawUI.BackgroundColor = "Black"  # Cambia el color de fondo a negro
    $host.UI.RawUI.ForegroundColor = "Green" # Cambia el color de texto a verde
    $host.UI.RawUI.WindowTitle = "Mi ventana de PowerShell"  # Establece el título de la ventana

    $font = $host.UI.RawUI.Font
    $fontFamily = "Consolas"  # Cambia la familia de la fuente
    $fontSize = 16            # Cambia el tamaño de la fuente
    $fontStyle = "Regular"    # Cambia el estilo de la fuente

    $font = New-Object System.Drawing.Font($fontFamily, $fontSize, $fontStyle)
    $host.UI.RawUI.Font = $font
}

# Llama a la función para establecer el estilo de la consola
Set-ConsoleStyle


# Cambiar el tamaño de la ventana de PowerShell
mode con: cols=55 lines=20

# Funcion para mostrar el menu y obtener la opcion del usuario
function Show-Menu {
    Clear-Host
    Write-Host "Selecciona una opcion:"
    Write-Host "`n1 - Encendido (ID 1 y 6005)"
    Write-Host "2 - Reinicio (ID 41 y 1074)"
    Write-Host "3 - Apagado (ID 42, 6006 y 6008)"
    Write-Host "4 - Todo (ID 1, 41, 42, 1074, 6005, 6006, 6008)"
    Write-Host "5 - Inicios de sesion exitosos (ID 4624)"
    Write-Host "6 - Errores de inicio de sesion (ID 4625)"
    Write-Host "7 - Otros inicios de sesion (ID 4648 y 4672)"
    Write-Host "8 - Cierres de sesion (ID 4634)"
    Write-Host "9 - Abrir archivo de eventos guardado"
    Write-Host "10 - Salir"
    $option = Read-Host "`nIntroduce el numero de tu opcion"
    return $option
}

# Bucle para mantener el script en ejecucion
while ($true) {
    # Obtener la opcion del usuario
    $option = Show-Menu

    # Salir si la opcion es 10
    if ($option -eq 10) {
        Write-Host "Saliendo del script."
        break
    }

    # Definir los IDs de eventos segun la opcion seleccionada
    switch ($option) {
        1 {
            $eventIDs1 = 1
            $eventIDs2 = 6005
            $filterBySource1 = $true
            $sourceName1 = "Microsoft-Windows-Power-Troubleshooter"
        }
        2 {
            $eventIDs = 41, 1074
            $filterBySource = $false
        }
        3 {
            $eventIDs = 6006, 6008, 42
            $filterBySource = $false
        }
        4 {
            $eventIDs1 = 1
            $sourceName1 = "Microsoft-Windows-Power-Troubleshooter"
            $eventIDs2 = 41, 42, 1074, 6005, 6006, 6008
            $filterBySource1 = $true
        }
        5 {
            $eventIDs = 4624
            $filterBySource = $false
        }
        6 {
            $eventIDs = 4625
            $filterBySource = $false
        }
        7 {
            $eventIDs = 4648, 4672
            $filterBySource = $false
        }
        8 {
            $eventIDs = 4634
            $filterBySource = $false
        }
        9 {
            $tempFolder = [System.IO.Path]::GetTempPath()
            $outputFile = Join-Path -Path $tempFolder -ChildPath "eventos.txt"
            if (Test-Path $outputFile) {
                Start-Process notepad.exe $outputFile
                Write-Host "Archivo de eventos abierto."
            } else {
                Write-Host "No se encontro el archivo de eventos."
            }
            continue
        }
        default {
            Write-Host "Opcion no valida. Por favor, selecciona una opcion del 1 al 10."
            continue
        }
    }

    # Calcular la fecha de hace 30 dias
    $startDate = (Get-Date).AddDays(-30)

    # Obtener eventos del Visor de Eventos de los ultimos 30 dias
    Write-Host "Obteniendo eventos del Visor de Eventos..."
    if ($option -eq 1) {
        $events1 = Get-WinEvent -FilterHashtable @{LogName='System'; ID=$eventIDs1; StartTime=$startDate} | Where-Object { $_.ProviderName -eq $sourceName1 }
        $events2 = Get-WinEvent -FilterHashtable @{LogName='System'; ID=$eventIDs2; StartTime=$startDate}
        $events = $events1 + $events2
        Write-Host "Filtrando eventos con origen '$sourceName1' para ID 1 y cualquier origen para ID 6005..."
    } elseif ($option -eq 4) {
        $events1 = Get-WinEvent -FilterHashtable @{LogName='System'; ID=$eventIDs1; StartTime=$startDate} | Where-Object { $_.ProviderName -eq $sourceName1 }
        $events2 = Get-WinEvent -FilterHashtable @{LogName='System'; ID=$eventIDs2; StartTime=$startDate}
        $events = $events1 + $events2
    } elseif ($option -eq 5 -or $option -eq 6 -or $option -eq 7) {
        $events = Get-WinEvent -FilterHashtable @{LogName='Security'; ID=$eventIDs; StartTime=$startDate}
    } else {
        $events = Get-WinEvent -FilterHashtable @{LogName='System'; ID=$eventIDs; StartTime=$startDate}
    }
    $events = $events | Select-Object TimeCreated, Id, Message, ProviderName, LogName

    # Verificar si se encontraron eventos
    if ($events.Count -eq 0) {
        Write-Host "No se encontraron eventos para los criterios especificados."
        continue
    }

    # Obtener la ruta de la carpeta temporal del sistema
    $tempFolder = [System.IO.Path]::GetTempPath()

    # Definir la ruta del archivo de salida en la carpeta temporal
    $outputFile = Join-Path -Path $tempFolder -ChildPath "eventos.txt"

    # Borrar el contenido anterior del archivo
    Clear-Content -Path $outputFile -Force

    # Escribir los eventos en el archivo con la fecha en formato DD/MM/YYYY
    Write-Host "Escribiendo eventos en el archivo '$outputFile'..."
    $events | ForEach-Object {
        $formattedDate = $_.TimeCreated.ToString("dd/MM/yyyy HH:mm:ss")
        $shortMessage = $_.Message.Substring(0, [Math]::Min($_.Message.Length, 200))  # Acorta el mensaje a los primeros 200 caracteres
        Add-Content -Path $outputFile -Value "Fecha: $formattedDate"
        Add-Content -Path $outputFile -Value "ID: $($_.Id)"
        Add-Content -Path $outputFile -Value "Proveedor: $($_.ProviderName)"
        Add-Content -Path $outputFile -Value "Categoria: $($_.LogName)"
        Add-Content -Path $outputFile -Value "Descripcion: $shortMessage"  # Usa el mensaje acortado
        Add-Content -Path $outputFile -Value "------------------------"
    }

    # Abrir el archivo con el Bloc de notas solo si la opcion no es 9 o 10
    if ($option -ne 9 -and $option -ne 10) {
        $notepadProcess = Start-Process notepad.exe $outputFile -PassThru

        # Esperar a que el Bloc de notas se cierre
        $notepadProcess.WaitForExit()

        Write-Output "Los eventos han sido guardados en $outputFile, el archivo ha sido abierto con el Bloc de notas."
    }
}

Write-Output "El script ha finalizado."
