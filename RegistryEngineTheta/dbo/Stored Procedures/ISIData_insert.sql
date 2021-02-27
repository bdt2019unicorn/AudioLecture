
CREATE PROCEDURE [dbo].[ISIData_insert]
	@priceDate DATE 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @valuationDate DATE = @priceDate

	DECLARE @PrevValuationDate DATE = (SELECT TOP 1 valuationDate FROM ValuationPeriod WHERE valuationDate < @ValuationDate ORDER BY valuationDate DESC);
	DECLARE @StartOfYear DATE = '1 Apr' + CAST(YEAR(@ValuationDate) AS VARCHAR(4))
	IF @StartOfYear > @ValuationDate 
	BEGIN
		SET @StartOfYear = DATEADD(YEAR, -1, @StartOfYear);
	END

	DELETE FROM ISIData
	WHERE valuationDate = @valuationDate


	INSERT INTO ISIData
		(memberId, fundId, valuationDate, TotalUnitsOnIssue, InvestorUnitsHeld, BasePrice, EntryPrice, ExitPrice, TaxableIncome, NonTaxableIncome, ForeignTaxCredits, DividendWithholdingPayments, ResidentWithholdingTax, 
		ImputationCredits, FormationLossesUsed, LandLossesUsed, DeductibleExpenses, InvestorAccountRebates, InvestorAccountExpenses, CPU_TaxableIncome, CPU_NonTaxableIncome, CPU_ForeignTaxCredits, 
		CPU_DividendWithholdingPayments, CPU_ResidentWithholdingTax, CPU_ImputationCredits, CPU_FormationLossesUsed, CPU_LandLossesUsed, CPU_DeductibleExpenses, CPU_InvestorAccountRebates, 
		CPU_InvestorAccountExpenses)


	SELECT

		-- Investor node:
		memberid InvestorId,
		fundId,
		@ValuationDate FundValuationDate,

		-- Balances node:
		FundBalanceUnitAmount TotalUnitsOnIssue,
		MemberFundBalanceUnitAmount InvestorUnitsHeld,

		-- Prices node:
		endUnitPrice BasePrice,
		endUnitPrice EntryOrice,
		endUnitPrice ExitPrice,

		-- Totals node.
		TaxableIncome,
		NonTaxableIncome,
		ForeignTaxCredits,
		DividendWithholdingPayments,
		ResidentWithholdingTax,
		ImputationCredits,
		0 FormationLossesUsed,
		0 LandLossesUsed,
		DeductibleExpenses,
		0 InvestorAccountRebates,
		0 InvestorAccountExpenses,
		-- Replacement Components node.
		ISNULL(MemberTaxDetails.cycleInvestedTaxableIncome,0) / TotalUnitsOnIssue CPU_TaxableIncome,
		0 CPU_NonTaxableIncome,
		ISNULL(MemberTaxDetails.cycleFTC,0) / TotalUnitsOnIssue CPU_ForeignTaxCredits,
		ISNULL(MemberTaxDetails.cycleDWP,0) / TotalUnitsOnIssue CPU_DividendWithholdingPayments,
		ISNULL(MemberTaxDetails.cycleRWT,0)/ TotalUnitsOnIssue CPU_ResidentWithholdingTax,
		ISNULL(MemberTaxDetails.cycleIC,0)  / TotalUnitsOnIssue CPU_ImputationCredits,	
		0 CPU_FormationLossesUsed,
		0 CPU_LandLossesUsed,
		0 CPU_DeductibleExpenses,
		0 CPU_InvestorAccountRebates,
		0 CPU_InvestorAccountExpenses


		FROM (	
			SELECT

				m.portfolioName RetailFundName,		
				f.fundName WholesaleFundName,
				f.fundId,
				fb.endUnitAmount TotalUnitsOnIssue,
				mt.memberid,
				mt.pieId,
				mt.valuationDate,
				fb.endUnitPrice,
				fb.endUnitAmount FundBalanceUnitAmount,
				mfb.endUnitAmount MemberFundBalanceUnitAmount,

				-- For valuation date.
				--ROUND(mt.closingTaxableAmount,2) TaxableIncome,
				ROUND((SELECT SUM(taxableAmount) FROM MemberTax WHERE memberid = m.memberid AND pieId = mt.pieId AND valuationDate BETWEEN @startOfYear AND @valuationDate),2) TaxableIncome,
				ROUND(0.00,2) NonTaxableIncome,
				--ROUND(mt.closingFTC,2) ForeignTaxCredits,
				ROUND((SELECT SUM(ftc) FROM MemberTax WHERE memberid = m.memberid AND pieId = mt.pieId AND valuationDate BETWEEN @startOfYear AND @valuationDate),2) ForeignTaxCredits,
				--ROUND(mt.DWP,2) DividendWithholdingPayments,
				ROUND((SELECT SUM(dwp) FROM MemberTax WHERE memberid = m.memberid AND pieId = mt.pieId AND valuationDate BETWEEN @startOfYear AND @valuationDate),2) DividendWithholdingPayments,
				--ROUND(mt.RWT,2) ResidentWithholdingTax,
				ROUND((SELECT SUM(rwt) FROM MemberTax WHERE memberid = m.memberid AND pieId = mt.pieId AND valuationDate BETWEEN @startOfYear AND @valuationDate),2) ResidentWithholdingTax,
				--ROUND(mt.IC,2) ImputationCredits,	
				ROUND((SELECT SUM(IC) FROM MemberTax WHERE memberid = m.memberid AND pieId = mt.pieId AND valuationDate BETWEEN @startOfYear AND @valuationDate),2) ImputationCredits,
				ROUND((SELECT SUM(tolAmount) FROM MemberTax WHERE memberid = m.memberid AND pieId = mt.pieId AND valuationDate BETWEEN @startOfYear AND @valuationDate),2) DeductibleExpenses,
	
				ROUND((SELECT SUM(taxableAmount) FROM MemberTax WHERE  pieId = mt.pieId AND valuationDate = @valuationDate),2) cycleInvestedTaxableIncome,
				ROUND((SELECT SUM(ftc) FROM MemberTax WHERE pieId = mt.pieId AND valuationDate = @valuationDate),2) cycleFTC,
				ROUND((SELECT SUM(dwp) FROM MemberTax WHERE pieId = mt.pieId AND valuationDate = @valuationDate),2) cycleDWP,
				ROUND((SELECT SUM(ic) FROM MemberTax WHERE pieId = mt.pieId AND valuationDate = @valuationDate),2) cycleIC,
				ROUND((SELECT SUM(rwt) FROM MemberTax WHERE pieId = mt.pieId AND valuationDate = @valuationDate),2) cycleRWT,
				ROUND((SELECT SUM(FDR) FROM MemberTax WHERE  pieId = mt.pieId AND valuationDate = @valuationDate),2) cycleFDR


				-- For previous valuation date.

				--mtPrevious.closingTaxableAmount PrevTaxableIncome,
				--0 PrevNonTaxableIncome,
				--mtPrevious.closingFTC PrevForeignTaxCredits,
				--mtPrevious.DWP PrevDividendWithholdingPayments,
				--mtPrevious.RWT PrevResidentWithholdingTax,
				--mtPrevious.IC PrevImputationCredits,
				--(SELECT SUM(tolAmount) FROM retail.CUST_RegistryEngine_MemberTax WHERE memberid = m.WholesaleMemberId AND pieId = m.WholesaleFundId AND valuationDate BETWEEN @startOfYear AND @PrevValuationDate) PrevDeductibleExpenses,
				--fundTax.*,
				--prevFundTax.*

			FROM
			
			
				--INNER JOIN retail.CUST_Retail_Fund retailFund ON retailFund.fundId = m.RetailFundId
				Fund f 
				INNER JOIN FundBalance fb ON fb.fundId = f.fundId AND fb.endDate = @ValuationDate
				INNER JOIN MemberTax mt ON mt.pieId = f.pieId AND mt.valuationDate = @ValuationDate
				INNER join MMCRetailFund m ON m.memberid=mt.memberid
				INNER JOIN MemberFundBalance mfb ON mfb.fundId = mt.pieId AND mfb.memberId = m.memberid AND mfb.endDate = @ValuationDate
			
			
				--INNER JOIN (
				--	SELECT 
				--		pieId fundLevelPieId,
				--		valuationDate fundLevelDate,
				--		SUM(closingTaxableAmount+tolAmount) fundLevelTaxableIncome,
				--		SUM(closingFTC) fundLevelFTC,
				--		SUM(DWP) fundLevelDWP,
				--		SUM(RWT) fundLevelRWT,
				--		SUM(IC) fundLevelIC,	
				--		SUM(tolAmount) fundLevelExpenses

				--	FROM MemberTax
				--	WHERE 
				--		 valuationDate = @ValuationDate
				--	GROUP BY
				--		pieId,
				--		valuationDate
				--) fundTax ON fundTax.fundLevelPieId = f.pieId 
				--INNER JOIN (
				--	SELECT 
				--		pieId fundLevelPieIdPrev,
				--		valuationDate fundLevelDatePrev,
				--		SUM(closingTaxableAmount+tolAmount) fundLevelTaxableIncomePrev,
				--		SUM(closingFTC) fundLevelFTCPrev,
				--		SUM(DWP) fundLevelDWPPrev,
				--		SUM(RWT) fundLevelRWTPrev,
				--		SUM(IC) fundLevelICPrev,	
				--		SUM(tolAmount) fundLevelExpensesPrev

				--	FROM MemberTax
				--	WHERE 
				--		 valuationDate = @PrevValuationDate
				--	GROUP BY
				--		pieId,
				--		valuationDate
				--) prevFundTax ON prevFundTax.fundLevelPieIdPrev = f.pieId 


			) MemberTaxDetails
		
		






END
