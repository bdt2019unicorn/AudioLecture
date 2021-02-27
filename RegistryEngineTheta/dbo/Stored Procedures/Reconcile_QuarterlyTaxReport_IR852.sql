--Reconcile_quarterlyTaxReport_IR852
CREATE PROCEDURE [dbo].[Reconcile_QuarterlyTaxReport_IR852]
@EOY SMALLDATETIME,
@PieId SMALLINT
AS
BEGIN
SET NOCOUNT ON;

--DECLARE @PIEID SMALLINT
--SET @PIEID = 1
Declare @Q1EndDate  smalldatetime
Declare @Q2EndDate  smalldatetime
Declare @Q3EndDate  smalldatetime
Declare @Q4EndDate  smalldatetime

Set @Q1EndDate = DATEADD(Month, -9, @EOY) --'30-06-2019'
set @Q2EndDate = DATEADD(Month, -6, @EOY) --'2019-09-30'
set @Q3EndDate = DATEADD(Month, -3, @EOY) --'2019-12-31'
set @Q4EndDate = @EOY --'2020-03-31'

DECLARE @tblQ1 TABLE (
	MemberId int null,
	Q1PIRCheck float,
	CheckQ1TaxableIncome float,
	CheckQ1ClosingTaxableAmt float,
	CheckQ1TaxPayable float,
	CheckQ1FTC float,
	CheckQ1IC float,
	CheckQ1TxPayAftCrd float
	);

	INSERT INTO @tblQ1 (
	MemberId,
	Q1PIRCheck,
	CheckQ1TaxableIncome,
	CheckQ1ClosingTaxableAmt,
	CheckQ1TaxPayable,
	CheckQ1FTC,
	CheckQ1IC,
	CheckQ1TxPayAftCrd
	)
	(
		SELECT 
			MemTax.MemberID,
			Round((MemTax.PIR - RATX.Quarter1PIR), 0) as Q1PIRCheck,
			ROUND((quarter1TotalTaxableIncome + quarter1Expenses - quarter1TaxableIncome),0) as CheckQ1TaxableIncome,
			Round((MemTax.closingTaxableAmount - RATX.quarter1TotalTaxableIncome), 0) as CheckQ1ClosingTaxableAmt,
			CASE 
				WHEN (RATX.quarter1PIR <> 0)
				THEN
					ROUND((MemTax.taxPayable + RATX.quarter1TaxPayableBeforeCredits +
						RATX.quarter1FTC + RATX.quarter1IC), 0) 
					ELSE
						ROUND((MemTax.taxPayable + RATX.quarter1TaxPayableBeforeCredits), 0) 
					END as CheckQ1TaxPayable,
			Round ((MemTax.closingFTC - RATX.quarter1FTC - MemTax.leftOverFTC), 0) as CheckQ1FTC,
			Round ((MemTax.closingIC - RATX.quarter1IC), 0) as CheckQ1IC,
			Round ((MemTax.taxPayable + RATX.quarter1TaxPayableAfterCredits), 0) as CheckQ1TxPayAftCrd
	    FROM 
		    MemberTax MemTax 
		    INNER JOIN gmi_users gmiusers ON gmiusers.id = Memtax.memberid
			inner join ReportAnnualTaxCertificate RATX on RATX.memberid = MemTax.MemberId
	    WHERE
		    MemTax.valuationDate  = @Q1EndDate --@valuationDate of first Quarter
			And RATX.Quarter1Date = @Q1EndDate and RATX.eoydate = @EOY
		    AND MemTax.pieId= @pieID AND RATX.pieId = @PIEID
			
	);

DECLARE @tblQ2 TABLE (
	MemberId int null,
	Q2PIRCheck float,
	CheckQ2TaxableIncome float,
	CheckQ2ClosingTaxableAmt float,
	CheckQ2TaxPayable float,
	CheckQ2FTC float,
	CheckQ2IC float,
	CheckQ2TxPayAftCrd float
	);

	INSERT INTO @tblQ2 (
	MemberId,
	Q2PIRCheck,
	CheckQ2TaxableIncome,
	CheckQ2ClosingTaxableAmt,
	CheckQ2TaxPayable,
	CheckQ2FTC,
	CheckQ2IC,
	CheckQ2TxPayAftCrd
	)
	(
		SELECT 
			MemTax.MemberID,
			Round((MemTax.PIR - RATX.Quarter2PIR), 0) as Q2PIRCheck,
			ROUND((quarter2TotalTaxableIncome + quarter2Expenses - quarter2TaxableIncome),0) as CheckQ2TaxableIncome,
			Round((MemTax.closingTaxableAmount - RATX.quarter2TotalTaxableIncome), 0) as CheckQ2ClosingTaxableAmt,
			CASE 
				WHEN (RATX.quarter2PIR <> 0)
				THEN
					ROUND((MemTax.taxPayable + RATX.quarter2TaxPayableBeforeCredits +
						RATX.quarter2FTC + RATX.quarter2IC), 0) 
					ELSE
						ROUND((MemTax.taxPayable + RATX.quarter2TaxPayableBeforeCredits), 0) 
					END as CheckQ2TaxPayable,
			Round ((MemTax.closingFTC - RATX.quarter2FTC - MemTax.leftOverFTC), 0) as CheckQ2FTC,
			Round ((MemTax.closingIC - RATX.quarter2IC), 0) as CheckQ2IC,
			Round ((MemTax.taxPayable + RATX.quarter2TaxPayableAfterCredits), 0) as CheckQ2TxPayAftCrd
	    FROM 
		    MemberTax MemTax 
		    INNER JOIN gmi_users gmiusers ON gmiusers.id = Memtax.memberid
			inner join ReportAnnualTaxCertificate RATX on RATX.memberid = MemTax.MemberId
	    WHERE
		    MemTax.valuationDate  = @Q2EndDate --@valuationDate of first Quarter
			And RATX.Quarter2Date = @Q2EndDate and RATX.eoydate = @EOY
		    AND MemTax.pieId= @pieID AND RATX.pieId = @PIEID
			
	);

	DECLARE @tblQ3 TABLE (
	MemberId int null,
	Q3PIRCheck float,
	CheckQ3TaxableIncome float,
	CheckQ3ClosingTaxableAmt float,
	CheckQ3TaxPayable float,
	CheckQ3FTC float,
	CheckQ3IC float,
	CheckQ3TxPayAftCrd float
	);

	INSERT INTO @tblQ3 (
	MemberId,
	Q3PIRCheck,
	CheckQ3TaxableIncome,
	CheckQ3ClosingTaxableAmt,
	CheckQ3TaxPayable,
	CheckQ3FTC,
	CheckQ3IC,
	CheckQ3TxPayAftCrd
	)
	(
		SELECT 
			MemTax.MemberID,
			ROUND((MemTax.PIR - RATX.Quarter3PIR), 0) as Q3PIRCheck,
			ROUND((quarter3TotalTaxableIncome + quarter3Expenses - quarter3TaxableIncome),0) as CheckQ3TaxableIncome,
			Round((MemTax.closingTaxableAmount - RATX.quarter3TotalTaxableIncome), 0) as CheckQ3ClosingTaxableAmt,
			CASE 
				WHEN (RATX.quarter3PIR <> 0)
				THEN
					ROUND((MemTax.taxPayable + RATX.quarter3TaxPayableBeforeCredits +
						RATX.quarter3FTC + RATX.quarter3IC), 0) 
					ELSE
						ROUND((MemTax.taxPayable + RATX.quarter3TaxPayableBeforeCredits), 0) 
					END as CheckQ3TaxPayable,
			Round ((MemTax.closingFTC - RATX.quarter3FTC - MemTax.leftOverFTC), 0) as CheckQ3FTC,
			Round ((MemTax.closingIC - RATX.quarter3IC), 0) as CheckQ3IC,
			Round ((MemTax.taxPayable + RATX.quarter3TaxPayableAfterCredits), 0) as CheckQ3TxPayAftCrd
	    FROM 
		    MemberTax MemTax 
		    INNER JOIN gmi_users gmiusers ON gmiusers.id = Memtax.memberid
			inner join ReportAnnualTaxCertificate RATX on RATX.memberid = MemTax.MemberId
	    WHERE
		    MemTax.valuationDate  = @Q3EndDate --@valuationDate of first Quarter
			And RATX.Quarter3Date = @Q3EndDate and RATX.eoydate = @EOY
		    AND MemTax.pieId= @pieID AND RATX.pieId = @PIEID
			
	);

DECLARE @tblQ4 TABLE (
	MemberId int null,
	Q4PIRCheck float,
	CheckQ4TaxableIncome float,
	CheckQ4ClosingTaxableAmt float,
	CheckQ4TaxPayable float,
	CheckQ4FTC float,
	CheckQ4IC float,
	CheckQ4TxPayAftCrd float
	);

	INSERT INTO @tblQ4 (
	MemberId,
	Q4PIRCheck,
	CheckQ4TaxableIncome,
	CheckQ4ClosingTaxableAmt,
	CheckQ4TaxPayable,
	CheckQ4FTC,
	CheckQ4IC,
	CheckQ4TxPayAftCrd
	)
	(
		SELECT 
			MemTax.MemberID,
			ROUND((MemTax.PIR - RATX.Quarter4PIR), 0) as Q4PIRCheck,
			ROUND((quarter4TotalTaxableIncome + quarter4Expenses - quarter4TaxableIncome),0) as CheckQ4TaxableIncome,
			Round((MemTax.closingTaxableAmount - RATX.quarter4TotalTaxableIncome), 0) as CheckQ4ClosingTaxableAmt,
			CASE 
				WHEN (RATX.quarter4PIR <> 0)
				THEN
					ROUND((MemTax.taxPayable + RATX.quarter4TaxPayableBeforeCredits +
						RATX.quarter4FTC + RATX.quarter4IC), 0) 
					ELSE
						ROUND((MemTax.taxPayable + RATX.quarter4TaxPayableBeforeCredits), 0) 
					END as CheckQ4TaxPayable,
			Round ((MemTax.closingFTC - RATX.quarter4FTC - MemTax.leftOverFTC), 0) as CheckQ4FTC,
			Round ((MemTax.closingIC - RATX.quarter4IC), 0) as CheckQ4IC,
			Round ((MemTax.taxPayable + RATX.quarter4TaxPayableAfterCredits), 0) as CheckQ4TxPayAftCrd
	    FROM 
		    MemberTax MemTax 
		    INNER JOIN gmi_users gmiusers ON gmiusers.id = Memtax.memberid
			inner join ReportAnnualTaxCertificate RATX on RATX.memberid = MemTax.MemberId
	    WHERE
		    MemTax.valuationDate  = @Q4EndDate --@valuationDate of first Quarter
			And RATX.Quarter4Date = @Q4EndDate and RATX.eoydate = @EOY
		    AND MemTax.pieId= @pieID AND RATX.pieId = @PIEID			
	);

	Select tQ1.MemberId, Q1PIRCheck, CheckQ1TaxableIncome, CheckQ1ClosingTaxableAmt, CheckQ1TaxPayable, CheckQ1FTC, CheckQ1IC, CheckQ1TxPayAftCrd,
			Q2PIRCheck, CheckQ2TaxableIncome, CheckQ2ClosingTaxableAmt, CheckQ2TaxPayable, CheckQ2FTC, CheckQ2IC, CheckQ2TxPayAftCrd,
			Q3PIRCheck, CheckQ3TaxableIncome, CheckQ3ClosingTaxableAmt, CheckQ3TaxPayable, CheckQ3FTC, CheckQ3IC, CheckQ3TxPayAftCrd,
			Q4PIRCheck, CheckQ4TaxableIncome, CheckQ4ClosingTaxableAmt, CheckQ4TaxPayable, CheckQ4FTC, CheckQ4IC, CheckQ4TxPayAftCrd
			from @tblQ1 tQ1
		inner join @tblQ2 tQ2 on tQ1.MemberId = tQ2.MemberId
		inner join @tblQ3 tQ3 on tQ2.MemberId = tQ3.MemberId
		inner join @tblQ4 tQ4 on tQ4.MemberId = tQ3.MemberId
		where (Q1PIRCheck <> 0 or CheckQ1TaxableIncome <> 0 or CheckQ1ClosingTaxableAmt <> 0 or CheckQ1TaxPayable <> 0 or CheckQ1FTC <> 0 or CheckQ1IC <> 0 or CheckQ1TxPayAftCrd <> 0) or
				(Q2PIRCheck <> 0 or CheckQ2TaxableIncome <> 0 or CheckQ2ClosingTaxableAmt <> 0 or CheckQ2TaxPayable <> 0 or CheckQ2FTC <> 0 or CheckQ2IC <> 0 or CheckQ2TxPayAftCrd <> 0) or
				(Q3PIRCheck <> 0 or CheckQ3TaxableIncome <> 0 or CheckQ3ClosingTaxableAmt <> 0 or CheckQ3TaxPayable <> 0 or CheckQ3FTC <> 0 or CheckQ3IC <> 0 or CheckQ3TxPayAftCrd <> 0) or
				(Q4PIRCheck <> 0 or CheckQ4TaxableIncome <> 0 or CheckQ4ClosingTaxableAmt <> 0 or CheckQ4TaxPayable <> 0 or CheckQ4FTC <> 0 or CheckQ4IC <> 0 or CheckQ4TxPayAftCrd <> 0) 
	order by tQ1.MemberId

	END
