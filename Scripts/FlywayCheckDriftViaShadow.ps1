$Project = 'Pubs' # for working directory and the name of the credentials file
$Branch = 'main' # the shadow database  
$Server = 'Philf01'
$RDBMS = 'SQLServer'
#
#we specify where in the user area we store connections and credentials
$buildCredentialsPath = "$env:USERPROFILE\$($Project)_$($RDBMS)_build_$($Server).toml"
$CurrentCredentialsPath = "$env:USERPROFILE\$($Project)_$($RDBMS)_$($Branch)_$($Server).toml"
$Credentials = "-configFiles=$CurrentCredentialsPath,$BuildCredentialsPath"
$MigrationIDs=flyway $current info -infoOfState="success,out_of_order" -migrationIds
flyway -X check -drift $Credentials -buildEnvironment=build "-appliedMigrations=$MigrationIDs"  

