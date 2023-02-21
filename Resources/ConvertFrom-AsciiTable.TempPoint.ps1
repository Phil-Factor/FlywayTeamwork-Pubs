Function ConvertFrom-AsciiTable
{
	Begin
	{
		# set our variables at the start
		$State = 'first'; $Keys = @(); $Data = @(); $Result = @()
	}
	Process
	{
		#for each line passed to the component ....
		if ($State -eq 'done') { $State = 'first' }
		if ($State -eq 'first') #we keep things simple via a state machine
		{
			$state = 'keys';
		}
		elseif ($State -eq 'line')
		{ $state = 'data'; }
		elseif ($State -eq 'keys')
		{
			#grab the keys into a list
			$Keys = ($_.trim('|')).split('|') | foreach{ $_.trim() }
			$state = 'line';
		}
		elseif ($State -eq 'data') #so we've got a data line
		{
			if ($_ -like '[+]*')
			{
				$state = 'done';
			} #
			else
			{
				#read the line into a hashtable
				$data = ($_.trim('|')).split('|') | foreach{ $_.trim().Replace('&#124;', '|') };
				$Datarow = @{ } #Save every element
				1 .. $keys.count | foreach { $DataRow.Add($Keys[$_ - 1], $data[$_ - 1]) };
				$Result += [psCustomObject]$Datarow
			}
		}
	}
	End { $Result }
}

