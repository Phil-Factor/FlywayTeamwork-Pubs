# it is sometimes useful to test to make sure 
# that your placeholders are there
'These are the Flyway environment variables
'
gci env:FLYWAY_* | sort-object name
'
These are the Flyway built_in and custom placeholders
'
gci env:FP__* | sort-object name
Write-warning "beware of $($env:FP__parameter__) "
Write-warning "$env:watery"
Write-warning "$env:wateryness"