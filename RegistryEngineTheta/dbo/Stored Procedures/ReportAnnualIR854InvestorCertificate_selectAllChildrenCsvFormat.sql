-- =============================================
-- Author:		<Binh>
-- Create date: <4 Feb 2021>
-- Description:	<Get all the child investor in IR854 reports in PieBox>
-- =============================================
CREATE PROCEDURE [dbo].[ReportAnnualIR854InvestorCertificate_selectAllChildrenCsvFormat]
    @eoyDate date
AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON;
	SELECT
      memberid
      , periodEndDate
      , name
      , irNumber
      , dob
      , contactAddress
      , countryCode
      , emailAddress
      ,phoneNumber
  FROM ReportAnnualIR854InvestorCertificateJoint
  WHERE periodEndDate = @eoyDate 

END
