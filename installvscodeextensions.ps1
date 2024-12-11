Get-Content "$PSScriptRoot\VsCodeExtensions\extensions.txt" | ForEach-Object {
    code --install-extension $_
}