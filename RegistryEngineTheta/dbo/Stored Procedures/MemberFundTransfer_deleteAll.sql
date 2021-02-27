
create PROCEDURE [dbo].[MemberFundTransfer_deleteAll]
	@valuationDate DATE,
	@fundId INT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    DELETE FROM 
		dbo.MemberFundTransfer
	WHERE
		valuationDate=@valuationDate
		AND fundId=@fundId
END
