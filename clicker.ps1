<#
    Automatically send a bunch of mouse clicks. Obviously this is dangerous and
    should be used very carefully. This probably works only on Windows™ computers.

    pwsh.exe .\clicker1.ps1
#>

[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Drawing")
$signature=@'
[DllImport("user32.dll",CharSet=CharSet.Auto,CallingConvention=CallingConvention.StdCall)]
public static extern void mouse_event(long dwFlags, long dx, long dy, long cButtons, long dwExtraInfo);
'@
$SendMouseClick = Add-Type -memberDefinition $signature -name "Win32MouseEventNew" -namespace Win32Functions -passThru


# Slower computers will probably need 30-50ms of sleep time to avoid major issues.
# A fast computer can probably handle 1ms just fine.
$sleepPerTick = 30
# This is how many clicks to send before taking a break.
$clicksPerTick = 10
# This is how many 'ticks' to run for a given cycle.
$ticks = 100
# The total number of times to do everything.
$cycles = 20
# Optionally, add extra delay between each cycle.
$sleepPerCycle = 0


Start-Sleep -Seconds 01  # give yourself a second to move the mouse into position

$count = 0
1..$cycles | ForEach-Object -Process {
    1..$ticks | ForEach-Object -Process {
        # This is where we do a 'tick' - send clicks, then sleep briefly.
        1..$clicksPerTick | ForEach-Object -Process {
            $SendMouseClick::mouse_event(0x00000002, 0, 0, 0, 0);
            $SendMouseClick::mouse_event(0x00000004, 0, 0, 0, 0);
        }
        Start-Sleep -Milliseconds (1,$sleepPerTick|Measure -Max).Maximum
    }
    $count = $count + 1
    Write-Host "$" $count
    Start-Sleep -Milliseconds $sleepPerCycle
}
