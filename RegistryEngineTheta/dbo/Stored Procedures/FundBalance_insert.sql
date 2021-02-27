
create PROCEDURE [dbo].[FundBalance_insert]
	-- Add the parameters for the stored procedure here
	@fundId INT,
	@endDate DATE,
	@startDate DATE, 
	@startDollarAmount DECIMAL(18,2),      
	@startUnitPrice DECIMAL(18,4),      
	@startUnitAmount DECIMAL(18,4),     
	@transferUnitAmount DECIMAL(18,4),     
	@endUnitAmount DECIMAL(18,4),      
	@endUnitPrice DECIMAL(18,4),     
	@endDollarAmount  DECIMAL(18,2) 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DELETE FROM dbo.FundBalance
	WHERE 
		endDate=@endDate
		AND fundId=@fundId


	INSERT INTO dbo.FundBalance
	(
	    fundId,
	    endDate,
	    startDate,
	    startDollarAmount,
	    startUnitPrice,
	    startUnitAmount,
	    transferUnitAmount,
	    endUnitAmount,
		endUnitPrice,
	    endDollarAmount
	)
	VALUES
	(   
		@fundId,         -- fundId - int
	    @endDate, -- endDate - date
	    @startDate, -- startDate - date
	    @startDollarAmount,      -- startDollarAmount - decimal(18, 2)
	    @startUnitPrice,      -- startUnitPrice - decimal(18, 4)
	    @startUnitAmount,      -- startUnitAmount - decimal(18, 4)
	    @transferUnitAmount,      -- transferUnitAmount - decimal(18, 4)
	    @endUnitAmount,      -- endUnitAmount - decimal(18, 4)
	    @endUnitPrice,      -- endDollarAmount - decimal(18, 2)
	    @endDollarAmount       -- endUnitPrice - decimal(18, 4)
	)
	
	
END
