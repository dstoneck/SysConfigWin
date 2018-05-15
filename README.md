SysConfigWin

This is a project I did to help setup system configurations on the local machine by end users

How I worked around restriction without changing them, by simply creating a shortcut to the script and to load with no profile and run as administrator.

Example: C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe -ExecutionPolicy Bypass -File \\<server>\script.ps1


Mostly this collection is the PowerShell Scripts used to configure the system locally

**This are all in testing phase and only had limited testing**

I welcome any input on how to improve these scripts