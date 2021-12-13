#Variables
$directoryToTest = "Unassigned"
$fileInDirectory = "Unassigned"
$currentFile = "Unassigned"
$testedFile = "Unassigned"
$outputDirectory = "Unassigned"

#Directory to look for duplicated files in
Write-Output "Directory to test: (Add '\' at the end)"
$directoryToTest = Read-Host
Write-Output "Testing Directory: "
Write-Output $directoryToTest

#Directory to save relevant txt files to (make sure to add '\' at the end
Write-Output "Ouput text files to this directory: (Add '\' at the end of path)"
$outputDirectory = Read-Host
Write-Output "Text files will be outputted to: "
Write-Output $outputDirectory

#Get files in the testing directory
$filesInDirectory = Get-ChildItem -Recurse -File -Name $directoryToTest
Write-Output $filesInDirectory

#Output those files to a text file
$filesInDirectory | Out-File $outputDirectory"\FilesInDirectory.txt"

#Get number of files in directory
$iterations = (Get-Content $outputDirectory"FilesInDirectory.txt").Length
Write-Output $iterations
#Get the hash and check for duplicates
for ($i = 0; $i -lt $iterations; $i++)
{
    $currentFile = Get-Content $outputDirectory"\FilesInDirectory.txt" | Select -Index $i
    $cfHashValue = Get-FileHash $directoryToTest$currentFile
    Write-Output $cfHashValue" Current;"
    for ($iT = 0; $iT -lt $iterations; $iT++)
    {
        $testedFile = Get-Content $outputDirectory"\FilesInDirectory.txt" | Select -Index ($iT)
        $tfHashValue = Get-FileHash $directoryToTest$testedFile
        Write-Output $tfHashValue
        if (($cfHashValue.Hash -eq $tfHashValue.Hash) -and ($i -ne $iT))
        {
            Write-Output "Duplicate found!!!!!!!!!!!!!!!!"
            $matchFile = ("Original: " + $directoryToTest + $currentFile + "`nDuplicate: " + $directoryToTest + $testedFile)
            $matchFile | Out-File ($outputDirectory + $currentFile)
        }
    }
}

#clean up
Remove-Item -Path ($outputDirectory + "FilesInDirectory.txt")
Write-Output $iterations
