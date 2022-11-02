#Sample Credit :
    #SOURCES :
        #https://github.com/mmillar-bolis/SystemSplash
        #https://community.spiceworks.com/topic/664020-maximize-an-open-window-with-powershell-win7
        #https://adamtheautomator.com/powershell-menu/
        #https://social.technet.microsoft.com/wiki/contents/articles/18697.an-example-of-using-write-progress-in-a-long-running-sharepoint-powershell-script.aspx
        

#****************************************************REMOTE CONNECTIONS****************************************************
Function Connect-Pi {
    ssh USERNAME@IPADDRESS -i C:\FILE\PATH\id_rsa
}

Function Connect-Docker {
    ssh USERNAME@IPADDRESS -i C:\FILE\PATH\id_rsa
}

Function Connect-Hyperv {
        Enter-PSSession -HostName IPADDRESS -UserName USERNAME -KeyFilePath C:\FILE\PATH\id_rsa
}

Function Connect-Nas {
        Enter-PSSession -HostName IPADDRESS -UserName USERNAME -KeyFilePath C:\FILE\PATH\id_rsa
}
#****************************************************REMOTE CONNECTIONS****************************************************

#****************************************************KEY FUNCTIONS****************************************************
Add-Type -AssemblyName "System.Windows.Forms"

Function Get-keyControlC {
    [System.Windows.Forms.SendKeys]::SendWait("^C")
    [System.Windows.Forms.SendKeys]::Send("{ENTER}")
}

Function Get-KeyEnter {
    [System.Windows.Forms.SendKeys]::SendWait("{ENTER}")
}
#****************************************************KEY FUNCTIONS****************************************************

#****************************************************Get-SystemSplash CHECK FUNCTION****************************************************
#SAMPLE CREDIT mmillar-bolis
#https://github.com/mmillar-bolis/SystemSplash
if (Get-Command -ListImported -Name Get-SystemSplash) {
    Write-Host "Functions Check Passed"
    Start-Sleep 1s
    Write-Host "Exiting PreCheck"
    #Clear-Host
} else {
    Write-Host "Functions Check Failed"
    Write-Host "Continue to install dependencies"
    Install-Module -Name SystemSplash -Repository PSGallery -Scope CurrentUser -Confirm
    Start-Sleep 3s
    #Clear-Host
}  
#****************************************************Get-SystemSplash FUNCTION****************************************************


#****************************************************APPLICATION WINDOW FUNCTION****************************************************
#SAMPLE CREDIT bobmccoy
#https://community.spiceworks.com/topic/664020-maximize-an-open-window-with-powershell-win7
function Set-WindowStyle {
param(
    [Parameter()]
    [ValidateSet('FORCEMINIMIZE', 'HIDE', 'MAXIMIZE', 'MINIMIZE', 'RESTORE', 
                    'SHOW', 'SHOWDEFAULT', 'SHOWMAXIMIZED', 'SHOWMINIMIZED', 
                    'SHOWMINNOACTIVE', 'SHOWNA', 'SHOWNOACTIVATE', 'SHOWNORMAL')]
    $Style = 'SHOW',
    [Parameter()]
    $MainWindowHandle = (Get-Process -Id $pid).MainWindowHandle
)
    $WindowStates = @{
        FORCEMINIMIZE   = 11; HIDE            = 0
        MAXIMIZE        = 3;  MINIMIZE        = 6
        RESTORE         = 9;  SHOW            = 5
        SHOWDEFAULT     = 10; SHOWMAXIMIZED   = 3
        SHOWMINIMIZED   = 2;  SHOWMINNOACTIVE = 7
        SHOWNA          = 8;  SHOWNOACTIVATE  = 4
        SHOWNORMAL      = 1
    }
    Write-Verbose ("Set Window Style {1} on handle {0}" -f $MainWindowHandle, $($WindowStates[$style]))

    $Win32ShowWindowAsync = Add-Type –memberDefinition @” 
    [DllImport("user32.dll")] 
    public static extern bool ShowWindowAsync(IntPtr hWnd, int nCmdShow);
“@ -name “Win32ShowWindowAsync” -namespace Win32Functions –passThru

    $Win32ShowWindowAsync::ShowWindowAsync($MainWindowHandle, $WindowStates[$Style]) | Out-Null
}
#****************************************************APPLICATION WINDOW FUNCTION****************************************************


#****************************************************Start-Work FUNCTION****************************************************
function Start-Work {
#Progress Bar Sample Credit 
#https://social.technet.microsoft.com/wiki/contents/articles/18697.an-example-of-using-write-progress-in-a-long-running-sharepoint-powershell-script.aspx

#The progress bar, is going to display the overall status of the function, which has four stages (steps), which are: 1. "Opening Chrome", 2. "Opening Outlook", 3. "Opening Teams", and finally, 4. "Opening OneNote"
$ProgressBarId = 0;
$numberOfActions = 4;

#Set the percentage of the first progress bar to 0%
Write-Progress -Id $ProgressBarId -Activity "Starting Work Enviorment" -PercentComplete (1)
Start-Sleep 5s

#Set the percentage of the first progress bar to 20% (calculated from (1/$numberOfActions *100), which is effectively 1/4*100)
Write-Progress -Id $ProgressBarId -Activity "Opening Chrome" -PercentComplete (1/$numberOfActions *100) -Status "Opening URL, and URL";
Start-Process -FilePath "C:\FILE\PATH\chrome.exe" -ArgumentList  "URL","URL"
Start-Sleep 1s
#(Get-Process -Name chrome).MainWindowHandle | ForEach-Object { Set-WindowStyle MAXIMIZE $_ }
(Get-Process -Name chrome).MainWindowHandle | ForEach-Object { Set-WindowStyle MINIMIZE $_ }
Start-Sleep 9s

#Set the percentage of the first progress bar to 20% (calculated from (1/$numberOfActions *100), which is effectively 1/4*100)
Write-Progress -Id $ProgressBarId -Activity "Opening Outlook" -PercentComplete (2/$numberOfActions *100) -Status "Loading Email";
Start-Process -FilePath "C:\FILE\PATH\OUTLOOK.EXE"
Start-Sleep 2s
#(Get-Process -Name OUTLOOK).MainWindowHandle | ForEach-Object { Set-WindowStyle MAXIMIZE $_ }
(Get-Process -Name OUTLOOK).MainWindowHandle | ForEach-Object { Set-WindowStyle MINIMIZE $_ }
Start-Sleep 8s

#Set the percentage of the first progress bar to 40% (calculated from (2/$numberOfActions *100), which is effectily 2/4*100)            
Write-Progress -Id $ProgressBarId -Activity "Opening Teams" -PercentComplete (3/$numberOfActions *100) -Status "Connecting to Teams";
start-process -FilePath "C:\FILE\PATH\Update.exe" -WorkingDirectory "C:\FILE\PATH\Teams" -WindowStyle Minimized -ArgumentList "--processStart  Teams.exe"
Start-Sleep 10s
#(Get-Process -Name Teams).MainWindowHandle | ForEach-Object { Set-WindowStyle MAXIMIZE $_ }
(Get-Process -Name Teams).MainWindowHandle | ForEach-Object { Set-WindowStyle MINIMIZE $_ }


#Set the percentage of the first progress bar to 60% (calculated from (3/$numberOfActions *100), which is effectively 3/4*100)
Write-Progress -Id $ProgressBarId -Activity "Open OneNote" -PercentComplete (3/$numberOfActions *100) -Status "Loading Notes";
Start-Process -Filepath "C:\FILE\PATH\ONENOTE.EXE"
Start-Sleep 5s
#(Get-Process -Name ONENOTE).MainWindowHandle | ForEach-Object { Set-WindowStyle MAXIMIZE $_ }
(Get-Process -Name ONENOTE).MainWindowHandle | ForEach-Object { Set-WindowStyle MINIMIZE $_ }
Start-Sleep 5s

#Finally, update the progress bar with a success message, and set the percent complete to 100%
Write-Progress -Id $ProgressBarId -Activity "Successfully Loaded Work Enviroment." -PercentComplete (4/$numberOfActions *100) -Status "Exiting";
Start-Sleep 5s

#Exiting Script
#exit
}
#****************************************************Start-Work FUNCTION****************************************************


#****************************************************SHOW-MENU FUNCTION****************************************************
#MENU SAMPLE CREDIT Adam Bertram
#https://adamtheautomator.com/powershell-menu/
#"**************************************************************************************************************************************************"
#"* ================================================================= Main  Menu ================================================================= *"
#"*                                                                                                                                                *"
#"*    =========== Remote Connections ===========    =========== Desktop Environment ===========    ============== Other Options ==============    *"
#"*                                                                                                                                                *"
#"*     1: Press '1' to connect to RaspberryPi.       1: Press 'W' to launch Work Environment.       1: Press 'Q' to exit terminal.                *"
#"*     2: Press '2' to connect to Docker Host.                                                      2: Press 'P' to return to Powershell.         *"
#"*     3: Press '3' to connect to Hyper-V Host.                                                     To relaunch type 'Get-Menu' in the prompt.    *"
#"*     4: Press '4' to connect to NAS Host.                                                                                                       *"
#"*                                                                                                                                                *"
#"*================================================================================================================================================*"
#"**************************************************************************************************************************************************"
function Show-Menu {
    param (
        [string]$Title = 'Main Menu'
    )
    Write-Host -Object ("**************************************************************************************************************************************************") -ForegroundColor Red

    Write-Host -Object ("*") -NoNewline -ForegroundColor Red
    Write-Host -Object (" ================================================================= ") -NoNewline -ForegroundColor Green
    Write-Host -Object ("Main  Menu") -NoNewline -ForegroundColor Cyan
    Write-Host -Object (" ================================================================= ") -NoNewline -ForegroundColor Green
    Write-Host -Object ("*") -ForegroundColor Red
    
    Write-Host -Object ("*                                                                                                                                                *") -ForegroundColor Red
    
    Write-Host -Object ("*") -NoNewline -ForegroundColor Red
    Write-Host -Object ("    =========== ") -NoNewline -ForegroundColor Green
    Write-Host -Object ("Remote Connections") -NoNewline -ForegroundColor Cyan
    Write-Host -Object (" ===========    =========== ") -NoNewline -ForegroundColor Green
    Write-Host -Object ("Desktop Environment") -NoNewline -ForegroundColor Cyan
    Write-Host -Object (" ===========    ============== ") -NoNewline -ForegroundColor Green
    Write-Host -Object ("Other Options") -NoNewline -ForegroundColor Cyan
    Write-Host -Object (" ==============    ") -NoNewline -ForegroundColor Green
    Write-Host -Object ("*") -ForegroundColor Red
    
    Write-Host -Object ("*                                                                                                                                                *") -ForegroundColor Red
    
    Write-Host -Object ("*") -NoNewline -ForegroundColor Red
    Write-Host -Object ("     1: Press '") -NoNewline -ForegroundColor Green
    Write-Host -Object ("1") -NoNewline -ForegroundColor Yellow
    Write-Host -Object ("' to connect to RaspberryPi.       1: Press '") -NoNewline -ForegroundColor Green
    Write-Host -Object ("W") -NoNewline -ForegroundColor Yellow
    Write-Host -Object ("' to launch Work Environment.       1: Press '") -NoNewline -ForegroundColor Green
    Write-Host -Object ("Q") -NoNewline -ForegroundColor Yellow
    Write-Host -Object ("' to exit terminal.                ") -NoNewline -ForegroundColor Green
    Write-Host -Object ("*") -ForegroundColor Red
    
    Write-Host -Object ("*") -NoNewline -ForegroundColor Red
    Write-Host -Object ("     2: Press '") -NoNewline -ForegroundColor Green
    Write-Host -Object ("2") -NoNewline -ForegroundColor Yellow
    Write-Host -Object ("' to connect to Docker Host.                                                      2: Press '") -NoNewline -ForegroundColor Green
    Write-Host -Object ("P") -NoNewline -ForegroundColor Yellow
    Write-Host -Object ("' to return to Powershell.         ") -NoNewline -ForegroundColor Green
    Write-Host -Object ("*") -ForegroundColor Red
    
    Write-Host -Object ("*") -NoNewline -ForegroundColor Red
    Write-Host -Object ("     3: Press '") -NoNewline -ForegroundColor Green
    Write-Host -Object ("3") -NoNewline -ForegroundColor Yellow
    Write-Host -Object ("' to connect to Hyper-V Host.                                                     To relaunch type '") -NoNewline -ForegroundColor Green
    Write-Host -Object ("Get-Menu") -NoNewline -ForegroundColor Yellow
    Write-Host -Object ("' in the prompt.    ") -NoNewline -ForegroundColor Green
    Write-Host -Object ("*") -ForegroundColor Red
    
    Write-Host -Object ("*") -NoNewline -ForegroundColor Red
    Write-Host -Object ("     4: Press '") -NoNewline -ForegroundColor Green
    Write-Host -Object ("4") -NoNewline -ForegroundColor Yellow
    Write-Host -Object ("' to connect to NAS Host.                                                                                                       ") -NoNewline -ForegroundColor Green
    Write-Host -Object ("*") -ForegroundColor Red
    
    Write-Host -Object ("*                                                                                                                                                *") -ForegroundColor Red
    
    Write-Host -Object ("*") -NoNewline -ForegroundColor Red
    Write-Host -Object ("================================================================================================================================================") -NoNewline -ForegroundColor Green
    Write-Host -Object ("*") -ForegroundColor Red
    
    Write-Host -Object ("**************************************************************************************************************************************************") -ForegroundColor Red
}
#****************************************************SHOW-MENU FUNCTION****************************************************

#****************************************************INTERACTIVE MENU FUNCTION****************************************************
Function Get-Menu {
do
 {
    (Get-Process -Name windowsterminal).MainWindowHandle | ForEach-Object { Set-WindowStyle MAXIMIZE $_ }

    Clear-Host

    Start-Sleep 1s

    Get-SystemSplash
    
    Show-Menu
    $selection = Read-Host "Please make a selection"
    switch ($selection)
    {
    '1' {
    'Connecting to RaspberryPi'
    Connect-Pi
    } '2' {
    'Connecting to Docker Host'
    Connect-Docker
    } '3' {
    'Connecting to Hyper-V Host'
    Connect-Hyperv
    Get-KeyEnter
    Get-keyControlC
    }'4' {
    'Connecting to NAS Host'
    Connect-Nas
    Get-KeyEnter
    Get-keyControlC
    }'w' {
    'Starting Work Enviorment'
    Start-Work
    Get-KeyEnter
    }'p' {
    'Exiting Menu'
    Start-Sleep 1s
    Clear-Host
    Write-Host "To lanch Main Menu type 'Get-Menu' in the prompt"
    Get-keyControlC
    }'q' {
    'Exiting PowerShell Good Bye'
    Start-Sleep 1s
    exit
    }
    }
    pause
 }
 until ($selection -eq 'q')
exit
}
#****************************************************INTERACTIVE MENU FUNCTION****************************************************

#****************************************************BANNER MOTD FUNCTION****************************************************
Clear-Host
Write-Host "To lanch Main Meun type 'Get-Menu' in the prompt"