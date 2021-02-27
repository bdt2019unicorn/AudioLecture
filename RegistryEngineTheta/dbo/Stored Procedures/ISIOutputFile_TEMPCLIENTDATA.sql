CREATE PROCEDURE [dbo].[ISIOutputFile_TEMPCLIENTDATA]

 @valuationdate DATE,
 @clientid INT

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @FundMemberMapping TABLE (WholesaleMemberId INT, WholesaleFundId INT,InvestorName varchar(200))

INSERT @FundMemberMapping (WholesaleMemberId, WholesaleFundId,InvestorName)
	Select u.Id AS InvestorId,W.fundId,u.client
	from gmi_users u
	CROSS JOIN Fund W 
	WHERE  
	u.id = @clientid -- u.user_type_id = 203
	and W.isActive = 1
	ORDER BY u.Id 
	--select * from @FundMemberMapping


DECLARE @PrevValuationDate DATE = (SELECT TOP 1 valuationDate FROM ValuationPeriod WHERE valuationDate < @ValuationDate ORDER BY valuationDate DESC);
DECLARE @StartOfYear DATE = '1 Apr' + CAST(YEAR(@ValuationDate) AS VARCHAR(4))
IF @StartOfYear > @ValuationDate 
BEGIN
	SET @StartOfYear = DATEADD(YEAR, -1, @StartOfYear);
END


SELECT

	-- Investor node:
	WholesaleMemberId investorId,	
	InvestorName,

	-- Fund node:
	'Y' IsPIE,
	pieId FundId,	
	WholesaleFundName FundName,
	@ValuationDate FundValuationDate,
	'NZD' Currency,

	-- Balances node:
	FundBalanceUnitAmount TotalUnitsOnIssue,
	MemberFundBalanceUnitAmount InvestorUnitsHeld,

	-- Prices node:
	endUnitPrice BasePrice,
	endUnitPrice EntryPrice,
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

		
			WholesaleMemberId, WholesaleFundId,InvestorName,
			f.fundName WholesaleFundName,
			fb.endUnitAmount TotalUnitsOnIssue,
			mt.memberid,
			mt.pieId,
			mt.valuationDate,
			fb.endUnitPrice,
			fb.endUnitAmount FundBalanceUnitAmount,
			mfb.endUnitAmount MemberFundBalanceUnitAmount,

			-- For valuation date.
			--ROUND(mt.closingTaxableAmount,2) TaxableIncome,
			ROUND((SELECT SUM(taxableAmount) FROM MemberTax WHERE memberid = m.WholesaleMemberId AND pieId = m.WholesaleFundId AND valuationDate BETWEEN @startOfYear AND @valuationDate),2) TaxableIncome,
			ROUND(0.00,2) NonTaxableIncome,
			--ROUND(mt.closingFTC,2) ForeignTaxCredits,
			ROUND((SELECT SUM(ftc) FROM MemberTax WHERE memberid = m.WholesaleMemberId AND pieId = m.WholesaleFundId AND valuationDate BETWEEN @startOfYear AND @valuationDate),2) ForeignTaxCredits,
			--ROUND(mt.DWP,2) DividendWithholdingPayments,
			ROUND((SELECT SUM(dwp) FROM MemberTax WHERE memberid = m.WholesaleMemberId AND pieId = m.WholesaleFundId AND valuationDate BETWEEN @startOfYear AND @valuationDate),2) DividendWithholdingPayments,
			--ROUND(mt.RWT,2) ResidentWithholdingTax,
			ROUND((SELECT SUM(rwt) FROM MemberTax WHERE memberid = m.WholesaleMemberId AND pieId = m.WholesaleFundId AND valuationDate BETWEEN @startOfYear AND @valuationDate),2) ResidentWithholdingTax,
			--ROUND(mt.IC,2) ImputationCredits,	
			ROUND((SELECT SUM(IC) FROM MemberTax WHERE memberid = m.WholesaleMemberId AND pieId = m.WholesaleFundId AND valuationDate BETWEEN @startOfYear AND @valuationDate),2) ImputationCredits,
			ROUND((SELECT SUM(tolAmount) FROM MemberTax WHERE memberid = m.WholesaleMemberId AND pieId = m.WholesaleFundId AND valuationDate BETWEEN @startOfYear AND @valuationDate),2) DeductibleExpenses,
	
			
			ROUND((SELECT SUM(taxableAmount) FROM MemberTax WHERE  pieId = m.WholesaleFundId AND valuationDate = @valuationDate),2) cycleInvestedTaxableIncome,
			ROUND((SELECT SUM(ftc) FROM MemberTax WHERE pieId = m.WholesaleFundId AND valuationDate = @valuationDate),2) cycleFTC,
			ROUND((SELECT SUM(dwp) FROM MemberTax WHERE pieId = m.WholesaleFundId AND valuationDate = @valuationDate),2) cycleDWP,
			ROUND((SELECT SUM(ic) FROM MemberTax WHERE pieId = m.WholesaleFundId AND valuationDate = @valuationDate),2) cycleIC,
			ROUND((SELECT SUM(rwt) FROM MemberTax WHERE pieId = m.WholesaleFundId AND valuationDate = @valuationDate),2) cycleRWT,
			ROUND((SELECT SUM(FDR) FROM MemberTax WHERE  pieId = m.WholesaleFundId AND valuationDate = @valuationDate),2) cycleFDR

		FROM
			@FundMemberMapping m
			INNER JOIN Fund f ON f.fundId = m.WholesaleFundId
			INNER JOIN MemberTax mt ON mt.memberid = m.WholesaleMemberId AND mt.pieId = m.WholesaleFundId AND mt.valuationDate = @ValuationDate
			INNER JOIN FundBalance fb ON fb.fundId = m.WholesaleFundId AND fb.endDate = @ValuationDate
			INNER JOIN MemberFundBalance mfb ON mfb.fundId = m.WholesaleFundId AND mfb.memberId = m.WholesaleMemberId AND mfb.endDate = @ValuationDate

		) MemberTaxDetails
		
		Order by WholesaleMemberId


END

