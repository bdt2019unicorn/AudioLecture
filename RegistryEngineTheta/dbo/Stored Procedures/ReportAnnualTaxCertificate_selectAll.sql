create PROCEDURE [dbo].[ReportAnnualTaxCertificate_selectAll]
	-- Add the parameters for the stored procedure here
	@date as date
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT 
		t1.*,
		t1.quarter4PIR AS annualPIR,
		t1.quarter1TaxableIncome + t1.quarter2TaxableIncome + t1.quarter3TaxableIncome + t1.quarter4TaxableIncome AS annualTaxableIncome,
		t1.quarter1Expenses + t1.quarter2Expenses + t1.quarter3Expenses + t1.quarter4Expenses AS annualExpenses,
		t1.quarter1TotalTaxableIncome + t1.quarter2TotalTaxableIncome + t1.quarter3TotalTaxableIncome + t1.quarter4TotalTaxableIncome AS annualTotalTaxableIncome,
		t1.quarter1TaxPayableBeforeCredits + t1.quarter2TaxPayableBeforeCredits + t1.quarter3TaxPayableBeforeCredits + t1.quarter4TaxPayableBeforeCredits AS annualTaxPayableBeforeCredits,
		t1.quarter1TaxPayableAfterCredits + t1.quarter2TaxPayableAfterCredits + t1.quarter3TaxPayableAfterCredits + t1.quarter4TaxPayableAfterCredits AS annualTaxPayableAfterCredits,
		t1.quarter1FTC + t1.quarter2FTC + t1.quarter3FTC + t1.quarter4FTC AS annualFTC,
		t1.quarter1IC + t1.quarter2IC + t1.quarter3IC + t1.quarter4IC AS annualIC,
		t1.quarter1DWP + t1.quarter2DWP + t1.quarter3DWP + t1.quarter4DWP  AS annualDWP ,
		t1.quarter1RWT + t1.quarter2RWT + t1.quarter3RWT + t1.quarter4RWT AS annualRWT,
		t1.quarter1TaxCredits + t1.quarter2TaxCredits + t1.quarter3TaxCredits + t1.quarter4TaxCredits AS annualTaxCredits
	FROM 
		dbo.ReportAnnualTaxCertificate AS t1
	WHERE 
		 t1.EOYDate = @date
	ORDER BY
		t1.memberName
	
END
