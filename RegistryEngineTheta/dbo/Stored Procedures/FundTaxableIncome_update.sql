-- =============================================
-- Author:		Dave
-- Create date: 10 May 10
-- Description:	called from the eom app. 
-- =============================================
CREATE PROCEDURE [dbo].[FundTaxableIncome_update]
	-- Add the parameters for the stored procedure here
	@fundId int,
	@valuationDate DATE,
	@totalGrossIncome float=0,
	@totalDeductibleExpenses float=0,
	@taxableIncomeAmount float=0,
	@FDROpeningBalance float=0,
	@taxableFDRIncome float=0,
	@foreignTaxCredits float=0,
	@imputationCredits float=0,
	@dividendWithholdingPayments float=0,
	@RWT float=0,
	@FDRClosingDate DATE = NULL,
	@FDRNumberOfDays INT = NULL
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	DECLARE @currentFundId as integer
	
	SELECT 
		@currentFundId=fundId
	FROM 
		FundTaxableIncome
	WHERE 
		valuationDate=@valuationDate 
		AND fundid=@fundId
	
	set @currentFundId = ISNULL(@currentFundId,0)
	
	IF (@currentFundId=0) 
	BEGIN --insert
		INSERT INTO FundTaxableIncome (
			valuationDate, 
			fundid, 
			totalGrossIncome, 
			totalDeductibleExpenses,
			taxableIncomeAmount, 
			foreignTaxCredits, 
			imputationCredits, 
			dividendWithholdingPayments, 
			RWT,  
			FDROpeningBalance, 
			FDRClosingDate,
			FDRNumberOfDays,
			taxableFDRIncome
		)
		VALUES (
			@valuationDate, 
			@fundId, 
			@totalGrossIncome, 
			@totalDeductibleExpenses, 
			@taxableIncomeAmount, 
			@foreignTaxCredits, 
			@imputationCredits, 
			@dividendWithholdingPayments, 
			@RWT,  
			@FDROpeningBalance, 
			@FDRClosingDate,
			@FDRNumberOfDays,
			@taxableFDRIncome
		)
	END
	ELSE 
	BEGIN --update
		UPDATE 
			dbo.FundTaxableIncome 
		SET 
			totalGrossIncome=@totalGrossIncome, 
			totalDeductibleExpenses=@totalDeductibleExpenses, 
			taxableIncomeAmount=@taxableIncomeAmount, 
			foreignTaxCredits=@foreignTaxCredits, 
			imputationCredits=@imputationCredits, 
			dividendWithholdingPayments=@dividendWithholdingPayments,
			RWT=@RWT,
			FDROpeningBalance=@FDROpeningBalance,
			FDRClosingDate=@FDRClosingDate,
			FDRNumberOfDays=@FDRNumberOfDays,
			taxableFDRIncome=@taxableFDRIncome 			
		WHERE 
			valuationDate=@valuationDate 
			AND fundid=@fundid
	END
END
