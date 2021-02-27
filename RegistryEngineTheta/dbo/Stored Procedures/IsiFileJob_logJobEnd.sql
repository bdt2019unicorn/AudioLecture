
-------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[IsiFileJob_logJobEnd]
(
    @jobId int,
    @isiFileCount int = 0,
    @priceFilePath varchar(255) = '', 
    @priceFileName varchar(100) = '', 
    @resultsMessage varchar(2000) = ''
)	
AS
BEGIN

	SET NOCOUNT ON;	

	UPDATE IsiFileJob
	SET isiFileCount = @isiFileCount,
		priceFilePath = @priceFilePath,
		priceFileName = @priceFileName,
		success = 1,
		resultsMessage = @resultsMessage
	WHERE isifileJobId = @jobId

	SELECT @@RowCount As RowsUpdated
 		
END
