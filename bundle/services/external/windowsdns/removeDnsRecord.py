#!/usr/bin/env python
# import
import argparse
import sys
import winrm
# setup argparse
parser = argparse.ArgumentParser()
parser.add_argument("Hostname", help="DNS hostname")
parser.add_argument("IPAddress", help="IP Address of new record")
parser.add_argument("DnsZone", help="Zone to remove from")
parser.add_argument("WinRmHost", help="WinRmHost, no suffix")
parser.add_argument("WinRmUser", help="WinRmUser")
parser.add_argument("WinRmPassword", help="WinRmUser Password")
args = parser.parse_args()
parser.parse_args()

# convert to useful variable names
ipaddress = args.IPAddress
hostname = args.Hostname
dnszone = args.DnsZone
winrmhost = args.WinRmHost
winrmuser = args.WinRmUser
winrmpassword = args.WinRmPassword
"""
Remove DNS record
May need to kinit the user before running this script
"""
s = winrm.Session(winrmhost,transport='ntlm', auth=(winrmuser,winrmpassword))
# s = winrm.Session(winrmhost,transport='kerberos', auth=(winrmuser,winrmpassword))
"""
Param(
    [string] $DNSServer,
    [string] $ZoneName,
    [string] $Hostname,
    [string] $IPAddress
 )
"""
r = s.run_ps("d:\scripts\deleteDnsRecord.ps1 " + winrmhost + " " + dnszone + " " + hostname + " " + ipaddress)
print "This is the standard output"
print r.std_out
print "This is the standard error stuff"
print r.std_err
