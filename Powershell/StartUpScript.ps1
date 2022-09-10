<#

☐ - uncomplete / needs testing
☑ - complete / tested
☒ - does not work / task scraped 

Start up Script
    - Ideas
        ☑ - Ask to start up Blank? (Default Yes) hit "Enter" for "Blank Startup" and exit or hit "No" for next prompt
        ☐ - Time out count down after set time default to blank
        ☑ - If not ask if im "Working"? (Default Yes) hit "Enter" for "Working Startup" and exit or hit "No" for next prompt
            ☑ - Open applications
                ☑ - Outlook
                ☑ - OneNote (Work)
                ☑ - Teams
                ☑ - Chrome
                    ☑ - Open Tabs                        
        ☑ - If there is no further prompts after hitting "No" on previous prompt proceed to exit and "Blank Startup"

        ☒ - Struggling to find a way to use an object arry of objects like "$work = $process1,$process2,$process3,$process4"
          to run with "Start-Process" or "Invoke-Expression"
          For now there will be individual instances of "Start-Process" and "Invoke-Expression"

        ☒ - foreach ($work in $work) {invoke-expression $process5} fixed that issue 

        ☑ - went back to starting indvidual processes that way i can add a delay between each application opening 
        ☑ - add delay between each application opening

    ☐ - Thoughts for later ideas              
        ☐ - Possibly ask if i am "Devloping"? 
            ☒ - Ask if it "Remote"? (Default Yes) hit "Enter" for "Remote Devlopment Startup" and exit or hit "No" for next prompt
                ☒ - Open applications
                    ☒ - Remote Desktop connection 
                    ☒ - OneNote (IT Notes)
            ☒ - Ask if it is "Local"? (Default Yes) hit "Enter" for "Local Devlopment Startup" and exit or hit "No" for next prompt
            ☐ - Open applications
                ☐ - VSCode
                ☐ - OneNote (IT Notes)
                ☐ - GitHub Desktop
                ☐ - Firefox
                    ☐ - Open Tabs

    $onenote = "C:\Program Files\Microsoft Office\root\Office16\ONENOTE.EXE"
    $work = $process1,$process2,$process3,$process4
    $process5 = 'Start-Process -Filepath $work'
    
    $question3 = 'Are you developing?'
    $firefox ="C:\<FILE\PATH>\firefox.exe"
    $code = "C:\<FILE\PATH>\Code.exe"
    $github = "C:\<FILE\PATH>\GitHubDesktop.exe"

    $process6 = 'Start-Process -FilePath $firefox -ArgumentList  "URL"'
    $process7 = 'Start-Process -FilePath $code'
    $process8 = 'Start-Process -FilePath $github'

    $decision3 = $Host.UI.PromptForChoice($title2, $question3, $choices1, 0)
    if ($decision2 -eq 0) {
        Write-Host 'Starting "Devlopement evironment"'
            Invoke-Expression $process6
            Start-Sleep 10s
            Invoke-Expression $process7
            Start-Sleep 10s
            Invoke-Expression $process8
            Start-Sleep 10s
        exit

    
    #>

    $outlook = "C:\<FILE\PATH>\OUTLOOK.EXE"
    $teams = "C:\<FILE\PATH>\teams.exe"
    $chrome = "C:\<FILE\PATH>\chrome.exe"
    $mssa = "C:\<FILE\PATH>ONENOTE.EXE"
    $process1 = 'Start-Process -FilePath $chrome -ArgumentList  "URL"'
    $process2 = 'Start-Process -FilePath $outlook'
    $process3 = 'Start-Process -Filepath $teams'
    $process4 = 'Start-Process -Filepath $mssa'
    $title1    = 'Welcome'
    $question1 = 'Do you want to start "Bank Desktop"?'
    $choices1  = '&Yes','&No'
    $title2 = ""
    $question2 = 'Are you working?'
    
    
    Get-Date
    
    $decision1 = $Host.UI.PromptForChoice($title1, $question1, $choices1, 0)
    if ($decision1 -eq 0) {
        Write-Host 'Stanting "Blank Desktop".'
        exit
    } else {
        $decision2 = $Host.UI.PromptForChoice($title2, $question2, $choices1, 0)
        if ($decision2 -eq 0) {
            Write-Host 'Starting "Work Environment"'
                Invoke-Expression $process1
                Start-Sleep 10s
                Invoke-Expression $process2
                Start-Sleep 10s
                Invoke-Expression $process3
                Start-Sleep 10s
                Invoke-Expression $process4
                Start-Sleep 10s
            exit
        } else {
            Write-Host 'Stanting "Blank Desktop".'
            }
    }
    