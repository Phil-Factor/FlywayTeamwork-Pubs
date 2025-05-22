<#
	.SYNOPSIS
		Returns the file path and type of file 
        (filename, classpath,Amazon S3 or Google Cloud Storage.)
	
	.DESCRIPTION
        uses the captured output of Flyway Info in debug mode (-X) to get a list
        of files that Flyway can detect within the location set by the project configuration
        parameters or environment variables.
        These locations are mentioned several times so duplicate filenames must be removed.
        The  debug report we get from Flyway Info -X is quite slow to arrive so I usually do
        it just once per session and use it when required.

	.PARAMETER $TheReport
        the captured output of Flyway Info in debug mode (-X)

    .PARAMETER $Types
        The list of filetypes you want to select (with a default of all script types no SQL)

    .usage
        cd "$env:FlywayWorkPath\pubs"
        $currentCredentialsPath = '-configFiles=C:\Users\AtillaTheHun\Pubs_SQLServer_develop_MyServer.toml,'
        $TheReport= flyway $currentCredentialsPath info -X
        ."$env:FlywayWorkPath\scripts\GetFlywayFilesAndTypes.ps1" $TheReport	
#>
param (
    [array]$TheReport,
    [array]$Types=@('ps1','bat','cmd','sh','py')
)

$TypeChoices= ($types|foreach{"\.$_"}) -join '|'
([regex]@"
DEBUG: (Found script callback: |Filtering out resource: |Found script configuration: |Found filesystem resource: )(?#
Capture pathAndfilename and type separately)(?<Filepath>.{3,})(?<Type>($TypeChoices))( \(filename|(?m:$))
"@).matches($TheReport -join "`n").Groups|foreach{ $Value=$_.Value;
    switch ($_.name){ 'FilePath'{$filepath =$Value} 
                      'Type' {"$filepath$Value"}
                       default { }}}|sort-object  -unique

