/*
 Pre-Deployment Script Template							
--------------------------------------------------------------------------------------
 This file contains SQL statements that will be executed before the build script.	
 Use SQLCMD syntax to include a file in the pre-deployment script.			
 Example:      :r .\myfile.sql								
 Use SQLCMD syntax to reference a variable in the pre-deployment script.		
 Example:      :setvar TableName MyTable							
               SELECT * FROM [$(TableName)]					
--------------------------------------------------------------------------------------
*/

/*						
--------------------------------------------------------------------------------------				
Pre-Deployment Script - START
--------------------------------------------------------------------------------------
*/
	
	/*
	--------------------------------------------------------
	1.PreDeployment.Updates.sql - START
	--------------------------------------------------------
	*/
		PRINT '		1.PreDeployment.Updates.sql - START'
GO

/*
This will be executed during the pre-deployment phase.
Use it to apply scripts for all actions that cannot be easily and 
consistently done using just the database project.

Note that the pre-deployment scripts are just prepended to the
generated script.

!!!Make sure your scripts are idempotent(repeatable)!!!

Example invocation:
EXEC sp_execute_script @sql = 'UPDATE Table....', @author = 'Your Name'
*/


GO

		PRINT '		1.PreDeployment.Updates.sql - END'
GO
	/*
	--------------------------------------------------------
	1.PreDeployment.Updates.sql - END
	--------------------------------------------------------
	*/

/*						
--------------------------------------------------------------------------------------				
Pre-Deployment Script - END
--------------------------------------------------------------------------------------
*/
GO
