create PROCEDURE [dbo].[ValuationPeriod_update] 
	@valuationDate DATE,
	@isPublic bit
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	Update
		ValuationPeriod
	SET 
		isPublic=@isPublic
	WHERE
		valuationDate=@valuationDate
	
END

