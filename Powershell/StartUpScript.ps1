<#

Start Up Sctipt 
Version 2.0

☐ - uncomplete / testing
☑ - complete / tested
☒ - does not work / task scraped 


V2.0 Rework Ideas
    ☑ - Ask to start up Blank? (Default Yes) hit "Enter" for "Blank Startup" and exit or hit "No" for next prompt
    ☐ - Time out count down after set time default to blank
            - need to look into this more

    ☑ - If not ask if im "Working"? (Default Yes) hit "Enter" for "Working Startup" and exit or hit "No" for next prompt
        ☑ - Open applications
            ☑ - Outlook
            ☑ - OneNote (Work)
            ☑ - Teams
                 ☑ - Fix error when starting Teams process
                    "Error while parsing hooks JSON. Error: ENOENT: no such file or directory, open 'C:\<FILE\PATH>\Microsoft\Teams\hooks.json'
                    (node:15140) [DEP0005] DeprecationWarning: Buffer() is deprecated due to security and usability issues. Please use the Buffer.alloc(), Buffer.allocUnsafe(), or Buffer.from() methods instead.
                    (node:15140) MaxListenersExceededWarning: Possible EventEmitter memory leak detected. 11 ecsSettingsUpdated listeners added to [EventEmitter]. Use emitter.setMaxListeners() to increase limit
                    (node:15140) MaxListenersExceededWarning: Possible EventEmitter memory leak detected. 11 appInitialized listeners added to [EventEmitter]. Use emitter.setMaxListeners() to increase limit"

                    Teams Shortcut uses these valuse to start so I should probably replicate that
                    Target: "C:\<FILE\PATH>Microsoft\Teams\Update.exe --processStart "Teams.exe""
                    Start in: "C:\<FILE\PATH>\Microsoft\Teams"

                    start-process -FilePath "C:\<FILE\PATH>\Microsoft\Teams\Update.exe" -WorkingDirectory "C:\<FILE\PATH>\Microsoft\Teams" -ArgumentList "--processStart  Teams.exe" Fiexes that error
            ☑ - Chrome
                ☑ - Open Tabs

    ☑ - If there is no further prompts after hitting "No" on previous prompt proceed to exit and "Blank Startup"

    ☒ - Struggling to find a way to use an object arry of objects like "$work = $process1,$process2,$process3,$process4"
        to run with "Start-Process" or "Invoke-Expression"
        For now there will be individual instances of "Start-Process" and "Invoke-Expression"

    ☒ - foreach ($work in $work) {invoke-expression $process5} fixed that issue 

    ☑ - add delay between each application opening
            - went back to starting indvidual processes that way i can add a delay between each application opening easily
             
    ☐ - Possibly ask if i am "Devloping"? 
        ☐ - Open applications
            ☐ - VSCode
            ☐ - OneNote (IT Notes)
            ☐ - GitHub Desktop
            ☐ - Firefox
                ☐ - Open Tabs

    
$question3 = 'Are you developing?'

$firefox = 'Start-Process -FilePath "C:\<FILE\PATH>\firefox.exe" -ArgumentList  "URL"'
$code = 'Start-Process -FilePath "C:\<FILE\PATH>\Code.exe"'
$github = 'Start-Process -FilePath "C:\<FILE\PATH>\GitHubDesktop.exe"'

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

$chrome = 'Start-Process -FilePath "C:\<File\Path>\chrome.exe" -ArgumentList  "URL","URL","URL"'
$outlook = 'Start-Process -FilePath "C:\<File\Path>\OUTLOOK.EXE"'
$teams = 'Start-Process -Filepath "C:\<File\Path>\teams.exe"'
$onenote = 'Start-Process -Filepath "C:\<File\Path>\ONENOTE.EXE"'
$title1    = 'Welcome'
$question1 = 'Do you want to start "Bank Desktop"?'
$choices1  = '&Yes','&No'
$title2 = ""
$question2 = 'Are you working?'


Get-Date

$decision1 = $Host.UI.PromptForChoice($title1, $question1, $choices1, 0)
if ($decision1 -eq 0) {
Write-Host 'Stanting "Blank Desktop Environment".'
exit
} else {
$decision2 = $Host.UI.PromptForChoice($title2, $question2, $choices1, 0)
if ($decision2 -eq 0) {
Write-Host 'Starting "Working Environment"'
    Invoke-Expression $chrome
    Start-Sleep 10s
    Invoke-Expression $outlook
    Start-Sleep 10s
    Invoke-Expression $teams
    Start-Sleep 10s
    Invoke-Expression $onenote
    Start-Sleep 10s
exit
} else {
Write-Host 'Stanting "Blank Desktop Environment".'
}
}
