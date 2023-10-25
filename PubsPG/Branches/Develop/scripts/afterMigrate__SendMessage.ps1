<#
Before using this, write two placeholders in your flyway.conf file. It can easily go
in the flyway.conf file in your user area.

   flyway.placeholders.Message=no message
   flyway.placeholders.TheWebhookUrl=https://<Whatever_webhook_you've_been_Assigned>


Send a message that is placed in the placeholder 'Message'. This will normally be 
placed in the FP__Message__ environment variable.

You specify a message at the command-line like this

   flyway migrate "-placeholders.Message=Ran a Pubs migration for Oracle" 
if you want to expressly prevent a message set it to 'No message'

#>
$TheMessage = "$($env:FP__Message__)"
$TheURI = "$($env:FP__TheWebhookUrl__)"
$MessageExists = !([string]::IsNullOrWhiteSpace($TheMessage));
$URIExists = !([string]::IsNullOrWhiteSpace($TheURI));
if ($TheMessage -ne 'no message')
{
	$messageObject = @{
		text =  @"
From: $($ENV:FP__flyway_user__)
on: $($ENV:FP__flyway_timestamp__)
After migration on $($ENV:FP__flyway_database__)
$($env:FP__Message__) 
"@
	}
	# Convert the payload object to JSON
	$messageJson = $messageObject | ConvertTo-Json
	$postParams = @{ payload = $messagejson }
	Invoke-RestMethod -Uri "$($env:FP__TheWebhookUrl__)" -Method POST -ContentType "application/json" -Body $postParams
	$env:FP__Message__ = 'No message'
}
if (!$MessageExists) { Write-warning "No default message Exists" }
if (!$URIExists) { Write-warning "No $URIExists Exists" }