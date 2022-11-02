<#
Start Up Sctipt 
Version 3.0

☐ - uncomplete / testing
☑ - complete / tested
☒ - does not work / task scraped 

V3.0 Rework Ideas
☑ - Minimize Windows Function
    Get-Process -WindowStyle Minimized does not work with every program
☑ - Get-SystemSplash
    Added PreStart Check to see if Get-SystemSplash is already installed
☑ - Progress Bar
    Added a Progress Bar for opening of applicatons
    
☑ - Open applications
    ☑ - Teams
        ☑ - Fix error when starting Teams process
            "Error while parsing hooks JSON. Error: ENOENT: no such file or directory, open 'C:\FILE\PATH\Microsoft\Teams\hooks.json'
            (node:15140) [DEP0005] DeprecationWarning: Buffer() is deprecated due to security and usability issues. Please use the Buffer.alloc(), Buffer.allocUnsafe(), or Buffer.from() methods instead.
            (node:15140) MaxListenersExceededWarning: Possible EventEmitter memory leak detected. 11 ecsSettingsUpdated listeners added to [EventEmitter]. Use emitter.setMaxListeners() to increase limit
            (node:15140) MaxListenersExceededWarning: Possible EventEmitter memory leak detected. 11 appInitialized listeners added to [EventEmitter]. Use emitter.setMaxListeners() to increase limit"
        Teams Shortcut uses these valuse to start so I should probably replicate that
        Target: "C:\FILE\PATHMicrosoft\Teams\Update.exe --processStart "Teams.exe""
        Start in: "C:\FILE\PATH\Microsoft\Teams"
        start-process -FilePath "C:\FILE\PATH\Microsoft\Teams\Update.exe" -WorkingDirectory "C:\FILE\PATH\Microsoft\Teams" -ArgumentList "--processStart  Teams.exe" Fiexes that error
            
☐ - Possibly ask if i am "Devloping"? 
    ☐ - Open applications
        ☐ - VSCode
        ☐ - OneNote (IT Notes)
        ☐ - GitHub Desktop
        ☐ - Firefox
            ☐ - Open Tabs
    
$question3 = 'Are you developing?'

$firefox = 'Start-Process -FilePath "C:\FILE\PATH\firefox.exe" -ArgumentList  "URL"'
$code = 'Start-Process -FilePath "C:\FILE\PATH\Code.exe"'
$github = 'Start-Process -FilePath "C:\FILE\PATH\GitHubDesktop.exe"'

$decision3 = $Host.UI.PromptForChoice($title2, $question3, $choices1, 0)
if ($decision2 -eq 0) {
    Write-Host 'Starting "Devlopement evironment"'
        Invoke-Expression $firefox
        Start-Sleep 10s
        Invoke-Expression $code
        Start-Sleep 10s
        Invoke-Expression $github
        Start-Sleep 10s
    exit
#>

#Minimize Windows Function
#CREDIT bobmccoy
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

if (Get-Command -ListImported -Name get-systemsplash) {
    Write-Host "PreStart Check Passed"
    Start-Sleep 3
    Write-Host "Exiting PreStart Check"
    Clear-Host
} else {
    Write-Host "PreStart Check Failed, Installing"
    Install-Module -Name SystemSplash -Repository PSGallery -Scope CurrentUser -Confirm
    Start-Sleep 5s
    Clear-Host
}  

#CREDIT M.Millar
#https://github.com/mmillar-bolis/SystemSplash
Get-SystemSplash

$title1    = 'Welcome'
$question1 = 'Do you want to start "Bank Desktop"?'
$choices1  = '&Yes','&No'
$title2 = ""
$question2 = 'Are you working?'

$decision1 = $Host.UI.PromptForChoice($title1, $question1, $choices1, 0)
if ($decision1 -eq 0) {
    Write-Host 'Stanting "Blank Desktop" Environment.'
    exit
} else {
    $decision2 = $Host.UI.PromptForChoice($title2, $question2, $choices1, 0)
    if ($decision2 -eq 0) {

        #Progress Bar Sample Credit 
        #https://social.technet.microsoft.com/wiki/contents/articles/18697.an-example-of-using-write-progress-in-a-long-running-sharepoint-powershell-script.aspx

        #The progress bar, is going to display the overall status of the function, which has four stages (steps), which are: 1. "ONE", 2. "TWO", 3. "THREE", and finally, 4. "FOUR"
        $ProgressBarId = 0;
        $numberOfActions = 4;

        #Set the percentage of the first progress bar to 0%
        Write-Progress -Id $ProgressBarId -Activity "Starting Work Enviorment" -PercentComplete (1)
        Start-Sleep 5s

        #Set the percentage of the first progress bar to 20% (calculated from (1/$numberOfActions *100), which is effectively 1/4*100)
        Write-Progress -Id $ProgressBarId -Activity "Opening Chrome" -PercentComplete (1/$numberOfActions *100) -Status "Opening URLs";
        Start-Process -FilePath "C:\FILE\PATH\chrome.exe" -ArgumentList  "URL","URL"
        Start-Sleep 1s
        (Get-Process -Name chrome).MainWindowHandle | ForEach-Object { Set-WindowStyle MAXIMIZE $_ }
        (Get-Process -Name chrome).MainWindowHandle | ForEach-Object { Set-WindowStyle MINIMIZE $_ }
        Start-Sleep 9s

        #Set the percentage of the first progress bar to 20% (calculated from (1/$numberOfActions *100), which is effectively 1/4*100)
        Write-Progress -Id $ProgressBarId -Activity "Opening Outlook" -PercentComplete (2/$numberOfActions *100) -Status "Loading Email";
        Start-Process -FilePath "C:\FILE\PATH\OUTLOOK.EXE"
        Start-Sleep 2s
        (Get-Process -Name OUTLOOK).MainWindowHandle | ForEach-Object { Set-WindowStyle MAXIMIZE $_ }
        (Get-Process -Name OUTLOOK).MainWindowHandle | ForEach-Object { Set-WindowStyle MINIMIZE $_ }
        Start-Sleep 8s

        #Set the percentage of the first progress bar to 40% (calculated from (2/$numberOfActions *100), which is effectily 2/4*100)            
        Write-Progress -Id $ProgressBarId -Activity "Opeing Teams" -PercentComplete (3/$numberOfActions *100) -Status "Connecting to Teams";
        start-process -FilePath "C:\FILE\PATH\Microsoft\Teams\Update.exe" -WorkingDirectory "C:\FILE\PATH\Microsoft\Teams" -WindowStyle Minimized -ArgumentList "--processStart  Teams.exe"
        Start-Sleep 5s
        (Get-Process -Name Teams).MainWindowHandle | ForEach-Object { Set-WindowStyle MAXIMIZE $_ }
        (Get-Process -Name Teams).MainWindowHandle | ForEach-Object { Set-WindowStyle MINIMIZE $_ }
        Start-Sleep 5s

        #Set the percentage of the first progress bar to 60% (calculated from (3/$numberOfActions *100), which is effectively 3/4*100)
        Write-Progress -Id $ProgressBarId -Activity "Opening OneNote" -PercentComplete (3/$numberOfActions *100) -Status "Loading Notes";
        Start-Process -Filepath "C:\FILE\PATH\ONENOTE.EXE"
        Start-Sleep 5s
        (Get-Process -Name ONENOTE).MainWindowHandle | ForEach-Object { Set-WindowStyle MAXIMIZE $_ }
        (Get-Process -Name ONENOTE).MainWindowHandle | ForEach-Object { Set-WindowStyle MINIMIZE $_ }
        Start-Sleep 5s

        #Finally, update the progress bar with a success message, and set the percent complete to 100%
        Write-Progress -Id $ProgressBarId -Activity "Successfully Loaded Work Enviroment." -PercentComplete (4/$numberOfActions *100) -Status "Exiting";
        Start-Sleep 5s

        #Exiting PowerShell
        exit
    } else {
        Clear-Host
        Write-Host 'Stanting "Blank Desktop" Environment.'
        }
}