$visualStudioProductPath = vswhere -latest -property productPath

$installDir = [System.IO.Path]::GetDirectoryName($visualStudioProductPath)

$vsixInstallerPath = [System.IO.Path]::Combine($installDir, "VSIXInstaller.exe")

& "$vsixInstallerPath" "/quiet" "$PSScriptRoot\VsExtensions\VsVim.vsix"

Copy-Item -Path "$PsScriptRoot\_vsvimrc" -Destination $env:UserProfile