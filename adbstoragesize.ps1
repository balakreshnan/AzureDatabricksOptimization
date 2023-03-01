$sub = Get-AzSubscription | Select-Object Name
$sub | ForEach-Object {   
    Set-AzContext -Subscription $_.Name    
    $currentSub = $_.Name   
    $RGs = Get-AzResourceGroup | Where-Object { $_.ResourceGroupName -like 'databricks-rg*' } | Select-Object ResourceGroupName
    $RGs | ForEach-Object {
        $CurrentRG = $_.ResourceGroupName
        $StorageAccounts = Get-AzStorageAccount -ResourceGroupName $CurrentRG | Select-Object StorageAccountName
        $StorageAccounts | ForEach-Object {
            $StorageAccount = $_.StorageAccountName
            $CurrentSAID = (Get-AzStorageAccount -ResourceGroupName $CurrentRG -AccountName $StorageAccount).Id
            $usedCapacity = (Get-AzMetric -ResourceId $CurrentSAID -MetricName "UsedCapacity").Data
            $usedCapacityInMB = $usedCapacity.Average / 1024 / 1024
            "$StorageAccount,$usedCapacityInMB,$CurrentRG,$currentSub" >> ".\storageAccountsUsedCapacity1.csv"}}}