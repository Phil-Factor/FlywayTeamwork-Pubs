<#
	.SYNOPSIS
		Gets the files of a git release, either the latest one or, if you specify the tag, the release that has that tag.
	
	.DESCRIPTION
		This is a, hopefully, reliable way of getting the latest release from Github, or a specific release. There are several examples on the internet but I couldn't get any to work. Git changes the protocol, but if you can get the correct path of the zip-ball of the files, you have a better chance.
	
	.PARAMETER RepoPath
		A description of the RepoName parameter.
	
	.PARAMETER credentials
		A description of the credentials parameter.
	
	.PARAMETER tag
		A description of the tag parameter.
	
	.PARAMETER TargetFolder
		A description of the DestinationFolder parameter.

	
	.EXAMPLE
		PS C:\> Get-TaggedGitRelease 
	
	.NOTES
		Additional information about the function.
#>
function Get-TaggedGitRelease
{
	[CmdletBinding()]
	param
	(
		[Parameter(Mandatory = $true,
				   ValueFromPipeline = $true,
				   Position = 1)]
		[string]$RepoPath,
		#We must know the owner and repository

		[Parameter(Mandatory = $false,
				   Position = 2)]
		[string]$credentials,
		[Parameter(Mandatory = $false,
				   Position = 3)]
		[string]$tag,
		[Parameter(Mandatory = $false,
				   Position = 4)]
		[string]$TargetFolder
	)
	-process {
	$RepoName = $repoPath -split '[\\/]' # get the owner and repo
	$owner = $RepoName[0]; $repository = $RepoName[1]; $CredentialFile = $RepoName -join '_'
	#now fetch the credentials from the user area
	$CredentialLocation = "$env:UserProfile\$CredentialFile.txt"
		if ($credentials -ne $null)
		{
			$credentials > "$CredentialLocation" #assume it is a first time }
			else
			{
				#fetch existing credentials
				if (($credentials -eq $null) -and (Test-Path "$($CredentialLocation)"))
				{ $credentials = Get-Content $CredentialLocation }
				else
				{ Write-Error "Could not find a credential. Github needs a credential to authorise this" }
			}
			$ZipBallFolder = "$env:TMP\$repository\"
			if ($TargetFolder -eq $null)
			{ $TargetFolder = "$env:UserProfile\$repo\scripts" }
			$headers = New-Object "System.Collections.Generic.Dictionary[[String], [String]]"
			$headers.Add("Authorization", "token $credentials")
			$releases = "https://api.github.com/repos/$repo/releases"
			$TheInformation = Invoke-WebRequest $releases -Headers $headers
			
			$ReleaseList = $TheInformation.content | convertFrom-json
			if ($tag -eq $null)
			{
				$TheLatest = $ReleaseList.GetEnumerator() | foreach{
					$Badverion = $false; #We need to be able to sort this - assume the best
					if ($_.tag_name -cmatch '\D*(\d([\d\.]){1,40})')
					{
						$Version = $matches[1]
					}
					else { $Badverion = $true; }
					if (!($Badverion))
					{
						try { $Version = [version]$Version }
						catch { $Badverion = $true }
					}
					if ($Badversion) { write-error "sorry but you must use numeric versions to get the latest" }
					[pscustomobject]@{
						'Tag' = $_.tag_name;
						'Version' = $Version;
						'Location' = $_.zipball_url
					}
				} | Sort-Object -Property version -Descending | select -First 1
				$Tag = $TheLatest.Tag;
				$location = $TheLatest.Location;
				
			}
			else
			{
				$location = $ReleaseList.GetEnumerator() |
				where { $_.tag_name -like $Tag } |
				select zipball_url -ExpandProperty 'zipball_url'
				
			}
			
			#we now have the tag and the location
			if (($location -eq $null) -or ($Tag -eq $null))
			{ write_error "could not find that tagged release" }
			else
			{
				Write-verbose "Downloading release $Tag to $ZipBallFolder"
				# $headers.Add("Accept", "application/octet-stream")
				# make sure that the folder is there
				if (-not (Test-Path "$($ZipBallFolder)"))
				{ $null = New-Item -ItemType Directory -Path "$($ZipBallFolder)" -Force }
				#now get the zip file 
				Invoke-WebRequest -Uri $location -Headers $headers -OutFile "$($ZipBallFolder)$Tag.zip"
				Write-Host "Extracting release files"
				Expand-Archive "$($ZipBallFolder)$Tag.zip" -DestinationPath $TargetFolder -Force
				Remove-Item "$($ZipBallFolder)$Tag.zip" -Force
			}
		}
	}
}