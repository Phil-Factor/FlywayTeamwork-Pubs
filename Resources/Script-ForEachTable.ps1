<#
	.SYNOPSIS
		Scripts a SQL routine for each table in the database
	
	.DESCRIPTION
		This script supplies a sql script that does whatever you specify in
	
	.PARAMETER Template
		the actual template you want with  '??' where you wish the actual 
        table names to be substituted.
	
	.PARAMETER PathToModel
		the paath to the JSON file containing the model 
	
	.PARAMETER ReverseOrder
		Do you wish to have the tables with no dependencies first or last.  
	
	.EXAMPLE
		PS C:\> Script-ForEachTable - -Template 'Select count(*) from $$'  PathToModel '<MyPathTo>\Pubs\Versions\current\Reports\DatabaseModel.JSON'
	
	.NOTES
		Additional information about the function.
#>
function Script-ForEachTable
{
	[CmdletBinding()]
	param
	(
		[Parameter(Mandatory = $true,
				   ValueFromPipeline = $true,
				   Position = 1,
				   HelpMessage = 'the actual template you want with  ?? where you wish the actual table names to be substituted.')]
		[string]$Template,
		[Parameter(Mandatory = $true,
				   Position = 2)]
		[string]$PathToModel,
		[Parameter(Position = 3)]
		[boolean]$ReverseOrder = $true
	)
	
	$model = [IO.File]::ReadAllText($PathToModel) #read the json text of the model
	try { $DB = $model | convertfrom-json } #convert it into a powershell model 
	catch { Write-error "The JSON model at $PathToModel isn't valid JSON" };
	$TablesInDependencyOrder = $DB | Sort-TablesIntoDependencyOrder;
	if ($ReverseOrder) { [array]::Reverse($TablesInDependencyOrder) } #Reverse the array.
	$TablesInDependencyOrder | foreach {
		$Template -ireplace '\?\?', $_;
	}
}