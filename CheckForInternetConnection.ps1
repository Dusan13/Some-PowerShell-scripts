param(
    [string]$Path
)

$PlayWav = New-Object System.Media.SoundPlayer
$PlayWav.SoundLocation = $null

$bellSound = $PSScriptRoot + '\resources\Bell.wav'
if (Test-Path $bellSound) {
    $PlayWav.SoundLocation = $bellSound
}

if (!([string]::IsNullOrEmpty($Path))) {
    Write-Host $Path
    if (!(Test-Path $Path)) {
        Write-Error 'Path passed as parameter is not valid'
        return
    }
    
    
    $PlayWav.SoundLocation = $path
}

$sites = 'google.com', 'www.aliexpress.com', 'facebook.com'

Clear-Host

Write-Host 'CHECKING INTERNET ACCESS'

:OuterLoop while ($True) {
    foreach ($site in $sites) {
        if (Test-Connection -computer $site -Quiet) { break OuterLoop }
    }
    Clear-Host
    Write-Host 'INTERNET ACCESS IS NOT AVAILABLE'
}

Clear-Host

Write-Host 'INTERNET ACCESS IS AVAILABLE'

if (!([string]::IsNullOrEmpty($PlayWav.SoundLocation))) {
    $PlayWav.PlayLooping()
}

read-host 'Press ENTER to continue and stop alarm...'

$PlayWav.Stop()
