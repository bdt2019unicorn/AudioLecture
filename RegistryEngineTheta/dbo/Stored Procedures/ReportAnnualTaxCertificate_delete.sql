
CREATE PROCEDURE [dbo].[ReportAnnualTaxCertificate_delete]
	@eoyDate DATE,
	@pieId INT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	DELETE
	FROM 
		dbo.ReportAnnualTaxCertificate
	WHERE 
		EOYDate = @eoyDate
		AND pieId=@pieId

	SELECT @@RowCount As RowsDeleted

END
