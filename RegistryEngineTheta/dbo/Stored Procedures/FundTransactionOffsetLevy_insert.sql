

create PROCEDURE [dbo].[FundTransactionOffsetLevy_insert]
	@fundId INT,
	@valuationDate DATE,
	@inflowLevy FLOAT,
	@outflowLevy FLOAT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DELETE FROM FundTransactionOffsetLevy
	WHERE
		fundId=@fundId
		AND valuationDate=@valuationDate

	INSERT INTO dbo.FundTransactionOffsetLevy ( 
		fundId ,
		valuationDate ,
		inflowLevy ,
		outflowLevy 
	)
	VALUES ( 
		@fundId , 
	    @valuationDate , 
	    @inflowLevy, 
	    @outflowLevy 
	)

END

