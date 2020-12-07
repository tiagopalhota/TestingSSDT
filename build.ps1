$SSDTToolsPath = $PSScriptRoot + "\build\Microsoft.Data.Tools.Msbuild.16.0.62004.28040\lib\net46"

gci

# These two environments variables are used by the build process to find
# the data tools necessary to do the build
$env:SQLDBExtensionsRefPath=$SSDTToolsPath
$env:SSDTPath=$SSDTToolsPath


# These two environments variables are used by the build process to find
# the data tools necessary to do the build
$env:SQLDBExtensionsRefPath=$SSDTToolsPath
$env:SSDTPath=$SSDTToolsPath

#Path to MSBuild on my machine
$MSBuildPath = "C:\Program Files (x86)\Microsoft Visual Studio\2017\Community\MSBuild\15.0\Bin\MSBuild.exe"


# The name of the project that is going to be built
$SSDTProject = ".\AdventureWorks.sqlproj"


# Execute the command, making sure the PostBuildEvent doesnt
# run in case we forgot to comment it out in the project
& $MSBuildPath $SSDTProject


if($LASTEXITCODE -ne 0)
{

	exit $LASTEXITCODE
}