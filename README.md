SysConfigWin

The file posted was design to pull drivers from the server and do basic configurations to a system. There maybe some glitch as it is still a work in progress

Due to restrictions the ability to configure MDT or SCCM was not allowed so here is the workaround I built. This was meant to be applied after you installed base image that didnt have the proper drivers installed on it.

Here is what this script does:
  reset internet options
  Configure IE Zones
  Apply Theme
  Apply OneDrive Fix (Clean reinstall)
  Disable Bitlocker
  Update Anti-Virus
  Windows Updates
  Prep for Sysprep
  
