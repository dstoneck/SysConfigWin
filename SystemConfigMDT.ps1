function mdtdeploy
{

    $Config = read-host "Apply configurations? (Y/N)"

        if ($Config -eq "y"){
        
            #Remove/rename accounts
            Invoke-Expression (account)
            
            #Lockscreen configurations
            Invoke-Expression (lockscreen)

            #Profile Picture
            Invoke-Expression (profilepic)

            #Theme Configurations
            Invoke-Expression (settheme)

            #IE Settings
            Invoke-Expression (IESettings)

            #Applications
            Invoke-Expression (applications)

        }
        else {
            break
        }




}


#Lock Screen
function lockscreen
{
    $reg = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Personalization"
    $path = C:\Windows\web\Screen\
    $image = wallpaper.jpg
    $server = \\<server>\

    Write-host "Updating Lock Screen"
    
    Copy-Item $server $path

    Set-ItemProperty -Path $reg -Name LockScreenImage -Value ($path + $image)

}

#update profile picture
function profilepic
{

    $server = \\<server>\
    $path = "%programdata%\Microsoft\User Account Pictures\"

    Write-Host "Changing Profile Pictures"

    Copy-Item $server $path -Force
    
}

#Set Theme
function settheme
{

    $server = \\<server>\
    $path = %windir%\Resources\Themes\
    $theme = Fun.theme


    Write-Host "Updating Theme"

    Copy-Item ($server + $theme) $path

    #Apply Theme
    #rundll32.exe %SystemRoot%\system32\shell32.dll,Control_RunDLL %SystemRoot%\system32\desk.cpl desk,@Themes /Action:OpenTheme /file:"C:\Windows\Resources\Themes\aero.theme"
    Start-Process -FilePath rundll32.exe -ArgumentList (%SystemRoot%\system32\shell32.dll,Control_RunDLL %SystemRoot%\system32\desk.cpl desk,@Themes /Action:OpenTheme /file:"C:\Windows\Resources\Themes\$theme") | Out-Null


}


#Internet Security Settings
function IESettings
{

    Write-Host "Opening Reset Internet options"
    Write-Host "Click Reset to contuine"

    & RunDll32.exe InetCpl.cpl,ResetIEtoDefaults | Out-Null

    #Configuring Rules/Proxy
    Invoke-Expression (IEZones) | Out-Null

    New-NetFirewallRule -DisplayName ICMPv4 -Direction in -Protocol icmpv4

}


function IEZones
{
    #Configuring Trusted zones for IE
    Write-Host "Applying IE Zones"

    if (-not (Test-Path -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\Domains\that.com\home'))
    {
        $null = New-Item -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\Domains\that.com\home'
    }

    Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\Domains\that.com\home' -Name http -Value 1 -Type DWord
    Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\Domains\that.com\home' -Name https -Value 1 -Type DWord

}

function applications
{

    $server = \\<server>\
    $install = C:\Temp0\
    

    #Copy installers

    New-Item -Path C:\Temp0 -ItemType Directory
    Copy-Item $server $install
    
    
    #Chrome
    
    Start-Process msiexec.exe -Wait -ArgumentList '/I C:\Temp0\chrome.msi /quiet'



    #Mcaffe
        #Framework


        #Agent



    # Create a Shortcut with Windows PowerShell
    $TargetFile = "C:\Program Files (x86)\App\app.exe"
    $ShortcutFile = "C:\Users\Public\Desktop"
    $WScriptShell = New-Object -ComObject WScript.Shell
    $Shortcut = $WScriptShell.CreateShortcut($ShortcutFile)
    $Shortcut.TargetPath = $TargetFile
    $Shortcut.Save()


    #Microsoft Office


    #Remove Directory
    Remove-Item -Path C:\Temp0 -Force
}

function account
{
    #removing fedexadmin account

    Remove-LocalUser -Name TempAdmin

    #rename guest to nobody

    Rename-LocalUser -Name Guest -NewName nobody

}

function startmenu
{

    Copy-Item \\<server>\ C:\Users\Default\AppData\Local\Microsoft\Windows\Shell

}