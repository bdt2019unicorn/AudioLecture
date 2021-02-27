
CREATE PROCEDURE [dbo].[Member_selectAllForTaxAllocation]
	@valuationDate DATE,
	@pieId INT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;


	DECLARE @prevValuationDate DATE = dbo.fnGetPreviousValuationDate(@valuationDate)
	DECLARE @registryVersionId INTEGER = (SELECT registryVersionId FROM pie WHERE pieid=@pieId)

	IF @registryVersionId=1
	BEGIN

		  select 
			--id,
			--foldername,
			--ISNULL(pirateom,currentpir) as pir,
			--irdNumber
			*,
			CAST((CASE WHEN results1.selectedPiePir IS NOT NULL THEN results1.selectedPiePir ELSE ISNULL(pirAtValuation,currentpir) END) AS DECIMAL(18,4)) AS pir
		from (
			select id, 
				foldername,
				t1.IRD AS irdNumber,
				pir as currentPir,
				(select top 1 pir from gmi_UsersBackup WITH(NOLOCK)
				where clientID=t1.id AND ISNULL(modified,added) <dateadd(day,1,@valuationDate) AND backupAdded >dateadd(day,1,@valuationDate) order by id desc
				) as pirAtValuation,
				(SELECT TOP 1 pir FROM gmi_PieClientSpecifiedPir
				WHERE 
					effectiveDate<=@valuationDate AND (isActive=1 OR endDate>@valuationDate)
					AND clientId=t1.id
					AND pieId=@pieId
				) selectedPiePir

			from gmi_users t1 WITH(NOLOCK)
			where id in (
					SELECT DISTINCT memberid
				FROM 
					dbo.MemberFundBalance b
					INNER JOIN dbo.Fund f ON f.fundId = b.fundId
				WHERE endDate<=@valuationDate
					AND f.pieid=@pieId
			)
			OR id IN (
				SELECT distinct 
					memberid 
				FROM 
					MemberTax WITH(NOLOCK) 
				WHERE 
					valuationDate=@prevValuationDate 
					AND closingTaxableAmount<>0 
					AND pieId=@pieId

			)
	) as results1
	order by id








	end






 --  SELECT
	--	u.id,
	--	u.foldername,
	--	u.pir,
	--	u.ird AS irdNumber

	--FROM gmi.dbo.users u
	--WHERE 
	--	id IN (
	--		SELECT DISTINCT memberid
	--		FROM 
	--			dbo.AccountBalance
	--		WHERE valuationDate<=@valuationDate
	--			AND accountId=@pieId
	--	)
	--ORDER BY
	--	u.id
END
