$token = "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"
$owner = "matiasmuniz471-pixel"
$repo = "Matias-Mu-iz-Portafolio-Web"
$headers = @{
    "Authorization" = "token $token"
    "Accept"        = "application/vnd.github.v3+json"
}

function Upload-File {
    param (
        [string]$localPath,
        [string]$remotePath
    )
    $fullPath = Join-Path (Get-Location) $localPath
    if (Test-Path $fullPath) {
        Write-Host "Processing $remotePath..."
        $bytes = [System.IO.File]::ReadAllBytes($fullPath)
        $base64Content = [System.Convert]::ToBase64String($bytes)
        
        $bodyObject = @{
            message = "Upload $remotePath"
            content = $base64Content
        }
        
        $url = "https://api.github.com/repos/$owner/$repo/contents/$remotePath"
        
        try {
            # Check if file exists to get SHA (for update)
            $existingFile = Invoke-RestMethod -Uri $url -Headers $headers -Method Get -ErrorAction SilentlyContinue
            if ($existingFile) {
                Write-Host "File exists, updating..."
                $bodyObject["sha"] = $existingFile.sha
            }
        } catch {
            # 404 is expected for new files
        }

        $bodyJson = $bodyObject | ConvertTo-Json -Compress
        
        try {
            $response = Invoke-RestMethod -Uri $url -Headers $headers -Method Put -Body $bodyJson -ContentType "application/json"
            Write-Host "Success: $remotePath"
        } catch {
            $err = $_.Exception.Message
            if ($_.Exception.Response) {
                $reader = New-Object System.IO.StreamReader($_.Exception.Response.GetResponseStream())
                $err = $reader.ReadToEnd()
            }
            Write-Error "Failed $remotePath : $err"
        }
    } else {
        Write-Warning "Local file not found: $fullPath"
    }
}

# Upload files
Upload-File "index.html" "index.html"
Upload-File "contacto.php" "contacto.php"
Upload-File "assets/profile.png" "assets/profile.png"
Upload-File "assets/ecuador.png" "assets/ecuador.png"
Upload-File "assets/cisco.png" "assets/cisco.png"
