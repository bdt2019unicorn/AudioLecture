
CREATE PROCEDURE [dbo].[MemberFundBalance_deleteAll]
	@fundId INT,
	@endDate DATE
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

   DELETE FROM dbo.MemberFundBalance
   WHERE endDate=@endDate
	AND fundId=@fundId
END
