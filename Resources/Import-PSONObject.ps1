$TestingImportPSONObject=$False;
<#
	.SYNOPSIS
		Converts from PSD1 (PSON) to an object
	
	.DESCRIPTION
		Takes a string of object notation and converts
    it into an object safely. It will not execute random
    Powershell - only object notation
	
	.PARAMETER contents
	The string containing the PowerShell object notation.
	
	.EXAMPLE
	Import-PSONObject -fileName 'MyFileOfPSON'
	
.NOTES
		returns a hash table by default but you can specify
        the object type in Powershell object notation.

		
#>
function Import-PSONObject
{
	[CmdletBinding()]
	param
	(
		[Parameter(Mandatory = $true)]
		$Filename
	)
	
	$content = Get-Content -Path $Filename -Raw -ErrorAction Stop
	$allowedCommands = @('Get-Content', 'Invoke-Expression')
	# Convert the array to a List<string> using array cast
	$allowedCommandsList = [System.Collections.Generic.List[string]]($allowedCommands)
	$lookingDodgy = $false
	$scriptBlock = [scriptblock]::Create($content)
	try
	{
		$scriptBlock.CheckRestrictedLanguage($allowedCommandsList, $null, $true)
	}
	catch
	{
		$lookingDodgy = $True
		Write-error "$Filename is not Valid Powershell Object Notation!"
	}
	if (!($lookingDodgy)) { $scriptBlock.invoke() }
	
}

if ($TestingImportPSONObjec)
    {
    $filePath = "$env:Temp\test.pson"
    @(
        @"
        @{
        Name = 'This Example should be OK'
        Value = 42
    }
"@,
        @"
        Write-Output 'This should not be allowed'
"@,
        @"
        Set-Content -Path 'output.txt' -Value 'This should not be allowed'
"@,
        @"
        function Test-Function {
            param (`$param1)
            Write-Output `$param1
        }
        Test-Function -param1 'This should not be allowed'
"@,
    @"
    @{
	    Name = 'Philip J Factor'
	    Age = 75
	    Skills = @('PowerShell', 'SQL', 'C#', 'Python')
	    Address = @{
		    Street = '123 Main St'
		    City = 'Nearyou Somewhere'
		    Postcode = 'DF4 6GU'
	    }
    }

"@
    ) | foreach{
	    Write-verbose "Executing $($_)"
	    $_ > $filePath
	    $TheObject = Import-PSONObject $filePath -ErrorAction SilentlyContinue
	    if ($TheObject -eq $Null) { write-warning "test data was rejected" }
	    else { write-output "test data was allowable" }
    }
    if (Test-Path $filePath)
    {
	    Remove-Item $filePath
    }
}