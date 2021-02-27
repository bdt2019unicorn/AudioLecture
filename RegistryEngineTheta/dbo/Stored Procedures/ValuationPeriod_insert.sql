-- =============================================
-- Author:		Dave
-- Create date: 1 June 2012
-- Description:	Called from the rebalancing application
-- =============================================
CREATE PROCEDURE [dbo].[ValuationPeriod_insert] 
	@valuationDate smalldatetime
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @isMonthEnd BIT = 0
	IF EOMONTH(@valuationDate)= @valuationDate
	BEGIN
		SET @isMonthEnd=1
	END	

    -- insert if there is not already an existing rebalance
    if ((select top 1 valuationDate from ValuationPeriod where valuationDate=@valuationDate) is null) begin
		insert into ValuationPeriod (valuationDate, isMonthEnd)
		values (@valuationDate, @isMonthEnd)
    end
END

