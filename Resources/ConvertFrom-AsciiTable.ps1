Function ConvertFrom-AsciiTable <# this is a pipeline-aware function that takes as its
input the pipeline input. If it is part of a table, it will parse it into a PS custom
Object and turn the input stream into one or more arreays of pscustom objects that can
then be turned into a JSON file or any other format you want #>
{
	Begin
	{
		# set our variables at the start
		$State = 'first'; $Keys = @(); $Data = @(); $Result = @(); $ResultSet = @();;
	}
	Process
	{
		#for each line passed to the component ....
		if ($State -eq 'done')
		{
			$Result = @();
			$State = 'first'
		}
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
				$ResultSet += ,$Result;
				$Result = @()
			} #
			else
			{
				#read the line into a hashtable
                $column=1;
				$data = ($_.trim('|')).split('|') | foreach{ $_.trim().Replace('&#124;', '|') };
				$Datarow = @{ } #Save every element
				1 .. $keys.count | foreach {
                $TheKey='Column '+ $column++;
                if ($Keys[$_ - 1] -ne $null){ $TheKey= $Keys[$_ - 1]}
                $DataRow.Add($TheKey, $data[$_ - 1]) };
				$Result += [psCustomObject]$Datarow
			}
		}
	}
	End
	{
		if ($Result.Count -gt 0) { $ResultSet += ,$Result }
		$ResultSet;
	}
}