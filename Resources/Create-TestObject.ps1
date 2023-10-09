<#
	.SYNOPSIS
		Parses a SQL test script into individual statements or queries and assigns then to one of four categories
	
	.DESCRIPTION
		This is a way of providing a single script that can be tested in a SQL IDE and then saved as an object  such as JSON)  so that indivifual statements can be run and times, and
	
	.PARAMETER Content
		A description of the Content parameter.
	
	.PARAMETER Terminator
		The statement terminator you use for SQL
	
	.EXAMPLE
		PS C:\> Create-TestObject
	
	.NOTES
		Additional information about the function.
#>
function Create-TestObject
{
	[CmdletBinding()]
	[OutputType([array])]
	param
	(
		[Parameter(Position = 1,Mandatory = $true)]
		[string]$Content,
		[Parameter(Position = 2)]
		$Terminator = ';' # The statement terminator you use for SQL
	)
	
	switch ($Terminator)
	{
		'GO' { $TerminatorLength = 2 } #Meaning you delete it
		default { $TerminatorLength = 0 } #Meaning you leave it there
	}
	$Tasks = @()
	if ($Terminator -eq 'GO')
        { $TerminatorLength = 2}
    else
        {$TerminatorLength=0}  #Meaning you leave it there
	$ExecuteAllQuantity = 1;
	$ExecuteNextQuantity = $ExecuteAllQuantity;
	$PauseAllQuantity = $PauseNextQuantity;
	
	$RegexForInterpretingExecution = [regex]@'
(?i)(?m)^(?<ExecuteOrPause>EXECUTE|PAUSE){1,10}\s(?#
what you do )(?<AllOrNext>ALL|NEXT)\s{1,10}(?#
how many times)(?<Quantity>\d{1,10})\s{0,10}(?#
ignore this)(?<TimesOrSecs>TIMES|SECS)?\s{0,5}(?#
do we do it random order?)(?<RandomOrSerial>randomly|serially)?
'@
	Tokenize_SQLString $Content | where {
		$_.value -eq $Terminator -or $_.name -eq 'BlockComment'
	} | foreach -begin { $State = 'Act'; $StartIndex = 0 } {
		if ($_.value -eq $Terminator)
		{
			$EndIndex = $_.Index;
			$Tasks += @{
				'State' = $State;
				'Times' = $ExecuteNextQuantity;
				'PauseBefore' = $PauseNextQuantity;
				'Expression' = "$($Content.Substring($StartIndex, $EndIndex - $StartIndex - $TerminatorLength))"
			};
			
			$StartIndex = $EndIndex + $TerminatorLength;
			$ExecuteNextQuantity = $ExecuteAllQuantity;
			$PauseNextQuantity = $PauseAllQuantity;
		}
		else
		{
			$CommentText = $_.Value -ireplace '(?s)\A\s*/\*\s*(?<TheComment>.*)\s*\*/\s*\z', '${TheComment}'
			if ($CommentText.Trim() -in ('Arrange', 'Act', 'Assert', 'Teardown'))
			{
				$State = $CommentText.Trim()
			}
			else
			{
				if (($CommentText.Trim() -like 'Execute*') -or ($CommentText.Trim() -like 'Pause*'))
				{
					if ($CommentText.Trim() -imatch $RegexForInterpretingExecution)
					{
						$ExecuteOrPause = $matches.ExecuteOrPause;
						$Action = $matches.AllOrNext;
						$Quantity = $matches.Quantity;
						$How = $matches.RandomOrSerial;
						if ($ExecuteOrPause -eq 'pause')
						{
							if ($Action -eq 'Next') { $PauseNextQuantity = $Quantity }
							else { $PauseAllQuantity = $Quantity }
						}
						if ($ExecuteOrPause -eq 'Execute')
						{
							if ($Action -eq 'Next') { $ExecuteNextQuantity = $Quantity }
							else { $ExecuteAllQuantity = $Quantity; $RandomOrSerially = $How; }
						}
					}
				}
			}
		}
	}
	@{
		'TheOrder' = $SectionAction;
		'Times' = $ExecuteAllQuantity;
		'Pause' = $PauseAllQuantity
		'Tasks' = $Tasks
	} #End foreach token
}

