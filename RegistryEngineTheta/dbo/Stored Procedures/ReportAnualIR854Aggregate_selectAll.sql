CREATE PROCEDURE [dbo].[ReportAnualIR854Aggregate_selectAll]
	@valuationDate DATE
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @valuationStartDate DATE = Dateadd(day, 1, Dateadd(year, -1, @valuationDate)); 

	DECLARE @dataTable TABLE 
	(
		memberid INT, 
		pieId INT, 
		clientid VARCHAR(255),  
		InvestorName VARCHAR(255), 
		taxableIncomeOrLoss FLOAT(53), 
		TotalZeroRatedAllocatedFTCr FLOAT(53), 
		TotalZeroRatedAllocatedDWPMATaxCr FLOAT(53), 
		TotalZeroRatedAllocatedICTaxCr FLOAT(53), 
		TotalZeroRatedAllocatedRWTTaxCr FLOAT(53), 
		unitsHeldAtYearEnd FLOAT(53)
	); 


	INSERT INTO @dataTable
	SELECT 
		'' AS memberid  
		,pieId 
		,'pcn' AS clientid
		,'Portfolio Custodial Nominees Limited' AS InvestorName
		,sum(taxableIncomeOrLoss) as taxableIncomeOrLoss
		,sum(TotalZeroRatedAllocatedFTCr) AS TotalZeroRatedAllocatedFTCr
		,sum(TotalZeroRatedAllocatedDWPMATaxCr) AS TotalZeroRatedAllocatedDWPMATaxCr
		,sum(TotalZeroRatedAllocatedICTaxCr) AS TotalZeroRatedAllocatedICTaxCr
		,sum(TotalZeroRatedAllocatedRWTTaxCr) AS TotalZeroRatedAllocatedRWTTaxCr
		,SUM(unitsHeldAtYearEnd) AS unitsHeldAtYearEnd
	FROM 
	(
		SELECT 
			pieId 
			,sum(taxableAmount) as taxableIncomeOrLoss
			,sum(FTC) AS TotalZeroRatedAllocatedFTCr
			,sum(DWP) AS TotalZeroRatedAllocatedDWPMATaxCr
			,sum(IC) AS TotalZeroRatedAllocatedICTaxCr
			,sum(RWT) AS TotalZeroRatedAllocatedRWTTaxCr

			,(
				SELECT SUM(endUnitAmount)
				FROM vwMemberFundBalanceSummary 
				WHERE 
					vwMemberFundBalanceSummary.endDate = MemberTax.valuationDate AND 
					vwMemberFundBalanceSummary.memberId IN (SELECT gmi_users.id FROM gmi_users WHERE user_type_id IN (101, 103, 105, 107, 108, 109, 201, 203)) AND 
					(select Fund.pieId from Fund where vwMemberFundBalanceSummary.fundId = Fund.fundId) = MemberTax.pieId
			) AS unitsHeldAtYearEnd
		FROM [RegistryEngineTheta].[dbo].[MemberTax] 
		WHERE 
			valuationDate BETWEEN @valuationStartDate AND @valuationDate
			AND memberid IN (SELECT DISTINCT gmi_users.id FROM gmi_users WHERE user_type_id IN (101, 103, 105, 107, 108, 109, 201, 203) AND gmi_users.id<>6105)
		GROUP BY pieId, valuationDate 
	) as allData 
	GROUP BY allData.pieId; 
	
	INSERT INTO @dataTable 
	SELECT 
		'' AS memberid
		,pieId 
		,'kwss' AS clientid
		,'Kiwi Wealth Super Scheme' AS InvestorName
		,sum(taxableIncomeOrLoss) as taxableIncomeOrLoss
		,sum(TotalZeroRatedAllocatedFTCr) AS TotalZeroRatedAllocatedFTCr
		,sum(TotalZeroRatedAllocatedDWPMATaxCr) AS TotalZeroRatedAllocatedDWPMATaxCr
		,sum(TotalZeroRatedAllocatedICTaxCr) AS TotalZeroRatedAllocatedICTaxCr
		,sum(TotalZeroRatedAllocatedRWTTaxCr) AS TotalZeroRatedAllocatedRWTTaxCr
		,SUM(unitsHeldAtYearEnd) AS unitsHeldAtYearEnd
	FROM 
	(
		SELECT 
			pieId
			,sum(taxableAmount) as taxableIncomeOrLoss
			,sum(FTC) AS TotalZeroRatedAllocatedFTCr
			,sum(DWP) AS TotalZeroRatedAllocatedDWPMATaxCr
			,sum(IC) AS TotalZeroRatedAllocatedICTaxCr
			,sum(RWT) AS TotalZeroRatedAllocatedRWTTaxCr

			,(
				SELECT SUM(endUnitAmount)
				FROM vwMemberFundBalanceSummary 
				WHERE 
					vwMemberFundBalanceSummary.endDate = MemberTax.valuationDate AND 
					vwMemberFundBalanceSummary.memberId IN (SELECT gmi_users.ID FROM dbo.gmi_users WHERE user_type_id = 302) AND 
					(select Fund.pieId from Fund where vwMemberFundBalanceSummary.fundId = Fund.fundId) = MemberTax.pieId
			) AS unitsHeldAtYearEnd
		FROM [RegistryEngineTheta].[dbo].[MemberTax] 
		WHERE 
			valuationDate BETWEEN @valuationStartDate AND @valuationDate
			AND memberid IN (SELECT gmi_users.ID FROM dbo.gmi_users WHERE user_type_id = 302)
		GROUP BY pieId, valuationDate 
	) AS allData 
	GROUP BY allData.pieId; 
	
	INSERT INTO @dataTable 
	SELECT 
			memberid
		  ,[pieId]
		  ,clientid 
		  ,InvestorName 
		  ,sum(taxableIncomeOrLoss) as taxableIncomeOrLoss
		  ,sum(TotalZeroRatedAllocatedFTCr) AS TotalZeroRatedAllocatedFTCr
		  ,sum(TotalZeroRatedAllocatedDWPMATaxCr) AS TotalZeroRatedAllocatedDWPMATaxCr
		  ,sum(TotalZeroRatedAllocatedICTaxCr) AS TotalZeroRatedAllocatedICTaxCr
		  ,sum(TotalZeroRatedAllocatedRWTTaxCr) AS TotalZeroRatedAllocatedRWTTaxCr
		  ,SUM(unitsHeldAtYearEnd) AS unitsHeldAtYearEnd
	FROM 
	(
		SELECT 
			  memberid
			  ,[pieId]
			  ,FolderName as clientid 
			  ,Client as InvestorName 
			  ,sum(taxableAmount) as taxableIncomeOrLoss
			  ,sum(FTC) AS TotalZeroRatedAllocatedFTCr
			  ,sum(DWP) AS TotalZeroRatedAllocatedDWPMATaxCr
			  ,sum(IC) AS TotalZeroRatedAllocatedICTaxCr
			  ,sum(RWT) AS TotalZeroRatedAllocatedRWTTaxCr
		
			  ,(
				SELECT endUnitAmount 
				FROM vwMemberFundBalanceSummary 
				WHERE 
					vwMemberFundBalanceSummary.endDate = MemberTax.valuationDate AND 
					vwMemberFundBalanceSummary.memberId = MemberTax.memberid AND 
					(select Fund.pieId from Fund where vwMemberFundBalanceSummary.fundId = Fund.fundId) = MemberTax.pieId
				) AS unitsHeldAtYearEnd
		FROM [RegistryEngineTheta].[dbo].[MemberTax] left join dbo.gmi_users ON MemberTax.memberid = gmi_users.ID 
		WHERE valuationDate BETWEEN @valuationStartDate AND @valuationDate
		AND memberid IN ('6007', '6006', '6008', '6105')  
		GROUP BY pieId, memberid, valuationDate, Foldername, Client 
	) AS allData 
	GROUP BY allData.pieId, allData.memberid, allData.clientid, allData.InvestorName; 

	SELECT
		'PIEC' AS 'ParentChildIndicator', 
		'IR854' AS IRCertType, 
		(SELECT TOP 1 ReportAnnualIR854InvestorCertificate.versionNumber FROM ReportAnnualIR854InvestorCertificate WHERE ReportAnnualIR854InvestorCertificate.periodEndDate = @valuationDate) AS versionNumber,
		IIF(pieId=1, 'Public Trust as Trustee for the Kiwi Wealth Fixed Interest Fund', 'Public Trust as Trustee for the Kiwi Wealth Growth Fund') AS pieName, 
		IIF(pieId=1, 114352737, 118064755) AS pieId, 
		FORMAT(@valuationDate, 'yyyyMMdd') AS periodEndDate, 
		InvestorName, 
		ISNULL((SELECT CAST(gmi_users.IRD AS varchar) FROM dbo.gmi_users WHERE gmi_users.ID = memberid), IIF(clientid='pcn', '84497419', '101561917')) AS InvestorIrdNumber, 
		clientid, 
		'0' AS PIRAtYearEnd, 
		'N' AS PIRChangedDuringTheYear,
		taxableIncomeOrLoss, 
		'0' AS taxCredits, 
		'0' AS taxPaid, 
		'0' AS taxableIncomeOrLossLowPIR, 
		'0' AS taxCreditsLowPIR, 
		'0' AS taxPaidLowPIR, 
		taxableIncomeOrLoss AS taxableIncomeOrLossZeroRated, 
		TotalZeroRatedAllocatedFTCr,
		TotalZeroRatedAllocatedDWPMATaxCr,
		TotalZeroRatedAllocatedICTaxCr, 
		TotalZeroRatedAllocatedRWTTaxCr, 
		'0' AS ZeroRatedExitedInvestorTaxPayForExitPeriod, 
		'' AS 'DateOfBirth', 
		'PO Box 50617, Porirua, 5240' AS 'Address', 
		'NZ' AS 'Country', 
		'operations@kiwiwealth.co.nz' AS 'EmailAddress', 
		'0800 427 384' AS 'PhNumber', 
		'0' AS 'HomeCountryTaxFileNumber', 
		unitsHeldAtYearEnd
	FROM @dataTable; 
END
