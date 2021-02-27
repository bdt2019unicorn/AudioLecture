
CREATE PROCEDURE [dbo].[TaxQuarterSummary_select]
	@quarterDate DATE,
	@pieId INT =1

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT 
		* 
	FROM 
		TaxQuarterSummary 
	WHERE
		quarterDate=@quarterDate
		AND pieId=@pieId

END
