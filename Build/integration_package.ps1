Param(
  [Parameter(mandatory=$true)][string]$componentname,
  [Parameter(mandatory=$true)][string]$buildnumber
)

$currentPath = Split-Path $MyInvocation.MyCommand.Path
$repository = Split-Path -Path $currentPath -Parent
$ffd = Join-Path $repository 'FFDefinitionXML'
$stylesheets = Join-Path $repository 'Stylesheets'
$output = Join-Path $currentPath 'Output'
$zipfilename = Join-Path $currentPath "Output\$componentname-$buildnumber.zip"

if (test-path $output) {
	rm $output -recurse -force
}

$temp = Join-Path $output 'Temp'

New-Item $output -ItemType directory
New-Item $temp -ItemType directory

Copy-Item $ffd $temp -recurse
Copy-Item $stylesheets $temp -recurse

[Reflection.Assembly]::LoadWithPartialName("System.IO.Compression.FileSystem")
$compressionLevel = [System.IO.Compression.CompressionLevel]::Optimal
[System.IO.Compression.ZipFile]::CreateFromDirectory($temp,$zipfilename, $compressionLevel, $false)