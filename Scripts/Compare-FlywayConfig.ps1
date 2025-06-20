<#
.SYNOPSIS
    Compares Flyway CLI-documented configuration items with your own list to detect omissions.

.DESCRIPTION
    Parses the output of `flyway -X` to extract configuration keys.
    Compares it with a user-provided list of documented keys (plain text or CSV).
    Outputs missing or new config items.

.PARAMETER KnownConfigFile
    Path to a file containing one config item per line, like `flyway.locations`

.EXAMPLE
    .\Compare-FlywayConfig.ps1 -KnownConfigFile ".\KnownConfigs.txt"
#>

param (
    [string]$KnownConfigFile = ".\KnownConfigs.txt"
)

# Fetch Flyway CLI help output
$flywayOutput = flyway -h 2>&1

# Parse all configuration keys mentioned in the output
# They usually appear as --key= or key= on separate lines
$configPattern = "(?m)^(?:--)?(?<key>flyway\.[\w\d\.]+)="
$foundConfigKeys = [regex]::Matches($flywayOutput, $configPattern) |
    ForEach-Object { $_.Groups["key"].Value.Trim() } |
    Sort-Object -Unique

# Read the known config keys (one per line)
$knownConfigKeys = Get-Content $KnownConfigFile |
    Where-Object { $_ -match "^flyway\." } |
    ForEach-Object { $_.Trim() } |
    Sort-Object -Unique

# Compare
$missingFromDoc = $foundConfigKeys | Where-Object { $_ -notin $knownConfigKeys }

# Output results
Write-Host "`n🧾 Configuration keys found in Flyway but missing from your list:`n" -ForegroundColor Cyan
$missingFromDoc | ForEach-Object { Write-Host " - $_" }
 