-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[ReportIR854InvestorCertificate_selectAllJointChildrenData] @eoyDate date
AS
BEGIN
    DECLARE @startDate date = dateadd(DAY, 1, dateadd(YEAR, -1, @eoyDate));
    SELECT cd.usersid AS memberid
         , cd.contactid
         , isnull(cd.firstNames, '') AS firstNames
         , isnull(cd.middleNames, '') AS middleNames
         , isnull(cd.surname, '') AS surname
         , convert(varchar(50), cd.irdNumber) AS irNumber
         , cd.dob AS dob
         , CASE
               WHEN isnull(cd.PostalAddressStreet1, '') <> '' THEN isnull(cd.PostalAddressStreet1, '')
               ELSE isnull(cd.street, '')
           END AS street
         , CASE
               WHEN isnull(cd.PostalAddressStreet1, '') <> '' THEN isnull(cd.PostalAddressStreet2, '')
               ELSE isnull(cd.street2, '')
           END AS street2
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
         , isnull(c.KBCountryCode, 'NZ') AS countryCode -- ISO3166-2
         , isnull(vcdpe.primaryEmailAddress, '') AS emailAddress
         , isnull(cd.homephone, '') AS homephone
         , isnull(cd.cellPhone, '') AS cellphone
         , isnull(cd.workphone, '') AS workphone
         , '0' AS homeCountryTaxFile
    FROM dbo.gmi_contact_details AS cd
    LEFT JOIN dbo.gmi_vContactDetailsPersonEmail AS vcdpe ON vcdpe.contactid = cd.contactid
    LEFT JOIN dbo.customer_country AS c ON c.countryName = iif(isnull(cd.PostalAddressStreet1, '') <> '', cd.postalAddressCountry, cd.country)
    WHERE cd.usersid IN (SELECT DISTINCT memberid FROM dbo.MemberTax WHERE valuationDate BETWEEN @startDate AND @eoyDate)
      AND cd.MainContact = 0
      AND cd.legalstatus = 'JOINT'
      AND cd.accountant = 0
END
