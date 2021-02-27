-- =============================================
-- Author:		Dave
-- Create date: 25 May 2015
-- Description:	returns a list with all current and pass client contact identities for tax filing.
-- =============================================
CREATE PROCEDURE [dbo].[Member_selectAllForYearEndTaxReturn] @yearEndDate date
AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON;

    DECLARE @startDate date = dateadd(DAY, 1, dateadd(YEAR, -1, @yearEndDate))
    DECLARE @endDate date = @yearEndDate

	DECLARE @quarter3 date = DATEADD(QUARTER,-1, @endDate);
	DECLARE @quarter2 date = DATEADD(QUARTER,-2, @endDate); 
	DECLARE @quarter1 date = DATEADD(QUARTER,-3, @endDate); 


    DECLARE @memberDetails table
    (
        memberId           int
      , vehicleType        varchar(100)
	  , pieTaxIdentityContactId int 
      , memberIrdNumber    int
      , pir                float
	  , taxableIncomeOrLoss float
	  , taxCredits			float
	  , taxPaid				float
	  , taxableIncomeOrLossLowPIR float
	  , taxCreditsLowPIR float 
	  , taxPaidLowPIR float 
	  , taxableIncomeOrLossZeroRated float 
	  , TotalZeroRatedAllocatedFTCr float 
	  , TotalZeroRatedAllocatedDWPMATaxCr float 
	  , TotalZeroRatedAllocatedICTaxCr float  
	  , TotalZeroRatedAllocatedRWTTaxCr float 
	  , ZeroRatedExitedInvestorTaxPayForExitPeriod float 
	  , numberPirUsed	   int 
	  , pirEqual0		   int 
      , memberName         varchar(200)
      , street1            varchar(200)
      , street2            varchar(200)
      , suburb             varchar(100)
      , city               varchar(100)
      , postcode           varchar(100)
      , country            varchar(100)
      , accountClosed      bit
      , accountClosedDate  date
      , dob                date
      , countryCode        varchar(10)
      , emailAddress       varchar(255)
      , homephone          varchar(100)
      , workphone          varchar(100)
      , cellPhone          varchar(100)
      , homeCountryTaxFile varchar(100)
      , unitsHeldAtYearEnd decimal
    )

    INSERT INTO @memberDetails
    (
        memberId
      , vehicleType
	  , pieTaxIdentityContactId
      , memberIrdNumber
      , pir
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
	  , numberPirUsed
	  , pirEqual0
      , memberName
      , street1
      , street2
      , suburb
      , city
      , postcode
      , country
      , accountClosed
      , accountClosedDate
      , dob
      , countryCode
      , emailAddress
      , homephone
      , workphone
      , cellPhone
      , homeCountryTaxFile
      , unitsHeldAtYearEnd
    )
    SELECT u.ID
         , u.vehicle_type
		 , u.pieTaxIdentityContactId
         
		 , u.IRD AS irdNumber
         , u.PIR

		 , mtInfo.taxableIncomeOrLoss
		 , mtInfo.taxCredits
		 , mtInfo.taxPaid

		 , IIF(mtInfo.numberPirUsed<=1, 0, IIF(mtInfo.pirEqual0>0, 0, mtInfo.taxableIncomeOrLossLowPIR))
		 , IIF(mtInfo.numberPirUsed<=1, 0, IIF(mtInfo.pirEqual0>0, 0, mtInfo.taxCreditsLowPIR))
		 , IIF(mtInfo.numberPirUsed<=1, 0, IIF(mtInfo.pirEqual0>0, 0, mtInfo.taxPaidLowPIR))

		 , IIF(mtInfo.numberPirUsed<=1 AND mtInfo.pirAtYearEnd=0, 0, mtInfo.taxableIncomeOrLossZeroRated) AS taxableIncomeOrLossZeroRated
		 , IIF(mtInfo.pirEqual0>0, mtInfo.ftc, 0) AS TotalZeroRatedAllocatedFTCr
		 , mtInfo.dwp AS TotalZeroRatedAllocatedDWPMATaxCr 
		 , mtInfo.ic AS TotalZeroRatedAllocatedICTaxCr
		 , mtInfo.rwt AS TotalZeroRatedAllocatedRWTTaxCr
		 , mtInfo.ZeroRatedExitedInvestorTaxPayForExitPeriod AS ZeroRatedExitedInvestorTaxPayForExitPeriod
		 , mtInfo.numberPirUsed
		 , mtInfo.pirEqual0
         
		 , ltrim(rtrim(u.Client)) AS memberName
         , CASE
               WHEN isnull(cd.PostalAddressStreet1, '') <> '' THEN isnull(cd.PostalAddressStreet1, '')
               ELSE isnull(cd.street, '')
           END AS streetAddress1
         , CASE
               WHEN isnull(cd.PostalAddressStreet1, '') <> '' THEN isnull(cd.PostalAddressStreet2, '')
               ELSE isnull(cd.street2, '')
           END AS streetAddress2
         , CASE
               WHEN isnull(cd.PostalAddressStreet1, '') <> '' THEN isnull(cd.PostalAddressSuburb, '')
               ELSE isnull(cd.suburb, '')
           END AS suburb
         , CASE
               WHEN isnull(cd.PostalAddressStreet1, '') <> '' THEN isnull(cd.postalAddressCity, '')
               ELSE isnull(cd.city, '')
           END AS city
         , CASE
               WHEN isnull(cd.PostalAddressStreet1, '') <> '' THEN isnull(cd.postalAddressPostcode, '')
               ELSE isnull(cd.postcode, '')
           END AS postcode
         , CASE
               WHEN isnull(cd.PostalAddressStreet1, '') <> '' THEN isnull(cd.postalAddressCountry, '')
               ELSE isnull(cd.country, '')
           END AS country
         , CASE
               WHEN u.user_type_id IN (101, 103, 201) THEN 0
               ELSE 1
           END AS accountClosed
         , CASE
               WHEN u.user_type_id IN (101, 103, 201) THEN NULL
               ELSE u.removed
           END AS accountClosedDate
         , cd.dob
         , isnull(c.KBCountryCode, 'NZ') AS countryCode
         , (SELECT TOP (1) vcdpe.primaryEmailAddress FROM dbo.gmi_vContactDetailsPersonEmail AS vcdpe WHERE vcdpe.contactid = cd.contactid) AS emailAddress
         , isnull(cd.homephone, '') AS homephone
         , isnull(cd.cellPhone, '') AS cellphone
         , isnull(cd.workphone, '') AS workphone
         , '0' AS homeCountryTaxFile
         , (SELECT sum(vmfbs.endUnitAmount)FROM dbo.vwMemberFundBalanceSummary AS vmfbs WHERE cd.usersid = vmfbs.memberId AND vmfbs.endDate = @endDate) AS unitsHeldAtYearEnd
    FROM 
		(
			select * from 
			(
				SELECT 
					  memberid
					, COUNT (DISTINCT MemberTax.PIR) AS numberPirUsed
				
					, sum(closingTaxableAmount) as taxableIncomeOrLoss, 
					sum(iif(PIR>0, isnull(closingFTC,0)+isnull(closingIC,0)+isnull(closingDWP,0)+isnull(closingRWT,0)-isnull(leftOverFTC,0), 0)) as taxCredits, 
					sum(taxPayable) as taxPaid, 
				
					sum(IIF(PIR IN (10.5,12.5,17.5,19.5,21), closingTaxableAmount, 0)) as taxableIncomeOrLossLowPIR, 
					sum(IIF(PIR IN (10.5,12.5,17.5,19.5,21), isnull(closingFTC,0)+isnull(closingIC,0)+isnull(closingDWP,0)+isnull(closingRWT,0)-isnull(leftOverFTC,0), 0)) as taxCreditsLowPIR, 
					sum(IIF(PIR IN (10.5,12.5,17.5,19.5,21), taxPayable,0)) as taxPaidLowPIR, 
				
					sum(IIF(PIR = 0, closingTaxableAmount, 0)) as taxableIncomeOrLossZeroRated, 
					isnull
					(
						(
							select TOP 1 mtTemp.closingFTC 
							FROM
							(
								select memberid, valuationDate, sum(closingFTC) as closingFTC
								FROM MemberTax mtTemp 
								WHERE 
									mtTemp.PIR=0 
									AND mtTemp.memberid = MemberTax.memberid 
									AND mtTemp.valuationDate IN (@quarter1, @quarter2, @quarter3, @endDate) 
								GROUP BY memberid, valuationDate
							
							) mtTemp
							order by valuationDate desc
						), 0
					) as ftc, 
					sum(IIF(PIR=0, isnull(closingDWP,0),0)) as dwp, 
					sum(IIF(PIR=0, isnull(closingIC,0), 0)) as ic, 
					sum(IIF(PIR=0, isnull(closingRWT,0), 0)) as rwt,
					sum(IIF(PIR = 0, taxPayable,0)) as ZeroRatedExitedInvestorTaxPayForExitPeriod
				
				FROM MemberTax 
				WHERE valuationDate IN (@quarter1, @quarter2, @quarter3, @endDate) 
				GROUP BY memberid 
			) mtNormal
			left join 
			(
				select 
					memberid as memberidpir0, 
					(SELECT top 1 mt.PIR FROM MemberTax mt where valuationDate = @endDate and memberid = MemberTax.memberid ) as pirAtYearEnd, 
					COUNT (DISTINCT CASE WHEN MemberTax.PIR = 0 THEN MemberTax.PIR END) AS pirEqual0
				FROM MemberTax 
				WHERE valuationDate IN (@quarter1, @quarter2, @quarter3, @endDate) 
				GROUP BY memberid 
			) mtpir0
			on mtNormal.memberid = mtpir0.memberidpir0
		) AS mtInfo 
		LEFT JOIN dbo.gmi_users AS u ON mtInfo.memberid = u.ID 
		INNER JOIN dbo.gmi_contact_details AS cd ON cd.usersid = u.ID
		LEFT JOIN dbo.customer_country AS c ON c.countryName = iif(isnull(cd.PostalAddressStreet1, '') <> '', cd.postalAddressCountry, cd.country)
    WHERE cd.[current] = 1
      AND cd.MainContact = 1
      AND u.user_type_id NOT IN (301, 302, 303, 203, 204, 303, 304) --exclude KWKS, Super, KWMF, Wholesale Clients

	(	  
		SELECT *
		FROM @memberDetails md
		where md.vehicleType = 'JOINT'
	)
	UNION
	(	  
		SELECT *
		FROM @memberDetails md
		where md.vehicleType <> 'JOINT' OR (md.vehicleType = 'JOINT' AND md.pieTaxIdentityContactId IS NULL)
	)
	ORDER by memberid 
END
