
-------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[IsiFileJob_logJobStart]
(
	@valuationDate Date,
	@runBy varchar(100)
)	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from interfering with SELECT statements.
	SET NOCOUNT ON;	

	INSERT INTO [dbo].[IsiFileJob]
	(
		 valuationDate,
		 runBy,
		 runDate
	)
	VALUES
	(
		@valuationDate, 
		@runBy,
		GETDATE()
	)

	SELECT SCOPE_IDENTITY() AS Id
 		
END