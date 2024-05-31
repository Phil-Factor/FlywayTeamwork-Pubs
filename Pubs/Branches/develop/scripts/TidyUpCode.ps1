param ($InputFile)
# now convert all the SQLcmd output and other things not allowed
      $script = [IO.File]::ReadAllText($InputFile)
      
      @(
        @(@'
:setvar __IsSqlCmdEnabled "True"
GO
IF N'$(__IsSqlCmdEnabled)' NOT LIKE N'True'
    BEGIN
        PRINT N'SQLCMD mode must be enabled to successfully execute this script.';
        SET NOEXEC ON;
    END
'@, ''),
        @(@'
GO
USE [$(DatabaseName)];
'@, '')
      ) | foreach {
        $Script = $script.replace($_[0], $_[1])
      }
# remove code to create schemas This has to be done by a regex
$Script = $Script -creplace ':setvar.*|:on error exit', ''
$Script = $Script -creplace '(\n|\r)+\s(\n|\r)+', "`n"
$Script = $Script -creplace '(?s)PRINT N''Creating Schema \[.{1,256}?\]...'';\s+?GO\s+?CREATE SCHEMA \[.{1,256}?\].+?GO', ''
# and write the script back
[System.IO.File]::WriteAllLines($InputFile, $script);
