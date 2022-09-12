<#

Remote shutdown script
Version 2.0

This new version uses RSA SSh Keys to connect to remote hosts

Once the uninterruptible power supply (UPS) starts the shutdown process, 
Task Scheduler will start this script based off the event ID that the UPS generates

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
    Get-PSDrive -name C,S | 
    Select-Object @{name="File Path";Expression="Root"},
    @{name='Used (GB)';expression={($_.used/1gb).tostring("#.##")}},
    @{name='Free (GB)';expression={($_.free/1gb).tostring("#.##")}},
    @{name='Size (GB)';expression={(($_.used+$_.free)/1gb).ToString('#.##')}} |
    Format-list 
    Stop-Computer
    }


Start-Sleep 60s

Receive-Job -name linux,hyperv,nas | Out-File C:\FILE\PATH\TO\OUTPUT\FILE.txt