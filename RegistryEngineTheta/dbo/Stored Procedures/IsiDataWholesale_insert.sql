
CREATE PROCEDURE [dbo].[IsiDataWholesale_insert]

	@jobId int,
	@valuationDate DATE

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @FundMemberMapping TABLE 
	(
		WholesaleMemberId INT, 
		WholesaleFundId INT,
		InvestorName varchar(200),
		FolderName varchar(120)
	)

	INSERT @FundMemberMapping 
	(
		WholesaleMemberId, 
		WholesaleFundId,
		InvestorName,
		FolderName
	)
	SELECT u.Id AS InvestorId,
			W.fundId,
			u.client,
			u.folderName
		FROM dbo.gmi_users u
		CROSS JOIN Fund W 
		WHERE u.user_type_id = 203 --in (5877,5880) 
		AND W.isActive = 1
		ORDER BY u.Id 
	

	DECLARE @PrevValuationDate DATE = (SELECT TOP 1 valuationDate FROM ValuationPeriod WHERE valuationDate < @valuationDate ORDER BY valuationDate DESC);
	DECLARE @StartOfYear DATE = '1 Apr' + CAST(YEAR(@ValuationDate) AS VARCHAR(4))
	IF @StartOfYear > @ValuationDate 
	BEGIN
		SET @StartOfYear = DATEADD(YEAR, -1, @StartOfYear);
	END

	INSERT INTO [dbo].[IsiDataWholesale]
	(
			   [isiFileJobId]
			   ,[investorId]
			   ,[investorName]
			   ,[folderName]
			   ,[isPIE]
			   ,[fundId]
			   ,[fundName]
			   ,[fundValuationDate]
			   ,[currency]
			   ,[totalUnitsOnIssue]
			   ,[investorUnitsHeld]
			   ,[basePrice]
			   ,[entryPrice]
			   ,[exitPrice]
			   ,[taxableIncome]
			   ,[nonTaxableIncome]
			   ,[foreignTaxCredits]
			   ,[dividendWithholdingPayments]
			   ,[residentWithholdingTax]
			   ,[imputationCredits]
			   ,[formationLossesUsed]
			   ,[landLossesUsed]
			   ,[deductibleExpenses]
			   ,[investorAccountRebates]
			   ,[investorAccountExpenses]
			   ,[cpu_TaxableIncome]
			   ,[cpu_NonTaxableIncome]
			   ,[cpu_ForeignTaxCredits]
			   ,[cpu_DividendWithholdingPayments]
			   ,[cpu_ResidentWithholdingTax]
			   ,[cpu_ImputationCredits]
			   ,[cpu_FormationLossesUsed]
			   ,[cpu_LandLossesUsed]
			   ,[cpu_DeductibleExpenses]
			   ,[cpu_InvestorAccountRebates]
			   ,[cpu_InvestorAccountExpenses]
	)

	SELECT

		@jobId AS jobid,
	 
		-- Investor node:
		WholesaleMemberId investorId,	
		InvestorName,
		FolderName,

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
		CAST(TaxableIncome AS Decimal(18,10)) AS TaxableIncome,
		CAST(NonTaxableIncome AS Decimal(18,10)) AS NonTaxableIncome,
		CAST(ForeignTaxCredits AS Decimal(18,10)) AS ForeignTaxCredits,
		CAST(DividendWithholdingPayments AS Decimal(18,10)) AS DividendWithholdingPayments,
		CAST(ResidentWithholdingTax AS Decimal(18,10)) AS ResidentWithholdingTax,
		CAST(ImputationCredits AS Decimal(18,10)) AS ImputationCredits,
		CAST(0 AS Decimal(18,10)) AS FormationLossesUsed,
		CAST(0 AS Decimal(18,10)) AS LandLossesUsed,
		CAST(DeductibleExpenses AS Decimal(18,10)) AS DeductibleExpenses,
		CAST(0 AS Decimal(18,10)) AS InvestorAccountRebates,
		CAST(0 AS Decimal(18,10)) AS InvestorAccountExpenses,


		-- Replacement Components node.
		CAST(ISNULL(MemberTaxDetails.cycleInvestedTaxableIncome,0) / TotalUnitsOnIssue AS Decimal(18,10)) CPU_TaxableIncome,
		CAST(0 AS Decimal(18,10)) AS  CPU_NonTaxableIncome,
		CAST(ISNULL(MemberTaxDetails.cycleFTC,0) / TotalUnitsOnIssue AS Decimal(18,10)) CPU_ForeignTaxCredits,
		CAST(ISNULL(MemberTaxDetails.cycleDWP,0) / TotalUnitsOnIssue AS Decimal(18,10)) CPU_DividendWithholdingPayments,
		CAST(ISNULL(MemberTaxDetails.cycleRWT,0)/ TotalUnitsOnIssue AS Decimal(18,10)) CPU_ResidentWithholdingTax,
		CAST(ISNULL(MemberTaxDetails.cycleIC,0)  / TotalUnitsOnIssue AS Decimal(18,10)) CPU_ImputationCredits,	
		CAST(0 AS Decimal(18,10)) AS  CPU_FormationLossesUsed,
		CAST(0 AS Decimal(18,10)) AS CPU_LandLossesUsed,
		CAST(0 AS Decimal(18,10)) AS  CPU_DeductibleExpenses,
		CAST(0 AS Decimal(18,10)) AS  CPU_InvestorAccountRebates,
		CAST(0 AS Decimal(18,10)) AS CPU_InvestorAccountExpenses


		FROM (	

	SELECT	
			WholesaleMemberId, 
			WholesaleFundId,
			InvestorName,
			m.FolderName,
			f.fundName WholesaleFundName,
			fb.endUnitAmount TotalUnitsOnIssue,
			m.wholesaleMemberid AS memberId,
			m.WholesaleFundId AS pieId,
			@valuationDate AS valuationDate,
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
			INNER JOIN FundBalance fb ON fb.fundId = m.WholesaleFundId AND fb.endDate = @ValuationDate
			INNER JOIN MemberFundBalance mfb ON mfb.fundId = m.WholesaleFundId AND mfb.memberId = m.WholesaleMemberId AND mfb.endDate = @ValuationDate

		) MemberTaxDetails
		
		ORDER BY WholesaleMemberId

		SELECT @@ROWCOUNT As RowsInserted

END

