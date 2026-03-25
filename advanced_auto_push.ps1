$repoPath = "D:\SEM-4\WEb\Git"
Set-Location $repoPath

# Add a timestamp to the overall log
$dateStr = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
Add-Content -Path "auto_commit.log" -Value "----------------------------------------"
Add-Content -Path "auto_commit.log" -Value "Run started at $dateStr"

# 1. Get all folders in this directory (exclude the .git hidden folder)
$folders = Get-ChildItem -Directory | Where-Object { $_.Name -ne ".git" }

if ($folders.Count -eq 0) {
    Add-Content -Path "auto_commit.log" -Value "ERROR: No folders found to make commits in."
    exit
}

# 2. Pick one random folder from the list
$selectedFolder = $folders | Get-Random

# 3. Choose a random number of commits between 3 and 4
$commitCount = Get-Random -Minimum 3 -Maximum 5

Add-Content -Path "auto_commit.log" -Value "Selected folder: $($selectedFolder.Name)"
Add-Content -Path "auto_commit.log" -Value "Commits to make: $commitCount"

# 4. Loop to make the commits one by one
for ($i = 1; $i -le $commitCount; $i++) {
    
    # Path to a dummy file inside the selected folder to make "anonymous" changes
    $dummyFile = Join-Path $selectedFolder.FullName "activity_log.txt"
    $currentTime = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $randomHash = [guid]::NewGuid().ToString()

    # Append a new line so Git detects a change
    Add-Content -Path $dummyFile -Value "Automated system check at $currentTime | ID: $randomHash"

    # Git commands to stage and commit just this change
    git add $dummyFile
    git commit -m "Update automated logs in $($selectedFolder.Name) (Update $i)"
    
    Add-Content -Path "auto_commit.log" -Value "  -> Commit $i successful."

    # Sleep for 2 seconds so the timestamps on the commits are slightly different
    Start-Sleep -Seconds 2
}

# 5. Finally, push all the new commits to GitHub
Add-Content -Path "auto_commit.log" -Value "Pushing to GitHub..."
git push >> auto_commit.log 2>&1

Add-Content -Path "auto_commit.log" -Value "Finished successfully at $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"
