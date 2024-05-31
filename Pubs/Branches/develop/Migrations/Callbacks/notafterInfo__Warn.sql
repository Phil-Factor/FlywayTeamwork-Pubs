Select  'beware of ${parameter}' as "warning"

IF (1=${MyOption})
	BEGIN 
	SELECT 'We have executed the code that you specified 
by setting the placeholder to 1' 
	END
ELSE 
	BEGIN 
	SELECT 'We have executed something else because you 
set the placeholder to something that wasn''t 1 '
	END	

${MySQL}