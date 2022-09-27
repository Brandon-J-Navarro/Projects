Get-Command | Where-Object name -eq <#MODULE#>
if (Get-Command -ListImported -Name <#MODULE#>) {
    Write-Host "Module exists"
} 
else {
    Write-Host "Module does not exist, Installing"
    Install-Module -Name <#MODULE#> -Repository PSGallery -Scope CurrentUser -Confirm
}  