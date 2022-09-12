<#
This script is to get an over view of storage drives to be inserted into BGInfo
#>
Get-PSDrive -name <#drive,letters#> | 
    Select-Object @{name="File Path";Expression="Root"},
    @{name='Used (GB)';expression={($_.used/1gb).tostring("#.##")}},
    @{name='Free (GB)';expression={($_.free/1gb).tostring("#.##")}},
    @{name='Size (GB)';expression={(($_.used+$_.free)/1gb).ToString('#.##')}} |
    Format-list |
    Out-File <#file\path.txt#>
