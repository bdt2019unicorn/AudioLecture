-- =============================================
-- Author:		Dave
-- Create date: 11 May 2011

-- =============================================
CREATE PROCEDURE [dbo].[ReportAnnualIR853InvestorCertificate_selectCsvFormat]
	@eoyDate smalldatetime
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	select 
		'IR853' AS IRCertType, 
		VersionNumber,
		'Portfolio Custodial Nominees Limited' AS PIEName,
		84497419 AS PIEId,
		CONVERT(VARCHAR(8), @eoyDate, 112) AS PeriodEndDate, 
		count(1) as numberOfCertificates,
			
		ROUND(sum(taxableIncomeOrLoss),2) as taxableIncomeOrLoss,
		ROUND(sum(IIF(PIRAtYearEnd>0,taxCredits, 0)),2) as taxCredits,
		ROUND(sum(IIF(PIRAtYearEnd>0,taxPaid, 0)),2) as taxPaid,
		
		ROUND(sum(IIF(PIRAtYearEnd>0,taxableIncomeOrLossLowPIR, 0)),2) as taxableIncomeOrLossLowPIR,
		ROUND(sum(IIF((PIRAtYearEnd=10.5 OR PIRAtYearEnd=17.5) AND (PIRChangedDuringTheYear='Y'), taxCreditsLowPIR, 0)),2) as taxCreditsLowPIR,
		ROUND(sum(IIF((PIRAtYearEnd=10.5 OR PIRAtYearEnd=17.5) AND (PIRChangedDuringTheYear='Y'), taxPaidLowPIR, 0)),2) as taxPaidLowPIR,

		ROUND(sum(IIF((PIRAtYearEnd<>0) AND (PIRChangedDuringTheYear='Y'),taxableIncomeOrLossZeroRated, 0)),2) as taxableIncomeOrLossZeroRated,
		ROUND(sum(IIF(PIRAtYearEnd=0, TotalZeroRatedAllocatedFTCr,0)),2) as TotalZeroRatedAllocatedFTCr,
		ROUND(sum(TotalZeroRatedAllocatedDWPMATaxCr),2) as TotalZeroRatedAllocatedDWPMATaxCr,
		ROUND(sum(IIF(PIRAtYearEnd=0, TotalZeroRatedAllocatedICTaxCr, 0)),2) as TotalZeroRatedAllocatedICTaxCr,
		ROUND(sum(TotalZeroRatedAllocatedRWTTaxCr),2) as TotalZeroRatedAllocatedRWTTaxCr,
		ROUND(sum(ZeroRatedExitedInvestorTaxPayForExitPeriod),2) as ZeroRatedExitedInvestorTaxPayForExitPeriod
	from 
		ReportAnnualIR854InvestorCertificate
	where 
		PeriodEndDate=@eoyDate
		and (
			taxableIncomeOrLoss<>0 --exclude members (old ex member accounts) with no tax
			OR
			taxCredits<>0 
			OR 
			taxPaid<>0
		)

	group by VersionNumber,
		PeriodEndDate
END

