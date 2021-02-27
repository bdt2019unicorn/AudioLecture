-- ===================================================================
-- Author:		Jason
-- Create date: 18/6/2019
-- Description:	Procedure sums daily (KIMWMT) and weekly (KWMT) taxable components from each database and provide these totals. Date ranges for this are driven of the clients tax year end. 
-- ===================================================================

CREATE PROCEDURE [dbo].[ISITaxComponentsTYTD_select]

	@priceDate DATE, 
	@clientid int 

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

DECLARE @eoyTaxDate int = (select eoy_balance_month from gmi_users where id = @clientid)
	DECLARE @valuationDate DATE = @priceDate
	DECLARE @StartOfYear DATE =  Dateadd(month,1,DATEFROMPARTS(CAST(YEAR(@ValuationDate) AS VARCHAR(4)),@eoyTaxDate,1))

	IF @StartOfYear > @ValuationDate 
	BEGIN
		SET @StartOfYear = DATEADD(YEAR, -1, @StartOfYear);
	END

	------------------------------------------- KW (GMI) REGISTRY ----------------------------------------------------------------------------
SELECT
				mt.memberid clientid,
				cast(mt.pieId as varchar) fundcode,
				f.fundname,
				'KIMMT' as trust,
				@StartOfYear as 'taxYearStartDate',
				mt.valuationDate,

				-- For valuation date.
				--ROUND(mt.closingTaxableAmount,2) TaxableIncome,
				ROUND((SELECT SUM(taxableAmount) FROM MemberTax WHERE memberid = u.id AND pieId = mt.pieId AND valuationDate BETWEEN @startOfYear AND @valuationDate),2) taxableIncome,
				ROUND(0.00,2) nonTaxableIncome,
				--ROUND(mt.closingFTC,2) ForeignTaxCredits,
				ROUND((SELECT SUM(ftc) FROM MemberTax WHERE memberid = u.id AND pieId = mt.pieId AND valuationDate BETWEEN @startOfYear AND @valuationDate),2) foreignTaxCredits,
				--ROUND(mt.DWP,2) DividendWithholdingPayments,
				ROUND((SELECT SUM(dwp) FROM MemberTax WHERE memberid = u.id AND pieId = mt.pieId AND valuationDate BETWEEN @startOfYear AND @valuationDate),2) dividendWithholdingPayments,
				--ROUND(mt.RWT,2) ResidentWithholdingTax,
				ROUND((SELECT SUM(rwt) FROM MemberTax WHERE memberid = u.id AND pieId = mt.pieId AND valuationDate BETWEEN @startOfYear AND @valuationDate),2) residentWithholdingTax,
				--ROUND(mt.IC,2) ImputationCredits,	
				ROUND((SELECT SUM(IC) FROM MemberTax WHERE memberid = u.id AND pieId = mt.pieId AND valuationDate BETWEEN @startOfYear AND @valuationDate),2) imputationCredits,
				ROUND((SELECT SUM(tolAmount) FROM MemberTax WHERE memberid = u.id AND pieId = mt.pieId AND valuationDate BETWEEN @startOfYear AND @valuationDate),2) deductibleExpenses,
			0 formationLossesUsed,
			0 landLossesUsed,
			0 investorAccountRebates,
			0 investorAccountExpenses

			FROM
			MemberTax mt 
			INNER JOIN gmi_users u on u.id = mt.memberid
			INNER JOIN fund f on f.pieid = mt.pieid
			WHERE mt.valuationDate = @ValuationDate
				AND u.id = @clientid

				UNION ALL

---------------------------------------------------------- BNP ISI DATA START------------------------------------------------------------------------------------------------------------------
select 
u.id,
a.fundcode,
m.BNPFundName fundname,
'KIMWMT' as trust,
@StartOfYear as 'taxYearStartDate',
@valuationDate as 'valuationdate',

				ROUND((SELECT SUM(taxableincome) FROM bnp_ISIDataDailyAllocation WHERE portfolio = u.foldername AND fundCode = m.BNPFundCode AND fundvaluationDate BETWEEN @startOfYear AND @valuationDate ),2) taxableIncome,
			
				ROUND((SELECT SUM(Nontaxableincome) FROM bnp_ISIDataDailyAllocation WHERE portfolio = u.foldername AND fundCode = m.BNPFundCode AND fundvaluationDate BETWEEN @startOfYear AND @valuationDate ),2) nonTaxableIncome,
		
				ROUND((SELECT SUM(ForeignTaxCredits) FROM bnp_ISIDataDailyAllocation WHERE portfolio = u.foldername AND fundCode = m.BNPFundCode AND fundvaluationDate BETWEEN @startOfYear AND @valuationDate ),2) foreignTaxCredits,
		
				ROUND((SELECT SUM(DividendWithholdingPayments) FROM bnp_ISIDataDailyAllocation WHERE portfolio = u.foldername AND fundCode = m.BNPFundCode AND fundvaluationDate BETWEEN @startOfYear AND @valuationDate ),2) dividendWithholdingPayments,
				
				ROUND((SELECT SUM(ResidentWithholdingTax) FROM bnp_ISIDataDailyAllocation WHERE portfolio = u.foldername AND fundCode = m.BNPFundCode AND fundvaluationDate BETWEEN @startOfYear AND @valuationDate ),2) residentWithholdingTax,
				
				ROUND((SELECT SUM(ImputationCredits) FROM bnp_ISIDataDailyAllocation WHERE portfolio = u.foldername AND fundCode = m.BNPFundCode AND fundvaluationDate BETWEEN @startOfYear AND @valuationDate ),2) imputationCredits,
				
				ROUND((SELECT SUM(DeductibleExpenses) FROM bnp_ISIDataDailyAllocation WHERE portfolio = u.foldername AND fundCode = m.BNPFundCode AND fundvaluationDate BETWEEN @startOfYear AND @valuationDate ),2) deductibleExpenses,
				
				ROUND((SELECT SUM(FormationLossesUsed) FROM bnp_ISIDataDailyAllocation WHERE portfolio = u.foldername AND fundCode = m.BNPFundCode AND fundvaluationDate BETWEEN @startOfYear AND @valuationDate ),2) formationLossesUsed,
				
				ROUND((SELECT SUM(LandLossesUsed) FROM bnp_ISIDataDailyAllocation WHERE portfolio = u.foldername AND fundCode = m.BNPFundCode AND fundvaluationDate BETWEEN @startOfYear AND @valuationDate ),2) landLossesUsed,
				
				ROUND((SELECT SUM(InvestorAccountRebates) FROM bnp_ISIDataDailyAllocation WHERE portfolio = u.foldername AND fundCode = m.BNPFundCode AND fundvaluationDate BETWEEN @startOfYear AND @valuationDate ),2) investorAccountRebates,

				ROUND((SELECT SUM(InvestorAccountExpenses) FROM bnp_ISIDataDailyAllocation WHERE portfolio = u.foldername AND fundCode = m.BNPFundCode AND fundvaluationDate BETWEEN @startOfYear AND @valuationDate ),2) investorAccountExpenses


			From bnp_ISIDataDailyAllocation a
			INNER JOIN gmi_users u on u.foldername = a.portfolio
			INNER JOIN gmi_custodianmapping m on m.BNPFundCode = a.fundCode and isCurrent = 1 --and BNPFundCode <> ''
			WHERE a.fundvaluationDate = @valuationDate
				AND u.id = @clientid


---------------------------------------------------------- BNP ISI DATA END------------------------------------------------------------------------------------------------------------------

 


END

