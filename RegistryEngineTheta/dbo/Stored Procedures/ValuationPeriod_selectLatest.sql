-- =============================================
-- Author:		Dave
-- Create date: 12 Sep 12
-- Description:	Returns the current rebalance object
-- =============================================
CREATE PROCEDURE [dbo].[ValuationPeriod_selectLatest]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	select TOP 1 * 
	from ValuationPeriod 
	order by valuationDate desc

    
END

