#Rename all subtitle file name to match video files name
param(
    [string]$Path
)

$lastLocation = Get-Location

if (([string]::IsNullOrEmpty($Path)) -or !(Test-Path $Path)) {
    Write-Error 'Path passed as parameter is not valid'
    return
}
     

Set-Location $Path

$regex = 's\d\de\d\d'

$subtitleExtensionArray = '.srt', '.sub', '.sbv'
$videoExtensionArray = '.avi', '.mkv', '.mp4', '.flv', '.swf', '.mov', '.wmv'

$allSubtitleFiles = get-childitem $Path | Where-Object {$subtitleExtensionArray.Contains($_.extension)}
$allVideoFiles = get-childitem $Path | Where-Object {$videoExtensionArray.Contains($_.extension)}



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
