
-- ===================================================================
-- Author:		Jason
-- Create date: 18/6/2019
-- Description:	Procedure sums daily (KIMWMT) and weekly (KWMT) taxable components from each database and provide these totals. 
-- ===================================================================

CREATE PROCEDURE [dbo].[ISITaxComponentsPTD_select]

	@startdate DATE, 
	@enddate DATE, 
	@clientid int 

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

------------------------------------------- KW (GMI) REGISTRY ----------------------------------------------------------------------------
select 
@clientid clientid,
cast(mt.pieId as varchar) fundcode,
f.fundname,
'KIMMT' as trust,
@startDate startdate,
@enddate enddate,
ROUND(SUM(taxableAmount),2) taxableIncome,
ROUND(0.00,2) nonTaxableIncome,
ROUND(SUM(ftc),2) foreignTaxCredits,
ROUND(SUM(dwp),2) dividendWithholdingPayments,
ROUND(SUM(rwt),2) residentWithholdingTax,
ROUND(SUM(ic),2) imputationCredits,
ROUND(SUM(tolAmount),2) deductibleExpenses,
0 formationLossesUsed,
0 landLossesUsed,
0 investorAccountRebates,
0 investorAccountExpenses

 from MemberTax mt 
 JOIN fund f on f.fundId = mt.pieId

 where mt.memberid = @clientid
 and mt.valuationDate between @startDate and @enddate
 Group by memberid,mt.pieId,f.fundname

 union all
---------------------------------------------------------- BNP ISI DATA START------------------------------------------------------------------------------------------------------------------

select 
u.id clientid,
a.fundcode,
m.BNPFundName fundname,
'KIMWMT' as trust,
@startDate startdate,
@enddate enddate,
ROUND(SUM(taxableincome),2)  taxableincome,
ROUND(SUM(Nontaxableincome),2) nonTaxableIncome,
ROUND(SUM(ForeignTaxCredits),2) foreignTaxCredits,
ROUND(SUM(DividendWithholdingPayments),2) dividendWithholdingPayments,
ROUND(SUM(ResidentWithholdingTax),2) residentWithholdingTax,
ROUND(SUM(ImputationCredits),2) imputationCredits,
ROUND(SUM(DeductibleExpenses),2) deductibleExpenses,
ROUND(SUM(FormationLossesUsed),2) formationLossesUsed,
ROUND(SUM(LandLossesUsed),2) landLossesUsed,
ROUND(SUM(InvestorAccountRebates),2) investorAccountRebates,
ROUND(SUM(InvestorAccountExpenses),2) investorAccountExpenses

From bnp_ISIDataDailyAllocation a
INNER JOIN gmi_users u on u.foldername = a.portfolio
INNER JOIN gmi_custodianmapping m on m.BNPFundCode = a.fundCode and isCurrent = 1 --and BNPFundCode <> ''
WHERE a.fundvaluationDate BETWEEN @startDate AND @enddate AND
 u.id = @clientid
group by u.id,a.fundcode,m.BNPFundName


END

