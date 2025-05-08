<#
    .SYNOPSIS
        Scans Flyway migration files to locate DDL operations on a specified database object.

    .DESCRIPTION
        Traverses the directory structure of one or more Flyway migration locations to identify
        all instances of CREATE or ALTER statements referencing a specified database object. 
        The function supports filtering by migration type (Versioned, Undo, Baseline, or Repeatable), 
        and provides contextual output around each match to assist with auditing or debugging. 
        It recursively searches each location up to a depth of five levels, processes standard 
        Flyway naming conventions to extract metadata, and outputs annotated code snippets 
        showing where and how the object is defined or modified.
        It accepts regex expressionms for the object names
        	
	.PARAMETER locations
		the array (not list)  of locations
	
	.PARAMETER ObjectName
		The name of the object. This can be a regex expression such as 'title.{1,60}?'
	
	.PARAMETER MigrationType
		either V, U, B or R (version, Undo, Baseline and Repeatable
	
	.PARAMETER LinesBefore
		the number if lines of context before the DDL reference to display.
	
	.PARAMETER LinesAfter
		the number if lines of context after the DDL reference  to display..
	
	.NOTES
		Additional information about the function.

    .example
        # must be in working directory as these are relative locations!
        Find-ObjectDDL -objectName 'jobs' @('filesystem:.\Migrations')  
        #if using Flyway Teamwork
        Find-ObjectDDL -objectName 'address' $dbdetails.locations  
        #if using regex expressions for the object (finds CREATE  VIEW 'dbo.TitlesTopicsAuthorsAndEditions')
        Find-ObjectDDL -objectName 'title.{1,120}' $dbdetails.locations
        Find-ObjectDDL -objectName 'title.{1,120}' $dbdetails.locations -plain $false
#>
function Find-ObjectDDL
{
	[CmdletBinding()]
	param
	(
		[Parameter(Mandatory = $true)]
		[string]$ObjectName,
		[Parameter(Mandatory = $true,
				   ValueFromPipeline = $true)]
		[array]$locations,
		[char]$MigrationType = 'V',
		[int]$LinesBefore = 2,
		[int]$LinesAfter = 3,
        [bool]$plain = $true
	)
	
	Begin
	{
    $hits=@();
	$SearchRegex=@"
(alter|create)\s+?(TABLE|VIEW|INDEX|DATABASE|FUNCTION|PROCEDURE)\s+?(?#
after the DDL keyword, the possible schema
)(\[[_\w]+\]\.|[_\w]+\.|"[_\w]+"\.)?(?#
Now for the name of the object
)($ObjectName|"$ObjectName"|\[$ObjectName\])(\s{0,60}|--{0,1})
"@		
	}
	Process
	{
		$Hits = $locations | where { $_ -like 'filesystem:*' } | foreach{
			$result = $_ -creplace '\A\s{0,5}?filesystem:', ''
			dir "$result" -Recurse -Depth 5 | where { $_ -like '[VUBR]*.sql' } | foreach{
				@{
					name = $_.fullname;
					parts = @(($_ -ireplace
							'(?<Type>U|B|V|R)(?<Version>[.\d]+.+)__(?<description>[_\w ]*)',
							'${Type},${Version},${description}') -split ',')
				}
			} | foreach {
				[pscustomobject]@{
					'Path' = $_.Name;
					'Type' = $_.parts[0];
					'version' = [version]$_.parts[1];
					'Description' = $_.parts[2]
				}
			}
		} | sort-object -property type, version | where { $_.type -in $MigrationType } | foreach{
			Select-string -path $_.path -pattern $SearchRegex -Context $LinesBefore, $LinesAfter
		} | foreach {@"
/* line $($_.LineNumber), file: $($_.Filename) */
$($_.Context.PreContext -join "`n")
$($_.Line)
$($_.Context.postContext -join "`n")
"@
		}
	}
	End
	{
	if ($plain){$hits}	
    else{
        $hits|foreach{$_ -split "`n"}|foreach{$color='DarkGreen'}{
                            write-host $_ -ForegroundColor $color -BackgroundColor white;
                            $color= 'black'}
        }
	}
}
