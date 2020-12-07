# -------------- 
# Set params
# --------------
 
$BuildName =  'AdventureWorks' #$OctopusParameters["BuildName"]
$ServerName = $OctopusParameters["ServerName"]
$DatabaseName = $OctopusParameters["DatabaseName"]
$DbUsername = $OctopusParameters["DbUsername"]
$DbPassword = $OctopusParameters["DbPassword"]
 
$ConnectionString = "Server= $ServerName; Database= $DatabaseName; User ID= $DbUsername; Password= $DbPassword"
 
Write-Host "This build will deploy: " $BuildName " to Server: " $ServerName
 
try {
    # Load in DAC DLL (requires config file to support .NET 4.0)
    Add-Type -path "C:\Program Files (x86)\Microsoft Visual Studio\2017\SQL\Common7\IDE\Extensions\Microsoft\SQLDB\DAC\130\Microsoft.SqlServer.Dac.dll"
 
    # Make DacServices object
    #$d = New-Object Microsoft.SqlServer.Dac.DacServices "Server = $ServerName; Data-base = $DatabaseName; Integrated Security = True;";
    $d = New-Object Microsoft.SqlServer.Dac.DacServices $ConnectionString
 
    # Register events (this will write info messages to the Task Log)
    Register-ObjectEvent -in $d -EventName Message -Source "msg" -Action { Out-Host -in $Event.SourceArgs[1].Message.Message} | Out-Null
 
    # Get dacpac file
    $dacpac = (Get-Location).Path + "Content" + $BuildName + ".dacpac"
    # 'Content' is from the nuget package that is created. So, you cannot see it on the local directory
 
    # Load dacpac from file & deploy to database
    $dp = [Microsoft.SqlServer.Dac.DacPackage]::Load($dacpac)
 
    # Set the DacDeployOptions
    $options = New-Object Microsoft.SqlServer.Dac.DacDeployOptions -Property @{
       'BlockOnPossibleDataLoss' = $true;
       'DropObjectsNotInSource' = $false;
       'ScriptDatabaseOptions' = $true;
    }
 
    Write-Host "Generating deployment script"
 
    # Generate the deployment script
    $deployScriptName = $BuildName + ".sql"
    $deployScript = $d.GenerateDeployScript($dp, $DatabaseName, $options)
 
    # Write the script out to a file
    $deployScript | Out-File $deployScriptName
 
    Write-Host "Deploying dacpac"
    # Deploy the dacpac
    $d.Deploy($dp, $DatabaseName, $true, $options)
 
    # Clean up event
    Unregister-Event -Source "msg"
 
    Write-Host "Successfully deployed"
    exit 0 # Success
}
catch {
    Write-Host ($_ | ConvertTo-Json)
     
    # Called on terminating error. $_ will contain details
    exit 1 # Failure
}