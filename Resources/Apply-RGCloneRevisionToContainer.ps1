<#
   .SYNOPSIS
      Creates a revision in a RGClone container for the current version of a
        Flyway Database if one doesn't already exist. The user must be authenticated
        to use RGClone using rgClone auth
   
   .DESCRIPTION
      Now we save the version if we haven't already done so, and if so, then
      we update our tally file that records the version that corrsponds with
      each Flyway revision
        This requires that RGClone is installed and working. You need to tell the
        function the name of the project whickh includes the name of the database
        the project, the 'engine' (RDBMS) and the branch. That gives the routine 
        the name of the credentials .CONF file that resides in the user area 
   
   .PARAMETER CloneProject
      The Name of the Clone Project
   
   .EXAMPLE
      PS C:\> Apply-RGCloneRevisionToContainer -CloneProject 'Pubs-TestRevisioning-mssql-develop'
   
#>
function Apply-RGCloneRevisionToContainer
{
   [CmdletBinding()]
   param
   (
      [string]$CloneProject
   )
<# Set Powershell to save files in UTF-8. This keeps you out of trouble 
when writing files that are then read by Flyway. #>
   $PSDefaultParameterValues['Out-File:Encoding'] = 'utf8'
   $Credentials = "$env:USERPROFILE\" + (($CloneProject -split '-' | select -first 4) -join '_') + '.conf'
   $ContainerName = "$CloneProject-container"
<# we get the current version number #>
   Write-Verbose "Establishing the current Flyway schema version"
   # get the connection details and credentials and pass them to Flyway
   $Output = Get-content $Credentials -Raw | flyway info -configFiles=-
   $Match = ([regex]'Schema version: (?<Version>[\d\.]{1,30})').matches($Output)
   if ($Match.Count -gt 0) #we've got a revision back
   {
      $currentversion = ($Match.Groups | where { $_.Success -and $_.name -eq 'Version' }).Value
   }
   else
   {
      if ($output -like '*<< Empty Schema >>*') { $currentversion = '0.0' }
      else
      { Write-Warning "No match for version from Flyway Info" }
   }
   Write-Verbose "The current Flyway version is $CurrentVersion"
<#
Now we save the version if we haven't already done so, and if so, then
we update our tally file that records the version that corresponds with
each Flyway revision
#>
   #calculate the name of the tally file that we should be using
   $CurrentCloneRevisionRecord = "$pwd\$($ContainerName)Record.json"
   #if it exists, then read it in
   if (Test-Path -Path $CurrentCloneRevisionRecord -PathType Leaf)
   { $RevisionRecord = [array](Get-content $CurrentCloneRevisionRecord -Raw | ConvertFrom-json) }
   else #create the array of hashtables
   { $RevisionRecord = @() }
   #now have we a record of this version being saved as a revision in RGClone?
   $Failed = $false; $Failure = '' #so far.. so far...
   if (($RevisionRecord | where{ $_.Version -eq $CurrentVersion }) -eq $null)
   {
      #OK. No record of it, so we need to add it
      $Feedback = rgclone save data-container $ContainerName #Save this version
      if ($LastExitCode -eq 7) { $Failed = $true; $Failure = "Not currently authenticated" }
      if ($LastExitCode -ne 0) { $Failed = $true; $Failure = "Error $LastExitCode in rgClone" }
      if (!($Failed)) # unless we hit problems
      {
         $Match = ([regex]"New revision is '(?<Revision>.{1,30}?)'").matches($feedback)
         if ($Match.Count -gt 0) #we've got a revision back
         {
            $Revision = ($Match.Groups | where { $_.Success -and $_.name -eq 'Revision' }).Value
            if ($Revision -notlike 'rev*')
            {
               $Failed = $true; $Failure = "unknown format of revision '$revision'"
            }
         }
         else
         {
            $Failure = "RG Clone didn't return a 'success message, just '$feedback'"
            $Failed = $true
         }
      }
      if (-not $failed)
      {
         $RevisionRecord += @{ 'Version' = $CurrentVersion; 'Revision' = $Revision }
         $RevisionRecord | ConvertTo-JSON -depth 2 > $CurrentCloneRevisionRecord
         Write-Verbose "This version $CurrentVersion saved to $ContainerName  as revision  '$Revision'"
      }
      else
      {
         Write-warning $Failure
      }
   }
   else
   {
      Write-Verbose "This version $CurrentVersion is already saved as a revision"
   }
} 
