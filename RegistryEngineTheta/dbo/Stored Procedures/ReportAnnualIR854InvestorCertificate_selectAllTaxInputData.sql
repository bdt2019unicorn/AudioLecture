-- =============================================
-- Author:		Dave
-- Create date: 12 May 2011
-- Description:	returns the data for the IR854 returns
-- =============================================
CREATE PROCEDURE [dbo].[ReportAnnualIR854InvestorCertificate_selectAllTaxInputData]
	@year int,
	@pirType INT --1=all, 2=mid, 3=zero rated
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	declare @quarter1 date = '30 June ' + cast(@year-1 as varchar(4))
	declare @quarter2 date = '30 Sep ' + cast(@year-1 as varchar(4))
	declare @quarter3 date = '31 Dec ' + cast(@year-1 as varchar(4))
	declare @quarter4 date = '31 Mar ' + cast(@year as varchar(4))
	
	if @pirType=1 
	BEGIN

		SELECT t1.memberid, sum(closingTaxableAmount) as 'taxableIncome', 
			sum(isnull(closingFTC,0)+isnull(closingIC,0)+isnull(closingDWP,0)+isnull(closingRWT,0)-isnull(leftOverFTC,0)) as 'taxCredits', 
			sum(isnull(closingFTC,0)-isnull(leftOverFTC,0)) as 'ftc', 
			sum(isnull(closingDWP,0)) as 'dwp', 
			sum(+isnull(closingIC,0)) as 'ic', 
			sum(isnull(closingRWT,0)) as 'rwt', 
			sum(taxPayable) as 'taxPayable'
		FROM MemberTax t1
			--inner join Member t2 on t2.id=t1.memberid
		WHERE valuationDate in (@quarter1,@quarter2,@quarter3,@quarter4)
		group by 
			t1.memberid
		order by 
			t1.memberid
	end
	else IF @pirType=2 
	BEGIN --if low PIR rates only
		SELECT t1.memberid, sum(closingTaxableAmount) as 'taxableIncome', 
			sum(isnull(closingFTC,0)+isnull(closingIC,0)+isnull(closingDWP,0)+isnull(closingRWT,0)-isnull(leftOverFTC,0)) as 'taxCredits', 
			sum(isnull(closingFTC,0)-isnull(leftOverFTC,0)) as 'ftc', 
			sum(isnull(closingDWP,0)) as 'dwp', 
			sum(+isnull(closingIC,0)) as 'ic', 
			sum(isnull(closingRWT,0)) as 'rwt', 
			sum(taxPayable) as 'taxPayable'
		FROM MemberTax t1
		--	inner join Member t2 on t2.id=t1.memberid
		WHERE valuationDate in (@quarter1,@quarter2,@quarter3,@quarter4)
			  and t1.pir in (10.5,12.5,17.5,19.5,21)
		group by 
			t1.memberid
		order by 
			t1.memberid
	END
	else --zero rated
	BEGIN --if low PIR rates only
		SELECT t1.memberid, sum(closingTaxableAmount) as 'taxableIncome', 
			sum(isnull(closingFTC,0)+isnull(closingIC,0)+isnull(closingDWP,0)+isnull(closingRWT,0)) as 'taxCredits', --isnull(leftOverFTC,0)
			sum(isnull(closingFTC,0)) as 'ftc', ---isnull(leftOverFTC,0)
			sum(isnull(closingDWP,0)) as 'dwp', 
			sum(+isnull(closingIC,0)) as 'ic', 
			sum(isnull(closingRWT,0)) as 'rwt', 
			sum(taxPayable) as 'taxPayable'
		FROM MemberTax t1
		--	inner join Member t2 on t2.id=t1.memberid
		WHERE valuationDate in (@quarter1,@quarter2,@quarter3,@quarter4)
			  and t1.pir in (0)
		group by 
			t1.memberid
		order by 
			t1.memberid
	END
END
