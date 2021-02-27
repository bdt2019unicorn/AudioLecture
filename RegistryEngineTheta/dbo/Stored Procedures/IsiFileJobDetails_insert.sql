CREATE PROCEDURE [dbo].[IsiFileJobDetails_insert]
(
	@isiFileJobId int,
	@investorId int,
	@investorName varchar(100),
	@folderName varchar(50), 
	@isiFilePath varchar(255), 
	@isiFileName varchar(100), 
	@isiFileFundCount int
)

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	INSERT INTO dbo.IsiFileJobDetails
	(
		isiFileJobId,
		investorId,
		investorName,
		folderName,
		isiFilePath,
		isiFileName,
		isiFileFundCount,
		dateAdded
	)
	VALUES
	(
		@isiFileJobId,
		@investorId,
		@investorName,
		@folderName,
		@isiFilePath, 
		@isiFileName, 
		@isiFileFundCount,
		GETDATE()
	)

	SELECT SCOPE_IDENTITY() As isiFileJobDetailsId
END

