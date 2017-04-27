Param(
    [string] $DNSServer,
    [string] $ZoneName,
    [string] $Hostname,
    [string] $IPAddress
 )

Remove-DnsServerResourceRecord -ComputerName $DNSServer -ZoneName $ZoneName -RRType "A" -Name $Hostname -RecordData $IPAddress -Force 
