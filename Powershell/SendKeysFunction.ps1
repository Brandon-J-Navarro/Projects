#SAMEPLE CREDIT :
    #https://github.com/stefanstranger/PowerShell/blob/master/WinKeys.ps1
    
Add-Type -AssemblyName "System.Windows.Forms"

Function Get-keyControlC {
    [System.Windows.Forms.SendKeys]::SendWait("^C")
    [System.Windows.Forms.SendKeys]::Send("{ENTER}")
}

Function Get-KeyEnter {
    [System.Windows.Forms.SendKeys]::SendWait("{ENTER}")
}