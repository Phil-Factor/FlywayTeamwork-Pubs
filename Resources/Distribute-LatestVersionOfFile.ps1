<#
	.SYNOPSIS
		Finds the latest version of a file and copy it over all other existing copies within the base directory you specify
	
	.DESCRIPTION
		This is a way of ensuring that the latest version of the file is updated everywhere within the directory structure
	
	.PARAMETER BaseDirectories
		the base directory from which to start looking; the location where the alterations can take place.
	
	.PARAMETER Filename
		The name of the file that you want synchronized across the location
	
	.PARAMETER JustListTheLatest
		we just want to see what the latest file is, as a precaution
	
	.EXAMPLE
		Distribute-LatestVersionOfFile '$env:GithubPath' 'DatabaseBuildAndMigrateTasks.ps1'
		Distribute-LatestVersionOfFile '$env:GithubPath' 'preliminary.ps1'
		Distribute-LatestVersionOfFile @("$env:GithubPath","$env:FlywayWorkPath") 'DatabaseBuildAndMigrateTasks.ps1'
		Distribute-LatestVersionOfFile @("$env:GithubPath","$env:FlywayWorkPath") 'DatabaseBuildAndMigrateTasks.ps1' -verbose
        Distribute-LatestVersionOfFile @("$env:GithubPath","$env:FlywayWorkPath") 'preliminary.ps1' -Verbose
        Distribute-LatestVersionOfFile @("$env:GithubPath","$env:FlywayWorkPath") 'DatabaseBuildAndMigrateTasks.ps1' -Verbose
        #Identify the latest version 
        Distribute-LatestVersionOfFile @("$env:GithubPath","$env:FlywayWorkPath") 'preliminary.ps1' -JustListTheLatest $true


#>

function Distribute-LatestVersionOfFile
{
	[CmdletBinding()]
	param
	(
		[Parameter(Mandatory = $true)]
		[string[]]$BaseDirectories,
		[Parameter(Mandatory = $true)]
		[string]$Filename,
		[Parameter(Mandatory = $false)]
		[bool]$JustListTheLatest=$False
	)
	
	$SortedList = @() # the complete list of the locations of the file specified
	$TheListOfDirectories=@()
	$TheListOfDirectories = $BaseDirectories | foreach{ "$($_)\$Filename" }
	#add the filename to each of the directories you specify
	$canonicalVersion = dir $TheListOfDirectories -recurse -OutVariable +SortedList |
	Sort-Object -Property lastWriteTime -Descending |
	select-object -first 1 #we get one of the collection with the latest date
	$VersionDate = $canonicalVersion.LastWriteTime #get the date of the file
	#now update every file of the same name with an earlier date
    if ($JustListTheLatest) {
        write-output $canonicalVersion.Fullname
        }
    else
        {
	    $SortedList |
	    where { $_.LastWriteTime -lt $VersionDate } |
	    foreach{
		    Write-Verbose "Updating $($_.FullName) to the version in $($canonicalVersion.FullName)";
		    Copy-Item -path $canonicalVersion -destination $_ -force
        }
	}
}
