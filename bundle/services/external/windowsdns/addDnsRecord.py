#!/usr/bin/env python
# import
import argparse
import winrm
# Setup argparse
parser = argparse.ArgumentParser()
# inputs
parser.add_argument("Hostname", help="DNS hostname")
parser.add_argument("IPAddress", help="IP Address of new record")
parser.add_argument("DnsZone", help="Target DNS Zone")
parser.add_argument("WinRmHost", help="WinRmHost, no suffix")
parser.add_argument("Username", help="Windows RM username")
parser.add_argument("Password", help="Windows RM password")
args = parser.parse_args()
parser.parse_args()
# assign to usable variables
ipaddress = args.IPAddress
print ipaddress
hostname = args.Hostname
print hostname
dnszone = args.DnsZone
print dnszone
winrmhost = args.WinRmHost
winrmuser = args.Username
winrmpassword = args.Password
"""
Add dns request
May need to kinit the user before running this script
"""
s = winrm.Session(winrmhost,transport='ntlm', auth=(winrmuser,winrmpassword))
# make the request
r = s.run_ps('Add-DnsServerResourceRecordA -IPv4Address ' + ipaddress + ' -Name ' + hostname + ' -ZoneName ' +  dnszone + ' -CreatePtr')
print "This is the standard output"
print r.std_out
print "This is the standard error stuff"
print r.std_err
