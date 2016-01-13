$currentPath = Split-Path $MyInvocation.MyCommand.Path
$repository = Split-Path -Path $currentPath -Parent
$ffd = Join-Path $repository 'FFDefinitionXML'
$stylesheets = Join-Path $repository 'Stylesheets'
$output = Join-Path $currentPath 'Output'

if (test-path $output) {
	rm $output -recurse -force
}

New-Item $output -ItemType directory

Copy-Item $ffd $output -recurse
Copy-Item $stylesheets $output -recurse