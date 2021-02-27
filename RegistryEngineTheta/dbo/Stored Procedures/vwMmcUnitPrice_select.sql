
-------------------------------------------------------------------------
-- Returns price file data for a valuation data
-------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[vwMmcUnitPrice_select]
(
	@valuationDate date
)	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from interfering with SELECT statements.
	SET NOCOUNT ON;

    SELECT fundId ,
		fundName,
		priceDate,
		navPrice,
		buyPrice,
		sellPrice,
		CAST(taxableIncomePerUnit AS Decimal(18,10)) AS taxableIncomePerUnit,
		CAST(foreignTaxCreditsPerUnit AS Decimal(18,10)) AS foreignTaxCreditsPerUnit,
		CAST(dividendWithholdingPaymentsPerUnit AS Decimal(18,10)) AS dividendWithholdingPaymentsPerUnit,
		CAST(residenceWithholdingTaxPerUnit AS Decimal(18,10)) AS residenceWithholdingTaxPerUnit,
		CAST(imputationCreditsPerUnit AS Decimal(18,10)) AS imputationCreditsPerUnit		
  FROM vwMmcUnitPrice
  WHERE priceDate = @valuationDate
  ORDER BY fundId
		
END