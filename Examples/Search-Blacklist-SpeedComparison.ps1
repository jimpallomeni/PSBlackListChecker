Clear-Host
Import-Module PSBlackListChecker -Force

$RunTypes = 'NoWorkflowAndRunSpaceNetDNS', 'NoWorkflowAndRunSpaceResolveDNS', 'WorkflowResolveDNS', 'WorkflowWithNetDNS', 'RunSpaceWithResolveDNS', 'RunSpaceWithNetDNS'

$IPs = '89.74.48.96' #, '89.74.48.97', '89.74.48.98', '89.74.48.99'

$Results = @()
foreach ($RunType in $RunTypes) {
    Write-Color '[', 'start ', ']', ' Testing ', $RunType -Color White, Green, White, White, Yellow
    $StopWatch = [System.Diagnostics.Stopwatch]::StartNew()
    $BlackList = Search-BlackList -IP $IPs -RunType $RunType -ReturnAll
    $StopWatch.Stop()
    $BlackListListed = $BlackList | Where-Object { $_.Islisted -eq $true }
    $BlackListListed | Format-Table -AutoSize
    Write-Color '[', 'output', ']', ' Blacklist Count ', $Blacklist.Count, ' Blacklist Listed Count ', $($BlackListListed.Count) -Color White, Yellow, White, White, Gray, White, Green
    Write-Color '[', 'end   ', ']', ' Elapsed ', $RunType, ' minutes: ', $StopWatch.Elapsed.Minutes, ' seconds: ', $StopWatch.Elapsed.Seconds, ' Milliseconds: ', $StopWatch.Elapsed.Milliseconds -Color White, Red, White, White, Yellow, White, Yellow, White, Green, White, Green, White, Green

    $Results += [PsCustomObject][ordered]@{
        'RunType'           = $RunType
        'BlackList All'     = $Blacklist.Count
        'BlackList Found'   = $BlackListListed.Count
        'Time Minutes'      = $StopWatch.Elapsed.Minutes
        'Time Seconds'      = $StopWatch.Elapsed.Seconds
        'Time Milliseconds' = $StopWatch.Elapsed.Milliseconds
    }
}

$Results | Format-Table -Autosize