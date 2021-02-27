CREATE PROCEDURE [dbo].[CalculateBNPIR853Totals]
	@startDate date,
	@endDate date
AS
BEGIN

DECLARE @temp TABLE 
(
	clientid INT, 
	Foldername nvarchar(200), 
	clientName nvarchar(200), 
	IRD int, 
	PIR float, 
	fundCode nvarchar(200), 
	fundName nvarchar(200), 
	trust nvarchar(200), 
	startDate DATE, 
	endDate DATE, 
	taxableIncome float,
	nonTaxableIncome float,
	foreignTaxCredits float,
	dividendWithholdingPayments float,
	residentWithholdingTax float,
	imputationCredits float,
	deductibleExpenses float,
	formationLossesUsed float,
	landLossesUsed float,
	investorAccountRebates float,
	investorAccountExpenses float,
	netPayable float
)

INSERT INTO @temp
exec dbo.CalculateBNPIR853TaxCertificateData @startDate, @endDate

select 
	ROUND(SUM(taxableIncome), 2) taxableIncomeTotal, -- Column H
	ROUND(SUM(foreignTaxCredits), 2) + ROUND(SUM(imputationCredits), 2) taxCreditsTotal, -- column I
	ROUND(SUM(netPayable), 2) netPayable,
	ROUND(SUM(CASE WHEN PIR = 0 THEN 0 ELSE taxableIncome END), 2) totalIncomeLossLowMidRate,
	ROUND(SUM(CASE WHEN PIR > 0 THEN foreignTaxCredits + imputationCredits END), 2) totalTaxCreditsLowMidRate,
	ROUND(SUM(CASE WHEN PIR = 0 THEN taxableIncome END), 2) zeroRatedIncomeLoss,
	ROUND(SUM(CASE WHEN PIR = 0 THEN foreignTaxCredits END), 2) zeroRatedFTCs,
	ROUND(SUM(CASE WHEN PIR = 0 THEN imputationCredits END), 2) zeroRatedICs
from @temp

END