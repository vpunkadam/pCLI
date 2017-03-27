$Scope = Get-VMHost -Location CLUSTERNAME
	foreach ($ESXHost in $Scope) {
		(Get-VMHost $ESXHost | Get-View).ExitLockdownMode()
		(Get-VMHost $ESXHost | Get-View).EnterLockdownMode()
	}