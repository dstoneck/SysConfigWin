funtion configure
{
    $ServerPath = "\\<server>\Drivers"
    $Manufacturer = Get-WmiObject Win32_Computersystem | Select -ExpandProperty Manufacturer
    $Model = Get-WmiObject Win32_Computersystem | Select -ExpandProperty Model
    Write-Host $Manufacturer
    Write-Host $Model
    
    #Reseting the internet Options

    Write-Host "Opening Reset Internet options"
    Write-Host "Click Reset to contuine"

    & RunDll32.exe InetCpl.cpl,ResetIEtoDefaults | Out-Null
        
    #Configure Proxy

    Invoke-Expression (IEZones) | Out-Null

    #Disk Cleanup
    Write-Host "Running Disk Cleanup"
    Start-Process -FilePath c:\windows\SYSTEM32\cleanmgr.exe -ArgumentList (/AUTOCLEAN) -Wait

    #Apply Theme
    #rundll32.exe %SystemRoot%\system32\shell32.dll,Control_RunDLL %SystemRoot%\system32\desk.cpl desk,@Themes /Action:OpenTheme /file:"C:\Windows\Resources\Themes\aero.theme"


    #Firewall Rule
    New-NetFirewallRule -DisplayName ICMPv4 -Direction in -Protocol icmpv4

    #Remove/reinstall OneDrive

    $OneDrive = read-host "Apply OneDrive Fix? (Y/N)"

        if ($OneDrive -eq "y"){
        
            Start-Process -FilePath %SystemRoot%\SysWOW64\OneDriveSetup.exe -ArgumentList /uninstall
            Remove-Item -Path ("C:\ProgramData\Microsoft\Windows\Start Menu\Programs\OneDrive for Business.lnk") -Force
            Copy-Item -Path ("\\wtc-mdtstrg-02\Image\Vendor Drivers\OneDriveSetup.exe") -Destination %USERPROFILE%\Desktop
            Start-Process -FilePath %USERPROFILES%\Desktop\OneDriveSetup.exe -ArgumentList /silent
        }

    #Checking Bitlocker
    Write-Host "Checking Bitlocker"
    manage-bde -off c:
    
    #Install Drivers

    New-Item -Path C:\Temp0 -ItemType Directory

    Switch ($Manufacturer.SubString(0,4))
    {
        Dell{Invoke-Expression (Driver-Dell) | Out-Null}
        Hewl{Invoke-Expression (Driver-HP) | Out-Null}
        Leno{Invoke-Expression (Driver-Lenovo) | Out-Null}
    }

    #Windows updates

    Start-Process -FilePath C:\Windows\System32\wuauclt.exe -ArgumentList /updatenow

    #Mcafee Update
    Start-Process -FilePath "c:\Program files\Mcafee\Agent\mconfig.exe" -ArgumentList (-enforce -noguid) -Wait

    Write-Host "Pausing script to confirm settings and system changes if needed"        
    $Pause = read-host "Continue? (Y/N)"

        if ($Pause -eq "y"){
        
        New-Item -Path C:\Windows\Setup\Scripts -ItemType directory
        Copy-Item -Path unattend.xml -Destination C:\Windows\System32\sysprep
        Copy-Item -Path Scripts\SetupComplete.cmd -Destination C:\Windows\Setup\Scripts


        }
        else{
            exit
        }

}

function Driver-HP
{
    Write-Host "Stand-By: Copying and Installing Drivers"
    Write-Host "This will take some time"
    Copy-Item -Path ($ServerPath + "\" + $Model) -Destination (C:\Temp0)
    
    $File = Null

    Get-ChildItem ("c:\Temp0\" + $Model ) -Filter Setup.exe -Recurse | ForEach-Object
    {
        Start-Process $_.Fullname -ArgumentList -s
    }
    Write-Host "Driver Installation Completed"
}

function Driver-Dell
{
    Write-Host "Stand-By: Copying and Installing Drivers"
    Write-Host "This will take some time"
    Copy-Item -Path ($ServerPath + "\" + $Model) -Destination (C:\Temp0)
    
    $File = Null

    Get-ChildItem ("c:\Temp0\" + $Model ) -Filter Setup.exe -Recurse | ForEach-Object
    {
        Start-Process $_.Fullname -ArgumentList /s
    }
    Write-Host "Driver Installation Completed"
}

function Driver-Lenovo
{
    Write-Host "Stand-By: Copying and Installing Drivers"
    Write-Host "This will take some time"
    Copy-Item -Path ($ServerPath + "\" + $Model) -Destination (C:\Temp0)
    
    $File = Null

    Get-ChildItem ("c:\Temp0\" + $Model ) -Filter Setup.exe -Recurse | ForEach-Object
    {
        Start-Process $_.Fullname -ArgumentList -s
    }
    Write-Host "Driver Installation Completed"
}

function IEZones
{

    Write-Host "Applying IE Zones"

    if (-not (Test-Path -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\Domains\that.com\home'))
    {
        $null = New-Item -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\Domains\that.com\home'
    }

    Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\Domains\that.com\home' -Name http -Value 1 -Type DWord
    Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\Domains\that.com\home' -Name https -Value 1 -Type DWord

}