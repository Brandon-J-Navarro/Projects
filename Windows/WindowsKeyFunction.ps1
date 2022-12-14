#This $source block is to add the "Windows" key as a function you can call since its not built in natively 
#Credit to https://github.com/stefanstranger/PowerShell/blob/master/WinKeys.ps1
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

#This adds the .NET APIs in so you can send keyboard strokes to the prompt
Add-Type -TypeDefinition $source -ReferencedAssemblies "System.Windows.Forms"
Add-Type -AssemblyName "System.Windows.Forms"

#EXAMPLE OF WIN+CTRL+ENTER
#
#    [KeyboardSend.KeyboardSend]::KeyDown("LWin")
#    [System.Windows.Forms.SendKeys]::SendWait("^{ENTER}")
#    [KeyboardSend.KeyboardSend]::KeyUp("LWin")
#