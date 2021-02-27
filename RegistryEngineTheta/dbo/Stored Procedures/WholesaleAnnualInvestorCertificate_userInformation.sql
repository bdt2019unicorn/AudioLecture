CREATE procedure [dbo].[WholesaleAnnualInvestorCertificate_userInformation] 
	@clientId int, @reportEndDate date = null 
as 
	
begin 
	set @reportEndDate = iIF(@reportEndDate is null, DATEADD(dd, -1, DATEADD(qq, DATEDIFF(qq, 0, GETDATE()), 0)), @reportEndDate); 
	select ID as clientId, Client as clientName, IRD as irdNumber, PIR as pir, FORMAT(getdate(), 'dd-MMMM-yyyy') as reportGenerated, FORMAT(@reportEndDate, 'dd MMMM yyyy') as reportEndDate
	FROM gmi_users
	WHERE ID = @clientId; 
end 

