#
$TheMessage="$($env:FP__Message__)"
$TheURI="$($env:FP__TheWebhookUrl__)"
$MessageExists = !([string]::IsNullOrWhiteSpace($TheMessage));
$URIExists = !([string]::IsNullOrWhiteSpace($TheURI));
if ($TheMessage -ne 'no message')
    {
    $messageObject  = @{
		text =  @"
From: $($ENV:FP__flyway_user__)
on: $($ENV:FP__flyway_timestamp__)
After migration on $($ENV:FP__flyway_database__)
$($env:FP__Message__) 
"@}
	# Convert the payload object to JSON
	 $messageJson = $messageObject | ConvertTo-Json
	 $postParams = @{ payload = $messagejson }
	 Invoke-RestMethod -Uri "$($env:FP__TheWebhookUrl__)" -Method POST -ContentType "application/json" -Body $postParams
    $env:FP__Message__='No message'
    }
if (!$MessageExists) {Write-warning "No default message Exists"} 
if (!$MessageExists) {Write-warning "No $URIExists Exists"} 