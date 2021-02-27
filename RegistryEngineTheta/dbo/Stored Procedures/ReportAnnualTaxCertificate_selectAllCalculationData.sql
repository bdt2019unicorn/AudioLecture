
-- =============================================
-- Author:		Dave
-- Create date: 31 May 2011
-- Description:	returns all the data for the annual tax certificate. Used by eom application
-- =============================================
CREATE PROCEDURE [dbo].[ReportAnnualTaxCertificate_selectAllCalculationData]
	-- Add the parameters for the stored procedure here
	@date date,
	@memberId INT = NULL,
	@pieId INT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;


declare @startDate as smalldatetime
--set the start date to 1 apr of the previous year
set @startDate = DATEADD(month,-12, DATEADD(DAY,1,@date))

--set the start date to 1 apr of the previous year
set @startDate = DATEADD(month,-12, DATEADD(DAY,1,@date))
declare @junDate as smalldatetime
declare @sepDate as smalldatetime
declare @decDate as smalldatetime

--set the start date to 1 apr of the previous year
set @junDate = cast(YEAR(@date)- 1 as varchar(4)) + '-06-30' 
set @sepDate = cast(YEAR(@date)- 1 as varchar(4)) + '-09-30'
set @decDate = cast(YEAR(@date)- 1 as varchar(4)) + '-12-31'






--get the member personal detail info
	DECLARE @memberDetails TABLE
		(
			memberId INT,
			vehicleType VARCHAR(100), 
			memberIrdNumber INT,	 
			memberName VARCHAR(200), 
			street1 VARCHAR(200), 
			street2 VARCHAR(200), 
			suburb VARCHAR(100), 
			city VARCHAR(100), 
			postcode VARCHAR(100)

		)

	INSERT INTO @memberDetails
	        ( 
			memberId,
			vehicleType ,
	          memberIrdNumber ,
	          memberName ,
	          street1 ,
	          street2 ,
	          suburb ,
	          city ,
	          postcode
	        )
	SELECT 
		u.id,
		u.vehicle_type,
		u.IRD AS irdNumber,
		LTRIM(RTRIM(u.client)) AS memberName,
		CASE WHEN ISNULL(cd.postalAddressStreet1,'') <>'' THEN ISNULL(cd.postalAddressStreet1,'') ELSE ISNULL(cd.street,'') END AS streetAddress1,
		CASE WHEN ISNULL(cd.postalAddressStreet1,'') <>'' THEN ISNULL(cd.postalAddressStreet2,'') ELSE ISNULL(cd.street2,'') END AS streetAddress2,
		CASE WHEN ISNULL(cd.postalAddressStreet1,'') <>'' THEN ISNULL(cd.postalAddressSuburb,'') ELSE ISNULL(cd.suburb,'') END AS suburb,
		CASE WHEN ISNULL(cd.postalAddressStreet1,'') <>'' THEN ISNULL(cd.postalAddressCity,'') ELSE ISNULL(cd.city,'') END AS city,
		CASE WHEN ISNULL(cd.postalAddressStreet1,'') <>'' THEN ISNULL(cd.postalAddressPostcode,'') ELSE ISNULL(cd.postcode,'') END AS postcode
	FROM gmi_users u
		INNER JOIN gmi_contact_details cd ON cd.usersid=u.id 
		--INNER JOIN dbo.ReportAnnualTaxCertificate t1 ON t1.memberid=u.id
	WHERE 
		cd.[current]=1
		AND cd.MainContact=1
		AND (u.vehicle_type<>'JOINT' OR (u.vehicle_type='JOINT' AND u.pieTaxIdentityContactId IS NULL))

	UNION

	SELECT 
		u.id,
		u.vehicle_type,
		u.IRD AS irdNumber,
		LTRIM(RTRIM(cd.title + ' ' + cd.firstnames +' ' + cd.surname)) AS memberName,
		CASE WHEN ISNULL(cd.postalAddressStreet1,'') <>'' THEN ISNULL(cd.postalAddressStreet1,'') ELSE ISNULL(cd.street,'') END AS streetAddress1,
		CASE WHEN ISNULL(cd.postalAddressStreet1,'') <>'' THEN ISNULL(cd.postalAddressStreet2,'') ELSE ISNULL(cd.street2,'') END AS streetAddress2,
		CASE WHEN ISNULL(cd.postalAddressStreet1,'') <>'' THEN ISNULL(cd.postalAddressSuburb,'') ELSE ISNULL(cd.suburb,'') END AS suburb,
		CASE WHEN ISNULL(cd.postalAddressStreet1,'') <>'' THEN ISNULL(cd.postalAddressCity,'') ELSE ISNULL(cd.city,'') END AS city,
		CASE WHEN ISNULL(cd.postalAddressStreet1,'') <>'' THEN ISNULL(cd.postalAddressPostcode,'') ELSE ISNULL(cd.postcode,'') END AS postcode
	FROM gmi.dbo.users u
		INNER JOIN gmi.dbo.contact_details cd ON cd.usersid=u.id 
		--INNER JOIN dbo.ReportAnnualTaxCertificate t1 ON t1.memberid=u.id
	WHERE 
		cd.contactid=u.pieTaxIdentityContactId
		AND u.vehicle_type='JOINT' 
		AND u.pieTaxIdentityContactId IS NOT NULL




--
-- get member taxable income, tax credits, and tax paid
	SELECT @date as 'eoyDate',
		t1.memberid as 'memberid',
		md.memberName,
		md.memberIrdNumber,
		md.street1,
		md.street2,
		md.suburb,
		md.city,
		md.postcode,
		md.vehicleType,
		--quarter 1
		@junDate as 'quarter1Date',
		isnull((select pir FROM MemberTax WITH(NOLOCK) where valuationdate=@junDate and memberid=t1.memberid AND pieId=@pieid),0) as 'quarter1PIR',
		isnull((
		
			SELECT SUM(ISNULL(MemberFundBalance.endUnitAmount / FundBalance.endUnitAmount, 0) * FundTaxableIncome.totalDeductibleExpenses)
			FROM FundTaxableIncome  WITH(NOLOCK)
				INNER JOIN FundBalance WITH(NOLOCK) ON FundTaxableIncome.fundId = FundBalance.fundId AND	FundTaxableIncome.valuationDate = FundBalance.endDate 
				INNER JOIN MemberFundBalance WITH(NOLOCK) ON FundTaxableIncome.valuationDate = MemberFundBalance.endDate AND FundTaxableIncome.fundid = MemberFundBalance.fundId
				INNER JOIN Fund ON Fund.fundId = FundBalance.fundId
			WHERE MemberFundBalance.memberid = t1.memberid
			AND MemberFundBalance.endDate between @startDate and @junDate
			 AND Fund.pieId=@pieid
			GROUP BY MemberFundBalance.memberid


			),0) as 'quarter1FundDeductibleExpenses',
		ROUND(isnull((SELECT SUM(ISNULL(fee,0)+ISNULL(tolAmount,0)) FROM MemberTax WITH(NOLOCK) WHERE  (memberid = t1.memberid) AND (valuationDate BETWEEN @startDate AND @junDate) AND pieId=@pieid),0),2) as 'quarter1Fees',
		isnull((select closingTaxableAmount FROM MemberTax WITH(NOLOCK) where valuationDate=@junDate and memberid=t1.memberid AND pieId=@pieid),0) as 'quarter1TaxableIncome',
		isnull((select isnull(closingFTC,0)+ isnull(closingIC,0) + isnull(closingDWP,0) + isnull(closingRWT,0)-isnull(leftoverftc,0) FROM MemberTax WITH(NOLOCK) where valuationDate=@junDate and memberid=t1.memberid AND pieId=@pieid),0) as 'quarter1TaxCredits',
		isnull((select isnull(closingFTC,0)-isnull(leftoverftc,0) FROM MemberTax WITH(NOLOCK) where valuationDate=@junDate and memberid=t1.memberid AND pieId=@pieid),0) as 'quarter1FTC',
		ISNULL((SELECT ISNULL(closingIC,0) FROM MemberTax WITH(NOLOCK) WHERE valuationDate=@junDate AND memberid=t1.memberid AND pieId=@pieid),0) AS 'quarter1IC',
        isnull((select isnull(closingDWP,0) FROM MemberTax WITH(NOLOCK) where valuationDate=@junDate and memberid=t1.memberid AND pieId=@pieid),0) as 'quarter1DWP',
		isnull((select isnull(closingRWT,0) FROM MemberTax WITH(NOLOCK) where valuationDate=@junDate and memberid=t1.memberid AND pieId=@pieid),0) as 'quarter1RWT',
		isnull((select taxPayable FROM MemberTax WITH(NOLOCK) where valuationDate=@junDate and memberid=t1.memberid AND pieId=@pieid),0) as 'quarter1TaxPayable',
		
		
		--quarter 2
		@sepDate as 'quarter2Date',
		isnull((select pir FROM MemberTax WITH(NOLOCK) where valuationDate=@sepDate and memberid=t1.memberid AND pieId=@pieid),0)  as 'quarter2PIR',
		isnull((
			SELECT SUM(ISNULL(MemberFundBalance.endUnitAmount / FundBalance.endUnitAmount, 0) * FundTaxableIncome.totalDeductibleExpenses)
			FROM FundTaxableIncome  WITH(NOLOCK)
				INNER JOIN FundBalance WITH(NOLOCK) ON FundTaxableIncome.fundId = FundBalance.fundId AND	FundTaxableIncome.valuationDate = FundBalance.endDate 
				INNER JOIN MemberFundBalance WITH(NOLOCK) ON FundTaxableIncome.valuationDate = MemberFundBalance.endDate AND FundTaxableIncome.fundid = MemberFundBalance.fundId
				INNER JOIN Fund ON Fund.fundId = FundBalance.fundId
			WHERE MemberFundBalance.memberid = t1.memberid
			AND MemberFundBalance.endDate between DATEADD(day,1,@junDate) and @sepDate
			 AND Fund.pieId=@pieid
			GROUP BY MemberFundBalance.memberid
			

			),0) as 'quarter2FundDeductibleExpenses',
		
		
		ROUND(isnull((SELECT SUM(ISNULL(fee,0)+ISNULL(tolAmount,0)) FROM MemberTax WITH(NOLOCK) WHERE  (memberid = t1.memberid) AND (valuationDate BETWEEN DATEADD(day,1,@junDate) and @sepDate) AND pieId=@pieid),0),2) as 'quarter2Fees',
		isnull((select closingTaxableAmount FROM MemberTax WITH(NOLOCK) where valuationDate=@sepDate and memberid=t1.memberid AND pieId=@pieid),0) as 'quarter2TaxableIncome',
		isnull((select isnull(closingFTC,0)+ isnull(closingIC,0) + isnull(closingDWP,0) + isnull(closingRWT,0)-isnull(leftoverftc,0) FROM MemberTax WITH(NOLOCK) where valuationDate=@sepDate and memberid=t1.memberid AND pieId=@pieid),0) as 'quarter2TaxCredits',
		isnull((select isnull(closingFTC,0)-isnull(leftoverftc,0) FROM MemberTax WITH(NOLOCK) where valuationDate=@sepDate and memberid=t1.memberid AND pieId=@pieid),0) as 'quarter2FTC',
		ISNULL((SELECT ISNULL(closingIC,0) FROM MemberTax WITH(NOLOCK) WHERE valuationDate=@sepDate AND memberid=t1.memberid AND pieId=@pieid),0) AS 'quarter2IC',
        isnull((select isnull(closingDWP,0) FROM MemberTax WITH(NOLOCK) where valuationDate=@sepDate and memberid=t1.memberid AND pieId=@pieid),0) as 'quarter2DWP',
		isnull((select isnull(closingRWT,0) FROM MemberTax WITH(NOLOCK) where valuationDate=@sepDate and memberid=t1.memberid AND pieId=@pieid),0) as 'quarter2RWT',
		isnull((select taxPayable FROM MemberTax WITH(NOLOCK) where valuationDate=@sepDate and memberid=t1.memberid AND pieId=@pieid),0) as 'quarter2TaxPayable',	
			
			
		--quarter 3
		@decDate as 'quarter3Date',
		isnull((select pir FROM MemberTax WITH(NOLOCK) where valuationDate=@decDate and memberid=t1.memberid AND pieId=@pieid),0)  as 'quarter3PIR',
		isnull((
			SELECT SUM(ISNULL(MemberFundBalance.endUnitAmount / FundBalance.endUnitAmount, 0) * FundTaxableIncome.totalDeductibleExpenses)
			FROM FundTaxableIncome  WITH(NOLOCK)
				INNER JOIN FundBalance WITH(NOLOCK) ON FundTaxableIncome.fundId = FundBalance.fundId AND	FundTaxableIncome.valuationDate = FundBalance.endDate 
				INNER JOIN MemberFundBalance WITH(NOLOCK) ON FundTaxableIncome.valuationDate = MemberFundBalance.endDate AND FundTaxableIncome.fundid = MemberFundBalance.fundId
				INNER JOIN Fund ON Fund.fundId = FundBalance.fundId
			WHERE MemberFundBalance.memberid = t1.memberid
			AND MemberFundBalance.endDate between DATEADD(day,1,@sepDate) and @decDate
			 AND Fund.pieId=@pieid
			GROUP BY MemberFundBalance.memberid


			),0) as 'quarter3FundDeductibleExpenses',

		
		
		ROUND(isnull((SELECT SUM(ISNULL(fee,0)+ISNULL(tolAmount,0)) FROM MemberTax WITH(NOLOCK) WHERE  (memberid = t1.memberid) AND (valuationDate BETWEEN DATEADD(day,1,@sepDate) and @decDate) AND pieId=@pieid),0),2) as 'quarter3Fees',
		isnull((select closingTaxableAmount FROM MemberTax WITH(NOLOCK) where valuationDate=@decDate and memberid=t1.memberid AND pieId=@pieid),0) as 'quarter3TaxableIncome',
		isnull((select isnull(closingFTC,0)+ isnull(closingIC,0) + isnull(closingDWP,0) + isnull(closingRWT,0)-isnull(leftoverftc,0) FROM MemberTax WITH(NOLOCK) where valuationDate=@decDate and memberid=t1.memberid AND pieId=@pieid),0) as 'quarter3TaxCredits',
		isnull((select isnull(closingFTC,0)-isnull(leftoverftc,0) FROM MemberTax WITH(NOLOCK) where valuationDate=@decDate and memberid=t1.memberid AND pieId=@pieid),0) as 'quarter3FTC',
		ISNULL((SELECT ISNULL(closingIC,0) FROM MemberTax WITH(NOLOCK) WHERE valuationDate=@decDate AND memberid=t1.memberid AND pieId=@pieid),0) AS 'quarter3IC',
        isnull((select isnull(closingDWP,0) FROM MemberTax WITH(NOLOCK) where valuationDate=@decDate and memberid=t1.memberid AND pieId=@pieid),0) as 'quarter3DWP',
		isnull((select isnull(closingRWT,0) FROM MemberTax WITH(NOLOCK) where valuationDate=@decDate and memberid=t1.memberid AND pieId=@pieid),0) as 'quarter3RWT',
		isnull((select taxPayable FROM MemberTax WITH(NOLOCK) where valuationDate=@decDate and memberid=t1.memberid AND pieId=@pieid),0) as 'quarter3TaxPayable',		
			
			
			
		--quarter 4
		@date as 'quarter4Date',
		isnull((select pir FROM MemberTax WITH(NOLOCK) where valuationDate=@date and memberid=t1.memberid AND pieId=@pieid),0)  as 'quarter4PIR',
		isnull((
			SELECT SUM(ISNULL(MemberFundBalance.endUnitAmount / FundBalance.endUnitAmount, 0) * FundTaxableIncome.totalDeductibleExpenses)
			FROM FundTaxableIncome  WITH(NOLOCK)
				INNER JOIN FundBalance WITH(NOLOCK) ON FundTaxableIncome.fundId = FundBalance.fundId AND	FundTaxableIncome.valuationDate = FundBalance.endDate 
				INNER JOIN MemberFundBalance WITH(NOLOCK) ON FundTaxableIncome.valuationDate = MemberFundBalance.endDate AND FundTaxableIncome.fundid = MemberFundBalance.fundId
				INNER JOIN Fund ON Fund.fundId = FundBalance.fundId
			WHERE MemberFundBalance.memberid = t1.memberid
			AND MemberFundBalance.endDate between DATEADD(day,1,@decDate) and @Date
			 AND Fund.pieId=@pieid
			GROUP BY MemberFundBalance.memberid

			),0) as 'quarter4FundDeductibleExpenses',
		ROUND(isnull((SELECT SUM(ISNULL(fee,0)+ISNULL(tolAmount,0)) FROM MemberTax WITH(NOLOCK) WHERE  (memberid = t1.memberid) AND (valuationDate BETWEEN DATEADD(day,1,@decDate) and @Date) AND pieId=@pieid),0),2) as 'quarter4Fees',
		isnull((select closingTaxableAmount FROM MemberTax WITH(NOLOCK) where valuationDate=@Date and memberid=t1.memberid AND pieId=@pieid),0) as 'quarter4TaxableIncome',
		isnull((select isnull(closingFTC,0)+ isnull(closingIC,0) + isnull(closingDWP,0) + isnull(closingRWT,0)-isnull(leftoverftc,0) FROM MemberTax WITH(NOLOCK) where valuationDate=@Date and memberid=t1.memberid AND pieId=@pieid),0) as 'quarter4TaxCredits',
		isnull((select isnull(closingFTC,0)-isnull(leftoverftc,0) FROM MemberTax WITH(NOLOCK) where valuationDate=@Date and memberid=t1.memberid AND pieId=@pieid),0) as 'quarter4FTC',
		ISNULL((SELECT ISNULL(closingIC,0) FROM MemberTax WITH(NOLOCK) WHERE valuationDate=@Date AND memberid=t1.memberid AND pieId=@pieid),0) AS 'quarter4IC',
        isnull((select isnull(closingDWP,0) FROM MemberTax WITH(NOLOCK) where valuationDate=@Date and memberid=t1.memberid AND pieId=@pieid),0) as 'quarter4DWP',
		isnull((select isnull(closingRWT,0) FROM MemberTax WITH(NOLOCK) where valuationDate=@Date and memberid=t1.memberid AND pieId=@pieid),0) as 'quarter4RWT',
		isnull((select taxPayable FROM MemberTax WITH(NOLOCK) where valuationDate=@Date and memberid=t1.memberid AND pieId=@pieid),0) as 'quarter4TaxPayable',	
		


		--totals for checking
		--isnull((
		--	SELECT SUM(ISNULL(AccountBalance.fum / AxysPortfolioBalance.fum, 0) * AxysPortfolioTaxableIncome.totalDeductibleExpenses)
		--	FROM AxysPortfolioTaxableIncome  WITH(NOLOCK)
		--	INNER JOIN
		--	AxysPortfolioBalance WITH(NOLOCK) ON AxysPortfolioTaxableIncome.axysId = AxysPortfolioBalance.axysid AND AxysPortfolioTaxableIncome.date = AxysPortfolioBalance.date 
		--	INNER JOIN
		--	AccountBalance ON AxysPortfolioTaxableIncome.date = AccountBalance.date AND AxysPortfolioTaxableIncome.axysId = AccountBalance.accountid
		--WHERE (AccountBalance.memberid = t1.memberid) 
		--	AND (AccountBalance.date between @startDate and @date)
		--GROUP BY AccountBalance.memberid
		--	),0) as 'fundDeductibleExpenses',
			
		(SELECT SUM(ISNULL(fee,0)+ISNULL(tolAmount,0) )
		FROM MemberTax  WITH(NOLOCK)
		WHERE  (memberid = t1.memberid) 
			AND (valuationDate BETWEEN @startDate AND @date)
			 AND pieId=@pieid
			) as 'fees',
		 SUM(isnull(TaxQuarterPIEReturn.taxPayable,0)) taxPaidDuringYear,
		 SUM(isnull(t1.closingTaxableAmount,0)) as taxableIncome,
		 SUM(isnull(t1.closingFTC,0)+ isnull(t1.closingIC,0) + isnull(t1.closingDWP,0) + isnull(t1.closingRWT,0)-leftoverftc) as 'taxCredits',
		 isnull((select isnull(leftOverFTC,0) FROM MemberTax WITH(NOLOCK) where valuationDate=@Date and memberid=t1.memberid AND pieId=@pieid),0) as 'leftOverFTC'
		 

	FROM TaxQuarterPIEReturn  WITH(NOLOCK)
		INNER JOIN @memberDetails md ON md.memberid=TaxQuarterPIEReturn.memberid
		INNER JOIN
		MemberTax as t1 WITH(NOLOCK) ON TaxQuarterPIEReturn.memberid = t1.memberid AND TaxQuarterPIEReturn.quarterDate = t1.valuationDate AND t1.pieid=TaxQuarterPIEReturn.pieId
	WHERE (t1.valuationDate BETWEEN @startDate AND @date)
		and (t1.memberid=@memberId OR @memberId IS NULL)
		AND t1.pieId=@pieId
	GROUP BY t1.memberid,
	md.memberName,
		md.memberIrdNumber,
		md.street1,
		md.street2,
		md.suburb,
		md.city,
		md.postcode,
		md.vehicleType
	ORDER BY t1.memberid
	
	
--quarter1PIR	float	Unchecked
--quarter1TaxableIncome	float	= quarter1TotalTaxableIncome + quarter1Expenses
--quarter1Expenses	float = deductable expenses + fees
--quarter1TotalTaxableIncome	= closing taxable income
--quarter1TaxPayableBeforeCredits	= quarter1TotalTaxableIncome*PIR
--quarter1TaxCredits	float	= closing tax credits - left over ftc
--quarter1TaxPayableAferCredits	float	= tax payable

--check that quarter1TaxPayableAferCredits = quarter1TaxPayableBeforeCredits-quarter1TaxCredits
	
END


