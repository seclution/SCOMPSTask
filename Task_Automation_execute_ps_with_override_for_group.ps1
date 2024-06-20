import-module operationsmanager

$TaskDisplayName = "Execute any PowerShell"
$GroupDisplayName = "ExampleGroup"
$ScriptbodyToExecute = 'if(!([string]::IsNullOrEmpty($env:COMPUTERNAME))){"OK"}else{"NotOK"}'
$TimeToExecute = 10

# Connect to SCOM Management Group
Get-SCOMManagementGroupConnection -ComputerName scom01.scom.seclution

# Get SCOM Group
$group = Get-SCOMGroup -DisplayName $GroupDisplayName

# Get Group ClassInstances
$instances = Get-SCOMClassInstance -Group $group


# For each classinstance...
foreach ($instance in $instances) {
    Write-Host $instance
    $output = $null
    $task = $null
    # Check if the instance has a ClassId
    
    # execute Task
    $task = Start-SCOMTask -task $(Get-SCOMTask -DisplayName $TaskDisplayName) -Instance $instance -Override @{ScriptBody=$ScriptbodyToExecute} -TaskCredentials $null
    Start-Sleep -Seconds $TimeToExecute
    
    if($task){
       
        $output = Get-SCOMTaskResult -id $task.Id
       
        
        [xml]$xml = $output.Output
        
        # CData des Outputs abrufen
        $cdataContent = $xml.DataItem.Property.InnerText
        # Output ausgeben
        Write-Output $cdataContent
    }
    else{
        echo "Task execution failed for instance: $($instance.DisplayName)"
    }
}
