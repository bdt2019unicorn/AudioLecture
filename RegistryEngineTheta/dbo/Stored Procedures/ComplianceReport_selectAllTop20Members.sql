-- =============================================
-- Author:		Dave
-- Create date: 20 Apr 15
-- =============================================
create PROCEDURE [dbo].[ComplianceReport_selectAllTop20Members]
	@date DATE 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;


	
	DECLARE @top20 TABLE
	(
		valuationDate date,
		memberId int,
		InvestmentDirectionId INT,
		InvestmentDirectionName VARCHAR(20),
		memberDollarAmount DECIMAL(18,2),
		fundTotalDollarAmount DECIMAL(18,2),
		fundTotalMemberNumber INT
	)

	--FI Pie
	INSERT INTO @top20
	( 
		valuationDate ,
		memberId ,
		InvestmentDirectionId,
		InvestmentDirectionName ,
		memberDollarAmount ,
		fundTotalDollarAmount ,
		fundTotalMemberNumber
	)
	SELECT TOP 20
		t1.endDate,
		t1.memberid,
		1,
		'Fi Pie',
		t1.endUnitAmount*fb.endUnitPrice AS memberDollarAmount,
	
		t2.fundTotalDollarAmount,
		t2.fundTotalMemberNumber
	FROM 
		dbo.MemberFundBalance t1
		INNER JOIN FundBalance fb ON fb.fundId = t1.fundId AND fb.endDate = t1.endDate
		inner JOIN (
			SELECT 
				tt1.endDate,
				SUM(tt1.endUnitAmount*endUnitPrice) AS fundTotalDollarAmount,
				COUNT(1) AS fundTotalMemberNumber
			FROM 
				dbo.MemberFundBalance tt1
				INNER JOIN FundBalance ON FundBalance.fundId = tt1.fundId AND FundBalance.endDate = tt1.endDate
			WHERE
				tt1.endDate=@date
				AND tt1.endUnitAmount<>0
				AND tt1.fundid=1
			GROUP BY
				tt1.endDate
		) t2 ON t2.endDate=t1.endDate
	WHERE
		t1.endDate=@date
		AND t1.endUnitAmount<>0
		AND t1.fundid=1
	ORDER BY 
		t1.endUnitAmount DESC

	--Growth Pie
	INSERT INTO @top20
	( 
		valuationDate ,
		memberId ,
		InvestmentDirectionId,
		InvestmentDirectionName ,
		memberDollarAmount ,
		fundTotalDollarAmount ,
		fundTotalMemberNumber
	)
	SELECT TOP 20
		t1.endDate,
		t1.memberid,
		2,
		'Growth Pie',
		t1.endUnitAmount*fb.endUnitPrice AS memberDollarAmount,
	
		t2.fundTotalDollarAmount,
		t2.fundTotalMemberNumber
	FROM 
		dbo.MemberFundBalance t1
		INNER JOIN FundBalance fb ON fb.fundId = t1.fundId AND fb.endDate = t1.endDate
		inner JOIN (
			SELECT 
				tt1.endDate,
				SUM(tt1.endUnitAmount*endUnitPrice) AS fundTotalDollarAmount,
				COUNT(1) AS fundTotalMemberNumber
			FROM 
				dbo.MemberFundBalance tt1
				INNER JOIN FundBalance ON FundBalance.fundId = tt1.fundId AND FundBalance.endDate = tt1.endDate
			WHERE
				tt1.endDate=@date
				AND tt1.endUnitAmount<>0
				AND tt1.fundid=2
			GROUP BY
				tt1.endDate
		) t2 ON t2.endDate=t1.endDate
	WHERE
		t1.endDate=@date
		AND t1.endUnitAmount<>0
		AND t1.fundid=2
	ORDER BY 
		t1.endUnitAmount DESC


	--return the list
	SELECT 
		valuationDate,
		[@top20].InvestmentDirectionName,
		u.client AS memberName,
		memberid,
		[@top20].memberDollarAmount,
		[@top20].memberDollarAmount/[@top20].fundTotalDollarAmount AS percentageHolding,
		[@top20].fundTotalDollarAmount,
		[@top20].fundTotalMemberNumber
	FROM 
		@top20
		INNER JOIN gmi_users u ON u.id=[@top20].memberId
	ORDER BY
		[@top20].InvestmentDirectionId,
		[@top20].memberDollarAmount desc



END
