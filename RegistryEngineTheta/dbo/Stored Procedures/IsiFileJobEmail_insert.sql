CREATE PROCEDURE [dbo].[IsiFileJobEmail_insert]
	@isiFileJobDetailsId int,
	@receiveIsiFileContactId int,
	@receiveIsiFileContactName varchar(100),
	@relationshipType varchar(50),
	@emailAddressTo varchar(100),
	@emailSent bit,
	@dateEmailSent datetime
AS
BEGIN

	SET NOCOUNT ON;

	INSERT INTO [dbo].[IsiFileJobEmail]
    (
		[isiFileJobDetailsId],
		[receiveIsiFileContactId],
		[receiveIsiFileContactName],
		[relationshipType],
		[emailAddressTo],
		[emailSent],
		[dateEmailSent]
	)
    VALUES
    (
		@isiFileJobDetailsId,
        @receiveIsiFileContactId,
        @receiveIsiFileContactName,
        @relationshipType,
        @emailAddressTo,
        @emailSent,
		@dateEmailSent
	)

	SELECT @@ROWCOUNT As RowsInserted

END

