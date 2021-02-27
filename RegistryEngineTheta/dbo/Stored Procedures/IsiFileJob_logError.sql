
-------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[IsiFileJob_logError]
(
	@jobId int,
	@errorMessage varchar(Max)
)	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from interfering with SELECT statements.
	SET NOCOUNT ON;	

	UPDATE IsiFileJob
	SET success = 0,
		errorMessage = @errorMessage
	WHERE isiFileJobid = @jobId

	SELECT @@RowCount As RowsUpdated
 		
END
