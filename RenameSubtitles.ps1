#Rename all subtitle file name to match video files name
param(
    [string]$path
)

$lastLocation = Get-Location

if (Test-Path $path) {
    Set-Location $path
}

$regex = 's\d\de\d\d'

$subtitleExtensionArray = '.srt', '.sub', '.sbv'
$videoExtensionArray = '.avi', '.mkv', '.mp4', '.flv', '.swf', '.mov', '.wmv'

$allSubtitleFiles = get-childitem 'D:\Bojack Horseman Season 1 Webrip XviD' | Where-Object {$subtitleExtensionArray.Contains($_.extension)}
$allVideoFiles = get-childitem 'D:\Bojack Horseman Season 1 Webrip XviD' | Where-Object {$videoExtensionArray.Contains($_.extension)}



foreach ($subFile in $allSubtitleFiles) {
    $subFile.name -match $regex > $null
    $subExtension = $subFile.Extension

    $episode = $Matches[0]
    
    $videoFile = $allVideoFiles | Where-Object {$_.name.ToLower().Contains($episode.ToLower())}
    $videoName = $videoFile.BaseName

    $newName = $videoName + $subExtension

    Rename-Item $subFile -NewName $newName
}

Set-Location $lastLocation