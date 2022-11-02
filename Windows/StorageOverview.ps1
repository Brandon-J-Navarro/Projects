<#

Storage Overview Script
Version 1.0

This script is to get an overview of NAS storage drives to be inserted into BGInfo

☐ - uncomplete / testing
☑ - complete / tested
☒ - does not work / task scraped

Ideas
    ☑ - Get a overview of Used Space
    ☑ - Get a overview of Free Space
    ☑ - Get a overview of Total Space
    ☐ - Find a way to format storage less that 1TB to use GB and
        storage over 1TB to use TB
            ☐ - Separte jobs with different formats and outting those jobs into one file like
                the remote shutdown script does could fix that

#>

Get-PSDrive -name <#DRIVE,LETTERS#> | 
    Select-Object @{name="File Path";Expression="Root"},
    @{name='Used (GB)';expression={($_.used/1gb).tostring("#.##")}},
    @{name='Free (GB)';expression={($_.free/1gb).tostring("#.##")}},
    @{name='Size (GB)';expression={(($_.used+$_.free)/1gb).ToString('#.##')}} |
    Format-list | Out-File <#C:\FILE\PATH\TO\OUTPUT\FILE.txt#>
