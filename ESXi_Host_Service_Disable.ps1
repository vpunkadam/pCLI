$user = 'yourlogin'  
$pswd = 'yourpassword'  
  
$cmd = 'etc/init.d/smartd stop'  
$cmd2 = 'chkconfig smartd off'  
  
Get-Cluster -Name yourclustername | Get-VMHost | %{  
    $ssh =Get-VMHostService -VMHost $_ | where{$_.Key -eq 'TSM-SSH'}  
    if(!$ssh.Running){  
        Start-VMHostService -HostService $ssh -Confirm:$false > $null  
    }  
  
    Write-host "Running remote SSH commands on $($_.Name)." -ForegroundColor Yellow  
    Echo Y | ./plink.exe $_.Name -pw $pswd -l $user $cmd  
    Echo Y | ./plink.exe $_.Name -pw $pswd -l $user $cmd2  
  
    if(!$ssh.Running){  
        Stop-VMHostService -HostService $ssh -Confirm:$false > $null  
    }  
}  