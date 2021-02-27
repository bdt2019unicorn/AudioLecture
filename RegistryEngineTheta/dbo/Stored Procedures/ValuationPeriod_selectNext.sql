-- =============================================
-- Author:		Dave
-- Create date: 12 Sep 12
-- Description:	Returns the current rebalance object
-- =============================================
create PROCEDURE [dbo].[ValuationPeriod_selectNext]
	@valuationDate SMALLDATETIME
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	
	SELECT TOP 1 
		* 
	from 
		ValuationPeriod 
	where 
		valuationDate > @valuationDate
	order by 
		valuationDate ASC

    
END

