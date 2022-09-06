<#
REMOTE SHUTDOWN SCRIPT
BLOCK 1
THIS CREATES THE ALIASES FOR THE CREDENTIALS TO CONNECT TO REMOTE COMPUTER
#>
$User = "*COMPUTERNAME\USERNAME*"
$PWord = ConvertTo-SecureString -String "*PASSWORD*" -AsPlainText -Force
$Credential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $User, $PWord
<#
BLOCK 2
THIS SENDS COMMANDS TO REMOTE COMPUTER OR COMPUTERS AS A JOB
AND PROVIEDS THE CREDENTIALS WE SET UP IN BLOCK 1
#>
Invoke-Command -ComputerName '*COMPUTERNAME*' -AsJob `
-JobName Remoteconnect -Credential $Credential -ScriptBlock {
    Get-ComputerInfo -Property csname,oslocaldatetime
   #Stop-Computer -Force
}
<#
BLOCK 3
THIS WILL MAKE POWERSHELL PAUSE BEFORE CONTINUEING
#>
start-sleep -Seconds 5
<#
BLOCK 4
THIS WILL FORMAT RESULTS AS PLAIN TEXT AND NOT HAVE EXTRA CHARACTERS AROUND TABLE NAMES
AND GET THE RESULTS OF THE JOB CREATED IN BLOCK 2 AND OUT PUT IT TO A FILE
#>
$PSStyle.OutputRendering = [System.Management.Automation.OutputRendering]::PlainText
Receive-Job -name Remoteconnect |
    Format-Table @{name='ComputerName';expression={$_.csname}},
    @{name='RestartTime';expression={$_.oslocaldatetime}} |
    out-file <#FILEPATH.txt#>
