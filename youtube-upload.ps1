 param (
    [string]$url = ""
 )
$url = $url.substring(10, $url.Length-10)
$outputfilename = "$env:TEMP\%(id)s\%(title)s.%(ext)s"
$youtubedlarg_filename = $url + " -o $outputfilename --recode-video mp4 --get-filename"
$youtubedlarg = $url + " -o $outputfilename --recode-video mp4 --no-warnings"
Write-Host 'initialing...'$url
$pinfo = New-Object System.Diagnostics.ProcessStartInfo
$pinfo.FileName = "youtube-dl.exe"
$pinfo.RedirectStandardError = $true
$pinfo.RedirectStandardOutput = $true
$pinfo.UseShellExecute = $false
$pinfo.Arguments = $youtubedlarg_filename
$p = New-Object System.Diagnostics.Process
$p.StartInfo = $pinfo
$p.Start() | Out-Null
$p.WaitForExit()
$stdout = $p.StandardOutput.ReadToEnd()
$stderr = $p.StandardError.ReadToEnd()


If ($stderr) {
    Write-Host "stderr: $stderr"    
    pause
} else {    
    $filepath = $stdout    
    Write-Host 'downloading...'$filepath
    $folder = Split-Path -Path $filepath
    Start-Process youtube-dl.exe -ArgumentList $youtubedlarg -WindowStyle Hidden -Wait -ErrorVariable $err
    If ($err) {
        Write-Host $err
        pause    
    } else {
        ii $folder      
    }    
}