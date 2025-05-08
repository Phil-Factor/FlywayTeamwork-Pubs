<#
	.SYNOPSIS
		Returns the file path and type of file 
        (filename, classpath,Amazon S3 or Google Cloud Storage.)
	
	.DESCRIPTION
		uses the output of Searches through the list of Flyway  locatiopns you specify for all the migrations of the type you can specify. If it finds a reference to the object you specify it displays it in context (you can specify the number of lines  in the context 
	
	.PARAMETER locations
		the array (not list)  of locations
	
	.PARAMETER ObjectName
		The name of the object
	
	.PARAMETER MigrationType
		A description of the MigrationType parameter.
	
	.PARAMETER LinesBefore
		A description of the LinesBefore parameter.
	
	.PARAMETER LinesAfter
		A description of the LinesAfter parameter.
	
	.NOTES
		Additional information about the function.
#>
param (
    [array]$Report
)
([regex]@"
(?#Look for particular debug lines 
)DEBUG: (Found script callback: |Filtering out resource: |DEBUG: Found script configuration: )(?#
Pick up the file path)(?<Filename>.*?)\((?<Type>.*?):.*?(?m:$)
"@).matches($TheReport -join "`n").Groups|foreach{ $Value=$_.Value;
    switch ($_.name){ 'Type' {[pscustomObject]@{'Filename'=$filename; 'Type'=$Value}; $filename=$null }
                      'Filename'{$filename =$Value } default { }}}|sort-object Filename -unique



