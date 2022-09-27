<#

Dad Joke Sctipt 
Version 1.0

**NOTE**    This will only work if narrator is alresady enabled 
            The popups are disbaled when activated
            Able to be activated with default Windows key Strokes "Ctrl+Win+Enter"


☐ - uncomplete / testing
☑ - complete / tested
☒ - does not work / task scraped 

Ideas
    ☑ - Have a pop up that displays Joke from the Get-DadJoke Function
    ☑ - Have Windows Narrator read the Joke
        ☑ - Find a way to call for the narrator automatically
    ☑ - Turn off Narrrator automatically afterwards

#>

<#
this $source block is to add the "Windows" key as a function you can call since its not built in natively 
Credit to https://github.com/stefanstranger/PowerShell/blob/master/WinKeys.ps1
#>
$source = @"
using System;
using System.Collections.Generic;
using System.Text;
using System.Threading.Tasks;
using System.Runtime.InteropServices;
using System.Windows.Forms;

namespace KeyboardSend
{


    public class KeyboardSend
    {
        [DllImport("user32.dll")]
        public static extern void keybd_event(byte bVk, byte bScan, int dwFlags, int dwExtraInfo);

        private const int KEYEVENTF_EXTENDEDKEY = 1;
        private const int KEYEVENTF_KEYUP = 2;

        public static void KeyDown(Keys vKey)
        {
            keybd_event((byte)vKey, 0, KEYEVENTF_EXTENDEDKEY, 0);
        }

        public static void KeyUp(Keys vKey)
        {
            keybd_event((byte)vKey, 0, KEYEVENTF_EXTENDEDKEY | KEYEVENTF_KEYUP, 0);
        }
    }
}

"@

<#
this adds the .NET APIs in so you can send keyboard strokes to the prompt
#>
Add-Type -TypeDefinition $source -ReferencedAssemblies "System.Windows.Forms"
Add-Type -AssemblyName "System.Windows.Forms"

<#
This is the function to use the keyboard shortcut to call for the windows narrator
#>
Function Voiceover
{
    [KeyboardSend.KeyboardSend]::KeyDown("LWin")
    [System.Windows.Forms.SendKeys]::SendWait("^{ENTER}")
    [KeyboardSend.KeyboardSend]::KeyUp("LWin")
}

<#
this is the get-dadjoke function
Credit https://community.spiceworks.com/scripts/show/4597-get-dadjoke
#>
Function Get-DadJoke 
{
Invoke-WebRequest -Uri "https://icanhazdadjoke.com" -Headers @{accept="application/json"} | 
Select-Object -ExpandProperty Content | ConvertFrom-Json | Select-Object -ExpandProperty Joke
}

<#
this last section just creates a variable for get-dadjoke and incerts it into a popup window and then enable the narrator 
#>
$joke = Get-DadJoke

$wshell = New-Object -ComObject Wscript.Shell

Voiceover

($wshell.Popup($joke,0,"Dad Joke",0))

Voiceover

Exit