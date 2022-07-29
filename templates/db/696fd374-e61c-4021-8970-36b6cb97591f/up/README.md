# Up scripts

* __One-time scripts__ (Must create a new script for each change)

Normal table creations, etc

1. DDL (schema changes - database structure)
1. DML (inserts/updates/deletes)


## How does the order work?

grate always runs files in order alphabetically.

## How should I name my scripts?

One should prepend your order specific scripts with either a number moving upwards padded with three zeros (i.e. `0001_somescript.sql` followed by `0002_nextscript.sql`) or a nice long date time in YYYYMMddHHmmss format (i.e. `20121026091400_somescript.sql` followed by `20121026091401_nextscript.sql`), but you are not limited to those options. Some people do a separation by numbers as in `####.##.##.####` or something else. Find what works for you (and your team) and use it.

## Errors
If there is a change to a one time script and the migrator is run, RH will determine you have changed that file and will shut down immediately with errors.  That being said, there is a configuration setting to allow you to still run with warnings. Although not recommended, RH tries not to be a tool that constrains users.  
