#Rename all subtitle file name to match video files name
param(
    [string]$Path
)

function get-NthTwoNumber {
    param (
        [string] $word,
        [int] $N
    )
    $reg = '\d\d'
    $count = 0
    for ($i = 0; $i -lt $word.length-1; $i++) {
        $subWord = $word.Substring($i, 2)
        if ($subWord -match $reg) {
            $count++
            if ($count -eq $N) {
                return $subWord
            }
        }
    }
}


#PROGRAM
$lastLocation = Get-Location

if (!([string]::IsNullOrEmpty($Path))) {
    
    if (!(Test-Path $Path)) {
        Write-Error 'Path passed as parameter is not valid'
        return
    }
    
    Set-Location $Path
}

$regex = 's?\d\dx?X?.?-?_?e?\d\d'

$subtitleExtensionArray = '.srt', '.sub', '.sbv'
$videoExtensionArray = '.avi', '.mkv', '.mp4', '.flv', '.swf', '.mov', '.wmv'

$allSubtitleFiles = get-childitem $Path | Where-Object { $subtitleExtensionArray.Contains($_.extension) }
$allVideoFiles = get-childitem $Path | Where-Object { $videoExtensionArray.Contains($_.extension) }

foreach ($sub in $allSubtitleFiles) {
    $s = get-NthTwoNumber -word $sub.name -N 1
    $e = get-NthTwoNumber -word $sub.name -N 2
    Rename-Item $sub -NewName ('s{0}e{1}.{2}' -f $s, $e, $sub.Extension)
}

$allSubtitleFiles = get-childitem $Path | Where-Object { $subtitleExtensionArray.Contains($_.extension) }

foreach ($subFile in $allSubtitleFiles) {
    $subFile.name -match $regex > $null
    $subExtension = $subFile.Extension

    $episode = $Matches[0]
    
    $videoFile = $allVideoFiles | Where-Object { $_.name.ToLower().Contains($episode.ToLower()) }
    $videoName = $videoFile.BaseName

    $newName = $videoName + $subExtension

    Rename-Item $subFile -NewName $newName
}

Set-Location $lastLocation

