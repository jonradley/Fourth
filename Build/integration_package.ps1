$currentPath = Split-Path $MyInvocation.MyCommand.Path
$repository = Split-Path -Path $currentPath -Parent
$ffd = Join-Path $repository 'FFDefinitionXML'
$stylesheets = Join-Path $repository 'Stylesheets'
$output = Join-Path $currentPath 'Output'
$zipfilename = Join-Path $currentPath 'Output\HOSP-EU-Intgration.zip'

if (test-path $zipfilename) {
	rm $zipfilename 
	rm $output -recurse
}

$temp = Join-Path $output 'Temp'

New-Item $output -ItemType directory
New-Item $temp -ItemType directory

Copy-Item $ffd $temp -recurse
Copy-Item $stylesheets $temp -recurse

[Reflection.Assembly]::LoadWithPartialName("System.IO.Compression.FileSystem")
$compressionLevel = [System.IO.Compression.CompressionLevel]::Optimal
[System.IO.Compression.ZipFile]::CreateFromDirectory($temp,$zipfilename, $compressionLevel, $false)