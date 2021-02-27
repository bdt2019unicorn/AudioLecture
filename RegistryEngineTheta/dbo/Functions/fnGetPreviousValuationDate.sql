
-- User Defined Function

-- =============================================
-- Author:		Dave
-- Create date: 28 Aug 2013
-- =============================================
CREATE FUNCTION [dbo].[fnGetPreviousValuationDate]
(
	-- Add the parameters for the function here
	@currentValuationDate SMALLDATETIME
)
RETURNS	SMALLDATETIME 
AS
BEGIN
	DECLARE @rtn SMALLDATETIME

	SELECT TOP 1
		@rtn=valuationDate
	FROM 
		dbo.ValuationPeriod
	WHERE
		valuationDate<@currentValuationDate
	ORDER BY
		valuationDate DESC

	-- Return the result of the function
	RETURN @rtn

END

