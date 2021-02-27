CREATE procedure [dbo].[WholesaleAnnualInvestorCertificate_selectByUserId]
	@startdate DATE, @enddate DATE, @memberId int 
as 
begin 
	SET NOCOUNT ON;
	declare @pir as table (
	  id int, 
	  foldername varchar(120), 
	  pir float
	); 
	insert into @pir 
	SELECT 
	  id, 
	  foldername, 
	  ISNULL(pirateom, currentpir) as pir 
	from 
	  (
		select 
		  id, 
		  foldername, 
		  pir as currentPir, 
		  (
			select 
			  top 1 pir 
			from 
			  gmiTestDb.dbo.UsersBackup WITH(NOLOCK) 
			where 
			  clientID = t1.id 
			  AND ISNULL(modified, added) < dateadd(day, 1, @enddate) 
			  AND backupAdded > dateadd(day, 1, @enddate) 
			order by 
			  id desc
		  ) as pirAtEom 
		from 
		  gmiTestDb.dbo.users t1 WITH(NOLOCK) 
		WHERE 
		  t1.id = @memberId
	  ) temp; 
	select 
	  a.*, 
	  p.pir 
	from 
	  (
		select 
		  memberid clientid, 
		  u.foldername, 
		  cast(mt.pieId as varchar) fundcode, 
		  f.fundname, 
		  'KIMMT' as trust, 
		  @startDate startdate, 
		  @enddate enddate, 
		  ROUND(
			SUM(taxableAmount), 
			2
		  ) taxableIncome, 
		  ROUND(0.00, 2) nonTaxableIncome, 
		  ROUND(
			SUM(ftc), 
			2
		  ) foreignTaxCredits, 
		  ROUND(
			SUM(dwp), 
			2
		  ) dividendWithholdingPayments, 
		  ROUND(
			SUM(rwt), 
			2
		  ) residentWithholdingTax, 
		  ROUND(
			SUM(ic), 
			2
		  ) imputationCredits, 
		  ROUND(
			SUM(tolAmount), 
			2
		  ) deductibleExpenses, 
		  0 formationLossesUsed, 
		  0 landLossesUsed, 
		  0 investorAccountRebates, 
		  0 investorAccountExpenses 
		from 
		  RegistryEngineTheta..MemberTax mt 
		  JOIN RegistryEngineTheta..fund f on f.fundId = mt.pieId 
		  JOIN gmiTestDb..users u ON u.id = mt.memberid 
		where 
		  mt.memberid = @memberId 
		  and mt.valuationDate between @startDate 
		  and @enddate 
		Group by 
		  memberid, 
		  u.foldername, 
		  mt.pieId, 
		  f.fundname 
		union all 
		select 
		  u.id clientid, 
		  u.foldername, 
		  a.fundcode, 
		  m.BNPFundName fundname, 
		  'KIMWMT' as trust, 
		  @startDate startdate, 
		  @enddate enddate, 
		  ROUND(
			SUM(taxableincome), 
			2
		  ) taxableincome, 
		  ROUND(
			SUM(Nontaxableincome), 
			2
		  ) nonTaxableIncome, 
		  ROUND(
			SUM(ForeignTaxCredits), 
			2
		  ) foreignTaxCredits, 
		  ROUND(
			SUM(DividendWithholdingPayments), 
			2
		  ) dividendWithholdingPayments, 
		  ROUND(
			SUM(ResidentWithholdingTax), 
			2
		  ) residentWithholdingTax, 
		  ROUND(
			SUM(ImputationCredits), 
			2
		  ) imputationCredits, 
		  ROUND(
			SUM(DeductibleExpenses), 
			2
		  ) deductibleExpenses, 
		  ROUND(
			SUM(FormationLossesUsed), 
			2
		  ) formationLossesUsed, 
		  ROUND(
			SUM(LandLossesUsed), 
			2
		  ) landLossesUsed, 
		  ROUND(
			SUM(InvestorAccountRebates), 
			2
		  ) investorAccountRebates, 
		  ROUND(
			SUM(InvestorAccountExpenses), 
			2
		  ) investorAccountExpenses 
		From 
		  bnp..ISIDataDailyAllocation a 
		  INNER JOIN gmiTestDb..users u on u.foldername = a.portfolio 
		  INNER JOIN gmiTestDb..custodianmapping m on m.BNPFundCode = a.fundCode 
		  and isCurrent = 1 
		WHERE 
		  a.fundvaluationDate BETWEEN @startDate 
		  AND @enddate 
		  AND u.id = @memberId 
		group by 
		  u.id, 
		  u.foldername, 
		  a.fundcode, 
		  m.BNPFundName
	  ) a 
	  Left join @pir p on p.id = a.clientid 
	order by 
	  clientid, 
	  fundcode
end 
