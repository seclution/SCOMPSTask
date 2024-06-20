$TaskDisplayName = "HSLockDown - LIST Accounts"
$ClassDisplayName = "SCOM Agent Management Class"
$ClassTargetDisplayName = "db*"
$TimeToExecute = 10



$task = Start-SCOMTask -task $(Get-SCOMTask -DisplayName $TaskDisplayName) -Instance $(Get-SCOMClass -DisplayName $ClassDisplayName | Get-SCOMClassInstance | where-object {$_.DisplayName -like $ClassTargetDisplayName}) -TaskCredentials $null
Start-Sleep -Seconds $TimeToExecute

$output = Get-SCOMTaskResult -id $task.Id

[xml]$xml = $output.Output

# get CData of output
$cdataContent = $xml.DataItem.StdOut."#cdata-section"

# print output
Write-Output $cdataContent