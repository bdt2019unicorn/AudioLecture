
CREATE PROCEDURE [dbo].[TaxQuarterSummary_insert]
	@pieId INT,
	@quarterDate AS date
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;


		DECLARE	@previousTaxQuarter DATE =  DateAdd(Day, -1, DateAdd(quarter,  DatePart(Quarter, @quarterDate)-1, '1/1/' + Convert(char(4), DatePart(Year, @quarterDate)))) --set to last eoy of quarter! Was missing any valuation on the 1st day of the quarter - doh

		DECLARE @doInsert BIT = 1


		DECLARE @grossInvested DECIMAL(18,2)
		DECLARE @grossInvestedAdjustment DECIMAL(18,2)
		DECLARE @cashInterest DECIMAL(18,2)
		DECLARE @fdr DECIMAL(18,2)
		DECLARE @fdrAdjustment DECIMAL(18,2)

		DECLARE @fees DECIMAL(18,2)
		DECLARE @expenses DECIMAL(18,2)
		DECLARE @tols DECIMAL(18,2)

		DECLARE @netTaxPayable DECIMAL(18,2)

		DECLARE @gainZero DECIMAL(18,2)
		DECLARE @gainLow DECIMAL(18,2)
		DECLARE @gainMid DECIMAL(18,2)
		DECLARE @gainHigh DECIMAL(18,2)
		DECLARE @lossZero DECIMAL(18,2)
		DECLARE @lossLow DECIMAL(18,2)
		DECLARE @lossMid DECIMAL(18,2)
		DECLARE @lossHigh DECIMAL(18,2)

		DECLARE @excessIC float
		DECLARE @FUM float

		SET @tols = ISNULL((SELECT SUM(tolAmount) FROM MemberTax WITH(NOLOCK) WHERE pieId=@pieId AND valuationDate > @previousTaxQuarter AND valuationDate <= @quarterDate),0)
		SET @grossInvested = ISNULL((
			SELECT SUM(totalGrossIncome) AS totalGrossIncome 
			FROM dbo.FundTaxableIncome ft
				INNER JOIN fund f ON f.fundId = ft.fundid
			WHERE f.pieId=@pieId AND ft.valuationDate > @previousTaxQuarter AND ft.valuationDate <= @quarterDate)		
			,0)
		SET @grossInvestedAdjustment = ISNULL((SELECT SUM(investedTaxableIncomeAdjustment) AS totalGrossIncome FROM MemberTax WITH(NOLOCK) WHERE pieId=@pieId AND valuationDate > @previousTaxQuarter AND valuationDate <= @quarterDate),0)
		SET @cashInterest = ISNULL((SELECT SUM(cashAccountInterest) FROM MemberTax WITH(NOLOCK) WHERE valuationDate > @previousTaxQuarter AND valuationDate <= @quarterDate),0)
		SET @fdr =ISNULL( (SELECT SUM(fdr) AS fdr FROM MemberTax WITH(NOLOCK) WHERE pieId=@pieId AND valuationDate > @previousTaxQuarter AND valuationDate <= @quarterDate),0)
		SET @fdrAdjustment = ISNULL((SELECT SUM(AdjustmentFDR) AS fdrAdjustment FROM MemberTax WITH(NOLOCK) WHERE pieId=@pieId AND valuationDate > @previousTaxQuarter AND valuationDate <= @quarterDate),0)
		SET @fees = 0--ISNULL((SELECT SUM(amount) AS total FROM Fees WITH(NOLOCK) WHERE Date > @startDate AND Date <= @quarterDate),0)
		SET @expenses = ISNULL((
			SELECT SUM(totalDeductibleExpenses) AS totalDeductibleExpenses 
			FROM dbo.FundTaxableIncome ft
				INNER JOIN fund f ON f.fundId = ft.fundid
			WHERE  
				f.pieId=@pieId 
				AND ft.valuationDate > @previousTaxQuarter 
				AND ft.valuationDate <= @quarterDate)
		,0)
		SET @netTaxPayable = ISNULL((SELECT SUM(taxPayable)  AS taxPayable FROM MemberTax WITH(NOLOCK) WHERE pieId=@pieId AND valuationDate = @quarterDate),0)

	
		DECLARE @netIncome DECIMAL(18,2) = @grossInvested+@grossInvestedAdjustment+@cashInterest+@fdr+@fdrAdjustment-@fees-@tols-@expenses
		DECLARE @netIncomeAcrossGainsAndLosses DECIMAL(18,2)
	--19.5
	--30
	--33


		SET @gainZero = (SELECT SUM(ClosingTaxableAmount) FROM MemberTax WITH(NOLOCK) WHERE pieId=@pieId AND ClosingTaxableAmount > 0 AND PIR = 0 AND valuationDate = @quarterDate GROUP BY PIR)
		SET @gainLow = (SELECT SUM(ClosingTaxableAmount) FROM MemberTax WITH(NOLOCK) WHERE pieId=@pieId AND ClosingTaxableAmount > 0 AND PIR = 10.5 AND valuationDate = @quarterDate GROUP BY PIR)
		SET @gainMid = (SELECT SUM(ClosingTaxableAmount) FROM MemberTax WITH(NOLOCK) WHERE pieId=@pieId AND ClosingTaxableAmount > 0 AND PIR = 17.5 AND valuationDate = @quarterDate GROUP BY PIR)
		SET @gainHigh = (SELECT SUM(ClosingTaxableAmount) FROM MemberTax WITH(NOLOCK) WHERE pieId=@pieId AND ClosingTaxableAmount > 0 AND PIR = 28 AND valuationDate = @quarterDate GROUP BY PIR)

		SET @lossZero = (SELECT SUM(ClosingTaxableAmount) FROM MemberTax WITH(NOLOCK) WHERE pieId=@pieId AND ClosingTaxableAmount < 0 AND PIR = 0 AND valuationDate = @quarterDate GROUP BY PIR)
		SET @lossLow = (SELECT SUM(ClosingTaxableAmount) FROM MemberTax WITH(NOLOCK) WHERE pieId=@pieId AND ClosingTaxableAmount < 0 AND PIR = 10.5 AND valuationDate = @quarterDate GROUP BY PIR)
		SET @lossMid = (SELECT SUM(ClosingTaxableAmount) FROM MemberTax WITH(NOLOCK) WHERE pieId=@pieId AND ClosingTaxableAmount < 0 AND PIR = 17.5 AND valuationDate = @quarterDate GROUP BY PIR)
		SET @lossHigh = (SELECT SUM(ClosingTaxableAmount) FROM MemberTax WITH(NOLOCK) WHERE pieId=@pieId AND ClosingTaxableAmount < 0 AND PIR = 28 AND valuationDate = @quarterDate GROUP BY PIR)

		SET @netIncomeAcrossGainsAndLosses = (SELECT SUM(ClosingTaxableAmount) FROM MemberTax WITH(NOLOCK) WHERE pieId=@pieId AND valuationDate = @quarterDate)

		SET @excessIC = 0 --Hardcode to zero for now
		SET @FUM = (
			SELECT SUM(fb.endDollarAmount) AS total 
			FROM dbo.FundBalance fb
				inner join fund f on f.fundId = fb.fundId
			WHERE 
				f.pieId=@pieId 
				AND fb.endDate = @quarterDate
		)


		SELECT
			@previousTaxQuarter AS startDate,
			@quarterDate AS endDate,
			@pieId AS pieId, 
			ISNULL(@grossInvested, 0.0) AS grossInvested,
			ISNULL(@grossInvestedAdjustment, 0.0) AS grossInvestedAdjustment,
			ISNULL(@cashInterest, 0.0) AS cashInterest,
			ISNULL(@fdr, 0.0) AS fdr,
			ISNULL(@fdrAdjustment, 0.0) AS fdrAdjustment,
			ISNULL(@fees, 0.0) AS fees,
			ISNULL(@tols,0.0) AS tols,
			ISNULL(@expenses, 0.0) AS expenses,
			@netIncome AS netIncome,

			ISNULL(@netTaxPayable, 0.0) AS netTaxPayable,
			ISNULL(@gainZero, 0.0) AS gainZero,
			ISNULL(@gainLow, 0.0) AS gainLow,
			ISNULL(@gainMid, 0.0) AS gainMid,
			ISNULL(@gainHigh, 0.0) AS gainHigh,
			ISNULL(@lossZero, 0.0) AS lossZero,
			ISNULL(@lossLow, 0.0) AS lossLow,
			ISNULL(@lossMid, 0.0) AS lossMid,
			ISNULL(@lossHigh, 0.0) AS lossHigh,
			ISNULL(@excessIC, 0.0) AS excessIC,
			ISNULL(@FUM, 0.0) AS FUM,
			@netIncomeAcrossGainsAndLosses AS netIncomeAcrossGainsAndLosses

	IF @doInsert=1
	BEGIN

	INSERT INTO TaxQuarterSummary (
		quarterDate, 
		pieId,
		grossTaxableIncome,
		taxableIncomeAdjustment,  
		bankAccountInterest, 
		fdr, 
		fdrAdjustment, 
		fee, 
		tol, 
		fundDeductibleExpenses, 
		netIncome, 
		taxPayable, 
		gainZero, 
		gainLow, 
		gainMid, 
		gainHigh, 
		lossZero, 
		lossLow, 
		lossMid, 
		lossHigh, 
		netIncomeAcrossGainsAndLosses, 
		excessIC, 
		totalFUM
		)

	SELECT
		@quarterDate AS endDate,
		@pieId,
		ISNULL(@grossInvested, 0.0) AS grossInvested,
		ISNULL(@grossInvestedAdjustment, 0.0) AS grossInvestedAdjustment,
		ISNULL(@cashInterest, 0.0) AS cashInterest,
		ISNULL(@fdr, 0.0) AS fdr,
		ISNULL(@fdrAdjustment, 0.0) AS fdrAdjustment,
		ISNULL(@fees, 0.0) AS fees,
		ISNULL(@tols,0.0) AS tols,
		ISNULL(@expenses, 0.0) AS expenses,
		@netIncome AS netIncome,
		ISNULL(@netTaxPayable, 0.0) AS netTaxPayable,
		ISNULL(@gainZero, 0.0) AS gainZero,
		ISNULL(@gainLow, 0.0) AS gainLow,
		ISNULL(@gainMid, 0.0) AS gainMid,
		ISNULL(@gainHigh, 0.0) AS gainHigh,
		ISNULL(@lossZero, 0.0) AS lossZero,
		ISNULL(@lossLow, 0.0) AS lossLow,
		ISNULL(@lossMid, 0.0) AS lossMid,
		ISNULL(@lossHigh, 0.0) AS lossHigh,
		@netIncomeAcrossGainsAndLosses AS netIncomeAcrossGainsAndLosses,
		ISNULL(@excessIC, 0.0) AS excessIC,
		ISNULL(@FUM, 0.0) AS FUM
	END











END
