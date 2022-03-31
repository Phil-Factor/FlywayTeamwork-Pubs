# FlywayTeamwork
###  Powershell-based Database Development with Branches using Flyway

This is a sample  Flyway framework for supporting  database development with Flyway. It currently supports  PostgreSQL, SQL Server, MySQL, MariaDB and SQLite. If you clone it, you will have a playground for trying Flyway out. 

This framework is designed to make it easier to use PowerShell scripts and callbacks of various kinds. This project has gradually evolved to support an expanding series of articles all about Flyway.  It  uses the old Pubs database, originally a demo database from Sybase. The whole purpose is  to demonstrate and explore the features of Flyway. However, it should be very useful for anyone starting out to develop scripts for use with Flyway because it is otherwise hard to get started. In this version called FlywayTeamwork, we’ve expanded the system to make it suitable for enterprise-scale developments,  diversified its support for a range of relational databases and rearranged the directory structure to a hierarchical one to accommodate the practice of branching. Although designed with GIT in mind, and currently used with GIT, it is designed to be able to work with any reasonable source control system. It does not rely on the source control system to accomodate branching- it can do it intrinsically. 

We’re using the following model of branching. 

![FlywayHierarchy](https://user-images.githubusercontent.com/917048/152835501-ddc5c01a-c707-45b3-b5d3-e4e20efb8108.png)

Within each branch is held all the migrations, scripts, models and reports. Each branch therefor has the same  names and purpose for its subdirectories. The sub-branches of any branch are contained in a ‘branches’ directory. 

We’ve also used the Current Working Directory or ’current location’. This means that the PowerShell must make the branch being worked on the current working directory $pwd. (think CD or Set-Location).  This allows all the server and database connection details to be kept in the branch folder.  It also means that a user can switch between branches merely by changing location/$pwd. The password is either stored or retrieved from the user area as a secure string, and is located by Server, User_ID and RDBMS (it is possible to have two different REDBMS on the same server)  The user-based Flyway.Conf file will need to store the user name (the ‘*installedBy*’  parameter) if you need to change this, you can over-ride the default identity with a command-line parameter or an environment variable. 

Another change is to allow several database project in the one project collection.  This has been flagged up as a potential problem by teams wanting to use Flyway.  Each database is in a directory whose name is the name of the project. This allows us to store all scripts, modules  and  routines that are to be used universally within the same project to be in just one place. This avoids a potential maintenance nightmare as these need updating.

All this requires that every PowerShell script that does a flyway action has to have an initialisation so that all the scriptBlocks, functions, cmdlets and so on are read in, and the context of the PowerShell script can be worked out. It puts all the data that it gathers into a hashtable that is easily available to the script.

All the examples of scripts, migration scripts (used in the course of a migration), and callback scripts have been altered accordingly. By using an initialisation, it has been possible to standardise these. 

The current catalog of supported tasks is here in [The Flyway Teamworks Scriptblocks.](https://github.com/Phil-Factor/FlywayTeamwork-Pubs/blob/main/ScriptBlocks.md)

