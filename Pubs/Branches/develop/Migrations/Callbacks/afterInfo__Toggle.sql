/*
Before this code can be used in a callback, you must have the following
default value for flyway.placeholders.Toggle set in the project flyway.conf
otherwise you'll get an error.
	flyway.placeholders.Toggle=Yes 
To turn the toggle on, use flyway.placeholders.Turnit=on otherwise
flyway.placeholders.Turnit=on
in the commandline, this will look like …
flyway info '-placeholders.Toggle=Yes' '-placeholders.Turnit=on' 

*/

IF ('${Toggle}' = 'Yes')
  BEGIN --only execute this if flyway.placeholders.Toggle=Yes
    IF ('on' = '${TurnIt}') --if flyway.placeholders.Turnit=on
      BEGIN /* the start of the block that you excecute to switch
	  the toggle on */
        SELECT 'We have executed the code for turning the feature on';
      END;
    ELSE IF ('off' = '${TurnIt}')--if flyway.placeholders.Turnit=off
      BEGIN /* the start of the block that you excecute to switch
	  the toggle off */
        SELECT 'We have executed the code for turning the feature off';
      END;
    ELSE
      BEGIN
        SELECT 'We couldn''t recognise your ''${TurnIt}'' instructiions';
      END;
  END;


