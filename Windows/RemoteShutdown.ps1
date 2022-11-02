<#

Remote shutdown script
Version 2.0

**NOTE**    This script is for in the even of a power outage my UPS
            Hosts will get shutdown gracefully
            UPS can only shutdown one host via USB
            This script will allow the other hosts to be shut down as well 
            Based off the Event ID the UPS Generates

☐ - uncomplete / testing
☑ - complete / tested
☒ - does not work / task scraped 

V2.0 Rework Ideas
    ☑ - Get Host Names and Date and time so I can track the outage 
    ☑ - Use RSA SSH Keys to connect to remote hosts
    ☐ - Docker Host
        ☐ - Shutdown Docker Containers
        ☐ - Shutdown Docker Host once Containers have stopped
    ☐ - Hyper-V Host
        ☐ - Shutdown Hyper-V VMs
        ☐ - Shutdown Hyper-V Host once VMs have shutdown
    ☑ - NAS
        ☑ - Get a overview of NAS Storage

    ☐ - Reverify uninterruptible power supply (UPS) starts the shutdown process, 
        (Need to revalidate now that more that more than one host is being shutdown,
        changed to RSA keys and there is enough time now that containers and VMs are being stopped as well)
        ☐ - Task Scheduler will start this script based off the event ID that the UPS generates

#>

$linux = New-PSSession -HostName <#IP ADDRESS#> -UserName <#USERNAME#> -KeyFilePath 'C:\FILE\PATH\TO\RSA\FILE'

$hyperv = New-PSSession -HostName <#IP ADDRESS#> -UserName <#USERNAME#> -KeyFilePath 'C:\FILE\PATH\TO\RSA\FILE'

$nas = New-PSSession -HostName <#IP ADDRESS#> -UserName <#USERNAME#> -KeyFilePath 'C:\FILE\PATH\TO\RSA\FILE'

Invoke-Command -Session $linux -AsJob -JobName linux -ScriptBlock {
    Get-Date
    hostname
    docker ps -a --format "table {{.Names}}"
    docker container stop $(docker container list -q)
    Start-Sleep 60s
    docker ps -a --format "table {{.Names}}"
    Stop-Computer
    }

Invoke-Command -Session $hyperv -AsJob -JobName hyperv -ScriptBlock {
    Get-Date
    hostname
    Get-VM | Where-Object State -eq running | Stop-VM
    Start-Sleep 60s
    Get-VM | Where-Object State -eq running | Select-Object vmname
    Stop-Computer
    }

Invoke-Command -Session $nas -AsJob -JobName nas -ScriptBlock {
    Get-Date
    hostname
    Get-PSDrive -name <#DRIVE,LETTERS#> | 
    Select-Object @{name="File Path";Expression="Root"},
    @{name='Used (GB)';expression={($_.used/1gb).tostring("#.##")}},
    @{name='Free (GB)';expression={($_.free/1gb).tostring("#.##")}},
    @{name='Size (GB)';expression={(($_.used+$_.free)/1gb).ToString('#.##')}} |
    Format-list 
    Stop-Computer
    }


Start-Sleep 120s

Receive-Job -name linux,hyperv,nas | Out-File <#C:\FILE\PATH\TO\OUTPUT\FILE.txt#>