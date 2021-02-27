CREATE PROCEDURE [dbo].[CalculateBNPIR853TaxCertificateData]
	@startDate DATE,
	@endDate DATE
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @clientList table (clientId INT)
	
	INSERT INTO @clientList VALUES (856),(1849),(1931),(907),(1931),(5946),(1942),(856),(1821),(2401),(6103),(6104),(6105),(6114),(2029),(2327),(1955),(6029),(6171),(1909),(2057)
		-- clientList values are the values found in the TaxableComponentsWholesaleGroup workbook.

	SELECT 
		u.ID clientid,
		u.Foldername,
		u.Client clientName,
		u.IRD,
		u.PIR,
		i.fundCode,
		cm.BNPFundName fundName,
		'KIMWMT' as trust,
		@startDate startDate,
		@endDate endDate,
		ROUND(SUM(taxableincome),2)  taxableincome,ROUND(SUM(Nontaxableincome),2) nonTaxableIncome,
		ROUND(SUM(ForeignTaxCredits),2) foreignTaxCredits, ROUND(SUM(DividendWithholdingPayments),2) dividendWithholdingPayments,
		ROUND(SUM(ResidentWithholdingTax),2) residentWithholdingTax,ROUND(SUM(ImputationCredits),2) imputationCredits,
		ROUND(SUM(DeductibleExpenses),2) deductibleExpenses,
		ROUND(SUM(FormationLossesUsed),2) formationLossesUsed,
		ROUND(SUM(LandLossesUsed),2) landLossesUsed,
		ROUND(SUM(InvestorAccountRebates),2) investorAccountRebates, 
		ROUND(SUM(InvestorAccountExpenses),2) investorAccountExpenses,
		ROUND(CASE WHEN u.PIR = 0 THEN 
			0
		ELSE
			CASE WHEN (SUM(taxableincome) * u.PIR) > (SUM(ForeignTaxCredits) + SUM(ImputationCredits)) THEN
				ROUND((ROUND(SUM(taxableincome),2) * u.PIR), 2) - (ROUND(SUM(ForeignTaxCredits), 2) + ROUND(SUM(ImputationCredits),2))
			ELSE	
				0
			END
		END, 2) netPayable
	FROM bnp.dbo.ISIDataDailyAllocation i
	INNER JOIN gmiTestDb.dbo.users u ON u.Foldername = i.portfolio
	INNER JOIN gmiTestDb.dbo.custodianmapping cm ON cm.BNPFundCode = i.fundCode and cm.isCurrent = 1
	WHERE fundValuationDate BETWEEN @startDate and @endDate 
		AND u.id IN (select clientId FROM @clientList)
		AND u.Foldername NOT IN ('lifetimefi','lifetimeieq','oneroa') -- will take care of lifetimefi/lifetimeieq/oneroa folders. These ports are excluded in the BNP IR853 Calculation
	GROUP BY u.ID, u.Foldername, i.fundCode, cm.BNPFundName, u.Client, u.IRD, u.PIR

END