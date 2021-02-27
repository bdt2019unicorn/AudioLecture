-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
create PROCEDURE [dbo].[ValuationPeriod_selectAllEom] 

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT 
		* 
	FROM 
		ValuationPeriod
	WHERE
		isMonthEnd=1
	order by 
		valuationDate desc
END

