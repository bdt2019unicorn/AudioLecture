-- =============================================
-- Author:		Dave
-- Create date: 11 May 2011

-- =============================================
CREATE PROCEDURE [dbo].[ReportAnnualIR854InvestorCertificate_selectAllCsvFormat] @eoyDate smalldatetime
AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON;

    --IR854 csv extract - save to excel then csv
    SELECT 'IR854' AS IRCertType
         , versionNumber
         , 'Portfolio Custodial Nominees Limited' AS PIEName
         , 84497419 AS PIEId
         , periodEndDate
         , convert(varchar(50), InvestorName) AS InvestorName
         , InvestorIrdNumber
         , ReportAnnualIR854InvestorCertificate.memberid
         , PIRAtYearEnd
         , PIRChangedDuringTheYear
         , taxableIncomeOrLoss
         , taxCredits
         , taxPaid
         , taxableIncomeOrLossLowPIR
         , taxCreditsLowPIR
         , taxPaidLowPIR
         , taxableIncomeOrLossZeroRated
         , TotalZeroRatedAllocatedFTCr
         , TotalZeroRatedAllocatedDWPMATaxCr
         , TotalZeroRatedAllocatedICTaxCr
         , TotalZeroRatedAllocatedRWTTaxCr
         , ZeroRatedExitedInvestorTaxPayForExitPeriod
		 , dob
		 , contactAddress
		 , countryCode
		 , emailAddress
		 , phoneNumber
		 , unitsHeldatYearEnd
    FROM dbo.ReportAnnualIR854InvestorCertificate
	WHERE 
		PeriodEndDate = @eoyDate 
		AND taxableIncomeOrLoss <> 0 --helps to exclude old members or returning members with invalid irdnumbers
	ORDER BY InvestorIrdNumber
END
