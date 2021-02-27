
CREATE PROCEDURE [dbo].[MemberFundTransfer_insertFromPiebook]
	@fundId INT,
	@memberId INT,
	@valuationDate DATE,
	@tolUnitAmount DECIMAL(18,4),
	@tolDollarAmount DECIMAL(18,2),
	@transferUnitAmount DECIMAL(18,4), --gross amount
	@transferDollarAmount DECIMAL(18,2), --gross amount
	@tradeDate DATE = NULL
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;


	--TOLS need to be negative!
	IF @tolUnitAmount>0 
	BEGIN
		SET @tolUnitAmount = @tolUnitAmount * -1.0000
		SET @tolDollarAmount = @tolDollarAmount * -1.00
	end


	IF @transferUnitAmount<0 --outflow tol - requires the transfer amount to have the tol taken out of it.
	BEGIN 
		SET @transferUnitAmount = @transferUnitAmount-@tolUnitAmount
		SET @transferDollarAmount = @transferDollarAmount-@tolDollarAmount
	END
  

	INSERT INTO dbo.MemberFundTransfer
	(
	    fundId,
	    memberId,
	    valuationDate,
	    tolUnitAmount,
	    tolDollarAmount,
	    transferUnitAmount,
	    transferDollarAmount,
		tradeDate
	)
	VALUES
	(   
	    @fundId,        
	    @memberId,         
	    @valuationDate,
		@tolUnitAmount,
	    @tolDollarAmount,
	    @transferUnitAmount,
	    @transferDollarAmount,
		@tradeDate
	)
END