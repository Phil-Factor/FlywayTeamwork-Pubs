Set-Alias -Name 'Flyway' -Value 'C:\ProgramData\chocolatey\lib\flyway.commandline\tools\flyway-10.16.0\flyway.cmd'
$VerbosePreference ='Continue' 
$CloneProject=$ENV:FLYWAY_PLACEHOLDERS_CLONEPROJECT
if ($CloneProject -notlike '*-*-*-*'){
    $CloneProject='none';
    Write-Verbose "no revisions will be checked"
    }
    else {Write-Verbose "Checking for revisions for current version  in  $CloneProject-clone"}
if (($CloneProject -ne 'none') -and ($ENV:FLYWAY_PLACEHOLDERS_CREATE_REVISION))
    {
    Apply-RGCloneRevisionToContainer -CloneProject $CloneProject
    }