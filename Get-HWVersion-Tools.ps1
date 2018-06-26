$vcNames = 'vc1','vc2','vc3'
Connect-VIServer -Server $vcNames

$vmNames = (Get-Cluster -Name Cluster01 | Get-VM) -join '|'
Get-View -ViewType VirtualMachine -Filter @{'Name'=$vmNames} |
Select Name,

    @{N='vCenter';E={([uri]$_.Client.ServiceUrl).Host}},

    @{N="HW Version";E={$_.Config.version}},

    @{N='VMware Toos Status';E={$_.Guest.ToolsStatus}},

    @{N="VMware Tools version";E={$_.Config.Tools.ToolsVersion}} |

Group-Object -Property vCenter | %{
    $_.Group |
    Export-Csv -Path ".\$($_.Name)-$(Get-Date -Format 'ddMMyyyy-HHmm').csv" -NoTypeInformation -UseCulture
}
