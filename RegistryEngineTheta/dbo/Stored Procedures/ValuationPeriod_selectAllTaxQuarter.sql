create PROCEDURE [dbo].[ValuationPeriod_selectAllTaxQuarter] 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here

	SELECT
		*
	FROM dbo.ValuationPeriod
	WHERE valuationDate= DateAdd(Day, -1, DateAdd(quarter,  DatePart(Quarter, DATEADD(DAY,1,valuationDate))-1, '1/1/' + Convert(char(4), DatePart(Year, DATEADD(DAY,1,valuationDate)))))
	ORDER BY
		valuationDate desc

	
END

