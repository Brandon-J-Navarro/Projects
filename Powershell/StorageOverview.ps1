Get-PSDrive -name <#driveleter#> | 
    Select-Object @{name="File Path";Expression="Root"},
    @{name='Used (GB)';expression={($_.used/1gb).tostring("#.##")}},
    @{name='Free (GB)';expression={($_.free/1gb).tostring("#.##")}},
    @{name='Size (GB)';expression={(($_.used+$_.free)/1gb).ToString('#.##')}} |
    Format-list |
    Out-File <#file\path.txt#>
