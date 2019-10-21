# This script will download and extract bginfo.zip, then create a .CMD file and add it to the Computer Startup
# The script will assume the script will run from same folder of BGInfo
# Update ScriptPath variable if different

# Variables
$SetupFolder = "C:\Setup"
$BGinfoFolder = $SetupFolder + "\BGinfo"
$BginfoFile = "bginfo.bgi"

# Create Folders
New-Item -ItemType "directory" -Path $BGinfoFolder -force

# Download BGinfo from Systernals
$ZipFile = $SetupFolder + "\BGInfo.zip"
Invoke-WebRequest "https://download.sysinternals.com/files/BGInfo.zip" -OutFile $ZipFile
Expand-Archive $ZipFile -DestinationPath $BGinfoFolder
Remove-Item $ZipFile

# Download BGinfo from GitHub
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
Invoke-WebRequest "https://github.com/guillermo-musumeci/install-bginfo-unattended/raw/master/bginfo.bgi" -OutFile ($BGinfoFolder + "\" + $BginfoFile)

# Create Auto Start File
$Bgfile = $BGinfoFolder + "\bg.cmd"
$BgScript = "@" + $BGinfoFolder + "\bginfo.exe " + $BGinfoFolder + "\" + $bginfoFile + " /timer:0 /nolicprompt"
New-Item $bgfile -force
Set-Content $bgfile $bgscript

# Configure Auto Start
$Destination = "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\StartUp" 
Copy-Item -Path $bgfile -Destination $Destination -force
Write-Host "File '$bgfile' was added to Startup successfully." -ForegroundColor Green

# Execute BGinfo
Start-Process $Bgfile
