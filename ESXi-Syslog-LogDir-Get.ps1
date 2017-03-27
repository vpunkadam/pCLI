Get-VMHost | Foreach {
	Write-Host "$($_.Name) Syslog setting:"	
    Get-AdvancedSetting -Entity $_ -Name 'Syslog.global.logDir'
}