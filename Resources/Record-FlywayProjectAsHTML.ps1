<#
	.SYNOPSIS
		Records the SQL migration files as a directory of  colourised HTML files, and tells you of any files altered, deleted or added.
	
	.DESCRIPTION
		This routine will write out every SQL Migration file as colourised HTML in a directory, with a page 
        listing them in version order with a hyperlink to the colourised SQL file. It will tell you if it 
detects any change, such as insertion, amendment or deletion, and maintains a log 
	
	.PARAMETER LocationOfTheProject
		The path to the flyway project
	
	.EXAMPLE
		    Record-FlywayProjectAsHTML -LocationOfTheProject 'c:\Users\Phil\Github\Pubs'
            Record-FlywayProjectAsHTML -TheDbDetails $DbDetails
            Record-FlywayProjectAsHTML
	
#>
function Record-FlywayProjectAsHTML
{
	[CmdletBinding()]
	param
	(
		[Parameter(Mandatory = $False)]
		[hashtable]$TheDBDetails,
		[Parameter(Mandatory = $false)]                 
		[string]$LocationOfTheProject

	)
	
	Begin
	{
	 if ($TheDBDetails -eq $null)
        {
        if ($LocationOfTheProject -ne $null)
              {    	cd $LocationOfTheProject
		    . "$Env:FlywayWorkPath\Scripts\preliminary.ps1" # we are using the framework just to get a comprehensive list of file locations
              $TheDBDetails=$TheDBDetails
              }
        else
            {
            Write-Error "you must either provide the DBDetails for the project  as a parameter or the LocationOfTheProject parameter"
            }
        }
		
	}
	Process
	{
		
		# you can customse this HTML header with your preferences 
		$Catalogue =@"
<!DOCTYPE html>
<html>
<head>
    <title>$($TheDBDetails.project) $($TheDBDetails.Branch) branch ($($TheDBDetails.projectDescription)) </title>
<style>
  body{ font-family:Consolas, courier,sans-serif ;}
   td {padding-left:10px;padding-right:10px}
</style>
</head>
<body>
<p>Files for $($TheDBDetails.project) ($($TheDBDetails.projectDescription))</p>

<table>

"@
		$Hashes = @(); <# Our hashes which eventually get stored with the HTML directory
 so we can see if a file has changed.#>
		$Log = @() # we log all changes
		# the location of the HTML is arbitrary, and can be set anywhere
		$Site = "$($TheDBDetails.reportlocation)\Current\code"
		# Create the location if it doesn't exist
		If (-not (Test-Path $Site -PathType Container))
		{ $null = New-Item -ItemType Directory -Path $Site -Force }
		# Create a backup directory if ncessary
		If (-not (Test-Path "$Site\backup" -PathType Container))
		{ $null = New-Item -ItemType Directory -Path "$Site\backup" -Force }
		# Delete the existing content 
		Del "$Site\backup\*.*" -Force -Recurse #delete the current backup
		Move-Item -Path "$Site\*.*" -Destination "$Site\backup" #move any existing content
		if (Test-Path "$Site\backup\Hashes.json" -PathType leaf) # get the existing hash table
		{
			#Read in the hash table and record the date 
			$LastRecord = (dir "$Site\backup\Hashes.json").LastWriteTime
			$OldHashes = Get-content -raw "$Site\backup\Hashes.json" | convertfrom-json
		}
		else #no hash table exists
		{
			$LastRecord = get-date
			$OldHashes = @() # there is no previous record
		}
        #now we run a pipeline that does each migration file in turn
		# Split the location list into locations
		$TheDBDetails.locations -split ',' |
		foreach{ $_ -replace 'filesystem:', '' } | # for each location
		foreach{ Dir "$_\V*.sql" -Recurse } | # for each relevant file
		foreach{
			if ($_.Name -imatch '(?m:^)(?<Type>.)(?<Version>.*)__(?<Description>.*)\.')
			{
				[pscustomobject]@{
					'name' = $_.BaseName;
					'Path' = $_.FullName;
					'Type' = $matches['Type'];
					'Version' = [version]$matches['Version'];
					'Description' = $matches['Description'];
					'hash' = (Get-filehash $_.FullName -Algorithm MD5).Hash
				}
			}
			else
			{
				Write-error "Mis-named file '$($_.Name)'"
			} #get them all sorted in increasing version
		} | Sort-Object -Property @{ Expression = "version"; Descending = $false } |
		foreach {
			# for each migration file in turn we do this (with the file object)
<# do we actually need to create this #>
			$what = $_
			$State = 'unchanged'; # until proven otherwise
			$ThisHash = $what.Hash; $ThisName = $what.Name;
            $ThatHash=@{} #the hash of the backup file
            write-verbose "processing '$Thisname'"
			$Hashes += @{ 'Hash' = $ThisHash; 'Name' = $ThisName } #add to the hashes
			$GotToCreateIt = $True; #assume that we have to create it
            if ($OldHashes.count -eq 0) {$State = 'unknown'}
                else
                {
                $ThatHash = $oldHashes | where { $_.Hash -eq $ThisHash }
                 # has it got a match for the hash?
			    if ($ThatHash -ne $nUll) #it got a match
	            {
		            if (Test-Path "$Site\backup\$($ThatHash.Name).HTML" -PathType leaf)
                        {
                        $GotToCreateIt = $False; #assume that it is available
		                Copy-Item "$Site\backup\$($ThatHash.Name).HTML" -Destination "$site\$ThisName.HTML"
                        }
		            $ThatName = $ThatHash.Name
                    if ($ThatName -ne $ThisName) {$State='renamed'}
	            }			
                else
			    { #it wasn't the same hash so something has changed
				    $GotToCreateIt = $True;
				    $FileExists = $oldHashes | where { $_.Name -eq $ThisName }
				    if ($FileExists -ne $Null) { $State = 'changed Content' }
				    else
				    { $State = 'new file' }
			    }
            }
			$TypeDescription = switch ($what.Type)
			{
				'U' { 'Undo' }
				'R' { 'Repeatable' }
				'B' { 'Baseline' }
				'V' { 'Versioned' }
				default { 'Unknown Type of' }
			}
			$FileDescription = "$TypeDescription file for $($what.Description) - version $($what.Version)"
			if ($GotToCreateIt)
			{
				write-verbose "generating $FileDescription."
				if (($oldHashes | where { $_.Name -eq $ThisName }) -ne $nUll)
				{
					$State = 'Content changed';
					$Log += "Existing file $ThisName has changed contents since $LastRecord";
				}
				else
				{
					if ($State -ne 'unknown')
                        {
                        $State = "New file since $LastRecord"
					    $Log += "New file $ThisName created since $LastRecord";
                        }
                    else
                        {
                        $Log += "first time $ThisName seen"
                        }
				}
				#we first find out what type it is 
				$OutputFile = "$Site\$ThisName.HTML"
				$HTMLHeader = "<!DOCTYPE html>
    <html>
    <head>
        <title>$FileDescription</title>
    </head>
    <body>
        <p>$($_.Version) version - $($TheDBDetails.Branch) branch of $($TheDBDetails.Project) at $LastRecord</p>
        <pre>"
				Convert-SQLtoHTML  (Get-Content -Raw $What.Path) -TheTitle $FileDescription  -HTMLHeader $HTMLHeader  > $OutputFile
			}
			Else # it has already been done and hasn't changed
			{
				$ThatName = $ThatHash.Name
				if ($ThisName -eq $ThatName)
				{
					$State = 'Unchanged'
					$Log += "$ThisName  is $State"
				}
				else
				{
					$state = "renamed from $Thatname"
					$Log += "$Thatname has been changed to $Thisname"
					Copy-Item "$Site\backup\$ThatName.HTML" -Destination "$site\$ThisName.HTML"
				};
            }
				
			$Catalogue += @"
    <tr>
		    <td>$TypeDescription</td>
		    <td><a href="file:///$OutputFile">$($What.Name)</a></td>
            <td>$State</td>
	    </tr>
"@
		}
		#Now we can write out the catalogue
		$Catalogue += @"
</table>

</body>
</html>
"@
		$NewNames = $Hashes | foreach{ $_.Name }
		$OldHashes | where { $_.Name -notin $Newnames } | Foreach { $Log += "file $($_.Name)has been deleted or renamed since $LastRecord" }
		
		$Catalogue > "$Site\catalogue.HTML"
		$Hashes | ConvertTo-json > "$Site\Hashes.json"
		$Log | ConvertTo-json > "$Site\Log.json"
	}
	End
	{
		
	}
}
