import-module operationsmanager
$TaskDisplayName = "Execute any PowerShell"
$ClassDisplayName = "SCOM Agent Management Class"
$ClassTargetDisplayName = "db*"
$ScriptbodyToExecute = 'if(!([string]::IsNullOrEmpty($env:COMPUTERNAME))){"OK"}else{"NotOK"}'
$TimeToExecute = 10

Get-SCOMManagementGroupConnection -ComputerName scom01.scom.seclution

$task = Start-SCOMTask -task $(Get-SCOMTask -DisplayName $TaskDisplayName) -Instance $(Get-SCOMClass -DisplayName $ClassDisplayName |  Get-SCOMClassInstance |     where-object {$_.DisplayName -like $ClassTargetDisplayName}) -Override @{ScriptBody=$ScriptbodyToExecute} -TaskCredentials $null
Start-Sleep -Seconds $TimeToExecute

$output = Get-SCOMTaskResult -id $task.Id

[xml]$xml = $output.Output

# get CData of output
#$cdataContent = $xml.DataItem.StdOut."#cdata-section"
$cdataContent = $xml.DataItem.Property.InnerText
# print output
Write-Output $cdataContent